//
//  TimelineWorkspacePanel.swift
//  SimplePlay
//

import SwiftUI
import UniformTypeIdentifiers

/// Combined track headers + timeline with synchronized vertical scrolling.
struct TimelineWorkspacePanel: View {
    @Bindable var viewModel: WorkspaceViewModel
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @State private var isDropTargeted = false
    @State private var magnificationAnchor: Double?
    @State private var horizontalScrollOffset: CGFloat = 0
    @State private var timelineScrollPosition = ScrollPosition(x: 0)

    private var isCompact: Bool {
        horizontalSizeClass == .compact
    }

    private var trackHeaderWidth: CGFloat {
        isCompact ? DAWTheme.compactTrackHeaderWidth : DAWTheme.trackHeaderWidth
    }

    private var trackRowHeight: CGFloat {
        isCompact ? DAWTheme.compactTrackRowHeight : DAWTheme.trackRowHeight
    }

    private var timelineTopInset: CGFloat {
        DAWTheme.rulerHeight + DAWTheme.markerLaneHeight
    }

    private var laneAreaHeight: CGFloat {
        CGFloat(max(viewModel.project.tracks.count, 1)) * trackRowHeight
    }

    private var timelineDropOverlayMessage: String {
#if os(iOS)
        "Drop audio at the playhead position"
#else
        "Drop stems at this timeline position"
#endif
    }

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                pinnedTimelineHeaders

