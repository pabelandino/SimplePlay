//
//  AppLocalization.swift
//  LvoqPlayback
//

import Foundation
import SwiftUI

/// In-app language override. When `preferredLanguageCode` is `nil`, the app follows the system.
enum AppLocalization {
    private(set) static var preferredLanguageCode: String?

    static func apply(preferredLanguageCode code: String?) {
        let normalized: String?
        if let code, AppLocale(rawValue: code) != nil {
            normalized = code
        } else {
            normalized = nil
        }
        preferredLanguageCode = normalized
    }

    static var resolvedLocale: Locale {
        guard let code = preferredLanguageCode else {
            return .autoupdatingCurrent
        }
        return Locale(identifier: code)
    }

    /// Use with `.environment(\.locale, …)` only when overriding; omit the modifier for system default.
    static var environmentLocale: Locale? {
        guard let code = preferredLanguageCode else { return nil }
        return Locale(identifier: code)
    }
}

private struct AppLocaleEnvironmentModifier: ViewModifier {
    let languageCode: String?

    func body(content: Content) -> some View {
        if let code = languageCode, AppLocale(rawValue: code) != nil {
            content.environment(\.locale, Locale(identifier: code))
        } else {
            content
        }
    }
}

extension View {
    func appLocaleEnvironment(languageCode: String?) -> some View {
        modifier(AppLocaleEnvironmentModifier(languageCode: languageCode))
    }

    /// Applies the saved language, or the system language when no override is stored.
    func appLocaleEnvironment() -> some View {
        modifier(AppLanguageRootModifier())
    }
}

private struct AppLanguageRootModifier: ViewModifier {
    @Bindable private var language = AppLanguageStore.shared

    func body(content: Content) -> some View {
        let _ = language.revision
        content.appLocaleEnvironment(languageCode: language.languageCode)
    }
}
