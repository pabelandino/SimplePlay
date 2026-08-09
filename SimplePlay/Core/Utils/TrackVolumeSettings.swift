//
//  TrackVolumeSettings.swift
//  SimplePlay
//

import Foundation

enum TrackVolumeSettings {
    /// Unity gain (0 dB).
    static let unityLinear: Double = 1.0
    /// Maximum linear gain (+12 dB).
    static let maxLinear: Double = 4.0
    static let minLinear: Double = 0
    static let minDecibels: Double = -60
    static let maxBoostDecibels: Double = 12

    static var trackRange: ClosedRange<Double> {
        minLinear...maxLinear
    }

    static func clamp(_ value: Double) -> Double {
        min(maxLinear, max(minLinear, value))
    }

    /// Maps linear gain to fader travel with 0 dB at the visual center.
    static func normalizedFaderPosition(from linear: Double) -> Double {
        let db = decibels(from: linear)
        if db.isInfinite || db <= minDecibels { return 0 }
        if db <= 0 {
            return 0.5 * (db - minDecibels) / -minDecibels
        }
        return 0.5 + 0.5 * min(db / maxBoostDecibels, 1)
    }

    static func linearGain(fromNormalizedFaderPosition position: Double) -> Double {
        let normalized = min(1, max(0, position))
        let db: Double
        if normalized <= 0.5 {
            db = minDecibels + (normalized / 0.5) * -minDecibels
        } else {
            db = ((normalized - 0.5) / 0.5) * maxBoostDecibels
        }
        return clamp(pow(10, db / 20))
    }

    static func decibels(from linear: Double) -> Double {
        guard linear > 0.000_001 else { return -.infinity }
        return 20 * log10(linear)
    }

    static func formattedDecibels(_ linear: Double) -> String {
        let db = decibels(from: linear)
        if db.isInfinite || db < -60 { return "-∞" }
        if abs(db) < 0.05 { return "0 dB" }
        return String(format: "%+.0f dB", db)
    }

    /// AVAudioMixerNode volume is capped at 1.0; extra gain uses EQ global gain.
    static func engineGainComponents(for linear: Double) -> (mixer: Float, boostDB: Float) {
        let clamped = clamp(linear)
        guard clamped > 0 else { return (0, 0) }

        if clamped <= unityLinear {
            return (Float(clamped), 0)
        }

        return (1, Float(decibels(from: clamped)))
    }
}
