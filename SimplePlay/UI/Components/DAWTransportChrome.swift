//
//  DAWTransportChrome.swift
//  SimplePlay
//

import SwiftUI

/// Pro Tools–inspired overview mini-timeline (bottom playhead scrubber) styling.
enum DAWTransportChrome {
    static func overviewRecessBackground(cornerRadius: CGFloat) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [
                            DAWTheme.overviewRecessTop,
                            DAWTheme.overviewRecessBottom,
                            DAWTheme.overviewRecessTop.opacity(0.92)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )

            brushedMetalOverlay(opacity: 0.04)
                .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))

            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .stroke(
                    LinearGradient(
                        colors: [
                            Color.black.opacity(0.55),
                            Color.black.opacity(0.25),
                            DAWTheme.transportBarHighlight.opacity(0.35)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    ),
                    lineWidth: 1
                )

            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .stroke(Color.white.opacity(0.05), lineWidth: 0.5)
                .padding(1)
                .blur(radius: 0.5)
                .mask {
                    RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                        .fill(
                            LinearGradient(
                                colors: [.clear, .black.opacity(0.55)],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                }
        }
    }

    static func overviewClipFill() -> LinearGradient {
        LinearGradient(
            colors: [
                DAWTheme.overviewClipHighlight.opacity(0.95),
                DAWTheme.overviewClipFill,
                DAWTheme.overviewClipFill.opacity(0.88)
            ],
            startPoint: .top,
            endPoint: .bottom
        )
    }

    static func overviewViewportFill() -> some View {
        RoundedRectangle(cornerRadius: 6, style: .continuous)
            .fill(DAWTheme.overviewViewportFill)
            .overlay {
                RoundedRectangle(cornerRadius: 6, style: .continuous)
                    .stroke(
                        LinearGradient(
                            colors: [
                                Color.black.opacity(0.35),
                                DAWTheme.overviewViewportStroke.opacity(0.85),
                                Color.white.opacity(0.08)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
            }
            .overlay {
                RoundedRectangle(cornerRadius: 5, style: .continuous)
                    .stroke(Color.black.opacity(0.25), lineWidth: 1)
                    .padding(1)
                    .blur(radius: 0.5)
            }
    }

    private static func brushedMetalOverlay(opacity: Double) -> some View {
        Canvas { context, size in
            let stripeHeight: CGFloat = 2
            var y: CGFloat = 0
            while y < size.height {
                let rect = CGRect(x: 0, y: y, width: size.width, height: stripeHeight)
                context.fill(
                    Path(rect),
                    with: .color(Color.white.opacity(y.truncatingRemainder(dividingBy: 4) == 0 ? opacity : opacity * 0.45))
                )
                y += stripeHeight
            }
        }
        .allowsHitTesting(false)
    }
}
