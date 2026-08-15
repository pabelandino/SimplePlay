//
//  iPhoneMIDIMappingBarView.swift
//  SimplePlay
//

import SwiftUI

/// Compact MIDI mapping bar for iPhone. Assign mode opens a sheet instead of covering the timeline.
struct iPhoneMIDIMappingBarView: View {
    @Bindable var viewModel: WorkspaceViewModel
    @State private var showsDevicePicker = false

    var body: some View {
        VStack(spacing: 0) {
            collapsedBar

            if !viewModel.project.sections.isEmpty,
               !viewModel.isMIDIMappingAssignModeEnabled {
                sectionQuickPads
            }
        }
        .frame(minHeight: DAWTheme.phoneMappingBarHeight)
        .background(DAWTheme.surface)
        .overlay(alignment: .bottom) {
            Rectangle().fill(DAWTheme.border).frame(height: 1)
        }
        .sheet(isPresented: $viewModel.isPhoneSectionAssignSheetPresented) {
            SectionAssignSheetView(viewModel: viewModel)
        }
        .onAppear {
            viewModel.applySavedMIDIDeviceConnection()
        }
        .onChange(of: viewModel.isPhoneSectionAssignSheetPresented) { _, isPresented in
            if !isPresented, viewModel.isMIDIMappingAssignModeEnabled {
                viewModel.isMIDIMappingAssignModeEnabled = false
                viewModel.isMIDIMappingExpanded = false
                viewModel.cancelMIDILearn()
            }
        }
    }

    private var collapsedBar: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                Button {
                    viewModel.isMIDIMappingExpanded.toggle()
                } label: {
                    Label(
                        viewModel.isMIDIMappingExpanded ? "Hide" : "Mapping",
                        systemImage: "pianokeys"
                    )
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(DAWTheme.textPrimary)
                }
                .buttonStyle(.plain)

                if viewModel.isMIDIMappingExpanded {
                    devicePickerButton
                }

                assignButton

                historyControls
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
        }
    }

    private var devicePickerButton: some View {
        Button {
            viewModel.prepareMIDIInput()
            showsDevicePicker = true
        } label: {
            HStack(spacing: 6) {
                Circle()
                    .fill(viewModel.connectedMIDISourceName != nil ? Color.green : Color.orange)
                    .frame(width: 7, height: 7)
                Text(viewModel.connectedMIDISourceName ?? "Device")
                    .font(.caption.weight(.medium))
                    .lineLimit(1)
            }
            .foregroundStyle(DAWTheme.textPrimary)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(DAWTheme.surfaceElevated)
            .clipShape(Capsule())
        }
        .buttonStyle(.plain)
        .sheet(isPresented: $showsDevicePicker) {
            phoneDevicePickerSheet
        }
    }

    private var assignButton: some View {
        Button {
            viewModel.setMIDIMappingAssignModeEnabled(!viewModel.isMIDIMappingAssignModeEnabled)
        } label: {
            Text(viewModel.isMIDIMappingAssignModeEnabled ? "Assigning…" : "Assign")
                .font(.caption2.weight(.semibold))
                .foregroundStyle(viewModel.isMIDIMappingAssignModeEnabled ? DAWTheme.accent : DAWTheme.textSecondary)
                .padding(.horizontal, 10)
                .padding(.vertical, 4)
                .background(
                    viewModel.isMIDIMappingAssignModeEnabled
                        ? DAWTheme.accent.opacity(0.14)
                        : DAWTheme.background.opacity(0.45)
                )
                .clipShape(Capsule())
                .overlay {
                    Capsule().stroke(
                        viewModel.isMIDIMappingAssignModeEnabled ? DAWTheme.accent.opacity(0.5) : DAWTheme.border,
                        lineWidth: 1
                    )
                }
        }
        .buttonStyle(.plain)
    }

    private var historyControls: some View {
        HStack(spacing: 4) {
            historyButton("arrow.uturn.backward", enabled: viewModel.canUndo) {
                viewModel.undo()
            }
            historyButton("arrow.uturn.forward", enabled: viewModel.canRedo) {
                viewModel.redo()
            }
        }
    }

    private var sectionQuickPads: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 6) {
                ForEach(viewModel.project.sections) { section in
                    sectionQuickPad(section)
                }
            }
            .padding(.horizontal, 10)
            .padding(.bottom, 6)
        }
    }

    private func sectionQuickPad(_ section: ArrangementSection) -> some View {
        let status = viewModel.sectionPlaybackStatus(for: section)

        return Button {
            viewModel.triggerSection(section)
        } label: {
            HStack(spacing: 5) {
                Image(systemName: sectionQuickPadIcon(for: status))
                    .font(.caption2.weight(.bold))
                Circle().fill(section.color).frame(width: 7, height: 7)
                Text(section.name)
                    .font(.caption.weight(.semibold))
                    .lineLimit(1)
            }
            .foregroundStyle(sectionQuickPadForeground(for: status))
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(sectionQuickPadBackground(for: status))
            .clipShape(Capsule())
            .overlay {
                Capsule().stroke(sectionQuickPadBorder(for: status), lineWidth: status == .playing ? 1.5 : 1)
            }
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Play \(section.name)")
    }

    private func sectionQuickPadIcon(for status: WorkspaceViewModel.SectionPlaybackStatus) -> String {
        switch status {
        case .idle: "play.fill"
        case .playing: "speaker.wave.2.fill"
        case .queued: "arrow.right.to.line"
        case .repeatingAtEnd: "repeat.1"
        }
    }

    private func sectionQuickPadForeground(for status: WorkspaceViewModel.SectionPlaybackStatus) -> Color {
        switch status {
        case .idle: DAWTheme.textPrimary
        case .playing: DAWTheme.playhead
        case .queued, .repeatingAtEnd: DAWTheme.accent
        }
    }

    private func sectionQuickPadBackground(for status: WorkspaceViewModel.SectionPlaybackStatus) -> Color {
        switch status {
        case .idle: DAWTheme.surfaceElevated
        case .playing: DAWTheme.playhead.opacity(0.14)
        case .queued, .repeatingAtEnd: DAWTheme.accent.opacity(0.12)
        }
    }

    private func sectionQuickPadBorder(for status: WorkspaceViewModel.SectionPlaybackStatus) -> Color {
        switch status {
        case .idle: DAWTheme.border
        case .playing: DAWTheme.playhead.opacity(0.6)
        case .queued, .repeatingAtEnd: DAWTheme.accent.opacity(0.55)
        }
    }

    private func historyButton(
        _ systemName: String,
        enabled: Bool,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            Image(systemName: systemName)
                .font(.caption.weight(.semibold))
                .foregroundStyle(enabled ? DAWTheme.textSecondary : DAWTheme.textSecondary.opacity(0.35))
                .frame(width: 28, height: 28)
                .background(DAWTheme.background.opacity(0.55))
                .clipShape(RoundedRectangle(cornerRadius: 6))
        }
        .buttonStyle(.plain)
        .disabled(!enabled)
    }

    private var phoneDevicePickerSheet: some View {
        NavigationStack {
            List {
                Button("All Inputs") {
                    viewModel.selectMIDIDevice(nil)
                    showsDevicePicker = false
                }
                ForEach(viewModel.availableMIDISources) { source in
                    Button(source.name) {
                        viewModel.selectMIDIDevice(source)
                        showsDevicePicker = false
                    }
                }
            }
            .navigationTitle("MIDI Input")
#if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
#endif
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") { showsDevicePicker = false }
                }
            }
        }
        .presentationDetents([.medium])
    }
}
