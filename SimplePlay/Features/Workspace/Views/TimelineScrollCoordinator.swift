//
//  TimelineScrollCoordinator.swift
//  SimplePlay
//

import SwiftUI

/// Holds horizontal scroll state so mirror headers can update without invalidating track lanes.
@MainActor
@Observable
final class TimelineScrollCoordinator {
    private(set) var horizontalOffset: CGFloat = 0
    private(set) var isScrolling = false

    func syncHorizontalOffset(_ offset: CGFloat) {
        horizontalOffset = max(0, offset)
    }

    func setScrolling(_ scrolling: Bool) {
        isScrolling = scrolling
    }
}

struct TimelineHorizontalMirror<Content: View>: View {
    let offset: CGFloat
    let contentWidth: CGFloat
    let height: CGFloat
    @ViewBuilder let content: () -> Content

    var body: some View {
        GeometryReader { geometry in
            content()
                .frame(width: contentWidth, alignment: .leading)
                .offset(x: -offset)
                .frame(width: geometry.size.width, alignment: .leading)
                .clipped()
        }
        .frame(height: height)
    }
}
