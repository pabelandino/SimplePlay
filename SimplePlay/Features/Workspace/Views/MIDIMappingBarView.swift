//
//  MIDIMappingBarView.swift
//  SimplePlay
//

import SwiftUI
#if os(iOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif

struct MIDIMappingBarView: View {
    @Bindable var viewModel: WorkspaceViewModel
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var showsDevicePicker = false

    private var isCompact: Bool {
        horizontalSizeClass == .compact
    }

    private var mappingPanelAnimation: Animation {
        if reduceMotion {
            return .linear(duration: 0.2)
        }
        return .smooth(duration: 0.32, extraBounce: 0.05)
    }

    private var sectionQuickPadCornerRadius: CGFloat {
        isCompact ? 8 : 7
    }

    private var sectionQuickPadMinHeight: CGFloat {
        isCompact ? 46 : 42
    }

    var body: some View {
        VStack(spacing: 0) {
            collapsedBar

            if viewModel.isMIDIMappingAssignModeEnabled || viewModel.isMIDILearnActive {
                expandedPanel
                    .transition(expandedPanelTransition)
            }
        }
        .clipped()
        .animation(mappingPanelAnimation, value: viewModel.isMIDIMappingAssignModeEnabled)
        .animation(mappingPanelAnimation, value: viewModel.isMIDILearnActive)
        .background(DAWTheme.surface)
        .overlay(alignment: .bottom) {
            Rectangle().fill(DAWTheme.border).frame(height: 1)
        }
        .onAppear {
            viewModel.applySavedMIDIDeviceConnection()
        }
#if os(iOS)
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
            viewModel.applySavedMIDIDeviceConnection()
        }
#elseif os(macOS)
        .onReceive(NotificationCenter.default.publisher(for: NSApplication.didBecomeActiveNotification)) { _ in
            viewModel.applySavedMIDIDeviceConnection()
        }
#endif
    }

    private var expandedPanelTransition: AnyTransition {
        if reduceMotion {
            return .opacity
        }

        return .asymmetric(
            insertion: .opacity
                .combined(with: .offset(y: -8))
                .combined(with: .scale(scale: 0.985, anchor: .top)),
            removal: .opacity
                .combined(with: .offset(y: -6))
                .combined(with: .scale(scale: 0.99, anchor: .top))
        )
    }

    private func setMappingExpanded(_ expanded: Bool) {
        viewModel.isMIDIMappingExpanded = expanded
    }

    private var collapsedBar: some View {
        VStack(spacing: isCompact ? 4 : 8) {
            Group {
                if isCompact {
                    ScrollView(.horizontal, showsIndicators: false) {
                        collapsedBarContent
                    }
                } else {
                    collapsedBarContent
                }
            }
            .frame(minHeight: isCompact ? 34 : 44)

            if !viewModel.project.sections.isEmpty,
               !viewModel.isMIDIMappingAssignModeEnabled {
                sectionQuickPads
                    .frame(minHeight: sectionQuickPadMinHeight)
            }
        }
        .padding(.horizontal, isCompact ? 10 : 16)
#if os(macOS)
        .padding(.leading, DAWTheme.macTrafficLightLeadingInset - 16)
#endif
        .padding(.vertical, isCompact ? 4 : 8)
    }

    private var collapsedBarContent: some View {
        HStack(spacing: isCompact ? 8 : 12) {
            Button {
                setMappingExpanded(!viewModel.isMIDIMappingExpanded)
            } label: {
                Label(
                    viewModel.isMIDIMappingExpanded ? "Hide" : "Mapping",
                    systemImage: "pianokeys"
                )
                    .font(isCompact ? .caption.weight(.semibold) : .subheadline.weight(.semibold))
                    .foregroundStyle(DAWTheme.textPrimary)
            }
            .buttonStyle(.plain)

            if !isCompact || viewModel.isMIDIMappingExpanded {
                devicePicker
            }

            if viewModel.isMIDIMappingExpanded {
                mappingRefreshControl
            }

            assignModeToggle

            if viewModel.isMIDILearnActive {
                Label("Assigning…", systemImage: "dot.radiowaves.left.and.right")
                    .font(.caption2.weight(.semibold))
                    .foregroundStyle(DAWTheme.accent)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(DAWTheme.accent.opacity(0.15))
                    .clipShape(Capsule())
            }

            if !isCompact {
                Spacer(minLength: 8)

                if let status = viewModel.midiLearnStatusMessage, !viewModel.isMIDILearnActive {
                    Text(status)
                        .font(.caption2)
                        .foregroundStyle(DAWTheme.textSecondary)
                        .lineLimit(1)
                }
            }

            historyControls
        }
    }

    private var historyControls: some View {
        HStack(spacing: 6) {
            historyButton(
                systemName: "arrow.uturn.backward",
                help: "Undo",
                enabled: viewModel.canUndo
            ) {
                viewModel.undo()
            }

            historyButton(
                systemName: "arrow.uturn.forward",
                help: "Redo",
                enabled: viewModel.canRedo
            ) {
                viewModel.redo()
            }
        }
    }

    @ViewBuilder
    private var mappingRefreshControl: some View {
        Button {
            viewModel.prepareMIDIInput()
        } label: {
            Label("Refresh MIDI", systemImage: "arrow.clockwise")
                .font(isCompact ? .caption.weight(.semibold) : .subheadline.weight(.medium))
        }
        .buttonStyle(DAWSecondaryButtonStyle())
        .help("Refresh MIDI devices")
    }

    private func historyButton(
        systemName: String,
        help: String,
        enabled: Bool,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            Image(systemName: systemName)
                .font(isCompact ? .caption.weight(.semibold) : .body.weight(.medium))
                .foregroundStyle(enabled ? DAWTheme.textPrimary : DAWTheme.textSecondary.opacity(0.45))
                .frame(width: isCompact ? 30 : 34, height: isCompact ? 30 : 34)
                .background(DAWTheme.surfaceElevated.opacity(enabled ? 1 : 0.55))
                .clipShape(RoundedRectangle(cornerRadius: 8))
        }
        .buttonStyle(.plain)
        .disabled(!enabled)
        .help(help)
    }

    private var assignModeToggle: some View {
        Button {
            viewModel.setMIDIMappingAssignModeEnabled(!viewModel.isMIDIMappingAssignModeEnabled)
        } label: {
            Text(assignModeToggleTitle)
                .font(.caption2.weight(.semibold))
                .foregroundStyle(viewModel.isMIDIMappingAssignModeEnabled ? DAWTheme.accent : DAWTheme.textSecondary)
                .padding(.horizontal, 8)
                .padding(.vertical, isCompact ? 3 : 4)
                .background(
                    viewModel.isMIDIMappingAssignModeEnabled
                        ? DAWTheme.accent.opacity(0.14)
                        : DAWTheme.background.opacity(0.45)
                )
                .clipShape(Capsule())
                .overlay {
                    Capsule()
                        .stroke(
                            viewModel.isMIDIMappingAssignModeEnabled ? DAWTheme.accent.opacity(0.5) : DAWTheme.border,
                            lineWidth: 1
                        )
                }
        }
        .buttonStyle(.plain)
        .help(viewModel.isMIDIMappingAssignModeEnabled
            ? "Stop assigning sections"
            : "Assign MIDI pads and Lyriora slides for each section")
    }

    private var assignModeToggleTitle: String {
        if viewModel.isMIDIMappingAssignModeEnabled {
            return "Assigning…"
        }
        return isCompact ? "Assign" : "Assign Sections"
    }

    private var sectionQuickPads: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: isCompact ? 6 : 8) {
                ForEach(viewModel.project.sections) { section in
                    sectionQuickPad(section)
                }
            }
            .padding(.vertical, 1)
        }
    }

    private func sectionQuickPad(_ section: ArrangementSection) -> some View {
        let status = viewModel.sectionPlaybackStatus(for: section)

        return Button {
            viewModel.triggerSection(section)
        } label: {
            HStack(spacing: 6) {
                Image(systemName: statusIcon(for: status))
                    .font(isCompact ? .caption.weight(.bold) : .caption2.weight(.bold))

                Circle()
                    .fill(section.color)
                    .frame(width: isCompact ? 8 : 7, height: isCompact ? 8 : 7)

                Text(section.name)
                    .font(isCompact ? .subheadline.weight(.semibold) : .caption.weight(.semibold))
                    .lineLimit(1)
            }
            .foregroundStyle(statusForeground(for: status))
            .padding(.horizontal, isCompact ? 14 : 12)
            .padding(.vertical, isCompact ? 12 : 10)
            .frame(minHeight: sectionQuickPadMinHeight)
            .background(statusBackground(for: section, status: status))
            .clipShape(RoundedRectangle(cornerRadius: sectionQuickPadCornerRadius, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: sectionQuickPadCornerRadius, style: .continuous)
                    .stroke(statusBorder(for: section, status: status), lineWidth: status == .idle ? 1 : 1.5)
            }
        }
        .buttonStyle(.plain)
        .help(sectionQuickPadHelp(section, status: status))
    }

    @ViewBuilder
    private var devicePicker: some View {
        Button {
            viewModel.prepareMIDIInput()
            showsDevicePicker = true
        } label: {
            devicePickerLabel
        }
        .buttonStyle(.plain)
        .sheet(isPresented: $showsDevicePicker) {
            NavigationStack {
                List {
                    Button {
                        viewModel.selectMIDIDevice(nil)
                        showsDevicePicker = false
                    } label: {
                        HStack {
                            Text("All Inputs")
                            Spacer()
                            if viewModel.project.preferredMIDISourceUniqueID == nil,
                               viewModel.connectedMIDISourceName == "All Inputs" {
                                Image(systemName: "checkmark")
                                    .foregroundStyle(DAWTheme.accent)
                            }
                        }
                    }

                    ForEach(viewModel.availableMIDISources) { source in
                        Button {
                            viewModel.selectMIDIDevice(source)
                            showsDevicePicker = false
                        } label: {
                            HStack {
                                Text(source.name)
                                Spacer()
                                if viewModel.project.preferredMIDISourceUniqueID == source.uniqueID {
                                    Image(systemName: "checkmark")
                                        .foregroundStyle(DAWTheme.accent)
                                }
                            }
                        }
                    }
                }
                .navigationTitle("MIDI Input")
#if os(iOS)
                .navigationBarTitleDisplayMode(.inline)
#endif
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Done") {
                            showsDevicePicker = false
                        }
                    }
                }
            }
