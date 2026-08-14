//
//  TransportRightToolbar.swift
//  SimplePlay
//

import SwiftUI

/// Shared icon button styling for transport-bar utility controls.
struct TransportToolbarButton: View {
    let systemName: String
    var isActive: Bool = false
    var size: CGFloat
    var cornerRadius: CGFloat = 8
    let accessibilityLabel: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: systemName)
                .font(size >= 40 ? .body.weight(.semibold) : (size >= 34 ? .body.weight(.semibold) : .caption.weight(.semibold)))
                .foregroundStyle(isActive ? DAWTheme.accent : DAWTheme.textPrimary)
                .frame(width: size, height: size)
                .background {
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(isActive ? DAWTheme.accent.opacity(0.15) : DAWTheme.background.opacity(0.55))
                }
        }
        .buttonStyle(.plain)
        .accessibilityLabel(accessibilityLabel)
    }
}

/// Right-side transport utilities: master volume, mixer, and timeline scale.
struct TransportRightToolbar: View {
    @Bindable var viewModel: WorkspaceViewModel
    var isCompact: Bool
    var usesPhoneDock: Bool

    @State private var activePanel: Panel = .none

    private enum Panel {
        case none
        case mainVolume
        case timelineScale
    }

    private var buttonSize: CGFloat {
        usesPhoneDock ? 40 : (isCompact ? 30 : 34)
    }

    private var buttonCornerRadius: CGFloat {
        usesPhoneDock ? 10 : 8
    }

    private var timelineScaleExpanded: Binding<Bool> {
        Binding(
            get: { activePanel == .timelineScale },
            set: { isExpanded in
                withAnimation(.easeInOut(duration: 0.18)) {
                    activePanel = isExpanded ? .timelineScale : .none
                }
            }
        )
    }

    var body: some View {
        HStack(spacing: usesPhoneDock ? 6 : 8) {
            if activePanel == .mainVolume {
                mainVolumePanel
                    .transition(.move(edge: .trailing).combined(with: .opacity))
            }

            if activePanel == .timelineScale {
                TimelineScaleControls(
                    viewModel: viewModel,
                    isCompact: isCompact,
                    usesPhoneDock: usesPhoneDock,
                    isExpanded: .constant(true),
                    showsPanel: true,
                    showsToggleButton: false
                )
                .transition(.move(edge: .trailing).combined(with: .opacity))
            }

            HStack(spacing: usesPhoneDock ? 4 : 6) {
                TransportToolbarButton(
                    systemName: mainVolumeIconName,
                    isActive: activePanel == .mainVolume,
                    size: buttonSize,
                    cornerRadius: buttonCornerRadius,
                    accessibilityLabel: activePanel == .mainVolume ? "Hide main volume" : "Show main volume"
                ) {
                    togglePanel(.mainVolume)
                }

                TransportToolbarButton(
                    systemName: "square.stack.3d.up.fill",
                    isActive: viewModel.showMixerPanel,
                    size: buttonSize,
                    cornerRadius: buttonCornerRadius,
                    accessibilityLabel: "Mixer"
                ) {
                    withAnimation(.easeInOut(duration: 0.22)) {
                        viewModel.showMixerPanel.toggle()
                    }
                }

                TimelineScaleControls(
                    viewModel: viewModel,
                    isCompact: isCompact,
                    usesPhoneDock: usesPhoneDock,
                    isExpanded: timelineScaleExpanded,
                    showsPanel: false,
                    showsToggleButton: true
                )
            }
        }
        .animation(.easeInOut(duration: 0.18), value: activePanel)
        .padding(.horizontal, usesPhoneDock ? 8 : (isCompact ? 8 : 10))
        .padding(.vertical, usesPhoneDock ? 4 : (isCompact ? 6 : 8))
        .background(DAWTheme.surfaceElevated)
        .clipShape(RoundedRectangle(cornerRadius: usesPhoneDock ? 12 : 10))
        .overlay {
            RoundedRectangle(cornerRadius: usesPhoneDock ? 12 : 10)
                .stroke(DAWTheme.border, lineWidth: 1)
        }
    }

    private var mainVolumeIconName: String {
        if activePanel == .mainVolume { return "xmark" }
        if viewModel.project.masterVolume <= 0.001 { return "speaker.slash.fill" }
        if viewModel.project.masterVolume < 0.45 { return "speaker.wave.1.fill" }
        return "speaker.wave.2.fill"
    }

    private var mainVolumePanel: some View {
        HStack(spacing: 8) {
            FaderMeterStripView(
                value: masterVolumeBinding,
                level: viewModel.masterMeterLevel,
                isAudible: viewModel.isPlaying,
                faderWidth: isCompact ? 14 : 16,
                faderHeight: isCompact ? 44 : 52,
                valueRange: 0...1,
                segmentCount: 8,
                dotSize: 3
            )

            Text("\(Int((viewModel.project.masterVolume * 100).rounded()))%")
                .font(.system(size: 9, weight: .semibold, design: .monospaced))
                .foregroundStyle(DAWTheme.textSecondary)
                .frame(minWidth: 28)
        }
        .padding(.horizontal, isCompact ? 8 : 10)
        .padding(.vertical, isCompact ? 6 : 8)
        .background(DAWTheme.background.opacity(0.55))
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .overlay {
            RoundedRectangle(cornerRadius: 8)
                .stroke(DAWTheme.border, lineWidth: 1)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Main volume \(Int((viewModel.project.masterVolume * 100).rounded())) percent")
    }

    private var masterVolumeBinding: Binding<Double> {
        Binding(
            get: { viewModel.project.masterVolume },
            set: { viewModel.setMasterVolume($0) }
        )
    }

    private func togglePanel(_ panel: Panel) {
        withAnimation(.easeInOut(duration: 0.18)) {
            if activePanel == panel {
                activePanel = .none
            } else {
                activePanel = panel
            }
        }
    }
}
