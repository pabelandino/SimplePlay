//
//  SingleLaneTimelineViews.swift
//  SimplePlay
//

import SwiftUI

/// Shared single-lane timeline: all stems stacked in one compact row.
enum SingleLaneTimelineViews {
    static func rowHeight(isPhone: Bool) -> CGFloat {
        isPhone ? DAWTheme.phoneSingleLaneRowHeight : DAWTheme.singleLaneRowHeight
    }
}

struct SingleLaneTrackHeaderCell: View {
    @Bindable var viewModel: WorkspaceViewModel
    let width: CGFloat
    let rowHeight: CGFloat
    let isPhone: Bool
    let showsAllTracks: Bool
    let onToggle: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 6) {
                Image(systemName: "square.stack.3d.up.fill")
                    .font(.system(size: isPhone ? 12 : 14, weight: .semibold))
                    .foregroundStyle(DAWTheme.textSecondary)

                VStack(alignment: .leading, spacing: 2) {
                    Text("All Stems")
                        .font(.system(size: isPhone ? 11 : 12, weight: .bold))
                        .foregroundStyle(DAWTheme.textPrimary)

                    Text("\(viewModel.project.tracks.count) tracks")
                        .font(.system(size: isPhone ? 9 : 10, weight: .medium))
                        .foregroundStyle(DAWTheme.textSecondary)
                }

                Spacer(minLength: 0)
            }

            Button(action: onToggle) {
                HStack(spacing: 4) {
                    Image(systemName: showsAllTracks
                        ? "rectangle.compress.vertical"
                        : "rectangle.expand.vertical")
                    Text(showsAllTracks ? "Stack" : "Expand")
                        .font(.system(size: isPhone ? 10 : 11, weight: .semibold))
                }
                .foregroundStyle(showsAllTracks ? DAWTheme.accent : DAWTheme.textSecondary)
                .frame(maxWidth: .infinity)
                .frame(height: isPhone ? DAWTheme.phoneTrackControlSize : 30)
                .background(
                    (showsAllTracks ? DAWTheme.accent.opacity(0.12) : DAWTheme.background.opacity(0.55))
                )
                .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
            }
            .buttonStyle(.plain)
            .accessibilityLabel(showsAllTracks ? "Stack stems into one lane" : "Expand all track lanes")
        }
        .padding(.horizontal, isPhone ? 8 : 12)
        .padding(.vertical, isPhone ? 8 : 10)
        .frame(width: width, height: rowHeight, alignment: .topLeading)
        .background(DAWTheme.surface.opacity(0.95))
        .overlay(alignment: .trailing) {
            Rectangle().fill(DAWTheme.border).frame(width: 1)
        }
        .overlay(alignment: .bottom) {
            Rectangle().fill(DAWTheme.border).frame(height: 1)
        }
    }
}

struct SingleLaneStackedClipsLane: View {
    @Bindable var viewModel: WorkspaceViewModel
    let contentWidth: CGFloat
    let rowHeight: CGFloat

    var body: some View {
        let tracks = viewModel.project.tracks
        let count = max(tracks.count, 1)
        let stripHeight = max(5, (rowHeight - CGFloat(count - 1)) / CGFloat(count))

        VStack(spacing: 1) {
            if tracks.isEmpty {
                Color.clear.frame(height: rowHeight)
            } else {
                ForEach(tracks) { track in
                    singleTrackStrip(track: track, stripHeight: stripHeight)
                }
            }
        }
        .frame(width: contentWidth, height: rowHeight, alignment: .topLeading)
        .clipped()
        .overlay(alignment: .bottom) {
            Rectangle().fill(DAWTheme.border).frame(height: 1)
        }
    }

    @ViewBuilder
    private func singleTrackStrip(track: AudioTrack, stripHeight: CGFloat) -> some View {
        let liveTrack = viewModel.project.tracks.first(where: { $0.id == track.id }) ?? track
        let color = viewModel.project.displayColor(for: liveTrack)

        Color.clear
            .frame(width: contentWidth, height: stripHeight)
            .overlay(alignment: .leading) {
                ForEach(liveTrack.clips) { clip in
                    let width = max(3, CGFloat(clip.duration) * viewModel.pixelsPerSecond)
                    RoundedRectangle(cornerRadius: 2, style: .continuous)
                        .fill(color.opacity(liveTrack.isMuted ? 0.25 : 0.78))
                        .frame(width: width, height: max(3, stripHeight - 2))
                        .offset(x: CGFloat(clip.startTime) * viewModel.pixelsPerSecond)
                }
            }
            .clipped()
    }
}

struct SingleLaneMarkerHeaderCell: View {
    let width: CGFloat
    let height: CGFloat
    let isPhone: Bool
    let showsAllTracks: Bool
    let onToggle: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: isPhone ? 4 : 6) {
            HStack(spacing: 4) {
                Image(systemName: "flag.fill")
                    .font(.system(size: 10, weight: .semibold))
                    .foregroundStyle(DAWTheme.textSecondary)
                Text("Sections")
                    .font(.system(size: 10, weight: .semibold))
                    .foregroundStyle(DAWTheme.textPrimary)
                Spacer(minLength: 0)
            }

            Button(action: onToggle) {
                HStack(spacing: 4) {
                    Image(systemName: showsAllTracks
                        ? "rectangle.compress.vertical"
                        : "rectangle.expand.vertical")
                    Text(showsAllTracks ? "Stack" : "Expand")
                        .font(.system(size: 10, weight: .semibold))
                }
                .foregroundStyle(DAWTheme.textSecondary)
                .frame(maxWidth: .infinity)
                .frame(height: isPhone ? DAWTheme.phoneTrackControlSize : 28)
                .background(DAWTheme.background.opacity(0.55))
                .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, isPhone ? 8 : 12)
        .padding(.vertical, isPhone ? 6 : 8)
        .frame(width: width, height: height)
        .background(DAWTheme.surface.opacity(0.95))
        .overlay(alignment: .trailing) {
            Rectangle().fill(DAWTheme.border).frame(width: 1)
        }
    }
}
