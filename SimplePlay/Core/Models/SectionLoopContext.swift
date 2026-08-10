//
//  SectionLoopContext.swift
//  SimplePlay
//

import Foundation

/// Timeline bounds for seamless section looping in the audio engine.
struct SectionLoopContext: Equatable, Sendable {
    let sectionID: UUID
    let startTime: TimeInterval
    let endTime: TimeInterval

    var duration: TimeInterval {
        max(0, endTime - startTime)
    }
}
