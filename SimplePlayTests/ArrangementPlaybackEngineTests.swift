//
//  ArrangementPlaybackEngineTests.swift
//  SimplePlayTests
//

import Testing
@testable import SimplePlay

@MainActor
struct ArrangementPlaybackEngineTests {
    @Test func repeatsSectionUntilAnotherTrigger() async {
        let engine = ArrangementPlaybackEngine()
        let chorus = ArrangementSection(
            name: "Chorus",
            startTime: 10,
            endTime: 20,
            midiNote: 62,
            playbackMode: .repeatSection
        )
        engine.configure(sections: [chorus])
        engine.triggerSection(midiNote: 62)
        engine.play()

        engine.currentTime = 19.9
        engine.tick(delta: 0.2, projectDuration: 60)

        #expect(engine.currentTime == 10)
    }

    @Test func waitsForCurrentSectionBeforeJumping() async {
        let engine = ArrangementPlaybackEngine()
        let chorus = ArrangementSection(
            name: "Chorus",
            startTime: 10,
            endTime: 20,
            midiNote: 62,
            playbackMode: .repeatSection,
            waitForCurrentToFinish: true
        )
        let verse = ArrangementSection(
            name: "Verse",
            startTime: 0,
            endTime: 10,
            midiNote: 60,
            playbackMode: .repeatSection,
            waitForCurrentToFinish: true
        )
        engine.configure(sections: [verse, chorus])
        engine.triggerSection(midiNote: 62)
        engine.play()
        engine.currentTime = 15
        engine.triggerSection(midiNote: 60)

        engine.tick(delta: 5, projectDuration: 60)
        #expect(engine.currentTime == 0)
    }
}
