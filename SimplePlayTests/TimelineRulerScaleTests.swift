//
//  TimelineRulerScaleTests.swift
//  SimplePlayTests
//

import CoreGraphics
import Testing
@testable import SimplePlay

struct TimelineRulerScaleTests {
    @Test func picksSecondIntervalsWhenZoomedIn() {
        #expect(TimelineRulerScale.majorTickInterval(pixelsPerSecond: 200) == 1)
        #expect(TimelineRulerScale.majorTickInterval(pixelsPerSecond: 120) == 1)
        #expect(TimelineRulerScale.majorTickInterval(pixelsPerSecond: 100) == 1)
        #expect(TimelineRulerScale.majorTickInterval(pixelsPerSecond: 50) == 5)
        #expect(TimelineRulerScale.majorTickInterval(pixelsPerSecond: 40) == 5)
    }

    @Test func picksMinuteIntervalsAtMediumZoom() {
        #expect(TimelineRulerScale.majorTickInterval(pixelsPerSecond: 20) == 5)
        #expect(TimelineRulerScale.majorTickInterval(pixelsPerSecond: 10) == 10)
        #expect(TimelineRulerScale.majorTickInterval(pixelsPerSecond: 6) == 15)
        #expect(TimelineRulerScale.majorTickInterval(pixelsPerSecond: 3) == 30)
        #expect(TimelineRulerScale.majorTickInterval(pixelsPerSecond: 1.5) == 60)
    }

    @Test func picksFiveMinuteIntervalsWhenZoomedOut() {
        #expect(TimelineRulerScale.majorTickInterval(pixelsPerSecond: 0.8) == 120)
        #expect(TimelineRulerScale.majorTickInterval(pixelsPerSecond: 0.4) == 300)
        #expect(TimelineRulerScale.majorTickInterval(pixelsPerSecond: 0.1) == 900)
    }

    @Test func formatsLabelsForCoarseTicks() {
        #expect(TimelineRulerScale.formatRulerLabel(300, tickInterval: 300) == "5:00")
        #expect(TimelineRulerScale.formatRulerLabel(600, tickInterval: 300) == "10:00")
        #expect(TimelineRulerScale.formatRulerLabel(90, tickInterval: 60) == "1:30")
        #expect(TimelineRulerScale.formatRulerLabel(15, tickInterval: 5) == "0:15")
    }
}
