//
//  TransportBarView.swift
//  SimplePlay
//

import SwiftUI

enum TransportBarStyle {
    case standard
    case phoneBottomDock
}

struct TransportBarView: View {
    @Bindable var viewModel: WorkspaceViewModel
    var style: TransportBarStyle = .standard
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.workspaceLayout) private var workspaceLayout

    private var isCompact: Bool {
        horizontalSizeClass == .compact || workspaceLayout.usesWrappedLayout
    }

    private var usesPhoneDock: Bool {
        style == .phoneBottomDock
    }

    private var phoneTapTarget: CGFloat { 44 }
    private var phoneSecondaryTapTarget: CGFloat { 40 }

    var body: some View {
        Group {
            if usesPhoneDock {
                phoneBottomDock
            } else {
                standardTransportBar
            }
        }
        .background(DAWTheme.surface)
        .overlay(alignment: .top) {
            Rectangle()
                .fill(DAWTheme.border)
                .frame(height: 1)
        }
    }

    private var standardTransportBar: some View {
        VStack(spacing: isCompact ? 6 : 8) {
            TimelineOverviewBar(viewModel: viewModel)
                .padding(.top, isCompact ? 6 : 8)

            HStack(spacing: isCompact ? 8 : 12) {
                timeDisplay
                Spacer(minLength: 4)
                transportControls
                Spacer(minLength: 4)
                TransportRightToolbar(
                    viewModel: viewModel,
                    isCompact: isCompact,
                    usesPhoneDock: false
                )
            }
            .padding(.horizontal, isCompact ? 12 : 16)
            .padding(.bottom, isCompact ? 8 : 10)
        }
    }

    private var phoneBottomDock: some View {
        VStack(spacing: 4) {
            TimelineOverviewBar(viewModel: viewModel, isPhoneDock: true)

            HStack(spacing: 8) {
                phoneTimeDisplay

                transportControls
                    .layoutPriority(1)

                phoneRightControls
            }
            .padding(.horizontal, 10)
            .padding(.bottom, 6)
        }
    }

    private var phoneRightControls: some View {
        TransportRightToolbar(
            viewModel: viewModel,
            isCompact: true,
            usesPhoneDock: true
        )
    }

    private var phoneTimeDisplay: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(viewModel.formattedCurrentTime)
                .font(.system(.caption, design: .monospaced).weight(.semibold))
                .foregroundStyle(DAWTheme.textPrimary)

            Text(viewModel.formattedDuration)
                .font(.system(.caption2, design: .monospaced))
                .foregroundStyle(DAWTheme.textSecondary)
        }
        .frame(minWidth: 58, alignment: .leading)
        .padding(.horizontal, 8)
        .padding(.vertical, 6)
        .background(DAWTheme.surfaceElevated)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay {
            RoundedRectangle(cornerRadius: 12)
                .stroke(DAWTheme.border, lineWidth: 1)
        }
    }

    private var timeDisplay: some View {
        HStack(spacing: 6) {
            VStack(alignment: .leading, spacing: 0) {
                Text(viewModel.formattedCurrentTime)
                    .font(.system(isCompact ? .caption : .body, design: .monospaced).weight(.semibold))
                    .foregroundStyle(DAWTheme.textPrimary)

                Text("of \(viewModel.formattedDuration)")
                    .font(.system(.caption2, design: .monospaced))
                    .foregroundStyle(DAWTheme.textSecondary)
            }

            if !isCompact {
                Divider()
                    .frame(height: 28)
                    .overlay(DAWTheme.border)

                HStack(spacing: 8) {
                    transportIconButton(
                        "arrow.uturn.backward",
                        help: "Undo",
                        enabled: viewModel.canUndo
                    ) {
                        viewModel.undo()
                    }
                    transportIconButton(
                        "arrow.uturn.forward",
                        help: "Redo",
                        enabled: viewModel.canRedo
                    ) {
                        viewModel.redo()
                    }
                }
            }
        }
        .padding(.horizontal, isCompact ? 10 : 12)
        .padding(.vertical, isCompact ? 6 : 8)
        .background(DAWTheme.surfaceElevated)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .overlay {
            RoundedRectangle(cornerRadius: 10)
                .stroke(DAWTheme.border, lineWidth: 1)
        }
    }

    private func transportIconButton(
        _ systemName: String,
        help: String,
        enabled: Bool = true,
        action: @escaping () -> Void = {}
    ) -> some View {
        Button(action: action) {
            Image(systemName: systemName)
                .font(.caption.weight(.semibold))
                .foregroundStyle(enabled ? DAWTheme.textSecondary : DAWTheme.textSecondary.opacity(0.45))
                .frame(width: 28, height: 28)
                .background(DAWTheme.background.opacity(enabled ? 0.55 : 0.35))
                .clipShape(RoundedRectangle(cornerRadius: 6))
        }
        .buttonStyle(.plain)
        .disabled(!enabled)
        .help(help)
    }

    private var transportControls: some View {
        HStack(spacing: usesPhoneDock ? 10 : (isCompact ? 8 : 12)) {
            transportCircleButton(
                systemName: "repeat",
                tint: loopButtonColor,
                isDisabled: viewModel.selectionRange == nil,
                help: "Loop selected clips"
            ) {
                viewModel.toggleSelectionLoop()
            }

            if !isCompact && !usesPhoneDock {
                transportCircleButton(systemName: "backward.fill", tint: DAWTheme.textPrimary) {
                    viewModel.seek(to: max(0, viewModel.playheadTime - 5))
                }
            }

            Button {
                viewModel.togglePlayback()
            } label: {
                ZStack {
                    Circle()
                        .fill(Color.green.opacity(0.28))
                        .frame(
                            width: usesPhoneDock ? 52 : (isCompact ? 50 : 56),
                            height: usesPhoneDock ? 52 : (isCompact ? 50 : 56)
                        )
                        .blur(radius: viewModel.isPlaying ? 7 : 0)
                        .opacity(viewModel.isPlaying ? 1 : 0)

                    Circle()
                        .stroke(Color.green.opacity(0.9), lineWidth: 2)
                        .frame(
                            width: usesPhoneDock ? 46 : (isCompact ? 44 : 48),
                            height: usesPhoneDock ? 46 : (isCompact ? 44 : 48)
                        )
                        .opacity(viewModel.isPlaying ? 1 : 0)

                    Image(systemName: viewModel.isPlaying ? "pause.fill" : "play.fill")
                        .font(usesPhoneDock ? .title3.weight(.bold) : (isCompact ? .body.weight(.bold) : .title3.weight(.bold)))
                        .foregroundStyle(.black)
                        .frame(
                            width: usesPhoneDock ? 40 : (isCompact ? 38 : 42),
                            height: usesPhoneDock ? 40 : (isCompact ? 38 : 42)
                        )
                        .background(Circle().fill(.white))
                }
            }
            .buttonStyle(.plain)
            .animation(.easeOut(duration: 0.12), value: viewModel.isPlaying)

            transportCircleButton(systemName: "stop.fill", tint: DAWTheme.textPrimary, help: "Stop") {
                viewModel.stop()
            }

            if !isCompact && !usesPhoneDock {
                transportCircleButton(systemName: "forward.fill", tint: DAWTheme.textPrimary) {
                    viewModel.seek(to: min(viewModel.project.duration, viewModel.playheadTime + 5))
                }
            }
        }
        .padding(.horizontal, usesPhoneDock ? 12 : (isCompact ? 8 : 12))
        .padding(.vertical, usesPhoneDock ? 4 : (isCompact ? 4 : 6))
        .background(DAWTheme.surfaceElevated.opacity(0.9))
        .clipShape(Capsule())
        .overlay {
            Capsule().stroke(DAWTheme.border, lineWidth: 1)
        }
        .frame(maxWidth: usesPhoneDock ? .infinity : nil)
    }

    private func transportCircleButton(
        systemName: String,
        tint: Color,
        isDisabled: Bool = false,
        help: String? = nil,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            Image(systemName: systemName)
                .font(usesPhoneDock ? .body.weight(.semibold) : (isCompact ? .caption.weight(.semibold) : .body.weight(.semibold)))
                .foregroundStyle(tint)
                .frame(
                    width: usesPhoneDock ? phoneSecondaryTapTarget : (isCompact ? 30 : 34),
                    height: usesPhoneDock ? phoneSecondaryTapTarget : (isCompact ? 30 : 34)
                )
        }
        .buttonStyle(.plain)
        .disabled(isDisabled)
        .opacity(isDisabled ? 0.35 : 1)
        .help(help ?? "")
    }

    private var loopButtonColor: Color {
        guard viewModel.selectionRange != nil else { return DAWTheme.textSecondary }
        return viewModel.isSelectionLoopEnabled ? DAWTheme.accent : DAWTheme.textPrimary
    }
}
