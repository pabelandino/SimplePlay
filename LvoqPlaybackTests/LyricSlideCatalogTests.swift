//
//  LyricSlideCatalogTests.swift
//  LvoqPlaybackTests
//

import Foundation
import Testing
@testable import LvoqPlayback

@MainActor
struct LyricSlideCatalogTests {
    @Test func clearingSectionLinksFreesOnlyThatSection() {
        let verseID = UUID()
        let chorusID = UUID()
        let catalog = LyricSlideCatalog(
            lyricID: UUID(),
            lyricTitle: "Song",
            slides: [
                LyricSlideCatalogItem(
                    slideID: UUID(),
                    order: 0,
                    preview: "Verse line",
                    text: "Verse line\nSecond line of the verse",
                    tag: "verse",
                    linkedSectionID: verseID
                ),
                LyricSlideCatalogItem(
                    slideID: UUID(),
                    order: 1,
                    preview: "Chorus line",
                    text: "Chorus line",
                    tag: "chorus",
                    linkedSectionID: chorusID
                )
            ]
        )

        let cleared = catalog.clearingSectionLinks(verseID)

        #expect(cleared.slides[0].linkedSectionID == nil)
        #expect(cleared.slides[1].linkedSectionID == chorusID)
        #expect(catalog.slides[0].linkedSectionID == verseID)
    }

    @Test func displayTextPrefersFullLyricsOverPreview() {
        let slide = LyricSlideCatalogItem(
            slideID: UUID(),
            order: 0,
            preview: "First line only",
            text: "First line only\nAnd the rest of the verse",
            tag: "verse"
        )

        #expect(slide.displayText == "First line only\nAnd the rest of the verse")
    }

    @Test func catalogItemDecodesLegacyPreviewOnlyPayload() throws {
        let slideID = UUID()
        let json = """
        {
          "slideID": "\(slideID.uuidString)",
          "order": 0,
          "preview": "First line only",
          "tag": "verse"
        }
        """
        let item = try JSONDecoder().decode(LyricSlideCatalogItem.self, from: Data(json.utf8))
        #expect(item.preview == "First line only")
        #expect(item.text == "First line only")
        #expect(item.displayText == "First line only")
    }

    @Test func catalogItemDecodesFullTextFromLvoqShow() throws {
        let slideID = UUID()
        let json = """
        {
          "slideID": "\(slideID.uuidString)",
          "order": 1,
          "preview": "First line only",
          "text": "First line only\\nSecond line\\nThird line",
          "tag": "chorus"
        }
        """
        let item = try JSONDecoder().decode(LyricSlideCatalogItem.self, from: Data(json.utf8))
        #expect(item.preview == "First line only")
        #expect(item.displayText.contains("Second line"))
        #expect(item.displayText.contains("Third line"))
    }

    @Test func sameSlideCanBeUsedByMultipleSections() {
        let slideID = UUID()
        let verse = ArrangementSection(
            name: "Verse",
            startTime: 0,
            endTime: 8,
            colorHex: "#FF0000",
            lyricSlideID: slideID
        )
        let chorus = ArrangementSection(
            name: "Chorus",
            startTime: 8,
            endTime: 16,
            colorHex: "#00FF00",
            lyricSlideID: slideID
        )
        let bridge = ArrangementSection(
            name: "Bridge",
            startTime: 16,
            endTime: 24,
            colorHex: "#0000FF"
        )

        let verseState = LyricSlideAssignment.state(
            slideID: slideID,
            currentSectionID: verse.id,
            sections: [verse, chorus, bridge]
        )
        #expect(verseState.isSelectedHere)
        #expect(verseState.usages.map(\.name) == ["Verse", "Chorus"])

        let chorusState = LyricSlideAssignment.state(
            slideID: slideID,
            currentSectionID: chorus.id,
            sections: [verse, chorus, bridge]
        )
        #expect(chorusState.isSelectedHere)
        #expect(chorusState.usages.map(\.name) == ["Verse", "Chorus"])

        let bridgeState = LyricSlideAssignment.state(
            slideID: slideID,
            currentSectionID: bridge.id,
            sections: [verse, chorus, bridge]
        )
        #expect(!bridgeState.isSelectedHere)
        #expect(bridgeState.usages.map(\.name) == ["Verse", "Chorus"])
    }
}
