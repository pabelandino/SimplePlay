//
//  SectionLoopContext.swift
//  SimplePlay
//

import Foundation

/// Timeline bounds for seamless section looping in the audio engine.
struct SectionLoopContext: Equatable, Sendable {
    /// Placeholder when looping a manual timeline selection (not a named section).
    static let selectionLoopPlaceholderID = UUID(uuidString: "00000000-0000-0000-0000-000000000001")!

    let sectionID: UUID
    let startTime: TimeInterval
    let endTime: TimeInterval

    var duration: TimeInterval {
        max(0, endTime - startTime)
    }
}
