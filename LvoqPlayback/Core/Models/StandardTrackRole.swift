//
//  StandardTrackRole.swift
//  LvoqPlayback
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
        case .click: L10n.TrackRole.click
        case .cue: L10n.TrackRole.cue
        case .guide: L10n.TrackRole.guide
        case .countIn: L10n.TrackRole.countIn
        case .leadVocal: L10n.TrackRole.leadVocal
        case .backingVocal: L10n.TrackRole.backingVocal
        case .electricGuitar: L10n.TrackRole.electricGuitar
        case .acousticGuitar: L10n.TrackRole.acousticGuitar
        case .bass: L10n.TrackRole.bass
        case .drums: L10n.TrackRole.drums
        case .keys: L10n.TrackRole.keys
        case .piano: L10n.TrackRole.piano
        case .synth: L10n.TrackRole.synth
        case .strings: L10n.TrackRole.strings
        case .brass: L10n.TrackRole.brass
        case .percussion: L10n.TrackRole.percussion
        case .loop: L10n.TrackRole.loop
        case .fx: L10n.TrackRole.fx
        case .unknown: L10n.TrackRole.unknown
        }
    }

    var defaultColor: Color {
        TrackColorPalette.color(for: self)
    }
}
