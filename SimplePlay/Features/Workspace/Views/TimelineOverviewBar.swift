//
//  TimelineOverviewBar.swift
//  SimplePlay
//

import SwiftUI

struct TimelineOverviewBar: View {
    @Bindable var viewModel: WorkspaceViewModel

    var body: some View {
        GeometryReader { proxy in
            let duration = max(viewModel.project.duration, 1)
            let playheadX = CGFloat(viewModel.playheadTime / duration) * proxy.size.width

            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 4)
                    .fill(DAWTheme.surfaceElevated)

                overviewSegments(in: proxy.size)

                Rectangle()
                    .fill(DAWTheme.playhead)
                    .frame(width: 2)
                    .offset(x: max(0, min(proxy.size.width - 2, playheadX)))

                Circle()
                    .fill(DAWTheme.playhead)
                    .frame(width: 10, height: 10)
                    .offset(x: max(0, min(proxy.size.width - 10, playheadX - 4)))
            }
            .contentShape(Rectangle())
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        scrub(to: value.location.x, width: proxy.size.width, duration: duration)
                    }
            )
        }
        .frame(height: 22)
        .padding(.horizontal, 16)
        .padding(.top, 8)
    }

    @ViewBuilder
    private func overviewSegments(in size: CGSize) -> some View {
        ForEach(viewModel.project.tracks) { track in
            ForEach(track.clips) { clip in
                let duration = max(viewModel.project.duration, 1)
                let x = CGFloat(clip.startTime / duration) * size.width
                let width = max(1, CGFloat(clip.duration / duration) * size.width)

                RoundedRectangle(cornerRadius: 2)
                    .fill(track.color.opacity(0.55))
                    .frame(width: width, height: 8)
                    .offset(x: x, y: size.height / 2 - 4)
            }
        }
    }

    private func scrub(to x: CGFloat, width: CGFloat, duration: TimeInterval) {
        let fraction = min(1, max(0, x / width))
        viewModel.seek(to: duration * TimeInterval(fraction))
    }
}
