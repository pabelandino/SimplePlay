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
    var clips: [PersistedClip]
}

struct PersistedProject: Codable, Sendable, Equatable {
    let id: UUID
    var name: String
    var tracks: [PersistedTrack]
    var groups: [TrackGroup]
    var sections: [ArrangementSection]
    var snapInterval: TimeInterval
    var isSnapEnabled: Bool
    var masterVolume: Double
    var tempo: Double
    var audioSettings: AudioSettings
}
