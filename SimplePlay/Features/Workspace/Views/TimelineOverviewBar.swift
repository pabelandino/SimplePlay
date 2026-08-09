//
//  TimelineOverviewBar.swift
//  SimplePlay
//

import SwiftUI

struct TimelineOverviewBar: View {
    @Bindable var viewModel: WorkspaceViewModel
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    private var isCompact: Bool {
        horizontalSizeClass == .compact
    }

    private var barHeight: CGFloat {
        isCompact ? 34 : 38
    }

    private var thumbSize: CGFloat {
        isCompact ? 16 : 14
    }

    private var touchTarget: CGFloat {
        isCompact ? 44 : 36
    }

    var body: some View {
        GeometryReader { proxy in
            let duration = max(viewModel.project.duration, 1)
            let width = proxy.size.width
            let playheadX = CGFloat(viewModel.playheadTime / duration) * width
            let contentWidth = max(viewModel.timelineContentWidth, 1)
            let viewportWidth = viewModel.timelineViewportWidth
            let visibleStart = viewModel.timelineVisibleOffsetX
            let showsViewport = contentWidth > viewportWidth + 8
            let overviewViewportX = (visibleStart / contentWidth) * width
            let overviewViewportW = max(14, (viewportWidth / contentWidth) * width)

            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [
                                DAWTheme.background.opacity(0.95),
                                DAWTheme.surfaceElevated.opacity(0.9)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .overlay {
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .stroke(DAWTheme.border, lineWidth: 1)
                    }

                overviewSegments(in: CGSize(width: width, height: barHeight))

                if showsViewport {
                    RoundedRectangle(cornerRadius: 6, style: .continuous)
                        .fill(DAWTheme.overviewViewport)
                        .overlay {
                            RoundedRectangle(cornerRadius: 6, style: .continuous)
                                .stroke(DAWTheme.accent.opacity(0.65), lineWidth: 1)
                        }
                        .frame(width: overviewViewportW, height: barHeight - 10)
                        .offset(x: min(max(0, overviewViewportX), width - overviewViewportW), y: 5)
                        .allowsHitTesting(false)
                }

                Rectangle()
                    .fill(
                        LinearGradient(
                            colors: [DAWTheme.playhead.opacity(0.2), DAWTheme.playhead, DAWTheme.playhead.opacity(0.2)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(width: 2, height: barHeight - 6)
                    .shadow(color: DAWTheme.playheadGlow, radius: 4, x: 0, y: 0)
                    .offset(x: clamped(playheadX - 1, max: width - 2), y: 3)
                    .allowsHitTesting(false)

                playheadThumb(
                    at: playheadX,
                    width: width,
                    duration: duration
                )
            }
            .contentShape(Rectangle())
            .gesture(scrubGesture(width: width, duration: duration))
        }
        .frame(height: barHeight)
        .padding(.horizontal, isCompact ? 10 : 16)
        .padding(.vertical, isCompact ? 4 : 6)
    }

    @ViewBuilder
    private func overviewSegments(in size: CGSize) -> some View {
        let laneHeight = max(3, size.height * 0.18)
        let laneSpacing: CGFloat = 2
        let trackCount = max(viewModel.project.tracks.count, 1)
        let totalLaneHeight = CGFloat(trackCount) * laneHeight + CGFloat(max(0, trackCount - 1)) * laneSpacing
        let topInset = (size.height - min(totalLaneHeight, size.height - 8)) / 2

        ForEach(Array(viewModel.project.tracks.enumerated()), id: \.element.id) { index, track in
            let laneY = topInset + CGFloat(index) * (laneHeight + laneSpacing)

            ForEach(track.clips) { clip in
                let duration = max(viewModel.project.duration, 1)
                let x = CGFloat(clip.startTime / duration) * size.width
                let clipWidth = max(2, CGFloat(clip.duration / duration) * size.width)

                RoundedRectangle(cornerRadius: 2, style: .continuous)
                    .fill(track.color.opacity(0.72))
                    .overlay {
                        RoundedRectangle(cornerRadius: 2, style: .continuous)
                            .stroke(track.color.opacity(0.35), lineWidth: 0.5)
                    }
                    .frame(width: clipWidth, height: laneHeight)
                    .offset(x: x, y: laneY)
            }
        }
    }

    private func playheadThumb(at playheadX: CGFloat, width: CGFloat, duration: TimeInterval) -> some View {
        let clampedX = clamped(playheadX, max: width)

        return ZStack {
            Circle()
                .fill(DAWTheme.playhead.opacity(0.18))
                .frame(width: touchTarget, height: touchTarget)

            Circle()
                .fill(
                    RadialGradient(
                        colors: [.white, DAWTheme.playhead],
                        center: .center,
                        startRadius: 0,
                        endRadius: thumbSize
                    )
                )
                .frame(width: thumbSize, height: thumbSize)
                .overlay {
                    Circle()
                        .stroke(Color.white.opacity(0.85), lineWidth: 1.5)
                }
                .shadow(color: DAWTheme.playheadGlow, radius: 5, x: 0, y: 0)
        }
        .frame(width: touchTarget, height: touchTarget)
        .contentShape(Circle().scale(1.2))
        .offset(x: clampedX - touchTarget / 2, y: (barHeight - touchTarget) / 2)
    }

    private func scrubGesture(width: CGFloat, duration: TimeInterval) -> some Gesture {
        DragGesture(minimumDistance: 0)
            .onChanged { value in
                scrub(to: value.location.x, width: width, duration: duration)
            }
    }

    private func scrub(to x: CGFloat, width: CGFloat, duration: TimeInterval) {
        let fraction = min(1, max(0, x / width))
        viewModel.seek(
            to: duration * TimeInterval(fraction),
            scrollTimeline: true,
            scrollAlignment: .center
        )
    }

    private func clamped(_ x: CGFloat, max: CGFloat) -> CGFloat {
        Swift.min(Swift.max(0, x), max)
    }
}
