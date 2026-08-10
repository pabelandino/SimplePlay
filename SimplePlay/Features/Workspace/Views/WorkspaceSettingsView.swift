//
//  WorkspaceSettingsView.swift
//  SimplePlay
//

import SwiftUI

struct WorkspaceSettingsView: View {
    @Bindable var viewModel: WorkspaceViewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 0) {
            settingsHeader
                .zIndex(1)

            PropertiesSidebarView(viewModel: viewModel)
        }
        .dawGlassBorder(cornerRadius: DAWGlassChrome.windowCornerRadius, lineWidth: 1.25)
        .preferredColorScheme(.dark)
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
#if os(iOS)
        .presentationDragIndicator(.visible)
        .presentationCornerRadius(DAWGlassChrome.windowCornerRadius)
#endif
#if os(macOS)
        .frame(minWidth: 420, idealWidth: 460, minHeight: 580, idealHeight: 680)
        .background(.clear)
#endif
    }

    private var settingsHeader: some View {
        HStack(alignment: .center, spacing: 16) {
            VStack(alignment: .leading, spacing: 3) {
                Text("Settings")
                    .font(.title3.weight(.bold))
                    .foregroundStyle(DAWTheme.textPrimary)

                Text("Audio, sections, and project preferences")
                    .font(.caption)
                    .foregroundStyle(DAWTheme.textSecondary)
            }

            Spacer(minLength: 0)

            Button("Done") {
                dismiss()
            }
            .buttonStyle(DAWPrimaryButtonStyle())
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .dawSettingsHeaderChrome()
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
