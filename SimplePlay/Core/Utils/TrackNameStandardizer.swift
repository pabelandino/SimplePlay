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

    /// English + Spanish aliases grouped by canonical role.
    private static let aliasMap: [(StandardTrackRole, [String])] = [
        (.click, ["click", "metronome", "metronomo", "metrónomo", "clk", "clic"]),
        (.cue, ["cue", "cues", "anuncio", "anuncios", "q"]),
        (.guide, ["guide", "guia", "guía", "reference", "ref", "demo", "guia vocal"]),
        (.countIn, ["count in", "countin", "count-in", "contador", "cnt", "pre count"]),
        (.leadVocal, ["lead vocal", "lead vox", "vocal", "voz", "voz principal", "main vocal", "ld vox", "vox lead", "vocal principal"]),
        (.backingVocal, ["backing vocal", "bv", "bgv", "coro", "coros", "armonia", "armonía", "armonias", "harmony", "bvs", "voces", "backing vox"]),
        (.electricGuitar, [
            "electric guitar", "e guitar", "eguitar", "e-guitar", "e guitarra",
            "guitarra electrica", "guitarra eléctrica", "guitarra elec",
            "eg", "ge", "guitar elect", "gtr eg", "guitarra e", "elec guitar", "elec gtr"
        ]),
        (.acousticGuitar, [
            "acoustic guitar", "a guitar", "aguitar", "a-guitar",
            "guitarra acustica", "guitarra acústica", "guitarra ac",
            "ag", "guitar ac", "gtr ag", "acoustic gtr", "ac gtr"
        ]),
        (.bass, ["bass", "bajo", "bs", "bas", "bass guitar", "guitarra bajo"]),
        (.drums, ["drums", "drum", "bateria", "batería", "dr", "kit", "battery", "batera"]),
        (.keys, ["keys", "keyboard", "teclado", "teclados", "ky", "org", "organ", "organo", "órgano"]),
        (.piano, ["piano", "pn", "pno"]),
        (.synth, ["synth", "synthesizer", "sintetizador", "sintetizadores", "sy", "sinth"]),
        (.strings, ["strings", "cuerdas", "st", "violin", "violines", "cello", "violonchelo", "viola"]),
        (.brass, ["brass", "metales", "br", "horn", "trompeta", "trumpet", "trombone", "trombon"]),
        (.percussion, ["percussion", "perc", "percusión", "pc", "shaker", "tambourine", "pandereta", "tambor"]),
        (.loop, ["loop", "loops", "bucle", "bucles"]),
        (.fx, ["fx", "effects", "efectos", "reverb", "delay", "sfx"])
    ]

    static func standardize(_ rawName: String) -> StandardizedName {
        let normalized = normalize(rawName)
        let tokens = tokenize(normalized)
        let variant = extractVariant(from: tokens)
        let contentTokens = tokens.filter { !isStandaloneVariantToken($0) }

        for (role, aliases) in aliasMap {
            for alias in aliases {
                let normalizedAlias = normalize(alias)
                if matchesAlias(
                    normalized: normalized,
                    contentTokens: contentTokens,
                    alias: normalizedAlias
                ) {
                    return StandardizedName(
                        originalName: rawName,
                        standardCode: makeStandardCode(role: role, variant: variant),
                        role: role
                    )
                }
            }
        }

        let fallbackCode = makeFallbackCode(from: contentTokens, variant: variant)
        return StandardizedName(
            originalName: rawName,
            standardCode: fallbackCode,
            role: .unknown
        )
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

    private static func tokenize(_ normalized: String) -> [String] {
        normalized.split(whereSeparator: \.isWhitespace).map(String.init)
    }

    private static func makeStandardCode(role: StandardTrackRole, variant: Int?) -> String {
        guard let variant else { return role.rawValue }
        return "\(role.rawValue)\(variant)"
    }

    private static func makeFallbackCode(from tokens: [String], variant: Int?) -> String {
        let base = tokens.first.map { String($0.prefix(3)).uppercased() } ?? "UNK"
        guard let variant else { return base }
        return "\(base)\(variant)"
    }

    private static func extractVariant(from tokens: [String]) -> Int? {
        if let last = tokens.last, isStandaloneVariantToken(last), let value = Int(last) {
            return value
        }

        for token in tokens {
            if let variant = trailingVariant(in: token) {
                return variant.value
            }
        }

        return nil
    }

    private static func isStandaloneVariantToken(_ token: String) -> Bool {
        !token.isEmpty && token.allSatisfy(\.isNumber)
    }

    /// Parses trailing digits from tokens like `eg1`, `eg_02`, `guitarra1`.
    private static func trailingVariant(in token: String) -> (value: Int, digitCount: Int)? {
        guard !token.isEmpty else { return nil }

        var digitRun = ""
        for character in token.reversed() {
            guard character.isNumber else { break }
            digitRun.insert(character, at: digitRun.startIndex)
        }

        guard !digitRun.isEmpty, let value = Int(digitRun), value > 0 else { return nil }

        let prefix = String(token.dropLast(digitRun.count))
            .trimmingCharacters(in: CharacterSet(charactersIn: "_- "))
        guard !prefix.isEmpty else { return (value, digitRun.count) }
        return (value, digitRun.count)
    }

    private static func matchesAlias(
        normalized: String,
        contentTokens: [String],
        alias: String
    ) -> Bool {
        if alias.contains(" ") {
            let withoutVariant = stripTrailingVariantPhrase(from: normalized)
            return withoutVariant.contains(alias)
        }

        for token in contentTokens {
            if token == alias { return true }
            if token.hasPrefix("\(alias)_") || token.hasSuffix("_\(alias)") { return true }

            if let variant = trailingVariant(in: token) {
                let prefix = String(token.dropLast(variant.digitCount))
                    .trimmingCharacters(in: CharacterSet(charactersIn: "_- "))
                if prefix == alias { return true }
            }

            if token.hasPrefix(alias) {
                let suffix = token.dropFirst(alias.count)
                if suffix.isEmpty || suffix.allSatisfy({ $0.isNumber || $0 == "_" || $0 == "-" }) {
                    return true
                }
            }
        }

        return false
    }

    private static func stripTrailingVariantPhrase(from normalized: String) -> String {
        var tokens = tokenize(normalized)
        if let last = tokens.last, isStandaloneVariantToken(last) {
            tokens.removeLast()
        }
        return tokens.joined(separator: " ")
    }
}
