//
//  ProjectPersistenceService.swift
//  SimplePlay
//

import Foundation

enum ProjectPersistenceError: LocalizedError {
    case invalidPackage
    case missingManifest
    case missingAudioFile(String)
    case unsupportedVersion(Int)

    var errorDescription: String? {
        switch self {
        case .invalidPackage: "Invalid project file."
        case .missingManifest: "Project manifest not found."
        case .missingAudioFile(let name): "Missing audio file: \(name)"
        case .unsupportedVersion(let version): "Unsupported project version: \(version)"
        }
    }
}

struct ProjectPersistenceService: Sendable {
    static let packageExtension = SimplePlayProjectType.fileExtension

    private let manifestName = "project.json"
    private let audioFolderName = "audio"

    func exportData(document: SavedProjectDocument) throws -> Data {
        let (manifestData, assets) = try buildArchivePayload(from: document)
        return SimplePlayProjectArchive.makeData(manifest: manifestData, assets: assets)
    }

    func save(document: SavedProjectDocument, to fileURL: URL) throws {
        let (manifestData, assets) = try buildArchivePayload(from: document)
        try SimplePlayProjectArchive.write(manifest: manifestData, assets: assets, to: fileURL)
    }

    func load(from url: URL) throws -> SavedProjectDocument {
        let resolvedURL = normalizedProjectURL(url)

        if isLegacyPackage(at: resolvedURL) {
            return try loadLegacyPackage(from: resolvedURL)
        }

        guard SimplePlayProjectArchive.isArchiveFile(at: resolvedURL) else {
            throw ProjectPersistenceError.invalidPackage
        }

        let (manifestData, assets) = try SimplePlayProjectArchive.read(from: resolvedURL)
        let manifest = try JSONDecoder.projectDecoder.decode(ManifestFile.self, from: manifestData)

        guard manifest.version <= SavedProjectDocument.currentVersion else {
            throw ProjectPersistenceError.unsupportedVersion(manifest.version)
        }

        let cacheRoot = openedProjectCacheRoot(for: manifest.project.id)
        try prepareDirectory(cacheRoot)
        try prepareDirectory(cacheRoot.appendingPathComponent(audioFolderName, isDirectory: true))

        for asset in assets {
            let destination = cacheRoot.appendingPathComponent(asset.relativePath)
            try prepareParentDirectory(for: destination)
            try asset.data.write(to: destination, options: .atomic)
        }

        let project = restoreRuntimeProject(from: manifest.project, packageURL: cacheRoot)
        return SavedProjectDocument(project: project, workspace: manifest.workspace)
    }

    private func buildArchivePayload(from document: SavedProjectDocument) throws -> (Data, [SimplePlayProjectArchive.Asset]) {
        let fileManager = FileManager.default
        let tempRoot = fileManager.temporaryDirectory
            .appendingPathComponent("SimplePlaySave-\(UUID().uuidString)", isDirectory: true)
        let audioDirectory = tempRoot.appendingPathComponent(audioFolderName, isDirectory: true)

        try prepareDirectory(tempRoot)
        try prepareDirectory(audioDirectory)
        defer { try? fileManager.removeItem(at: tempRoot) }

        let persistedProject = try makePersistedProject(from: document.project, audioDirectory: audioDirectory)
        let manifest = ManifestFile(
            version: SavedProjectDocument.currentVersion,
            workspace: document.workspace,
            project: persistedProject
        )
        let manifestData = try JSONEncoder.pretty.encode(manifest)

        let audioFiles = try fileManager.contentsOfDirectory(at: audioDirectory, includingPropertiesForKeys: nil)
        let assets = try audioFiles.map { fileURL in
            SimplePlayProjectArchive.Asset(
                relativePath: "\(audioFolderName)/\(fileURL.lastPathComponent)",
                data: try Data(contentsOf: fileURL)
            )
        }

        return (manifestData, assets)
    }

    private func loadLegacyPackage(from packageURL: URL) throws -> SavedProjectDocument {
        let manifestURL = packageURL.appendingPathComponent(manifestName)
        guard FileManager.default.fileExists(atPath: manifestURL.path) else {
            throw ProjectPersistenceError.missingManifest
        }

        let data = try Data(contentsOf: manifestURL)
        let manifest = try JSONDecoder.projectDecoder.decode(ManifestFile.self, from: data)

        guard manifest.version <= SavedProjectDocument.currentVersion else {
            throw ProjectPersistenceError.unsupportedVersion(manifest.version)
        }

        let project = restoreRuntimeProject(from: manifest.project, packageURL: packageURL)
        return SavedProjectDocument(project: project, workspace: manifest.workspace)
    }

    private func isLegacyPackage(at url: URL) -> Bool {
        var isDirectory: ObjCBool = false
        guard FileManager.default.fileExists(atPath: url.path, isDirectory: &isDirectory), isDirectory.boolValue else {
            return false
        }

        let manifestURL = url.appendingPathComponent(manifestName)
        return FileManager.default.fileExists(atPath: manifestURL.path)
    }

    private func openedProjectCacheRoot(for projectID: UUID) -> URL {
        let base = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        return base
            .appendingPathComponent("SimplePlay/OpenedProjects", isDirectory: true)
            .appendingPathComponent(projectID.uuidString, isDirectory: true)
    }

    private func normalizedProjectURL(_ url: URL) -> URL {
        if url.pathExtension.isEmpty {
            return url.appendingPathExtension(Self.packageExtension)
        }
        return url
    }

