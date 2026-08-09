//
//  AudioImportDocumentPicker.swift
//  SimplePlay
//

#if os(iOS)
import SwiftUI
import UIKit
import UniformTypeIdentifiers

/// Presents UIDocumentPickerViewController for reliable audio/folder import on iPad.
struct AudioImportDocumentPicker: UIViewControllerRepresentable {
    @Binding var isPresented: Bool
    let contentTypes: [UTType]
    let allowsMultipleSelection: Bool
    let copiesAsFiles: Bool
    let onPick: ([URL]) -> Void

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    func makeUIViewController(context: Context) -> AudioImportPickerHostViewController {
        let controller = AudioImportPickerHostViewController()
        controller.coordinator = context.coordinator
        return controller
    }

    func updateUIViewController(_ uiViewController: AudioImportPickerHostViewController, context: Context) {
        uiViewController.coordinator = context.coordinator
        uiViewController.presentImportPickerIfNeeded(
            isPresented: isPresented,
            contentTypes: contentTypes,
            allowsMultipleSelection: allowsMultipleSelection,
            copiesAsFiles: copiesAsFiles
        ) {
            isPresented = false
        }
    }

    final class Coordinator: NSObject, UIDocumentPickerDelegate {
        var parent: AudioImportDocumentPicker

        init(parent: AudioImportDocumentPicker) {
            self.parent = parent
        }

        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            parent.onPick(urls)
            parent.isPresented = false
        }

        func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
            parent.isPresented = false
        }
    }
}

final class AudioImportPickerHostViewController: UIViewController {
    weak var coordinator: AudioImportDocumentPicker.Coordinator?
    private var isShowingPicker = false

    func presentImportPickerIfNeeded(
        isPresented: Bool,
        contentTypes: [UTType],
        allowsMultipleSelection: Bool,
        copiesAsFiles: Bool,
        onDismiss: @escaping () -> Void
    ) {
        guard isPresented else {
            isShowingPicker = false
            return
        }

        guard !isShowingPicker, presentedViewController == nil else { return }

        let picker = UIDocumentPickerViewController(
            forOpeningContentTypes: contentTypes,
            asCopy: copiesAsFiles
        )
        picker.delegate = coordinator
        picker.allowsMultipleSelection = allowsMultipleSelection
        picker.shouldShowFileExtensions = true

        isShowingPicker = true
        present(picker, animated: true) {
            if self.presentedViewController == nil {
                self.isShowingPicker = false
                onDismiss()
            }
        }
    }
}
#endif
