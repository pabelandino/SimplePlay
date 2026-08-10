//
//  ArrangementSection.swift
//  SimplePlay
//

import Foundation
import SwiftUI

/// A song section marker (verse, chorus, etc.) mapped to MIDI and shown in the marker lane.
struct ArrangementSection: Identifiable, Codable, Sendable, Equatable {
    let id: UUID
    var name: String
    var startTime: TimeInterval
    var endTime: TimeInterval
    var colorHex: String
    var midiNote: UInt8
    var midiChannel: UInt8
    var midiUsesControlChange: Bool
    var playbackMode: SectionPlaybackMode
    /// Optional section to jump to after this one finishes (for continueToNext mode).
    var nextSectionID: UUID?
    /// When switching sections mid-playback, wait for the current section to finish first.
    var waitForCurrentToFinish: Bool

    init(
        id: UUID = UUID(),
        name: String,
        startTime: TimeInterval,
        endTime: TimeInterval,
        colorHex: String,
        midiNote: UInt8 = 60,
        midiChannel: UInt8 = 0,
        midiUsesControlChange: Bool = false,
        playbackMode: SectionPlaybackMode = .continueTimeline,
        nextSectionID: UUID? = nil,
        waitForCurrentToFinish: Bool = true
    ) {
        self.id = id
        self.name = name
        self.startTime = startTime
        self.endTime = endTime
        self.colorHex = colorHex
        self.midiNote = midiNote
        self.midiChannel = midiChannel
        self.midiUsesControlChange = midiUsesControlChange
        self.playbackMode = playbackMode
        self.nextSectionID = nextSectionID
        self.waitForCurrentToFinish = waitForCurrentToFinish
    }

    enum CodingKeys: String, CodingKey {
        case id, name, startTime, endTime, colorHex
        case midiNote, midiChannel, midiUsesControlChange, playbackMode
        case nextSectionID, waitForCurrentToFinish
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        startTime = try container.decode(TimeInterval.self, forKey: .startTime)
        endTime = try container.decode(TimeInterval.self, forKey: .endTime)
        midiNote = try container.decode(UInt8.self, forKey: .midiNote)
        midiChannel = try container.decodeIfPresent(UInt8.self, forKey: .midiChannel) ?? 0
        midiUsesControlChange = try container.decodeIfPresent(Bool.self, forKey: .midiUsesControlChange) ?? false
        playbackMode = try container.decode(SectionPlaybackMode.self, forKey: .playbackMode)
        nextSectionID = try container.decodeIfPresent(UUID.self, forKey: .nextSectionID)
        waitForCurrentToFinish = try container.decodeIfPresent(Bool.self, forKey: .waitForCurrentToFinish) ?? true

        if let storedColor = try container.decodeIfPresent(String.self, forKey: .colorHex) {
            colorHex = storedColor
        } else {
            colorHex = SectionMarkerPalette.hex(forName: name, index: Int(midiNote - 60))
        }
    }

    var duration: TimeInterval { max(0, endTime - startTime) }

    var color: Color {
        Color(hex: colorHex) ?? SectionMarkerPalette.color(forName: name, index: 0)
    }

    func contains(time: TimeInterval) -> Bool {
        time >= startTime && time < endTime
    }
}
