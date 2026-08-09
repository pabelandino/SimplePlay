//
//  WaveformLoadMonitor.swift
//  SimplePlay
//

import Foundation
import Observation

@MainActor
@Observable
final class WaveformLoadMonitor {
    static let shared = WaveformLoadMonitor()

    private(set) var trackClipProgress: [UUID: [UUID: Double]] = [:]

    func beginClip(trackID: UUID, clipID: UUID) {
        var clips = trackClipProgress[trackID] ?? [:]
        guard clips[clipID] == nil else { return }
        clips[clipID] = 0
        trackClipProgress[trackID] = clips
    }

    func setClipProgress(trackID: UUID, clipID: UUID, progress: Double) {
        var clips = trackClipProgress[trackID] ?? [:]
        guard clips[clipID] != nil else { return }

        clips[clipID] = min(1, max(0, progress))
        trackClipProgress[trackID] = clips

        if progress >= 1 {
            scheduleTrackCleanupIfFinished(trackID)
        }
    }

    func completeClip(trackID: UUID, clipID: UUID) {
        var clips = trackClipProgress[trackID] ?? [:]
        guard clips[clipID] != nil else { return }

        clips[clipID] = 1
        trackClipProgress[trackID] = clips
        scheduleTrackCleanupIfFinished(trackID)
    }

    func progress(for trackID: UUID) -> Double {
        guard let clips = trackClipProgress[trackID], !clips.isEmpty else { return 0 }
        return clips.values.reduce(0, +) / Double(clips.count)
    }

    func isLoading(trackID: UUID) -> Bool {
        guard let clips = trackClipProgress[trackID] else { return false }
        return clips.values.contains { $0 < 1 }
    }

    func reset() {
        trackClipProgress.removeAll()
    }

    private func scheduleTrackCleanupIfFinished(_ trackID: UUID) {
        guard let clips = trackClipProgress[trackID], clips.values.allSatisfy({ $0 >= 1 }) else {
            return
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self,
                  let current = self.trackClipProgress[trackID],
                  current.values.allSatisfy({ $0 >= 1 })
            else { return }
            self.trackClipProgress.removeValue(forKey: trackID)
        }
    }
}
