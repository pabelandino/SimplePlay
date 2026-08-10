//
//  WorkspaceSettingsView.swift
//  SimplePlay
//

import SwiftUI

struct WorkspaceSettingsView: View {
    @Bindable var viewModel: WorkspaceViewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            PropertiesSidebarView(viewModel: viewModel)
                .navigationTitle("Settings")
#if os(iOS)
                .navigationBarTitleDisplayMode(.inline)
#endif
                .toolbar {
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Done") {
                            dismiss()
                        }
                    }
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
#if os(macOS)
        .frame(minWidth: 360, minHeight: 520)
#endif
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
