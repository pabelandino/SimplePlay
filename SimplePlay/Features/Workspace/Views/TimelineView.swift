//
//  TimelineView.swift
//  SimplePlay
//

import SwiftUI

struct TrackLaneView: View {
    let track: AudioTrack
    @Bindable var viewModel: WorkspaceViewModel
    let contentWidth: CGFloat
    @State private var dragAnchorTimes: [UUID: TimeInterval] = [:]

    private var liveTrack: AudioTrack {
        viewModel.project.tracks.first(where: { $0.id == track.id }) ?? track
    }

    var body: some View {
        let displayColor = viewModel.project.displayColor(for: liveTrack)

        ZStack(alignment: .leading) {
            ForEach(track.clips) { clip in
                WaveformClipView(
                    clip: clip,
                    trackID: track.id,
                    trackColor: displayColor,
                    pixelsPerSecond: viewModel.pixelsPerSecond,
                    isSelected: viewModel.isClipSelected(clip.id)
                )
                .offset(x: CGFloat(clip.startTime) * viewModel.pixelsPerSecond)
                .highPriorityGesture(clipDragGesture(clip: clip))
                .simultaneousGesture(
                    TapGesture().onEnded {
                        viewModel.handleClipTap(clip.id, extendSelection: ClipSelectionModifiers.isExtending)
                    }
                )
            }
        }
        .frame(width: contentWidth, height: DAWTheme.trackRowHeight - 8, alignment: .leading)
        .padding(.vertical, 4)
    }

    private func clipDragGesture(clip: AudioClip) -> some Gesture {
        DragGesture(minimumDistance: 2)
            .onChanged { value in
                if dragAnchorTimes.isEmpty {
                    viewModel.clearTimelineSelection()
                    prepareDragAnchors(primaryClip: clip)
                }
                let delta = TimeInterval(value.translation.width / viewModel.pixelsPerSecond)
                viewModel.moveClips(anchorTimes: dragAnchorTimes, delta: delta)
            }
            .onEnded { _ in
                dragAnchorTimes.removeAll()
            }
    }

    private func prepareDragAnchors(primaryClip: AudioClip) {
        if viewModel.isClipSelected(primaryClip.id), viewModel.selectedClipIDs.count > 1 {
            dragAnchorTimes = allSelectedClipStartTimes()
        } else {
            viewModel.selectedClipIDs = [primaryClip.id]
            dragAnchorTimes = [primaryClip.id: primaryClip.startTime]
        }
    }

    private func allSelectedClipStartTimes() -> [UUID: TimeInterval] {
        var anchors: [UUID: TimeInterval] = [:]
        for track in viewModel.project.tracks {
            for clip in track.clips where viewModel.selectedClipIDs.contains(clip.id) {
                anchors[clip.id] = clip.startTime
            }
        }
        return anchors
    }
}

enum ClipSelectionModifiers {
    static var isExtending: Bool {
#if os(macOS)
        NSEvent.modifierFlags.contains(.command) || NSEvent.modifierFlags.contains(.shift)
#else
        false
#endif
    }
}

#if os(macOS)
import AppKit
#endif

struct TimelineRulerView: View {
    let duration: TimeInterval
    let pixelsPerSecond: CGFloat
    let playheadTime: TimeInterval
    let onSeek: (TimeInterval) -> Void

    var body: some View {
        ZStack(alignment: .leading) {
            Canvas { context, size in
                let interval: TimeInterval = zoomAdjustedInterval
                var time: TimeInterval = 0

                while time <= max(duration, 60) {
                    let x = CGFloat(time) * pixelsPerSecond
                    var path = Path()
                    path.move(to: CGPoint(x: x, y: size.height - 8))
                    path.addLine(to: CGPoint(x: x, y: size.height))
                    context.stroke(path, with: .color(DAWTheme.timelineRuler), lineWidth: 1)

                    let label = Text(TimeFormatting.format(time))
                        .font(.caption2)
                        .foregroundStyle(DAWTheme.textSecondary)
                    context.draw(label, at: CGPoint(x: x + 4, y: 8), anchor: .topLeading)

                    time += interval
                }
            }
            .background(DAWTheme.surfaceElevated)

            Rectangle()
                .fill(DAWTheme.playhead.opacity(0.9))
                .frame(width: 2)
                .offset(x: CGFloat(playheadTime) * pixelsPerSecond)
                .allowsHitTesting(false)
        }
        .contentShape(Rectangle())
        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged { value in
                    onSeek(time(at: value.location.x))
                }
        )
    }

    private var zoomAdjustedInterval: TimeInterval {
        if pixelsPerSecond > 200 { return 1 }
        if pixelsPerSecond > 100 { return 2 }
        if pixelsPerSecond > 50 { return 5 }
        return 10
    }

    private func time(at x: CGFloat) -> TimeInterval {
        max(0, TimeInterval(x / pixelsPerSecond))
    }
}

struct SectionOverlayView: View {
    let section: ArrangementSection
    let pixelsPerSecond: CGFloat
    let isSelected: Bool

    var body: some View {
        RoundedRectangle(cornerRadius: 4)
            .fill(Color.white.opacity(isSelected ? 0.2 : 0.08))
            .overlay {
                RoundedRectangle(cornerRadius: 4)
                    .stroke(Color.white.opacity(0.5), style: StrokeStyle(lineWidth: 1, dash: [4, 4]))
            }
            .overlay(alignment: .topLeading) {
                Text(section.name)
                    .font(.caption2.weight(.semibold))
                    .foregroundStyle(.white)
                    .padding(4)
            }
            .frame(width: CGFloat(section.duration) * pixelsPerSecond, height: 200)
    }
}
