//
//  AppLocale.swift
//  LvoqPlayback
//

import Foundation

/// UI languages shipped with the app. To add another language:
/// 1. Add a case here
/// 2. Add matching entries in `Localizable.xcstrings` and `InfoPlist.xcstrings`
/// 3. Register the code in the Xcode project's `knownRegions`
enum AppLocale: String, CaseIterable, Sendable, Identifiable {
    case english = "en"
    case spanish = "es"
    case portuguese = "pt"

    var id: String { rawValue }

    var languageCode: String { rawValue }

    var settingsNameKey: String {
        switch self {
        case .english: "settings.language.name.en"
        case .spanish: "settings.language.name.es"
        case .portuguese: "settings.language.name.pt"
        }
    }
}

enum AppLocaleCatalog {
    static let supportedLanguageCodes: [String] = AppLocale.allCases.map(\.languageCode)
}
