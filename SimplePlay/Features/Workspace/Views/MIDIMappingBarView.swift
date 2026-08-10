//
//  MIDIMappingBarView.swift
//  SimplePlay
//

import SwiftUI
#if os(iOS)
import UIKit
#endif

struct MIDIMappingBarView: View {
    @Bindable var viewModel: WorkspaceViewModel
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
#if os(iOS)
    @State private var showsDevicePicker = false
#endif

    private var isCompact: Bool {
        horizontalSizeClass == .compact
    }

    private var mappingPanelAnimation: Animation {
        if reduceMotion {
            return .linear(duration: 0.2)
        }
        return .smooth(duration: 0.32, extraBounce: 0.05)
    }

    var body: some View {
        VStack(spacing: 0) {
            collapsedBar

            if viewModel.isMIDIMappingExpanded {
                expandedPanel
                    .transition(expandedPanelTransition)
            }
        }
        .clipped()
        .animation(mappingPanelAnimation, value: viewModel.isMIDIMappingExpanded)
        .background(DAWTheme.surface)
        .overlay(alignment: .bottom) {
            Rectangle().fill(DAWTheme.border).frame(height: 1)
        }
        .onAppear {
            viewModel.applySavedMIDIDeviceConnection()
            if !viewModel.project.sections.isEmpty {
                setMappingExpanded(true)
            }
        }
        .onChange(of: viewModel.project.sections.count) { _, count in
            if count > 0 {
                setMappingExpanded(true)
            }
        }
#if os(iOS)
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
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
        Group {
            if isCompact {
                ScrollView(.horizontal, showsIndicators: false) {
                    collapsedBarContent
                }
            } else {
                collapsedBarContent
            }
        }
        .frame(minHeight: 44)
        .padding(.horizontal, isCompact ? 12 : 16)
#if os(macOS)
        .padding(.leading, DAWTheme.macTrafficLightLeadingInset - 16)
#endif
        .padding(.vertical, 8)
    }

    private var collapsedBarContent: some View {
        HStack(spacing: 12) {
            Button {
                setMappingExpanded(!viewModel.isMIDIMappingExpanded)
            } label: {
                Label(
                    viewModel.isMIDIMappingExpanded ? "Hide Mapping" : "Show Mapping",
                    systemImage: "pianokeys"
                )
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(DAWTheme.textPrimary)
            }
            .buttonStyle(.plain)

            devicePicker

            if viewModel.isMIDILearnActive {
                Label("Assigning…", systemImage: "dot.radiowaves.left.and.right")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(DAWTheme.accent)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(DAWTheme.accent.opacity(0.15))
                    .clipShape(Capsule())
            }

            loopQuickButton

            if !isCompact {
                Spacer(minLength: 8)

                if let status = viewModel.midiLearnStatusMessage, !viewModel.isMIDILearnActive {
                    Text(status)
                        .font(.caption2)
                        .foregroundStyle(DAWTheme.textSecondary)
                        .lineLimit(1)
                }
            }

            Button {
                viewModel.prepareMIDIInput()
            } label: {
                Image(systemName: "arrow.clockwise")
            }
            .buttonStyle(DAWSecondaryButtonStyle())
            .help("Refresh MIDI devices")
        }
    }

    @ViewBuilder
    private var devicePicker: some View {
#if os(iOS)
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
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Done") {
                            showsDevicePicker = false
                        }
                    }
                }
            }
            .presentationDetents([.medium, .large])
        }
#else
        Menu {
            Button("All Inputs") {
                viewModel.selectMIDIDevice(nil)
            }

            if !viewModel.availableMIDISources.isEmpty {
                Divider()
                ForEach(viewModel.availableMIDISources) { source in
                    Button(source.name) {
                        viewModel.selectMIDIDevice(source)
                    }
                }
            }
        } label: {
            devicePickerLabel
        }
        .buttonStyle(.plain)
