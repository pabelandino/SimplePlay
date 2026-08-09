//
//  DAWTheme.swift
//  SimplePlay
//

import SwiftUI

enum DAWTheme {
    static let background = Color(hex: "#0D0D0F")!
    static let surface = Color(hex: "#151518")!
    static let surfaceElevated = Color(hex: "#1C1C21")!
    static let border = Color(hex: "#2A2A30")!
    static let textPrimary = Color.white
    static let textSecondary = Color(hex: "#8E8E93")!
    static let accent = Color(hex: "#FF9500")!
    static let playhead = Color(hex: "#FF3B30")!
    static let timelineRuler = Color(hex: "#3A3A40")!
    static let selection = Color.white.opacity(0.15)
    static let mutedTrack = Color(hex: "#5A5A62")!

    static let trackHeaderWidth: CGFloat = 248
    static let propertiesMinWidth: CGFloat = 220
    static let propertiesMaxWidth: CGFloat = 380
    static let propertiesDefaultWidth: CGFloat = 260
    static let sidebarHandleWidth: CGFloat = 6
    static let transportHeight: CGFloat = 88
    static let toolbarHeight: CGFloat = 52
    static let trackRowHeight: CGFloat = 72
    static let pixelsPerSecond: CGFloat = 80
    static let minZoom: Double = 0.05
    static let maxZoom: Double = 8.0
}
