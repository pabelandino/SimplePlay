//
//  TransportBarView.swift
//  SimplePlay
//

import SwiftUI

struct TransportBarView: View {
    @Bindable var viewModel: WorkspaceViewModel
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    private var isCompact: Bool {
        horizontalSizeClass == .compact
    }

    var body: some View {
        VStack(spacing: isCompact ? 6 : 8) {
            TimelineOverviewBar(viewModel: viewModel)
                .padding(.top, isCompact ? 6 : 8)

            HStack(spacing: isCompact ? 8 : 12) {
                timeDisplay
                Spacer(minLength: 4)
                transportControls
                Spacer(minLength: 4)
                mainVolumeControl
                mixerButton
                zoomControls
            }
            .padding(.horizontal, isCompact ? 12 : 16)
            .padding(.bottom, isCompact ? 8 : 10)
        }
        .background(DAWTheme.surface)
        .overlay(alignment: .top) {
            Rectangle()
                .fill(DAWTheme.border)
                .frame(height: 1)
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
                    transportIconButton("arrow.uturn.backward", help: "Undo")
                    transportIconButton("arrow.uturn.forward", help: "Redo")
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

    private func transportIconButton(_ systemName: String, help: String) -> some View {
        Button(action: {}) {
            Image(systemName: systemName)
                .font(.caption.weight(.semibold))
                .foregroundStyle(DAWTheme.textSecondary)
                .frame(width: 28, height: 28)
                .background(DAWTheme.background.opacity(0.55))
                .clipShape(RoundedRectangle(cornerRadius: 6))
        }
        .buttonStyle(.plain)
        .help(help)
    }

    private var transportControls: some View {
        HStack(spacing: isCompact ? 8 : 12) {
            transportCircleButton(
                systemName: "repeat",
                tint: loopButtonColor,
                isDisabled: viewModel.selectionRange == nil,
                help: "Loop selected clips"
            ) {
                viewModel.toggleSelectionLoop()
            }

            if !isCompact {
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
                        .frame(width: isCompact ? 50 : 56, height: isCompact ? 50 : 56)
                        .blur(radius: viewModel.isPlaying ? 7 : 0)
                        .opacity(viewModel.isPlaying ? 1 : 0)

                    Circle()
                        .stroke(Color.green.opacity(0.9), lineWidth: 2)
                        .frame(width: isCompact ? 44 : 48, height: isCompact ? 44 : 48)
                        .opacity(viewModel.isPlaying ? 1 : 0)

                    Image(systemName: viewModel.isPlaying ? "pause.fill" : "play.fill")
                        .font(isCompact ? .body.weight(.bold) : .title3.weight(.bold))
                        .foregroundStyle(.black)
                        .frame(width: isCompact ? 38 : 42, height: isCompact ? 38 : 42)
                        .background(Circle().fill(.white))
                }
            }
            .buttonStyle(.plain)
            .animation(.easeOut(duration: 0.12), value: viewModel.isPlaying)

            transportCircleButton(systemName: "stop.fill", tint: DAWTheme.textPrimary, help: "Stop") {
                viewModel.stop()
            }

            if !isCompact {
                transportCircleButton(systemName: "forward.fill", tint: DAWTheme.textPrimary) {
                    viewModel.seek(to: min(viewModel.project.duration, viewModel.playheadTime + 5))
                }
            }
        }
        .padding(.horizontal, isCompact ? 8 : 12)
        .padding(.vertical, isCompact ? 4 : 6)
        .background(DAWTheme.surfaceElevated.opacity(0.9))
        .clipShape(Capsule())
        .overlay {
            Capsule().stroke(DAWTheme.border, lineWidth: 1)
        }
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
                .font(isCompact ? .caption.weight(.semibold) : .body.weight(.semibold))
                .foregroundStyle(tint)
                .frame(width: isCompact ? 30 : 34, height: isCompact ? 30 : 34)
        }
        .buttonStyle(.plain)
        .disabled(isDisabled)
        .opacity(isDisabled ? 0.35 : 1)
        .help(help ?? "")
    }

    @ViewBuilder
    private var mainVolumeControl: some View {
        VStack(spacing: 2) {
            Text("Main")
                .font(.system(size: 9, weight: .bold))
                .foregroundStyle(DAWTheme.textSecondary)

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
        }
        .frame(width: isCompact ? 36 : 42)
        .padding(.horizontal, isCompact ? 6 : 8)
        .padding(.vertical, isCompact ? 4 : 6)
        .background(DAWTheme.surfaceElevated)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .overlay {
            RoundedRectangle(cornerRadius: 10)
                .stroke(DAWTheme.border, lineWidth: 1)
        }
        .accessibilityLabel("Main Volume")
    }

    private var masterVolumeBinding: Binding<Double> {
        Binding(
            get: { viewModel.project.masterVolume },
            set: { viewModel.setMasterVolume($0) }
        )
    }

    @ViewBuilder
    private var mixerButton: some View {
        Button {
            withAnimation(.easeInOut(duration: 0.22)) {
                viewModel.showMixerPanel.toggle()
            }
        } label: {
            Image(systemName: "slider.vertical.3")
                .font(isCompact ? .caption.weight(.semibold) : .body.weight(.semibold))
                .foregroundStyle(viewModel.showMixerPanel ? DAWTheme.accent : DAWTheme.textSecondary)
                .frame(width: isCompact ? 30 : 34, height: isCompact ? 30 : 34)
                .background(viewModel.showMixerPanel ? DAWTheme.accent.opacity(0.15) : DAWTheme.surfaceElevated)
                .clipShape(RoundedRectangle(cornerRadius: 8))
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Mixer")
    }

    @ViewBuilder
    private var zoomControls: some View {
        HStack(spacing: isCompact ? 6 : 8) {
            if isCompact {
                Button { viewModel.zoomOutOneStep() } label: {
                    Image(systemName: "minus.magnifyingglass")
                }
                Button { viewModel.zoomInOneStep() } label: {
                    Image(systemName: "plus.magnifyingglass")
                }
                Button("Fit") { viewModel.zoomToFitTimeline() }
                    .font(.caption.weight(.semibold))
            } else {
                Button { viewModel.zoomOutOneStep() } label: {
                    Image(systemName: "minus.magnifyingglass")
                }

                Slider(
                    value: Binding(
                        get: { viewModel.zoom },
                        set: { viewModel.setZoom($0) }
                    ),
                    in: viewModel.minimumTimelineZoom...DAWTheme.maxZoom
                )
                .frame(width: 96)

                Button { viewModel.zoomInOneStep() } label: {
                    Image(systemName: "plus.magnifyingglass")
                }

                Button("Fit") { viewModel.zoomToFitTimeline() }
                    .font(.caption.weight(.semibold))
            }
        }
        .foregroundStyle(DAWTheme.textSecondary)
        .padding(.horizontal, isCompact ? 8 : 10)
        .padding(.vertical, isCompact ? 6 : 8)
        .background(DAWTheme.surfaceElevated)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .overlay {
            RoundedRectangle(cornerRadius: 10)
                .stroke(DAWTheme.border, lineWidth: 1)
        }
    }

    private var loopButtonColor: Color {
        guard viewModel.selectionRange != nil else { return DAWTheme.textSecondary }
        return viewModel.isSelectionLoopEnabled ? DAWTheme.accent : DAWTheme.textPrimary
    }
}
