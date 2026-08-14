//
//  WaveformCache.swift
//  SimplePlay
//

import AVFoundation
import Foundation

/// Generates downsampled peak data for waveform rendering with chunked IO and disk cache.
actor WaveformCache {
    static let shared = WaveformCache()

    private var memoryCache: [String: [Float]] = [:]
    private let maxConcurrentJobs = 2
    private var activeJobs = 0
    private var waiters: [CheckedContinuation<Void, Never>] = []

    private var cacheDirectory: URL {
        let base = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        let directory = base.appendingPathComponent("SimplePlay/WaveformCache", isDirectory: true)
        try? FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
        return directory
    }

    func isCached(
        for url: URL,
        sourceOffset: TimeInterval = 0,
        duration: TimeInterval? = nil,
        sampleCount: Int = 240
    ) -> Bool {
        let key = cacheKey(
            url: url,
            sampleCount: sampleCount,
            sourceOffset: sourceOffset,
            duration: duration
        )
        if memoryCache[key] != nil { return true }
        return loadFromDisk(key: key) != nil
    }

    func peaks(
        for url: URL,
        sourceOffset: TimeInterval = 0,
        duration: TimeInterval? = nil,
        sampleCount: Int = 240,
        onProgress: (@MainActor @Sendable (Double) -> Void)? = nil
    ) async throws -> [Float] {
        let key = cacheKey(
            url: url,
            sampleCount: sampleCount,
            sourceOffset: sourceOffset,
            duration: duration
        )

        if let cached = memoryCache[key] {
            reportProgress(1, to: onProgress)
            return cached
        }

        if let diskCached = loadFromDisk(key: key) {
            memoryCache[key] = diskCached
            reportProgress(1, to: onProgress)
            return diskCached
        }

        await acquireSlot()
        defer { releaseSlot() }

        if let cached = memoryCache[key] {
            reportProgress(1, to: onProgress)
            return cached
        }

        reportProgress(0, to: onProgress)

        let peaks: [Float]
        if let filePeaks = try? await peaksFromAudioFileChunked(
            url: url,
            sampleCount: sampleCount,
            sourceOffset: sourceOffset,
            duration: duration,
            onProgress: onProgress
        ), !filePeaks.isEmpty {
            peaks = normalize(filePeaks)
        } else if let assetPeaks = try? await peaksFromAssetLimited(
            url: url,
            sampleCount: sampleCount,
            sourceOffset: sourceOffset,
            duration: duration,
            onProgress: onProgress
        ), !assetPeaks.isEmpty {
            peaks = normalize(assetPeaks)
        } else {
            reportProgress(1, to: onProgress)
            return []
        }

        memoryCache[key] = peaks
        saveToDisk(peaks: peaks, key: key)
        reportProgress(1, to: onProgress)

        return peaks
    }

    private func reportProgress(_ value: Double, to handler: (@MainActor @Sendable (Double) -> Void)?) {
        guard let handler else { return }
        Task { @MainActor in
            handler(value)
        }
    }

    private func acquireSlot() async {
        if activeJobs < maxConcurrentJobs {
            activeJobs += 1
            return
        }

        await withCheckedContinuation { continuation in
            waiters.append(continuation)
        }
        activeJobs += 1
    }

    private func releaseSlot() {
        activeJobs = max(0, activeJobs - 1)
        if !waiters.isEmpty, activeJobs < maxConcurrentJobs {
            let waiter = waiters.removeFirst()
            waiter.resume()
        }
    }

    private func cacheKey(
        url: URL,
        sampleCount: Int,
        sourceOffset: TimeInterval,
        duration: TimeInterval?
    ) -> String {
        let attributes = (try? FileManager.default.attributesOfItem(atPath: url.path)) ?? [:]
        let size = attributes[.size] as? NSNumber
        let modified = attributes[.modificationDate] as? Date
        let region = duration.map { "\(sourceOffset)|\($0)" } ?? "full"
        let fingerprint = "\(url.path)|\(size?.intValue ?? 0)|\(modified?.timeIntervalSince1970 ?? 0)|\(sampleCount)|\(region)"
        return fingerprint.data(using: .utf8)?.base64EncodedString() ?? url.lastPathComponent
    }

    private func diskURL(for key: String) -> URL {
        cacheDirectory.appendingPathComponent(key).appendingPathExtension("wfc")
    }

    private func loadFromDisk(key: String) -> [Float]? {
        let url = diskURL(for: key)
        guard let data = try? Data(contentsOf: url), data.count >= 4 else { return nil }
        let count = data.count / MemoryLayout<Float>.size
        return data.withUnsafeBytes { raw in
            let buffer = raw.bindMemory(to: Float.self)
            return Array(buffer.prefix(count))
        }
    }

    private func saveToDisk(peaks: [Float], key: String) {
        var values = peaks
        let data = Data(bytes: &values, count: values.count * MemoryLayout<Float>.size)
        try? data.write(to: diskURL(for: key), options: .atomic)
    }

    private func normalize(_ peaks: [Float]) -> [Float] {
        guard let maxPeak = peaks.max(), maxPeak > 0 else { return peaks }
        return peaks.map { min(1, $0 / maxPeak) }
    }

    /// Reads only the frames needed per bucket instead of loading the entire file.
    private func peaksFromAudioFileChunked(
        url: URL,
        sampleCount: Int,
        sourceOffset: TimeInterval = 0,
        duration: TimeInterval? = nil,
        onProgress: (@MainActor (Double) -> Void)? = nil
    ) async throws -> [Float] {
        let file = try AVAudioFile(forReading: url)
        let format = file.processingFormat
        let sampleRate = format.sampleRate
        guard sampleRate > 0 else { return [] }

        let totalFrames = Int(file.length)
        guard totalFrames > 0 else { return [] }

        let regionStartFrame: Int
        let regionEndFrame: Int
        if let duration {
            regionStartFrame = min(totalFrames, max(0, Int(sourceOffset * sampleRate)))
            regionEndFrame = min(
                totalFrames,
                max(regionStartFrame + 1, Int((sourceOffset + duration) * sampleRate))
            )
        } else {
            regionStartFrame = 0
            regionEndFrame = totalFrames
        }

        let regionFrames = regionEndFrame - regionStartFrame
        guard regionFrames > 0 else { return [] }

        let bucketSize = max(1, regionFrames / sampleCount)
        var peaks: [Float] = []
        peaks.reserveCapacity(sampleCount)

        for bucket in 0..<sampleCount {
            let startFrame = AVAudioFramePosition(regionStartFrame + bucket * bucketSize)
            guard startFrame < regionEndFrame else { break }

            let framesToRead = AVAudioFrameCount(
                min(bucketSize, regionEndFrame - Int(startFrame))
            )
            guard framesToRead > 0,
                  let buffer = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: framesToRead)
            else { continue }

            file.framePosition = startFrame
            try file.read(into: buffer, frameCount: framesToRead)

            guard let channelData = buffer.floatChannelData?[0] else {
                peaks.append(0)
                continue
            }

            var peak: Float = 0
            for frame in 0..<Int(buffer.frameLength) {
                peak = max(peak, abs(channelData[frame]))
            }
            peaks.append(peak)

            if let onProgress, bucket.isMultiple(of: 2) || bucket == sampleCount - 1 {
                let progress = Double(bucket + 1) / Double(sampleCount)
                reportProgress(progress, to: onProgress)
            }
        }

        return peaks
    }

    private func peaksFromAssetLimited(
        url: URL,
        sampleCount: Int,
        sourceOffset: TimeInterval = 0,
        duration: TimeInterval? = nil,
        onProgress: (@MainActor (Double) -> Void)? = nil
    ) async throws -> [Float] {
        let asset = AVURLAsset(url: url)
        guard let track = try await asset.loadTracks(withMediaType: .audio).first else {
            return []
        }

        let assetDuration = try await asset.load(.duration).seconds
        let regionStart = max(0, sourceOffset)
        let regionDuration = duration ?? max(0, assetDuration - regionStart)
        guard regionDuration > 0 else { return [] }

        let reader = try AVAssetReader(asset: asset)
        reader.timeRange = CMTimeRange(
            start: CMTime(seconds: regionStart, preferredTimescale: 44100),
            duration: CMTime(seconds: regionDuration, preferredTimescale: 44100)
        )
        let outputSettings: [String: Any] = [
            AVFormatIDKey: kAudioFormatLinearPCM,
            AVLinearPCMIsFloatKey: true,
            AVLinearPCMBitDepthKey: 32,
            AVLinearPCMIsNonInterleaved: false
        ]

        let output = AVAssetReaderTrackOutput(track: track, outputSettings: outputSettings)
        reader.add(output)
        guard reader.startReading() else { return [] }

        var peaks: [Float] = []
        peaks.reserveCapacity(sampleCount)
        var sampleCounter = 0
        let samplesPerBucket = 4096

        while reader.status == .reading, peaks.count < sampleCount {
            guard let sampleBuffer = output.copyNextSampleBuffer(),
                  let blockBuffer = CMSampleBufferGetDataBuffer(sampleBuffer) else {
                continue
            }

            let length = CMBlockBufferGetDataLength(blockBuffer)
            var data = Data(count: length)
            _ = data.withUnsafeMutableBytes { pointer in
                CMBlockBufferCopyDataBytes(blockBuffer, atOffset: 0, dataLength: length, destination: pointer.baseAddress!)
            }

            var bucketPeak: Float = peaks.last ?? 0
            let peakCountBefore = peaks.count
            data.withUnsafeBytes { rawBuffer in
                let floatBuffer = rawBuffer.bindMemory(to: Float.self)
                for sample in floatBuffer {
                    bucketPeak = max(bucketPeak, abs(sample))
                    sampleCounter += 1
                    if sampleCounter >= samplesPerBucket {
                        peaks.append(bucketPeak)
                        bucketPeak = 0
                        sampleCounter = 0
                        if peaks.count >= sampleCount { break }
                    }
                }
            }

            if peaks.count > peakCountBefore, let onProgress {
                let progress = Double(peaks.count) / Double(sampleCount)
                reportProgress(progress, to: onProgress)
            }

            await Task.yield()
        }

        while peaks.count < sampleCount {
            peaks.append(0)
        }

        return Array(peaks.prefix(sampleCount))
    }
}
