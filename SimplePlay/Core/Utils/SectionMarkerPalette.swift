//
//  SectionMarkerPalette.swift
//  SimplePlay
//

import SwiftUI

enum SectionMarkerPalette {
    static var palette: [String] {
        TrackColorPalette.distinctHexColors
    }

    static func hex(forName name: String, index: Int) -> String {
        let lower = name.lowercased()

        if lower.contains("chorus") { return "#FF9500" }
        if lower.contains("pre-chorus") || lower.contains("prechorus") { return "#FFB340" }
        if lower.contains("verse") { return "#64D2FF" }
        if lower.contains("bridge") { return "#BF5AF2" }
        if lower.contains("outro") { return "#FF6482" }
        if lower.contains("intro") { return "#30D158" }

        return palette[index % palette.count]
    }

    static func color(forName name: String, index: Int) -> Color {
        Color(hex: hex(forName: name, index: index)) ?? .blue
    }

    static func nextDistinctHex(sections: [ArrangementSection], name: String) -> String {
        nextDistinctHex(from: Set(sections.map(\.colorHex)), name: name, preferredIndex: sections.count)
    }

    static func ensureDistinctColors(on sections: inout [ArrangementSection]) {
        var usedHexes = Set<String>()

        for index in sections.indices {
            let name = sections[index].name
            var candidate = sections[index].colorHex

            if candidate.isEmpty || usedHexes.contains(candidate) {
                candidate = nextDistinctHex(from: usedHexes, name: name, preferredIndex: index)
            }

            sections[index].colorHex = candidate
            usedHexes.insert(candidate)
        }
    }

    private static func nextDistinctHex(
        from usedHexes: Set<String>,
        name: String,
        preferredIndex: Int
    ) -> String {
        var candidate = hex(forName: name, index: preferredIndex)
        var offset = 0

        while usedHexes.contains(candidate) {
            offset += 1
            candidate = palette[(preferredIndex + offset) % palette.count]
        }

        return candidate
    }
}
