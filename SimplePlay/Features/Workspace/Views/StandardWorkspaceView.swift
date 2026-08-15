//
//  StandardWorkspaceView.swift
//  SimplePlay
//

import SwiftUI

/// iPad and macOS workspace layout.
struct StandardWorkspaceView: View {
    @Bindable var viewModel: WorkspaceViewModel
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.verticalSizeClass) private var verticalSizeClass

    private var workspaceLayout: WorkspaceLayoutContext {
        WorkspaceLayoutContext(
            horizontalSizeClass: horizontalSizeClass,
            verticalSizeClass: verticalSizeClass,
            isTimelineWrapped: viewModel.isTimelineWrappedCompact
        )
    }

    var body: some View {
        VStack(spacing: 0) {
            TopToolbarView(viewModel: viewModel)
            MIDIMappingBarView(viewModel: viewModel)
                .layoutPriority(1)
            TimelineWorkspacePanel(viewModel: viewModel)
            TransportBarView(viewModel: viewModel)
        }
        .environment(\.workspaceLayout, workspaceLayout)
        .safeAreaInset(edge: .bottom, spacing: 0) {
            if viewModel.showMixerPanel {
                MixerPanelView(viewModel: viewModel)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .animation(.easeInOut(duration: 0.22), value: viewModel.showMixerPanel)
        .contentShape(Rectangle())
        .background(DAWTheme.background)
#if os(macOS)
        .background(MacWindowTitleBarHidden())
        .ignoresSafeArea(.container, edges: .top)
#endif
    }
}
