//
//  MacWindowTitleBarHidden.swift
//  SimplePlay
//

import SwiftUI

#if os(macOS)
import AppKit

enum MacWindowConfigurator {
    static func apply(to window: NSWindow) {
        window.styleMask.insert(.fullSizeContentView)
        window.titleVisibility = .hidden
        window.titlebarAppearsTransparent = true
        window.isMovableByWindowBackground = false
        window.isOpaque = true
        window.backgroundColor = NSColor(DAWTheme.surface)
        window.toolbar = nil

        if #available(macOS 11.0, *) {
            window.titlebarSeparatorStyle = .none
            window.toolbarStyle = .unifiedCompact
        }

        window.standardWindowButton(.closeButton)?.isHidden = false
        window.standardWindowButton(.miniaturizeButton)?.isHidden = false
        window.standardWindowButton(.zoomButton)?.isHidden = false
    }

    static func configureAllWindows() {
        for window in NSApplication.shared.windows {
            apply(to: window)
        }
    }
}

/// Drag handle limited to the custom title-bar strip (traffic-light row).
struct MacWindowDragRegion: NSViewRepresentable {
    func makeNSView(context: Context) -> WindowDragView {
        WindowDragView()
    }

    func updateNSView(_ nsView: WindowDragView, context: Context) {}
}

final class WindowDragView: NSView {
    override func mouseDown(with event: NSEvent) {
        window?.performDrag(with: event)
    }
}

/// Makes the native window use a transparent, hidden title bar so the app chrome is fully custom.
struct MacWindowTitleBarHidden: NSViewRepresentable {
    func makeNSView(context: Context) -> WindowTitleBarConfigurator {
        WindowTitleBarConfigurator()
    }

    func updateNSView(_ nsView: WindowTitleBarConfigurator, context: Context) {
        nsView.applyConfiguration()
    }
}

final class WindowTitleBarConfigurator: NSView {
    override func viewDidMoveToWindow() {
        super.viewDidMoveToWindow()
        applyConfiguration()
    }

    override func layout() {
        super.layout()
        applyConfiguration()
    }

    func applyConfiguration() {
        guard let window else { return }
        MacWindowConfigurator.apply(to: window)
    }
}
#endif
