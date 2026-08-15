//
//  LyricPlaySyncStatusView.swift
//  SimplePlay
//

import SwiftUI

struct LyricPlaySyncStatusView: View {
    @Bindable var viewModel: WorkspaceViewModel
    var isCompact: Bool = false

    var body: some View {
        HStack(spacing: 8) {
            Circle()
                .fill(statusColor)
                .frame(width: 7, height: 7)

            VStack(alignment: .leading, spacing: 2) {
                Text(statusTitle)
                    .lineLimit(isCompact ? 2 : 1)

                if let subtitle = statusSubtitle {
                    Text(subtitle)
                        .font(.caption2)
                        .foregroundStyle(DAWTheme.textSecondary.opacity(0.85))
                        .lineLimit(2)
                }
            }

            Spacer(minLength: 0)

            if viewModel.isLyrioraSyncEnabled {
                Button("Refresh") {
                    Task { await viewModel.refreshLyricCatalog() }
                }
                .buttonStyle(DAWSecondaryButtonStyle())
                .disabled(viewModel.isLoadingLyricCatalog)
            }

            Button(viewModel.isLyrioraSyncEnabled ? "Disconnect" : "Connect") {
                viewModel.setLyrioraSyncEnabled(!viewModel.isLyrioraSyncEnabled)
            }
            .buttonStyle(DAWSecondaryButtonStyle())
        }
        .font(isCompact ? .caption2 : .caption)
        .foregroundStyle(DAWTheme.textSecondary)
        .padding(.horizontal, isCompact ? 10 : 12)
        .padding(.vertical, isCompact ? 8 : 9)
        .background(DAWTheme.background.opacity(0.45))
        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
    }

    private var statusColor: Color {
        if !viewModel.isLyrioraSyncEnabled {
            return DAWTheme.textSecondary.opacity(0.45)
        }
        if viewModel.isLyrioraReachable {
            return .green
        }
        if viewModel.isLoadingLyricCatalog {
            return .yellow
        }
        return .red
    }

    private var statusTitle: String {
        if !viewModel.isLyrioraSyncEnabled {
            return "Lyriora disconnected"
        }
        if viewModel.isLoadingLyricCatalog {
            return "Loading slides from Lyriora…"
        }
        if let catalog = viewModel.lyricCatalog {
            return "\(catalog.slides.count) slides · \(catalog.lyricTitle)"
        }
        switch viewModel.lyricConnectionState {
        case .searching:
            return "Searching for Lyriora…"
        case .connected(let name):
            return "Lyriora found · \(name)"
        case .failed(let message):
            return message
        case .idle:
            return viewModel.lyricSyncErrorMessage ?? "Lyriora not found on this network"
        }
    }

    private var statusSubtitle: String? {
        if !viewModel.isLyrioraSyncEnabled {
            return "Slide sync and network lookup are paused."
        }
        if viewModel.lyricCatalog == nil, !viewModel.isLoadingLyricCatalog {
            return "Open Lyriora on the same Wi‑Fi with a lyric selected."
        }
        return nil
    }
}
