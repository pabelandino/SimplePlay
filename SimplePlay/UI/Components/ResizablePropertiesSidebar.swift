//
//  ResizablePropertiesSidebar.swift
//  SimplePlay
//

import SwiftUI

struct ResizablePropertiesSidebar: View {
    @Bindable var viewModel: WorkspaceViewModel
    @State private var dragStartWidth: CGFloat?

    var body: some View {
        HStack(spacing: 0) {
            if viewModel.isPropertiesSidebarVisible {
                sidebarResizeHandle

                PropertiesSidebarView(viewModel: viewModel)
                    .frame(width: viewModel.propertiesSidebarWidth)
            } else {
                collapsedSidebarToggle
            }
        }
    }

    private var sidebarResizeHandle: some View {
        Rectangle()
            .fill(DAWTheme.border)
            .frame(width: DAWTheme.sidebarHandleWidth)
            .overlay {
                Capsule()
                    .fill(DAWTheme.textSecondary.opacity(0.45))
                    .frame(width: 2, height: 44)
            }
            .contentShape(Rectangle())
            .gesture(
                DragGesture(minimumDistance: 1)
                    .onChanged { value in
                        if dragStartWidth == nil {
                            dragStartWidth = viewModel.propertiesSidebarWidth
                        }
                        let start = dragStartWidth ?? viewModel.propertiesSidebarWidth
                        viewModel.propertiesSidebarWidth = min(
                            DAWTheme.propertiesMaxWidth,
                            max(DAWTheme.propertiesMinWidth, start - value.translation.width)
                        )
                    }
                    .onEnded { _ in
                        dragStartWidth = nil
                    }
            )
#if os(macOS)
            .onHover { hovering in
                if hovering {
                    NSCursor.resizeLeftRight.push()
                } else {
                    NSCursor.pop()
                }
            }
#endif
    }

    private var collapsedSidebarToggle: some View {
        Button {
            viewModel.isPropertiesSidebarVisible = true
        } label: {
            Image(systemName: "sidebar.right")
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(DAWTheme.textSecondary)
                .frame(width: 28)
                .frame(maxHeight: .infinity)
                .background(DAWTheme.surface)
        }
        .buttonStyle(.plain)
        .help("Show Inspector")
    }
}

#if os(macOS)
import AppKit
#endif
