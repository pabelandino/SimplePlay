//
//  SectionAudioCache.swift
//  LvoqPlayback
//
//  Pre-decoded PCM slices for section bodies. Decode uses a dedicated AVAudioFile
//  so it never seeks the file handle used by the live player.
//

import AVFoundation
import Foundation

/// In-memory PCM cache for section-sized audio slices (loop body / jump destination).
@MainActor
final class SectionAudioCache {
    /// Reject slices longer than this so a 3-minute section cannot balloon memory.
    nonisolated static let maxSliceSeconds: TimeInterval = 60

    /// RAM window after a section end so linear continuation / jumps are gapless.
    /// The rest of a long clip still streams from disk once this head is playing.
    nonisolated static let continuationCacheSeconds: TimeInterval = 8

    struct WarmSlice: Sendable {
        let clipID: UUID
        let fileURL: URL
        let sourceStartFrame: AVAudioFramePosition
        let frameCount: AVAudioFrameCount
        let sampleRate: Double
        /// Where the overlap sits inside a section-length buffer. 0 for tails.
        let destOffsetFrames: AVAudioFrameCount
        /// Section-length frame count. 0 means store the overlap only (continuation tail).
        let sectionFrameCount: AVAudioFrameCount

        init(
            clipID: UUID,
            fileURL: URL,
            sourceStartFrame: AVAudioFramePosition,
            frameCount: AVAudioFrameCount,
            sampleRate: Double,
            destOffsetFrames: AVAudioFrameCount = 0,
            sectionFrameCount: AVAudioFrameCount = 0
        ) {
            self.clipID = clipID
            self.fileURL = fileURL
            self.sourceStartFrame = sourceStartFrame
            self.frameCount = frameCount
            self.sampleRate = sampleRate
            self.destOffsetFrames = destOffsetFrames
            self.sectionFrameCount = sectionFrameCount
        }
    }

    struct Key: Hashable, Sendable {
        let sectionID: UUID
        let clipID: UUID
        let sourceStartFrame: AVAudioFramePosition
        let frameCount: AVAudioFrameCount
    }

    private struct SectionClipKey: Hashable {
        let sectionID: UUID
        let clipID: UUID
    }

    /// `/var` vs `/private/var` (and bookmark URLs) must hit the same PCM slot.
    nonisolated static func normalizedPath(_ url: URL) -> String {
        url.resolvingSymlinksInPath().standardizedFileURL.path
    }

    private var buffers: [Key: AVAudioPCMBuffer] = [:]
    private var sectionBodies: [SectionClipKey: AVAudioPCMBuffer] = [:]
    private var warmGeneration: [UUID: UInt64] = [:]

    func cachedIfPresent(
        sectionID: UUID,
        clipID: UUID,
        sourceStartFrame: AVAudioFramePosition,
        frameCount: AVAudioFrameCount
    ) -> AVAudioPCMBuffer? {
        let exact = Key(
            sectionID: sectionID,
            clipID: clipID,
            sourceStartFrame: sourceStartFrame,
            frameCount: frameCount
        )
        if let buffer = buffers[exact] {
            return buffer
        }
        return nil
    }

    /// Padded section-length PCM for one clip. Loop this buffer with `.loops`.
    func sectionBody(sectionID: UUID, clipID: UUID) -> AVAudioPCMBuffer? {
        sectionBodies[SectionClipKey(sectionID: sectionID, clipID: clipID)]
    }