                ScrollView(.vertical, showsIndicators: true) {
                    HStack(alignment: .top, spacing: 0) {
                        trackHeaderColumnTracksOnly
                        masterTimelineHorizontalScroll
                    }
                }
            }
            .onAppear {
                viewModel.updateTimelineViewportWidth(geometry.size.width - trackHeaderWidth)
            }
            .onChange(of: geometry.size.width) { _, newWidth in
                viewModel.updateTimelineViewportWidth(newWidth - trackHeaderWidth)
            }
            .onChange(of: horizontalSizeClass) { _, _ in
                viewModel.updateTimelineViewportWidth(geometry.size.width - trackHeaderWidth)
            }
        }
        .background(DAWTheme.background)
    }

    // MARK: - Pinned headers (Time + Sections stay visible while tracks scroll)

    private var pinnedTimelineHeaders: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                timeHeaderCell
                mirroredHorizontalTimeline(height: DAWTheme.rulerHeight) {
                    TimelineRulerView(
                        duration: viewModel.project.duration,
                        pixelsPerSecond: viewModel.pixelsPerSecond,
                        playheadTime: viewModel.playheadTime,
                        onSeek: { time in
                            viewModel.seek(to: time)
                        }
                    )
                    .frame(width: viewModel.timelineContentWidth, height: DAWTheme.rulerHeight)
                }
            }

            HStack(spacing: 0) {
                markerHeaderRow
                masterSectionLaneScroll
            }
        }
        .background(DAWTheme.surface)
        .overlay(alignment: .bottom) {
            Rectangle().fill(DAWTheme.border).frame(height: 1)
        }
    }

    private var timeHeaderCell: some View {
        Rectangle()
            .fill(DAWTheme.surfaceElevated)
            .frame(width: trackHeaderWidth, height: DAWTheme.rulerHeight)
            .overlay(alignment: .topLeading) {
                Text("Time")
                    .font(.caption2)
                    .foregroundStyle(DAWTheme.textSecondary)
                    .padding(.leading, isCompact ? 8 : 12)
                    .padding(.top, 8)
            }
            .overlay(alignment: .trailing) {
                Rectangle().fill(DAWTheme.border).frame(width: 1)
            }
    }

    // MARK: - Track headers (scroll vertically with lanes)

    private var trackHeaderColumnTracksOnly: some View {
        VStack(spacing: 0) {
            ForEach(Array(viewModel.project.tracks.enumerated()), id: \.element.id) { index, track in
                TrackHeaderRowView(track: track, viewModel: viewModel)
                    .offset(y: viewModel.trackDragVisualOffset(for: track.id))
                    .overlay(alignment: .top) {
                        if viewModel.showsTrackDropIndicator(at: index) {
                            Rectangle()
                                .fill(track.color)
                                .frame(height: 2)
                        }
                    }
                    .zIndex(viewModel.draggingTrackID == track.id ? 1 : 0)
                    .frame(height: trackRowHeight)
            }

            Button {
                viewModel.presentAddTrackImport()
            } label: {
                Label(isCompact ? "Add" : "Add Track", systemImage: "plus")
                    .font(isCompact ? .caption : .subheadline)
                    .foregroundStyle(DAWTheme.textSecondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, isCompact ? 8 : 12)
                    .frame(height: isCompact ? 36 : 44)
            }
            .buttonStyle(.plain)
        }
        .frame(width: trackHeaderWidth)
        .background(DAWTheme.surface)
        .overlay(alignment: .trailing) {
            Rectangle().fill(DAWTheme.border).frame(width: 1)
        }
    }

    private var markerHeaderRow: some View {
        HStack(spacing: isCompact ? 4 : 8) {
            Image(systemName: "flag.fill")
                .font(.caption2)
                .foregroundStyle(viewModel.isSectionRepeatEnabled ? DAWTheme.accent : DAWTheme.textSecondary)

            VStack(alignment: .leading, spacing: 2) {
                Text("Sections")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(DAWTheme.textPrimary)

                if viewModel.isSectionRepeatEnabled {
                    Text(viewModel.queuedSectionName.map { "Repeat · \($0)" } ?? "Repeat On")
                        .font(.caption2)
                        .foregroundStyle(DAWTheme.accent)
                        .lineLimit(1)
                } else if !isCompact {
                    Text("Drag in the Sections lane to create markers")
                        .font(.caption2)
                        .foregroundStyle(DAWTheme.textSecondary)
                }
            }

            Spacer(minLength: 0)
        }
        .padding(.horizontal, isCompact ? 8 : 12)
        .frame(width: trackHeaderWidth, height: DAWTheme.markerLaneHeight)
        .background(DAWTheme.surface.opacity(0.95))
        .overlay(alignment: .trailing) {
            Rectangle().fill(DAWTheme.border).frame(width: 1)
        }
    }

    private var masterSectionLaneScroll: some View {
        mirroredHorizontalTimeline(height: DAWTheme.markerLaneHeight) {
            SectionMarkerLaneView(
                viewModel: viewModel,
                contentWidth: viewModel.timelineContentWidth
            )
        }
    }

    // MARK: - Master horizontal scroll (tracks + playhead)

    private var masterTimelineHorizontalScroll: some View {
        ScrollView(.horizontal, showsIndicators: true) {
            ZStack(alignment: .topLeading) {
                trackLaneBackground
                trackLanes
                playhead

                if viewModel.project.tracks.isEmpty {
                    TimelineEmptyDropHint()
                }
            }
            .scrollTargetLayout()
            .frame(width: viewModel.timelineContentWidth, height: laneAreaHeight)
            .overlay {
                if isDropTargeted {
                    AudioDropOverlay(message: timelineDropOverlayMessage)
                }
            }
            .modifier(TimelineAudioDropModifier(viewModel: viewModel, isDropTargeted: $isDropTargeted))
        }
        .scrollPosition($timelineScrollPosition)
        .scrollDisabled(viewModel.isSectionInteractionActive)
        .simultaneousGesture(magnificationGesture)
        .onScrollGeometryChange(for: CGFloat.self) { geometry in
            geometry.contentOffset.x + geometry.contentInsets.leading
        } action: { _, newValue in
            horizontalScrollOffset = max(0, newValue)
            viewModel.updateTimelineVisibleOffset(horizontalScrollOffset)
        }
        .onChange(of: viewModel.timelineScrollRequest) { _, request in
            guard let request else { return }
            applyTimelineScroll(offsetX: request.offsetX)
        }
        .onChange(of: viewModel.playheadTime) { _, _ in
            followPlayheadIfNeeded()
        }
        .onChange(of: viewModel.isPlaying) { _, isPlaying in
            if isPlaying {
                followPlayheadIfNeeded()
            }
        }
    }

    @ViewBuilder
    private func mirroredHorizontalTimeline<Content: View>(
        height: CGFloat,
        @ViewBuilder content: () -> Content
    ) -> some View {
        let mirroredContent = content()

        GeometryReader { geometry in
            mirroredContent
                .frame(width: viewModel.timelineContentWidth, alignment: .leading)
                .offset(x: -horizontalScrollOffset)
                .frame(width: geometry.size.width, alignment: .leading)
                .clipped()
        }
        .frame(height: height)
    }

    private func followPlayheadIfNeeded() {
        guard viewModel.isPlaying else { return }

        let playheadX = CGFloat(viewModel.playheadTime) * viewModel.pixelsPerSecond
        let viewport = max(1, viewModel.timelineViewportWidth)
        let maxOffset = max(0, viewModel.timelineContentWidth - viewport)
        let blockWidth = viewport * 0.85
        let visibleEnd = horizontalScrollOffset + viewport * 0.88

        guard playheadX > visibleEnd else { return }

        let blockIndex = floor(playheadX / blockWidth)
        let targetX = min(maxOffset, blockIndex * blockWidth)
        guard abs(targetX - horizontalScrollOffset) > 1 else { return }

        applyTimelineScroll(offsetX: targetX)
    }

    private func applyTimelineScroll(offsetX: CGFloat) {
        horizontalScrollOffset = offsetX
        timelineScrollPosition = ScrollPosition(x: offsetX)
        viewModel.updateTimelineVisibleOffset(offsetX)
    }

    private var magnificationGesture: some Gesture {
        MagnificationGesture()
            .onChanged { scale in
                if magnificationAnchor == nil {
                    magnificationAnchor = viewModel.zoom
                }
                viewModel.setZoom((magnificationAnchor ?? 1) * scale)
            }
            .onEnded { _ in
                magnificationAnchor = nil
            }
    }

    private var trackLaneBackground: some View {
        VStack(spacing: 0) {
            ForEach(viewModel.project.tracks) { _ in
                Rectangle()
                    .fill(DAWTheme.background)
                    .frame(height: trackRowHeight)
                    .overlay(alignment: .bottom) {
                        Rectangle().fill(DAWTheme.border).frame(height: 1)
                    }
            }
        }
        .allowsHitTesting(false)
        .overlay {
            Color.clear
                .contentShape(Rectangle())
                .gesture(timelineSeekGesture)
        }
    }

    private var timelineSeekGesture: some Gesture {
        SpatialTapGesture()
            .onEnded { value in
                seekToTimelinePosition(value.location.x)
            }
    }

    private func seekToTimelinePosition(_ x: CGFloat) {
        let rawTime = TimeInterval(max(0, x) / viewModel.pixelsPerSecond)
        let snapped = SnapGrid.snap(
            rawTime,
            interval: viewModel.project.snapInterval,
            enabled: viewModel.project.isSnapEnabled
        )
        viewModel.seek(to: snapped)
    }

    private var trackLanes: some View {
        ForEach(Array(viewModel.project.tracks.enumerated()), id: \.element.id) { index, track in
            TrackLaneView(
                track: track,
                viewModel: viewModel,
                contentWidth: viewModel.timelineContentWidth,
                rowHeight: trackRowHeight
            )
            .offset(
                y: CGFloat(index) * trackRowHeight
                    + viewModel.trackDragVisualOffset(for: track.id)
            )
            .overlay(alignment: .top) {
                if viewModel.showsTrackDropIndicator(at: index) {
                    Rectangle()
                        .fill(track.color)
                        .frame(height: 2)
                }
            }
            .zIndex(viewModel.draggingTrackID == track.id ? 1 : 0)
            .frame(width: viewModel.timelineContentWidth, height: trackRowHeight, alignment: .leading)
        }
    }

    private var playhead: some View {
        PlayheadView(
            playheadTime: viewModel.playheadTime,
            pixelsPerSecond: viewModel.pixelsPerSecond,
            height: laneAreaHeight
        ) { time in
            viewModel.seek(to: time)
        }
        .zIndex(100)
    }
}

