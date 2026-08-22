//
//  PlaybackDeltaPolicyTests.swift
//  SimplePlayTests
//

import Foundation
import Testing
@testable import SimplePlay

struct PlaybackDeltaPolicyTests {
    @Test func acceptsNormalForwardDelta() {
        let result = PlaybackDeltaPolicy.resolve(
            previousArrangementTime: 10,
            audioTime: 10.04,
            projectDuration: 120,
            suppressJumpRestart: false
        )

        #expect(abs(result.delta - 0.04) < 0.0001)
        #expect(!result.shouldSeekArrangementToAudio)
    }

    @Test func rejectsNegativeDelta() {
        let result = PlaybackDeltaPolicy.resolve(
            previousArrangementTime: 20,
            audioTime: 19.5,
            projectDuration: 120,
            suppressJumpRestart: false
        )

        #expect(result.delta == 0)
    }

    @Test func suppressJumpRestartResyncsLargeForwardDelta() {
        let result = PlaybackDeltaPolicy.resolve(
            previousArrangementTime: 10,
            audioTime: 18,
            projectDuration: 120,
            suppressJumpRestart: true
        )

        #expect(result.shouldSeekArrangementToAudio)
        #expect(result.delta == 0.5)
    }

    @Test func moderateDriftResyncsWithoutAdvancing() {
        let result = PlaybackDeltaPolicy.resolve(
            previousArrangementTime: 10,
            audioTime: 10.8,
            projectDuration: 120,
            suppressJumpRestart: false
        )

        #expect(result.delta == 0)
        #expect(result.shouldSeekArrangementToAudio)
        #expect(result.logsDriftSync)
    }

    @Test func ignoresStaleClockJump() {
        let result = PlaybackDeltaPolicy.resolve(
            previousArrangementTime: 10,
            audioTime: 25,
            projectDuration: 120,
            suppressJumpRestart: false
        )

        #expect(result.delta == 0)
        #expect(result.logsIgnoredJump)
        #expect(!result.shouldSeekArrangementToAudio)
    }
}
