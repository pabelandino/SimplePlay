//
//  DAWTheme.swift
//  SimplePlay
//

import SwiftUI
#if os(iOS)
import UIKit
#endif

enum DAWTheme {
#if os(iOS)
    static var isPhone: Bool {
        UIDevice.current.userInterfaceIdiom == .phone
    }
#else
    static var isPhone: Bool { false }
#endif
    static let background = Color(hex: "#0D0D0F")!
    static let surface = Color(hex: "#151518")!
    static let surfaceElevated = Color(hex: "#1C1C21")!
    static let border = Color(hex: "#2A2A30")!
    static let textPrimary = Color.white
    static let textSecondary = Color(hex: "#8E8E93")!
    static let accent = Color(hex: "#FF9500")!
    static let faderFill = Color(white: 0.78)
    static let playhead = Color(hex: "#7EB8FF")!
    static let playheadGlow = Color(hex: "#7EB8FF")!.opacity(0.35)
    static let overviewViewport = Color(hex: "#FF9500")!.opacity(0.22)
    static let timelineRuler = Color(hex: "#3A3A40")!
    static let selection = Color.white.opacity(0.15)
    static let mutedTrack = Color(hex: "#5A5A62")!

    static let rulerHeight: CGFloat = 28
    static let markerLaneHeight: CGFloat = 68
    static let trackHeaderWidth: CGFloat = 268
    static let propertiesMinWidth: CGFloat = 220
    static let propertiesMaxWidth: CGFloat = 380
    static let propertiesDefaultWidth: CGFloat = 260
    static let sidebarHandleWidth: CGFloat = 6
    static let compactTrackHeaderWidth: CGFloat = 158
    static let compactTrackRowHeight: CGFloat = 56
    static let compactToolbarHeight: CGFloat = 44
    static let compactTransportHeight: CGFloat = 96
    static let phoneTransportDockHeight: CGFloat = 82
    static let phoneMixerStripHeight: CGFloat = 206
    static let transportHeight: CGFloat = 96
    static let toolbarHeight: CGFloat = 52
#if os(macOS)
    /// Vertical space reserved for traffic-light window controls.
    static let macTitleBarTopInset: CGFloat = 28
    static let macTrafficLightLeadingInset: CGFloat = 72
#endif
    static let trackRowHeight: CGFloat = 72
    static let pixelsPerSecond: CGFloat = 80
    /// Hard lower bound for zoom; actual minimum may be higher to fit the full timeline.
    static let absoluteMinZoom: Double = 0.001
    static let maxZoom: Double = 8.0
    static let timelineTailPaddingSeconds: TimeInterval = 30
    static let timelineZoomHorizontalInset: CGFloat = 32
    static let emptyTimelineMinimumWidth: CGFloat = 800
}
