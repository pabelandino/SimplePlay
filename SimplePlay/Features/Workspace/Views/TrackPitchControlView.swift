//
//  TrackPitchControlView.swift
//  SimplePlay
//

import SwiftUI

struct TrackPitchControlView: View {
    @Bindable var viewModel: WorkspaceViewModel
    var compact = false

    var body: some View {
        Group {
            if compact {
                pitchMenu
                    .buttonStyle(DAWIconToolbarButtonStyle())
            } else {
                pitchMenu
                    .buttonStyle(DAWSecondaryButtonStyle())
            }
        }
    }

    private var pitchMenu: some View {
        Menu {
            if viewModel.project.tracks.isEmpty {
                Text("Import tracks to adjust pitch.")
            } else {
                if viewModel.project.tracks.count > 1 {
                    Picker("Track", selection: selectedTrackIDBinding) {
                        ForEach(viewModel.project.tracks) { track in
                            Text(track.displayName).tag(track.id)
                        }
                    }
                } else if let track = viewModel.activePitchTrack {
                    Text(track.displayName)
                }

                Text(pitchLabel)
                    .font(.caption.monospaced())

                Slider(
                    value: selectedTrackPitchBinding,
                    in: PitchShiftSettings.minSemitones...PitchShiftSettings.maxSemitones,
                    step: 0.5
                )

                Button("Reset to Original") {
                    viewModel.resetSelectedTrackPitch()
                }
                .disabled(pitchIsOriginal)
            }
        } label: {
            if compact {
                Image(systemName: "tuningfork")
            } else {
                HStack(spacing: 5) {
                    Image(systemName: "tuningfork")
                    Text(menuTitle)
                        .font(.caption.weight(.semibold))
                }
            }
        }
        .disabled(viewModel.project.tracks.isEmpty)
        .accessibilityLabel(compact ? "Pitch" : menuTitle)
        .help("Track pitch shift")
    }

    private var menuTitle: String {
        if pitchIsOriginal {
            return "Pitch"
        }
        return pitchShortLabel
    }

    private var pitchShortLabel: String {
        let semitones = viewModel.activePitchTrack?.pitchSemitones ?? 0
        if semitones > 0 {
            return String(format: "+%.1f st", semitones)
        }
        return String(format: "%.1f st", semitones)
    }

    private var pitchLabel: String {
        let semitones = viewModel.activePitchTrack?.pitchSemitones ?? 0
        if abs(semitones) < 0.001 { return "Original (0 st)" }
        if semitones > 0 { return String(format: "+%.1f semitones", semitones) }
        return String(format: "%.1f semitones", semitones)
    }

    private var pitchIsOriginal: Bool {
        abs(viewModel.activePitchTrack?.pitchSemitones ?? 0) < 0.001
    }

    private var selectedTrackIDBinding: Binding<UUID> {
        Binding(
            get: {
                if let selected = viewModel.selectedTrackIDForPitch,
                   viewModel.project.tracks.contains(where: { $0.id == selected }) {
                    return selected
                }
                return viewModel.activePitchTrack?.id ?? viewModel.project.tracks[0].id
            },
            set: { viewModel.selectedTrackIDForPitch = $0 }
        )
    }

    private var selectedTrackPitchBinding: Binding<Double> {
        Binding(
            get: { viewModel.activePitchTrack?.pitchSemitones ?? 0 },
            set: { viewModel.setSelectedTrackPitch($0) }
        )
    }
}
