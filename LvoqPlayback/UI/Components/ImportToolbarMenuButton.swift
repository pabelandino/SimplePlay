//
//  ImportToolbarMenuButton.swift
//  LvoqPlayback
//

#if os(iOS)
import SwiftUI
import UIKit

/// UIKit menu buttons avoid SwiftUI `Menu` `_UIReparentingView` warnings on iPad.
struct ImportToolbarMenuButton: View {
    @Bindable var viewModel: WorkspaceViewModel
    var showsLabel = false

    var body: some View {
        UIKitToolbarMenuButtonRepresentable(
            title: showsLabel ? L10n.Common.importLabel : nil,
            systemImage: "waveform.badge.plus",
            accessibilityLabel: L10n.Import.audio,
            menuActions: [
                (L10n.Import.audioFiles, "doc.badge.plus", {
                    viewModel.presentImportPanel(for: .audioFiles, afterMenuDismiss: true)
                }),
                (L10n.Import.folder, "folder.badge.plus", {
                    viewModel.presentImportPanel(for: .folder, afterMenuDismiss: true)
                }),
            ]
        )
        .frame(width: showsLabel ? nil : 36, height: 36)
        .fixedSize(horizontal: showsLabel, vertical: false)
    }
}

struct ProjectSessionToolbarMenuButton: View {
    @Bindable var viewModel: WorkspaceViewModel
    var showsLabel = false

    var body: some View {
        UIKitToolbarMenuButtonRepresentable(
            title: showsLabel ? L10n.Common.new : nil,
            systemImage: "doc.badge.plus",
            accessibilityLabel: L10n.File.projectSession,
            menuActions: [
                (L10n.File.newProject, "doc", {
                    viewModel.requestNewProject()
                }),
                (L10n.File.resetSession, "arrow.counterclockwise", {
                    viewModel.requestResetSession()
                }),
            ]
        )
        .frame(width: showsLabel ? nil : 36, height: 36)
        .fixedSize(horizontal: showsLabel, vertical: false)
    }
}

private struct UIKitToolbarMenuButtonRepresentable: UIViewRepresentable {
    let title: String?
    let systemImage: String
    let accessibilityLabel: String
    let menuActions: [(title: String, systemImage: String, handler: () -> Void)]

    func makeCoordinator() -> Coordinator {
        Coordinator(menuActions: menuActions)
    }

    func makeUIView(context: Context) -> UIButton {
        let button = UIButton(type: .system)
        applyAppearance(to: button, coordinator: context.coordinator)
        return button
    }

    func updateUIView(_ button: UIButton, context: Context) {
        context.coordinator.menuActions = menuActions
        applyAppearance(to: button, coordinator: context.coordinator)
    }

    final class Coordinator {
        var menuActions: [(title: String, systemImage: String, handler: () -> Void)]

        init(menuActions: [(title: String, systemImage: String, handler: () -> Void)]) {
            self.menuActions = menuActions
        }
    }

    private func applyAppearance(to button: UIButton, coordinator: Coordinator) {
        var configuration = UIButton.Configuration.plain()
        configuration.baseForegroundColor = UIColor(DAWTheme.textPrimary)
        configuration.background.backgroundColor = UIColor(DAWTheme.surfaceElevated)
        configuration.background.cornerRadius = 8
        configuration.image = UIImage(systemName: systemImage)
        configuration.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(
            pointSize: 14,
            weight: .medium
        )

        if let title {
            configuration.title = title
            configuration.imagePadding = 5
            configuration.imagePlacement = .leading
            configuration.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
                var outgoing = incoming
                outgoing.font = .systemFont(ofSize: 12, weight: .semibold)
                return outgoing
            }
            configuration.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 10, bottom: 8, trailing: 12)
        } else {
            configuration.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
        }

        button.configuration = configuration

        let actions = coordinator.menuActions.map { item in
            UIAction(title: item.title, image: UIImage(systemName: item.systemImage)) { _ in
                item.handler()
            }
        }
        button.menu = UIMenu(children: actions)
        button.showsMenuAsPrimaryAction = true
        button.accessibilityLabel = accessibilityLabel
    }
}
#endif
