//
//  TimelineSampleGrid.swift
//  SimplePlay
//

import Foundation

/// Converts timeline times to sample-accurate boundaries for playback and section markers.
enum TimelineSampleGrid {
    static func sampleDuration(sampleRate: Double) -> TimeInterval {
        guard sampleRate > 0 else { return 0 }
        return 1.0 / sampleRate
    }

    static func frames(at time: TimeInterval, sampleRate: Double) -> Int64 {
        guard sampleRate > 0 else { return 0 }
        return Int64((max(0, time) * sampleRate).rounded(.toNearestOrAwayFromZero))
    }

    static func timeFromFrame(_ frame: Int64, sampleRate: Double) -> TimeInterval {
        guard sampleRate > 0 else { return 0 }
        return Double(max(0, frame)) / sampleRate
    }

    static func quantize(_ time: TimeInterval, sampleRate: Double) -> TimeInterval {
        timeFromFrame(frames(at: time, sampleRate: sampleRate), sampleRate: sampleRate)
    }

    /// Applies the edit grid first, then aligns to the project sample rate.
    static func snapSectionBoundary(
        _ time: TimeInterval,
        snapInterval: TimeInterval,
        snapEnabled: Bool,
        sampleRate: Double
    ) -> TimeInterval {
        let snapped = SnapGrid.snap(time, interval: snapInterval, enabled: snapEnabled)
        return quantize(snapped, sampleRate: sampleRate)
    }
}
