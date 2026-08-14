//
//  WaveformLOD.swift
//  SimplePlay
//

import CoreGraphics
import Foundation

/// Level-of-detail selection for waveform peak data based on on-screen width.
enum WaveformLOD {
    static let minSamples = 200
    static let maxSamples = 8192

    /// Target peak count for a clip at the current zoom level (~1 peak per pixel).
    static func targetSampleCount(clipWidth: CGFloat) -> Int {
        min(maxSamples, max(minSamples, Int(ceil(clipWidth))))
    }

    /// Quantized bucket used for cache keys and incremental reloads while zooming in.
    static func loadBucket(for clipWidth: CGFloat) -> Int {
        let target = targetSampleCount(clipWidth: clipWidth)
        guard target > minSamples else { return minSamples }

        let exponent = round(log2(Double(target)))
        return min(maxSamples, max(minSamples, Int(pow(2.0, exponent))))
    }

    /// Peak count for caching an entire source file at the current horizontal zoom.
    static func fileLoadBucket(fileDuration: TimeInterval, pixelsPerSecond: CGFloat) -> Int {
        guard fileDuration > 0, pixelsPerSecond > 0 else { return maxSamples }
        let filePixelWidth = CGFloat(fileDuration) * pixelsPerSecond
        return loadBucket(for: max(filePixelWidth, 48))
    }
}

/// Slices cached full-file peaks for a clip region without re-reading audio from disk.
enum WaveformPeakSlicer {
    static func visiblePeaks(
        from fullPeaks: [Float],
        fileDuration: TimeInterval,
        sourceOffset: TimeInterval,
        visibleDuration: TimeInterval,
        targetCount: Int
    ) -> [Float] {
        guard fileDuration > 0, visibleDuration > 0, !fullPeaks.isEmpty, targetCount > 0 else {
            return fullPeaks
        }

        let startFraction = min(1.0, max(0.0, sourceOffset / fileDuration))
        let endFraction = min(1.0, max(startFraction, (sourceOffset + visibleDuration) / fileDuration))

        let startIndex = Int(startFraction * Double(fullPeaks.count))
        let endIndex = max(startIndex + 1, Int(endFraction * Double(fullPeaks.count)))
        let slice = Array(fullPeaks[startIndex..<min(endIndex, fullPeaks.count)])

        if slice.count >= targetCount {
            return resampleMaxPooled(slice, to: targetCount)
        }
        return interpolateUpsample(slice, to: targetCount)
    }

    private static func interpolateUpsample(_ peaks: [Float], to targetCount: Int) -> [Float] {
        guard !peaks.isEmpty, targetCount > 0 else { return [] }
        guard peaks.count > 1, peaks.count < targetCount else {
            return peaks.count == 1 ? Array(repeating: peaks[0], count: targetCount) : peaks
        }

        var result: [Float] = []
        result.reserveCapacity(targetCount)

        for index in 0..<targetCount {
            let position = Double(index) / Double(max(targetCount - 1, 1)) * Double(peaks.count - 1)
            let lower = Int(floor(position))
            let upper = min(lower + 1, peaks.count - 1)
            let fraction = Float(position - Double(lower))
            let value = peaks[lower] + (peaks[upper] - peaks[lower]) * fraction
            result.append(value)
        }

        return result
    }

    private static func resampleMaxPooled(_ peaks: [Float], to targetCount: Int) -> [Float] {
        guard !peaks.isEmpty, targetCount > 0 else { return [] }
        guard peaks.count != targetCount else { return peaks }

        var result: [Float] = []
        result.reserveCapacity(targetCount)

        for bucket in 0..<targetCount {
            let start = bucket * peaks.count / targetCount
            let end = max(start + 1, (bucket + 1) * peaks.count / targetCount)
            result.append(peaks[start..<min(end, peaks.count)].max() ?? 0)
        }

        return result
    }
}
