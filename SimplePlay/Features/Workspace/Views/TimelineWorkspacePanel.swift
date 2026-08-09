//
//  TimelineWorkspacePanel.swift
//  SimplePlay
//

import SwiftUI

/// Combined track headers + timeline with synchronized vertical scrolling.
struct TimelineWorkspacePanel: View {
    @Bindable var viewModel: WorkspaceViewModel
    @State private var isDropTargeted = false
    @State private var magnificationAnchor: Double?

    var body: some View {
        GeometryReader { geometry in
            ScrollView(.vertical, showsIndicators: true) {
                HStack(alignment: .top, spacing: 0) {
                    trackHeaderColumn
                    timelineScrollArea
                }
            }
            .onAppear {
                viewModel.updateTimelineViewportWidth(geometry.size.width - DAWTheme.trackHeaderWidth)
            }
            .onChange(of: geometry.size.width) { _, newWidth in
                viewModel.updateTimelineViewportWidth(newWidth - DAWTheme.trackHeaderWidth)
            }
        }
        .background(DAWTheme.background)
    }

    private var trackHeaderColumn: some View {
        VStack(spacing: 0) {
            Rectangle()
                .fill(DAWTheme.surfaceElevated)
                .frame(height: 28)
                .overlay(alignment: .leading) {
                    Text("Tracks")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(DAWTheme.textSecondary)
                        .padding(.leading, 12)
                }

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
                    .frame(height: DAWTheme.trackRowHeight)
            }

            Button {
                viewModel.showImportPanel = true
            } label: {
                Label("Add Track", systemImage: "plus")
                    .font(.subheadline)
                    .foregroundStyle(DAWTheme.textSecondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 12)
                    .frame(height: 44)
            }
            .buttonStyle(.plain)
        }
        .frame(width: DAWTheme.trackHeaderWidth)
        .background(DAWTheme.surface)
        .overlay(alignment: .trailing) {
            Rectangle()
                .fill(DAWTheme.border)
                .frame(width: 1)
        }
    }

    private var timelineScrollArea: some View {
        ScrollView(.horizontal, showsIndicators: true) {
            ZStack(alignment: .topLeading) {
                timelineBackground
                trackLanes
                sectionOverlays
                selectionOverlay
                playhead

                if viewModel.project.tracks.isEmpty {
                    TimelineEmptyDropHint()
                }
            }
            .frame(
                width: viewModel.timelineContentWidth,
                height: max(400, CGFloat(max(viewModel.project.tracks.count, 1)) * DAWTheme.trackRowHeight + 40)
            )
            .overlay {
                if isDropTargeted {
                    AudioDropOverlay(message: "Drop stems at this timeline position")
                }
            }
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
        }
        .simultaneousGesture(marqueeSelectionGesture)
        .simultaneousGesture(magnificationGesture)
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

    private var marqueeSelectionGesture: some Gesture {
        DragGesture(minimumDistance: 10)
            .onChanged { value in
                guard viewModel.draggingTrackID == nil else { return }

                let horizontal = abs(value.translation.width)
                let vertical = abs(value.translation.height)
                guard horizontal > vertical * 1.5, horizontal >= 12 else {
                    if vertical > horizontal {
                        viewModel.clearTimelineSelection()
                    }
                    return
                }

                let start = TimeInterval(max(0, value.startLocation.x) / viewModel.pixelsPerSecond)
                let end = TimeInterval(max(0, value.location.x) / viewModel.pixelsPerSecond)
                viewModel.selectionRange = min(start, end)...max(start, end)
            }
            .onEnded { value in
                guard viewModel.draggingTrackID == nil else { return }

                let horizontal = abs(value.translation.width)
                let vertical = abs(value.translation.height)
                guard horizontal > vertical * 1.5, horizontal >= 12 else {
                    viewModel.clearTimelineSelection()
                    return
                }

                let start = TimeInterval(max(0, value.startLocation.x) / viewModel.pixelsPerSecond)
                let end = TimeInterval(max(0, value.location.x) / viewModel.pixelsPerSecond)
                let range = min(start, end)...max(start, end)
                viewModel.selectionRange = range
                viewModel.selectClipsIntersecting(range: range)
            }
    }

    @ViewBuilder
    private var selectionOverlay: some View {
        if let range = viewModel.selectionRange {
            Rectangle()
                .fill(DAWTheme.selection)
                .frame(width: max(2, CGFloat(range.upperBound - range.lowerBound) * viewModel.pixelsPerSecond))
                .offset(x: CGFloat(range.lowerBound) * viewModel.pixelsPerSecond)
                .allowsHitTesting(false)
        }
    }

    private var timelineBackground: some View {
        VStack(spacing: 0) {
            TimelineRulerView(
                duration: viewModel.project.duration,
                pixelsPerSecond: viewModel.pixelsPerSecond,
                playheadTime: viewModel.playheadTime
            ) { time in
                viewModel.seek(to: time)
            }
            .frame(height: 28)

            ForEach(viewModel.project.tracks) { _ in
                Rectangle()
                    .fill(DAWTheme.background)
                    .frame(height: DAWTheme.trackRowHeight)
                    .overlay(alignment: .bottom) {
                        Rectangle().fill(DAWTheme.border).frame(height: 1)
                    }
            }
        }
    }

    private var trackLanes: some View {
        VStack(spacing: 0) {
            Color.clear.frame(height: 28)

            ForEach(Array(viewModel.project.tracks.enumerated()), id: \.element.id) { index, track in
                TrackLaneView(
                    track: track,
                    viewModel: viewModel,
                    contentWidth: viewModel.timelineContentWidth
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
                .frame(width: viewModel.timelineContentWidth, height: DAWTheme.trackRowHeight, alignment: .leading)
            }
        }
        .frame(width: viewModel.timelineContentWidth, alignment: .leading)
    }

    private var sectionOverlays: some View {
        ForEach(viewModel.project.sections) { section in
            SectionOverlayView(
                section: section,
                pixelsPerSecond: viewModel.pixelsPerSecond,
                isSelected: viewModel.selectedSectionID == section.id
            )
            .offset(x: CGFloat(section.startTime) * viewModel.pixelsPerSecond)
        }
    }

    private var playhead: some View {
        PlayheadView(
            playheadTime: viewModel.playheadTime,
            pixelsPerSecond: viewModel.pixelsPerSecond,
            height: CGFloat(max(viewModel.project.tracks.count, 1)) * DAWTheme.trackRowHeight + 28
        ) { time in
            viewModel.seek(to: time)
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
                .fill(DAWTheme.playhead)
                .frame(width: 2, height: height)

            Circle()
                .fill(DAWTheme.playhead)
                .frame(width: 10, height: 10)
                .offset(y: -4)
        }
        .frame(width: 16, height: height, alignment: .top)
        .contentShape(Rectangle().size(width: 16, height: height))
        .offset(x: x - 8)
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
        .animation(nil, value: playheadTime)
        .animation(nil, value: pixelsPerSecond)
    }
}
