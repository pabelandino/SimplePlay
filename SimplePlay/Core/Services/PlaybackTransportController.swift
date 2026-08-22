//
//  PlaybackTransportController.swift
//  SimplePlay
//
//  Central transport loop (Logic-style): audio render clock drives arrangement + UI.
//

import Foundation

/// Pure transport tick orchestration — testable without SwiftUI.
enum PlaybackTransportController {
    enum TickCommand: Equatable {
        case none
        case pauseTransport
        case seekArrangement(TimeInterval)
        case publishPlayhead(TimeInterval, force: Bool)
        case syncLyrics
        case scrollToTimeIfOffScreen(TimeInterval)
        case completeRepeatBoundary(section: ArrangementSection, loop: SectionLoopContext)
        case armRepeatAudio(loop: SectionLoopContext, playheadTime: TimeInterval)
        case resolveTimelineAudioJump(TimeInterval)
        case reanchorTransport(TimeInterval)
        case restartAudioAfterSectionExit(TimeInterval, hadActiveLoop: Bool)
        case restartSelectionLoop(at: TimeInterval, range: ClosedRange<TimeInterval>)
        case armQueuedSectionJump(boundary: TimeInterval, destination: TimeInterval, playhead: TimeInterval)
        case armContinueToNextJump
        case armLinearContinuation(sectionEnd: TimeInterval, playheadTime: TimeInterval)
    }

    struct TickInput {
        let isPlaying: Bool
        let projectDuration: TimeInterval
        let sampleRate: Double
        let isSelectionLoopEnabled: Bool
        let selectionRange: ClosedRange<TimeInterval>?
        let audioTime: TimeInterval?
        let arrangementState: ArrangementPlaybackEngine.PlaybackState
        let arrangementTime: TimeInterval
        let arrangementIsPlaying: Bool
        let activeSection: ArrangementSection?
        let pendingSection: ArrangementSection?
        let loopPrebufferTriggered: Bool
        let lastAudioTime: TimeInterval?
        let suppressTimelineJumpRestart: Bool
        let skipSectionExitHandling: Bool
        let isSectionLoopActive: Bool
        let isAnyPlayerPlaying: Bool
        let hasArmedBoundaryJump: Bool
        let isSampleClockEstablished: Bool
        let sections: [ArrangementSection]
        let wallTime: TimeInterval
    }

    struct TickState {
        var loopPrebufferTriggered: Bool
        var suppressTimelineJumpRestartUntil: Date?
        var skipSectionExitHandlingUntil: Date?
        var lastAudioTimelineTime: TimeInterval?
        var lastTransportReanchorWallTime: TimeInterval?
    }

    struct TickOutput {
        var commands: [TickCommand]
        var state: TickState
    }

    static func resolveSuppressFlags(now: Date, state: TickState) -> (suppressJump: Bool, skipExit: Bool) {
        let suppressJump = state.suppressTimelineJumpRestartUntil.map { now < $0 } ?? false
        let skipExit = state.skipSectionExitHandlingUntil.map { now < $0 } ?? false
        return (suppressJump, skipExit)
    }

