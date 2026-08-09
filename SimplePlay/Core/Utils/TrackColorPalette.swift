//
//  TrackColorPalette.swift
//  SimplePlay
//

import SwiftUI

enum TrackColorPalette {
    /// Distinct track colors. Gray is reserved for muted / non-solo lanes only.
    static let distinctHexColors: [String] = [
        "#FF9500", "#FFD60A", "#FF375F", "#FF6482",
        "#BF5AF2", "#AF52DE", "#30D158", "#FF453A",
        "#64D2FF", "#5E5CE6", "#AC8E68", "#FFB340",
        "#FF9F0A", "#32ADE6", "#00C7BE", "#5856D6",
        "#FF2D55", "#34C759", "#007AFF", "#FF6961",
        "#FFD426", "#7AC6FF", "#DA8FFF", "#63E6E2",
        "#F782BE", "#94D82D", "#FFA94D", "#748FFC",
        "#E599F7", "#38D9A9", "#FF8787", "#20C997",
        "#845EF7", "#339AF0", "#F06595", "#82C91E",
    ]

    static func color(for role: StandardTrackRole, variant: Int = 0) -> Color {
        Color(hex: hex(for: role, variant: variant)) ?? role.fallbackColor
    }

    static func hex(for role: StandardTrackRole, variant: Int = 0) -> String {
        let base = paletteIndex(for: role)
        let index = (base + variant) % distinctHexColors.count
        return distinctHexColors[index]
    }

    /// Assigns a unique color to every track based on role and occurrence order.
    static func assignDistinctColors(to tracks: inout [AudioTrack]) {
        var usedHexes = Set<String>()
        var roleVariants: [StandardTrackRole: Int] = [:]

        for index in tracks.indices {
            let role = tracks[index].role
            var variant = roleVariants[role, default: 0]
            var candidate = hex(for: role, variant: variant)

            while usedHexes.contains(candidate) {
                variant += 1
                candidate = hex(for: role, variant: variant)
            }

            tracks[index].colorHex = candidate
            usedHexes.insert(candidate)
            roleVariants[role] = variant + 1
        }
    }

    /// Keeps saved colors when unique; reassigns only colliding lanes.
    static func ensureDistinctColors(on tracks: inout [AudioTrack]) {
        var usedHexes = Set<String>()
        var roleVariants: [StandardTrackRole: Int] = [:]

        for index in tracks.indices {
            let currentHex = tracks[index].colorHex
            if !usedHexes.contains(currentHex) {
                usedHexes.insert(currentHex)
                continue
            }

            let role = tracks[index].role
            var variant = roleVariants[role, default: 0]
            var candidate = hex(for: role, variant: variant)

            while usedHexes.contains(candidate) {
                variant += 1
                candidate = hex(for: role, variant: variant)
            }

            tracks[index].colorHex = candidate
            usedHexes.insert(candidate)
            roleVariants[role] = variant + 1
        }
    }

    private static func paletteIndex(for role: StandardTrackRole) -> Int {
        switch role {
        case .click: 0
        case .cue: 1
        case .guide: 2
        case .countIn: 3
        case .leadVocal: 4
        case .backingVocal: 5
        case .electricGuitar: 6
        case .acousticGuitar: 7
        case .bass: 8
        case .drums: 9
        case .keys: 10
        case .piano: 11
        case .synth: 12
        case .strings: 13
        case .brass: 14
        case .percussion: 15
        case .loop: 16
        case .fx: 17
        case .unknown: 18
        }
    }
}

extension StandardTrackRole {
    fileprivate var fallbackColor: Color {
        .blue
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
