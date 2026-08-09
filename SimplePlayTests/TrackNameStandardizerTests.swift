//
//  TrackNameStandardizerTests.swift
//  SimplePlayTests
//

import Testing
@testable import SimplePlay

struct TrackNameStandardizerTests {
    @Test func standardizesSpanishElectricGuitar() {
        let result = TrackNameStandardizer.standardize("Guitarra Electrica")
        #expect(result.standardCode == "EG")
        #expect(result.role == .electricGuitar)
    }

    @Test func standardizesEnglishElectricGuitar() {
        let result = TrackNameStandardizer.standardize("Electric Guitar")
        #expect(result.standardCode == "EG")
        #expect(result.role == .electricGuitar)
    }

    @Test func prioritizesClickTrack() {
        let result = TrackNameStandardizer.standardize("Click Track")
        #expect(result.role == .click)
        #expect(result.standardCode == "CLK")
    }

    @Test func standardizesCueAndGuide() {
        #expect(TrackNameStandardizer.standardize("Cue").role == .cue)
        #expect(TrackNameStandardizer.standardize("Guia").role == .guide)
    }
}
