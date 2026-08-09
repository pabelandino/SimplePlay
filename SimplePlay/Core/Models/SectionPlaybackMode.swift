//
//  SectionPlaybackMode.swift
//  SimplePlay
//

import Foundation

/// How an arrangement section behaves when triggered via MIDI.
enum SectionPlaybackMode: String, Codable, CaseIterable, Sendable, Identifiable {
    /// Loop the section until another trigger is received.
    case repeatSection = "repeat"
    /// Play once, then continue normal timeline playback.
    case continueTimeline = "continue"
    /// Play once, then jump to the next linked section if configured.
    case continueToNext = "continue_to_next"
    /// Play once and stop at section end.
    case oneShot = "one_shot"

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .repeatSection: "Repeat"
        case .continueTimeline: "Continue"
        case .continueToNext: "Continue to Next"
        case .oneShot: "One Shot"
        }
    }
}
