//
//  TimelineEditTool.swift
//  SimplePlay
//

import Foundation

/// Editing tool for the timeline clip area. The track header column always behaves like arrow.
enum TimelineEditTool: String, CaseIterable, Sendable {
    case hand
    case arrow
}
