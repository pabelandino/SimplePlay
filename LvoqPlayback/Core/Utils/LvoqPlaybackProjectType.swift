//
//  LvoqPlaybackProjectType.swift
//  LvoqPlayback
//

import UniformTypeIdentifiers

extension UTType {
    static let simplePlayProject = UTType(exportedAs: "com.pabel.simpleplay.project", conformingTo: .data)
}

enum LvoqPlaybackProjectType {
    /// Legacy extension kept so existing projects still open.
    static let fileExtension = "simpleplay"
    static let additionalFileExtension = "lvoqplayback"
}
