//
//  TimelineView.swift
//  SimplePlay
//

import SwiftUI

struct TrackLaneView: View {
    let track: AudioTrack
    @Bindable var viewModel: WorkspaceViewModel
    let contentWidth: CGFloat
    var rowHeight: CGFloat = DAWTheme.trackRowHeight
    @State private var dragAnchorTimes: [UUID: TimeInterval] = [:]

    private var liveTrack: AudioTrack {
        viewModel.project.tracks.first(where: { $0.id == track.id }) ?? track
    }

    var body: some View {
        let displayColor = viewModel.project.displayColor(for: liveTrack)

        ZStack(alignment: .leading) {
            ForEach(liveTrack.clips) { clip in
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
        .frame(width: contentWidth, height: rowHeight - 8, alignment: .leading)
        .padding(.vertical, 4)
    }

    private func clipDragGesture(clip: AudioClip) -> some Gesture {
        DragGesture(minimumDistance: 2)
            .onChanged { value in
                guard viewModel.timelineTool == .hand else { return }

                if dragAnchorTimes.isEmpty {
                    viewModel.clearTimelineSelection()
                    prepareDragAnchors(primaryClip: clip)
                }
                let delta = TimeInterval(value.translation.width / viewModel.pixelsPerSecond)
                viewModel.moveClips(anchorTimes: dragAnchorTimes, delta: delta)
            }
            .onEnded { _ in
                guard viewModel.timelineTool == .hand else { return }
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

    @State private var dragStartTime: TimeInterval?

    var body: some View {
        ZStack(alignment: .leading) {
            TimelineRulerTicksView(
                duration: duration,
                pixelsPerSecond: pixelsPerSecond
            )
            .equatable()

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
                    if dragStartTime == nil {
                        dragStartTime = playheadTime
                    }
                    let delta = TimeInterval(value.translation.width / pixelsPerSecond)
                    onSeek(max(0, (dragStartTime ?? playheadTime) + delta))
                }
                .onEnded { _ in
                    dragStartTime = nil
                }
        )
        .simultaneousGesture(
            SpatialTapGesture()
                .onEnded { value in
                    onSeek(max(0, TimeInterval(value.location.x / pixelsPerSecond)))
                }
        )
    }
}

private struct TimelineRulerTicksView: View, Equatable {
    let duration: TimeInterval
    let pixelsPerSecond: CGFloat

    var body: some View {
        Canvas { context, size in
            let majorInterval = TimelineRulerScale.majorTickInterval(pixelsPerSecond: pixelsPerSecond)
            let minorInterval = TimelineRulerScale.minorTickInterval(for: majorInterval)
            let endTime = max(duration, majorInterval)

            if let minorInterval {
                var minorTime: TimeInterval = 0
                while minorTime <= endTime {
                    if minorTime.truncatingRemainder(dividingBy: majorInterval) > 0.001 {
                        drawTick(
                            in: &context,
                            size: size,
                            time: minorTime,
                            height: 4,
                            color: DAWTheme.timelineRuler.opacity(0.45)
                        )
                    }
                    minorTime += minorInterval
                }
            }

            var time: TimeInterval = 0
            while time <= endTime {
                drawTick(
                    in: &context,
                    size: size,
                    time: time,
                    height: 8,
                    color: DAWTheme.timelineRuler
                )

                let label = Text(TimelineRulerScale.formatRulerLabel(time, tickInterval: majorInterval))
                    .font(.caption2.monospacedDigit())
                    .foregroundStyle(DAWTheme.textSecondary)

                context.draw(
                    label,
                    at: CGPoint(x: CGFloat(time) * pixelsPerSecond, y: 9),
                    anchor: .top
                )

                time += majorInterval
            }
        }
        .background(DAWTheme.surfaceElevated)
    }

    private func drawTick(
        in context: inout GraphicsContext,
        size: CGSize,
        time: TimeInterval,
        height: CGFloat,
        color: Color
    ) {
        let x = CGFloat(time) * pixelsPerSecond
        var path = Path()
        path.move(to: CGPoint(x: x, y: size.height - height))
        path.addLine(to: CGPoint(x: x, y: size.height))
        context.stroke(path, with: .color(color), lineWidth: 1)
    }
}
