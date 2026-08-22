//
//  SectionLyricLinkSheet.swift
//  SimplePlay
//

import SwiftUI

struct SectionLyricLinkSheet: View {
    @Bindable var viewModel: WorkspaceViewModel
    let section: ArrangementSection

    @Environment(\.dismiss) private var dismiss

    private var liveSection: ArrangementSection {
        viewModel.project.sections.first(where: { $0.id == section.id }) ?? section
    }

    var body: some View {
        VStack(spacing: 0) {
            header
                .zIndex(1)

            Group {
                if viewModel.isLoadingLyricCatalog, viewModel.lyricCatalog == nil {
                    ProgressView("Loading slides from Lyriora…")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if let catalog = viewModel.lyricCatalog {
                    catalogContent(catalog)
                } else {
                    unavailableState
                }
            }
        }
        .background(DAWTheme.background)
        .dawGlassBorder(cornerRadius: DAWGlassChrome.windowCornerRadius, lineWidth: 1.25)
        .preferredColorScheme(.dark)
        .task {
            await viewModel.refreshLyricCatalog()
        }
#if os(iOS)
        .presentationDragIndicator(.visible)
        .presentationCornerRadius(DAWGlassChrome.windowCornerRadius)
#endif
#if os(macOS)
        .frame(minWidth: 520, idealWidth: 640, minHeight: 560, idealHeight: 720)
#endif
    }

    private var header: some View {
        HStack(alignment: .center, spacing: 16) {
            VStack(alignment: .leading, spacing: 3) {
                Text("Assign Slide")
                    .font(.title3.bold())
                    .foregroundStyle(DAWTheme.textPrimary)

                Text(headerSubtitle)
                    .font(.caption)
                    .foregroundStyle(DAWTheme.textSecondary)
                    .lineLimit(2)
            }

            Spacer(minLength: 0)

            if liveSection.hasLyricSlideLink {
                Button("Clear Link", role: .destructive, action: clearLink)
                    .buttonStyle(DAWSecondaryButtonStyle())
            }

            Button("Close", action: dismiss.callAsFunction)
                .buttonStyle(DAWPrimaryButtonStyle())
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .dawSettingsHeaderChrome()
    }

    private var headerSubtitle: String {
        if let catalog = viewModel.lyricCatalog {
            return "\(liveSection.name) · \(catalog.lyricTitle) · \(catalog.slides.count) slides"
        }
        return "Link a Lyriora slide to \(liveSection.name)"
    }

    private func catalogContent(_ catalog: LyricSlideCatalog) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 14) {
                Text("Tap a card to assign it to \(liveSection.name).")
                    .font(.caption)
                    .foregroundStyle(DAWTheme.textSecondary)

                LyricSlidePickerList(
                    viewModel: viewModel,
                    sectionID: section.id,
                    catalog: catalog
                )
            }
            .padding(16)
        }
        .scrollContentBackground(.hidden)
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

    private func clearLink() {
        viewModel.clearLyricSlideLink(for: section.id)
    }
}