#endif
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

    private var loopQuickButton: some View {
        let isLearning = viewModel.midiLearnTarget == .loopToggle

        return Button {
            setMappingExpanded(true)
        } label: {
            HStack(spacing: 6) {
                Image(systemName: viewModel.isSectionRepeatEnabled ? "repeat.circle.fill" : "repeat.circle")
                Text(isLearning ? "Listening…" : "Loop")
                    .font(.caption.weight(.semibold))
            }
            .foregroundStyle(isLearning ? DAWTheme.accent : DAWTheme.textPrimary)
            .padding(.horizontal, 10)
            .padding(.vertical, 7)
            .background(isLearning ? DAWTheme.accent.opacity(0.15) : DAWTheme.surfaceElevated)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .overlay {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(isLearning ? DAWTheme.accent : DAWTheme.border, lineWidth: 1)
            }
        }
        .buttonStyle(.plain)
        .help(viewModel.project.sectionRepeatMIDIMapped
            ? "Loop toggle · \(loopAssignmentLabel)"
            : "Open MIDI mapping to assign Loop toggle")
    }

    private var loopAssignmentLabel: String {
        MIDINoteAssignment(
            note: viewModel.project.sectionRepeatMIDINote,
            channel: viewModel.project.sectionRepeatMIDIChannel
        ).displayName
    }

    private var expandedPanel: some View {
        VStack(alignment: .leading, spacing: 12) {
            if viewModel.isMIDILearnActive {
                learnBanner
            }

            Text("Tap Assign on a section, then press a pad. While playing, another pad queues a jump at the section end. Press the same section pad again during playback to repeat that section once.")
                .font(.caption2)
                .foregroundStyle(DAWTheme.textSecondary)

            loopMappingCard

            if viewModel.project.sections.isEmpty {
                Text("Create section markers in the timeline, then assign each one to a pad.")
                    .font(.caption)
                    .foregroundStyle(DAWTheme.textSecondary)
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(viewModel.project.sections) { section in
                            sectionMappingCard(section)
                        }
                    }
                    .padding(.vertical, 2)
                }
            }
        }
        .padding(.horizontal, isCompact ? 12 : 16)
#if os(macOS)
        .padding(.leading, DAWTheme.macTrafficLightLeadingInset - 16)
#endif
        .padding(.bottom, 12)
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

    private var loopMappingCard: some View {
        let isLearning = viewModel.midiLearnTarget == .loopToggle
        let isMapped = viewModel.project.sectionRepeatMIDIMapped
        let assignment = MIDINoteAssignment(
            note: viewModel.project.sectionRepeatMIDINote,
            channel: viewModel.project.sectionRepeatMIDIChannel
        )

        return HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Label("Loop Toggle", systemImage: "repeat.circle.fill")
                    .font(.caption.weight(.semibold))

                Text(isMapped ? assignment.displayName : "Not assigned")
                    .font(.caption2.monospaced())
                    .foregroundStyle(DAWTheme.textSecondary)

                Text("Assign a dedicated controller button here. Until then, section pads never toggle Loop.")
                    .font(.caption2)
                    .foregroundStyle(DAWTheme.textSecondary)
            }

            Spacer(minLength: 8)

            Button(isLearning ? "Listening…" : "Assign Button") {
                if isLearning {
                    viewModel.cancelMIDILearn()
                } else {
                    viewModel.startMIDILearn(for: .loopToggle)
                }
            }
            .buttonStyle(DAWSecondaryButtonStyle())
        }
        .padding(10)
        .background(isLearning ? DAWTheme.accent.opacity(0.12) : DAWTheme.background.opacity(0.55))
        .overlay {
            RoundedRectangle(cornerRadius: 10)
                .stroke(isLearning ? DAWTheme.accent : DAWTheme.border, lineWidth: isLearning ? 2 : 1)
        }
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }

    private func sectionMappingCard(_ section: ArrangementSection) -> some View {
        let isLearning = viewModel.midiLearnTarget == .section(section.id)
        let assignment = MIDINoteAssignment(
            note: section.midiNote,
            channel: section.midiChannel,
            usesControlChange: section.midiUsesControlChange
        )

        return VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 6) {
                Circle()
                    .fill(section.color)
                    .frame(width: 8, height: 8)

                Text(section.name)
                    .font(.caption.weight(.semibold))
                    .lineLimit(1)
            }

            Text(assignment.displayName)
                .font(.caption2.monospaced())
                .foregroundStyle(DAWTheme.textSecondary)

            Button(isLearning ? "Listening…" : "Assign") {
                if isLearning {
                    viewModel.cancelMIDILearn()
                } else {
                    viewModel.startMIDILearn(for: .section(section.id))
                }
            }
            .buttonStyle(DAWSecondaryButtonStyle())
        }
        .foregroundStyle(DAWTheme.textPrimary)
        .padding(10)
        .frame(width: 132, alignment: .leading)
        .background(isLearning ? section.color.opacity(0.14) : DAWTheme.background.opacity(0.55))
        .overlay {
            RoundedRectangle(cornerRadius: 10)
                .stroke(isLearning ? section.color : DAWTheme.border, lineWidth: isLearning ? 2 : 1)
        }
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}
