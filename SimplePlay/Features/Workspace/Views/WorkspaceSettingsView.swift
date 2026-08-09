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
        }
#if os(macOS)
        .frame(minWidth: 360, minHeight: 520)
#endif
    }
}
