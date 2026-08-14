//
//  EditCommands.swift
//  SimplePlay
//

import SwiftUI

struct EditCommands: Commands {
    @Bindable var viewModel: WorkspaceViewModel

    var body: some Commands {
        CommandGroup(replacing: .undoRedo) {
            Button("Undo") {
                viewModel.undo()
            }
            .keyboardShortcut("z", modifiers: .command)
            .disabled(!viewModel.canUndo)

            Button("Redo") {
                viewModel.redo()
            }
            .keyboardShortcut("z", modifiers: [.command, .shift])
            .disabled(!viewModel.canRedo)
        }
    }
}
