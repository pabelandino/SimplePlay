//
//  ArrangementPlaybackEngineTests.swift
//  SimplePlayTests
//

import Foundation
import Testing
@testable import SimplePlay

@MainActor
struct ArrangementPlaybackEngineTests {
    @Test func repeatsSectionUntilAnotherTrigger() async {
        let engine = ArrangementPlaybackEngine()
        let chorus = makeSection(
            name: "Chorus",
            start: 10,
            end: 20,
            note: 62
        )
        engine.configure(sections: [chorus])
        engine.triggerSection(chorus)
        engine.play()

        engine.currentTime = 19.9
        engine.tick(delta: 0.2, projectDuration: 60)

        #expect(engine.currentTime == 10)
    }

    @Test func waitsForCurrentSectionBeforeJumping() async {
        let engine = ArrangementPlaybackEngine()
        let chorus = makeSection(
            name: "Chorus",
            start: 10,
            end: 20,
            note: 62
        )
        let verse = makeSection(
            name: "Verse",
            start: 0,
            end: 10,
            note: 60
        )
        engine.configure(sections: [verse, chorus])
        engine.triggerSection(chorus)
        engine.play()
        engine.currentTime = 15
        engine.triggerSection(verse)

        engine.tick(delta: 5, projectDuration: 60)
        #expect(engine.currentTime == 0)
    }

    @Test func queuesNextSectionWhileRepeatEnabled() async {
        let engine = ArrangementPlaybackEngine()
        let verse = makeSection(name: "Verse", start: 0, end: 10, note: 60)
        let chorus = makeSection(name: "Chorus", start: 10, end: 20, note: 62)

        engine.configure(sections: [verse, chorus])
        engine.isRepeatEnabled = true
        engine.triggerSection(verse)
        engine.play()
        engine.currentTime = 5
        engine.triggerSection(chorus)

        #expect(engine.pendingSection?.id == chorus.id)
        #expect(engine.currentTime == 5)

        engine.setRepeatEnabled(false)
        engine.currentTime = 9.9
        engine.tick(delta: 0.2, projectDuration: 60)

        #expect(engine.currentTime == 10)
        #expect(engine.activeSection?.id == chorus.id)
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
            playbackMode: .repeatSection,
            waitForCurrentToFinish: true
        )
    }
}
