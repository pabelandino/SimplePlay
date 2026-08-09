//
//  WorkspaceView.swift
//  SimplePlay
//

import SwiftUI
import UniformTypeIdentifiers

struct WorkspaceView: View {
    @Bindable var viewModel: WorkspaceViewModel

    var body: some View {
        VStack(spacing: 0) {
            TopToolbarView(viewModel: viewModel)
            HStack(spacing: 0) {
                TimelineWorkspacePanel(viewModel: viewModel)
                ResizablePropertiesSidebar(viewModel: viewModel)
            }
            TransportBarView(viewModel: viewModel)
        }
        .background(DAWTheme.background)
        .workspaceKeyboardShortcuts(viewModel: viewModel)
        .audioDropTarget(viewModel: viewModel)
        .fileImporter(
            isPresented: $viewModel.showImportPanel,
            allowedContentTypes: SupportedAudioFormats.contentTypes,
            allowsMultipleSelection: true
        ) { result in
            switch result {
            case .success(let urls):
                urls.forEach { viewModel.beginAccessIfNeeded(for: $0) }
                viewModel.importMultitrack(urls: urls)
            case .failure(let error):
                viewModel.errorMessage = error.localizedDescription
            }
        }
        .fileImporter(
            isPresented: $viewModel.showOpenProjectPanel,
            allowedContentTypes: [.simplePlayProject],
            allowsMultipleSelection: false
        ) { result in
            switch result {
            case .success(let urls):
                guard let url = urls.first else { return }
                viewModel.loadProject(from: url)
            case .failure(let error):
                viewModel.errorMessage = error.localizedDescription
            }
        }
        .fileExporter(
            isPresented: $viewModel.showSaveProjectPanel,
            document: viewModel.projectFileDocument,
            contentType: .simplePlayProject,
            defaultFilename: viewModel.project.name
        ) { result in
            viewModel.handleProjectSaveResult(result)
        }
        .alert("Error", isPresented: .constant(viewModel.errorMessage != nil)) {
            Button("OK") { viewModel.errorMessage = nil }
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
    }
}

#Preview {
    WorkspaceView(viewModel: WorkspaceViewModel())
        .frame(width: 1280, height: 800)
}
