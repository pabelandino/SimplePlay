//
//  EditCommands.swift
//  LvoqPlayback
//

import SwiftUI

struct EditCommands: Commands {
    @Bindable var viewModel: WorkspaceViewModel

    var body: some Commands {
        CommandGroup(replacing: .undoRedo) {
            Button(L10n.Transport.undo) {
                viewModel.undo()
            }
            .keyboardShortcut("z", modifiers: .command)
            .disabled(!viewModel.canUndo)

            Button(L10n.Transport.redo) {
                viewModel.redo()
            }
            .keyboardShortcut("z", modifiers: [.command, .shift])
            .disabled(!viewModel.canRedo)
        }
    }
}
