//
//  TimelineRulerScale.swift
//  SimplePlay
//

import CoreGraphics
import Foundation

enum TimelineRulerScale {
    /// Minimum horizontal space between major ruler labels.
    static let minimumLabelSpacing: CGFloat = 84

    /// Nice major tick steps from seconds up to hours.
    static let majorIntervals: [TimeInterval] = [
        1, 2, 5, 10, 15, 30,
        60, 120, 300, 600, 900, 1800, 3600
    ]

    static func majorTickInterval(pixelsPerSecond: CGFloat) -> TimeInterval {
        guard pixelsPerSecond > 0 else { return 60 }

        for interval in majorIntervals {
            if CGFloat(interval) * pixelsPerSecond >= minimumLabelSpacing {
                return interval
            }
        }

        return majorIntervals.last ?? 3600
    }

    static func minorTickInterval(for major: TimeInterval) -> TimeInterval? {
        switch major {
        case ..<5: return nil
        case ..<30: return major / 2
        case ..<300: return major / 2
        default: return nil
        }
    }

    static func formatRulerLabel(_ time: TimeInterval, tickInterval: TimeInterval) -> String {
        let clamped = max(0, time)
        let totalSeconds = Int(clamped.rounded(.down))
        let hours = totalSeconds / 3600
        let minutes = (totalSeconds % 3600) / 60
        let seconds = totalSeconds % 60

        if tickInterval >= 3600 {
            return String(format: "%d:00:00", hours)
        }

        if tickInterval >= 300 {
            if hours > 0 {
                return String(format: "%d:%02d:00", hours, minutes)
            }
            return String(format: "%d:00", minutes)
        }

        if tickInterval >= 60 {
            if hours > 0 {
                return String(format: "%d:%02d:%02d", hours, minutes, seconds)
            }
            return String(format: "%d:%02d", minutes, seconds)
        }

        if hours > 0 {
            return String(format: "%d:%02d:%02d", hours, minutes, seconds)
        }

        if minutes > 0 {
            return String(format: "%d:%02d", minutes, seconds)
        }

        if tickInterval >= 5 {
            return String(format: "0:%02d", seconds)
        }

        return "\(seconds)s"
    }
}
