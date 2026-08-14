//
//  TimelineView.swift
//  SimplePlay
//

import SwiftUI

private let trackLaneCoordinateSpace = "trackLane"

struct TrackLaneView: View {
    let track: AudioTrack
    @Bindable var viewModel: WorkspaceViewModel
    let contentWidth: CGFloat
    var rowHeight: CGFloat = DAWTheme.trackRowHeight
    var isTimelineScrolling = false

    private var clipHeight: CGFloat {
        max(24, rowHeight - 16)
    }

    private var liveTrack: AudioTrack {
        viewModel.project.tracks.first(where: { $0.id == track.id }) ?? track
    }

    var body: some View {
        let displayColor = viewModel.project.displayColor(for: liveTrack)

        Color.clear
            .allowsHitTesting(false)
            .frame(width: contentWidth, height: rowHeight - 8)
            .overlay(alignment: .leading) {
                ZStack(alignment: .leading) {
                    ForEach(liveTrack.clips) { clip in
                        clipContent(
                            clip: clip,
                            displayColor: displayColor,
                            isGhost: false
                        )
                    }

                    ForEach(viewModel.clipMovePreviewItems(for: track.id)) { item in
                        if let previewStart = viewModel.previewStartTime(for: item.clipID) {
                            clipContent(
                                clip: item.clip,
                                displayColor: displayColor,
                                isGhost: true,
                                previewStartTime: previewStart
                            )
                            .zIndex(20)
                        }
                    }
                }
            }
            .padding(.vertical, 4)
            .coordinateSpace(name: trackLaneCoordinateSpace)
            .modifier(TrackLaneDropModifier(trackID: track.id, viewModel: viewModel))
    }

    @ViewBuilder
    private func clipContent(
        clip: AudioClip,
        displayColor: Color,
        isGhost: Bool,
        previewStartTime: TimeInterval? = nil
    ) -> some View {
        let displayClip = isGhost ? clip : viewModel.displayClip(clip)
        let timelineStart = previewStartTime ?? displayClip.startTime
        let showTrimHandles = !isGhost
            && viewModel.timelineTool == .trim
            && viewModel.isClipSelected(clip.id)
            && viewModel.selectedClipIDs.count == 1
            && (!viewModel.isClipTrimActive || viewModel.clipTrimPreview?.id == clip.id)

        Group {
            WaveformClipView(
                clip: displayClip,
                trackID: track.id,
                trackColor: displayColor,
                pixelsPerSecond: viewModel.pixelsPerSecond,
                isSelected: !isGhost && viewModel.isClipSelected(clip.id),
                clipHeight: clipHeight,
                isTimelineScrolling: isTimelineScrolling,
                isTrimPreview: !isGhost && viewModel.clipTrimPreview?.id == clip.id,
                isGhost: isGhost,
                loadsWaveform: true
            )
            .overlay(alignment: .leading) {
                if showTrimHandles {
                    ClipTrimHandle(
                        edge: .start,
                        clipHeight: clipHeight,
                        viewModel: viewModel,
                        trackID: track.id,
                        clipID: clip.id
                    )
                }
            }
            .overlay(alignment: .trailing) {
                if showTrimHandles {
                    ClipTrimHandle(
                        edge: .end,
                        clipHeight: clipHeight,
                        viewModel: viewModel,
                        trackID: track.id,
                        clipID: clip.id
                    )
                }
            }
            .overlay {
                if !isGhost, viewModel.timelineTool == .split {
                    ClipSplitOverlay(
                        clip: displayClip,
                        clipHeight: clipHeight,
                        pixelsPerSecond: viewModel.pixelsPerSecond,
                        viewModel: viewModel,
                        trackID: track.id,
                        clipID: clip.id
                    )
                }
            }
            .modifier(ClipDragInteractionModifier(
                isEnabled: !isGhost && viewModel.timelineTool == .hand,
                gesture: clipDragGesture(clip: clip)
            ))
            .simultaneousGesture(
                TapGesture().onEnded {
                    guard !isGhost else { return }
                    switch viewModel.timelineTool {
                    case .arrow:
                        viewModel.handleClipTap(
                            clip.id,
                            extendSelection: ClipSelectionModifiers.isExtending
                        )
                    case .trim:
                        viewModel.handleClipTap(clip.id, extendSelection: false)
                    default:
                        break
                    }
                }
            )
        }
        .offset(x: CGFloat(timelineStart) * viewModel.pixelsPerSecond)
        .opacity(isGhost ? 1 : (viewModel.isClipBeingMoved(clip.id) ? 0.28 : 1))
        .allowsHitTesting(!isGhost)
        .transaction { transaction in
            if viewModel.isClipMoveActive {
                transaction.disablesAnimations = true
            }
        }
    }

    private func clipDragGesture(clip: AudioClip) -> some Gesture {
        DragGesture(minimumDistance: 4)
            .onChanged { value in
                guard viewModel.timelineTool == .hand else { return }

                if !viewModel.isClipMoveActive {
                    viewModel.beginClipMove(primaryClipID: clip.id)
                }
                viewModel.updateClipMovePreview(translationWidth: value.translation.width)
            }
            .onEnded { _ in
                guard viewModel.timelineTool == .hand else {
                    viewModel.cancelClipMovePreview()
                    return
                }

                if viewModel.isClipMoveActive {
                    viewModel.commitClipMovePreview()
                }
            }
    }
}

