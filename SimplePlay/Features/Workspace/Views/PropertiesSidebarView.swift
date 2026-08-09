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
            VStack(alignment: .leading, spacing: 16) {
                audioSettings
                trackPitch
                sectionEditor
                selectedMarkerEditor
                selectionInfo
                playbackSettings
                volumeControls
                sessionManagement
            }
            .padding(16)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(DAWTheme.surface)
    }

    private var audioSettings: some View {
        SidebarPanel(title: "Audio Output") {
            SidebarLabeledRow(title: "Interface") {
                Picker("Interface", selection: selectedDeviceID) {
                    ForEach(viewModel.availableOutputDevices) { device in
                        Text(device.name).tag(device.id)
                    }
                }
                .labelsHidden()
                .pickerStyle(.menu)
            }

            if selectedDevice.outputChannelCount > 2 {
                SidebarLabeledRow(title: "Output Pair") {
                    Picker("Output Pair", selection: $viewModel.project.audioSettings.outputChannelPair) {
                        ForEach(AudioDeviceService.channelPairOptions(for: selectedDevice), id: \.self) { pair in
                            Text(AudioDeviceService.channelPairLabel(pairIndex: pair)).tag(pair)
                        }
                    }
                    .labelsHidden()
                    .pickerStyle(.menu)
                }
            }

            SidebarLabeledRow(title: "Sample Rate") {
                Picker("Sample Rate", selection: $viewModel.project.audioSettings.sampleRate) {
                    ForEach(AudioSampleRate.allCases) { rate in
                        Text(rate.displayName).tag(rate)
                    }
                }
                .labelsHidden()
                .pickerStyle(.menu)
            }

            Button("Apply Audio Settings") {
                viewModel.applyAudioSettings()
            }
            .buttonStyle(DAWSecondaryButtonStyle())

            Button("Refresh Devices") {
                viewModel.refreshAudioDevices()
            }
            .buttonStyle(DAWSecondaryButtonStyle())
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
        SidebarPanel(title: "Track Pitch") {
            if viewModel.project.tracks.isEmpty {
                Text("Import tracks to adjust pitch per lane without changing speed.")
                    .font(.caption)
                    .foregroundStyle(DAWTheme.textSecondary)
            } else {
                Text("Shift pitch for one track at a time. Original files are unchanged — set to 0 to restore.")
                    .font(.caption)
                    .foregroundStyle(DAWTheme.textSecondary)
                    .fixedSize(horizontal: false, vertical: true)

                if viewModel.project.tracks.count > 1 {
                    SidebarLabeledRow(title: "Track") {
                        Picker("Track", selection: selectedTrackIDBinding) {
                            ForEach(viewModel.project.tracks) { track in
                                Text(track.displayName).tag(track.id)
                            }
                        }
                        .labelsHidden()
                        .pickerStyle(.menu)
                    }
                } else if let track = viewModel.activePitchTrack {
                    LabeledContent("Track") {
                        Text(track.displayName)
                            .foregroundStyle(DAWTheme.textSecondary)
                    }
                }

                SidebarLabeledRow(title: "Pitch") {
                    Text(pitchLabel)
                        .font(.system(.body, design: .monospaced))
                        .foregroundStyle(pitchIsOriginal ? DAWTheme.textSecondary : DAWTheme.accent)
                }

                Slider(
                    value: selectedTrackPitchBinding,
                    in: PitchShiftSettings.minSemitones...PitchShiftSettings.maxSemitones,
                    step: 0.5
                )

                HStack {
                    Text("-5 st")
                    Spacer()
                    Text("Original")
                    Spacer()
                    Text("+5 st")
                }
                .font(.caption2)
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
        SidebarPanel(title: "Section Markers") {
            Text(sectionCreationHint)
                .font(.caption)
                .foregroundStyle(DAWTheme.textSecondary)
                .fixedSize(horizontal: false, vertical: true)

            SidebarLabeledRow(title: "Default Name") {
                Picker("Default Name", selection: $viewModel.preferredMarkerPreset) {
                    ForEach(sectionPresets, id: \.self) { preset in
                        Text(preset).tag(preset)
                    }
                }
                .labelsHidden()
                .pickerStyle(.menu)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }

    @ViewBuilder
    private var selectedMarkerEditor: some View {
        if let section = selectedSection {
            SidebarPanel(title: "Selected Marker") {
                HStack(spacing: 10) {
                    Circle()
                        .fill(section.color)
                        .frame(width: 12, height: 12)
                    TextField("Marker name", text: selectedSectionNameBinding)
                        .textFieldStyle(.roundedBorder)
                }

                LabeledContent("Pad Mapping") {
                    Text(MIDINoteAssignment(note: section.midiNote, channel: section.midiChannel).displayName)
                        .font(.system(.caption, design: .monospaced))
                        .foregroundStyle(DAWTheme.textSecondary)
                }

                Text("Use the MIDI Controller panel above the timeline to assign pads.")
                    .font(.caption2)
                    .foregroundStyle(DAWTheme.textSecondary)

                LabeledContent("Range") {
                    Text("\(TimeFormatting.format(section.startTime)) – \(TimeFormatting.format(section.endTime))")
                        .font(.system(.caption, design: .monospaced))
                        .foregroundStyle(DAWTheme.textSecondary)
                }

                HStack(spacing: 8) {
                    Button("Trigger") {
                        viewModel.triggerSection(section)
                    }
                    .buttonStyle(DAWPrimaryButtonStyle())
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
        SidebarPanel(title: "Selection Duration") {
            if let range = viewModel.selectionRange {
                LabeledContent("Start") {
                    Text(TimeFormatting.format(range.lowerBound))
                        .font(.system(.body, design: .monospaced))
                }
                LabeledContent("End") {
                    Text(TimeFormatting.format(range.upperBound))
                        .font(.system(.body, design: .monospaced))
                }

                Toggle("Loop Selection", isOn: $viewModel.isSelectionLoopEnabled)
            } else {
                Text("Use the arrow tool and drag horizontally on the timeline to select a range.")
                    .font(.caption)
                    .foregroundStyle(DAWTheme.textSecondary)
            }
        }
    }

    private var playbackSettings: some View {
        SidebarPanel(title: "Snap Grid") {
            Toggle("Enable Snap", isOn: $viewModel.project.isSnapEnabled)

            SidebarLabeledRow(title: "Interval (seconds)") {
                TextField("Interval", value: $viewModel.project.snapInterval, format: .number)
                    .textFieldStyle(.roundedBorder)
            }
        }
    }

    private var volumeControls: some View {
        SidebarPanel(title: "Sound Levels") {
            SidebarLabeledRow(title: "Master Volume") {
                DAWVerticalFaderView(
                    value: masterVolumeBinding,
                    accentColor: DAWTheme.faderFill,
                    width: 32,
                    height: 140,
                    showsValueLabel: false
                )
            }
        }
    }

    private var sessionManagement: some View {
        SidebarPanel(title: "Project Session") {
            Button("New Project…") {
                viewModel.requestNewProject()
            }
            .buttonStyle(DAWSecondaryButtonStyle())

            Button("Reset Session…", role: .destructive) {
                viewModel.requestResetSession()
            }
            .buttonStyle(DAWSecondaryButtonStyle())

            Text("New Project can save your current work before starting blank. Reset Session clears everything immediately after confirmation.")
                .font(.caption)
                .foregroundStyle(DAWTheme.textSecondary)
        }
    }

    private var masterVolumeBinding: Binding<Double> {
        Binding(
            get: { viewModel.project.masterVolume },
            set: { viewModel.setMasterVolume($0) }
        )
    }
}
