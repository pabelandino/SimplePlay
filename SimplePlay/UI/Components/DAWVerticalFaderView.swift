//
//  DAWVerticalFaderView.swift
//  SimplePlay
//

import SwiftUI

/// Custom vertical DAW-style fader (not `Slider`).
struct DAWVerticalFaderView: View {
    @Binding var value: Double
    var accentColor: Color = DAWTheme.faderFill
    var width: CGFloat = 28
    var height: CGFloat = 120
    var valueRange: ClosedRange<Double> = 0...1
    var showsValueLabel = true
    var showsUnityMark = false
    var usesUnityCenterDecibelScale = false

    @State private var dragStartValue: Double?

    private var span: Double {
        valueRange.upperBound - valueRange.lowerBound
    }

    private var normalizedPosition: Double {
        if usesUnityCenterDecibelScale {
            return TrackVolumeSettings.normalizedFaderPosition(from: value)
        }
        guard span > 0 else { return 0 }
        return (value - valueRange.lowerBound) / span
    }

    var body: some View {
        VStack(spacing: 4) {
            GeometryReader { geometry in
                let travel = max(1, geometry.size.height - thumbHeight)
                let thumbY = travel * (1 - normalizedPosition)
                let unityY = unityMarkY(travel: travel)

                ZStack(alignment: .top) {
                    RoundedRectangle(cornerRadius: 5)
                        .fill(DAWTheme.background.opacity(0.85))
                        .overlay {
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(DAWTheme.border, lineWidth: 1)
                        }

                    if showsUnityMark, let unityY {
                        Rectangle()
                            .fill(DAWTheme.textSecondary.opacity(0.55))
                            .frame(height: 1)
                            .offset(y: unityY)
                    }

                    RoundedRectangle(cornerRadius: 4)
                        .fill(
                            LinearGradient(
                                colors: [accentColor.opacity(0.35), accentColor.opacity(0.9)],
                                startPoint: .bottom,
                                endPoint: .top
                            )
                        )
                        .frame(height: max(4, geometry.size.height * normalizedPosition))
                        .frame(maxHeight: .infinity, alignment: .bottom)

                    RoundedRectangle(cornerRadius: 3)
                        .fill(Color(white: 0.92))
                        .overlay {
                            RoundedRectangle(cornerRadius: 3)
                                .stroke(Color.white.opacity(0.35), lineWidth: 0.5)
                        }
                        .frame(width: width + 4, height: thumbHeight)
                        .shadow(color: .black.opacity(0.35), radius: 2, y: 1)
                        .offset(y: thumbY)
                }
                .contentShape(Rectangle())
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { gesture in
                            if dragStartValue == nil {
                                dragStartValue = value
                            }
                            let deltaNormalized = -(gesture.translation.height / travel)
                            if usesUnityCenterDecibelScale {
                                let startNorm = TrackVolumeSettings.normalizedFaderPosition(
                                    from: dragStartValue ?? value
                                )
                                let newNorm = min(1, max(0, startNorm + deltaNormalized))
                                value = TrackVolumeSettings.linearGain(fromNormalizedFaderPosition: newNorm)
                            } else {
                                let delta = deltaNormalized * span
                                let base = dragStartValue ?? value
                                value = min(valueRange.upperBound, max(valueRange.lowerBound, base + delta))
                            }
                        }
                        .onEnded { _ in
                            dragStartValue = nil
                        }
                )
                .onTapGesture { location in
                    let fraction = 1 - min(1, max(0, location.y / geometry.size.height))
                    if usesUnityCenterDecibelScale {
                        value = TrackVolumeSettings.linearGain(fromNormalizedFaderPosition: fraction)
                    } else {
                        value = valueRange.lowerBound + fraction * span
                    }
                }
            }
            .frame(width: width, height: height)

            if showsValueLabel {
                Text(volumeLabel)
                    .font(.system(size: 9, weight: .semibold, design: .monospaced))
                    .foregroundStyle(DAWTheme.textSecondary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
            }
        }
    }

    private var thumbHeight: CGFloat {
        max(10, min(16, width * 0.55))
    }

    private var volumeLabel: String {
        TrackVolumeSettings.formattedDecibels(value)
    }

    private func unityMarkY(travel: CGFloat) -> CGFloat? {
        guard showsUnityMark else { return nil }
        if usesUnityCenterDecibelScale {
            return travel * 0.5
        }
        guard span > 0, valueRange.contains(TrackVolumeSettings.unityLinear) else {
            return nil
        }
        let unityPosition = (TrackVolumeSettings.unityLinear - valueRange.lowerBound) / span
        return travel * (1 - unityPosition)
    }
}