    /// Serial background warm for one section so the wrap path can `scheduleBuffer`.
    func warm(sectionID: UUID, name: String, slices: [WarmSlice]) {
        let budgeted = slices.filter {
            let frames = max($0.frameCount, $0.sectionFrameCount)
            return Self.isSliceWithinBudget(frameCount: frames, sampleRate: $0.sampleRate)
        }
        guard !budgeted.isEmpty else { return }
        if SectionCueQueueMonitor.shared.isQueuing(sectionID: sectionID) {
            return
        }
        let anyMiss = budgeted.contains {
            buffers[Key(
                sectionID: sectionID,
                clipID: $0.clipID,
                sourceStartFrame: $0.sourceStartFrame,
                frameCount: $0.frameCount
            )] == nil
        }
        guard anyMiss else { return }

        evict(sectionID: sectionID)
        warmGeneration[sectionID, default: 0] += 1
        let decodeGeneration = warmGeneration[sectionID] ?? 1
        let generation = SectionCueQueueMonitor.shared.begin(
            sectionID: sectionID,
            total: budgeted.count
        )

        SectionLoopDiagnostics.log(String(
            format: "queuing %d gapless slices for section '%@'",
            budgeted.count,
            name
        ))

        Task.detached(priority: .utility) {
            for slice in budgeted {
                let key = Key(
                    sectionID: sectionID,
                    clipID: slice.clipID,
                    sourceStartFrame: slice.sourceStartFrame,
                    frameCount: slice.frameCount
                )
                let decoded = SectionAudioCache.decodeSlice(
                    fileURL: slice.fileURL,
                    sourceStartFrame: slice.sourceStartFrame,
                    frameCount: slice.frameCount
                )
                await MainActor.run {
                    if let decoded, self.warmGeneration[sectionID] == decodeGeneration {
                        self.store(key: key, buffer: decoded)
                        if slice.sectionFrameCount > 0,
                           let padded = SectionAudioCache.padOverlap(
                            decoded,
                            destOffset: slice.destOffsetFrames,
                            sectionFrames: slice.sectionFrameCount
                           ) {
                            self.sectionBodies[SectionClipKey(sectionID: sectionID, clipID: slice.clipID)] = padded
                        }
                    }
                    SectionCueQueueMonitor.shared.completeOne(
                        sectionID: sectionID,
                        generation: generation
                    )
                }
            }
        }
    }

    private func store(key: Key, buffer: AVAudioPCMBuffer) {
        buffers[key] = buffer
    }

    func evictAll() {
        buffers.removeAll(keepingCapacity: false)
        sectionBodies.removeAll(keepingCapacity: false)
        warmGeneration.removeAll(keepingCapacity: false)
    }

    func evict(sectionID: UUID) {
        buffers = buffers.filter { $0.key.sectionID != sectionID }
        sectionBodies = sectionBodies.filter { $0.key.sectionID != sectionID }
    }

    nonisolated static func isSliceWithinBudget(frameCount: AVAudioFrameCount, sampleRate: Double) -> Bool {
        guard sampleRate > 0 else { return false }
        return Double(frameCount) / sampleRate <= maxSliceSeconds
    }

    nonisolated static func sourceRange(
        clip: AudioClip,
        timelineStart: TimeInterval,
        timelineEnd: TimeInterval,
        sampleRate: Double
    ) -> (sourceStart: AVAudioFramePosition, frameCount: AVAudioFrameCount)? {
        guard sampleRate > 0, timelineEnd > timelineStart else { return nil }
        let clipStart = TimelineSampleGrid.frames(at: clip.startTime, sampleRate: sampleRate)
        let clipEnd = TimelineSampleGrid.frames(at: clip.endTime, sampleRate: sampleRate)
        let rangeStart = TimelineSampleGrid.frames(at: timelineStart, sampleRate: sampleRate)
        let rangeEnd = TimelineSampleGrid.frames(at: timelineEnd, sampleRate: sampleRate)
        let bodyStart = max(rangeStart, clipStart)
        let bodyEnd = min(rangeEnd, clipEnd)
        guard bodyEnd > bodyStart else { return nil }
        let sourceOffset = TimelineSampleGrid.frames(at: clip.sourceOffset, sampleRate: sampleRate)
        let sourceStart = sourceOffset + (bodyStart - clipStart)
        let frameCount = AVAudioFrameCount(bodyEnd - bodyStart)
        guard sourceStart >= 0, frameCount > 0 else { return nil }
        return (sourceStart, frameCount)
    }

