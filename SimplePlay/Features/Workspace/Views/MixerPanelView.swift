//
//  MixerPanelView.swift
//  SimplePlay
//

import SwiftUI

struct MixerPanelView: View {
    @Bindable var viewModel: WorkspaceViewModel
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    private var isCompact: Bool {
        horizontalSizeClass == .compact
    }

    private var stripHeight: CGFloat {
        isCompact ? 250 : 270
    }

    var body: some View {
        VStack(spacing: 0) {
            mixerHandle
            mixerHeader

            if viewModel.project.tracks.isEmpty {
                Text("Import tracks to mix levels.")
                    .font(.caption)
                    .foregroundStyle(DAWTheme.textSecondary)
                    .frame(maxWidth: .infinity, minHeight: 120)
                    .padding(.bottom, 12)
            } else {
                HStack(spacing: 0) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(alignment: .top, spacing: isCompact ? 10 : 14) {
                            ForEach(Array(viewModel.project.groups.enumerated()), id: \.element.id) { index, group in
                                let groupTracks = viewModel.tracks(forGroupIndex: index)
                                if !groupTracks.isEmpty {
                                    ForEach(groupTracks) { track in
                                        mixerChannelStrip(for: track)
                                    }

                                    groupDivider
                                }
                            }

                            ForEach(orphanTracks) { track in
                                mixerChannelStrip(for: track)
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                    }
                    .frame(height: stripHeight)
                    .clipped()

                    pinnedMastersColumn
                        .frame(height: stripHeight)
                }
            }
        }
        .background {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(DAWTheme.surface)
                .shadow(color: .black.opacity(0.35), radius: 18, y: -4)
        }
        .overlay {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(DAWTheme.border, lineWidth: 1)
        }
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .padding(.horizontal, isCompact ? 8 : 12)
        .padding(.bottom, 8)
    }

    private var orphanTracks: [AudioTrack] {
        viewModel.project.tracks.filter { track in
            guard let index = track.clips.first?.groupIndex,
                  viewModel.project.groups.indices.contains(index) else { return true }
            return false
        }
    }

    private var groupDivider: some View {
        Rectangle()
            .fill(DAWTheme.border.opacity(0.8))
            .frame(width: 1)
            .padding(.vertical, 12)
    }

