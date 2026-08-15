//
//  SectionMarkerLaneView.swift
//  SimplePlay
//

import SwiftUI

private struct SectionDragSession: Equatable {
    let sectionID: UUID
    let kind: WorkspaceViewModel.SectionDragKind
    let anchorStart: TimeInterval
    let anchorEnd: TimeInterval
    /// Offset from the section start edge to the finger at drag begin (move only).
    let grabOffsetX: CGFloat
    var laneLocationX: CGFloat
}

private let sectionLaneCoordinateSpace = "sectionLane"

private enum SectionMarkerDensity {
    case full
    case compact
    case minimal
    case dot
}

private struct SectionMarkerLayout {
    let width: CGFloat
    let height: CGFloat
    let density: SectionMarkerDensity
    let showsName: Bool
    let showsTimeRange: Bool
    let showsResizeHandles: Bool
    let showsFloatingName: Bool
    let showsPlayTrigger: Bool
    let horizontalTextPadding: CGFloat

    var cornerRadius: CGFloat {
        switch density {
        case .full, .compact: 10
        case .minimal: 2
        case .dot: 0
        }
    }

    private static var resizeHandleReserve: CGFloat {
#if os(iOS)
        44
#else
        28
#endif
    }

    static func make(
        startTime: TimeInterval,
        endTime: TimeInterval,
        sections: [ArrangementSection],
        pixelsPerSecond: CGFloat,
        laneContentHeight: CGFloat,
        excludingSectionID: UUID? = nil
    ) -> SectionMarkerLayout {
        let duration = max(0, endTime - startTime)
        let naturalWidth = CGFloat(duration) * pixelsPerSecond

        var availableWidth = naturalWidth
        if let nextStart = sections
            .filter({ section in
                section.id != excludingSectionID && section.startTime > startTime + 0.001
            })
            .map(\.startTime)
            .min() {
            let gapToNext = CGFloat(nextStart - startTime) * pixelsPerSecond - 1
            availableWidth = min(naturalWidth, max(0, gapToNext))
        }

        let zoomScale = min(1, max(0.45, pixelsPerSecond / 48))
        let height = max(DAWTheme.isPhone ? 28 : 20, laneContentHeight * zoomScale)

        let minWidthForHandles: CGFloat = DAWTheme.isPhone ? 64 : 120
        let minHeightForHandles: CGFloat = DAWTheme.isPhone ? 26 : 32

        let handleReserve: CGFloat = {
            if availableWidth >= minWidthForHandles && height >= minHeightForHandles { return resizeHandleReserve }
            if availableWidth >= 72 { return 12 }
            return 4
        }()

        let showsHandles = availableWidth >= minWidthForHandles && height >= minHeightForHandles
        let showsPlayTrigger = DAWTheme.isPhone && availableWidth >= 40
        let playButtonReserve: CGFloat = showsPlayTrigger ? 28 : 0
        let textPadding = showsHandles ? handleReserve : 4
        let innerWidth = max(0, availableWidth - textPadding - textPadding - playButtonReserve)

        let showsTimeRange = innerWidth >= 108 && height >= 38
        let showsName = innerWidth >= 18 && height >= 16

        let density: SectionMarkerDensity
        let width: CGFloat

        if showsTimeRange {
            density = .full
            width = availableWidth
        } else if showsName {
            density = .compact
            width = availableWidth
        } else if availableWidth >= 5 {
            density = .minimal
            width = max(3, availableWidth)
        } else {
            density = .dot
            width = max(4, min(6, height * 0.85))
        }

        return SectionMarkerLayout(
            width: width,
            height: height,
            density: density,
            showsName: showsName,
            showsTimeRange: showsTimeRange,
            showsResizeHandles: showsHandles && (density == .full || (DAWTheme.isPhone && density == .compact)),
            showsFloatingName: !showsName && availableWidth >= 4,
            showsPlayTrigger: showsPlayTrigger,
            horizontalTextPadding: textPadding
        )
    }
}

private struct SectionMarkerLabelContent: View {
    let name: String
    let startLabel: String
    let endLabel: String
    let layout: SectionMarkerLayout

