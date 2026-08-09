//
//  SnapGrid.swift
//  SimplePlay
//

import Foundation

enum SnapGrid {
    static func snap(_ time: TimeInterval, interval: TimeInterval, enabled: Bool) -> TimeInterval {
        guard enabled, interval > 0 else { return max(0, time) }
        return (time / interval).rounded() * interval
    }
}
