//
//  ProjectFilePanel.swift
//  SimplePlay
//

import Foundation

#if os(macOS)
import AppKit
import UniformTypeIdentifiers

enum ProjectFilePanel {
    static func chooseSaveURL(defaultName: String) -> URL? {
        let panel = NSSavePanel()
        panel.canCreateDirectories = true
        panel.nameFieldStringValue = "\(defaultName).\(ProjectPersistenceService.packageExtension)"
        panel.prompt = "Save"
        panel.title = "Save Project"
        return panel.runModal() == .OK ? panel.url : nil
    }

    static func chooseOpenURL() -> URL? {
        let panel = NSOpenPanel()
        panel.canChooseDirectories = true
        panel.canChooseFiles = true
        panel.allowsOtherFileTypes = true
        panel.treatsFilePackagesAsDirectories = true
        panel.allowsMultipleSelection = false
        panel.prompt = "Open"
        panel.title = "Open Project"
        return panel.runModal() == .OK ? panel.url : nil
    }

    static func chooseAudioFilesForImport() -> [URL]? {
        let panel = NSOpenPanel()
        panel.canChooseFiles = true
        panel.canChooseDirectories = false
        panel.allowsMultipleSelection = true
        panel.allowsOtherFileTypes = false
        panel.allowedContentTypes = SupportedAudioFormats.filePickerTypes
        panel.prompt = "Import"
        panel.title = "Import Audio Files"
        guard panel.runModal() == .OK else { return nil }
        return panel.urls
    }

    static func chooseFolderForImport() -> URL? {
        let panel = NSOpenPanel()
        panel.canChooseFiles = false
        panel.canChooseDirectories = true
        panel.allowsMultipleSelection = false
        panel.allowsOtherFileTypes = false
        panel.allowedContentTypes = SupportedAudioFormats.folderPickerTypes
        panel.prompt = "Import"
        panel.title = "Import Folder"
        guard panel.runModal() == .OK else { return nil }
        return panel.url
    }
}
#endif
