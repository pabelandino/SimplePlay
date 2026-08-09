//
//  MIDIMappingBarView.swift
//  SimplePlay
//

import SwiftUI

struct MIDIMappingBarView: View {
    @Bindable var viewModel: WorkspaceViewModel
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    private var isCompact: Bool {
        horizontalSizeClass == .compact
    }

    var body: some View {
        VStack(spacing: 0) {
            collapsedBar

            if viewModel.isMIDIMappingExpanded {
                expandedPanel
            }
        }
        .background(DAWTheme.surface)
        .overlay(alignment: .bottom) {
            Rectangle().fill(DAWTheme.border).frame(height: 1)
        }
        .onAppear {
            viewModel.refreshMIDIDevices()
        }
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
                withAnimation(.easeInOut(duration: 0.2)) {
                    viewModel.isMIDIMappingExpanded.toggle()
                }
            } label: {
                Label("MIDI", systemImage: "pianokeys")
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
                viewModel.refreshMIDIDevices()
            } label: {
                Image(systemName: "arrow.clockwise")
            }
            .buttonStyle(DAWSecondaryButtonStyle())
            .help("Refresh MIDI devices")
        }
    }

    private var devicePicker: some View {
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
        .buttonStyle(.plain)
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
            if isLearning {
                viewModel.cancelMIDILearn()
            } else {
                viewModel.startMIDILearn(for: .loopToggle)
            }
        } label: {
            HStack(spacing: 6) {
                Image(systemName: "repeat.circle.fill")
                Text("Loop")
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
        .help("Assign Loop Repeat button")
    }

    private var expandedPanel: some View {
        VStack(alignment: .leading, spacing: 12) {
            if viewModel.isMIDILearnActive {
                learnBanner
            }

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
        let assignment = MIDINoteAssignment(note: section.midiNote, channel: section.midiChannel)

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
