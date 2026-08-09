//
//  SimplePlayProjectFileDocument.swift
//  SimplePlay
//

import SwiftUI
import UniformTypeIdentifiers

struct SimplePlayProjectFileDocument: FileDocument {
    static var readableContentTypes: [UTType] { [.simplePlayProject] }

    var data: Data

    init(data: Data) {
        self.data = data
    }

    init(configuration: ReadConfiguration) throws {
        guard let data = configuration.file.regularFileContents else {
            throw SimplePlayProjectArchiveError.invalidArchive
        }
        self.data = data
    }

    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        FileWrapper(regularFileWithContents: data)
    }
}
