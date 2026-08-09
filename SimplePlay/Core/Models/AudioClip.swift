//
//  AudioClip.swift
//  SimplePlay
//

import Foundation

/// A single audio region placed on the timeline.
struct AudioClip: Identifiable, Codable, Sendable, Equatable {
    let id: UUID
    var name: String
    var fileURL: URL
    var startTime: TimeInterval
    var duration: TimeInterval
    var sourceOffset: TimeInterval
    var groupIndex: Int

    init(
        id: UUID = UUID(),
        name: String,
        fileURL: URL,
        startTime: TimeInterval = 0,
        duration: TimeInterval,
        sourceOffset: TimeInterval = 0,
        groupIndex: Int = 0
    ) {
        self.id = id
        self.name = name
        self.fileURL = fileURL
        self.startTime = startTime
        self.duration = duration
        self.sourceOffset = sourceOffset
        self.groupIndex = groupIndex
    }

    var endTime: TimeInterval { startTime + duration }
}
