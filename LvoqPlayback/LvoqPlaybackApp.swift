//
//  LvoqPlaybackApp.swift
//  LvoqPlayback
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
struct LvoqPlaybackApp: App {
#if os(macOS)
    @NSApplicationDelegateAdaptor(MacAppDelegate.self) private var appDelegate
#endif
    @State private var viewModel = WorkspaceViewModel()
    @State private var language = AppLanguageStore.shared

    var body: some Scene {
        let _ = language.revision
        WindowGroup {
            ContentView(viewModel: viewModel)
                .appLocaleEnvironment()
        }
#if os(macOS)
        .defaultSize(width: 1280, height: 800)
        .windowStyle(.hiddenTitleBar)
        .commands {
            FileCommands(viewModel: viewModel)
            EditCommands(viewModel: viewModel)
            TransportCommands(viewModel: viewModel)
        }
#endif
    }
}
