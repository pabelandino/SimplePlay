//
//  ArrangementPlaybackEngineTests.swift
//  SimplePlayTests
//

import Foundation
import Testing
@testable import SimplePlay

@MainActor
struct ArrangementPlaybackEngineTests {
    @Test func globalLoopRepeatsSectionWhenEnabled() async {
        let engine = ArrangementPlaybackEngine()
        let chorus = makeSection(
            name: "Chorus",
            start: 10,
            end: 20,
            note: 62
        )
        engine.configure(sections: [chorus])
        engine.setRepeatEnabled(true)
        engine.triggerSection(chorus)
        engine.play()

        engine.currentTime = 19.9
        engine.tick(delta: 0.2, projectDuration: 60)

        #expect(engine.currentTime == 10)
    }

    @Test func doesNotRepeatWithoutSamePadOrLoopMode() async {
        let engine = ArrangementPlaybackEngine()
        let chorus = makeSection(name: "Chorus", start: 10, end: 20, note: 62)

        engine.configure(sections: [chorus])
        engine.triggerSection(chorus)
        engine.play()

        engine.currentTime = 19.9
        engine.tick(delta: 0.2, projectDuration: 60)

        #expect(engine.state == .continuingTimeline)
        #expect(engine.activeSection == nil)
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
        engine.setRepeatEnabled(true)
        engine.triggerSection(verse)
        engine.play()
        engine.currentTime = 5
        _ = engine.triggerSection(chorus)

        #expect(engine.pendingSection?.id == chorus.id)
        #expect(engine.currentTime == 5)

        engine.setRepeatEnabled(false)
        engine.currentTime = 9.9
        engine.tick(delta: 0.2, projectDuration: 60)

        #expect(engine.currentTime == 10)
        #expect(engine.activeSection?.id == chorus.id)
    }

    @Test func repeatsSameSectionAfterSecondTrigger() async {
        let engine = ArrangementPlaybackEngine()
        let section = makeSection(name: "Chorus", start: 10, end: 20, note: 62)

        engine.configure(sections: [section])
        engine.triggerSection(section)
        engine.play()
        engine.currentTime = 15
        _ = engine.triggerSection(section)

        #expect(engine.currentTime == 15)

        engine.currentTime = 19.9
        engine.tick(delta: 0.2, projectDuration: 60)

        #expect(engine.currentTime == 10)
        #expect(engine.activeSection?.id == section.id)
        #expect(engine.state == .playingSection(section))
    }

    @Test func continuesNormallyAfterRepeatWithoutSamePadPress() async {
        let engine = ArrangementPlaybackEngine()
        let section = makeSection(name: "Chorus", start: 10, end: 20, note: 62)

        engine.configure(sections: [section])
        engine.triggerSection(section)
        engine.play()
        engine.currentTime = 15
        _ = engine.triggerSection(section)

        engine.currentTime = 19.9
        engine.tick(delta: 0.2, projectDuration: 60)
        #expect(engine.currentTime == 10)

        engine.currentTime = 19.9
        engine.tick(delta: 0.2, projectDuration: 60)

        #expect(engine.state == .continuingTimeline)
        #expect(engine.activeSection == nil)
    }

    @Test func continuesNormallyAfterJumpWithoutSamePadPress() async {
        let engine = ArrangementPlaybackEngine()
        let verse = makeSection(name: "Verse", start: 0, end: 10, note: 60)
        let chorus = makeSection(name: "Chorus", start: 10, end: 20, note: 62)

        engine.configure(sections: [verse, chorus])
        engine.triggerSection(chorus)
        engine.play()
        engine.currentTime = 15
        _ = engine.triggerSection(verse)

        engine.currentTime = 19.9
        engine.tick(delta: 0.2, projectDuration: 60)
        #expect(engine.activeSection?.id == verse.id)

        engine.currentTime = 9.9
        engine.tick(delta: 0.2, projectDuration: 60)

        #expect(engine.state == .continuingTimeline)
        #expect(engine.activeSection == nil)
    }

