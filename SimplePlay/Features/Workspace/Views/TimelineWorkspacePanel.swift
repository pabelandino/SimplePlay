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
    @State private var scrollCoordinator = TimelineScrollCoordinator()
    @State private var isDropTargeted = false
    @State private var magnificationAnchor: Double?
    @State private var zoomAnchorTime: TimeInterval?
    @State private var zoomAnchorViewportX: CGFloat?
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
                PinnedTimelineHeaderStrip(
                    viewModel: viewModel,
                    scrollCoordinator: scrollCoordinator,
                    trackHeaderWidth: trackHeaderWidth,
                    isCompact: isCompact
                )

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

    private var masterTimelineHorizontalScroll: some View {
        TimelineTrackScrollArea(
            viewModel: viewModel,
            scrollCoordinator: scrollCoordinator,
            timelineScrollPosition: $timelineScrollPosition,
            trackRowHeight: trackRowHeight,
            laneAreaHeight: laneAreaHeight,
            isDropTargeted: $isDropTargeted,
            timelineDropOverlayMessage: timelineDropOverlayMessage,
            onZoomChange: { oldZoom, newZoom in
                guard oldZoom != newZoom, magnificationAnchor == nil else { return }
                preserveTimelineScrollAfterZoom(
                    from: oldZoom,
                    focalViewportX: viewModel.timelineViewportWidth * 0.5
                )
            },
            onScrollRequest: { request in
                guard let request else { return }
                applyTimelineScroll(offsetX: request.offsetX)
            },
            onPlayheadFollow: followPlayheadIfNeeded
        )
        .simultaneousGesture(magnificationGesture)
    }

    private func followPlayheadIfNeeded() {
        guard viewModel.isPlaying, !scrollCoordinator.isScrolling else { return }

        let playheadX = CGFloat(viewModel.playheadTime) * viewModel.pixelsPerSecond
        let viewport = max(1, viewModel.timelineViewportWidth)
        let maxOffset = max(0, viewModel.timelineContentWidth - viewport)
        let margin = viewport * 0.12
        let visibleStart = scrollCoordinator.horizontalOffset + margin
        let visibleEnd = scrollCoordinator.horizontalOffset + viewport - margin

        guard playheadX < visibleStart || playheadX > visibleEnd else { return }

        let targetX = min(maxOffset, max(0, playheadX - viewport * 0.35))
        guard abs(targetX - scrollCoordinator.horizontalOffset) > 1 else { return }

        applyTimelineScroll(offsetX: targetX)
    }

    private func applyTimelineScroll(offsetX: CGFloat) {
        let viewport = max(1, viewModel.timelineViewportWidth)
        let maxOffset = max(0, viewModel.timelineContentWidth - viewport)
        let clampedOffset = min(max(0, offsetX), maxOffset)

        scrollCoordinator.syncHorizontalOffset(clampedOffset)
        timelineScrollPosition = ScrollPosition(x: clampedOffset)
        viewModel.flushTimelineVisibleOffset(clampedOffset)
    }

    private func preserveTimelineScrollAfterZoom(from oldZoom: Double, focalViewportX: CGFloat) {
        if viewModel.zoom <= viewModel.minimumTimelineZoom + 0.001 {
            applyTimelineScroll(offsetX: 0)
            return
        }

        let oldPixelsPerSecond = DAWTheme.pixelsPerSecond * oldZoom
        let anchorTime = TimeInterval(
            (scrollCoordinator.horizontalOffset + focalViewportX) / oldPixelsPerSecond
        )
        applyTimelineScrollPreservingTime(anchorTime, focalViewportX: focalViewportX)
    }

    private func applyTimelineScrollPreservingTime(_ anchorTime: TimeInterval, focalViewportX: CGFloat) {
        if viewModel.zoom <= viewModel.minimumTimelineZoom + 0.001 {
            applyTimelineScroll(offsetX: 0)
            return
        }

        let targetOffset = CGFloat(anchorTime) * viewModel.pixelsPerSecond - focalViewportX
        applyTimelineScroll(offsetX: targetOffset)
    }

    private var magnificationGesture: some Gesture {
        MagnifyGesture()
            .onChanged { value in
                if magnificationAnchor == nil {
                    magnificationAnchor = viewModel.zoom
                    zoomAnchorViewportX = value.startLocation.x
                    let oldPixelsPerSecond = DAWTheme.pixelsPerSecond * viewModel.zoom
                    zoomAnchorTime = TimeInterval(
                        (scrollCoordinator.horizontalOffset + value.startLocation.x) / oldPixelsPerSecond
                    )
                }

                viewModel.setZoom((magnificationAnchor ?? 1) * value.magnification)

                if let anchorTime = zoomAnchorTime {
                    applyTimelineScrollPreservingTime(
                        anchorTime,
                        focalViewportX: zoomAnchorViewportX ?? value.startLocation.x
                    )
                }
            }
            .onEnded { _ in
                magnificationAnchor = nil
                zoomAnchorTime = nil
                zoomAnchorViewportX = nil
            }
    }
}

