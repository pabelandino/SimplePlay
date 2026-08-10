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

    private var usesPhoneLayout: Bool {
        DAWTheme.isPhone
    }

    private var stripHeight: CGFloat {
        if usesPhoneLayout { return DAWTheme.phoneMixerStripHeight }
        return isCompact ? 250 : 270
    }

    private var channelFaderHeight: CGFloat {
        usesPhoneLayout ? 118 : (isCompact ? 110 : 130)
    }

    private var masterFaderHeight: CGFloat {
        usesPhoneLayout ? 118 : (isCompact ? 130 : 150)
    }

    private var channelFaderWidth: CGFloat {
        usesPhoneLayout ? 28 : (isCompact ? 24 : 28)
    }

    private var channelStripWidth: CGFloat {
        usesPhoneLayout ? 74 : (isCompact ? 88 : 96)
    }

    var body: some View {
        VStack(spacing: 0) {
            mixerHandle
            mixerHeader

            if viewModel.project.tracks.isEmpty {
                Text("Import tracks to mix levels.")
                    .font(.caption)
                    .foregroundStyle(DAWTheme.textSecondary)
                    .frame(maxWidth: .infinity, minHeight: usesPhoneLayout ? 88 : 120)
                    .padding(.bottom, usesPhoneLayout ? 8 : 12)
            } else {
                mixerScrollWithPinnedMasters
            }
        }
        .background {
            RoundedRectangle(cornerRadius: usesPhoneLayout ? 14 : 16, style: .continuous)
                .fill(DAWTheme.surface)
                .shadow(color: .black.opacity(0.35), radius: 18, y: -4)
        }
        .overlay {
            RoundedRectangle(cornerRadius: usesPhoneLayout ? 14 : 16, style: .continuous)
                .stroke(DAWTheme.border, lineWidth: 1)
        }
        .padding(.horizontal, usesPhoneLayout ? 8 : (isCompact ? 8 : 12))
        .padding(.bottom, usesPhoneLayout ? 4 : 8)
    }

    private var mixerScrollWithPinnedMasters: some View {
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
                .padding(.horizontal, usesPhoneLayout ? 10 : 16)
                .padding(.vertical, usesPhoneLayout ? 10 : 8)
            }
            .frame(height: stripHeight)
            .clipped()

            pinnedMastersColumn
                .frame(height: stripHeight)
        }
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
            .padding(.vertical, usesPhoneLayout ? 8 : 12)
    }

    private var pinnedMastersColumn: some View {
        Group {
            if usesPhoneLayout {
                mastersStripRow
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding(.leading, 8)
                    .padding(.trailing, 10)
                    .padding(.vertical, 10)
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    mastersStripRow
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                }
            }
        }
        .frame(width: usesPhoneLayout ? phoneMastersColumnWidth : nil, alignment: .trailing)
        .background(DAWTheme.surfaceElevated.opacity(0.95))
        .overlay(alignment: .leading) {
            Rectangle()
                .fill(DAWTheme.border)
                .frame(width: 1)
        }
    }

    private var mastersStripRow: some View {
        HStack(alignment: .top, spacing: usesPhoneLayout ? 6 : (isCompact ? 8 : 10)) {
            ForEach(viewModel.project.groups) { group in
                groupMasterStrip(for: group)
            }

            projectMasterStrip
        }
    }

    private var phoneStripHorizontalPadding: CGFloat { 6 }

    private var phoneStripOuterWidth: CGFloat {
        channelStripWidth + phoneStripHorizontalPadding * 2
    }

    private var phoneMastersColumnWidth: CGFloat {
        let stripCount = viewModel.project.groups.count + 1
        let spacing = CGFloat(max(0, stripCount - 1)) * 6
        let columnHorizontalPadding: CGFloat = 16
        let trailingSafetyInset: CGFloat = 6
        return CGFloat(stripCount) * phoneStripOuterWidth + spacing + columnHorizontalPadding + trailingSafetyInset
    }

    private var mixerHandle: some View {
        Capsule()
            .fill(DAWTheme.border)
            .frame(width: 36, height: 4)
            .padding(.top, usesPhoneLayout ? 6 : 8)
            .padding(.bottom, usesPhoneLayout ? 4 : 8)
    }

    private var mixerHeader: some View {
        HStack(spacing: 0) {
            Text("Mixer")
                .font(usesPhoneLayout ? .caption.weight(.semibold) : .subheadline.weight(.semibold))
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
        .padding(.horizontal, usesPhoneLayout ? 12 : 16)
        .padding(.bottom, usesPhoneLayout ? 4 : 8)
        .background(DAWTheme.surface)
        .zIndex(1)
    }

    private func mixerChannelStrip(for track: AudioTrack) -> some View {
        let displayColor = viewModel.project.displayColor(for: track)
        let level = viewModel.trackMeterLevel(for: track.id)
        let isAudible = viewModel.isTrackAudibleAtPlayhead(track.id)

        return VStack(spacing: usesPhoneLayout ? 5 : 8) {
            Text(track.standardCode)
                .font(.caption2.weight(.bold))
                .foregroundStyle(displayColor)
                .lineLimit(1)

            Text(track.originalName)
                .font(.system(size: 9))
                .foregroundStyle(DAWTheme.textSecondary)
                .lineLimit(1)
                .frame(maxWidth: channelStripWidth - 8)

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

            if !usesPhoneLayout {
                PanKnobView(
                    pan: Binding(
                        get: { trackPan(for: track.id) },
                        set: { viewModel.setPan(trackID: track.id, pan: $0) }
                    )
                )
            }

            FaderMeterStripView(
                value: trackVolumeBinding(for: track.id),
                level: level,
                isAudible: isAudible,
                faderWidth: channelFaderWidth,
                faderHeight: channelFaderHeight,
                segmentCount: usesPhoneLayout ? 10 : 12,
                dotSize: usesPhoneLayout ? 4 : 5
            )
            .padding(.vertical, usesPhoneLayout ? 2 : 0)
        }
        .frame(width: channelStripWidth)
        .padding(.vertical, usesPhoneLayout ? 8 : 10)
        .padding(.horizontal, usesPhoneLayout ? phoneStripHorizontalPadding : 8)
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

        return VStack(spacing: usesPhoneLayout ? 5 : 8) {
            Text(groupShortName(group.name))
                .font(.caption2.weight(.bold))
                .foregroundStyle(DAWTheme.textPrimary)
                .lineLimit(1)

            Text("Group")
                .font(.system(size: 9))
                .foregroundStyle(DAWTheme.textSecondary)

            if !usesPhoneLayout {
                Spacer(minLength: 22)
            }

            FaderMeterStripView(
                value: groupVolumeBinding(for: group.id),
                level: level,
                isAudible: isAudible,
                faderWidth: channelFaderWidth,
                faderHeight: masterFaderHeight,
                segmentCount: usesPhoneLayout ? 10 : 12,
                dotSize: usesPhoneLayout ? 4 : 5
            )
            .padding(.vertical, usesPhoneLayout ? 2 : 0)
        }
        .frame(width: channelStripWidth)
        .padding(.vertical, usesPhoneLayout ? 8 : 10)
        .padding(.horizontal, usesPhoneLayout ? phoneStripHorizontalPadding : 8)
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

        return VStack(spacing: usesPhoneLayout ? 5 : 8) {
            Text("Main")
                .font(.caption2.weight(.bold))
                .foregroundStyle(DAWTheme.textPrimary)

            Text("Output")
                .font(.system(size: 9))
                .foregroundStyle(DAWTheme.textSecondary)

            if !usesPhoneLayout {
                Spacer(minLength: 22)
            }

            FaderMeterStripView(
                value: masterVolumeBinding,
                level: level,
                isAudible: isAudible,
                faderWidth: usesPhoneLayout ? 30 : (isCompact ? 26 : 30),
                faderHeight: masterFaderHeight,
                valueRange: 0...1,
                segmentCount: usesPhoneLayout ? 10 : 12,
                dotSize: usesPhoneLayout ? 4 : 5
            )
            .padding(.vertical, usesPhoneLayout ? 2 : 0)
        }
        .frame(width: channelStripWidth)
        .padding(.vertical, usesPhoneLayout ? 8 : 10)
        .padding(.horizontal, usesPhoneLayout ? phoneStripHorizontalPadding : 8)
        .background(DAWTheme.accent.opacity(0.08))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay {
            RoundedRectangle(cornerRadius: 12)
                .stroke(DAWTheme.accent.opacity(0.45), lineWidth: 1)
        }
        .padding(.trailing, usesPhoneLayout ? 1 : 0)
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