private struct ClipTrimHandle: View {
    let edge: ClipEditService.TrimEdge
    let clipHeight: CGFloat
    @Bindable var viewModel: WorkspaceViewModel
    let trackID: UUID
    let clipID: UUID

    private var handleHitWidth: CGFloat {
#if os(iOS)
        44
#else
        28
#endif
    }

    var body: some View {
        RoundedRectangle(cornerRadius: 3, style: .continuous)
            .fill(Color.white.opacity(0.82))
            .frame(width: 13, height: min(clipHeight - 8, 24))
            .padding(.horizontal, 4)
            .frame(width: handleHitWidth, height: clipHeight)
            .contentShape(Rectangle())
            .highPriorityGesture(trimGesture)
#if os(macOS)
            .cursor(.resizeLeftRight)
#endif
    }

    private var trimGesture: some Gesture {
        DragGesture(minimumDistance: 0, coordinateSpace: .named(trackLaneCoordinateSpace))
            .onChanged { value in
                if !viewModel.isClipTrimActive {
                    viewModel.beginClipTrim(trackID: trackID, clipID: clipID, edge: edge)
                }
                viewModel.updateClipTrim(laneLocationX: value.location.x)
            }
            .onEnded { _ in
                viewModel.commitClipTrim()
            }
    }
}

private struct ClipSplitOverlay: View {
    let clip: AudioClip
    let clipHeight: CGFloat
    let pixelsPerSecond: CGFloat
    @Bindable var viewModel: WorkspaceViewModel
    let trackID: UUID
    let clipID: UUID

    private var clipWidth: CGFloat {
        max(48, CGFloat(clip.duration) * pixelsPerSecond)
    }

    var body: some View {
        ZStack(alignment: .leading) {
            Color.white.opacity(0.001)
                .contentShape(Rectangle())
                .highPriorityGesture(splitGesture)

            if let splitTime = viewModel.clipSplitPreviewTime(for: clipID) {
                Rectangle()
                    .fill(DAWTheme.playhead.opacity(0.95))
                    .frame(width: 2, height: clipHeight - 6)
                    .offset(x: CGFloat(splitTime - clip.startTime) * pixelsPerSecond - 1)
                    .allowsHitTesting(false)
            }
        }
        .frame(width: clipWidth, height: clipHeight)
        .accessibilityLabel("Split clip")
        .accessibilityHint("Drag on the clip to choose a cut point, then release")
    }

    private var splitGesture: some Gesture {
        DragGesture(minimumDistance: 0, coordinateSpace: .named(trackLaneCoordinateSpace))
            .onChanged { value in
                viewModel.updateClipSplitPreview(
                    trackID: trackID,
                    clipID: clipID,
                    laneLocationX: value.location.x
                )
            }
            .onEnded { value in
                viewModel.updateClipSplitPreview(
                    trackID: trackID,
                    clipID: clipID,
                    laneLocationX: value.location.x
                )
                viewModel.commitClipSplit(trackID: trackID, clipID: clipID)
            }
    }
}

private struct TrackLaneDropModifier: ViewModifier {
    let trackID: UUID
    @Bindable var viewModel: WorkspaceViewModel

    func body(content: Content) -> some View {
#if os(iOS)
        content.onDrop(of: SupportedAudioFormats.dropTypes, isTargeted: nil) { providers in
            Task { @MainActor in
                let urls = await DropURLLoader.loadURLs(from: providers)
                guard !urls.isEmpty else { return }

                let dropTime = SnapGrid.snap(
                    viewModel.playheadTime,
                    interval: viewModel.project.snapInterval,
                    enabled: viewModel.project.isSnapEnabled
                )
                viewModel.importDroppedItems(
                    urls: urls,
                    startTime: dropTime,
                    targetTrackID: trackID
                )
            }
            return true
        }
#else
        content.dropDestination(for: URL.self) { urls, location in
            let dropTime = SnapGrid.snap(
                TimeInterval(max(0, location.x) / viewModel.pixelsPerSecond),
                interval: viewModel.project.snapInterval,
                enabled: viewModel.project.isSnapEnabled
            )
            viewModel.importDroppedItems(
                urls: urls,
                startTime: dropTime,
                targetTrackID: trackID
            )
            return true
        }
#endif
    }
}

private struct ClipDragInteractionModifier<G: Gesture>: ViewModifier {
    let isEnabled: Bool
    let gesture: G

    func body(content: Content) -> some View {
        if isEnabled {
            content.gesture(gesture)
        } else {
            content
        }
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

private extension View {
    func cursor(_ cursor: NSCursor) -> some View {
        onContinuousHover { phase in
            switch phase {
            case .active:
                cursor.push()
            case .ended:
                NSCursor.pop()
            }
        }
    }
}
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