#if os(iOS)
            .presentationDetents([.medium, .large])
#endif
#if os(macOS)
            .frame(minWidth: 360, minHeight: 320)
#endif
        }
    }

    private var devicePickerLabel: some View {
        HStack(spacing: 8) {
            Circle()
                .fill(viewModel.connectedMIDISourceName != nil ? Color.green : Color.orange)
                .frame(width: 8, height: 8)

            Text(devicePickerTitle)
                .font(.subheadline.weight(.medium))
                .foregroundStyle(devicePickerTitleColor)
                .lineLimit(1)

            Image(systemName: "chevron.up.chevron.down")
                .font(.caption2.weight(.semibold))
                .foregroundStyle(DAWTheme.textSecondary)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 7)
        .background(DAWTheme.surfaceElevated)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .overlay {
            RoundedRectangle(cornerRadius: 10)
                .stroke(DAWTheme.border, lineWidth: 1)
        }
    }

    private var devicePickerTitle: String {
        viewModel.connectedMIDISourceName ?? "Select Device"
    }

    private var devicePickerTitleColor: Color {
        viewModel.connectedMIDISourceName != nil ? DAWTheme.textPrimary : DAWTheme.accent
    }

    private var expandedPanel: some View {
        VStack(alignment: .leading, spacing: isCompact ? 8 : 12) {
            if viewModel.isMIDILearnActive {
                learnBanner
            }

            if !isCompact {
                Text("Assign a MIDI pad and a Lyriora slide for each section card.")
                    .font(.caption2)
                    .foregroundStyle(DAWTheme.textSecondary)
            }

            if viewModel.isMIDIMappingAssignModeEnabled {
                lyricCatalogStatus
            }

            if viewModel.project.sections.isEmpty {
                Text("Create section markers in the timeline, then assign them here.")
                    .font(.caption2)
                    .foregroundStyle(DAWTheme.textSecondary)
            } else if viewModel.isMIDIMappingAssignModeEnabled {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: isCompact ? 8 : 10) {
                        ForEach(viewModel.project.sections) { section in
                            sectionMappingCard(section)
                        }
                    }
                    .padding(.vertical, 2)
                }
            }
        }
        .padding(.horizontal, isCompact ? 10 : 16)
