//
//  FileCommands.swift
//  SimplePlay
//

import SwiftUI

struct FileCommands: Commands {
    @Bindable var viewModel: WorkspaceViewModel

    var body: some Commands {
        CommandGroup(replacing: .saveItem) {
            Button("Save Project") {
                viewModel.saveProject()
            }
            .keyboardShortcut("s", modifiers: .command)

            Button("Save Project As…") {
                viewModel.saveProjectAs()
            }
            .keyboardShortcut("s", modifiers: [.command, .shift])
        }

        CommandGroup(after: .newItem) {
            Button("Open Project…") {
                viewModel.openProject()
            }
            .keyboardShortcut("o", modifiers: .command)
        }
    }
}
