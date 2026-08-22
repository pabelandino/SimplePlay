//
//  ArrangementPlaybackEngineAdvanceTests.swift
//  SimplePlayTests
//

import Foundation
import Testing
@testable import SimplePlay

@MainActor
struct ArrangementPlaybackEngineAdvanceTests {
    @Test func repeatingSectionDoesNotAdvancePastEnd() async {
        let engine = ArrangementPlaybackEngine()
        let section = makeSection(name: "Chorus", start: 10, end: 20, note: 62)

        engine.configure(sections: [section])
        engine.triggerSection(section)
        engine.play()
        _ = engine.triggerSection(section)

        let result = engine.advance(to: 25, projectDuration: 60)

        #expect(result.outcome == .none)
        #expect(engine.currentTime == 20)
    }

    @Test func playingSectionIgnoresEndClockWhileAtStartAfterRepeatWrap() async {
        let engine = ArrangementPlaybackEngine()
        let section = makeSection(name: "Verse", start: 32.962880, end: 36.836916, note: 60)

        engine.configure(sections: [section])
        engine.triggerSection(section)
        engine.play()
        engine.currentTime = 35
        _ = engine.triggerSection(section)
        engine.completeRepeatAtEndBoundary(for: section)

        let result = engine.advance(to: 36.836916, projectDuration: 120)

        #expect(result.outcome == .none)
        #expect(engine.currentTime == 32.962880)
        if case .playingSection(let active) = engine.state {
            #expect(active.id == section.id)
        } else {
            Issue.record("Expected playingSection after repeat wrap guard")
        }
    }

    @Test func continuingTimelineStopsAtProjectEnd() async {
        let engine = ArrangementPlaybackEngine()
        let section = makeSection(name: "Chorus", start: 10, end: 20, note: 62)

        engine.configure(sections: [section])
        engine.triggerSection(section)
        engine.play()
        engine.currentTime = 19.9
        engine.tick(delta: 0.2, projectDuration: 60)

        #expect(engine.state == .continuingTimeline)
        engine.currentTime = 59

        let result = engine.advance(to: 61, projectDuration: 60)

        #expect(result.outcome == .reachedProjectEnd)
        #expect(!engine.isPlaying)
    }
}

private func makeSection(
    name: String,
    start: TimeInterval,
    end: TimeInterval,
    note: UInt8
) -> ArrangementSection {
    ArrangementSection(
        name: name,
        startTime: start,
        endTime: end,
        colorHex: SectionMarkerPalette.hex(forName: name, index: Int(note - 60)),
        midiNote: note,
        playbackMode: .continueTimeline,
        waitForCurrentToFinish: true
    )
}