// MARK: - Pinned ruler + sections (only subviews that read scroll offset)

private struct PinnedTimelineHeaderStrip: View {
    @Bindable var viewModel: WorkspaceViewModel
    var scrollCoordinator: TimelineScrollCoordinator
    let trackHeaderWidth: CGFloat
    let isCompact: Bool

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                timeHeaderCell
                TimelineHorizontalMirror(
                    offset: scrollCoordinator.horizontalOffset,
                    contentWidth: viewModel.timelineContentWidth,
                    height: DAWTheme.rulerHeight
                ) {
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
                TimelineHorizontalMirror(
                    offset: scrollCoordinator.horizontalOffset,
                    contentWidth: viewModel.timelineContentWidth,
                    height: DAWTheme.markerLaneHeight
                ) {
                    SectionMarkerLaneView(
                        viewModel: viewModel,
                        contentWidth: viewModel.timelineContentWidth
                    )
                }
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

    private var markerHeaderRow: some View {
        HStack(spacing: isCompact ? 4 : 8) {
            Image(systemName: "flag.fill")
                .font(.caption2)
                .foregroundStyle(
                    viewModel.repeatingSectionName != nil
                        ? DAWTheme.accent
                        : DAWTheme.textSecondary
                )

            VStack(alignment: .leading, spacing: 2) {
                Text("Sections")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(DAWTheme.textPrimary)

                if let queued = viewModel.queuedSectionName {
                    Text("Next · \(queued)")
                        .font(.caption2)
                        .foregroundStyle(DAWTheme.accent)
                        .lineLimit(1)
                } else if let repeating = viewModel.repeatingSectionName {
                    Text("Repeat once · \(repeating)")
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
}

// MARK: - Horizontal track scroll (does not read scroll offset in body)

private struct TimelineTrackScrollArea: View {
    @Bindable var viewModel: WorkspaceViewModel
    var scrollCoordinator: TimelineScrollCoordinator
    @Binding var timelineScrollPosition: ScrollPosition
    let trackRowHeight: CGFloat
    let laneAreaHeight: CGFloat
    @Binding var isDropTargeted: Bool
    let timelineDropOverlayMessage: String
    let onZoomChange: (Double, Double) -> Void
    let onScrollRequest: (WorkspaceViewModel.TimelineScrollRequest?) -> Void
    let onPlayheadFollow: () -> Void

    var body: some View {
        ScrollView(.horizontal, showsIndicators: true) {
            ZStack(alignment: .topLeading) {
                TimelineTrackLaneBackground(
                    trackCount: viewModel.project.tracks.count,
                    rowHeight: trackRowHeight,
                    pixelsPerSecond: viewModel.pixelsPerSecond,
                    snapInterval: viewModel.project.snapInterval,
                    isSnapEnabled: viewModel.project.isSnapEnabled,
                    onSeek: { time in viewModel.seek(to: time) }
                )
                .equatable()

                VStack(spacing: 0) {
                    ForEach(Array(viewModel.project.tracks.enumerated()), id: \.element.id) { index, track in
                        TrackLaneView(
                            track: track,
                            viewModel: viewModel,
                            contentWidth: viewModel.timelineContentWidth,
                            rowHeight: trackRowHeight,
                            isTimelineScrolling: scrollCoordinator.isScrolling
                        )
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
                }
                .frame(width: viewModel.timelineContentWidth, alignment: .leading)

                if let guides = viewModel.activeSectionEdgeGuides {
                    SectionEdgeGuideOverlay(
                        startTime: guides.startTime,
                        endTime: guides.endTime,
                        showStartEdge: guides.showStartEdge,
                        showEndEdge: guides.showEndEdge,
                        color: Color(hex: guides.colorHex) ?? DAWTheme.accent,
                        pixelsPerSecond: viewModel.pixelsPerSecond,
                        height: laneAreaHeight
                    )
                    .zIndex(40)
                    .allowsHitTesting(false)
                }

                PlayheadView(
                    playheadTime: viewModel.playheadTime,
                    pixelsPerSecond: viewModel.pixelsPerSecond,
                    height: laneAreaHeight
                ) { time in
                    viewModel.seek(to: time)
                }
                .zIndex(100)

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
        .scrollDisabled(viewModel.isSectionResizeActive)
        .onScrollGeometryChange(for: CGFloat.self) { geometry in
            geometry.contentOffset.x + geometry.contentInsets.leading
        } action: { _, newValue in
            scrollCoordinator.syncHorizontalOffset(max(0, newValue))
        }
        .onScrollPhaseChange { _, newPhase in
            let isScrolling = newPhase != .idle
            scrollCoordinator.setScrolling(isScrolling)
            viewModel.setTimelineScrolling(isScrolling)
            if newPhase == .idle {
                viewModel.flushTimelineVisibleOffset(scrollCoordinator.horizontalOffset)
            }
        }
        .onChange(of: viewModel.zoom) { oldZoom, newZoom in
            onZoomChange(oldZoom, newZoom)
        }
        .onChange(of: viewModel.timelineScrollRequest) { _, request in
            onScrollRequest(request)
        }
        .onChange(of: viewModel.playheadTime) { _, _ in
            onPlayheadFollow()
        }
        .onChange(of: viewModel.isPlaying) { _, isPlaying in
            if isPlaying {
                onPlayheadFollow()
            }
        }
    }
}

private struct TimelineTrackLaneBackground: View, Equatable {
    let trackCount: Int
    let rowHeight: CGFloat
    let pixelsPerSecond: CGFloat
    let snapInterval: TimeInterval
    let isSnapEnabled: Bool
    let onSeek: (TimeInterval) -> Void

    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.trackCount == rhs.trackCount
            && lhs.rowHeight == rhs.rowHeight
            && lhs.pixelsPerSecond == rhs.pixelsPerSecond
            && lhs.snapInterval == rhs.snapInterval
            && lhs.isSnapEnabled == rhs.isSnapEnabled
    }

    var body: some View {
        VStack(spacing: 0) {
            ForEach(0..<trackCount, id: \.self) { _ in
                Rectangle()
                    .fill(DAWTheme.background)
                    .frame(height: rowHeight)
                    .overlay(alignment: .bottom) {
                        Rectangle().fill(DAWTheme.border).frame(height: 1)
                    }
            }
        }
        .allowsHitTesting(false)
        .overlay {
            Color.clear
                .contentShape(Rectangle())
                .gesture(
                    SpatialTapGesture()
                        .onEnded { value in
                            let rawTime = TimeInterval(max(0, value.location.x) / pixelsPerSecond)
                            let snapped = SnapGrid.snap(
                                rawTime,
                                interval: snapInterval,
                                enabled: isSnapEnabled
                            )
                            onSeek(snapped)
                        }
                )
        }
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
