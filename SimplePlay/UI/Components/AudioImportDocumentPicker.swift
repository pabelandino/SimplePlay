//
//  AudioImportDocumentPicker.swift
//  SimplePlay
//

#if os(iOS)
import UIKit
import UniformTypeIdentifiers

/// Presents UIDocumentPickerViewController from the key window root, outside SwiftUI hosting.
@MainActor
enum ImportDocumentPickerPresenter {
    private static var activeSession: ImportDocumentPickerSession?

    static func present(
        contentTypes: [UTType],
        allowsMultipleSelection: Bool,
        copiesAsFiles: Bool,
        onPick: @escaping ([URL]) -> Void,
        onCancel: @escaping () -> Void = {}
    ) {
        guard activeSession == nil else { return }
        guard let host = topViewController() else { return }

        let session = ImportDocumentPickerSession(onPick: onPick, onCancel: onCancel)
        activeSession = session

        let picker = UIDocumentPickerViewController(
            forOpeningContentTypes: contentTypes,
            asCopy: copiesAsFiles
        )
        picker.delegate = session
        picker.allowsMultipleSelection = allowsMultipleSelection
        picker.shouldShowFileExtensions = true

        host.present(picker, animated: true)
    }

    fileprivate static func clearSession() {
        activeSession = nil
    }

    private static func topViewController() -> UIViewController? {
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap(\.windows)
            .first(where: \.isKeyWindow)?
            .rootViewController
    }
}

private final class ImportDocumentPickerSession: NSObject, UIDocumentPickerDelegate {
    let onPick: ([URL]) -> Void
    let onCancel: () -> Void

    init(onPick: @escaping ([URL]) -> Void, onCancel: @escaping () -> Void) {
        self.onPick = onPick
        self.onCancel = onCancel
    }

    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        onPick(urls)
        ImportDocumentPickerPresenter.clearSession()
    }

    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        onCancel()
        ImportDocumentPickerPresenter.clearSession()
    }
}
#endif
