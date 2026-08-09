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
        case .emptySelection: "No audio files were found to import."
        case .storageUnavailable: "Could not access app storage."
        }
    }
}

struct ImportedStemsResult: Sendable {
    let stems: [TrackOrganizationService.ImportedStem]
    let notice: String?
}

/// Reads audio file metadata and prepares stems for track organization.
struct AudioImportService: Sendable {
    static let maximumImportCount = 20

    private let storage = AudioFileStorageService()

    func loadStems(from urls: [URL], projectID: UUID) throws -> ImportedStemsResult {
        let audioURLs = urls
            .filter { SupportedAudioFormats.isSupported(url: $0) }
            .sorted {
                $0.lastPathComponent.localizedCaseInsensitiveCompare($1.lastPathComponent) == .orderedAscending
            }

        guard !audioURLs.isEmpty else { throw AudioImportError.emptySelection }

        let (selectedURLs, notice) = limitedURLs(from: audioURLs)
        let stems = try importStemFiles(selectedURLs, projectID: projectID)
        return ImportedStemsResult(stems: stems, notice: notice)
    }

    func loadStemsFromFolder(_ folderURL: URL, projectID: UUID) throws -> ImportedStemsResult {
        let accessed = folderURL.startAccessingSecurityScopedResource()
        defer {
            if accessed {
                folderURL.stopAccessingSecurityScopedResource()
            }
        }

        let contents = try FileManager.default.contentsOfDirectory(
            at: folderURL,
            includingPropertiesForKeys: nil
        )
        let audioURLs = contents.filter { SupportedAudioFormats.isSupported(url: $0) }
        return try loadStems(from: audioURLs, projectID: projectID)
    }

    private func limitedURLs(from audioURLs: [URL]) -> ([URL], String?) {
        guard audioURLs.count > Self.maximumImportCount else {
            return (audioURLs, nil)
        }

        let notice = "Only the first \(Self.maximumImportCount) audio files were imported. Maximum is \(Self.maximumImportCount) per folder or selection."
        return (Array(audioURLs.prefix(Self.maximumImportCount)), notice)
    }

    private func importStemFiles(
        _ urls: [URL],
        projectID: UUID
    ) throws -> [TrackOrganizationService.ImportedStem] {
        var stems: [TrackOrganizationService.ImportedStem] = []

        for url in urls {
            let storedURL = try storage.importFile(from: url, projectID: projectID)
            let duration = try readDuration(url: storedURL)
            let name = TrackNameStandardizer.extractName(from: url)
            stems.append(.init(url: storedURL, name: name, duration: duration))
        }

        return stems.sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
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