    var body: some View {
        VStack(alignment: .leading, spacing: layout.showsTimeRange ? 3 : 0) {
            if layout.showsName {
                Text(name)
                    .font(layout.showsTimeRange ? .caption.weight(.semibold) : .caption2.weight(.semibold))
                    .foregroundStyle(.white)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                    .allowsTightening(true)
            }

            if layout.showsTimeRange {
                Text("\(startLabel) → \(endLabel)")
                    .font(.caption2.monospaced())
                    .foregroundStyle(.white.opacity(0.85))
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                    .allowsTightening(true)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
    }
}

struct SectionMarkerLaneView: View {
    @Bindable var viewModel: WorkspaceViewModel
    let contentWidth: CGFloat
    @Environment(\.workspaceLayout) private var workspaceLayout

    @State private var dragSession: SectionDragSession?

    private var laneContentHeight: CGFloat {
        max(12, workspaceLayout.markerLaneHeight - 14)
    }

    private var creationDragMinimumDistance: CGFloat {
        2
    }

    private var creationHint: String {
#if os(iOS)
        "Tap and drag here to create a section marker"
#else
        "Drag here to create a section marker"
#endif
    }

    var body: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 8)
                .fill(DAWTheme.surfaceElevated.opacity(0.65))
                .overlay {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(DAWTheme.border, lineWidth: 1)
                }
                .contentShape(Rectangle())
                .highPriorityGesture(sectionCreationGesture)

            if let preview = viewModel.sectionCreationPreview {
                SectionCreationPreviewView(
                    range: preview,
                    pixelsPerSecond: viewModel.pixelsPerSecond,
                    laneContentHeight: laneContentHeight,
                    name: viewModel.preferredMarkerPreset,
                    color: Color(
                        hex: SectionMarkerPalette.nextDistinctHex(
                            sections: viewModel.project.sections,
                            name: viewModel.preferredMarkerPreset
                        )
                    ) ?? SectionMarkerPalette.color(
                        forName: viewModel.preferredMarkerPreset,
                        index: viewModel.project.sections.count
                    )
                )
            }

            ForEach(viewModel.project.sections) { section in
                SectionMarkerChipView(
                    section: section,
                    layout: SectionMarkerLayout.make(
                        startTime: section.startTime,
                        endTime: section.endTime,
                        sections: viewModel.project.sections,
                        pixelsPerSecond: viewModel.pixelsPerSecond,
                        laneContentHeight: laneContentHeight,
                        excludingSectionID: dragSession?.sectionID == section.id && dragSession?.kind == .move
                            ? section.id
                            : nil
                    ),
                    viewModel: viewModel,
                    isSelected: viewModel.selectedSectionID == section.id,
                    isDimmed: dragSession?.sectionID == section.id && dragSession?.kind == .move,
                    dragSession: $dragSession
                )
                .offset(x: CGFloat(section.startTime) * viewModel.pixelsPerSecond)
                .opacity(isMoveDragGhost(for: section) ? 0.22 : 1)
                .zIndex(dragSession?.sectionID == section.id ? 1 : 0)
            }

            if let session = dragSession,
               let section = viewModel.project.sections.first(where: { $0.id == session.sectionID }) {
                let ghostStart = ghostStartTime(for: session)
                let ghostEnd = ghostEndTime(for: session)

                SectionMarkerGhostChipView(
                    section: section,
                    startTime: ghostStart,
                    endTime: ghostEnd,
                    layout: SectionMarkerLayout.make(
                        startTime: ghostStart,
                        endTime: ghostEnd,
                        sections: viewModel.project.sections,
                        pixelsPerSecond: viewModel.pixelsPerSecond,
                        laneContentHeight: laneContentHeight,
                        excludingSectionID: session.sectionID
                    )
                )
                .offset(x: CGFloat(ghostStart) * viewModel.pixelsPerSecond)
                .transaction { $0.disablesAnimations = true }
                .zIndex(20)
                .allowsHitTesting(false)
            }

            if viewModel.project.sections.isEmpty, viewModel.sectionCreationPreview == nil {
                Text(creationHint)
                    .font(.caption2)
                    .foregroundStyle(DAWTheme.textSecondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 12)
                    .allowsHitTesting(false)
            }
        }
        .frame(width: contentWidth, height: workspaceLayout.markerLaneHeight - 8)
        .padding(.vertical, 4)
        .coordinateSpace(name: sectionLaneCoordinateSpace)
        .onChange(of: dragSession) { _, newValue in
            if newValue == nil {
                if viewModel.draggingSectionID != nil {
                    viewModel.cancelSectionDrag()
                }
                if viewModel.sectionMovePreviewSectionID != nil {
                    viewModel.clearSectionMovePreview()
                }
            }
        }
    }

    private func ghostStartTime(for session: SectionDragSession) -> TimeInterval {
        viewModel.previewRangeForSectionDrag(
            kind: session.kind,
            anchorStart: session.anchorStart,
            anchorEnd: session.anchorEnd,
            laneLocationX: session.laneLocationX,
            grabOffsetX: session.grabOffsetX
        ).lowerBound
    }

    private func ghostEndTime(for session: SectionDragSession) -> TimeInterval {
        viewModel.previewRangeForSectionDrag(
            kind: session.kind,
            anchorStart: session.anchorStart,
            anchorEnd: session.anchorEnd,
            laneLocationX: session.laneLocationX,
            grabOffsetX: session.grabOffsetX
        ).upperBound
    }

    private func isMoveDragGhost(for section: ArrangementSection) -> Bool {
        dragSession?.sectionID == section.id && dragSession?.kind == .move
    }

    private var sectionCreationGesture: some Gesture {
        DragGesture(minimumDistance: creationDragMinimumDistance)
            .onChanged { value in
                guard dragSession == nil, !viewModel.isSectionInteractionActive else { return }

                if viewModel.sectionCreationPreview == nil {
                    viewModel.beginSectionCreation(atX: value.startLocation.x)
                }
                viewModel.updateSectionCreation(toX: value.location.x)
            }
            .onEnded { _ in
                viewModel.commitSectionCreation()
            }
    }
}

