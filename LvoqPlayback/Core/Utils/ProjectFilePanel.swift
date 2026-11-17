//
//  ProjectFilePanel.swift
//  LvoqPlayback
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
        panel.prompt = L10n.Panel.save
        panel.title = L10n.Panel.saveTitle
        return panel.runModal() == .OK ? panel.url : nil
    }

    static func chooseOpenURL() -> URL? {
        let panel = NSOpenPanel()
        panel.canChooseDirectories = true
        panel.canChooseFiles = true
        panel.allowsOtherFileTypes = true
        panel.treatsFilePackagesAsDirectories = true
        panel.allowsMultipleSelection = false
        panel.prompt = L10n.Panel.open
        panel.title = L10n.Panel.openTitle
        return panel.runModal() == .OK ? panel.url : nil
    }

    static func chooseAudioFilesForImport() -> [URL]? {
        let panel = NSOpenPanel()
        panel.canChooseFiles = true
        panel.canChooseDirectories = false
        panel.allowsMultipleSelection = true
        panel.allowsOtherFileTypes = false
        panel.allowedContentTypes = SupportedAudioFormats.filePickerTypes
        panel.prompt = L10n.Panel.importLabel
        panel.title = L10n.Panel.importFilesTitle
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
        panel.prompt = L10n.Panel.importLabel
        panel.title = L10n.Panel.importFolderTitle
        guard panel.runModal() == .OK else { return nil }
        return panel.url
    }
}
#endif
