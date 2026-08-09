//
//  ProjectArchiveTests.swift
//  SimplePlayTests
//

import Foundation
import Testing

@testable import SimplePlay

struct ProjectArchiveTests {
    @Test func roundTripsSingleFileProject() throws {
        let tempDirectory = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString, isDirectory: true)
        try FileManager.default.createDirectory(at: tempDirectory, withIntermediateDirectories: true)
        defer { try? FileManager.default.removeItem(at: tempDirectory) }

        let manifest = Data("""
        {"version":1,"name":"Test"}
        """.utf8)
        let assets = [
            SimplePlayProjectArchive.Asset(
                relativePath: "audio/test.wav",
                data: Data([0x01, 0x02, 0x03])
            )
        ]

        let fileURL = tempDirectory.appendingPathComponent("Project.simpleplay")
        try SimplePlayProjectArchive.write(manifest: manifest, assets: assets, to: fileURL)

        let loaded = try SimplePlayProjectArchive.read(from: fileURL)
        #expect(loaded.manifest == manifest)
        #expect(loaded.assets.count == 1)
        #expect(loaded.assets[0].relativePath == "audio/test.wav")
        #expect(loaded.assets[0].data == Data([0x01, 0x02, 0x03]))
    }
}
