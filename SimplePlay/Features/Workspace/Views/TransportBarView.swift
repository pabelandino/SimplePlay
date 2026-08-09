//
//  TransportBarView.swift
//  SimplePlay
//

import SwiftUI

struct TransportBarView: View {
    @Bindable var viewModel: WorkspaceViewModel

    var body: some View {
        VStack(spacing: 8) {
            TimelineOverviewBar(viewModel: viewModel)
            HStack {
                timeDisplay
                Spacer()
                transportControls
                Spacer()
                zoomControls
            }
            .padding(.horizontal, 16)
        }
        .frame(height: DAWTheme.transportHeight)
        .background(DAWTheme.surface)
        .overlay(alignment: .top) {
            Rectangle()
                .fill(DAWTheme.border)
                .frame(height: 1)
        }
    }

    private var timeDisplay: some View {
        HStack(spacing: 8) {
            Text("\(viewModel.formattedCurrentTime) / \(viewModel.formattedDuration)")
                .font(.system(.body, design: .monospaced))
                .foregroundStyle(DAWTheme.textPrimary)

            Button(action: {}) {
                Image(systemName: "arrow.uturn.backward")
            }
            .buttonStyle(.plain)
            .foregroundStyle(DAWTheme.textSecondary)

            Button(action: {}) {
                Image(systemName: "arrow.uturn.forward")
            }
            .buttonStyle(.plain)
            .foregroundStyle(DAWTheme.textSecondary)
        }
    }

    private var transportControls: some View {
        HStack(spacing: 16) {
            Button {
                viewModel.seek(to: max(0, viewModel.playheadTime - 5))
            } label: {
                Image(systemName: "backward.fill")
            }
            .buttonStyle(.plain)
            .foregroundStyle(DAWTheme.textPrimary)

            Button {
                viewModel.togglePlayback()
            } label: {
                Image(systemName: viewModel.isPlaying ? "pause.fill" : "play.fill")
                    .font(.title2)
                    .foregroundStyle(.black)
                    .frame(width: 44, height: 44)
                    .background(Circle().fill(.white))
            }
            .buttonStyle(.plain)

            Button {
                viewModel.stop()
            } label: {
                Image(systemName: "stop.fill")
                    .font(.title3)
                    .foregroundStyle(DAWTheme.textPrimary)
                    .frame(width: 36, height: 36)
                    .background(Circle().stroke(DAWTheme.border, lineWidth: 1))
            }
            .buttonStyle(.plain)
            .help("Stop")

            Button {
                viewModel.seek(to: min(viewModel.project.duration, viewModel.playheadTime + 5))
            } label: {
                Image(systemName: "forward.fill")
            }
            .buttonStyle(.plain)
            .foregroundStyle(DAWTheme.textPrimary)
        }
    }

    private var zoomControls: some View {
        HStack(spacing: 10) {
            Button {
                viewModel.adjustZoom(by: 0.85)
            } label: {
                Image(systemName: "minus.magnifyingglass")
            }
            .buttonStyle(.plain)
            .foregroundStyle(DAWTheme.textSecondary)

            Slider(
                value: Binding(
                    get: { viewModel.zoom },
                    set: { viewModel.setZoom($0) }
                ),
                in: DAWTheme.minZoom...DAWTheme.maxZoom
            )
            .frame(width: 100)

            Button {
                viewModel.adjustZoom(by: 1.15)
            } label: {
                Image(systemName: "plus.magnifyingglass")
            }
            .buttonStyle(.plain)
            .foregroundStyle(DAWTheme.textSecondary)

            Button("Fit") {
                viewModel.zoomToFitTimeline()
            }
            .buttonStyle(DAWSecondaryButtonStyle())
            .help("Zoom to fit entire project")
        }
    }
}
