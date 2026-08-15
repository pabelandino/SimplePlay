//
//  iPhoneTimelinePanel.swift
//  SimplePlay
//

import SwiftUI

/// iPhone-only timeline. Default: all stems in one compact lane. Expanded: full multitrack.
struct iPhoneTimelinePanel: View {
    @Bindable var viewModel: WorkspaceViewModel
    @State private var scrollCoordinator = TimelineScrollCoordinator()
    @State private var timelineScrollPosition = ScrollPosition(x: 0)
    @State private var magnificationAnchor: Double?
    @State private var zoomAnchorTime: TimeInterval?
    @State private var zoomAnchorViewportX: CGFloat?

    private let trackHeaderWidth = DAWTheme.phoneTrackHeaderWidth

    private var showsSingleLane: Bool {
        viewModel.showsSingleTimelineLaneOnPhone
    }

    private var singleLaneHeight: CGFloat {
        viewModel.singleLaneRowHeight(isPhone: true)
    }

    private var laneAreaHeight: CGFloat {
        if showsSingleLane {
            return singleLaneHeight
        }
        return CGFloat(max(viewModel.project.tracks.count, 1)) * DAWTheme.phoneTrackRowHeight
    }

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                phonePinnedHeader

                ScrollView(.vertical, showsIndicators: !showsSingleLane) {
                    HStack(alignment: .top, spacing: 0) {
                        phoneTrackHeaderColumn
                        phoneTimelineScroll
                    }
                }
            }
            .clipped()
            .onAppear {
                updateViewportWidth(geometry.size.width)
            }
            .onChange(of: geometry.size.width) { _, newWidth in
                updateViewportWidth(newWidth)
            }
            .onChange(of: viewModel.isPhoneTimelineExpanded) { _, _ in
                updateViewportWidth(geometry.size.width)
            }
        }
        .background(DAWTheme.background)
        .clipped()
        .animation(.easeInOut(duration: 0.2), value: viewModel.isPhoneTimelineExpanded)
    }

    private func updateViewportWidth(_ totalWidth: CGFloat) {
        viewModel.updateTimelineViewportWidth(totalWidth - trackHeaderWidth)
        viewModel.updateTrackRowHeightForInteraction(
            showsSingleLane ? singleLaneHeight : DAWTheme.phoneTrackRowHeight
        )
    }

    private var phonePinnedHeader: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Rectangle()
                    .fill(DAWTheme.surfaceElevated)
                    .frame(width: trackHeaderWidth, height: DAWTheme.phoneTimelineRulerHeight)
                    .overlay(alignment: .topLeading) {
                        Text("Time")
                            .font(.system(size: 10, weight: .semibold))
                            .foregroundStyle(DAWTheme.textSecondary)
                            .padding(.leading, 8)
                            .padding(.top, 6)
                    }
                    .overlay(alignment: .trailing) {
                        Rectangle().fill(DAWTheme.border).frame(width: 1)
                    }

                TimelineHorizontalMirror(
                    offset: scrollCoordinator.horizontalOffset,
                    contentWidth: viewModel.timelineContentWidth,
                    height: DAWTheme.phoneTimelineRulerHeight
                ) {
                    TimelineRulerView(
                        duration: viewModel.project.duration,
                        pixelsPerSecond: viewModel.pixelsPerSecond,
                        playheadTime: viewModel.playheadTime,
                        onSeek: { viewModel.seek(to: $0) }
                    )
                    .frame(width: viewModel.timelineContentWidth, height: DAWTheme.phoneTimelineRulerHeight)
                }
                .clipped()
            }

            HStack(spacing: 0) {
                if showsSingleLane {
                    iPhoneSectionsLabelHeaderCell(
                        width: trackHeaderWidth,
                        height: DAWTheme.phoneMarkerLaneHeight
                    )
                } else {
                    SingleLaneMarkerHeaderCell(
                        width: trackHeaderWidth,
                        height: DAWTheme.phoneMarkerLaneHeight,
                        isPhone: true,
                        showsAllTracks: true,
                        onToggle: { viewModel.togglePhoneTimelineExpanded() }
                    )
                }

                TimelineHorizontalMirror(
                    offset: scrollCoordinator.horizontalOffset,
                    contentWidth: viewModel.timelineContentWidth,
                    height: DAWTheme.phoneMarkerLaneHeight
                ) {
                    ZStack(alignment: .topLeading) {
                        SectionMarkerLaneView(
                            viewModel: viewModel,
                            contentWidth: viewModel.timelineContentWidth
                        )

                        if let guides = viewModel.activeSectionEdgeGuides {
                            SectionEdgeGuideOverlay(
                                startTime: guides.startTime,
                                endTime: guides.endTime,
                                showStartEdge: guides.showStartEdge,
                                showEndEdge: guides.showEndEdge,
                                color: Color(hex: guides.colorHex) ?? DAWTheme.accent,
                                pixelsPerSecond: viewModel.pixelsPerSecond,
                                height: DAWTheme.phoneMarkerLaneHeight
                            )
                            .allowsHitTesting(false)
                        }
                    }
                }
                .clipped()
            }
        }
        .background(DAWTheme.surface)
        .overlay(alignment: .bottom) {
            Rectangle().fill(DAWTheme.border).frame(height: 1)
        }
    }

    @ViewBuilder
    private var phoneTrackHeaderColumn: some View {
        if showsSingleLane {
            SingleLaneTrackHeaderCell(
                viewModel: viewModel,
                width: trackHeaderWidth,
                rowHeight: singleLaneHeight,
                isPhone: true,
                showsAllTracks: viewModel.isPhoneTimelineExpanded,
                onToggle: { viewModel.togglePhoneTimelineExpanded() }
            )
        } else {
            VStack(spacing: 0) {
                ForEach(viewModel.project.tracks) { track in
                    iPhoneTrackHeaderRow(
                        track: track,
                        viewModel: viewModel,
                        rowHeight: DAWTheme.phoneTrackRowHeight
                    )
                }
            }
            .frame(width: trackHeaderWidth)
            .background(DAWTheme.surface)
            .overlay(alignment: .trailing) {
                Rectangle().fill(DAWTheme.border).frame(width: 1)
            }
        }
    }

    private var phoneTimelineScroll: some View {
        ScrollView(.horizontal, showsIndicators: true) {
            ZStack(alignment: .topLeading) {
                if showsSingleLane {
                    SingleLaneStackedClipsLane(
                        viewModel: viewModel,
                        contentWidth: viewModel.timelineContentWidth,
                        rowHeight: singleLaneHeight
                    )
                } else {
                    iPhoneMultitrackLaneContent(
                        viewModel: viewModel,
                        scrollCoordinator: scrollCoordinator,
                        laneAreaHeight: laneAreaHeight
                    )
                }

                timelineGuideOverlays

                PlayheadView(
                    playheadTime: viewModel.playheadTime,
                    pixelsPerSecond: viewModel.pixelsPerSecond,
                    height: laneAreaHeight
                ) { viewModel.seek(to: $0) }
                .zIndex(100)
            }
            .frame(width: viewModel.timelineContentWidth, height: laneAreaHeight)
            .clipped()
        }
        .scrollPosition($timelineScrollPosition)
        .scrollDisabled(viewModel.isSectionResizeActive)
        .clipped()
        .simultaneousGesture(magnificationGesture)
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
        .onChange(of: viewModel.timelineScrollRequest) { _, request in
            guard let request else { return }
            applyTimelineScroll(offsetX: request.offsetX)
        }
    }

    private func applyTimelineScroll(offsetX: CGFloat) {
        let viewport = max(1, viewModel.timelineViewportWidth)
        let maxOffset = max(0, viewModel.timelineContentWidth - viewport)
        let clampedOffset = min(max(0, offsetX), maxOffset)
        scrollCoordinator.syncHorizontalOffset(clampedOffset)
        timelineScrollPosition = ScrollPosition(x: clampedOffset)
        viewModel.flushTimelineVisibleOffset(clampedOffset)
    }

    @ViewBuilder
    private var timelineGuideOverlays: some View {
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

        if let guides = viewModel.activeClipMoveGuides {
            SectionEdgeGuideOverlay(
                startTime: guides.startTime,
                endTime: guides.endTime,
                showStartEdge: guides.showStartEdge,
                showEndEdge: guides.showEndEdge,
                color: Color(hex: guides.colorHex) ?? DAWTheme.accent,
                pixelsPerSecond: viewModel.pixelsPerSecond,
                height: laneAreaHeight
            )
            .zIndex(41)
            .allowsHitTesting(false)
        }

        if let guides = viewModel.activeClipSplitGuide {
            SectionEdgeGuideOverlay(
                startTime: guides.startTime,
                endTime: guides.endTime,
                showStartEdge: guides.showStartEdge,
                showEndEdge: guides.showEndEdge,
                color: Color(hex: guides.colorHex) ?? DAWTheme.accent,
                pixelsPerSecond: viewModel.pixelsPerSecond,
                height: laneAreaHeight
            )
            .zIndex(42)
            .allowsHitTesting(false)
        }
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

private struct iPhoneSectionsLabelHeaderCell: View {
    let width: CGFloat
    let height: CGFloat

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: 4) {
                Image(systemName: "flag.fill")
                    .font(.system(size: 10, weight: .semibold))
                    .foregroundStyle(DAWTheme.textSecondary)
                Text("Sections")
                    .font(.system(size: 10, weight: .semibold))
                    .foregroundStyle(DAWTheme.textPrimary)
                Spacer(minLength: 0)
            }

            Text("Tap ▶ to play · drag edges to resize")
                .font(.system(size: 9, weight: .medium))
                .foregroundStyle(DAWTheme.textSecondary)
                .lineLimit(2)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 6)
        .frame(width: width, height: height, alignment: .topLeading)
        .background(DAWTheme.surface.opacity(0.95))
        .overlay(alignment: .trailing) {
            Rectangle().fill(DAWTheme.border).frame(width: 1)
        }
    }
}

