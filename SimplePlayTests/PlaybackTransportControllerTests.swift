//
//  PlaybackTransportControllerTests.swift
//  SimplePlayTests
//

import Foundation
import Testing
@testable import SimplePlay

@MainActor
struct PlaybackTransportControllerTests {
    @Test func repeatArmedClampsPlayheadAndArmsNearBoundary() async {
        let section = makeSection(name: "Chorus", start: 10, end: 20, note: 62)
        let loop = SectionLoopContext(sectionID: section.id, startTime: 10, endTime: 20)

        var state = PlaybackTransportController.TickState(
            loopPrebufferTriggered: false,
            suppressTimelineJumpRestartUntil: nil,
            skipSectionExitHandlingUntil: nil,
            lastAudioTimelineTime: 19.0,
            lastTransportReanchorWallTime: nil
        )

        let input = PlaybackTransportController.TickInput(
            isPlaying: true,
            projectDuration: 60,
            sampleRate: 48_000,
            isSelectionLoopEnabled: false,
            selectionRange: nil,
            audioTime: 19.92,
            arrangementState: .repeatingSectionAtEnd(section),
            arrangementTime: 19.5,
            arrangementIsPlaying: true,
            activeSection: section,
            pendingSection: nil,
            loopPrebufferTriggered: false,
            lastAudioTime: 19.0,
            suppressTimelineJumpRestart: false,
            skipSectionExitHandling: false,
            isSectionLoopActive: false,
            isAnyPlayerPlaying: true,
            hasArmedBoundaryJump: false,
            isSampleClockEstablished: true,
            sections: [section],
            wallTime: 100
        )

        let output = PlaybackTransportController.tick(input: input, state: state) { _, _ in
            ArrangementPlaybackEngine.AdvanceResult(
                outcome: .none,
                newTime: 19.5,
                newState: .repeatingSectionAtEnd(section)
            )
        }

        #expect(output.commands.contains(.seekArrangement(19.92)))
        #expect(output.commands.contains(.publishPlayhead(19.92, force: true)))
        #expect(output.commands.contains(.armRepeatAudio(loop: loop, playheadTime: 19.92)))
    }

    @Test func metadataOnlyRepeatStillPrearmsLoopBodyNearBoundary() async {
        let section = makeSection(name: "Chorus", start: 10, end: 20, note: 62)
        let loop = SectionLoopContext(sectionID: section.id, startTime: 10, endTime: 20)

        var state = PlaybackTransportController.TickState(
            loopPrebufferTriggered: false,
            suppressTimelineJumpRestartUntil: nil,
            skipSectionExitHandlingUntil: nil,
            lastAudioTimelineTime: 19.0,
            lastTransportReanchorWallTime: nil
        )

        let input = PlaybackTransportController.TickInput(
            isPlaying: true,
            projectDuration: 60,
            sampleRate: 48_000,
            isSelectionLoopEnabled: false,
            selectionRange: nil,
            audioTime: 19.92,
            arrangementState: .repeatingSectionAtEnd(section),
            arrangementTime: 19.5,
            arrangementIsPlaying: true,
            activeSection: section,
            pendingSection: nil,
            loopPrebufferTriggered: false,
            lastAudioTime: 19.0,
            suppressTimelineJumpRestart: false,
            skipSectionExitHandling: false,
            isSectionLoopActive: true,
            isAnyPlayerPlaying: true,
            hasArmedBoundaryJump: true,
            isSampleClockEstablished: true,
            sections: [section],
            wallTime: 100
        )

        let output = PlaybackTransportController.tick(input: input, state: state) { _, _ in
            ArrangementPlaybackEngine.AdvanceResult(
                outcome: .none,
                newTime: 19.5,
                newState: .repeatingSectionAtEnd(section)
            )
        }

        #expect(output.commands.contains(.armRepeatAudio(loop: loop, playheadTime: 19.92)))
    }

