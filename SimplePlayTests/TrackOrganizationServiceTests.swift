//
//  TrackOrganizationServiceTests.swift
//  SimplePlayTests
//

import Foundation
import Testing
@testable import SimplePlay

struct TrackOrganizationServiceTests {
    private let service = TrackOrganizationService()

    @Test func ordersClickFirst() {
        let stems = [
            stem(name: "Bass", duration: 10),
            stem(name: "Click", duration: 10),
            stem(name: "Electric Guitar", duration: 10)
        ]
        let group = TrackGroup(name: "A")
        let tracks = service.buildTracks(from: stems, group: group, groupIndex: 0)
        let sorted = service.sortTracks(tracks)

        #expect(sorted.first?.role == .click)
        #expect(sorted.map(\.role) == [.click, .bass, .electricGuitar])
    }

    @Test func mergesMatchingTracksSideBySide() {
        var project = DAWProject()
        let first = [
            stem(name: "Click", duration: 10),
            stem(name: "Electric Guitar", duration: 10)
        ]
        project = service.importInitial(project: project, stems: first, groupName: "Take 1")

        let second = [
            stem(name: "Click", duration: 12),
            stem(name: "Electric Guitar", duration: 12)
        ]
        project = service.merge(project: project, newStems: second, groupName: "Take 2")

        #expect(project.tracks.count == 2)
        #expect(project.tracks[0].clips.count == 2)
        #expect(project.tracks[1].clips.count == 2)
    }

    @Test func addsUnknownTrackBelow() {
        var project = DAWProject()
        project = service.importInitial(
            project: project,
            stems: [stem(name: "Click", duration: 10)],
            groupName: "Take 1"
        )

        project = service.merge(
            project: project,
            newStems: [stem(name: "Custom Ambience Layer", duration: 10)],
            groupName: "Take 2"
        )

        #expect(project.tracks.count == 2)
        #expect(project.tracks.last?.role == .unknown)
    }

    private func stem(name: String, duration: TimeInterval) -> TrackOrganizationService.ImportedStem {
        .init(url: URL(fileURLWithPath: "/tmp/\(name).wav"), name: name, duration: duration)
    }
}
