//
//  TrackHeaderColumnView.swift
//  SimplePlay
//

import SwiftUI

struct TrackHeaderRowView: View {
    let track: AudioTrack
    @Bindable var viewModel: WorkspaceViewModel
    @Bindable private var waveformMonitor = WaveformLoadMonitor.shared

    private var liveTrack: AudioTrack {
        viewModel.project.tracks.first(where: { $0.id == track.id }) ?? track
    }

    private var displayColor: Color {
        viewModel.project.displayColor(for: liveTrack)
    }

    var body: some View {
        HStack(spacing: 8) {
            FaderMeterStripView(
                value: trackVolumeBinding,
                level: viewModel.trackMeterLevel(for: track.id),
                isAudible: viewModel.isTrackAudibleAtPlayhead(track.id),
                faderWidth: 20,
                faderHeight: 52,
                segmentCount: 8,
                dotSize: 4
            )
            .padding(.leading, 6)
            .accessibilityLabel("Track volume and level")

            VStack(spacing: 0) {
                VStack(spacing: 6) {
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
                            Text(liveTrack.originalName)
                                .font(.caption2)
                                .foregroundStyle(
                                    viewModel.project.isTrackDisplayedInColor(liveTrack)
                                        ? DAWTheme.textSecondary
                                        : DAWTheme.mutedTrack.opacity(0.85)
                                )
                                .lineLimit(1)
                        }

                        Spacer(minLength: 0)
                    }

                    TrackWaveformProgressBar(
                        color: displayColor,
                        progress: waveformMonitor.progress(for: track.id),
                        isVisible: waveformMonitor.isLoading(trackID: track.id)
                    )

                    HStack(spacing: 6) {
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

                        PanKnobView(
                            pan: Binding(
                                get: { trackPan },
                                set: { viewModel.setPan(trackID: track.id, pan: $0) }
                            )
                        )

                        Spacer(minLength: 0)
                    }
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 8)
                .frame(maxHeight: .infinity, alignment: .top)
            }
        }
        .background(DAWTheme.background.opacity(0.4))
        .overlay(alignment: .bottom) {
            Rectangle()
                .fill(DAWTheme.border)
                .frame(height: 1)
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
