//
//  StandardTrackRole.swift
//  SimplePlay
//

import Foundation
import SwiftUI

/// Canonical instrument / bus roles used for ordering, grouping, and color assignment.
enum StandardTrackRole: String, Codable, CaseIterable, Sendable, Identifiable {
    case click = "CLK"
    case cue = "CUE"
    case guide = "GDE"
    case countIn = "CNT"
    case leadVocal = "LD"
    case backingVocal = "BV"
    case electricGuitar = "EG"
    case acousticGuitar = "AG"
    case bass = "BS"
    case drums = "DR"
    case keys = "KY"
    case piano = "PN"
    case synth = "SY"
    case strings = "ST"
    case brass = "BR"
    case percussion = "PC"
    case loop = "LP"
    case fx = "FX"
    case unknown = "UNK"

    var id: String { rawValue }

    /// Priority for vertical ordering. Lower values appear first.
    var sortPriority: Int {
        switch self {
        case .click: 0
        case .cue: 1
        case .guide: 2
        case .countIn: 3
        case .drums: 10
        case .bass: 20
        case .keys, .piano: 30
        case .electricGuitar, .acousticGuitar: 40
        case .leadVocal: 50
        case .backingVocal: 60
        case .synth, .strings, .brass, .percussion, .loop, .fx: 70
        case .unknown: 999
        }
    }

    var displayName: String {
        switch self {
        case .click: "Click"
        case .cue: "Cue"
        case .guide: "Guide"
        case .countIn: "Count In"
        case .leadVocal: "Lead Vocal"
        case .backingVocal: "Backing Vocal"
        case .electricGuitar: "Electric Guitar"
        case .acousticGuitar: "Acoustic Guitar"
        case .bass: "Bass"
        case .drums: "Drums"
        case .keys: "Keys"
        case .piano: "Piano"
        case .synth: "Synth"
        case .strings: "Strings"
        case .brass: "Brass"
        case .percussion: "Percussion"
        case .loop: "Loop"
        case .fx: "FX"
        case .unknown: "Unknown"
        }
    }

    var defaultColor: Color {
        TrackColorPalette.color(for: self)
    }
}