#if os(macOS)
        .padding(.leading, DAWTheme.macTrafficLightLeadingInset - 16)
#endif
        .padding(.bottom, isCompact ? 8 : 12)
        .task(id: viewModel.isMIDIMappingAssignModeEnabled) {
            guard viewModel.isMIDIMappingAssignModeEnabled else { return }
            await viewModel.refreshLyricCatalog()
        }
    }

    @ViewBuilder
    private var lyricCatalogStatus: some View {
        HStack(spacing: 8) {
            Circle()
                .fill(viewModel.isLyrioraReachable ? Color.green : Color.red)
                .frame(width: 7, height: 7)

            if viewModel.isLoadingLyricCatalog {
                Text("Loading slides from Lyriora…")
            } else if let catalog = viewModel.lyricCatalog {
                Text("\(catalog.slides.count) slides · \(catalog.lyricTitle)")
            } else {
                Text(viewModel.lyricSyncErrorMessage ?? "Lyriora not found on this network")
            }

            Spacer(minLength: 0)

            Button("Refresh") {
                Task { await viewModel.refreshLyricCatalog() }
            }
            .buttonStyle(DAWSecondaryButtonStyle())
            .disabled(viewModel.isLoadingLyricCatalog)
        }
        .font(.caption2)
        .foregroundStyle(DAWTheme.textSecondary)
        .padding(.horizontal, 10)
        .padding(.vertical, 8)
        .background(DAWTheme.background.opacity(0.45))
        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
    }

    @ViewBuilder
    private var learnBanner: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 10) {
                Image(systemName: "hand.tap.fill")
                    .foregroundStyle(DAWTheme.accent)

                Text(viewModel.midiLearnStatusMessage ?? "Press a pad or button on your controller.")
                    .font(.caption)
                    .foregroundStyle(DAWTheme.textPrimary)

                Spacer()

                Button("Cancel") {
                    viewModel.cancelMIDILearn()
                }
                .buttonStyle(DAWSecondaryButtonStyle())
            }

            if let debug = viewModel.lastMIDIInputDebugMessage {
                Text("Last input: \(debug)")
                    .font(.caption2.monospaced())
                    .foregroundStyle(DAWTheme.textSecondary)
            } else {
                Text("Waiting for MIDI… If nothing appears, try All Inputs or refresh.")
                    .font(.caption2)
                    .foregroundStyle(DAWTheme.textSecondary)
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(DAWTheme.accent.opacity(0.12))
                .overlay {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(DAWTheme.accent.opacity(0.45), lineWidth: 1)
                }
        )
    }

    private func sectionMappingCard(_ section: ArrangementSection) -> some View {
        let isLearning = viewModel.midiLearnTarget == .section(section.id)
        let status = viewModel.sectionPlaybackStatus(for: section)
        let assignment = MIDINoteAssignment(
            note: section.midiNote,
            channel: section.midiChannel,
            usesControlChange: section.midiUsesControlChange
        )
        let isPlaying = status == .playing

        return VStack(spacing: 0) {
            Button {
                viewModel.triggerSection(section)
            } label: {
                sectionPlayCardBody(section: section, status: status)
            }
            .buttonStyle(SectionMappingPlayButtonStyle())
            .accessibilityLabel("Play \(section.name)")

            if viewModel.isMIDIMappingAssignModeEnabled {
                Rectangle()
                    .fill(DAWTheme.border.opacity(0.85))
                    .frame(height: 1)

                Button {
                    if isLearning {
                        viewModel.cancelMIDILearn()
                    } else {
                        viewModel.startMIDILearn(for: .section(section.id))
                    }
                } label: {
                    sectionAssignRow(
                        assignment: assignment,
                        isLearning: isLearning
                    )
                }
                .buttonStyle(SectionMappingAssignButtonStyle(isLearning: isLearning))
                .accessibilityLabel(isLearning ? "Listening for MIDI assignment" : "Assign MIDI for \(section.name)")

                Rectangle()
                    .fill(DAWTheme.border.opacity(0.85))
                    .frame(height: 1)

                sectionLyricAssignRow(section)
            }
        }
        .frame(width: isCompact ? 148 : 176)
        .background(cardBackground(for: section, status: status, isLearning: isLearning))
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .stroke(
                    cardBorder(for: section, status: status, isLearning: isLearning),
                    lineWidth: cardBorderWidth(status: status, isLearning: isLearning)
                )
        }
        .modifier(SectionMappingCardGlow(
            isActive: isPlaying,
            color: section.color,
            reduceMotion: reduceMotion
        ))
        .animation(mappingPanelAnimation, value: status)
        .help(sectionQuickPadHelp(section, status: status))
    }

    private func sectionPlayCardBody(
        section: ArrangementSection,
        status: WorkspaceViewModel.SectionPlaybackStatus
    ) -> some View {
        VStack(alignment: .leading, spacing: isCompact ? 6 : 10) {
            HStack(alignment: .center, spacing: 8) {
                RoundedRectangle(cornerRadius: 2, style: .continuous)
                    .fill(section.color)
                    .frame(width: 3, height: isCompact ? 22 : 28)

                VStack(alignment: .leading, spacing: 2) {
                    Text(section.name)
                        .font(isCompact ? .caption.weight(.bold) : .subheadline.weight(.bold))
                        .foregroundStyle(DAWTheme.textPrimary)
                        .lineLimit(1)

                    if !isCompact {
                        Label {
                            Text(sectionTimeRange(section))
                        } icon: {
                            Image(systemName: "clock")
                        }
                        .font(.caption2.monospaced())
                        .foregroundStyle(DAWTheme.textSecondary)
                        .labelStyle(.titleAndIcon)
                    }
                }

                Spacer(minLength: 0)

                sectionPlayGlyph(status: status, accent: section.color)
            }

            if status != .idle, !isCompact {
                HStack(spacing: 5) {
                    Image(systemName: statusIcon(for: status))
                        .font(.caption2.weight(.bold))

                    Text(statusLabel(for: status))
                        .font(.caption2.weight(.bold))
                }
                .foregroundStyle(statusForeground(for: status))
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(statusForeground(for: status).opacity(0.14))
                .clipShape(Capsule())
            }
        }
        .padding(.horizontal, isCompact ? 10 : 12)
        .padding(.vertical, isCompact ? 8 : 12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(sectionPlayAreaBackground(section: section, status: status))
    }

    @ViewBuilder
    private func sectionPlayGlyph(
        status: WorkspaceViewModel.SectionPlaybackStatus,
        accent: Color
    ) -> some View {
        let isPlaying = status == .playing

        ZStack {
            Circle()
                .fill(isPlaying ? accent.opacity(0.22) : DAWTheme.surfaceElevated)
                .frame(width: isCompact ? 28 : 34, height: isCompact ? 28 : 34)

            Circle()
                .stroke(isPlaying ? accent.opacity(0.55) : DAWTheme.border, lineWidth: 1)
                .frame(width: isCompact ? 28 : 34, height: isCompact ? 28 : 34)

            Image(systemName: isPlaying ? "waveform" : "play.fill")
                .font(.system(size: isPlaying ? 13 : 11, weight: .bold))
                .foregroundStyle(isPlaying ? accent : DAWTheme.textPrimary.opacity(0.9))
                .symbolEffect(.variableColor.iterative.reversing, options: .repeating, isActive: isPlaying && !reduceMotion)
        }
    }

    private func sectionPlayAreaBackground(
        section: ArrangementSection,
        status: WorkspaceViewModel.SectionPlaybackStatus
    ) -> some View {
        Group {
            switch status {
            case .idle:
                DAWTheme.background.opacity(0.35)
            case .playing:
                LinearGradient(
                    colors: [
                        section.color.opacity(0.06),
                        section.color.opacity(0.2)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            case .queued:
                LinearGradient(
                    colors: [
                        DAWTheme.accent.opacity(0.05),
                        DAWTheme.accent.opacity(0.14)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            case .repeatingAtEnd:
                LinearGradient(
                    colors: [
                        section.color.opacity(0.04),
                        section.color.opacity(0.14)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            }
        }
    }

    private func sectionAssignRow(
        assignment: MIDINoteAssignment,
        isLearning: Bool
    ) -> some View {
        HStack(spacing: 6) {
            Image(systemName: isLearning ? "dot.radiowaves.left.and.right" : "pianokeys")
                .font(.caption2.weight(.semibold))
                .foregroundStyle(isLearning ? DAWTheme.accent : DAWTheme.textSecondary)

            Text(isLearning ? "Listening…" : assignment.displayName)
                .font(.caption2.weight(.medium))
                .foregroundStyle(isLearning ? DAWTheme.accent : DAWTheme.textSecondary)
                .lineLimit(1)

            Spacer(minLength: 0)

            if !isLearning {
                Text("MIDI")
                    .font(.caption2.weight(.semibold))
                    .foregroundStyle(DAWTheme.textPrimary.opacity(0.85))
            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 9)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(isLearning ? DAWTheme.accent.opacity(0.1) : DAWTheme.background.opacity(0.45))
    }

    @ViewBuilder
    private func sectionLyricAssignRow(_ section: ArrangementSection) -> some View {
        if let catalog = viewModel.lyricCatalog {
            Menu {
                ForEach(catalog.slides) { slide in
                    Button {
                        viewModel.assignLyricSlide(
                            sectionID: section.id,
                            slide: slide,
                            catalog: catalog
                        )
                    } label: {
                        Text(lyricSlideMenuTitle(slide))
                    }
                }

                if section.hasLyricSlideLink {
                    Divider()
                    Button("Clear Slide Link", role: .destructive) {
                        viewModel.clearLyricSlideLink(for: section.id)
                    }
                }
            } label: {
                sectionLyricAssignLabel(section)
            }
            .buttonStyle(SectionMappingAssignButtonStyle(isLearning: false))
        } else {
            sectionLyricAssignLabel(section)
                .opacity(0.72)
        }
    }

    private func sectionLyricAssignLabel(_ section: ArrangementSection) -> some View {
        HStack(spacing: 6) {
            Image(systemName: "text.below.photo")
                .font(.caption2.weight(.semibold))
                .foregroundStyle(section.hasLyricSlideLink ? DAWTheme.playhead : DAWTheme.textSecondary)

            Text(viewModel.lyricSlideLabel(for: section, catalog: viewModel.lyricCatalog))
                .font(.caption2.weight(.medium))
                .foregroundStyle(section.hasLyricSlideLink ? DAWTheme.textPrimary : DAWTheme.textSecondary)
                .lineLimit(1)

            Spacer(minLength: 0)

            if viewModel.isLoadingLyricCatalog {
                ProgressView()
                    .controlSize(.small)
            } else if viewModel.lyricCatalog != nil {
                Text(section.hasLyricSlideLink ? "Change" : "Slide")
                    .font(.caption2.weight(.semibold))
                    .foregroundStyle(DAWTheme.textPrimary.opacity(0.85))
            } else {
                Image(systemName: "wifi.exclamationmark")
                    .font(.caption2.weight(.semibold))
                    .foregroundStyle(.red.opacity(0.85))
            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 9)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(DAWTheme.background.opacity(0.45))
    }

    private func lyricSlideMenuTitle(_ slide: LyricSlideCatalogItem) -> String {
        let preview = slide.preview.trimmingCharacters(in: .whitespacesAndNewlines)
        if preview.isEmpty {
            return "Slide \(slide.order + 1)"
        }
        return "Slide \(slide.order + 1) · \(preview)"
    }

    private func sectionTimeRange(_ section: ArrangementSection) -> String {
        "\(TimeFormatting.format(section.startTime)) – \(TimeFormatting.format(section.endTime))"
    }

    private func statusIcon(for status: WorkspaceViewModel.SectionPlaybackStatus) -> String {
        switch status {
        case .idle: "play.fill"
        case .playing: "speaker.wave.2.fill"
        case .queued: "arrow.right.to.line"
        case .repeatingAtEnd: "repeat.1"
        }
    }

    private func statusLabel(for status: WorkspaceViewModel.SectionPlaybackStatus) -> String {
        switch status {
        case .idle: ""
        case .playing: "Playing"
        case .queued: "Queued"
        case .repeatingAtEnd: "Repeat"
        }
    }

    private func statusForeground(for status: WorkspaceViewModel.SectionPlaybackStatus) -> Color {
        switch status {
        case .idle: DAWTheme.textPrimary
        case .playing: DAWTheme.playhead
        case .queued: DAWTheme.accent
        case .repeatingAtEnd: DAWTheme.accent
        }
    }

    private func statusBackground(for section: ArrangementSection, status: WorkspaceViewModel.SectionPlaybackStatus) -> Color {
        switch status {
        case .idle: DAWTheme.background.opacity(0.75)
        case .playing: section.color.opacity(0.22)
        case .queued: DAWTheme.accent.opacity(0.14)
        case .repeatingAtEnd: section.color.opacity(0.18)
        }
    }

    private func statusBorder(for section: ArrangementSection, status: WorkspaceViewModel.SectionPlaybackStatus) -> Color {
        switch status {
        case .idle: DAWTheme.border
        case .playing: section.color
        case .queued: DAWTheme.accent
        case .repeatingAtEnd: section.color.opacity(0.85)
        }
    }

    private func cardBackground(for section: ArrangementSection, status: WorkspaceViewModel.SectionPlaybackStatus, isLearning: Bool) -> Color {
        if isLearning { return section.color.opacity(0.14) }
        return statusBackground(for: section, status: status)
    }

    private func cardBorder(for section: ArrangementSection, status: WorkspaceViewModel.SectionPlaybackStatus, isLearning: Bool) -> Color {
        if isLearning { return section.color }
        return statusBorder(for: section, status: status)
    }

    private func cardBorderWidth(status: WorkspaceViewModel.SectionPlaybackStatus, isLearning: Bool) -> CGFloat {
        if isLearning { return 2 }
        return status == .idle ? 1 : 1.5
    }

    private func sectionQuickPadHelp(_ section: ArrangementSection, status: WorkspaceViewModel.SectionPlaybackStatus) -> String {
        let assignment = MIDINoteAssignment(
            note: section.midiNote,
            channel: section.midiChannel,
            usesControlChange: section.midiUsesControlChange
        ).displayName

        switch status {
        case .idle:
            var details = "Play “\(section.name)” · MIDI: \(assignment)"
            if section.hasLyricSlideLink {
                details += " · \(viewModel.lyricSlideLabel(for: section, catalog: viewModel.lyricCatalog))"
            }
            return details
        case .playing:
            return "“\(section.name)” is playing · tap again to repeat once"
        case .queued:
            return "“\(section.name)” queued for section end"
        case .repeatingAtEnd:
            return "“\(section.name)” will repeat at section end"
        }
    }
}

// MARK: - Section mapping card styles

private struct SectionMappingPlayButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .contentShape(Rectangle())
            .scaleEffect(configuration.isPressed ? 0.985 : 1)
            .opacity(configuration.isPressed ? 0.94 : 1)
            .animation(.easeOut(duration: 0.12), value: configuration.isPressed)
    }
}

private struct SectionMappingAssignButtonStyle: ButtonStyle {
    let isLearning: Bool

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .contentShape(Rectangle())
            .background(
                configuration.isPressed
                    ? (isLearning ? DAWTheme.accent.opacity(0.16) : DAWTheme.surfaceElevated.opacity(0.55))
                    : Color.clear
            )
    }
}

private struct SectionMappingCardGlow: ViewModifier {
    let isActive: Bool
    let color: Color
    let reduceMotion: Bool

    func body(content: Content) -> some View {
        if isActive, !reduceMotion {
            TimelineView(.animation(minimumInterval: 1.0 / 30, paused: false)) { context in
                let phase = (sin(context.date.timeIntervalSinceReferenceDate * 2.4) + 1) / 2
                let outerOpacity = 0.28 + phase * 0.32
                let innerRadius: CGFloat = 6 + phase * 8

                content
                    .shadow(color: color.opacity(outerOpacity), radius: innerRadius, x: 0, y: 0)
                    .shadow(color: color.opacity(outerOpacity * 0.55), radius: 2, x: 0, y: 0)
            }
        } else if isActive {
            content
                .shadow(color: color.opacity(0.45), radius: 10, x: 0, y: 0)
                .shadow(color: color.opacity(0.25), radius: 3, x: 0, y: 0)
        } else {
            content
        }
    }
}
