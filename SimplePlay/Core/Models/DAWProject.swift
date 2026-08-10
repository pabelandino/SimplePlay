//
//  DAWProject.swift
//  SimplePlay
//

import Foundation

/// Root project model containing tracks, groups, and arrangement sections.
struct DAWProject: Identifiable, Codable, Sendable, Equatable {
    let id: UUID
    var name: String
    var tracks: [AudioTrack]
    var groups: [TrackGroup]
    var sections: [ArrangementSection]
    var sectionRepeatMIDINote: UInt8
    var sectionRepeatMIDIChannel: UInt8
    /// Loop toggle MIDI is inactive until the user assigns it via the Loop Assign Button.
    var sectionRepeatMIDIMapped: Bool
    var preferredMIDISourceName: String?
    var preferredMIDISourceUniqueID: Int32?
    var snapInterval: TimeInterval
    var isSnapEnabled: Bool
    var masterVolume: Double
    var tempo: Double
    var audioSettings: AudioSettings

    init(
        id: UUID = UUID(),
        name: String = "Untitled Project",
        tracks: [AudioTrack] = [],
        groups: [TrackGroup] = [],
        sections: [ArrangementSection] = [],
        sectionRepeatMIDINote: UInt8 = 36,
        sectionRepeatMIDIChannel: UInt8 = 0,
        sectionRepeatMIDIMapped: Bool = false,
        preferredMIDISourceName: String? = nil,
        preferredMIDISourceUniqueID: Int32? = nil,
        snapInterval: TimeInterval = 0.25,
        isSnapEnabled: Bool = true,
        masterVolume: Double = 1.0,
        tempo: Double = 120,
        audioSettings: AudioSettings = AudioSettings()
    ) {
        self.id = id
        self.name = name
        self.tracks = tracks
        self.groups = groups
        self.sections = sections
        self.sectionRepeatMIDINote = sectionRepeatMIDINote
        self.sectionRepeatMIDIChannel = sectionRepeatMIDIChannel
        self.sectionRepeatMIDIMapped = sectionRepeatMIDIMapped
        self.preferredMIDISourceName = preferredMIDISourceName
        self.preferredMIDISourceUniqueID = preferredMIDISourceUniqueID
        self.snapInterval = snapInterval
        self.isSnapEnabled = isSnapEnabled
        self.masterVolume = masterVolume
        self.tempo = tempo
        self.audioSettings = audioSettings
    }

    var duration: TimeInterval {
        tracks
            .flatMap(\.clips)
            .map(\.endTime)
            .max() ?? 0
    }
}