    /// Places a clip's overlap inside a zero-padded buffer that lasts the whole section
    /// so `scheduleBuffer(..., options: .loops)` wraps on the section, not the clip.
    nonisolated static func padLayout(
        clip: AudioClip,
        sectionStart: TimeInterval,
        sectionEnd: TimeInterval,
        sampleRate: Double
    ) -> (
        sourceStart: AVAudioFramePosition,
        overlapFrames: AVAudioFrameCount,
        destOffset: AVAudioFrameCount,
        sectionFrames: AVAudioFrameCount
    )? {
        guard let overlap = sourceRange(
            clip: clip,
            timelineStart: sectionStart,
            timelineEnd: sectionEnd,
            sampleRate: sampleRate
        ) else { return nil }
        let sectionStartFrame = TimelineSampleGrid.frames(at: sectionStart, sampleRate: sampleRate)
        let sectionEndFrame = TimelineSampleGrid.frames(at: sectionEnd, sampleRate: sampleRate)
        let sectionFrames = AVAudioFrameCount(max(0, sectionEndFrame - sectionStartFrame))
        guard sectionFrames > 0 else { return nil }
        let overlapStart = TimelineSampleGrid.frames(
            at: max(clip.startTime, sectionStart),
            sampleRate: sampleRate
        )
        let destOffset = AVAudioFrameCount(max(0, overlapStart - sectionStartFrame))
        return (overlap.sourceStart, overlap.frameCount, destOffset, sectionFrames)
    }

    nonisolated static func padOverlap(
        _ overlap: AVAudioPCMBuffer,
        destOffset: AVAudioFrameCount,
        sectionFrames: AVAudioFrameCount
    ) -> AVAudioPCMBuffer? {
        guard sectionFrames > 0 else { return nil }
        guard let dest = AVAudioPCMBuffer(
            pcmFormat: overlap.format,
            frameCapacity: sectionFrames
        ) else { return nil }
        dest.frameLength = sectionFrames
        guard let destChannels = dest.floatChannelData else {
            Self.preTouchPCMPages(dest)
            return dest
        }
        let channelCount = Int(overlap.format.channelCount)
        let total = Int(sectionFrames)
        for channel in 0..<channelCount {
            destChannels[channel].update(repeating: 0, count: total)
        }
        guard let srcChannels = overlap.floatChannelData else {
            Self.preTouchPCMPages(dest)
            return dest
        }
        let copyCount = min(Int(overlap.frameLength), max(0, total - Int(destOffset)))
        guard copyCount > 0 else {
            Self.preTouchPCMPages(dest)
            return dest
        }
        let offset = Int(destOffset)
        for channel in 0..<channelCount {
            destChannels[channel].advanced(by: offset).update(from: srcChannels[channel], count: copyCount)
        }
        Self.preTouchPCMPages(dest)
        return dest
    }

    nonisolated static func continuationTailRange(
        clip: AudioClip,
        sectionEnd: TimeInterval,
        sampleRate: Double
    ) -> (sourceStart: AVAudioFramePosition, frameCount: AVAudioFrameCount)? {
        let tailEnd = min(clip.endTime, sectionEnd + continuationCacheSeconds)
        return sourceRange(
            clip: clip,
            timelineStart: sectionEnd,
            timelineEnd: tailEnd,
            sampleRate: sampleRate
        )
    }

    nonisolated static func decodeSlice(
        fileURL: URL,
        sourceStartFrame: AVAudioFramePosition,
        frameCount: AVAudioFrameCount
    ) -> AVAudioPCMBuffer? {
        let reader: AVAudioFile
        do {
            reader = try AVAudioFile(forReading: fileURL)
        } catch {
            return nil
        }
        guard sourceStartFrame < reader.length else { return nil }
        let readable = min(AVAudioFrameCount(reader.length - sourceStartFrame), frameCount)
        guard readable > 0 else { return nil }
        guard let buffer = AVAudioPCMBuffer(
            pcmFormat: reader.processingFormat,
            frameCapacity: readable
        ) else {
            return nil
        }
        reader.framePosition = sourceStartFrame
        do {
            try reader.read(into: buffer, frameCount: readable)
        } catch {
            return nil
        }
        guard buffer.frameLength > 0 else { return nil }
        Self.preTouchPCMPages(buffer)
        return buffer
    }

    /// Fault PCM pages off the render thread so the first wrap is not a page-in stall.
    nonisolated static func preTouchPCMPages(_ buffer: AVAudioPCMBuffer) {
        guard let channels = buffer.floatChannelData else { return }
        let frames = Int(buffer.frameLength)
        let count = Int(buffer.format.channelCount)
        guard frames > 0, count > 0 else { return }
        let strideFrames = 1024
        for channel in 0..<count {
            let samples = channels[channel]
            var index = 0
            while index < frames {
                _ = samples[index]
                index += strideFrames
            }
            _ = samples[frames - 1]
        }
    }
}
