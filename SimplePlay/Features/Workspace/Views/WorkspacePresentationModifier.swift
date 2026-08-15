//
//  WorkspacePresentationModifier.swift
//  SimplePlay
//

import SwiftUI
import UniformTypeIdentifiers

struct WorkspacePresentationModifier: ViewModifier {
    @Bindable var viewModel: WorkspaceViewModel

    func body(content: Content) -> some View {
        content
            .workspaceKeyboardShortcuts(viewModel: viewModel)
            .audioDropTarget(viewModel: viewModel)
            .sheet(isPresented: $viewModel.showSettings) {
                WorkspaceSettingsView(viewModel: viewModel)
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
            .alert("Import", isPresented: .constant(viewModel.importNoticeMessage != nil)) {
                Button("OK") { viewModel.importNoticeMessage = nil }
            } message: {
                Text(viewModel.importNoticeMessage ?? "")
            }
            .confirmationDialog(
                "Reset Session",
                isPresented: $viewModel.showResetSessionConfirmation,
                titleVisibility: .visible
            ) {
                Button("Reset Everything", role: .destructive) {
                    viewModel.performResetSession()
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("This will permanently remove all tracks, multitracks, sections, markers, selections, and timeline edits. Mixer levels and MIDI mappings in this session will also be cleared. This cannot be undone.")
            }
            .confirmationDialog(
                "New Project",
                isPresented: $viewModel.showNewProjectConfirmation,
                titleVisibility: .visible
            ) {
                Button("Save and Continue") {
                    viewModel.createNewProject(saveCurrent: true)
                }
                Button("Continue Without Saving", role: .destructive) {
                    viewModel.createNewProject(saveCurrent: false)
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("Start a blank project? You can save your current work first, including tracks, sections, markers, mixer settings, and MIDI mappings.")
            }
            .confirmationDialog(
                deleteSectionDialogTitle,
                isPresented: sectionDeletionDialogBinding,
                titleVisibility: .visible
            ) {
                Button("Delete", role: .destructive) {
                    viewModel.confirmPendingSectionDeletion()
                }
                Button("Cancel", role: .cancel) {
                    viewModel.cancelSectionDeletion()
                }
            } message: {
                Text("This section marker will be removed from the timeline.")
            }
    }

    private var deleteSectionDialogTitle: String {
        if let name = viewModel.pendingSectionDeletionName {
            return "Delete \"\(name)\"?"
        }
        return "Delete Section?"
    }

    private var sectionDeletionDialogBinding: Binding<Bool> {
        Binding(
            get: { viewModel.sectionIDPendingDeletion != nil },
            set: { isPresented in
                if !isPresented {
                    viewModel.cancelSectionDeletion()
                }
            }
        )
    }
}