    private var pinnedMastersColumn: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(alignment: .top, spacing: isCompact ? 8 : 10) {
                ForEach(viewModel.project.groups) { group in
                    groupMasterStrip(for: group)
                }

                projectMasterStrip
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
        }
        .background(DAWTheme.surfaceElevated.opacity(0.95))
        .overlay(alignment: .leading) {
            Rectangle()
                .fill(DAWTheme.border)
                .frame(width: 1)
        }
    }

    private var mixerHandle: some View {
        Capsule()
            .fill(DAWTheme.border)
            .frame(width: 36, height: 4)
            .padding(.top, 8)
            .padding(.bottom, 8)
    }

    private var mixerHeader: some View {
        HStack(spacing: 0) {
            Text("Mixer")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(DAWTheme.textPrimary)

            Spacer()

            Button {
                withAnimation(.easeInOut(duration: 0.22)) {
                    viewModel.showMixerPanel = false
                }
            } label: {
                Image(systemName: "chevron.down")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(DAWTheme.textSecondary)
                    .frame(width: 28, height: 28)
                    .background(DAWTheme.surfaceElevated)
                    .clipShape(Circle())
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Close Mixer")
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 8)
        .background(DAWTheme.surface)
        .zIndex(1)
    }

    private func mixerChannelStrip(for track: AudioTrack) -> some View {
        let displayColor = viewModel.project.displayColor(for: track)
        let level = viewModel.trackMeterLevel(for: track.id)
        let isAudible = viewModel.isTrackAudibleAtPlayhead(track.id)

        return VStack(spacing: 8) {
            Text(track.standardCode)
                .font(.caption2.weight(.bold))
                .foregroundStyle(displayColor)
                .lineLimit(1)

            Text(track.originalName)
                .font(.system(size: 9))
                .foregroundStyle(DAWTheme.textSecondary)
                .lineLimit(1)
                .frame(maxWidth: 68)

            HStack(spacing: 4) {
                TrackControlButton(
                    title: "M",
                    isActive: track.isMuted,
                    activeColor: .orange
                ) {
                    viewModel.toggleMute(trackID: track.id)
                }

                TrackControlButton(
                    title: "S",
                    isActive: track.isSolo,
                    activeColor: .yellow
                ) {
                    viewModel.toggleSolo(trackID: track.id)
                }
            }

            PanKnobView(
                pan: Binding(
                    get: { trackPan(for: track.id) },
                    set: { viewModel.setPan(trackID: track.id, pan: $0) }
                )
            )

            FaderMeterStripView(
                value: trackVolumeBinding(for: track.id),
                level: level,
                isAudible: isAudible,
                faderWidth: isCompact ? 24 : 28,
                faderHeight: isCompact ? 110 : 130,
                segmentCount: 12,
                dotSize: 5
            )
        }
        .frame(width: isCompact ? 88 : 96)
        .padding(.vertical, 10)
        .padding(.horizontal, 8)
        .background(DAWTheme.background.opacity(0.45))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay {
            RoundedRectangle(cornerRadius: 12)
                .stroke(DAWTheme.border, lineWidth: 1)
        }
    }

    private func groupMasterStrip(for group: TrackGroup) -> some View {
        let level = viewModel.groupMeterLevel(for: group.id)
        let isAudible = viewModel.isPlaying

        return VStack(spacing: 8) {
            Text(groupShortName(group.name))
                .font(.caption2.weight(.bold))
                .foregroundStyle(DAWTheme.textPrimary)
                .lineLimit(1)

            Text("Group")
                .font(.system(size: 9))
                .foregroundStyle(DAWTheme.textSecondary)

            Spacer(minLength: 22)

            FaderMeterStripView(
                value: groupVolumeBinding(for: group.id),
                level: level,
                isAudible: isAudible,
                faderWidth: isCompact ? 24 : 28,
                faderHeight: isCompact ? 130 : 150,
                segmentCount: 12,
                dotSize: 5
            )
        }
        .frame(width: isCompact ? 88 : 96)
        .padding(.vertical, 10)
        .padding(.horizontal, 8)
        .background(DAWTheme.background.opacity(0.55))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay {
            RoundedRectangle(cornerRadius: 12)
                .stroke(DAWTheme.border, lineWidth: 1)
        }
    }

    private var projectMasterStrip: some View {
        let level = viewModel.masterMeterLevel
        let isAudible = viewModel.isPlaying

        return VStack(spacing: 8) {
            Text("Main")
                .font(.caption2.weight(.bold))
                .foregroundStyle(DAWTheme.textPrimary)

            Text("Output")
                .font(.system(size: 9))
                .foregroundStyle(DAWTheme.textSecondary)

            Spacer(minLength: 22)

            FaderMeterStripView(
                value: masterVolumeBinding,
                level: level,
                isAudible: isAudible,
                faderWidth: isCompact ? 26 : 30,
                faderHeight: isCompact ? 130 : 150,
                valueRange: 0...1,
                segmentCount: 12,
                dotSize: 5
            )
        }
        .frame(width: isCompact ? 88 : 96)
        .padding(.vertical, 10)
        .padding(.horizontal, 8)
        .background(DAWTheme.accent.opacity(0.08))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay {
            RoundedRectangle(cornerRadius: 12)
                .stroke(DAWTheme.accent.opacity(0.45), lineWidth: 1)
        }
    }

    private func groupShortName(_ name: String) -> String {
        let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return "MT" }
        if trimmed.count <= 8 { return trimmed }
        return String(trimmed.prefix(7)) + "…"
    }

    private func trackPan(for trackID: UUID) -> Double {
        viewModel.project.tracks.first(where: { $0.id == trackID })?.pan ?? 0
    }

    private func trackVolumeBinding(for trackID: UUID) -> Binding<Double> {
        Binding(
            get: {
                viewModel.project.tracks.first(where: { $0.id == trackID })?.volume ?? 1
            },
            set: { viewModel.setTrackVolume(trackID: trackID, volume: $0) }
        )
    }

    private func groupVolumeBinding(for groupID: UUID) -> Binding<Double> {
        Binding(
            get: {
                viewModel.project.groups.first(where: { $0.id == groupID })?.volume ?? 1
            },
            set: { viewModel.setGroupVolume(groupID: groupID, volume: $0) }
        )
    }

    private var masterVolumeBinding: Binding<Double> {
        Binding(
            get: { viewModel.project.masterVolume },
            set: { viewModel.setMasterVolume($0) }
        )
    }
}
