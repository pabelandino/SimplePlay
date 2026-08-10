//
//  PropertiesSidebarView.swift
//  SimplePlay
//

import SwiftUI

struct PropertiesSidebarView: View {
    @Bindable var viewModel: WorkspaceViewModel

    private let sectionPresets = ["Verse", "Verse 1", "Verse 2", "Pre-Chorus", "Chorus", "Bridge", "Outro"]

    var body: some View {
        ScrollView {
            GlassEffectContainer(spacing: 14) {
                VStack(alignment: .leading, spacing: 14) {
                    audioSettings
                    trackPitch
                    sectionEditor
                    selectedMarkerEditor
                    selectionInfo
                    playbackSettings
                    volumeControls
                    sessionManagement
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
        }
        .scrollContentBackground(.hidden)
        .background(.clear)
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var audioSettings: some View {
        SidebarPanel(title: "Audio Output", icon: "speaker.wave.2.fill") {
            SettingsMenuRow(
                title: "Interface",
                options: viewModel.availableOutputDevices.map { ($0.id, $0.name) },
                selection: selectedDeviceID
            )

            if selectedDevice.outputChannelCount > 2 {
                SettingsMenuRow(
                    title: "Output Pair",
                    options: AudioDeviceService.channelPairOptions(for: selectedDevice).map {
                        ($0, AudioDeviceService.channelPairLabel(pairIndex: $0))
                    },
                    selection: $viewModel.project.audioSettings.outputChannelPair
                )
            }

            SettingsMenuRow(
                title: "Sample Rate",
                options: AudioSampleRate.allCases.map { ($0, $0.displayName) },
                selection: $viewModel.project.audioSettings.sampleRate
            )

            HStack(spacing: 8) {
                Button("Apply Audio Settings") {
                    viewModel.applyAudioSettings()
                }
                .buttonStyle(DAWPrimaryButtonStyle())
                .frame(maxWidth: .infinity)

                Button("Refresh Devices") {
                    viewModel.refreshAudioDevices()
                }
                .buttonStyle(DAWSecondaryButtonStyle())
                .frame(maxWidth: .infinity)
            }
        }
    }

    private var selectedDevice: AudioOutputDevice {
        if let deviceID = viewModel.project.audioSettings.outputDeviceID,
           let device = viewModel.availableOutputDevices.first(where: { $0.id == deviceID }) {
            return device
        }
        return .systemDefault
    }

    private var selectedDeviceID: Binding<UInt32> {
        Binding(
            get: {
                let stored = viewModel.project.audioSettings.outputDeviceID ?? 0
                if viewModel.availableOutputDevices.contains(where: { $0.id == stored }) {
                    return stored
                }
                return 0
            },
            set: { newValue in
                viewModel.project.audioSettings.outputDeviceID = newValue == 0 ? nil : newValue
                if newValue == 0 {
                    viewModel.project.audioSettings.outputDeviceName = AudioOutputDevice.systemDefault.name
                } else if let device = viewModel.availableOutputDevices.first(where: { $0.id == newValue }) {
                    viewModel.project.audioSettings.outputDeviceName = device.name
                }
            }
        )
    }

    private var trackPitch: some View {
        SidebarPanel(title: "Track Pitch", icon: "tuningfork") {
            if viewModel.project.tracks.isEmpty {
                SettingsFootnote(text: "Import tracks to adjust pitch per lane without changing speed.")
            } else {
                SettingsFootnote(
                    text: "Shift pitch for one track at a time. Original files are unchanged — set to 0 to restore."
                )

                if viewModel.project.tracks.count > 1 {
                    SettingsMenuRow(
                        title: "Track",
                        options: viewModel.project.tracks.map { ($0.id, $0.displayName) },
                        selection: selectedTrackIDBinding
                    )
                } else if let track = viewModel.activePitchTrack {
                    SettingsValueRow(title: "Track", value: track.displayName)
                }

                HStack {
                    Text("Pitch")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(DAWTheme.textSecondary)
                    Spacer(minLength: 8)
                    SettingsBadge(text: pitchLabel, isHighlighted: !pitchIsOriginal)
                }

                Slider(
                    value: selectedTrackPitchBinding,
                    in: PitchShiftSettings.minSemitones...PitchShiftSettings.maxSemitones,
                    step: 0.5
                )
                .tint(DAWTheme.accent)

                HStack {
                    Text("-5 st")
                    Spacer()
                    Text("Original")
                    Spacer()
                    Text("+5 st")
                }
                .font(.caption2.weight(.medium))
                .foregroundStyle(DAWTheme.textSecondary)

                Button("Reset to Original") {
                    viewModel.resetSelectedTrackPitch()
                }
                .buttonStyle(DAWSecondaryButtonStyle())
                .disabled(pitchIsOriginal)
            }
        }
    }

    private var selectedTrackIDBinding: Binding<UUID> {
        Binding(
            get: {
                if let selected = viewModel.selectedTrackIDForPitch,
                   viewModel.project.tracks.contains(where: { $0.id == selected }) {
                    return selected
                }
                if let active = viewModel.activePitchTrack?.id {
                    return active
                }
                return viewModel.project.tracks[0].id
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

    private var pitchIsOriginal: Bool {
        abs(viewModel.activePitchTrack?.pitchSemitones ?? 0) < 0.001
    }

    private var pitchLabel: String {
        let semitones = viewModel.activePitchTrack?.pitchSemitones ?? 0
        if abs(semitones) < 0.001 { return "Original (0 st)" }
        let sign = semitones > 0 ? "+" : ""
        return "\(sign)\(String(format: "%.1f", semitones)) st"
    }

    private var selectedSection: ArrangementSection? {
        if let selectedID = viewModel.selectedSectionID,
           let section = viewModel.project.sections.first(where: { $0.id == selectedID }) {
            return section
        }
        return viewModel.project.sections.first
    }

    private var sectionCreationHint: String {
#if os(iOS)
        "In the Sections lane, tap and drag horizontally to create a marker. Tap a marker to delete it."
#else
        "In the Sections lane, drag horizontally to create a marker. Tap a marker to delete it."
#endif
    }

    private var sectionEditor: some View {
        SidebarPanel(title: "Section Markers", icon: "flag.fill") {
            SettingsFootnote(text: sectionCreationHint)

            SettingsMenuRow(
                title: "Default Name",
                options: sectionPresets.map { ($0, $0) },
                selection: $viewModel.preferredMarkerPreset
            )
        }
    }

    @ViewBuilder
    private var selectedMarkerEditor: some View {
        if let section = selectedSection {
            SidebarPanel(title: "Selected Marker", icon: "mappin.and.ellipse") {
                SettingsFieldLabel(title: "Name") {
                    HStack(spacing: 10) {
                        Circle()
                            .fill(section.color)
                            .frame(width: 10, height: 10)

                        TextField("Marker name", text: selectedSectionNameBinding)
                            .textFieldStyle(.plain)
                            .font(.subheadline)
                            .foregroundStyle(DAWTheme.textPrimary)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 10)
                    .dawSettingsControlGlass()
                }

                SettingsValueRow(
                    title: "Pad Mapping",
                    value: MIDINoteAssignment(
                        note: section.midiNote,
                        channel: section.midiChannel,
                        usesControlChange: section.midiUsesControlChange
                    ).displayName,
                    monospaced: true
                )

                Button("Assign Pad") {
                    viewModel.startMIDILearn(for: .section(section.id))
                }
                .buttonStyle(DAWSecondaryButtonStyle())

                SettingsFootnote(
                    text: "While playing, another pad queues a jump at the current section end. Press the same section pad again during playback to repeat it once."
                )

                SettingsValueRow(
                    title: "Range",
                    value: "\(TimeFormatting.format(section.startTime)) – \(TimeFormatting.format(section.endTime))",
                    monospaced: true
                )

                HStack(spacing: 8) {
                    Button("Trigger") {
                        viewModel.triggerSection(section)
                    }
                    .buttonStyle(DAWPrimaryButtonStyle())
                    .frame(maxWidth: .infinity)

                    Button("Delete Marker", role: .destructive) {
                        viewModel.requestDeleteSection(section.id)
                    }
                    .buttonStyle(DAWSecondaryButtonStyle())
                    .frame(maxWidth: .infinity)
                }
            }
        }
    }

    private var selectedSectionNameBinding: Binding<String> {
        Binding(
            get: { selectedSection?.name ?? "" },
            set: { newValue in
                guard let section = selectedSection else { return }
                viewModel.renameSection(section.id, name: newValue)
            }
        )
    }

    private var selectionInfo: some View {
        SidebarPanel(title: "Selection Duration", icon: "arrow.left.and.right.square") {
            if let range = viewModel.selectionRange {
                SettingsValueRow(
                    title: "Start",
                    value: TimeFormatting.format(range.lowerBound),
                    monospaced: true
                )
                SettingsValueRow(
                    title: "End",
                    value: TimeFormatting.format(range.upperBound),
                    monospaced: true
                )

                SettingsToggleRow(title: "Loop Selection", isOn: $viewModel.isSelectionLoopEnabled)
            } else {
                SettingsFootnote(
                    text: "Use the arrow tool and drag horizontally on the timeline to select a range."
                )
            }
        }
    }

    private var playbackSettings: some View {
        SidebarPanel(title: "Snap Grid", icon: "square.grid.3x3") {
            SettingsToggleRow(title: "Enable Snap", isOn: $viewModel.project.isSnapEnabled)

            SettingsNumberInput(
                title: "Interval (seconds)",
                value: $viewModel.project.snapInterval
            )
        }
    }

    private var volumeControls: some View {
        SidebarPanel(title: "Sound Levels", icon: "speaker.wave.3.fill") {
            SettingsFieldLabel(title: "Master Volume") {
                HStack {
                    Spacer(minLength: 0)
                    DAWVerticalFaderView(
                        value: masterVolumeBinding,
                        accentColor: DAWTheme.faderFill,
                        width: 32,
                        height: 140,
                        showsValueLabel: false
                    )
                    Spacer(minLength: 0)
                }
            }
        }
    }

    private var sessionManagement: some View {
        SidebarPanel(title: "Project Session", icon: "folder.fill") {
            Button("New Project…") {
                viewModel.requestNewProject()
            }
            .buttonStyle(DAWSecondaryButtonStyle())

            Button("Reset Session…", role: .destructive) {
                viewModel.requestResetSession()
            }
            .buttonStyle(DAWSecondaryButtonStyle())

            SettingsFootnote(
                text: "New Project can save your current work before starting blank. Reset Session clears everything immediately after confirmation."
            )
        }
    }

    private var masterVolumeBinding: Binding<Double> {
        Binding(
            get: { viewModel.project.masterVolume },
            set: { viewModel.setMasterVolume($0) }
        )
    }
}