private struct iPhoneMultitrackLaneContent: View {
    @Bindable var viewModel: WorkspaceViewModel
    var scrollCoordinator: TimelineScrollCoordinator
    let laneAreaHeight: CGFloat

    var body: some View {
        ZStack(alignment: .topLeading) {
            VStack(spacing: 0) {
                ForEach(viewModel.project.tracks) { track in
                    TrackLaneView(
                        track: track,
                        viewModel: viewModel,
                        contentWidth: viewModel.timelineContentWidth,
                        rowHeight: DAWTheme.phoneTrackRowHeight,
                        isTimelineScrolling: scrollCoordinator.isScrolling
                    )
                    .frame(height: DAWTheme.phoneTrackRowHeight)
                    .clipped()
                    .overlay(alignment: .bottom) {
                        Rectangle().fill(DAWTheme.border).frame(height: 1)
                    }
                }
            }
            .frame(width: viewModel.timelineContentWidth, alignment: .leading)
        }
        .frame(height: laneAreaHeight)
    }
}

private struct iPhoneTrackHeaderRow: View {
    let track: AudioTrack
    @Bindable var viewModel: WorkspaceViewModel
    let rowHeight: CGFloat

    private var liveTrack: AudioTrack {
        viewModel.project.tracks.first(where: { $0.id == track.id }) ?? track
    }

