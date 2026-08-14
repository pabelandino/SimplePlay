//
//  SavedProjectDocument.swift
//  SimplePlay
//

import Foundation

struct SavedProjectDocument: Codable, Sendable {
    static let currentVersion = 1

    var version: Int
    var project: DAWProject
    var workspace: WorkspaceSnapshot

    struct WorkspaceSnapshot: Codable, Sendable, Equatable {
        var playheadTime: TimeInterval
        var zoom: Double
        var isPropertiesSidebarVisible: Bool
        var propertiesSidebarWidth: Double
    }

    init(project: DAWProject, workspace: WorkspaceSnapshot) {
        self.version = Self.currentVersion
        self.project = project
        self.workspace = workspace
    }
}

struct PersistedClip: Codable, Sendable, Equatable {
    let id: UUID
    var name: String
    var audioFileName: String
    var startTime: TimeInterval
    var duration: TimeInterval
    var sourceOffset: TimeInterval
    var groupIndex: Int
}

struct PersistedTrack: Codable, Sendable, Equatable {
    let id: UUID
    var originalName: String
    var standardCode: String
    var role: StandardTrackRole
    var colorHex: String
    var isMuted: Bool
    var isSolo: Bool
    var isLocked: Bool
    var pan: Double
    var volume: Double
    var pitchSemitones: Double
    var isPitchEnabled: Bool
    var clips: [PersistedClip]

    enum CodingKeys: String, CodingKey {
        case id, originalName, standardCode, role, colorHex
        case isMuted, isSolo, isLocked, pan, volume, pitchSemitones, isPitchEnabled, clips
    }

    init(
        id: UUID,
        originalName: String,
        standardCode: String,
        role: StandardTrackRole,
        colorHex: String,
        isMuted: Bool,
        isSolo: Bool,
        isLocked: Bool,
        pan: Double,
        volume: Double = 1,
        pitchSemitones: Double = 0,
        isPitchEnabled: Bool = false,
        clips: [PersistedClip]
    ) {
        self.id = id
        self.originalName = originalName
        self.standardCode = standardCode
        self.role = role
        self.colorHex = colorHex
        self.isMuted = isMuted
        self.isSolo = isSolo
        self.isLocked = isLocked
        self.pan = pan
        self.volume = volume
        self.pitchSemitones = pitchSemitones
        self.isPitchEnabled = isPitchEnabled
        self.clips = clips
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        originalName = try container.decode(String.self, forKey: .originalName)
        standardCode = try container.decode(String.self, forKey: .standardCode)
        role = try container.decode(StandardTrackRole.self, forKey: .role)
        colorHex = try container.decode(String.self, forKey: .colorHex)
        isMuted = try container.decode(Bool.self, forKey: .isMuted)
        isSolo = try container.decode(Bool.self, forKey: .isSolo)
        isLocked = try container.decode(Bool.self, forKey: .isLocked)
        pan = try container.decode(Double.self, forKey: .pan)
        volume = try container.decodeIfPresent(Double.self, forKey: .volume) ?? 1
        pitchSemitones = try container.decodeIfPresent(Double.self, forKey: .pitchSemitones) ?? 0
        isPitchEnabled = try container.decodeIfPresent(Bool.self, forKey: .isPitchEnabled)
            ?? (abs(pitchSemitones) >= 0.001)
        clips = try container.decode([PersistedClip].self, forKey: .clips)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(originalName, forKey: .originalName)
        try container.encode(standardCode, forKey: .standardCode)
        try container.encode(role, forKey: .role)
        try container.encode(colorHex, forKey: .colorHex)
        try container.encode(isMuted, forKey: .isMuted)
        try container.encode(isSolo, forKey: .isSolo)
        try container.encode(isLocked, forKey: .isLocked)
        try container.encode(pan, forKey: .pan)
        try container.encode(volume, forKey: .volume)
        try container.encode(pitchSemitones, forKey: .pitchSemitones)
        try container.encode(isPitchEnabled, forKey: .isPitchEnabled)
        try container.encode(clips, forKey: .clips)
    }
}

struct PersistedProject: Codable, Sendable, Equatable {
    let id: UUID
    var name: String
    var tracks: [PersistedTrack]
    var groups: [TrackGroup]
    var sections: [ArrangementSection]
    var sectionRepeatMIDINote: UInt8
    var sectionRepeatMIDIChannel: UInt8
    var sectionRepeatMIDIMapped: Bool
    var preferredMIDISourceName: String?
    var preferredMIDISourceUniqueID: Int32?
    var snapInterval: TimeInterval
    var isSnapEnabled: Bool
    var masterVolume: Double
    var tempo: Double
    var audioSettings: AudioSettings

    enum CodingKeys: String, CodingKey {
        case id, name, tracks, groups, sections
        case sectionRepeatMIDINote, sectionRepeatMIDIChannel, sectionRepeatMIDIMapped
        case preferredMIDISourceName, preferredMIDISourceUniqueID
        case snapInterval, isSnapEnabled, masterVolume, tempo, audioSettings
    }

    init(
        id: UUID,
        name: String,
        tracks: [PersistedTrack],
        groups: [TrackGroup],
        sections: [ArrangementSection],
        sectionRepeatMIDINote: UInt8 = 36,
        sectionRepeatMIDIChannel: UInt8 = 0,
        sectionRepeatMIDIMapped: Bool = false,
        preferredMIDISourceName: String? = nil,
        preferredMIDISourceUniqueID: Int32? = nil,
        snapInterval: TimeInterval,
        isSnapEnabled: Bool,
        masterVolume: Double,
        tempo: Double,
        audioSettings: AudioSettings
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

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        tracks = try container.decode([PersistedTrack].self, forKey: .tracks)
        groups = try container.decode([TrackGroup].self, forKey: .groups)
        sections = try container.decode([ArrangementSection].self, forKey: .sections)
        sectionRepeatMIDINote = try container.decodeIfPresent(UInt8.self, forKey: .sectionRepeatMIDINote) ?? 36
        sectionRepeatMIDIChannel = try container.decodeIfPresent(UInt8.self, forKey: .sectionRepeatMIDIChannel) ?? 0
        sectionRepeatMIDIMapped = try container.decodeIfPresent(Bool.self, forKey: .sectionRepeatMIDIMapped) ?? false
        preferredMIDISourceName = try container.decodeIfPresent(String.self, forKey: .preferredMIDISourceName)
        preferredMIDISourceUniqueID = try container.decodeIfPresent(Int32.self, forKey: .preferredMIDISourceUniqueID)
        snapInterval = try container.decode(TimeInterval.self, forKey: .snapInterval)
        isSnapEnabled = try container.decode(Bool.self, forKey: .isSnapEnabled)
        masterVolume = try container.decode(Double.self, forKey: .masterVolume)
        tempo = try container.decode(Double.self, forKey: .tempo)
        audioSettings = try container.decode(AudioSettings.self, forKey: .audioSettings)
    }
}
