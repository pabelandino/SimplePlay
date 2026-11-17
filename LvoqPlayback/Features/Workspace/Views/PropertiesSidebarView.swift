//
//  PropertiesSidebarView.swift
//  LvoqPlayback
//

import SwiftUI

struct PropertiesSidebarView: View {
    @Bindable var viewModel: WorkspaceViewModel
    @Bindable private var language = AppLanguageStore.shared

    private var sectionPresets: [String] { L10n.Section.presets }

    var body: some View {
        ScrollView {
            GlassEffectContainer(spacing: 14) {
                VStack(alignment: .leading, spacing: 14) {
                    languageSettings
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

    @ViewBuilder
    private func lyricSlideLinkSection(for section: ArrangementSection) -> some View {
        SettingsValueRow(
            title: L10n.Lyric.slide,
            value: section.hasLyricSlideLink
                ? viewModel.lyricSlideLabel(for: section, catalog: viewModel.lyricCatalog)
                : L10n.Lyric.notAssigned,
            monospaced: false
        )

        Button(section.hasLyricSlideLink ? L10n.Lyric.change : L10n.Lyric.assign) {
            viewModel.presentLyricLinkSheet(for: section.id)
        }
        .buttonStyle(DAWSecondaryButtonStyle())

        SettingsFootnote(
            text: L10n.Lyric.cardsFootnote
        )
    }

    private var audioSettings: some View {
        SidebarPanel(title: L10n.Audio.output, icon: "speaker.wave.2.fill") {
            SettingsMenuRow(
                title: L10n.Audio.interface,
                options: viewModel.availableOutputDevices.map { ($0.id, $0.name) },
                selection: selectedDeviceID
            )
            .onChange(of: viewModel.project.audioSettings.outputDeviceID) { _, _ in
                viewModel.applyAudioSettings()
            }

            if selectedDevice.outputChannelCount > 2 {
                SettingsMenuRow(
                    title: L10n.Audio.outputPair,
                    options: AudioDeviceService.channelPairOptions(for: selectedDevice).map {
                        ($0, AudioDeviceService.channelPairLabel(pairIndex: $0))
                    },
                    selection: $viewModel.project.audioSettings.outputChannelPair
                )
                .onChange(of: viewModel.project.audioSettings.outputChannelPair) { _, _ in
                    viewModel.applyAudioSettings()
                }
            }

            SettingsMenuRow(
                title: L10n.Audio.sampleRate,
                options: AudioSampleRate.allCases.map { ($0, $0.displayName) },
                selection: $viewModel.project.audioSettings.sampleRate
            )
            .onChange(of: viewModel.project.audioSettings.sampleRate) { _, _ in
                viewModel.applyAudioSettings()
            }

            SettingsFootnote(
                text: L10n.Audio.sampleRateFootnote
            )

            Button(L10n.Audio.refreshDevices) {
                viewModel.refreshAudioDevices()
            }
            .buttonStyle(DAWSecondaryButtonStyle())
            .frame(maxWidth: .infinity)
        }
    }

    private var selectedDevice: AudioOutputDevice {
        AudioDeviceService.device(
            matching: viewModel.project.audioSettings,
            in: viewModel.availableOutputDevices
        ) ?? .systemDefault
    }

    private var selectedDeviceID: Binding<UInt32> {
        Binding(
            get: {
                selectedDevice.id
            },
            set: { newValue in
                if newValue == 0 {
                    viewModel.project.audioSettings.outputDeviceID = nil
                    viewModel.project.audioSettings.outputPortUID = nil
                    viewModel.project.audioSettings.outputDeviceName = AudioOutputDevice.systemDefault.name
                } else if let device = viewModel.availableOutputDevices.first(where: { $0.id == newValue }) {
                    viewModel.project.audioSettings.outputDeviceID = device.id
                    viewModel.project.audioSettings.outputPortUID = device.portUID
                    viewModel.project.audioSettings.outputDeviceName = device.name
                }
            }
        )
    }

    private var trackPitch: some View {
        SidebarPanel(title: L10n.Pitch.title, icon: "tuningfork") {
            if viewModel.project.tracks.isEmpty {
                SettingsFootnote(text: L10n.Pitch.empty)
            } else {
                SettingsFootnote(
                    text: L10n.Pitch.footnote
                )

                if viewModel.project.tracks.count > 1 {
                    SettingsMenuRow(
                        title: L10n.Pitch.track,
                        options: viewModel.project.tracks.map { ($0.id, $0.displayName) },
                        selection: selectedTrackIDBinding
                    )
                } else if let track = viewModel.activePitchTrack {
                    SettingsValueRow(title: L10n.Pitch.track, value: track.displayName)
                }

                HStack {
                    Text(L10n.Pitch.label)
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
                    Text(L10n.Pitch.minusFive)
                    Spacer()
                    Text(L10n.Common.original)
                    Spacer()
                    Text(L10n.Pitch.plusFive)
                }
                .font(.caption2.weight(.medium))
                .foregroundStyle(DAWTheme.textSecondary)

                Button(L10n.Pitch.reset) {
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
        !(viewModel.activePitchTrack?.isPitchEnabled ?? false)
    }

    private var pitchLabel: String {
        guard viewModel.activePitchTrack?.isPitchEnabled == true else {
            return L10n.Pitch.originalOff
        }
        let semitones = viewModel.activePitchTrack?.pitchSemitones ?? 0
        if abs(semitones) < 0.001 { return L10n.Pitch.originalZero }
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
        L10n.Section.creationHintIOS
#else
        L10n.Section.creationHintMac
#endif
    }

    private var sectionEditor: some View {
        SidebarPanel(title: L10n.Section.markers, icon: "flag.fill") {
            SettingsFootnote(text: sectionCreationHint)

            SettingsMenuRow(
                title: L10n.Section.defaultName,
                options: sectionPresets.map { ($0, $0) },
                selection: $viewModel.preferredMarkerPreset
            )
        }
    }

    @ViewBuilder
    private var selectedMarkerEditor: some View {
        if let section = selectedSection {
            SidebarPanel(title: L10n.Section.selectedMarker, icon: "mappin.and.ellipse") {
                SettingsFieldLabel(title: L10n.Section.name) {
                    HStack(spacing: 10) {
                        Circle()
                            .fill(section.color)
                            .frame(width: 10, height: 10)

                        TextField(L10n.Section.markerName, text: selectedSectionNameBinding)
                            .textFieldStyle(.plain)
                            .font(.subheadline)
                            .foregroundStyle(DAWTheme.textPrimary)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 10)
                    .dawSettingsControlGlass()
                }

                SettingsValueRow(
                    title: L10n.Section.padMapping,
                    value: MIDINoteAssignment(
                        note: section.midiNote,
                        channel: section.midiChannel,
                        usesControlChange: section.midiUsesControlChange
                    ).displayName,
                    monospaced: true
                )

                Button(L10n.Section.assignMIDI) {
                    viewModel.startMIDILearn(for: .section(section.id))
                }
                .buttonStyle(DAWSecondaryButtonStyle())

                lyricSlideLinkSection(for: section)

                SettingsFootnote(
                    text: L10n.Section.playFootnote
                )

                SettingsValueRow(
                    title: L10n.Section.range,
                    value: "\(TimeFormatting.format(section.startTime)) – \(TimeFormatting.format(section.endTime))",
                    monospaced: true
                )

                HStack(spacing: 8) {
                    Button(L10n.Common.trigger) {
                        viewModel.triggerSection(section)
                    }
                    .buttonStyle(DAWPrimaryButtonStyle())
                    .frame(maxWidth: .infinity)

                    Button(L10n.Section.deleteMarker, role: .destructive) {
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
        SidebarPanel(title: L10n.Selection.duration, icon: "arrow.left.and.right.square") {
            if let range = viewModel.selectionRange {
                SettingsValueRow(
                    title: L10n.Selection.start,
                    value: TimeFormatting.format(range.lowerBound),
                    monospaced: true
                )
                SettingsValueRow(
                    title: L10n.Selection.end,
                    value: TimeFormatting.format(range.upperBound),
                    monospaced: true
                )

                SettingsToggleRow(title: L10n.Selection.loop, isOn: $viewModel.isSelectionLoopEnabled)
            } else {
                SettingsFootnote(
                    text: L10n.Selection.empty
                )
            }
        }
    }

    private var playbackSettings: some View {
        SidebarPanel(title: L10n.Snap.title, icon: "square.grid.3x3") {
            SettingsToggleRow(title: L10n.Snap.enable, isOn: $viewModel.project.isSnapEnabled)

            SettingsNumberInput(
                title: L10n.Snap.interval,
                value: $viewModel.project.snapInterval
            )
        }
    }

    private var volumeControls: some View {
        SidebarPanel(title: L10n.Audio.soundLevels, icon: "speaker.wave.3.fill") {
            SettingsFieldLabel(title: L10n.Audio.masterVolume) {
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
        SidebarPanel(title: L10n.File.projectSession, icon: "folder.fill") {
            Button(L10n.File.newProjectEllipsis) {
                viewModel.requestNewProject()
            }
            .buttonStyle(DAWSecondaryButtonStyle())

            Button(L10n.File.resetSessionEllipsis, role: .destructive) {
                viewModel.requestResetSession()
            }
            .buttonStyle(DAWSecondaryButtonStyle())

            SettingsFootnote(
                text: L10n.File.sessionFootnote
            )
        }
    }

    private var languageSettings: some View {
        SidebarPanel(title: L10n.Settings.languageSection, icon: "globe") {
            SettingsMenuRow(
                title: L10n.Settings.languageSection,
                options: languageOptions,
                selection: languageSelection
            )
            SettingsFootnote(text: L10n.Settings.languageFooter)
        }
    }

    private var languageOptions: [(String, String)] {
        [("system", L10n.Settings.languageSystem)]
            + AppLocale.allCases.map { ($0.languageCode, L10n.Settings.languageName(for: $0)) }
    }

    private var languageSelection: Binding<String> {
        Binding(
            get: { language.languageCode ?? "system" },
            set: { language.languageCode = $0 == "system" ? nil : $0 }
        )
    }

    private var masterVolumeBinding: Binding<Double> {
        Binding(
            get: { viewModel.project.masterVolume },
            set: { viewModel.setMasterVolume($0) }
        )
    }
}
