//
//  SectionPlaybackCoordinator.swift
//  SimplePlay
//
//  Single contract between arrangement state and audio scheduling for section playback.
//  Audio is the authority for repeat-at-end boundaries; arrangement must not wrap alone.
//

import Foundation

/// Pure rules + small helpers for section playback sync (testable without AVAudioEngine).
enum SectionPlaybackCoordinator {
    /// Epsilon for comparing playhead position to section edges (sample grid + timer jitter).
    static let boundaryEpsilon: TimeInterval = 0.004

    /// How close to section end we pre-arm gapless repeat / continuation audio.
    /// Keep in sync with `TransportClock.repeatPrearmLeadTime`.
    static let repeatPrearmLeadTime: TimeInterval = 2.5

    /// After a wrap, wait this long before scheduling the next body on the idle
    /// lane. Scheduling 12 PCM buffers in the first IO cycles gaps the restart.
    static let postWrapPrimeHoldoff: TimeInterval = 0.25

    /// If remaining is this short, arm even during the post-wrap holdoff.
    static let mustPrimeRemaining: TimeInterval = 0.5

    enum RepeatBoundaryPhase: Equatable {
        /// Normal transport: arrangement clock follows audio delta.
        case followAudioDelta
        /// Repeat armed: arrangement playhead tracks audio, clamped to section bounds.
        case repeatArmed(audioTime: TimeInterval, section: ArrangementSection, loop: SectionLoopContext)
        /// Audio reached section end while repeat is armed — fire boundary handler once.
        case repeatBoundary(section: ArrangementSection, loop: SectionLoopContext)
    }

    /// Caps linear `play()` scheduling so audio cannot run past the active section while repeat is pending.
    /// If `playheadTime` is already at or past that cap, return nil so a seek later in the song
    /// is not scheduled as an empty range (`playbackUnavailable`).
    static func linearScheduleCap(
        arrangementState: ArrangementPlaybackEngine.PlaybackState,
        activeSection: ArrangementSection?,
        pendingSection: ArrangementSection?,
        playheadTime: TimeInterval? = nil
    ) -> TimeInterval? {
        let cap: TimeInterval?
        switch arrangementState {
        case .playingSection(let section), .repeatingSectionAtEnd(let section):
            cap = section.endTime
        case .waitingToJump:
            cap = activeSection?.endTime
        case .idle, .continuingTimeline:
            cap = pendingSection?.endTime
        }
        if let cap, let playheadTime, playheadTime >= cap - boundaryEpsilon {
            return nil
        }
        return cap
    }

    static func repeatLoopContext(
        for section: ArrangementSection,
        sampleRate: Double
    ) -> SectionLoopContext {
        let start = TimelineSampleGrid.timeFromFrame(
            TimelineSampleGrid.frames(at: section.startTime, sampleRate: sampleRate),
            sampleRate: sampleRate
        )
        let end = TimelineSampleGrid.timeFromFrame(
            TimelineSampleGrid.frames(at: section.endTime, sampleRate: sampleRate),
            sampleRate: sampleRate
        )
        return SectionLoopContext(sectionID: section.id, startTime: start, endTime: end)
    }

    static func resolveRepeatBoundaryPhase(
        arrangementState: ArrangementPlaybackEngine.PlaybackState,
        audioTime: TimeInterval?,
        sampleRate: Double
    ) -> RepeatBoundaryPhase {
        guard case .repeatingSectionAtEnd(let section) = arrangementState,
              let audioTime else {
            return .followAudioDelta
        }

        let loop = repeatLoopContext(for: section, sampleRate: sampleRate)
        if audioTime >= loop.endTime - boundaryEpsilon {
            return .repeatBoundary(section: section, loop: loop)
        }

        return .repeatArmed(audioTime: audioTime, section: section, loop: loop)
    }

    static func clampedPlayhead(in loop: SectionLoopContext, audioTime: TimeInterval) -> TimeInterval {
        min(max(audioTime, loop.startTime), loop.endTime)
    }

    static func shouldPrearmRepeatAudio(
        loop: SectionLoopContext,
        playheadTime: TimeInterval,
        alreadyArmed: Bool
    ) -> Bool {
        guard !alreadyArmed else { return false }
        let remaining = loop.endTime - playheadTime
        guard remaining > 0, remaining <= repeatPrearmLeadTime else { return false }
        let elapsedInLoop = playheadTime - loop.startTime
        if elapsedInLoop < postWrapPrimeHoldoff, remaining > mustPrimeRemaining {
            return false
        }
        return true
    }
}
