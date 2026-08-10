//
//  SidebarPanel.swift
//  SimplePlay
//

import SwiftUI

struct SidebarPanel<Content: View>: View {
    let title: String
    var icon: String? = nil
    @ViewBuilder var content: () -> Content

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            if let icon {
                SettingsSectionHeader(title: title, icon: icon)
            } else {
                Text(title)
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(DAWTheme.textPrimary)
            }

            content()
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .dawSettingsPanelGlass()
    }
}

struct SidebarLabeledRow<Content: View>: View {
    let title: String
    @ViewBuilder var content: () -> Content

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.caption.weight(.semibold))
                .foregroundStyle(DAWTheme.textSecondary)
            content()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
