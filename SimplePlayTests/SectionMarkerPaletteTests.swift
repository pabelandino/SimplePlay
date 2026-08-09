//
//  SectionMarkerPaletteTests.swift
//  SimplePlayTests
//

import Testing
@testable import SimplePlay

struct SectionMarkerPaletteTests {
    @Test func assignsDistinctColorsForDuplicateNames() {
        var sections = [
            ArrangementSection(
                name: "Verse",
                startTime: 0,
                endTime: 8,
                colorHex: "#64D2FF"
            ),
            ArrangementSection(
                name: "Verse 2",
                startTime: 8,
                endTime: 16,
                colorHex: "#64D2FF"
            ),
            ArrangementSection(
                name: "Chorus",
                startTime: 16,
                endTime: 24,
                colorHex: "#FF9500"
            ),
        ]

        SectionMarkerPalette.ensureDistinctColors(on: &sections)

        let colors = Set(sections.map(\.colorHex))
        #expect(colors.count == sections.count)
        #expect(sections[0].colorHex != sections[1].colorHex)
    }

    @Test func nextDistinctHexAvoidsUsedColors() {
        let existing = [
            ArrangementSection(
                name: "Verse",
                startTime: 0,
                endTime: 8,
                colorHex: "#64D2FF"
            ),
        ]

        let next = SectionMarkerPalette.nextDistinctHex(sections: existing, name: "Verse")
        #expect(next != existing[0].colorHex)
    }
}
