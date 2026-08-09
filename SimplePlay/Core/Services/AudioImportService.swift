//
//  AudioImportService.swift
//  SimplePlay
//

import AVFoundation
import Foundation

enum AudioImportError: LocalizedError {
    case unsupportedFormat
    case unreadableFile
    case emptySelection
    case storageUnavailable

    var errorDescription: String? {
        switch self {
        case .unsupportedFormat: "Unsupported audio format."
        case .unreadableFile: "Could not read audio file."
        case .emptySelection: "No audio files were selected."
        case .storageUnavailable: "Could not access app storage."
        }
    }
}

/// Reads audio file metadata and prepares stems for track organization.
struct AudioImportService: Sendable {
    private let storage = AudioFileStorageService()

    func loadStems(from urls: [URL], projectID: UUID) throws -> [TrackOrganizationService.ImportedStem] {
        guard !urls.isEmpty else { throw AudioImportError.emptySelection }

        var stems: [TrackOrganizationService.ImportedStem] = []

        for url in urls {
            guard SupportedAudioFormats.isSupported(url: url) else {
                throw AudioImportError.unsupportedFormat
            }

            let storedURL = try storage.importFile(from: url, projectID: projectID)
            let duration = try readDuration(url: storedURL)
            let name = TrackNameStandardizer.extractName(from: url)
            stems.append(.init(url: storedURL, name: name, duration: duration))
        }

        return stems.sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
    }

    func loadStemsFromFolder(_ folderURL: URL, projectID: UUID) throws -> [TrackOrganizationService.ImportedStem] {
        let accessed = folderURL.startAccessingSecurityScopedResource()
        defer {
            if accessed {
                folderURL.stopAccessingSecurityScopedResource()
            }
        }

        let fileManager = FileManager.default
        let contents = try fileManager.contentsOfDirectory(
            at: folderURL,
            includingPropertiesForKeys: nil
        )
        let audioURLs = contents.filter { SupportedAudioFormats.isSupported(url: $0) }
        return try loadStems(from: audioURLs, projectID: projectID)
    }

    private func readDuration(url: URL) throws -> TimeInterval {
        if let fileDuration = try? durationFromAudioFile(url: url), fileDuration > 0 {
            return fileDuration
        }

        let asset = AVURLAsset(url: url)
        let duration = asset.duration
        guard duration.isValid, !duration.isIndefinite else {
            throw AudioImportError.unreadableFile
        }

        let seconds = CMTimeGetSeconds(duration)
        guard seconds.isFinite, seconds > 0 else {
            throw AudioImportError.unreadableFile
        }
        return seconds
    }

    private func durationFromAudioFile(url: URL) throws -> TimeInterval {
        let file = try AVAudioFile(forReading: url)
        let sampleRate = file.processingFormat.sampleRate
        guard sampleRate > 0 else { throw AudioImportError.unreadableFile }
        return Double(file.length) / sampleRate
    }
}
