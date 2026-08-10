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

struct SectionMarkerLaneView: View {
    @Bindable var viewModel: WorkspaceViewModel
    let contentWidth: CGFloat

    @State private var dragSession: SectionDragSession?

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
                    viewModel: viewModel,
                    isSelected: viewModel.selectedSectionID == section.id,
                    isDimmed: dragSession?.sectionID == section.id,
                    dragSession: $dragSession
                )
                .offset(x: CGFloat(section.startTime) * viewModel.pixelsPerSecond)
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
                    pixelsPerSecond: viewModel.pixelsPerSecond
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
        .frame(width: contentWidth, height: DAWTheme.markerLaneHeight - 8)
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
    let name: String
    let color: Color

    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(color.opacity(0.35))
            .overlay {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(color.opacity(0.9), style: StrokeStyle(lineWidth: 2, dash: [6, 4]))
            }
            .overlay(alignment: .leading) {
                Text(name)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 8)
            }
            .frame(
                width: max(48, CGFloat(range.upperBound - range.lowerBound) * pixelsPerSecond),
                height: DAWTheme.markerLaneHeight - 14
            )
            .offset(x: CGFloat(range.lowerBound) * pixelsPerSecond)
            .allowsHitTesting(false)
    }
}

private struct SectionMarkerGhostChipView: View {
    let section: ArrangementSection
    let startTime: TimeInterval
    let endTime: TimeInterval
    let pixelsPerSecond: CGFloat

    private var chipWidth: CGFloat {
        max(56, CGFloat(max(0, endTime - startTime)) * pixelsPerSecond)
    }

    var body: some View {
        HStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 4) {
                Text(section.name)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.white.opacity(0.92))
                    .lineLimit(1)

                HStack(spacing: 6) {
                    Text(TimeFormatting.format(startTime))
                    Text("→")
                    Text(TimeFormatting.format(endTime))
                }
                .font(.caption2.monospaced())
                .foregroundStyle(.white.opacity(0.78))
            }
            .padding(.horizontal, 10)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        }
        .frame(width: chipWidth, height: DAWTheme.markerLaneHeight - 14)
        .background {
            RoundedRectangle(cornerRadius: 10)
                .fill(
                    LinearGradient(
                        colors: [
                            section.color.opacity(0.52),
                            section.color.opacity(0.34),
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
        }
        .overlay {
            RoundedRectangle(cornerRadius: 10)
                .stroke(section.color.opacity(0.85), style: StrokeStyle(lineWidth: 2, dash: [5, 4]))
        }
        .shadow(color: section.color.opacity(0.35), radius: 12, y: 6)
    }
}

fileprivate struct SectionMarkerChipView: View {
    let section: ArrangementSection
    @Bindable var viewModel: WorkspaceViewModel
    let isSelected: Bool
    let isDimmed: Bool
    @Binding var dragSession: SectionDragSession?

    private let chipTapThreshold: CGFloat = 8
    private let chipMoveThreshold: CGFloat = 10

    private var liveSection: ArrangementSection {
        viewModel.project.sections.first(where: { $0.id == section.id }) ?? section
    }

    private var chipWidth: CGFloat {
        max(56, CGFloat(liveSection.duration) * viewModel.pixelsPerSecond)
    }

    var body: some View {
        HStack(spacing: 0) {
            resizeHandle(edge: .start)

            VStack(alignment: .leading, spacing: 4) {
                Text(liveSection.name)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.white)
                    .lineLimit(1)

                HStack(spacing: 6) {
                    Text(TimeFormatting.format(liveSection.startTime))
                    Text("→")
                    Text(TimeFormatting.format(liveSection.endTime))
                }
                .font(.caption2.monospaced())
                .foregroundStyle(.white.opacity(0.85))
            }
            .padding(.horizontal, 10)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
            .contentShape(Rectangle())
            .gesture(chipMoveOrTapGesture)

            resizeHandle(edge: .end)
        }
        .frame(width: chipWidth, height: DAWTheme.markerLaneHeight - 14)
        .opacity(isDimmed ? 0.28 : 1)
        .background {
            RoundedRectangle(cornerRadius: 10)
                .fill(
                    LinearGradient(
                        colors: [
                            liveSection.color.opacity(0.82),
                            liveSection.color.opacity(0.58),
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
        }
        .overlay {
            RoundedRectangle(cornerRadius: 10)
                .stroke(
                    isSelected ? Color.white.opacity(0.95) : liveSection.color.opacity(0.9),
                    lineWidth: isSelected ? 2 : 1
                )
        }
        .shadow(color: liveSection.color.opacity(0.25), radius: 5, y: 2)
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
        .help("Drag to move · Drag edges to resize · Double-click to trigger · Tap to delete")
#endif
    }

    private var chipMoveOrTapGesture: some Gesture {
        DragGesture(minimumDistance: 0, coordinateSpace: .named(sectionLaneCoordinateSpace))
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
                    viewModel.requestDeleteSection(section.id)
                }
            }
    }

    private enum ResizeEdge {
        case start
        case end
    }

    private var resizeHandleVisualWidth: CGFloat {
#if os(iOS)
        10
#else
        8
#endif
    }

    private var resizeHandleHitWidth: CGFloat {
#if os(iOS)
        36
#else
        24
#endif
    }

    private func resizeHandle(edge: ResizeEdge) -> some View {
        RoundedRectangle(cornerRadius: 3)
            .fill(Color.white.opacity(isDimmed ? 0.2 : 0.35))
            .frame(width: resizeHandleVisualWidth)
            .padding(.vertical, 8)
            .padding(edge == .start ? .leading : .trailing, 2)
            .contentShape(
                Rectangle().size(
                    width: resizeHandleHitWidth,
                    height: DAWTheme.markerLaneHeight - 14
                )
            )
            .highPriorityGesture(sectionDragGesture(kind: edge == .start ? .resizeStart : .resizeEnd))
#if os(macOS)
            .cursor(.resizeLeftRight)
#endif
    }

    private func sectionDragGesture(kind: WorkspaceViewModel.SectionDragKind) -> some Gesture {
        DragGesture(minimumDistance: 2, coordinateSpace: .named(sectionLaneCoordinateSpace))
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
            .onEnded { _ in
                let shouldCommit = dragSession?.sectionID == section.id && dragSession?.kind == kind
                defer { dragSession = nil }

                guard shouldCommit else {
                    viewModel.cancelSectionDrag()
                    return
                }

                viewModel.commitSectionDragPreview(sectionID: section.id, kind: kind)
            }
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
