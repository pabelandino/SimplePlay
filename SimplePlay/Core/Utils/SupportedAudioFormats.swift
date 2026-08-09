//
//  SupportedAudioFormats.swift
//  SimplePlay
//

import UniformTypeIdentifiers

enum SupportedAudioFormats {
    static let fileExtensions: Set<String> = ["wav", "aiff", "aif", "caf", "mp3", "m4a", "aac", "flac"]

    static var contentTypes: [UTType] {
        [
            .wav,
            .aiff,
            .mp3,
            .mpeg4Audio,
            .audio
        ]
    }

    static var dropTypes: [UTType] {
        contentTypes + [.fileURL, .folder]
    }

    static func isSupported(url: URL) -> Bool {
        let ext = url.pathExtension.lowercased()
        return fileExtensions.contains(ext)
    }
}
