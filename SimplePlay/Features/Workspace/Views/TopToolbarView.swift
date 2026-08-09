//
//  TopToolbarView.swift
//  SimplePlay
//

import SwiftUI

struct TopToolbarView: View {
    @Bindable var viewModel: WorkspaceViewModel

    var body: some View {
        HStack(spacing: 16) {
            HStack(spacing: 8) {
                Image(systemName: "line.3.horizontal")
                    .foregroundStyle(DAWTheme.textSecondary)
                Text(viewModel.project.name)
                    .font(.headline)
                    .foregroundStyle(DAWTheme.textPrimary)
                Image(systemName: "chevron.down")
                    .font(.caption)
                    .foregroundStyle(DAWTheme.textSecondary)
            }

            Spacer()

            HStack(spacing: 12) {
                toolButton("cursorarrow", isActive: true)
                toolButton("plus")
                toolButton("scissors")
                toolButton("text.insert", isActive: true, accent: true)
            }

            Spacer()

            HStack(spacing: 12) {
                Button {
                    viewModel.isPropertiesSidebarVisible.toggle()
                } label: {
                    Image(systemName: viewModel.isPropertiesSidebarVisible ? "sidebar.right" : "sidebar.right.fill")
                }
                .buttonStyle(DAWSecondaryButtonStyle())
                .help(viewModel.isPropertiesSidebarVisible ? "Hide Inspector" : "Show Inspector")

                Button("Open") {
                    viewModel.openProject()
                }
                .buttonStyle(DAWSecondaryButtonStyle())

                Button("Save") {
                    viewModel.saveProject()
                }
                .buttonStyle(DAWSecondaryButtonStyle())

                Button("Import") {
                    viewModel.showImportPanel = true
                }
                .buttonStyle(DAWSecondaryButtonStyle())

                Button("Share") {}
                    .buttonStyle(DAWSecondaryButtonStyle())

                Button("Publish") {}
                    .buttonStyle(DAWPrimaryButtonStyle())
            }
        }
        .padding(.horizontal, 16)
        .frame(height: DAWTheme.toolbarHeight)
        .background(DAWTheme.surface)
        .overlay(alignment: .bottom) {
            Rectangle()
                .fill(DAWTheme.border)
                .frame(height: 1)
        }
    }

    private func toolButton(_ systemName: String, isActive: Bool = false, accent: Bool = false) -> some View {
        Image(systemName: systemName)
            .font(.system(size: 14, weight: .medium))
            .foregroundStyle(isActive ? (accent ? DAWTheme.accent : DAWTheme.textPrimary) : DAWTheme.textSecondary)
            .frame(width: 32, height: 32)
            .background(isActive ? DAWTheme.surfaceElevated : .clear)
            .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

struct DAWPrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.subheadline.weight(.semibold))
            .foregroundStyle(.black)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(DAWTheme.accent.opacity(configuration.isPressed ? 0.8 : 1))
            .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

struct DAWSecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.subheadline.weight(.medium))
            .foregroundStyle(DAWTheme.textPrimary)
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(DAWTheme.surfaceElevated.opacity(configuration.isPressed ? 0.7 : 1))
            .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}
