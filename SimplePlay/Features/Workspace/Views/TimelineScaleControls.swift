//
//  TimelineScaleControls.swift
//  SimplePlay
//

import SwiftUI

/// Collapsible zoom + track-height controls for the transport bar.
struct TimelineScaleControls: View {
    @Bindable var viewModel: WorkspaceViewModel
    var isCompact: Bool
    var usesPhoneDock: Bool
    @Binding var isExpanded: Bool
    var showsPanel: Bool = true
    var showsToggleButton: Bool = true

    private var buttonSize: CGFloat {
        usesPhoneDock ? 40 : (isCompact ? 30 : 34)
    }

    private var buttonCornerRadius: CGFloat {
        usesPhoneDock ? 10 : 8
    }

    var body: some View {
        Group {
            if showsPanel && isExpanded {
                scalePanel
            }

            if showsToggleButton {
                TransportToolbarButton(
                    systemName: isExpanded ? "xmark" : "arrow.up.left.and.arrow.down.right",
                    isActive: isExpanded,
                    size: buttonSize,
                    cornerRadius: buttonCornerRadius,
                    accessibilityLabel: isExpanded ? "Hide timeline scale controls" : "Show timeline scale controls"
                ) {
                    withAnimation(.easeInOut(duration: 0.18)) {
                        isExpanded.toggle()
                    }
                }
            }
        }
    }

    private var scalePanel: some View {
        HStack(alignment: .top, spacing: isCompact ? 8 : 10) {
            zoomSection

            panelDivider

            trackHeightSection
        }
        .padding(.horizontal, isCompact ? 8 : 10)
        .padding(.vertical, isCompact ? 6 : 8)
        .background(DAWTheme.background.opacity(0.55))
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .overlay {
            RoundedRectangle(cornerRadius: 8)
                .stroke(DAWTheme.border, lineWidth: 1)
        }
    }

    private var panelDivider: some View {
        Rectangle()
            .fill(DAWTheme.border)
            .frame(width: 1, height: 34)
    }

    private var zoomSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Zoom")
                .font(.system(size: 9, weight: .bold))
                .foregroundStyle(DAWTheme.textSecondary)

            HStack(spacing: 6) {
                scaleIconButton(systemName: "minus.magnifyingglass") {
                    viewModel.zoomOutOneStep()
                }

                Slider(
                    value: Binding(
                        get: { viewModel.timelineZoomSliderPosition() },
                        set: { viewModel.setTimelineZoomFromSliderPosition($0) }
                    ),
                    in: 0...1
                )
                .frame(width: isCompact ? 72 : 96)

                scaleIconButton(systemName: "plus.magnifyingglass") {
                    viewModel.zoomInOneStep()
                }

                if !isCompact || !usesPhoneDock {
                    Button("Fit") {
                        viewModel.zoomToFitTimeline()
                    }
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(DAWTheme.textSecondary)
                    .buttonStyle(.plain)
                }
            }
        }
    }

    private var trackHeightSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Tracks")
                .font(.system(size: 9, weight: .bold))
                .foregroundStyle(DAWTheme.textSecondary)

            HStack(spacing: 6) {
                scaleIconButton(systemName: "arrow.down.to.line.compact") {
                    nudgeTrackRowZoom(by: 0.88)
                }

                Slider(
                    value: Binding(
                        get: { viewModel.trackRowZoom },
                        set: { viewModel.setTrackRowZoom($0) }
                    ),
                    in: DAWTheme.minTrackRowZoom...DAWTheme.maxTrackRowZoom
                )
                .frame(width: isCompact ? 56 : 72)

                scaleIconButton(systemName: "arrow.up.to.line.compact") {
                    nudgeTrackRowZoom(by: 1.12)
                }

                Text("\(Int((viewModel.trackRowZoom * 100).rounded()))%")
                    .font(.system(size: 9, weight: .semibold, design: .monospaced))
                    .foregroundStyle(DAWTheme.textSecondary)
                    .frame(minWidth: 32, alignment: .trailing)
                    .accessibilityLabel("Track height \(Int((viewModel.trackRowZoom * 100).rounded())) percent")
            }
        }
    }

    private func nudgeTrackRowZoom(by factor: Double) {
        viewModel.setTrackRowZoom(viewModel.trackRowZoom * factor)
    }

    private func scaleIconButton(systemName: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: systemName)
                .font(isCompact ? .caption.weight(.semibold) : .body.weight(.semibold))
                .foregroundStyle(DAWTheme.textPrimary)
                .frame(width: isCompact ? 26 : 28, height: isCompact ? 26 : 28)
                .background(DAWTheme.surfaceElevated.opacity(0.85))
                .clipShape(RoundedRectangle(cornerRadius: 6))
        }
        .buttonStyle(.plain)
    }
}
