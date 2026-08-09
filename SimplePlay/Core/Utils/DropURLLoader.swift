//
//  DropURLLoader.swift
//  SimplePlay
//

import Foundation
import UniformTypeIdentifiers

/// Loads file and folder URLs from drag-and-drop item providers.
enum DropURLLoader {
    private static let supportedTypeIdentifiers = [
        UTType.fileURL.identifier,
        UTType.folder.identifier,
        UTType.audio.identifier,
        UTType.wav.identifier,
        UTType.aiff.identifier,
        UTType.mp3.identifier
    ]

    static func loadURLs(from providers: [NSItemProvider]) async -> [URL] {
        var urls: [URL] = []

        await withTaskGroup(of: URL?.self) { group in
            for provider in providers {
                group.addTask {
                    await loadURL(from: provider)
                }
            }

            for await url in group {
                if let url {
                    urls.append(url)
                }
            }
        }

        return urls
    }

    private static func loadURL(from provider: NSItemProvider) async -> URL? {
        for typeIdentifier in supportedTypeIdentifiers where provider.hasItemConformingToTypeIdentifier(typeIdentifier) {
            if let url = try? await loadFileURL(from: provider, typeIdentifier: typeIdentifier) {
                return url
            }
        }
        return nil
    }

    private static func loadFileURL(from provider: NSItemProvider, typeIdentifier: String) async throws -> URL? {
        try await withCheckedThrowingContinuation { continuation in
            provider.loadItem(forTypeIdentifier: typeIdentifier, options: nil) { item, error in
                if let error {
                    continuation.resume(throwing: error)
                    return
                }

                if let url = item as? URL {
                    continuation.resume(returning: url)
                    return
                }

                if let data = item as? Data,
                   let url = URL(dataRepresentation: data, relativeTo: nil) {
                    continuation.resume(returning: url)
                    return
                }

                if let string = item as? String,
                   let url = URL(string: string) {
                    continuation.resume(returning: url)
                    return
                }

                continuation.resume(returning: nil)
            }
        }
    }
}
