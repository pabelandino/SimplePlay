//
//  ClipEditService.swift
//  SimplePlay
//

import AVFoundation
import Foundation

/// Pure clip trim/split logic. Does not touch `AudioEngineService`.
enum ClipEditService {
    static let minimumClipDuration: TimeInterval = 0.05

    enum TrimEdge: Sendable, Equatable {
        case start
        case end
    }

    static func fileDuration(for clip: AudioClip) -> TimeInterval? {
        guard let file = try? AVAudioFile(forReading: clip.fileURL) else { return nil }
        let rate = file.processingFormat.sampleRate
        guard rate > 0 else { return nil }
        return Double(file.length) / rate
    }

    static func trimStart(clip: AudioClip, to newStartTime: TimeInterval, fileDuration: TimeInterval?) -> AudioClip? {
        let delta = newStartTime - clip.startTime
        guard delta >= 0 else { return nil }

        let maxTrim = clip.duration - minimumClipDuration
        guard delta <= maxTrim + 0.000_001 else { return nil }

        var updated = clip
        updated.startTime = newStartTime
        updated.sourceOffset += delta
        updated.duration -= delta

        if let fileDuration, updated.sourceOffset + updated.duration > fileDuration + 0.000_001 {
            return nil
        }

        return updated
    }

    static func trimEnd(clip: AudioClip, to newEndTime: TimeInterval, fileDuration: TimeInterval?) -> AudioClip? {
        let newDuration = newEndTime - clip.startTime
        guard newDuration >= minimumClipDuration else { return nil }

        var updated = clip
        updated.duration = newDuration

        if let fileDuration, updated.sourceOffset + updated.duration > fileDuration + 0.000_001 {
            return nil
        }

        return updated
    }

    static func split(clip: AudioClip, at timelineTime: TimeInterval) -> (left: AudioClip, right: AudioClip)? {
        guard timelineTime > clip.startTime + minimumClipDuration,
              timelineTime < clip.endTime - minimumClipDuration else {
            return nil
        }

        let leftDuration = timelineTime - clip.startTime
        var left = clip
        left.duration = leftDuration

        let right = AudioClip(
            name: clip.name,
            fileURL: clip.fileURL,
            startTime: timelineTime,
            duration: clip.endTime - timelineTime,
            sourceOffset: clip.sourceOffset + leftDuration,
            groupIndex: clip.groupIndex
        )

        return (left, right)
    }
}
