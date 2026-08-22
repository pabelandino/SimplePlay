//
//  SectionStandbyCoordinatorTests.swift
//  SimplePlayTests
//

import Foundation
import Testing
@testable import SimplePlay

@Suite struct SectionStandbyCoordinatorTests {
    @Test func ignoresBufferEndBeforeStandbyHasStarted() {
        #expect(
            !SectionStandbyCoordinator.shouldChainFromBufferEnd(
                endedGeneration: 1,
                playingGeneration: 0
            )
        )
    }

    @Test func ignoresStaleBufferEndAfterReprime() {
        #expect(
            !SectionStandbyCoordinator.shouldChainFromBufferEnd(
                endedGeneration: 1,
                playingGeneration: 2
            )
        )
    }

    @Test func chainsWhenPlayingGenerationMatches() {
        #expect(
            SectionStandbyCoordinator.shouldChainFromBufferEnd(
                endedGeneration: 3,
                playingGeneration: 3
            )
        )
    }

    @Test func ignoresCuedBufferEndSoPlayAtKeepsOwnership() {
        #expect(
            !SectionStandbyCoordinator.shouldChainFromBufferEnd(
                endedGeneration: 3,
                playingGeneration: 3,
                isCued: true
            )
        )
    }

    @Test func cuedStandbyDoesNotNeedImmediateStart() {
        #expect(!SectionStandbyCoordinator.needsImmediateStart(standbyIsPlaying: true))
        #expect(SectionStandbyCoordinator.needsImmediateStart(standbyIsPlaying: false))
        #expect(
            !SectionStandbyCoordinator.needsImmediateStart(
                standbyIsPlaying: false,
                isCued: true
            )
        )
    }

    @Test func doesNotPauseCuedStandby() {
        #expect(
            !SectionStandbyCoordinator.shouldPauseRetiredStandby(
                isCued: true,
                standbyIsLive: false,
                incomingLiveIsRendering: true
            )
        )
    }

    @Test func doesNotPauseOutgoingCapBeforeIncomingRenders() {
        #expect(
            !SectionStandbyCoordinator.shouldPauseRetiredStandby(
                isCued: false,
                standbyIsLive: false,
                incomingLiveIsRendering: false
            )
        )
    }

    @Test func pausesRetiredCapOnceIncomingIsRendering() {
        #expect(
            SectionStandbyCoordinator.shouldPauseRetiredStandby(
                isCued: false,
                standbyIsLive: false,
                incomingLiveIsRendering: true
            )
        )
    }

    @Test func skipsRearmWhenLoopAlreadyCued() {
        #expect(
            SectionStandbyCoordinator.shouldSkipRearm(
                currentIntent: .loopBody,
                expectedIntent: .loopBody,
                hasPrimeOrCue: true
            )
        )
    }

    @Test func doesNotSkipRearmWhenSwitchingToContinuation() {
        #expect(
            !SectionStandbyCoordinator.shouldSkipRearm(
                currentIntent: .loopBody,
                expectedIntent: .continuation,
                hasPrimeOrCue: true
            )
        )
    }
}
