//
//  TopToolbarView.swift
//  SimplePlay
//

import SwiftUI
#if os(iOS)
import UIKit
#endif

struct TopToolbarView: View {
    @Bindable var viewModel: WorkspaceViewModel
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    private var isCompact: Bool {
        horizontalSizeClass == .compact
    }

    private var usesPhoneToolbar: Bool {
#if os(iOS)
        UIDevice.current.userInterfaceIdiom == .phone
#else
        false
#endif
    }

    private var usesIconActionButtons: Bool {
        usesPhoneToolbar || isCompact
    }

    var body: some View {
        VStack(spacing: 0) {
#if os(macOS)
            DAWTheme.surface
                .frame(height: DAWTheme.macTitleBarTopInset)
                .overlay {
                    MacWindowDragRegion()
                }
#endif
            HStack(spacing: usesIconActionButtons ? 6 : 16) {
                projectTitle

                Spacer(minLength: usesIconActionButtons ? 4 : 8)

                toolButtons

                if !usesIconActionButtons {
                    Spacer(minLength: 8)
                }

                actionButtons
            }
            .padding(.horizontal, usesIconActionButtons ? 10 : 16)
#if os(macOS)
            .padding(.leading, DAWTheme.macTrafficLightLeadingInset - 16)
#endif
        }
        .frame(height: usesIconActionButtons ? DAWTheme.compactToolbarHeight : DAWTheme.toolbarHeight)
#if os(macOS)
        .frame(minHeight: DAWTheme.toolbarHeight + DAWTheme.macTitleBarTopInset)
#endif
        .background(DAWTheme.surface)
        .overlay(alignment: .bottom) {
            Rectangle()
                .fill(DAWTheme.border)
                .frame(height: 1)
        }
    }

    private var projectTitle: some View {
        Text(viewModel.project.name)
            .font(usesIconActionButtons ? .subheadline.weight(.semibold) : .headline)
            .foregroundStyle(DAWTheme.textPrimary)
            .lineLimit(1)
            .minimumScaleFactor(0.8)
            .layoutPriority(-1)
    }

    private var toolButtons: some View {
        HStack(spacing: usesIconActionButtons ? 4 : 12) {
            timelineToolButton(
                tool: .hand,
                systemName: "hand.raised",
                help: "Move clips"
            )
            timelineToolButton(
                tool: .arrow,
                systemName: "cursorarrow",
                help: "Select clips"
            )

            if !usesIconActionButtons {
                toolButton("plus")
                toolButton("scissors")
            }
        }
    }

    private var actionButtons: some View {
        HStack(spacing: usesIconActionButtons ? 4 : 12) {
            TrackPitchControlView(viewModel: viewModel, compact: usesIconActionButtons)

            toolbarIconButton(
                systemName: "gearshape",
                accessibilityLabel: "Settings"
            ) {
                viewModel.showSettings = true
            }

            if usesIconActionButtons {
                toolbarIconButton(
                    systemName: "folder",
                    accessibilityLabel: "Open Project"
                ) {
                    viewModel.openProject()
                }

                projectSessionMenu(compact: true)

                toolbarIconButton(
                    systemName: "square.and.arrow.down",
                    accessibilityLabel: "Save Project"
                ) {
                    viewModel.saveProject()
                }

                Menu {
                    Button("Import Audio Files", systemImage: "doc.badge.plus") {
                        viewModel.presentImportPanel(for: .audioFiles)
                    }
                    Button("Import Folder", systemImage: "folder.badge.plus") {
                        viewModel.presentImportPanel(for: .folder)
                    }
                } label: {
                    Image(systemName: "tray.and.arrow.down")
                }
                .buttonStyle(DAWIconToolbarButtonStyle())
                .accessibilityLabel("Import")
            } else {
                Button("Open") { viewModel.openProject() }
                    .buttonStyle(DAWSecondaryButtonStyle())
                projectSessionMenu(compact: false)
                Button("Save") { viewModel.saveProject() }
                    .buttonStyle(DAWSecondaryButtonStyle())
                Menu {
                    Button("Import Audio Files") {
                        viewModel.presentImportPanel(for: .audioFiles)
                    }
                    Button("Import Folder") {
                        viewModel.presentImportPanel(for: .folder)
                    }
                } label: {
                    Text("Import")
                }
                .buttonStyle(DAWSecondaryButtonStyle())
                .help("Import audio files or a folder (max 20 audio files)")
            }
        }
    }

    @ViewBuilder
    private func projectSessionMenu(compact: Bool) -> some View {
        if compact {
            Menu {
                projectSessionMenuItems
            } label: {
                Image(systemName: "doc.badge.plus")
            }
            .buttonStyle(DAWIconToolbarButtonStyle())
            .accessibilityLabel("Project Session")
        } else {
            Menu {
                projectSessionMenuItems
            } label: {
                Text("New")
            }
            .buttonStyle(DAWSecondaryButtonStyle())
            .help("Start a new project or reset the current session")
        }
    }

    @ViewBuilder
    private var projectSessionMenuItems: some View {
        Button("New Project", systemImage: "doc") {
            viewModel.requestNewProject()
        }
        Button("Reset Session", systemImage: "arrow.counterclockwise", role: .destructive) {
            viewModel.requestResetSession()
        }
    }

    private func toolbarIconButton(
        systemName: String,
        accessibilityLabel: String,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            Image(systemName: systemName)
        }
        .buttonStyle(DAWIconToolbarButtonStyle())
        .accessibilityLabel(accessibilityLabel)
    }

    private func timelineToolButton(tool: TimelineEditTool, systemName: String, help: String) -> some View {
        Button {
            viewModel.timelineTool = tool
        } label: {
            Image(systemName: systemName)
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(viewModel.timelineTool == tool ? DAWTheme.accent : DAWTheme.textSecondary)
                .frame(width: 32, height: 32)
                .background(viewModel.timelineTool == tool ? DAWTheme.surfaceElevated : .clear)
                .clipShape(RoundedRectangle(cornerRadius: 8))
        }
        .buttonStyle(.plain)
        .accessibilityLabel(help)
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
            .lineLimit(1)
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
            .lineLimit(1)
            .minimumScaleFactor(0.85)
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(DAWTheme.surfaceElevated.opacity(configuration.isPressed ? 0.7 : 1))
            .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

struct DAWIconToolbarButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 15, weight: .medium))
            .foregroundStyle(DAWTheme.textPrimary)
            .frame(width: 36, height: 36)
            .background(DAWTheme.surfaceElevated.opacity(configuration.isPressed ? 0.7 : 1))
            .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}