    private func prepareDirectory(_ url: URL) throws {
        try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)
    }

    private func prepareParentDirectory(for url: URL) throws {
        try FileManager.default.createDirectory(
            at: url.deletingLastPathComponent(),
            withIntermediateDirectories: true
        )
    }

    private func makePersistedProject(from project: DAWProject, audioDirectory: URL) throws -> PersistedProject {
        let fileManager = FileManager.default
        var persistedTracks: [PersistedTrack] = []

        for track in project.tracks {
            var persistedClips: [PersistedClip] = []

            for clip in track.clips {
                let destinationName = "\(clip.id.uuidString)-\(clip.fileURL.lastPathComponent)"
                let destinationURL = audioDirectory.appendingPathComponent(destinationName)

                guard fileManager.fileExists(atPath: clip.fileURL.path) else {
                    throw ProjectPersistenceError.missingAudioFile(clip.fileURL.lastPathComponent)
                }

                if fileManager.fileExists(atPath: destinationURL.path) {
                    try fileManager.removeItem(at: destinationURL)
                }
                try fileManager.copyItem(at: clip.fileURL, to: destinationURL)

                persistedClips.append(
                    PersistedClip(
                        id: clip.id,
                        name: clip.name,
                        audioFileName: destinationName,
                        startTime: clip.startTime,
                        duration: clip.duration,
                        sourceOffset: clip.sourceOffset,
                        groupIndex: clip.groupIndex
                    )
                )
            }

            persistedTracks.append(
                PersistedTrack(
                    id: track.id,
                    originalName: track.originalName,
                    standardCode: track.standardCode,
                    role: track.role,
                    colorHex: track.colorHex,
                    isMuted: track.isMuted,
                    isSolo: track.isSolo,
                    isLocked: track.isLocked,
                    pan: track.pan,
                    volume: track.volume,
                    pitchSemitones: track.pitchSemitones,
                    isPitchEnabled: track.isPitchEnabled,
                    clips: persistedClips
                )
            )
        }

        return PersistedProject(
            id: project.id,
            name: project.name,
            tracks: persistedTracks,
            groups: project.groups,
            sections: project.sections,
            sectionRepeatMIDINote: project.sectionRepeatMIDINote,
            sectionRepeatMIDIChannel: project.sectionRepeatMIDIChannel,
            sectionRepeatMIDIMapped: project.sectionRepeatMIDIMapped,
            preferredMIDISourceName: project.preferredMIDISourceName,
            preferredMIDISourceUniqueID: project.preferredMIDISourceUniqueID,
            snapInterval: project.snapInterval,
            isSnapEnabled: project.isSnapEnabled,
            masterVolume: project.masterVolume,
            tempo: project.tempo,
            audioSettings: project.audioSettings
        )
    }

    private func restoreRuntimeProject(from persisted: PersistedProject, packageURL: URL) -> DAWProject {
        let audioDirectory = packageURL.appendingPathComponent(audioFolderName, isDirectory: true)

        var tracks = persisted.tracks.map { track in
            AudioTrack(
                id: track.id,
                originalName: track.originalName,
                standardCode: track.standardCode,
                role: track.role,
                colorHex: track.colorHex,
                isMuted: track.isMuted,
                isSolo: track.isSolo,
                isLocked: track.isLocked,
                pan: track.pan,
                volume: track.volume,
                pitchSemitones: track.pitchSemitones,
                isPitchEnabled: track.isPitchEnabled,
                clips: track.clips.map { clip in
                    AudioClip(
                        id: clip.id,
                        name: clip.name,
                        fileURL: audioDirectory.appendingPathComponent(clip.audioFileName),
                        startTime: clip.startTime,
                        duration: clip.duration,
                        sourceOffset: clip.sourceOffset,
                        groupIndex: clip.groupIndex
                    )
                }
            )
        }

        migrateLegacyGroupPitch(into: &tracks, groups: persisted.groups)
        TrackColorPalette.ensureDistinctColors(on: &tracks)

        return DAWProject(
            id: persisted.id,
            name: persisted.name,
            tracks: tracks,
            groups: persisted.groups,
            sections: persisted.sections,
            sectionRepeatMIDINote: persisted.sectionRepeatMIDINote,
            sectionRepeatMIDIChannel: persisted.sectionRepeatMIDIChannel,
            sectionRepeatMIDIMapped: persisted.sectionRepeatMIDIMapped,
            preferredMIDISourceName: persisted.preferredMIDISourceName,
            preferredMIDISourceUniqueID: persisted.preferredMIDISourceUniqueID,
            snapInterval: persisted.snapInterval,
            isSnapEnabled: persisted.isSnapEnabled,
            masterVolume: persisted.masterVolume,
            tempo: persisted.tempo,
            audioSettings: persisted.audioSettings
        )
    }

    private func migrateLegacyGroupPitch(into tracks: inout [AudioTrack], groups: [TrackGroup]) {
        for index in tracks.indices {
            guard !tracks[index].isPitchEnabled,
                  abs(tracks[index].pitchSemitones) < 0.001 else { continue }

            let groupIndices = Set(tracks[index].clips.map(\.groupIndex))
            guard groupIndices.count == 1,
                  let groupIndex = groupIndices.first,
                  groups.indices.contains(groupIndex)
            else { continue }

            let legacyPitch = groups[groupIndex].pitchSemitones
            guard abs(legacyPitch) > 0.001 else { continue }

            tracks[index].pitchSemitones = PitchShiftSettings.clampSemitones(legacyPitch)
            tracks[index].isPitchEnabled = true
        }
    }
}

private struct ManifestFile: Codable {
    var version: Int
    var workspace: SavedProjectDocument.WorkspaceSnapshot
    var project: PersistedProject
}

private extension JSONEncoder {
    static var pretty: JSONEncoder {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        encoder.dateEncodingStrategy = .iso8601
        return encoder
    }
}

private extension JSONDecoder {
    static var projectDecoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }
}