    static func tick(
        input: TickInput,
        state: TickState,
        now: Date = Date(),
        advanceArrangement: (TimeInterval, TimeInterval) -> ArrangementPlaybackEngine.AdvanceResult
    ) -> TickOutput {
        var commands: [TickCommand] = []
        var nextState = state

        guard input.isPlaying else {
            return TickOutput(commands: [], state: nextState)
        }

        let suppressFlags = resolveSuppressFlags(now: now, state: state)

        let repeatPhase = SectionPlaybackCoordinator.resolveRepeatBoundaryPhase(
            arrangementState: input.arrangementState,
            audioTime: input.audioTime,
            sampleRate: input.sampleRate
        )

        switch repeatPhase {
        case .repeatBoundary(let section, let loop):
            let suppressRepeat = suppressFlags.skipExit
                || suppressFlags.suppressJump
                || input.skipSectionExitHandling
                || input.suppressTimelineJumpRestart
            let justWrapped = (input.lastAudioTime ?? loop.endTime) <= loop.startTime + 0.35
            if suppressRepeat || justWrapped {
                let audioTime = input.audioTime ?? loop.endTime
                let clamped = justWrapped
                    ? loop.startTime
                    : TransportClock.clampedPlayhead(in: loop, audioTime: audioTime)
                nextState.lastAudioTimelineTime = clamped
                commands.append(.seekArrangement(clamped))
                commands.append(.publishPlayhead(clamped, force: true))
                return TickOutput(commands: commands, state: nextState)
            }
            nextState.loopPrebufferTriggered = false
            nextState.suppressTimelineJumpRestartUntil = now.addingTimeInterval(
                TransportClock.boundaryRestartSuppression
            )
            nextState.skipSectionExitHandlingUntil = now.addingTimeInterval(
                TransportClock.sectionExitSuppression
            )
            commands.append(.completeRepeatBoundary(section: section, loop: loop))
            return TickOutput(commands: commands, state: nextState)

        case .repeatArmed(let audioTime, _, let loop):
            let clamped = TransportClock.clampedPlayhead(in: loop, audioTime: audioTime)
            nextState.lastAudioTimelineTime = audioTime
            commands.append(.seekArrangement(clamped))
            commands.append(.publishPlayhead(clamped, force: true))
            commands.append(.syncLyrics)
            if SectionPlaybackCoordinator.shouldPrearmRepeatAudio(
                loop: loop,
                playheadTime: audioTime,
                alreadyArmed: input.loopPrebufferTriggered
            ) {
                commands.append(.armRepeatAudio(loop: loop, playheadTime: audioTime))
            }
            return TickOutput(commands: commands, state: nextState)

        case .followAudioDelta:
            break
        }

        guard let audioTime = input.audioTime else {
            return TickOutput(commands: [], state: nextState)
        }

        nextState.lastAudioTimelineTime = audioTime

        if input.isSelectionLoopEnabled,
           let range = input.selectionRange,
           range.upperBound > range.lowerBound,
           !isArrangementSectionControlling(input.arrangementState) {
            if audioTime >= range.upperBound - TransportClock.boundaryEpsilon {
                commands.append(.restartSelectionLoop(at: range.lowerBound, range: range))
                commands.append(.publishPlayhead(range.lowerBound, force: true))
                return TickOutput(commands: commands, state: nextState)
            }
            commands.append(.publishPlayhead(audioTime, force: true))
            return TickOutput(commands: commands, state: nextState)
        }

        let previousArrangementTime = input.arrangementTime
        let previousState = input.arrangementState
        let advance = advanceArrangement(audioTime, input.projectDuration)
        let newTime = advance.newTime
        let newState = advance.newState

        switch advance.outcome {
        case .reachedProjectEnd:
            commands.append(.publishPlayhead(audioTime, force: true))
            commands.append(.pauseTransport)
            return TickOutput(commands: commands, state: nextState)

        case .arrangementStopped:
            commands.append(.publishPlayhead(newTime, force: true))
            commands.append(.pauseTransport)
            return TickOutput(commands: commands, state: nextState)

        case .none, .sectionHandled:
            break
        }

        if shouldRestartAudioAfterSectionExit(from: previousState, to: newState),
           !suppressFlags.skipExit,
           !suppressFlags.suppressJump,
           !input.skipSectionExitHandling,
           // When a pre-scheduled section-jump arm exists, resolveTimelineAudioJump will handle
           // the audio transition. Firing restartAudioAfterSectionExit here would call
           // seamlessJumpPlayback which flushes the arm from the player FIFO, causing silence.
           !input.hasArmedBoundaryJump {
            nextState.loopPrebufferTriggered = false
            let hadLoop = input.isSectionLoopActive
            commands.append(.restartAudioAfterSectionExit(newTime, hadActiveLoop: hadLoop))
        }

        let didJumpBackward = TransportClock.didBackwardTimelineJump(
            from: previousArrangementTime,
            to: newTime
        )
        let isSectionTransition = isArrangementSectionTransition(
            from: previousArrangementTime,
            to: newTime,
            state: newState,
            sections: input.sections
        )

        commands.append(.publishPlayhead(audioTime, force: true))

        if didJumpBackward {
            commands.append(.scrollToTimeIfOffScreen(newTime))
        }

        commands.append(.syncLyrics)

        // Allow resolveTimelineAudioJump when a pre-armed section boundary jump is waiting:
        // the 0.75 s suppression set by the previous loop boundary must not block the
        // section-jump arm from completing its transition. Without this bypass, the next
        // tick detects a backward jump and restarts with the wrong section's audio.
        let jumpSuppressed = suppressFlags.suppressJump || input.suppressTimelineJumpRestart
        if (!jumpSuppressed || input.hasArmedBoundaryJump),
           TransportClock.requiresAudioResyncAfterTimelineMove(
               from: previousArrangementTime,
               to: newTime,
               isSectionTransition: isSectionTransition
           ) {
            nextState.loopPrebufferTriggered = false
            commands.append(.resolveTimelineAudioJump(newTime))
        } else if !suppressFlags.suppressJump,
                  !input.suppressTimelineJumpRestart,
                  TransportClock.needsTransportReanchor(
                      lastAudioTime: input.lastAudioTime,
                      transportTime: audioTime,
                      previousArrangementTime: previousArrangementTime,
                      isSectionTransition: isSectionTransition,
                      lastReanchorWallTime: state.lastTransportReanchorWallTime,
                      wallTime: input.wallTime,
                      activeSection: input.activeSection
                  ) {
            nextState.lastTransportReanchorWallTime = input.wallTime
            commands.append(.reanchorTransport(audioTime))
        }

        if !input.hasArmedBoundaryJump,
           case .playingSection(let section) = newState {
            let remaining = section.endTime - audioTime
            if remaining > 0, remaining <= 2.5,
               section.playbackMode == .continueToNext,
               section.nextSectionID != nil {
                commands.append(.armContinueToNextJump)
            } else if !input.loopPrebufferTriggered,
                      !input.isSectionLoopActive,
                      remaining > 0,
                      remaining <= TransportClock.continuationPrearmLeadTime {
                switch section.playbackMode {
                case .continueTimeline, .repeatSection:
                    commands.append(.armLinearContinuation(
                        sectionEnd: section.endTime,
                        playheadTime: audioTime
                    ))
                case .continueToNext, .oneShot:
                    break
                }
            }
        }

        if case .waitingToJump = newState,
           let active = input.activeSection,
           let pending = input.pendingSection,
           !input.hasArmedBoundaryJump {
            let remaining = active.endTime - audioTime
            if remaining > 0, remaining <= 2.5 {
                commands.append(.armQueuedSectionJump(
                    boundary: active.endTime,
                    destination: pending.startTime,
                    playhead: audioTime
                ))
            }
        }

        if advance.outcome == .none,
           TransportClock.didAudioSeek(from: input.lastAudioTime, to: audioTime),
           input.hasArmedBoundaryJump,
           !suppressFlags.suppressJump {
            commands.append(.resolveTimelineAudioJump(audioTime))
        }

        if newTime >= input.projectDuration,
           input.projectDuration > 0,
           !isArrangementSectionControlling(newState) {
            commands.append(.pauseTransport)
        }

        if !input.arrangementIsPlaying {
            commands.append(.pauseTransport)
        }

        return TickOutput(commands: commands, state: nextState)
    }

