//
//  SectionCueQueueBadge.swift
//  LvoqPlayback
//

import SwiftUI

/// 2pt progress line while section PCM slices decode in the background.
struct SectionCueQueueBadge: View {
    let color: Color
    let progress: Double
    let isVisible: Bool

    var body: some View {
        if isVisible {
            GeometryReader { geometry in
                let clamped = min(1, max(0, progress))
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(color.opacity(0.28))
                    Rectangle()
                        .fill(color)
                        .frame(width: max(2, geometry.size.width * clamped))
                }
            }
            .frame(height: 2)
            .accessibilityElement(children: .ignore)
            .accessibilityLabel(L10n.Accessibility.queueAudio)
            .accessibilityValue("\(Int((min(1, max(0, progress)) * 100).rounded())) percent")
            .animation(.easeOut(duration: 0.2), value: progress)
        }
    }
}
