//
//  SectionLyricLinkSheet.swift
//  SimplePlay
//

import SwiftUI

struct SectionLyricLinkSheet: View {
    @Bindable var viewModel: WorkspaceViewModel
    let section: ArrangementSection

    @Environment(\.dismiss) private var dismiss
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    private var isCompact: Bool {
        horizontalSizeClass == .compact || DAWTheme.isPhone
    }

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoadingLyricCatalog {
                    ProgressView("Loading slides from Lyriora…")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if let catalog = viewModel.lyricCatalog {
                    catalogContent(catalog)
                } else {
                    unavailableState
                }
            }
            .navigationTitle("Assign Slide · \(section.name)")
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { dismiss() }
                }

                if section.hasLyricSlideLink {
                    ToolbarItem(placement: .destructiveAction) {
                        Button("Clear Link", role: .destructive) {
                            viewModel.clearLyricSlideLink(for: section.id)
                            dismiss()
                        }
                    }
                }
            }
            .task {
                await viewModel.refreshLyricCatalog()
            }
        }
        #if os(macOS)
        .frame(minWidth: 460, minHeight: 520)
        #endif
    }

    private func catalogContent(_ catalog: LyricSlideCatalog) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: isCompact ? 10 : 14) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(catalog.lyricTitle)
                        .font(isCompact ? .subheadline.weight(.semibold) : .headline)
                    Text("\(catalog.slides.count) slides · tap to assign to \(section.name)")
                        .font(.caption)
                        .foregroundStyle(DAWTheme.textSecondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                LyricSlidePickerList(
                    viewModel: viewModel,
                    section: section,
                    catalog: catalog,
                    isCompact: isCompact
                ) {
                    dismiss()
                }
            }
            .padding(isCompact ? 12 : 16)
        }
        .background(DAWTheme.background)
    }

    private var unavailableState: some View {
        ContentUnavailableView {
            Label("Lyriora Not Found", systemImage: "wifi.exclamationmark")
        } description: {
            Text(viewModel.lyricSyncErrorMessage ?? "Make sure Lyriora is open on the same Wi‑Fi network with a lyric selected.")
        } actions: {
            Button("Retry") {
                Task { await viewModel.refreshLyricCatalog() }
            }
            .buttonStyle(DAWPrimaryButtonStyle())
        }
    }
}
