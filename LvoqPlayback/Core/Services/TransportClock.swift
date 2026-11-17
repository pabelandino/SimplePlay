//
//  TransportClock.swift
//  LvoqPlayback
//
//  Logic-style transport: the audio render clock is the only time authority.
//  UI reads display time; arrangement logic reacts to absolute transport position.
//

import Foundation

/// Sample-grid transport helpers shared by the audio engine and UI transport loop.
enum TransportClock {
    /// Epsilon for comparing playhead position to section edges (sample grid + render jitter).
    static let boundaryEpsilon: TimeInterval = 0.004

    /// How close to a section end we pre-arm linear continuation.
    /// Long enough to splice cached PCM tails; short enough that a pad tap
    /// during the extra cycle can still adopt a loop body.
    static let continuationPrearmLeadTime: TimeInterval = 1.0

    /// How close to a section end we pre-arm gapless jump / repeat audio.
    /// Also when the next loop body is scheduled after a wrap — never in the wrap quantum.
    static let repeatPrearmLeadTime: TimeInterval = 2.5

    /// Minimum backward jump treated as an audio-led boundary seek (repeat wrap, queued jump).
    static let backwardJumpThreshold: TimeInterval = 0.05

    /// Forward discontinuity beyond steady playback — usually stale clock or explicit seek.
    static let forwardJumpThreshold: TimeInterval = 0.5

    /// Display refresh while the app is active (smooth playhead).
    static let activeDisplayInterval: TimeInterval = 1.0 / 60.0

    /// Display refresh while backgrounded (save power).
    static let backgroundDisplayInterval: TimeInterval = 1.0 / 15.0

    /// Duration to suppress arrangement-driven audio restarts after a gapless boundary.
    static let boundaryRestartSuppression: TimeInterval = 0.75

    /// Duration to suppress section-exit handling after repeat/boundary completion.
    static let sectionExitSuppression: TimeInterval = 0.75

    static func clampedPlayhead(in loop: SectionLoopContext, audioTime: TimeInterval) -> TimeInterval {
        min(max(audioTime, loop.startTime), loop.endTime)
    }

    static func didTimelineJump(from previous: TimeInterval, to newTime: TimeInterval) -> Bool {
        abs(newTime - previous) > backwardJumpThreshold
    }

    static func didBackwardTimelineJump(from previous: TimeInterval, to newTime: TimeInterval) -> Bool {
        newTime + backwardJumpThreshold < previous
    }

    /// Audio must be resynced only on backward seeks or explicit section jumps — not forward catch-up after UI jank.
    static func requiresAudioResyncAfterTimelineMove(
        from previous: TimeInterval,
        to newTime: TimeInterval,
        isSectionTransition: Bool
    ) -> Bool {
        if didBackwardTimelineJump(from: previous, to: newTime) {
            return true
        }
        if isSectionTransition, didTimelineJump(from: previous, to: newTime) {
            return true
        }
        return false
    }

    static func didAudioSeek(from previous: TimeInterval?, to audioTime: TimeInterval) -> Bool {
        guard let previous else { return false }
        let delta = audioTime - previous
        if delta <= -backwardJumpThreshold { return true }
        if delta >= forwardJumpThreshold { return true }
        return false
    }

    /// Minimum interval between lightweight transport re-anchors (avoids churn).
    static let transportReanchorMinInterval: TimeInterval = 0.1

    /// Forward catch-up after UI thread stall — re-anchor render clock metadata without restarting players.
    static func needsTransportReanchor(
        lastAudioTime: TimeInterval?,
        transportTime: TimeInterval,
        previousArrangementTime: TimeInterval,
        isSectionTransition: Bool,
        lastReanchorWallTime: TimeInterval?,
        wallTime: TimeInterval,
        activeSection: ArrangementSection? = nil
    ) -> Bool {
        guard !isSectionTransition else { return false }
        if didBackwardTimelineJump(from: previousArrangementTime, to: transportTime) {
            return false
        }

        if let activeSection,
           isRepeatWrapStaleRenderClock(
               arrangementTime: previousArrangementTime,
               transportTime: transportTime,
               sectionStart: activeSection.startTime,
               sectionEnd: activeSection.endTime
           ) {
            return false
        }

        let forwardDrift = transportTime - previousArrangementTime
        guard forwardDrift > backwardJumpThreshold else { return false }

        if let lastReanchorWallTime,
           wallTime - lastReanchorWallTime < transportReanchorMinInterval {
            return false
        }

        if forwardDrift > 0.08 { return true }
        if let lastAudioTime, transportTime - lastAudioTime > 0.08 { return true }
        return false
    }

    /// Arrangement already wrapped to section start while the render clock still reports the prior pass at section end.
    static func isRepeatWrapStaleRenderClock(
        arrangementTime: TimeInterval,
        transportTime: TimeInterval,
        sectionStart: TimeInterval,
        sectionEnd: TimeInterval
    ) -> Bool {
        arrangementTime <= sectionStart + boundaryEpsilon
            && transportTime >= sectionEnd - boundaryEpsilon
    }

    static func isPlayheadOffScreen(
        time: TimeInterval,
        pixelsPerSecond: Double,
        visibleOffsetX: Double,
        viewportWidth: Double,
        marginFraction: Double = 0.12
    ) -> Bool {
        let playheadX = time * pixelsPerSecond
        let margin = viewportWidth * marginFraction
        let visibleStart = visibleOffsetX + margin
        let visibleEnd = visibleOffsetX + viewportWidth - margin
        return playheadX < visibleStart || playheadX > visibleEnd
    }
}

/// Keeps the visible playhead moving at 1× between audio render-clock samples (Logic-style display extrapolation).
struct TransportDisplayClock: Equatable {
    private(set) var anchorAudioTime: TimeInterval = 0
    private(set) var anchorWallTime: TimeInterval = 0
    private(set) var isAnchored = false

    mutating func reset(to time: TimeInterval, wallTime: TimeInterval) {
        anchorAudioTime = time
        anchorWallTime = wallTime
        isAnchored = true
    }

    mutating func clear() {
        isAnchored = false
        anchorAudioTime = 0
        anchorWallTime = 0
    }

    mutating func commitSample(_ audioTime: TimeInterval, wallTime: TimeInterval) {
        anchorAudioTime = audioTime
        anchorWallTime = wallTime
        isAnchored = true
    }

    /// Prefers the render sample when present; otherwise extrapolates at 1× from the last anchor.
    func resolvedTime(
        isPlaying: Bool,
        wallTime: TimeInterval,
        sampleTime: TimeInterval?
    ) -> TimeInterval? {
        if let sampleTime {
            return sampleTime
        }
        guard isPlaying, isAnchored else { return nil }
        return anchorAudioTime + max(0, wallTime - anchorWallTime)
    }
}
