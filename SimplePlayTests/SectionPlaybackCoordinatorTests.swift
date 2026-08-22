//
//  SectionPlaybackCoordinatorTests.swift
//  SimplePlayTests
//

import Foundation
import Testing
@testable import SimplePlay

@Suite struct SectionPlaybackCoordinatorTests {
    private func makeSection(start: TimeInterval, end: TimeInterval) -> ArrangementSection {
        ArrangementSection(
            name: "Test",
            startTime: start,
            endTime: end,
            colorHex: "#FF0000",
            midiNote: 60,
            playbackMode: .continueTimeline,
            waitForCurrentToFinish: false
        )
    }

    @Test func linearCapWhilePlayingSection() {
        let section = makeSection(start: 10, end: 20)
        let cap = SectionPlaybackCoordinator.linearScheduleCap(
            arrangementState: .playingSection(section),
            activeSection: section,
            pendingSection: nil
        )
        #expect(cap == 20)
    }

    @Test func linearCapWhileRepeatArmed() {
        let section = makeSection(start: 10, end: 20)
        let cap = SectionPlaybackCoordinator.linearScheduleCap(
            arrangementState: .repeatingSectionAtEnd(section),
            activeSection: section,
            pendingSection: nil
        )
        #expect(cap == 20)
    }

    @Test func repeatArmedPhaseBeforeBoundary() {
        let section = makeSection(start: 10, end: 20)
        let phase = SectionPlaybackCoordinator.resolveRepeatBoundaryPhase(
            arrangementState: .repeatingSectionAtEnd(section),
            audioTime: 15,
            sampleRate: 44_100
        )
        guard case .repeatArmed(let audioTime, _, _) = phase else {
            Issue.record("Expected repeatArmed")
            return
        }
        #expect(audioTime == 15)
    }

    @Test func repeatBoundaryPhaseAtSectionEnd() {
        let section = makeSection(start: 10, end: 20)
        let phase = SectionPlaybackCoordinator.resolveRepeatBoundaryPhase(
            arrangementState: .repeatingSectionAtEnd(section),
            audioTime: 20,
            sampleRate: 44_100
        )
        guard case .repeatBoundary = phase else {
            Issue.record("Expected repeatBoundary")
            return
        }
    }

    @Test func shouldPrearmRepeatWhenNearSectionEnd() {
        let loop = SectionLoopContext(sectionID: UUID(), startTime: 10, endTime: 20)
        #expect(
            SectionPlaybackCoordinator.shouldPrearmRepeatAudio(
                loop: loop,
                playheadTime: 19.92,
                alreadyArmed: false
            )
        )
        #expect(
            !SectionPlaybackCoordinator.shouldPrearmRepeatAudio(
                loop: loop,
                playheadTime: 15,
                alreadyArmed: false
            )
        )
        #expect(
            !SectionPlaybackCoordinator.shouldPrearmRepeatAudio(
                loop: loop,
                playheadTime: 19.92,
                alreadyArmed: true
            )
        )
    }

    @Test func shouldNotPrearmInTheFirstIOCyclesAfterWrap() {
        let shortLoop = SectionLoopContext(sectionID: UUID(), startTime: 10, endTime: 12)
        #expect(
            !SectionPlaybackCoordinator.shouldPrearmRepeatAudio(
                loop: shortLoop,
                playheadTime: 10.05,
                alreadyArmed: false
            )
        )
        #expect(
            SectionPlaybackCoordinator.shouldPrearmRepeatAudio(
                loop: shortLoop,
                playheadTime: 10.30,
                alreadyArmed: false
            )
        )
    }

    @Test func shouldPrearmImmediatelyWhenRemainingIsTiny() {
        let tinyLoop = SectionLoopContext(sectionID: UUID(), startTime: 10, endTime: 10.4)
        #expect(
            SectionPlaybackCoordinator.shouldPrearmRepeatAudio(
                loop: tinyLoop,
                playheadTime: 10.02,
                alreadyArmed: false
            )
        )
    }

    @Test func followAudioDeltaOutsideRepeatArmed() {
        let section = makeSection(start: 10, end: 20)
        let phase = SectionPlaybackCoordinator.resolveRepeatBoundaryPhase(
            arrangementState: .playingSection(section),
            audioTime: 15,
            sampleRate: 44_100
        )
        #expect(phase == .followAudioDelta)
    }
}
