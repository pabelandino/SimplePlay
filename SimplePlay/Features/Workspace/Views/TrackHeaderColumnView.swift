//
//  TrackHeaderColumnView.swift
//  SimplePlay
//

import SwiftUI

struct TrackHeaderRowView: View {
    let track: AudioTrack
    @Bindable var viewModel: WorkspaceViewModel
    var rowHeight: CGFloat = DAWTheme.trackRowHeight
    @Bindable private var waveformMonitor = WaveformLoadMonitor.shared

    private enum Density {
        case full
        case compact
        case minimal
    }

    private var liveTrack: AudioTrack {
        viewModel.project.tracks.first(where: { $0.id == track.id }) ?? track
    }

    private var displayColor: Color {
        viewModel.project.displayColor(for: liveTrack)
    }

    private var density: Density {
        if rowHeight < 48 { return .minimal }
        if rowHeight < 64 { return .compact }
        return .full
    }

    private var faderHeight: CGFloat {
        switch density {
        case .full:
            min(52, rowHeight - 12)
        case .compact:
            min(36, rowHeight - 10)
        case .minimal:
            min(28, rowHeight - 6)
        }
    }

    private var faderWidth: CGFloat {
        density == .minimal ? 14 : 20
    }

    var body: some View {
        Group {
            switch density {
            case .full:
                fullLayout
            case .compact:
                compactLayout
            case .minimal:
                minimalLayout
            }
        }
        .frame(height: rowHeight)
        .clipped()
        .background(DAWTheme.background.opacity(0.4))
        .overlay(alignment: .bottom) {
            Rectangle()
                .fill(DAWTheme.border)
                .frame(height: 1)
        }
    }

    private var fullLayout: some View {
        HStack(spacing: 8) {
            faderStrip

            VStack(spacing: 0) {
                VStack(spacing: 6) {
                    trackTitleRow(showSubtitle: true)

                    TrackWaveformProgressBar(
                        color: displayColor,
                        progress: waveformMonitor.progress(for: track.id),
                        isVisible: waveformMonitor.isLoading(trackID: track.id)
                    )

                    HStack(spacing: 6) {
                        trackControlButtons(showPan: true)
                        Spacer(minLength: 0)
                    }
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 8)
                .frame(maxHeight: .infinity, alignment: .top)
            }
        }
    }

    private var compactLayout: some View {
        HStack(spacing: 6) {
            faderStrip

            VStack(alignment: .leading, spacing: 4) {
                trackTitleRow(showSubtitle: true)

                HStack(spacing: 4) {
                    trackControlButtons(showPan: true)
                    Spacer(minLength: 0)
                }
            }
            .padding(.trailing, 8)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.leading, 4)
    }

    private var minimalLayout: some View {
        HStack(spacing: 4) {
            faderStrip

            Text(liveTrack.standardCode)
                .font(.caption2.weight(.bold))
                .foregroundStyle(displayColor)
                .lineLimit(1)
                .frame(minWidth: 24, alignment: .leading)

            trackControlButtons(showPan: false)

            Spacer(minLength: 0)
        }
        .padding(.horizontal, 6)
    }

    private var faderStrip: some View {
        FaderMeterStripView(
            value: trackVolumeBinding,
            level: viewModel.trackMeterLevel(for: track.id),
            isAudible: viewModel.isTrackAudibleAtPlayhead(track.id),
            faderWidth: faderWidth,
            faderHeight: faderHeight,
            segmentCount: density == .full ? 8 : 6,
            dotSize: density == .minimal ? 3 : 4
        )
        .padding(.leading, density == .minimal ? 2 : 6)
        .accessibilityLabel("Track volume and level")
    }

    @ViewBuilder
    private func trackTitleRow(showSubtitle: Bool) -> some View {
        HStack(spacing: 6) {
            TrackReorderHandle(
                track: track,
                viewModel: viewModel,
                displayColor: displayColor
            )

            VStack(alignment: .leading, spacing: 2) {
                Text(liveTrack.standardCode)
                    .font(.caption.weight(.bold))
                    .foregroundStyle(displayColor)
                    .shadow(
                        color: displayColor.opacity(waveformMonitor.isLoading(trackID: track.id) ? 0.75 : 0),
                        radius: 6
                    )
                if showSubtitle {
                    Text(liveTrack.originalName)
                        .font(.caption2)
                        .foregroundStyle(
                            viewModel.project.isTrackDisplayedInColor(liveTrack)
                                ? DAWTheme.textSecondary
                                : DAWTheme.mutedTrack.opacity(0.85)
                        )
                        .lineLimit(1)
                }
            }

            Spacer(minLength: 0)
        }
    }

    @ViewBuilder
    private func trackControlButtons(showPan: Bool) -> some View {
        TrackControlButton(
            title: "M",
            isActive: liveTrack.isMuted,
            activeColor: .orange
        ) {
            viewModel.toggleMute(trackID: track.id)
        }

        TrackControlButton(
            title: "S",
            isActive: liveTrack.isSolo,
            activeColor: .yellow
        ) {
            viewModel.toggleSolo(trackID: track.id)
        }

        if showPan {
            PanKnobView(
                pan: Binding(
                    get: { trackPan },
                    set: { viewModel.setPan(trackID: track.id, pan: $0) }
                )
            )
        }
    }

    private var trackVolumeBinding: Binding<Double> {
        Binding(
            get: {
                viewModel.project.tracks.first(where: { $0.id == track.id })?.volume ?? liveTrack.volume
            },
            set: { viewModel.setTrackVolume(trackID: track.id, volume: $0) }
        )
    }

    private var trackPan: Double {
        viewModel.project.tracks.first(where: { $0.id == track.id })?.pan ?? track.pan
    }
}

struct TrackReorderHandle: View {
    let track: AudioTrack
    @Bindable var viewModel: WorkspaceViewModel
    let displayColor: Color

    var body: some View {
        Image(systemName: "line.3.horizontal")
            .font(.caption2.weight(.semibold))
            .foregroundStyle(viewModel.draggingTrackID == track.id ? displayColor : DAWTheme.textSecondary)
            .frame(width: 18, height: 28)
            .contentShape(Rectangle())
            .help("Drag to reorder track")
            .highPriorityGesture(
                DragGesture(minimumDistance: 4)
                    .onChanged { value in
                        viewModel.beginTrackDrag(trackID: track.id)
                        viewModel.updateTrackDrag(trackID: track.id, translation: value.translation.height)
                    }
                    .onEnded { _ in
                        viewModel.endTrackDrag(trackID: track.id)
                    }
            )
    }
}
