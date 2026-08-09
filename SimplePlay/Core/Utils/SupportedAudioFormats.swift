//
//  SupportedAudioFormats.swift
//  SimplePlay
//

import UniformTypeIdentifiers

enum SupportedAudioFormats {
    static let fileExtensions: Set<String> = ["wav", "aiff", "aif", "caf", "mp3", "m4a", "aac", "flac"]

    static var contentTypes: [UTType] {
        var types: [UTType] = [.audio, .wav, .aiff, .mp3, .mpeg4Audio]
        for ext in fileExtensions {
            if let type = UTType(filenameExtension: ext) {
                types.append(type)
            }
        }
        return deduplicated(types)
    }

    static var filePickerTypes: [UTType] {
        contentTypes
    }

    static var folderPickerTypes: [UTType] {
        [.folder]
    }

    static var importPickerTypes: [UTType] {
        deduplicated(contentTypes + [.folder])
    }

    static var dropTypes: [UTType] {
        deduplicated(contentTypes + [.fileURL, .folder, .item])
    }

    private static func deduplicated(_ types: [UTType]) -> [UTType] {
        var seen = Set<String>()
        return types.filter { seen.insert($0.identifier).inserted }
    }

    static func isSupported(url: URL) -> Bool {
        let ext = url.pathExtension.lowercased()
        return fileExtensions.contains(ext)
    }
}