private struct SectionCreationPreviewView: View {
    let range: ClosedRange<TimeInterval>
    let pixelsPerSecond: CGFloat
    let laneContentHeight: CGFloat
    let name: String
    let color: Color

    var body: some View {
        let layout = SectionMarkerLayout.make(
            startTime: range.lowerBound,
            endTime: range.upperBound,
            sections: [],
            pixelsPerSecond: pixelsPerSecond,
            laneContentHeight: laneContentHeight
        )

        RoundedRectangle(cornerRadius: layout.cornerRadius)
            .fill(color.opacity(0.35))
            .overlay {
                RoundedRectangle(cornerRadius: layout.cornerRadius)
                    .stroke(color.opacity(0.9), style: StrokeStyle(lineWidth: 2, dash: [6, 4]))
            }
            .overlay(alignment: .leading) {
                if layout.showsName {
                    Text(name)
                        .font(layout.showsTimeRange ? .caption.weight(.semibold) : .caption2.weight(.semibold))
                        .foregroundStyle(.white)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                        .padding(.horizontal, layout.horizontalTextPadding)
                }
            }
            .frame(width: max(layout.width, layout.density == .dot ? 6 : 12), height: layout.height)
            .clipShape(RoundedRectangle(cornerRadius: layout.cornerRadius))
            .offset(x: CGFloat(range.lowerBound) * pixelsPerSecond)
            .allowsHitTesting(false)
    }
}

private struct SectionMarkerGhostChipView: View {
    let section: ArrangementSection
    let startTime: TimeInterval
    let endTime: TimeInterval
    let layout: SectionMarkerLayout

    var body: some View {
        sectionChipSurface(
            name: section.name,
            startLabel: TimeFormatting.format(startTime),
            endLabel: TimeFormatting.format(endTime),
            color: section.color,
            isSelected: false,
            isDimmed: false,
            layout: layout
        )
    }
}

