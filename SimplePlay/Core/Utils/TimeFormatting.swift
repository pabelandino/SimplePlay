//
//  TimeFormatting.swift
//  SimplePlay
//

import Foundation

enum TimeFormatting {
    static func format(_ time: TimeInterval, showMilliseconds: Bool = false) -> String {
        let clamped = max(0, time)
        let totalSeconds = Int(clamped)
        let hours = totalSeconds / 3600
        let minutes = (totalSeconds % 3600) / 60
        let seconds = totalSeconds % 60

        if showMilliseconds {
            let ms = Int((clamped - Double(totalSeconds)) * 1000)
            return String(format: "%02d:%02d:%02d.%03d", hours, minutes, seconds, ms)
        }

        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
}