    private var displayColor: Color {
        viewModel.project.displayColor(for: liveTrack)
    }

    var body: some View {
        HStack(spacing: 0) {
            RoundedRectangle(cornerRadius: 3, style: .continuous)
                .fill(displayColor)
                .frame(width: 4)
                .padding(.vertical, 6)

            VStack(alignment: .leading, spacing: 6) {
                Text(liveTrack.standardCode)
                    .font(.system(size: 12, weight: .bold))
                    .foregroundStyle(displayColor)
                    .lineLimit(1)

                HStack(spacing: 8) {
                    phoneControlButton("M", isActive: liveTrack.isMuted, activeColor: .orange) {
                        viewModel.toggleMute(trackID: track.id)
                    }
                    phoneControlButton("S", isActive: liveTrack.isSolo, activeColor: .yellow) {
                        viewModel.toggleSolo(trackID: track.id)
                    }
                }
            }
            .padding(.leading, 8)
            .padding(.trailing, 6)
            .padding(.vertical, 6)

            Spacer(minLength: 0)
        }
        .frame(height: rowHeight)
        .background(DAWTheme.background.opacity(0.35))
        .overlay(alignment: .bottom) {
            Rectangle().fill(DAWTheme.border).frame(height: 1)
        }
    }

    private func phoneControlButton(
        _ title: String,
        isActive: Bool,
        activeColor: Color,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 12, weight: .bold))
                .foregroundStyle(isActive ? .black : DAWTheme.textPrimary)
                .frame(width: DAWTheme.phoneTrackControlSize, height: DAWTheme.phoneTrackControlSize)
                .background(isActive ? activeColor : DAWTheme.surfaceElevated)
                .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                .overlay {
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .stroke(DAWTheme.border, lineWidth: 1)
                }
        }
        .buttonStyle(.plain)
    }
}
