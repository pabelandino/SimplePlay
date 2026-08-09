//
//  TrackColorPalette.swift
//  SimplePlay
//

import SwiftUI

enum TrackColorPalette {
    static func color(for role: StandardTrackRole) -> Color {
        switch role {
        case .click: Color(hex: "#FF9500")!
        case .cue, .guide, .countIn: Color(hex: "#FFD60A")!
        case .leadVocal: Color(hex: "#FF375F")!
        case .backingVocal: Color(hex: "#FF6482")!
        case .electricGuitar: Color(hex: "#BF5AF2")!
        case .acousticGuitar: Color(hex: "#AF52DE")!
        case .bass: Color(hex: "#30D158")!
        case .drums: Color(hex: "#FF453A")!
        case .keys, .piano: Color(hex: "#64D2FF")!
        case .synth: Color(hex: "#5E5CE6")!
        case .strings: Color(hex: "#AC8E68")!
        case .brass: Color(hex: "#FFB340")!
        case .percussion: Color(hex: "#FF9F0A")!
        case .loop: Color(hex: "#32ADE6")!
        case .fx: Color(hex: "#8E8E93")!
        case .unknown: Color(hex: "#636366")!
        }
    }

    static func hex(for role: StandardTrackRole) -> String {
        switch role {
        case .click: "#FF9500"
        case .cue, .guide, .countIn: "#FFD60A"
        case .leadVocal: "#FF375F"
        case .backingVocal: "#FF6482"
        case .electricGuitar: "#BF5AF2"
        case .acousticGuitar: "#AF52DE"
        case .bass: "#30D158"
        case .drums: "#FF453A"
        case .keys, .piano: "#64D2FF"
        case .synth: "#5E5CE6"
        case .strings: "#AC8E68"
        case .brass: "#FFB340"
        case .percussion: "#FF9F0A"
        case .loop: "#32ADE6"
        case .fx: "#8E8E93"
        case .unknown: "#636366"
        }
    }
}

extension DAWProject {
    var hasSoloTracks: Bool {
        tracks.contains(where: \.isSolo)
    }

    /// Whether the track should render in its assigned color (vs greyed out).
    func isTrackDisplayedInColor(_ track: AudioTrack) -> Bool {
        if track.isMuted { return false }
        if hasSoloTracks { return track.isSolo }
        return true
    }

    func displayColor(for track: AudioTrack) -> Color {
        isTrackDisplayedInColor(track) ? track.color : DAWTheme.mutedTrack
    }
}

extension Color {
    init?(hex: String) {
        var sanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        sanitized = sanitized.replacingOccurrences(of: "#", with: "")

        guard sanitized.count == 6, let value = UInt64(sanitized, radix: 16) else {
            return nil
        }

        let red = Double((value >> 16) & 0xFF) / 255
        let green = Double((value >> 8) & 0xFF) / 255
        let blue = Double(value & 0xFF) / 255
        self.init(red: red, green: green, blue: blue)
    }
}
