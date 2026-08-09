//
//  AudioDropTargetModifier.swift
//  SimplePlay
//

import SwiftUI
import UniformTypeIdentifiers

struct AudioDropTargetModifier: ViewModifier {
    @Bindable var viewModel: WorkspaceViewModel
    var startTime: TimeInterval?
    var overlayMessage: String

    @State private var isTargeted = false

    func body(content: Content) -> some View {
        content
            .contentShape(Rectangle())
            .overlay {
                if isTargeted {
                    AudioDropOverlay(message: overlayMessage)
                }
            }
            .animation(.easeInOut(duration: 0.15), value: isTargeted)
            .onDrop(of: SupportedAudioFormats.dropTypes, isTargeted: $isTargeted) { providers in
                handleDrop(providers: providers, at: startTime)
                return true
            }
    }

    private func handleDrop(providers: [NSItemProvider], at startTime: TimeInterval?) {
        Task { @MainActor in
            let urls = await DropURLLoader.loadURLs(from: providers)
            guard !urls.isEmpty else { return }
            viewModel.importDroppedItems(urls: urls, startTime: startTime)
        }
    }
}

extension View {
    func audioDropTarget(
        viewModel: WorkspaceViewModel,
        startTime: TimeInterval? = nil,
        overlayMessage: String = "Drop audio files or a folder to import"
    ) -> some View {
        modifier(
            AudioDropTargetModifier(
                viewModel: viewModel,
                startTime: startTime,
                overlayMessage: overlayMessage
            )
        )
    }
}