fileprivate struct SectionMarkerChipView: View {
    let section: ArrangementSection
    let layout: SectionMarkerLayout
    @Bindable var viewModel: WorkspaceViewModel
    let isSelected: Bool
    let isDimmed: Bool
    @Binding var dragSession: SectionDragSession?

#if os(iOS)
    private let chipTapThreshold: CGFloat = 12
    private let chipMoveThreshold: CGFloat = 14
    private let chipMoveDragMinimumDistance: CGFloat = 8
#else
    private let chipTapThreshold: CGFloat = 8
    private let chipMoveThreshold: CGFloat = 10
    private let chipMoveDragMinimumDistance: CGFloat = 4
#endif

    private var liveSection: ArrangementSection {
        viewModel.project.sections.first(where: { $0.id == section.id }) ?? section
    }

    var body: some View {
        Group {
            if layout.density == .dot {
                Circle()
                    .fill(liveSection.color.opacity(isDimmed ? 0.35 : 0.92))
                    .overlay {
                        Circle()
                            .stroke(
                                isSelected ? Color.white.opacity(0.95) : liveSection.color.opacity(0.9),
                                lineWidth: isSelected ? 2 : 1
                            )
                    }
                    .frame(width: layout.width, height: layout.width)
                    .contentShape(Rectangle())
                    .gesture(chipMoveOrTapGesture)
            } else {
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: layout.cornerRadius)
                        .fill(
                            LinearGradient(
                                colors: [
                                    liveSection.color.opacity(isDimmed ? 0.35 : 0.82),
                                    liveSection.color.opacity(isDimmed ? 0.22 : 0.58),
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )

                    SectionMarkerLabelContent(
                        name: liveSection.name,
                        startLabel: TimeFormatting.format(liveSection.startTime),
                        endLabel: TimeFormatting.format(liveSection.endTime),
                        layout: layout
                    )
                    .padding(.horizontal, layout.horizontalTextPadding)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                    .contentShape(Rectangle())
                    .gesture(chipMoveOrTapGesture)
                }
                .frame(width: layout.width, height: layout.height)
                .clipShape(RoundedRectangle(cornerRadius: layout.cornerRadius))
                .overlay {
                    RoundedRectangle(cornerRadius: layout.cornerRadius)
                        .stroke(
                            isSelected ? Color.white.opacity(0.95) : liveSection.color.opacity(0.9),
                            lineWidth: isSelected ? 2 : 1
                        )
                }
                .overlay(alignment: .leading) {
                    if layout.showsResizeHandles {
                        resizeHandle(edge: .start)
                    }
                }
                .overlay(alignment: .trailing) {
                    if layout.showsResizeHandles {
                        resizeHandle(edge: .end)
                    }
                }
                .shadow(
                    color: liveSection.color.opacity(layout.density == .full ? 0.25 : 0.12),
                    radius: layout.density == .full ? 5 : 2,
                    y: 2
                )
            }
        }
        .overlay {
            if DAWTheme.isPhone, !isDimmed, layout.showsPlayTrigger || layout.density == .dot {
                sectionPlayTriggerOverlay
            }
        }
        .opacity(isDimmed ? 0.28 : 1)
        .overlay(alignment: .topLeading) {
            if layout.showsFloatingName {
                Text(liveSection.name)
                    .font(.system(size: 9, weight: .semibold))
                    .foregroundStyle(.white)
                    .lineLimit(1)
                    .fixedSize(horizontal: true, vertical: false)
                    .padding(.horizontal, 4)
                    .padding(.vertical, 1)
                    .background(liveSection.color.opacity(0.94))
                    .clipShape(RoundedRectangle(cornerRadius: 4, style: .continuous))
                    .overlay {
                        RoundedRectangle(cornerRadius: 4, style: .continuous)
                            .stroke(Color.white.opacity(0.25), lineWidth: 0.5)
                    }
                    .offset(y: -12)
                    .allowsHitTesting(false)
            }
        }
        .simultaneousGesture(
            TapGesture(count: 2).onEnded {
                viewModel.triggerSection(liveSection)
            }
        )
        .contextMenu {
            Button("Assign MIDI Pad") {
                viewModel.startMIDILearn(for: .section(section.id))
            }
            Button("Delete Marker", role: .destructive) {
                viewModel.requestDeleteSection(section.id)
            }
        }
#if os(macOS)
        .help("Drag center to move · Drag edges to resize · Tap or double-click to trigger")
#endif
    }

    private var chipMoveOrTapGesture: some Gesture {
        DragGesture(
            minimumDistance: chipMoveDragMinimumDistance,
            coordinateSpace: .named(sectionLaneCoordinateSpace)
        )
            .onChanged { value in
                guard dragSession == nil
                    || (dragSession?.sectionID == section.id && dragSession?.kind == .move) else {
                    return
                }

                let distance = hypot(value.translation.width, value.translation.height)
                guard distance >= chipMoveThreshold else { return }

                if dragSession == nil {
                    let grabOffsetX = value.startLocation.x - CGFloat(liveSection.startTime) * viewModel.pixelsPerSecond
                    dragSession = SectionDragSession(
                        sectionID: section.id,
                        kind: .move,
                        anchorStart: liveSection.startTime,
                        anchorEnd: liveSection.endTime,
                        grabOffsetX: grabOffsetX,
                        laneLocationX: value.location.x
                    )
                } else if var session = dragSession,
                          session.sectionID == section.id,
                          session.kind == .move {
                    session.laneLocationX = value.location.x
                    dragSession = session
                }

                if let session = dragSession,
                   session.sectionID == section.id,
                   session.kind == .move {
                    viewModel.updateSectionMovePreview(
                        sectionID: section.id,
                        anchorStart: session.anchorStart,
                        anchorEnd: session.anchorEnd,
                        laneLocationX: session.laneLocationX,
                        grabOffsetX: session.grabOffsetX
                    )
                }
            }
            .onEnded { value in
                let shouldCommitMove = dragSession?.sectionID == section.id && dragSession?.kind == .move
                defer { dragSession = nil }

                if shouldCommitMove {
                    viewModel.commitSectionDragPreview(sectionID: section.id, kind: .move)
                    return
                }

                let distance = hypot(value.translation.width, value.translation.height)
                if distance < chipTapThreshold {
                    viewModel.triggerSection(liveSection)
                }
            }
    }

    private enum ResizeEdge {
        case start
        case end
    }

    private var resizeHandleHitWidth: CGFloat {
#if os(iOS)
        44
#else
        28
#endif
    }

    @ViewBuilder
    private var sectionPlayTriggerOverlay: some View {
        HStack(spacing: 0) {
            Spacer(minLength: 0)
            sectionPlayTriggerButton
            if layout.showsResizeHandles {
                Color.clear.frame(width: resizeHandleHitWidth)
            }
        }
    }

    private var sectionPlayTriggerButton: some View {
        let status = viewModel.sectionPlaybackStatus(for: liveSection)

        return Button {
            viewModel.triggerSection(liveSection)
        } label: {
            Image(systemName: sectionPlayIcon(for: status))
                .font(.system(size: layout.density == .dot ? 7 : 9, weight: .bold))
                .foregroundStyle(.white)
                .frame(
                    width: layout.density == .dot ? 18 : 24,
                    height: layout.density == .dot ? 18 : 24
                )
                .background(playTriggerBackground(for: status))
                .clipShape(Circle())
                .overlay {
                    Circle().stroke(Color.white.opacity(status == .idle ? 0.35 : 0.7), lineWidth: 1)
                }
        }
        .buttonStyle(.plain)
        .zIndex(3)
        .accessibilityLabel("Play \(liveSection.name)")
    }

    private func sectionPlayIcon(for status: WorkspaceViewModel.SectionPlaybackStatus) -> String {
        switch status {
        case .idle: "play.fill"
        case .playing: "speaker.wave.2.fill"
        case .queued: "arrow.right.to.line"
        case .repeatingAtEnd: "repeat.1"
        }
    }

    private func playTriggerBackground(for status: WorkspaceViewModel.SectionPlaybackStatus) -> Color {
        switch status {
        case .idle: Color.black.opacity(0.45)
        case .playing: DAWTheme.playhead.opacity(0.92)
        case .queued: DAWTheme.accent.opacity(0.85)
        case .repeatingAtEnd: DAWTheme.accent.opacity(0.75)
        }
    }

    private func resizeHandle(edge: ResizeEdge) -> some View {
        HStack(spacing: 0) {
            if edge == .end {
                Spacer(minLength: 0)
            }

            resizeGripIndicator

            if edge == .start {
                Spacer(minLength: 0)
            }
        }
        .frame(width: resizeHandleHitWidth)
        .frame(maxHeight: .infinity)
        .contentShape(Rectangle())
        .zIndex(2)
        .highPriorityGesture(sectionDragGesture(kind: edge == .start ? .resizeStart : .resizeEnd))
#if os(macOS)
        .cursor(.resizeLeftRight)
#endif
    }

    private var resizeGripIndicator: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 3, style: .continuous)
                .fill(Color.black.opacity(isDimmed ? 0.28 : 0.48))
                .overlay {
                    RoundedRectangle(cornerRadius: 3, style: .continuous)
                        .stroke(Color.white.opacity(0.18), lineWidth: 0.5)
                }

            HStack(spacing: 3) {
                ForEach(0..<2, id: \.self) { _ in
                    Capsule()
                        .fill(Color.white.opacity(isDimmed ? 0.55 : 0.92))
                        .frame(width: 2, height: 12)
                }
            }
        }
        .frame(width: 13, height: 22)
        .padding(.horizontal, 5)
    }

    private func sectionDragGesture(kind: WorkspaceViewModel.SectionDragKind) -> some Gesture {
        DragGesture(minimumDistance: 0, coordinateSpace: .named(sectionLaneCoordinateSpace))
            .onChanged { value in
                guard dragSession == nil
                    || (dragSession?.sectionID == section.id && dragSession?.kind == kind) else {
                    return
                }

                if dragSession == nil {
                    let grabOffsetX: CGFloat
                    if kind == .resizeStart {
                        let edgeX = CGFloat(liveSection.startTime) * viewModel.pixelsPerSecond
                        grabOffsetX = value.startLocation.x - edgeX
                    } else {
                        let edgeX = CGFloat(liveSection.endTime) * viewModel.pixelsPerSecond
                        grabOffsetX = value.startLocation.x - edgeX
                    }
                    dragSession = SectionDragSession(
                        sectionID: section.id,
                        kind: kind,
                        anchorStart: liveSection.startTime,
                        anchorEnd: liveSection.endTime,
                        grabOffsetX: grabOffsetX,
                        laneLocationX: value.location.x
                    )
                    viewModel.beginSectionDrag(sectionID: section.id, kind: kind)
                } else if var session = dragSession,
                          session.sectionID == section.id,
                          session.kind == kind {
                    session.laneLocationX = value.location.x
                    dragSession = session
                }

                if let session = dragSession,
                   session.sectionID == section.id,
                   session.kind == kind {
                    viewModel.updateSectionDragPreview(
                        kind: kind,
                        anchorStart: session.anchorStart,
                        anchorEnd: session.anchorEnd,
                        laneLocationX: session.laneLocationX,
                        grabOffsetX: session.grabOffsetX
                    )
                }
            }
            .onEnded { value in
                let shouldCommit = dragSession?.sectionID == section.id && dragSession?.kind == kind
                defer { dragSession = nil }

                guard shouldCommit else {
                    viewModel.cancelSectionDrag()
                    return
                }

                let distance = hypot(value.translation.width, value.translation.height)
                guard distance >= 2 else {
                    viewModel.cancelSectionDrag()
                    return
                }

                viewModel.commitSectionDragPreview(sectionID: section.id, kind: kind)
            }
    }
}

