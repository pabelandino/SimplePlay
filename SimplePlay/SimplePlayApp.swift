//
//  SimplePlayApp.swift
//  SimplePlay
//

import SwiftUI

@main
struct SimplePlayApp: App {
    @State private var viewModel = WorkspaceViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: viewModel)
        }
#if os(macOS)
        .defaultSize(width: 1280, height: 800)
        .commands {
            FileCommands(viewModel: viewModel)
            TransportCommands(viewModel: viewModel)
        }
#endif
    }
}
