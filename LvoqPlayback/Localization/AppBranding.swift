//
//  AppBranding.swift
//  LvoqPlayback
//

import Foundation

enum AppBranding {
    static let bundleIdentifier = "com.lvoqplayback.app"

    /// User-visible app name from the string catalog (follows system language or in-app override).
    static var displayName: String { L10n.App.displayName }

    /// Companion lyric app shown in sync UI.
    static var companionName: String { L10n.App.companionName }
}
