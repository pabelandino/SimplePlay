//
//  AudioTrack.swift
//  SimplePlay
//

import Foundation
import SwiftUI

/// One horizontal lane in the multitrack timeline.
struct AudioTrack: Identifiable, Codable, Sendable, Equatable {
    let id: UUID
    var originalName: String
    var standardCode: String
    var role: StandardTrackRole
    var colorHex: String
    var isMuted: Bool
    var isSolo: Bool
    var isLocked: Bool
    var pan: Double
    var clips: [AudioClip]

    init(
        id: UUID = UUID(),
        originalName: String,
        standardCode: String,
        role: StandardTrackRole,
        colorHex: String,
        isMuted: Bool = false,
        isSolo: Bool = false,
        isLocked: Bool = false,
        pan: Double = 0,
        clips: [AudioClip] = []
    ) {
        self.id = id
        self.originalName = originalName
        self.standardCode = standardCode
        self.role = role
        self.colorHex = colorHex
        self.isMuted = isMuted
        self.isSolo = isSolo
        self.isLocked = isLocked
        self.pan = pan
        self.clips = clips
    }

    var displayName: String { "\(standardCode) · \(originalName)" }

    var color: Color {
        Color(hex: colorHex) ?? role.defaultColor
    }
}
