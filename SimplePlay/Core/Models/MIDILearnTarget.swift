//
//  MIDILearnTarget.swift
//  SimplePlay
//

import Foundation

enum MIDILearnTarget: Equatable, Sendable {
    case section(UUID)
}

struct MIDINoteAssignment: Equatable, Sendable {
    let note: UInt8
    let channel: UInt8
    let usesControlChange: Bool

    init(note: UInt8, channel: UInt8, usesControlChange: Bool = false) {
        self.note = note
        self.channel = channel
        self.usesControlChange = usesControlChange
    }

    var displayName: String {
        if usesControlChange {
            return "CC \(note) · Ch \(channel + 1)"
        }
        return "Note \(note) · Ch \(channel + 1)"
    }
}
