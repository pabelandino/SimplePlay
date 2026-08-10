//
//  TimelineSampleGridTests.swift
//  SimplePlayTests
//

import Testing
@testable import SimplePlay

struct TimelineSampleGridTests {
    @Test func quantizeAlignsToSampleGrid() {
        let sampleRate = 48_000.0
        let time = TimelineSampleGrid.quantize(1.000_010, sampleRate: sampleRate)
        #expect(time == 1.0)
    }

    @Test func snapSectionBoundaryUsesGridThenSamples() {
        let time = TimelineSampleGrid.snapSectionBoundary(
            1.12,
            snapInterval: 0.25,
            snapEnabled: true,
            sampleRate: 48_000
        )
        #expect(time == 1.125)
    }

    @Test func framesAndTimeRoundTrip() {
        let sampleRate = 44_100.0
        let frame = TimelineSampleGrid.frames(at: 2.5, sampleRate: sampleRate)
        let time = TimelineSampleGrid.timeFromFrame(frame, sampleRate: sampleRate)
        #expect(time == TimelineSampleGrid.quantize(2.5, sampleRate: sampleRate))
    }
}
