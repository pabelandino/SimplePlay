//
//  TrackGroup.swift
//  SimplePlay
//

import Foundation

/// Represents one imported multitrack bundle (e.g. stems from a single recording session).
struct TrackGroup: Identifiable, Codable, Sendable, Equatable {
    let id: UUID
    var name: String
    var importedAt: Date
    var horizontalOffset: TimeInterval
    /// Pitch offset in semitones (-12…+12). 0 = original audio.
    var pitchSemitones: Double
    /// Group bus level (same range as track faders).
    var volume: Double

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case importedAt
        case horizontalOffset
        case pitchSemitones
        case volume
    }

    init(
        id: UUID = UUID(),
        name: String,
        importedAt: Date = .now,
        horizontalOffset: TimeInterval = 0,
        pitchSemitones: Double = 0,
        volume: Double = TrackVolumeSettings.unityLinear
    ) {
        self.id = id
        self.name = name
        self.importedAt = importedAt
        self.horizontalOffset = horizontalOffset
        self.pitchSemitones = pitchSemitones
        self.volume = volume
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        importedAt = try container.decode(Date.self, forKey: .importedAt)
        horizontalOffset = try container.decodeIfPresent(TimeInterval.self, forKey: .horizontalOffset) ?? 0
        pitchSemitones = try container.decodeIfPresent(Double.self, forKey: .pitchSemitones) ?? 0
        volume = try container.decodeIfPresent(Double.self, forKey: .volume) ?? TrackVolumeSettings.unityLinear
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(importedAt, forKey: .importedAt)
        try container.encode(horizontalOffset, forKey: .horizontalOffset)
        try container.encode(pitchSemitones, forKey: .pitchSemitones)
        try container.encode(volume, forKey: .volume)
    }
}
