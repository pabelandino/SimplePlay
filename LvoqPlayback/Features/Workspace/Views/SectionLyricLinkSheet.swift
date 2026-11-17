//
//  SectionLyricLinkSheet.swift
//  LvoqPlayback
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
                    ProgressView(L10n.Lyric.loading)
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
                Text(L10n.Lyric.assignSlide)
                    .font(.title3.bold())
                    .foregroundStyle(DAWTheme.textPrimary)

                Text(headerSubtitle)
                    .font(.caption)
                    .foregroundStyle(DAWTheme.textSecondary)
                    .lineLimit(2)
            }

            Spacer(minLength: 0)

            if liveSection.hasLyricSlideLink {
                Button(L10n.Lyric.clearLink, role: .destructive, action: clearLink)
                    .buttonStyle(DAWSecondaryButtonStyle())
            }

            Button(L10n.Common.close, action: dismiss.callAsFunction)
                .buttonStyle(DAWPrimaryButtonStyle())
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .dawSettingsHeaderChrome()
    }

    private var headerSubtitle: String {
        if let catalog = viewModel.lyricCatalog {
            return L10n.Lyric.header(section: liveSection.name, title: catalog.lyricTitle, count: catalog.slides.count)
        }
        return L10n.Lyric.linkToSection(liveSection.name)
    }

    private func catalogContent(_ catalog: LyricSlideCatalog) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 14) {
                Text(L10n.Lyric.tapCard(liveSection.name))
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
            Label(L10n.Lyric.notFound, systemImage: "wifi.exclamationmark")
        } description: {
            Text(viewModel.lyricSyncErrorMessage ?? L10n.Lyric.notFoundBody)
        } actions: {
            Button(L10n.Common.retry) {
                Task { await viewModel.refreshLyricCatalog() }
            }
            .buttonStyle(DAWPrimaryButtonStyle())
        }
    }

    private func clearLink() {
        viewModel.clearLyricSlideLink(for: section.id)
    }
}
