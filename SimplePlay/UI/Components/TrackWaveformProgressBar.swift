//
//  TrackWaveformProgressBar.swift
//  SimplePlay
//

import SwiftUI

struct TrackWaveformProgressBar: View {
    let color: Color
    let progress: Double
    let isVisible: Bool

    var body: some View {
        if isVisible {
            GeometryReader { geometry in
                let clampedProgress = min(1, max(0, progress))
                let fillWidth = max(8, geometry.size.width * clampedProgress)

                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(color.opacity(0.1))
                        .overlay {
                            Capsule()
                                .stroke(color.opacity(0.22), lineWidth: 0.5)
                        }

                    Capsule()
                        .fill(
                            LinearGradient(
                                colors: [
                                    color.opacity(0.75),
                                    color,
                                    color.opacity(0.9)
                                ],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: fillWidth)
                        .shadow(color: color.opacity(0.95), radius: 3, y: 0)
                        .shadow(color: color.opacity(0.65), radius: 8, y: 0)
                        .shadow(color: color.opacity(0.4), radius: 14, y: 0)
                }
            }
            .frame(height: 5)
            .transition(.opacity.combined(with: .scale(scale: 0.98, anchor: .leading)))
            .animation(.easeOut(duration: 0.2), value: progress)
        }
    }
}
