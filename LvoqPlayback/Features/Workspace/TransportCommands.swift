//
//  TransportCommands.swift
//  LvoqPlayback
//

import SwiftUI

struct TransportCommands: Commands {
    @Bindable var viewModel: WorkspaceViewModel

    var body: some Commands {
        CommandMenu(L10n.Transport.menu) {
            Button(viewModel.isPlaying ? L10n.Common.pause : L10n.Common.play) {
                viewModel.togglePlayback()
            }
            .keyboardShortcut(.space, modifiers: [])

            Button(L10n.Common.stop) {
                viewModel.stop()
            }
            .keyboardShortcut(.return, modifiers: [])
        }
    }
}

struct WorkspaceKeyboardShortcuts: ViewModifier {
    @Bindable var viewModel: WorkspaceViewModel

    func body(content: Content) -> some View {
        content
#if os(macOS)
            .focusable()
            .focusEffectDisabled()
            .onKeyPress(.space, phases: .down) { press in
                guard !press.modifiers.contains(.command), !press.modifiers.contains(.option) else {
                    return .ignored
                }
                viewModel.togglePlayback()
                return .handled
            }
            .onKeyPress(.return, phases: .down) { press in
                guard !press.modifiers.contains(.command) else { return .ignored }
                viewModel.stop()
                return .handled
            }
            .onKeyPress(.init("a"), phases: .down) { press in
                guard press.modifiers.contains(.command) else { return .ignored }
                viewModel.selectAllClips()
                return .handled
            }
            .onKeyPress(.init("z"), phases: .down) { press in
                guard press.modifiers.contains(.command) else { return .ignored }
                if press.modifiers.contains(.shift) {
                    guard viewModel.canRedo else { return .ignored }
                    viewModel.redo()
                } else {
                    guard viewModel.canUndo else { return .ignored }
                    viewModel.undo()
                }
                return .handled
            }
#endif
    }
}

extension View {
    func workspaceKeyboardShortcuts(viewModel: WorkspaceViewModel) -> some View {
        modifier(WorkspaceKeyboardShortcuts(viewModel: viewModel))
    }
}
