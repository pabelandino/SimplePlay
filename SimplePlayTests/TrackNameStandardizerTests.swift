//
//  TrackNameStandardizerTests.swift
//  SimplePlayTests
//

import Foundation
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

    @Test func standardizesNumberedElectricGuitarAliases() {
        #expect(TrackNameStandardizer.standardize("EG 1").standardCode == "EG1")
        #expect(TrackNameStandardizer.standardize("EG 2").role == .electricGuitar)
        #expect(TrackNameStandardizer.standardize("EG 2").standardCode == "EG2")
        #expect(TrackNameStandardizer.standardize("EG1").standardCode == "EG1")
        #expect(TrackNameStandardizer.standardize("EG2").standardCode == "EG2")
        #expect(TrackNameStandardizer.standardize("Guitarra Electrica 1").standardCode == "EG1")
        #expect(TrackNameStandardizer.standardize("Guitarra Electrica 2").standardCode == "EG2")
    }

    @Test func mergesNumberedElectricGuitarsAcrossMultitracks() {
        let service = TrackOrganizationService()
        var project = DAWProject()

        project = service.importInitial(
            project: project,
            stems: [
                stem(name: "EG 1", duration: 10),
                stem(name: "EG 2", duration: 10)
            ],
            groupName: "Multitrack 1"
        )

        project = service.merge(
            project: project,
            newStems: [
                stem(name: "Guitarra Electrica 1", duration: 12),
                stem(name: "Guitarra Electrica 2", duration: 12)
            ],
            groupName: "Multitrack 2"
        )

        #expect(project.tracks.count == 2)
        #expect(project.tracks[0].standardCode == "EG1")
        #expect(project.tracks[1].standardCode == "EG2")
        #expect(project.tracks[0].clips.count == 2)
        #expect(project.tracks[1].clips.count == 2)
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

    @Test func unknownNamesKeepSeparateTracks() {
        let service = TrackOrganizationService()
        var project = DAWProject()
        project = service.importInitial(
            project: project,
            stems: [stem(name: "Custom Layer A", duration: 10)],
            groupName: "Take 1"
        )
        project = service.merge(
            project: project,
            newStems: [stem(name: "Totally Different Stem", duration: 10)],
            groupName: "Take 2"
        )

        #expect(project.tracks.count == 2)
        #expect(project.tracks.allSatisfy { $0.role == .unknown })
    }

    private func stem(name: String, duration: TimeInterval) -> TrackOrganizationService.ImportedStem {
        .init(url: URL(fileURLWithPath: "/tmp/\(name).wav"), name: name, duration: duration)
    }
}
