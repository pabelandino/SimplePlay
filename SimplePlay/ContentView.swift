//
//  ContentView.swift
//  SimplePlay
//

import SwiftUI

struct ContentView: View {
    @Bindable var viewModel: WorkspaceViewModel

    var body: some View {
        WorkspaceView(viewModel: viewModel)
            .onOpenURL { url in
                viewModel.loadProject(from: url)
            }
    }
}

#Preview {
    ContentView(viewModel: WorkspaceViewModel())
        .frame(width: 1280, height: 800)
}
