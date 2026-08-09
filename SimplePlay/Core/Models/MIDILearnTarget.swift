//
//  MIDILearnTarget.swift
//  SimplePlay
//

import Foundation

enum MIDILearnTarget: Equatable, Sendable {
    case section(UUID)
    case loopToggle
}

struct MIDINoteAssignment: Equatable, Sendable {
    let note: UInt8
    let channel: UInt8

    var displayName: String {
        "Note \(note) · Ch \(channel + 1)"
    }
}
