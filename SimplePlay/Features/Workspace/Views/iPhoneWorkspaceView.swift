//
//  iPhoneWorkspaceView.swift
//  SimplePlay
//

import SwiftUI

/// Dedicated iPhone workspace shell (portrait and landscape).
struct iPhoneWorkspaceView: View {
    @Bindable var viewModel: WorkspaceViewModel

    private var phoneLayout: WorkspaceLayoutContext {
        WorkspaceLayoutContext(
            horizontalSizeClass: .compact,
            verticalSizeClass: .compact,
            isTimelineWrapped: false
        )
    }

    var body: some View {
        VStack(spacing: 0) {
            TopToolbarView(viewModel: viewModel)
            iPhoneMIDIMappingBarView(viewModel: viewModel)
            iPhoneTimelinePanel(viewModel: viewModel)
        }
        .environment(\.workspaceLayout, phoneLayout)
        .safeAreaInset(edge: .bottom, spacing: 0) {
            VStack(spacing: 0) {
                if viewModel.showMixerPanel {
                    MixerPanelView(viewModel: viewModel)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                }
                TransportBarView(viewModel: viewModel, style: .phoneBottomDock)
            }
        }
        .animation(.easeInOut(duration: 0.22), value: viewModel.showMixerPanel)
        .contentShape(Rectangle())
        .background(DAWTheme.background)
    }
}
