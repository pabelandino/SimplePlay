//
//  TrackNameStandardizer.swift
//  SimplePlay
//

import Foundation

/// Maps raw track filenames / labels (English or Spanish) to canonical codes and roles.
enum TrackNameStandardizer {
    struct StandardizedName: Sendable, Equatable {
        let originalName: String
        let standardCode: String
        let role: StandardTrackRole
    }

    private static let aliasMap: [(StandardTrackRole, [String])] = [
        (.click, ["click", "metronome", "metronomo", "metrónomo", "clk"]),
        (.cue, ["cue", "cues", "anuncio", "anuncios"]),
        (.guide, ["guide", "guia", "guía", "reference", "ref", "demo"]),
        (.countIn, ["count in", "countin", "contador", "cnt"]),
        (.leadVocal, ["lead vocal", "lead vox", "vocal", "voz", "voz principal", "main vocal", "ld vox", "ld"]),
        (.backingVocal, ["backing vocal", "bv", "bgv", "coro", "coros", "armonia", "armonía", "harmony", "bvs"]),
        (.electricGuitar, ["electric guitar", "e guitar", "eguitar", "guitarra electrica", "guitarra eléctrica", "eg", "guitar elect", "gtr eg"]),
        (.acousticGuitar, ["acoustic guitar", "a guitar", "aguitar", "guitarra acustica", "guitarra acústica", "ag", "guitar ac", "gtr ag"]),
        (.bass, ["bass", "bajo", "bs", "bas"]),
        (.drums, ["drums", "drum", "bateria", "batería", "dr", "kit"]),
        (.keys, ["keys", "keyboard", "teclado", "ky", "org"]),
        (.piano, ["piano", "pn"]),
        (.synth, ["synth", "synthesizer", "sintetizador", "sy"]),
        (.strings, ["strings", "cuerdas", "st", "violin", "violines", "cello"]),
        (.brass, ["brass", "metales", "br", "horn", "trompeta", "trumpet"]),
        (.percussion, ["percussion", "perc", "percusión", "pc", "shaker", "tambourine"]),
        (.loop, ["loop", "loops", "bucle"]),
        (.fx, ["fx", "effects", "efectos", "reverb", "delay"])
    ]

    static func standardize(_ rawName: String) -> StandardizedName {
        let normalized = normalize(rawName)
        let tokens = normalized.split(separator: " ").map(String.init)

        for (role, aliases) in aliasMap {
            for alias in aliases {
                let normalizedAlias = normalize(alias)
                if matchesAlias(normalized, alias: normalizedAlias, tokens: tokens) {
                    return StandardizedName(
                        originalName: rawName,
                        standardCode: role.rawValue,
                        role: role
                    )
                }
            }
        }

        // Fallback: use first token uppercase or UNK
        let fallbackCode = tokens.first.map { String($0.prefix(3)).uppercased() } ?? "UNK"
        return StandardizedName(
            originalName: rawName,
            standardCode: fallbackCode,
            role: .unknown
        )
    }

    private static func matchesAlias(_ normalized: String, alias: String, tokens: [String]) -> Bool {
        if tokens.contains(alias) { return true }

        // Multi-word aliases must match as a contiguous phrase.
        if alias.contains(" "), normalized.contains(alias) { return true }

        // Single-token aliases match whole tokens or dedicated track prefixes (e.g. "eg_01").
        guard !alias.contains(" ") else { return false }
        return tokens.contains { token in
            token == alias || token.hasPrefix("\(alias)_") || token.hasSuffix("_\(alias)")
        }
    }

    static func normalize(_ value: String) -> String {
        value
            .folding(options: [.diacriticInsensitive, .caseInsensitive], locale: .current)
            .replacingOccurrences(of: "_", with: " ")
            .replacingOccurrences(of: "-", with: " ")
            .replacingOccurrences(of: ".", with: " ")
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased()
    }

    static func extractName(from url: URL) -> String {
        url.deletingPathExtension().lastPathComponent
    }
}
