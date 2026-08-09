//
//  SimplePlayApp.swift
//  SimplePlay
//

import SwiftUI

#if os(macOS)
import AppKit

final class MacAppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        MacWindowConfigurator.configureAllWindows()
    }

    func applicationDidBecomeActive(_ notification: Notification) {
        MacWindowConfigurator.configureAllWindows()
    }
}
#endif

@main
struct SimplePlayApp: App {
#if os(macOS)
    @NSApplicationDelegateAdaptor(MacAppDelegate.self) private var appDelegate
#endif
    @State private var viewModel = WorkspaceViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: viewModel)
        }
#if os(macOS)
        .defaultSize(width: 1280, height: 800)
        .windowStyle(.hiddenTitleBar)
        .commands {
            FileCommands(viewModel: viewModel)
            TransportCommands(viewModel: viewModel)
        }
#endif
    }
}
