//
//  PitchShiftSettingsTests.swift
//  SimplePlayTests
//

import Foundation
import Testing

@testable import SimplePlay

struct PitchShiftSettingsTests {
    @Test func clampsSemitonesToSafeRange() {
        #expect(PitchShiftSettings.clampSemitones(-24) == -5)
        #expect(PitchShiftSettings.clampSemitones(3.5) == 3.5)
        #expect(PitchShiftSettings.clampSemitones(24) == 5)
    }

    @Test func convertsSemitonesToCents() {
        #expect(PitchShiftSettings.cents(from: -2) == -200)
        #expect(PitchShiftSettings.cents(from: 0) == 0)
        #expect(PitchShiftSettings.cents(from: 3.5) == 350)
    }

    @Test func resolvesTrackPitchByTrackID() {
        let track = AudioTrack(
            originalName: "EG",
            standardCode: "EG",
            role: .electricGuitar,
            colorHex: "#FFFFFF",
            pitchSemitones: 2.5,
            isPitchEnabled: true
        )
        let project = DAWProject(tracks: [track])

        #expect(project.pitchSemitones(forTrackID: track.id) == 2.5)
        #expect(project.usesPitchProcessing(forTrackID: track.id))
        #expect(project.track(containing: UUID()) == nil)
    }

    @Test func pitchBypassedUntilEnabled() {
        let track = AudioTrack(
            originalName: "EG",
            standardCode: "EG",
            role: .electricGuitar,
            colorHex: "#FFFFFF",
            pitchSemitones: 0,
            isPitchEnabled: false
        )

        #expect(!PitchShiftSettings.usesPitchProcessing(for: track))
    }
}
