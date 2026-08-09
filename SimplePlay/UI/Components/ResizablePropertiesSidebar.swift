//
//  ResizablePropertiesSidebar.swift
//  SimplePlay
//

import SwiftUI

/// Legacy layout component. Inspector content now lives in `WorkspaceSettingsView`.
struct ResizablePropertiesSidebar: View {
    @Bindable var viewModel: WorkspaceViewModel

    var body: some View {
        EmptyView()
    }
}

#if os(macOS)
import AppKit
#endif