struct PlayheadView: View {
    let playheadTime: TimeInterval
    let pixelsPerSecond: CGFloat
    let height: CGFloat
    let onSeek: (TimeInterval) -> Void

    @State private var dragStartTime: TimeInterval?

    var body: some View {
        let x = CGFloat(playheadTime) * pixelsPerSecond

        ZStack(alignment: .top) {
            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [DAWTheme.playhead.opacity(0.15), DAWTheme.playhead, DAWTheme.playhead.opacity(0.15)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .frame(width: 2, height: height)
                .shadow(color: DAWTheme.playheadGlow, radius: 3, x: 0, y: 0)

            Circle()
                .fill(
                    RadialGradient(
                        colors: [.white, DAWTheme.playhead],
                        center: .center,
                        startRadius: 0,
                        endRadius: 8
                    )
                )
                .overlay {
                    Circle()
                        .stroke(Color.white.opacity(0.85), lineWidth: 1.5)
                }
                .frame(width: 14, height: 14)
                .shadow(color: DAWTheme.playheadGlow, radius: 4, x: 0, y: 0)
                .offset(y: -6)
        }
        .frame(width: 44, height: height, alignment: .top)
        .contentShape(Rectangle().size(width: 44, height: height))
        .offset(x: x - 22)
        .highPriorityGesture(playheadDragGesture)
        .animation(nil, value: playheadTime)
        .animation(nil, value: pixelsPerSecond)
    }

    private var playheadDragGesture: some Gesture {
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
    }
}

private struct TimelineAudioDropModifier: ViewModifier {
    @Bindable var viewModel: WorkspaceViewModel
    @Binding var isDropTargeted: Bool

    func body(content: Content) -> some View {
#if os(iOS)
        content
            .onDrop(of: SupportedAudioFormats.dropTypes, isTargeted: $isDropTargeted) { providers in
                Task { @MainActor in
                    let urls = await DropURLLoader.loadURLs(from: providers)
                    guard !urls.isEmpty else { return }

                    let dropTime = SnapGrid.snap(
                        viewModel.playheadTime,
                        interval: viewModel.project.snapInterval,
                        enabled: viewModel.project.isSnapEnabled
                    )
                    viewModel.importDroppedItems(urls: urls, startTime: dropTime)
                }
                return true
            }
#else
        content
            .dropDestination(for: URL.self) { urls, location in
                let dropTime = SnapGrid.snap(
                    TimeInterval(max(0, location.x) / viewModel.pixelsPerSecond),
                    interval: viewModel.project.snapInterval,
                    enabled: viewModel.project.isSnapEnabled
                )
                viewModel.importDroppedItems(urls: urls, startTime: dropTime)
                return true
            } isTargeted: { targeted in
                isDropTargeted = targeted
            }
#endif
    }
}
