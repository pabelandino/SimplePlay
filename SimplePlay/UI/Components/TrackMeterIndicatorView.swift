//
//  TrackMeterIndicatorView.swift
//  SimplePlay
//

import SwiftUI

/// Vertical LED-style level meter with dB-mapped dots (green / yellow / red).
struct TrackMeterIndicatorView: View {
    let level: Float
    let isAudible: Bool
    var segmentCount: Int = 10
    var dotSize: CGFloat = 5

    private static let safeGreen = Color(red: 0.18, green: 0.92, blue: 0.42)
    private static let hotYellow = Color(red: 1, green: 0.86, blue: 0.12)
    private static let clipRed = Color(red: 1, green: 0.22, blue: 0.2)

    private var litSegmentCount: Int {
        guard isAudible, level > 0.001 else { return 0 }

        let decibels = Self.decibels(from: level)
        // Map roughly -50 dB (silence) to -6 dB (healthy loud) across the meter.
        let normalized = min(1, max(0, (decibels + 50) / 44))
        let curved = pow(normalized, 1.65)
        return Int(floor(curved * Double(segmentCount) + 0.001))
    }

    var body: some View {
        GeometryReader { geometry in
            let spacing = segmentSpacing(in: geometry.size.height)

            VStack(spacing: spacing) {
                ForEach((0..<segmentCount).reversed(), id: \.self) { index in
                    meterDot(at: index, isLit: index < litSegmentCount)
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height, alignment: .bottom)
        }
        .animation(.easeOut(duration: 0.07), value: litSegmentCount)
    }

    private func segmentSpacing(in height: CGFloat) -> CGFloat {
        guard segmentCount > 1 else { return 0 }
        let totalDotHeight = CGFloat(segmentCount) * dotSize
        return max(1, (height - totalDotHeight) / CGFloat(segmentCount - 1))
    }

    @ViewBuilder
    private func meterDot(at index: Int, isLit: Bool) -> some View {
        let tierColor = segmentColor(for: index, isLit: isLit)

        Circle()
            .fill(tierColor)
            .frame(width: dotSize, height: dotSize)
            .shadow(color: tierColor.opacity(isLit ? 0.85 : 0), radius: isLit ? 3 : 0)
            .shadow(color: tierColor.opacity(isLit ? 0.4 : 0), radius: isLit ? 5 : 0)
    }

    private func segmentColor(for index: Int, isLit: Bool) -> Color {
        guard isLit else {
            return DAWTheme.border.opacity(0.45)
        }

        let tier = Double(index + 1) / Double(segmentCount)
        if tier >= 0.94 {
            return Self.clipRed
        }
        if tier >= 0.82 {
            return Self.hotYellow
        }
        return Self.safeGreen
    }

    static func decibels(from level: Float) -> Double {
        20 * log10(Double(max(0.000_001, level)))
    }
}
