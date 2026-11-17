//
//  WorkspacePresentationModifier.swift
//  LvoqPlayback
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
            .alert(L10n.Common.error, isPresented: .constant(viewModel.errorMessage != nil)) {
                Button(L10n.Common.ok) { viewModel.errorMessage = nil }
            } message: {
                Text(viewModel.errorMessage ?? "")
            }
            .alert(L10n.Common.importLabel, isPresented: .constant(viewModel.importNoticeMessage != nil)) {
                Button(L10n.Common.ok) { viewModel.importNoticeMessage = nil }
            } message: {
                Text(viewModel.importNoticeMessage ?? "")
            }
            .confirmationDialog(
                L10n.File.resetSession,
                isPresented: $viewModel.showResetSessionConfirmation,
                titleVisibility: .visible
            ) {
                Button(L10n.File.resetEverything, role: .destructive) {
                    viewModel.performResetSession()
                }
                Button(L10n.Common.cancel, role: .cancel) {}
            } message: {
                Text(L10n.File.resetSessionMessage)
            }
            .confirmationDialog(
                L10n.File.newProject,
                isPresented: $viewModel.showNewProjectConfirmation,
                titleVisibility: .visible
            ) {
                Button(L10n.File.saveAndContinue) {
                    viewModel.createNewProject(saveCurrent: true)
                }
                Button(L10n.File.continueWithoutSaving, role: .destructive) {
                    viewModel.createNewProject(saveCurrent: false)
                }
                Button(L10n.Common.cancel, role: .cancel) {}
            } message: {
                Text(L10n.File.newProjectMessage)
            }
            .confirmationDialog(
                deleteSectionDialogTitle,
                isPresented: sectionDeletionDialogBinding,
                titleVisibility: .visible
            ) {
                Button(L10n.Common.delete, role: .destructive) {
                    viewModel.confirmPendingSectionDeletion()
                }
                Button(L10n.Common.cancel, role: .cancel) {
                    viewModel.cancelSectionDeletion()
                }
            } message: {
                Text(L10n.File.deleteSectionMessage)
            }
            .sheet(isPresented: workspaceLyricLinkSheetBinding, onDismiss: dismissLyricLinkSheet) {
                lyricLinkSheet
            }
    }

    private var deleteSectionDialogTitle: String {
        if let name = viewModel.pendingSectionDeletionName {
            return L10n.File.deleteNamed(name)
        }
        return L10n.File.deleteSection
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

    /// iPhone assign already presents this sheet from `SectionAssignSheetView`.
    private var workspaceLyricLinkSheetBinding: Binding<Bool> {
        Binding(
            get: {
                if viewModel.isPhoneSectionAssignSheetPresented {
                    return false
                }
                return viewModel.isSectionLyricLinkSheetPresented
            },
            set: { viewModel.isSectionLyricLinkSheetPresented = $0 }
        )
    }

    @ViewBuilder
    private var lyricLinkSheet: some View {
        if let section = viewModel.sectionForLyricLink {
            SectionLyricLinkSheet(viewModel: viewModel, section: section)
        }
    }

    private func dismissLyricLinkSheet() {
        viewModel.sectionIDForLyricLink = nil
        viewModel.isSectionLyricLinkSheetPresented = false
    }
}