    @Test func repeatWorksWhenPlaybackStartedWithTransport() async {
        let engine = ArrangementPlaybackEngine()
        let section = makeSection(name: "Chorus", start: 10, end: 20, note: 62)

        engine.configure(sections: [section])
        engine.seek(to: 15)
        engine.play()

        _ = engine.triggerSection(section)

        #expect(engine.state == .repeatingSectionAtEnd(section))

        engine.currentTime = 19.9
        engine.tick(delta: 0.2, projectDuration: 60)

        #expect(engine.currentTime == 10)
        #expect(engine.activeSection?.id == section.id)
    }

    @Test func queuesJumpWhenPlaybackStartedWithTransport() async {
        let engine = ArrangementPlaybackEngine()
        let verse = makeSection(name: "Verse", start: 0, end: 10, note: 60)
        let chorus = makeSection(name: "Chorus", start: 10, end: 20, note: 62)

        engine.configure(sections: [verse, chorus])
        engine.seek(to: 15)
        engine.play()

        let result = engine.triggerSection(verse)

        #expect(result == .queuedForEnd)
        #expect(engine.pendingSection?.id == verse.id)
        #expect(engine.currentTime == 15)

        engine.currentTime = 19.9
        engine.tick(delta: 0.2, projectDuration: 60)

        #expect(engine.activeSection?.id == verse.id)
        #expect(engine.currentTime == 0)
    }

    @Test func nestedMarkersPreferNarrowestSectionForPadLogic() async {
        let engine = ArrangementPlaybackEngine()
        let verse = makeSection(name: "Verse", start: 0, end: 60, note: 60)
        let chorus = makeSection(name: "Chorus", start: 10, end: 20, note: 62)

        engine.configure(sections: [verse, chorus])
        engine.triggerSection(chorus)
        engine.play()
        engine.currentTime = 15

        let jumpResult = engine.triggerSection(verse)
        #expect(jumpResult == .queuedForEnd)
        #expect(engine.pendingSection?.id == verse.id)

        let repeatEngine = ArrangementPlaybackEngine()
        repeatEngine.configure(sections: [verse, chorus])
        repeatEngine.triggerSection(chorus)
        repeatEngine.play()
        repeatEngine.currentTime = 15

        let repeatResult = repeatEngine.triggerSection(chorus)
        #expect(repeatResult == .enabledRepeatAtEnd)
    }

    @Test func jumpBackAfterSectionEnds() async {
        let engine = ArrangementPlaybackEngine()
        let verse = makeSection(name: "Verse", start: 0, end: 10, note: 60)
        let chorus = makeSection(name: "Chorus", start: 10, end: 20, note: 62)

        engine.configure(sections: [verse, chorus])
        engine.triggerSection(chorus)
        engine.play()
        engine.currentTime = 19.9
        engine.tick(delta: 0.2, projectDuration: 120)

        #expect(engine.state == .continuingTimeline)

        let result = engine.triggerSection(verse)
        #expect(result == .activatedImmediately)
        #expect(engine.activeSection?.id == verse.id)
        #expect(engine.currentTime == 0)
    }

    @Test func jumpBackAfterNestedSectionEnds() async {
        let engine = ArrangementPlaybackEngine()
        let verse = makeSection(name: "Verse", start: 0, end: 60, note: 60)
        let chorus = makeSection(name: "Chorus", start: 10, end: 20, note: 62)

        engine.configure(sections: [verse, chorus])
        engine.triggerSection(chorus)
        engine.play()
        engine.currentTime = 19.9
        engine.tick(delta: 0.2, projectDuration: 120)

        #expect(engine.state == .continuingTimeline)

        let result = engine.triggerSection(verse)
        #expect(result == .activatedImmediately)
        #expect(engine.activeSection?.id == verse.id)
        #expect(engine.currentTime == 0)
    }

    private func makeSection(
        name: String,
        start: TimeInterval,
        end: TimeInterval,
        note: UInt8,
        playbackMode: SectionPlaybackMode = .continueTimeline
    ) -> ArrangementSection {
        ArrangementSection(
            name: name,
            startTime: start,
            endTime: end,
            colorHex: SectionMarkerPalette.hex(forName: name, index: Int(note - 60)),
            midiNote: note,
            playbackMode: playbackMode,
            waitForCurrentToFinish: true
        )
    }
}
