//
//  PropertiesSidebarView.swift
//  SimplePlay
//

import SwiftUI

struct PropertiesSidebarView: View {
    @Bindable var viewModel: WorkspaceViewModel
    @State private var newSectionName = "Verse"
    @State private var sectionMode: SectionPlaybackMode = .repeatSection

    private let sectionPresets = ["Verse", "Verse 1", "Verse 2", "Pre-Chorus", "Chorus", "Bridge", "Outro"]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                audioSettings
                sectionEditor
                selectionInfo
                playbackSettings
                volumeControls
                arrangementList
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
                        Text(device.name).tag(Optional(device.id == 0 ? nil : device.id))
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

    private var selectedDeviceID: Binding<UInt32?> {
        Binding(
            get: { viewModel.project.audioSettings.outputDeviceID },
            set: { newValue in
                viewModel.project.audioSettings.outputDeviceID = newValue
                if let id = newValue,
                   let device = viewModel.availableOutputDevices.first(where: { $0.id == id }) {
                    viewModel.project.audioSettings.outputDeviceName = device.name
                } else {
                    viewModel.project.audioSettings.outputDeviceName = AudioOutputDevice.systemDefault.name
                }
            }
        )
    }

    private var sectionEditor: some View {
        SidebarPanel(title: "Arrangement Sections") {
            Text("Drag horizontally on the timeline to select a time range for MIDI sections.")
                .font(.caption)
                .foregroundStyle(DAWTheme.textSecondary)
                .fixedSize(horizontal: false, vertical: true)

            SidebarLabeledRow(title: "Section") {
                Picker("Section", selection: $newSectionName) {
                    ForEach(sectionPresets, id: \.self) { preset in
                        Text(preset).tag(preset)
                    }
                }
                .labelsHidden()
                .pickerStyle(.menu)
                .frame(maxWidth: .infinity, alignment: .leading)
            }

            SidebarLabeledRow(title: "Playback Mode") {
                Picker("Mode", selection: $sectionMode) {
                    ForEach(SectionPlaybackMode.allCases) { mode in
                        Text(mode.displayName).tag(mode)
                    }
                }
                .labelsHidden()
                .pickerStyle(.menu)
                .frame(maxWidth: .infinity, alignment: .leading)
            }

            Button("Assign Selection to Section") {
                if let range = viewModel.selectionRange {
                    viewModel.addSection(name: newSectionName, range: range, mode: sectionMode)
                    viewModel.selectionRange = nil
                }
            }
            .buttonStyle(DAWPrimaryButtonStyle())
            .frame(maxWidth: .infinity)
            .disabled(viewModel.selectionRange == nil)
        }
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
            } else {
                Text("Drag horizontally on the timeline to select a range.")
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
                Slider(value: $viewModel.project.masterVolume, in: 0...1)
            }
            .onChange(of: viewModel.project.masterVolume) { _, newValue in
                viewModel.audioEngine.masterVolume = newValue
            }
        }
    }

    private var arrangementList: some View {
        SidebarPanel(title: "MIDI Sections") {
            if viewModel.project.sections.isEmpty {
                Text("No sections yet.")
                    .font(.caption)
                    .foregroundStyle(DAWTheme.textSecondary)
            } else {
                VStack(spacing: 10) {
                    ForEach(viewModel.project.sections) { section in
                        HStack(alignment: .top, spacing: 10) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(section.name)
                                    .font(.subheadline.weight(.medium))
                                Text("Note \(section.midiNote) · \(section.playbackMode.displayName)")
                                    .font(.caption2)
                                    .foregroundStyle(DAWTheme.textSecondary)
                            }
                            Spacer(minLength: 8)
                            Button("Trigger") {
                                viewModel.triggerSection(section)
                            }
                            .buttonStyle(DAWSecondaryButtonStyle())
                        }
                    }
                }
            }
        }
    }
}