    @Test func repeatArmedDoesNotSchedulePCMRightAfterWrap() async {
        let section = makeSection(name: "Short", start: 10, end: 12, note: 62)
        var state = PlaybackTransportController.TickState(
            loopPrebufferTriggered: false,
            suppressTimelineJumpRestartUntil: nil,
            skipSectionExitHandlingUntil: nil,
            lastAudioTimelineTime: 10.0,
            lastTransportReanchorWallTime: nil
        )

        let input = PlaybackTransportController.TickInput(
            isPlaying: true,
            projectDuration: 60,
            sampleRate: 48_000,
            isSelectionLoopEnabled: false,
            selectionRange: nil,
            audioTime: 10.05,
            arrangementState: .repeatingSectionAtEnd(section),
            arrangementTime: 10.0,
            arrangementIsPlaying: true,
            activeSection: section,
            pendingSection: nil,
            loopPrebufferTriggered: false,
            lastAudioTime: 10.0,
            suppressTimelineJumpRestart: false,
            skipSectionExitHandling: false,
            isSectionLoopActive: true,
            isAnyPlayerPlaying: true,
            hasArmedBoundaryJump: false,
            isSampleClockEstablished: true,
            sections: [section],
            wallTime: 100
        )

        let output = PlaybackTransportController.tick(input: input, state: state) { _, _ in
            ArrangementPlaybackEngine.AdvanceResult(
                outcome: .none,
                newTime: 10.0,
                newState: .repeatingSectionAtEnd(section)
            )
        }

        #expect(!output.commands.contains(where: {
            if case .armRepeatAudio = $0 { return true }
            return false
        }))
    }

    @Test func advanceToAudioTimeHandlesQueuedJump() async {
        let engine = ArrangementPlaybackEngine()
        let verse = makeSection(name: "Verse", start: 0, end: 10, note: 60)
        let chorus = makeSection(name: "Chorus", start: 10, end: 20, note: 62, waitForCurrentToFinish: true)

        engine.configure(sections: [verse, chorus])
        engine.triggerSection(verse)
        engine.play()
        engine.currentTime = 9.5
        _ = engine.triggerSection(chorus)

        let result = engine.advance(to: 10.05, projectDuration: 60)

        #expect(result.outcome == .sectionHandled(previousTime: 9.5, newTime: 10))
        #expect(engine.activeSection?.id == chorus.id)
    }

    @Test func linearPlaybackDoesNotRestartAudioOnForwardCatchUp() async {
        var state = PlaybackTransportController.TickState(
            loopPrebufferTriggered: false,
            suppressTimelineJumpRestartUntil: nil,
            skipSectionExitHandlingUntil: nil,
            lastAudioTimelineTime: 30.0,
            lastTransportReanchorWallTime: nil
        )

        let input = PlaybackTransportController.TickInput(
            isPlaying: true,
            projectDuration: 300,
            sampleRate: 48_000,
            isSelectionLoopEnabled: false,
            selectionRange: nil,
            audioTime: 30.12,
            arrangementState: .idle,
            arrangementTime: 30.0,
            arrangementIsPlaying: true,
            activeSection: nil,
            pendingSection: nil,
            loopPrebufferTriggered: false,
            lastAudioTime: 30.0,
            suppressTimelineJumpRestart: false,
            skipSectionExitHandling: false,
            isSectionLoopActive: false,
            isAnyPlayerPlaying: true,
            hasArmedBoundaryJump: false,
            isSampleClockEstablished: true,
            sections: [],
            wallTime: 200
        )

        let output = PlaybackTransportController.tick(input: input, state: state) { _, _ in
            ArrangementPlaybackEngine.AdvanceResult(
                outcome: .none,
                newTime: 30.12,
                newState: .idle
            )
        }

        #expect(!output.commands.contains(.resolveTimelineAudioJump(30.12)))
        #expect(output.commands.contains(.reanchorTransport(30.12)))
    }

    @Test func boundarySuppressionBlocksReanchorAndSectionExitRestart() async {
        let section = makeSection(name: "Verse", start: 33.389025, end: 37.245079, note: 60)
        let suppressUntil = Date().addingTimeInterval(TransportClock.boundaryRestartSuppression)

        var state = PlaybackTransportController.TickState(
            loopPrebufferTriggered: false,
            suppressTimelineJumpRestartUntil: suppressUntil,
            skipSectionExitHandlingUntil: suppressUntil,
            lastAudioTimelineTime: 33.389025,
            lastTransportReanchorWallTime: nil
        )

        let input = PlaybackTransportController.TickInput(
            isPlaying: true,
            projectDuration: 300,
            sampleRate: 44_100,
            isSelectionLoopEnabled: false,
            selectionRange: nil,
            audioTime: 37.245079,
            arrangementState: .playingSection(section),
            arrangementTime: 33.389025,
            arrangementIsPlaying: true,
            activeSection: section,
            pendingSection: nil,
            loopPrebufferTriggered: false,
            lastAudioTime: 33.389025,
            suppressTimelineJumpRestart: true,
            skipSectionExitHandling: true,
            isSectionLoopActive: false,
            isAnyPlayerPlaying: true,
            hasArmedBoundaryJump: false,
            isSampleClockEstablished: true,
            sections: [section],
            wallTime: 100
        )

        let output = PlaybackTransportController.tick(input: input, state: state) { _, _ in
            ArrangementPlaybackEngine.AdvanceResult(
                outcome: .sectionHandled(previousTime: 33.389025, newTime: 37.245079),
                newTime: 37.245079,
                newState: .continuingTimeline
            )
        }

        #expect(!output.commands.contains(.reanchorTransport(37.245079)))
        #expect(!output.commands.contains(.restartAudioAfterSectionExit(37.245079, hadActiveLoop: false)))
    }

    @Test func suppressedRepeatBoundaryDoesNotFireAgain() async {
        let section = makeSection(name: "Verse", start: 10, end: 20, note: 60)
        let loop = SectionLoopContext(sectionID: section.id, startTime: 10, endTime: 20)
        let suppressUntil = Date().addingTimeInterval(TransportClock.boundaryRestartSuppression)
        let state = PlaybackTransportController.TickState(
            loopPrebufferTriggered: false,
            suppressTimelineJumpRestartUntil: suppressUntil,
            skipSectionExitHandlingUntil: suppressUntil,
            lastAudioTimelineTime: 20,
            lastTransportReanchorWallTime: nil
        )
        let input = PlaybackTransportController.TickInput(
            isPlaying: true,
            projectDuration: 60,
            sampleRate: 44_100,
            isSelectionLoopEnabled: false,
            selectionRange: nil,
            audioTime: 20,
            arrangementState: .repeatingSectionAtEnd(section),
            arrangementTime: 10,
            arrangementIsPlaying: true,
            activeSection: section,
            pendingSection: nil,
            loopPrebufferTriggered: false,
            lastAudioTime: 20,
            suppressTimelineJumpRestart: true,
            skipSectionExitHandling: true,
            isSectionLoopActive: true,
            isAnyPlayerPlaying: true,
            hasArmedBoundaryJump: true,
            isSampleClockEstablished: true,
            sections: [section],
            wallTime: 100
        )
        let output = PlaybackTransportController.tick(input: input, state: state) { _, _ in
            ArrangementPlaybackEngine.AdvanceResult(
                outcome: .none,
                newTime: 10,
                newState: .repeatingSectionAtEnd(section)
            )
        }
        #expect(!output.commands.contains(.completeRepeatBoundary(section: section, loop: loop)))
        #expect(output.commands.contains(.publishPlayhead(20, force: true)))
    }

    @Test func justWrappedClockStuckAtEndDoesNotRetrigger() async {
        let section = makeSection(name: "Verse", start: 10, end: 20, note: 60)
        let loop = SectionLoopContext(sectionID: section.id, startTime: 10, endTime: 20)
        let state = PlaybackTransportController.TickState(
            loopPrebufferTriggered: false,
            suppressTimelineJumpRestartUntil: nil,
            skipSectionExitHandlingUntil: nil,
            lastAudioTimelineTime: 10,
            lastTransportReanchorWallTime: nil
        )
        let input = PlaybackTransportController.TickInput(
            isPlaying: true,
            projectDuration: 60,
            sampleRate: 44_100,
            isSelectionLoopEnabled: false,
            selectionRange: nil,
            audioTime: 20,
            arrangementState: .repeatingSectionAtEnd(section),
            arrangementTime: 10,
            arrangementIsPlaying: true,
            activeSection: section,
            pendingSection: nil,
            loopPrebufferTriggered: false,
            lastAudioTime: 10.05,
            suppressTimelineJumpRestart: false,
            skipSectionExitHandling: false,
            isSectionLoopActive: true,
            isAnyPlayerPlaying: true,
            hasArmedBoundaryJump: true,
            isSampleClockEstablished: true,
            sections: [section],
            wallTime: 100
        )
        let output = PlaybackTransportController.tick(input: input, state: state) { _, _ in
            ArrangementPlaybackEngine.AdvanceResult(
                outcome: .none,
                newTime: 10,
                newState: .repeatingSectionAtEnd(section)
            )
        }
        #expect(!output.commands.contains(.completeRepeatBoundary(section: section, loop: loop)))
        #expect(output.commands.contains(.publishPlayhead(10, force: true)))
    }

    @Test func forwardCatchUpUsesReanchorNotFullRestart() async {
        #expect(
            TransportClock.needsTransportReanchor(
                lastAudioTime: 30.0,
                transportTime: 30.12,
                previousArrangementTime: 30.0,
                isSectionTransition: false,
                lastReanchorWallTime: nil,
                wallTime: 100
            )
        )
    }

    @Test func repeatWrapStaleClockDoesNotReanchorForward() async {
        let section = ArrangementSection(
            name: "Verse",
            startTime: 33.389025,
            endTime: 37.245079,
            colorHex: "#FF0000",
            midiNote: 60,
            playbackMode: .continueTimeline,
            waitForCurrentToFinish: false
        )
        #expect(
            TransportClock.isRepeatWrapStaleRenderClock(
                arrangementTime: 33.389025,
                transportTime: 37.245079,
                sectionStart: section.startTime,
                sectionEnd: section.endTime
            )
        )
        #expect(
            !TransportClock.needsTransportReanchor(
                lastAudioTime: 33.389025,
                transportTime: 37.245079,
                previousArrangementTime: 33.389025,
                isSectionTransition: false,
                lastReanchorWallTime: nil,
                wallTime: 100,
                activeSection: section
            )
        )
    }

    @Test func backwardTimelineMoveRequestsAudioResync() async {
        #expect(
            TransportClock.requiresAudioResyncAfterTimelineMove(
                from: 40,
                to: 10,
                isSectionTransition: false
            )
        )
        #expect(
            !TransportClock.requiresAudioResyncAfterTimelineMove(
                from: 30,
                to: 30.12,
                isSectionTransition: false
            )
        )
    }

    @Test func playingSectionArmsLinearContinuationNearEnd() async {
        let section = makeSection(name: "Verse", start: 10, end: 20, note: 60)
        let state = PlaybackTransportController.TickState(
            loopPrebufferTriggered: false,
            suppressTimelineJumpRestartUntil: nil,
            skipSectionExitHandlingUntil: nil,
            lastAudioTimelineTime: 19.0,
            lastTransportReanchorWallTime: nil
        )
        let input = PlaybackTransportController.TickInput(
            isPlaying: true,
            projectDuration: 60,
            sampleRate: 48_000,
            isSelectionLoopEnabled: false,
            selectionRange: nil,
            audioTime: 19.2,
            arrangementState: .playingSection(section),
            arrangementTime: 19.2,
            arrangementIsPlaying: true,
            activeSection: section,
            pendingSection: nil,
            loopPrebufferTriggered: false,
            lastAudioTime: 19.0,
            suppressTimelineJumpRestart: false,
            skipSectionExitHandling: false,
            isSectionLoopActive: false,
            isAnyPlayerPlaying: true,
            hasArmedBoundaryJump: false,
            isSampleClockEstablished: true,
            sections: [section],
            wallTime: 100
        )
        let output = PlaybackTransportController.tick(input: input, state: state) { _, _ in
            ArrangementPlaybackEngine.AdvanceResult(
                outcome: .none,
                newTime: 19.2,
                newState: .playingSection(section)
            )
        }
        #expect(output.commands.contains { command in
            if case .armLinearContinuation(let sectionEnd, _) = command {
                return abs(sectionEnd - 20) < 0.001
            }
            return false
        })
    }

    @Test func playingSectionDoesNotArmContinuationTooEarly() async {
        let section = makeSection(name: "Verse", start: 10, end: 20, note: 60)
        let state = PlaybackTransportController.TickState(
            loopPrebufferTriggered: false,
            suppressTimelineJumpRestartUntil: nil,
            skipSectionExitHandlingUntil: nil,
            lastAudioTimelineTime: 18.0,
            lastTransportReanchorWallTime: nil
        )
        let input = PlaybackTransportController.TickInput(
            isPlaying: true,
            projectDuration: 60,
            sampleRate: 48_000,
            isSelectionLoopEnabled: false,
            selectionRange: nil,
            audioTime: 18.5,
            arrangementState: .playingSection(section),
            arrangementTime: 18.5,
            arrangementIsPlaying: true,
            activeSection: section,
            pendingSection: nil,
            loopPrebufferTriggered: false,
            lastAudioTime: 18.0,
            suppressTimelineJumpRestart: false,
            skipSectionExitHandling: false,
            isSectionLoopActive: false,
            isAnyPlayerPlaying: true,
            hasArmedBoundaryJump: false,
            isSampleClockEstablished: true,
            sections: [section],
            wallTime: 100
        )
        let output = PlaybackTransportController.tick(input: input, state: state) { _, _ in
            ArrangementPlaybackEngine.AdvanceResult(
                outcome: .none,
                newTime: 18.5,
                newState: .playingSection(section)
            )
        }
        #expect(!output.commands.contains { command in
            if case .armLinearContinuation = command { return true }
            return false
        })
    }

    @Test func loopActiveDoesNotArmLinearContinuation() async {
        let section = makeSection(name: "Verse", start: 10, end: 20, note: 60)
        let state = PlaybackTransportController.TickState(
            loopPrebufferTriggered: false,
            suppressTimelineJumpRestartUntil: nil,
            skipSectionExitHandlingUntil: nil,
            lastAudioTimelineTime: 18.0,
            lastTransportReanchorWallTime: nil
        )
        let input = PlaybackTransportController.TickInput(
            isPlaying: true,
            projectDuration: 60,
            sampleRate: 48_000,
            isSelectionLoopEnabled: false,
            selectionRange: nil,
            audioTime: 18.2,
            arrangementState: .playingSection(section),
            arrangementTime: 18.2,
            arrangementIsPlaying: true,
            activeSection: section,
            pendingSection: nil,
            loopPrebufferTriggered: false,
            lastAudioTime: 18.0,
            suppressTimelineJumpRestart: false,
            skipSectionExitHandling: false,
            isSectionLoopActive: true,
            isAnyPlayerPlaying: true,
            hasArmedBoundaryJump: false,
            isSampleClockEstablished: true,
            sections: [section],
            wallTime: 100
        )
        let output = PlaybackTransportController.tick(input: input, state: state) { _, _ in
            ArrangementPlaybackEngine.AdvanceResult(
                outcome: .none,
                newTime: 18.2,
                newState: .playingSection(section)
            )
        }
        #expect(!output.commands.contains { command in
            if case .armLinearContinuation = command { return true }
            return false
        })
    }

    @Test func isPlayheadOffScreenDetectsFarJump() async {
        #expect(
            TransportClock.isPlayheadOffScreen(
                time: 50,
                pixelsPerSecond: 100,
                visibleOffsetX: 0,
                viewportWidth: 800
            )
        )
        #expect(
            !TransportClock.isPlayheadOffScreen(
                time: 2,
                pixelsPerSecond: 100,
                visibleOffsetX: 0,
                viewportWidth: 800
            )
        )
    }
}

private func makeSection(
    name: String,
    start: TimeInterval,
    end: TimeInterval,
    note: UInt8,
    waitForCurrentToFinish: Bool = true
) -> ArrangementSection {
    ArrangementSection(
        name: name,
        startTime: start,
        endTime: end,
        colorHex: SectionMarkerPalette.hex(forName: name, index: Int(note - 60)),
        midiNote: note,
        playbackMode: .continueTimeline,
        waitForCurrentToFinish: waitForCurrentToFinish
    )
}