    private static func isArrangementSectionControlling(_ state: ArrangementPlaybackEngine.PlaybackState) -> Bool {
        switch state {
        case .playingSection, .repeatingSectionAtEnd, .waitingToJump:
            return true
        case .idle, .continuingTimeline:
            return false
        }
    }

    private static func isRepeatingAtEnd(_ state: ArrangementPlaybackEngine.PlaybackState) -> Bool {
        if case .repeatingSectionAtEnd = state { return true }
        return false
    }

    private static func shouldRestartAudioAfterSectionExit(
        from previous: ArrangementPlaybackEngine.PlaybackState,
        to current: ArrangementPlaybackEngine.PlaybackState
    ) -> Bool {
        let wasInSection: Bool = {
            switch previous {
            case .playingSection, .repeatingSectionAtEnd:
                return true
            default:
                return false
            }
        }()
        guard wasInSection else { return false }

        switch current {
        case .continuingTimeline, .idle:
            return true
        default:
            return false
        }
    }

    private static func isArrangementSectionTransition(
        from previousTime: TimeInterval,
        to newTime: TimeInterval,
        state: ArrangementPlaybackEngine.PlaybackState,
        sections: [ArrangementSection]
    ) -> Bool {
        guard TransportClock.didTimelineJump(from: previousTime, to: newTime) else { return false }

        if case .continuingTimeline = state {
            return false
        }

        let previousSection = sections.first(where: { $0.contains(time: previousTime) })
        let newSection = sections.first(where: { $0.contains(time: newTime) })

        if let previousSection, let newSection {
            return previousSection.id != newSection.id
        }

        switch state {
        case .playingSection(let section):
            return abs(newTime - section.startTime) <= TransportClock.activeDisplayInterval * 2
        default:
            return previousSection != nil && newSection == nil
        }
    }
}
