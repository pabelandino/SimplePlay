//
//  ArrangementSection.swift
//  SimplePlay
//

import Foundation

/// A manually defined song section (verse, chorus, etc.) mapped to MIDI.
struct ArrangementSection: Identifiable, Codable, Sendable, Equatable {
    let id: UUID
    var name: String
    var startTime: TimeInterval
    var endTime: TimeInterval
    var midiNote: UInt8
    var midiChannel: UInt8
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
        midiNote: UInt8 = 60,
        midiChannel: UInt8 = 0,
        playbackMode: SectionPlaybackMode = .repeatSection,
        nextSectionID: UUID? = nil,
        waitForCurrentToFinish: Bool = true
    ) {
        self.id = id
        self.name = name
        self.startTime = startTime
        self.endTime = endTime
        self.midiNote = midiNote
        self.midiChannel = midiChannel
        self.playbackMode = playbackMode
        self.nextSectionID = nextSectionID
        self.waitForCurrentToFinish = waitForCurrentToFinish
    }

    var duration: TimeInterval { max(0, endTime - startTime) }

    func contains(time: TimeInterval) -> Bool {
        time >= startTime && time < endTime
    }
}
