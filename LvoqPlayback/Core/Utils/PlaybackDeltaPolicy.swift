//
//  PlaybackDeltaPolicy.swift
//  LvoqPlayback
//

import Foundation

/// Pure rules for advancing the arrangement clock from the audio engine clock.
/// Keep in sync with `WorkspaceViewModel.computePlaybackDelta` — covered by unit tests.
enum PlaybackDeltaPolicy {
    struct Resolution: Equatable {
        let delta: TimeInterval
        let shouldSeekArrangementToAudio: Bool
        let logsDriftSync: Bool
        let logsIgnoredJump: Bool
    }

    static func resolve(
        previousArrangementTime: TimeInterval,
        audioTime: TimeInterval,
        projectDuration: TimeInterval,
        suppressJumpRestart: Bool
    ) -> Resolution {
        let rawDelta = audioTime - previousArrangementTime

        if rawDelta >= 0, rawDelta <= 0.5 {
            return Resolution(
                delta: rawDelta,
                shouldSeekArrangementToAudio: false,
                logsDriftSync: false,
                logsIgnoredJump: false
            )
        }

        if suppressJumpRestart,
           rawDelta > 0.5,
           audioTime <= projectDuration + 0.5 {
            return Resolution(
                delta: max(0, min(rawDelta, 0.5)),
                shouldSeekArrangementToAudio: true,
                logsDriftSync: false,
                logsIgnoredJump: false
            )
        }

        if rawDelta > 0.5, rawDelta <= 1.0, audioTime <= projectDuration + 0.25 {
            return Resolution(
                delta: 0,
                shouldSeekArrangementToAudio: true,
                logsDriftSync: true,
                logsIgnoredJump: false
            )
        }

        if rawDelta > 1.0 {
            return Resolution(
                delta: 0,
                shouldSeekArrangementToAudio: false,
                logsDriftSync: false,
                logsIgnoredJump: true
            )
        }

        return Resolution(
            delta: 0,
            shouldSeekArrangementToAudio: false,
            logsDriftSync: false,
            logsIgnoredJump: false
        )
    }
}
