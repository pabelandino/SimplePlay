//
//  ProjectFilePanel.swift
//  SimplePlay
//

import Foundation

#if os(macOS)
import AppKit

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
}
#endif
