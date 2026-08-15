//
//  WorkspaceView.swift
//  SimplePlay
//

import SwiftUI

struct WorkspaceView: View {
    @Bindable var viewModel: WorkspaceViewModel
    @Environment(\.scenePhase) private var scenePhase

    var body: some View {
        Group {
#if os(iOS)
            if DAWTheme.isPhone {
                iPhoneWorkspaceView(viewModel: viewModel)
            } else {
                StandardWorkspaceView(viewModel: viewModel)
            }
#else
            StandardWorkspaceView(viewModel: viewModel)
#endif
        }
        .modifier(WorkspacePresentationModifier(viewModel: viewModel))
        .modifier(WorkspaceLifecycleModifier(viewModel: viewModel, scenePhase: scenePhase))
    }
}

private struct WorkspaceLifecycleModifier: ViewModifier {
    let viewModel: WorkspaceViewModel
    let scenePhase: ScenePhase

    func body(content: Content) -> some View {
        content
            .onChange(of: scenePhase) { _, phase in
                viewModel.setApplicationSceneActive(phase == .active)
            }
            .onChange(of: viewModel.showMixerPanel) { _, _ in
                viewModel.syncMeterMonitoring()
            }
    }
}

#Preview {
    WorkspaceView(viewModel: WorkspaceViewModel())
        .frame(width: 1280, height: 800)
}
