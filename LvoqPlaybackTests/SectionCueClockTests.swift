//
//  SectionCueClockTests.swift
//  LvoqPlaybackTests
//

import AVFoundation
import Foundation
import Testing
@testable import LvoqPlayback

@Suite struct SectionCueClockTests {
    @Test func remainingNeverNegative() {
        #expect(SectionCueClock.remaining(to: 10, playhead: 12) == 0)
    }

    @Test func remainingAtArmIsDistanceToCut() {
        #expect(SectionCueClock.remaining(to: 20, playhead: 17.5) == 2.5)
    }

    @Test func remainingAfterWrapEqualsSectionDuration() {
        let loopStart: TimeInterval = 10
        let loopEnd: TimeInterval = 20
        #expect(SectionCueClock.remaining(to: loopEnd, playhead: loopStart) == 10)
    }

    @Test func cueHostTimeAddsRemainingWithoutLeadIn() {
        let remaining: TimeInterval = 2.5
        let renderHost: UInt64 = 1_000_000_000
        let expected = renderHost &+ AVAudioTime.hostTime(forSeconds: remaining)
        #expect(
            SectionCueClock.cueHostTime(remaining: remaining, renderHostTime: renderHost)
                == expected
        )
    }

    @Test func makeCueHostTimeNilWhenAlreadyAtBoundary() {
        #expect(
            SectionCueClock.makeCueHostTime(
                remaining: 0,
                renderHostTime: 1_000,
                isHostTimeValid: true
            ) == nil
        )
    }

    @Test func makeCueHostTimeNilWhenRenderClockInvalid() {
        #expect(
            SectionCueClock.makeCueHostTime(
                remaining: 1,
                renderHostTime: 1_000,
                isHostTimeValid: false
            ) == nil
        )
    }

    @Test func makeCueHostTimeMatchesCueHostTime() {
        let remaining: TimeInterval = 0.35
        let renderHost: UInt64 = 42
        #expect(
            SectionCueClock.makeCueHostTime(
                remaining: remaining,
                renderHostTime: renderHost,
                isHostTimeValid: true
            ) == SectionCueClock.cueHostTime(remaining: remaining, renderHostTime: renderHost)
        )
    }

    @Test func prerollEatsOneIOCycleButKeepsCueInTheFuture() {
        #expect(SectionCueClock.preroll(forRemaining: 1.45) == SectionCueClock.cutPrerollSeconds)
        #expect(
            abs(
                SectionCueClock.cueRemaining(toBoundary: 1.45)
                    - (1.45 - SectionCueClock.cutPrerollSeconds)
            ) < 0.0001
        )
        #expect(SectionCueClock.preroll(forRemaining: 0.01) == 0)
        #expect(
            abs(SectionCueClock.cueRemaining(toBoundary: 0.05) - SectionCueClock.minFutureCueSeconds)
                < 0.0001
        )
    }

    @Test func fillSilenceLeavesStartLeadBeforeTheBody() {
        #expect(
            abs(SectionCueClock.fillSilenceSeconds(remaining: 2.17, startLead: 0.02) - 2.15) < 0.0001
        )
        #expect(SectionCueClock.fillSilenceSeconds(remaining: 0.01, startLead: 0.02) == 0)
    }

    @Test func oneRenderSnapshotKeepsEveryClipOnTheSameCut() {
        let remaining: TimeInterval = 2.624535
        let renderHost: UInt64 = 9_000_000
        let first = SectionCueClock.cueHostTime(remaining: remaining, renderHostTime: renderHost)
        let last = SectionCueClock.cueHostTime(remaining: remaining, renderHostTime: renderHost)
        #expect(first == last)
    }
}