@ViewBuilder
private func sectionChipSurface(
    name: String,
    startLabel: String,
    endLabel: String,
    color: Color,
    isSelected: Bool,
    isDimmed: Bool,
    layout: SectionMarkerLayout
) -> some View {
    if layout.density == .dot {
        Circle()
            .fill(color.opacity(isDimmed ? 0.35 : 0.92))
            .overlay {
                Circle()
                    .stroke(color.opacity(0.85), style: StrokeStyle(lineWidth: 2, dash: [5, 4]))
            }
            .frame(width: layout.width, height: layout.width)
    } else {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: layout.cornerRadius)
                .fill(
                    LinearGradient(
                        colors: [
                            color.opacity(0.52),
                            color.opacity(0.34),
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )

            SectionMarkerLabelContent(
                name: name,
                startLabel: startLabel,
                endLabel: endLabel,
                layout: layout
            )
            .padding(.horizontal, layout.horizontalTextPadding)
        }
        .frame(width: layout.width, height: layout.height)
        .clipShape(RoundedRectangle(cornerRadius: layout.cornerRadius))
        .overlay {
            RoundedRectangle(cornerRadius: layout.cornerRadius)
                .stroke(color.opacity(0.85), style: StrokeStyle(lineWidth: 2, dash: [5, 4]))
        }
        .shadow(color: color.opacity(0.35), radius: layout.density == .full ? 12 : 4, y: layout.density == .full ? 6 : 2)
    }
}

struct SectionEdgeGuideOverlay: View {
    let startTime: TimeInterval
    let endTime: TimeInterval
    let showStartEdge: Bool
    let showEndEdge: Bool
    let color: Color
    let pixelsPerSecond: CGFloat
    let height: CGFloat

    var body: some View {
        ZStack(alignment: .topLeading) {
            if showStartEdge {
                edgeGuide(at: startTime)
            }
            if showEndEdge {
                edgeGuide(at: endTime)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }

    private func edgeGuide(at time: TimeInterval) -> some View {
        ZStack(alignment: .top) {
            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [
                            color.opacity(0.18),
                            color.opacity(0.85),
                            color.opacity(0.18),
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .frame(width: 1, height: height)

            Circle()
                .fill(color.opacity(0.95))
                .frame(width: 6, height: 6)
                .offset(y: -3)
        }
        .offset(x: CGFloat(time) * pixelsPerSecond)
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
