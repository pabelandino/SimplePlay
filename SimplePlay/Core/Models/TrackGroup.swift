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

    init(
        id: UUID = UUID(),
        name: String,
        importedAt: Date = .now,
        horizontalOffset: TimeInterval = 0
    ) {
        self.id = id
        self.name = name
        self.importedAt = importedAt
        self.horizontalOffset = horizontalOffset
    }
}
