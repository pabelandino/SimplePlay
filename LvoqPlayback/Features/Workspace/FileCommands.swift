//
//  FileCommands.swift
//  LvoqPlayback
//

import SwiftUI

struct FileCommands: Commands {
    @Bindable var viewModel: WorkspaceViewModel

    var body: some Commands {
        CommandGroup(replacing: .saveItem) {
            Button(L10n.File.saveProject) {
                viewModel.saveProject()
            }
            .keyboardShortcut("s", modifiers: .command)

            Button(L10n.File.saveProjectAs) {
                viewModel.saveProjectAs()
            }
            .keyboardShortcut("s", modifiers: [.command, .shift])
        }

        CommandGroup(after: .newItem) {
            Button(L10n.File.openProject) {
                viewModel.openProject()
            }
            .keyboardShortcut("o", modifiers: .command)
        }
    }
}
