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

    /// Icon-only actions on iPhone and narrow macOS layouts.
    private var usesCompactToolbarActions: Bool {
#if os(iOS)
        UIDevice.current.userInterfaceIdiom == .phone
#else
        isCompact
#endif
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
            HStack(spacing: usesCompactToolbarActions ? 6 : 10) {
                projectTitle

                Spacer(minLength: usesCompactToolbarActions ? 4 : 8)

                toolButtons

                if !usesCompactToolbarActions {
                    Spacer(minLength: 8)
                }

                actionButtons
            }
            .padding(.horizontal, usesCompactToolbarActions ? 10 : 16)
#if os(macOS)
            .padding(.leading, DAWTheme.macTrafficLightLeadingInset - 16)
#endif
        }
        .frame(height: usesCompactToolbarActions ? DAWTheme.compactToolbarHeight : DAWTheme.toolbarHeight)
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
            .font(usesCompactToolbarActions ? .subheadline.weight(.semibold) : .headline)
            .foregroundStyle(DAWTheme.textPrimary)
            .lineLimit(1)
            .minimumScaleFactor(0.8)
            .layoutPriority(-1)
    }

    private var toolButtons: some View {
        HStack(spacing: usesCompactToolbarActions ? 4 : 12) {
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
            timelineToolButton(
                tool: .split,
                systemName: "scissors",
                help: "Split clip — drag on waveform to cut"
            )
            timelineToolButton(
                tool: .trim,
                systemName: "crop",
                help: "Trim clip edges"
            )

            if !usesCompactToolbarActions {
                addTrackMenu
            }
        }
    }

    private var addTrackMenu: some View {
        Menu {
            Button("Empty Track", systemImage: "rectangle.dashed") {
                viewModel.addEmptyTrack()
            }
            Button("Import Audio…", systemImage: "waveform.badge.plus") {
                viewModel.presentAddTrackImport()
            }
        } label: {
            toolButton("plus")
        }
        .accessibilityLabel("Add track")
    }

    private var actionButtons: some View {
        HStack(spacing: usesCompactToolbarActions ? 4 : 8) {
            TrackPitchControlView(viewModel: viewModel, compact: usesCompactToolbarActions)

            settingsButton
            openButton
            projectSessionButton
            saveButton
            importButton
        }
    }

    @ViewBuilder
    private var settingsButton: some View {
        if usesCompactToolbarActions {
            toolbarIconButton(systemName: "gearshape", accessibilityLabel: "Settings") {
                viewModel.showSettings = true
            }
        } else {
            toolbarLabeledButton(title: "Settings", systemName: "gearshape", help: "Settings") {
                viewModel.showSettings = true
            }
        }
    }

    @ViewBuilder
    private var openButton: some View {
        if usesCompactToolbarActions {
            toolbarIconButton(systemName: "folder", accessibilityLabel: "Open Project") {
                viewModel.openProject()
            }
        } else {
            toolbarLabeledButton(title: "Open", systemName: "folder", help: "Open Project") {
                viewModel.openProject()
            }
        }
    }

    @ViewBuilder
    private var projectSessionButton: some View {
#if os(iOS)
        ProjectSessionToolbarMenuButton(
            viewModel: viewModel,
            showsLabel: !usesCompactToolbarActions
        )
#else
        projectSessionMenu(labeled: !usesCompactToolbarActions)
#endif
    }

    @ViewBuilder
    private var saveButton: some View {
        if usesCompactToolbarActions {
            toolbarIconButton(systemName: "internaldrive.fill", accessibilityLabel: "Save Project") {
                viewModel.saveProject()
            }
        } else {
            toolbarLabeledButton(
                title: "Save",
                systemName: "internaldrive.fill",
                help: "Save Project"
            ) {
                viewModel.saveProject()
            }
        }
    }

    @ViewBuilder
    private var importButton: some View {
#if os(iOS)
        ImportToolbarMenuButton(
            viewModel: viewModel,
            showsLabel: !usesCompactToolbarActions
        )
#else
        importMenu(labeled: !usesCompactToolbarActions)
#endif
    }

    @ViewBuilder
    private func importMenu(labeled: Bool) -> some View {
        Menu {
            importMenuItems
        } label: {
            if labeled {
                HStack(spacing: 5) {
                    Image(systemName: "waveform.badge.plus")
                    Text("Import")
                        .font(.caption.weight(.semibold))
                }
            } else {
                Image(systemName: "waveform.badge.plus")
            }
        }
        .modifier(ToolbarMenuButtonStyleModifier(labeled: labeled))
        .accessibilityLabel("Import audio")
        .help("Import audio files or a folder (max 20 audio files)")
    }

    @ViewBuilder
    private func projectSessionMenu(labeled: Bool) -> some View {
        Menu {
            projectSessionMenuItems
        } label: {
            if labeled {
                HStack(spacing: 5) {
                    Image(systemName: "doc.badge.plus")
                    Text("New")
                        .font(.caption.weight(.semibold))
                }
            } else {
                Image(systemName: "doc.badge.plus")
            }
        }
        .modifier(ToolbarMenuButtonStyleModifier(labeled: labeled))
        .accessibilityLabel("Project Session")
        .help("Start a new project or reset the current session")
    }

    @ViewBuilder
    private var importMenuItems: some View {
        Button("Import Audio Files", systemImage: "doc.badge.plus") {
            viewModel.presentImportPanel(for: .audioFiles)
        }
        Button("Import Folder", systemImage: "folder.badge.plus") {
            viewModel.presentImportPanel(for: .folder)
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

    private func toolbarLabeledButton(
        title: String,
        systemName: String,
        help: String,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            HStack(spacing: 5) {
                Image(systemName: systemName)
                    .font(.system(size: 14, weight: .medium))
                Text(title)
                    .font(.caption.weight(.semibold))
            }
        }
        .buttonStyle(DAWLabeledToolbarButtonStyle())
        .help(help)
        .accessibilityLabel(help)
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
            if viewModel.timelineTool != tool {
                viewModel.cancelClipEditing()
                viewModel.timelineTool = tool
            }
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

struct DAWLabeledToolbarButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundStyle(DAWTheme.textPrimary)
            .lineLimit(1)
            .padding(.horizontal, 10)
            .padding(.vertical, 8)
            .frame(minHeight: 36)
            .background(DAWTheme.surfaceElevated.opacity(configuration.isPressed ? 0.7 : 1))
            .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

private struct ToolbarMenuButtonStyleModifier: ViewModifier {
    let labeled: Bool

    func body(content: Content) -> some View {
        if labeled {
            content.buttonStyle(DAWLabeledToolbarButtonStyle())
        } else {
            content.buttonStyle(DAWIconToolbarButtonStyle())
        }
    }
}
