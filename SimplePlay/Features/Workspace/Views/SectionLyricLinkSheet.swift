//
//  SectionLyricLinkSheet.swift
//  SimplePlay
//

import SwiftUI

struct SectionLyricLinkSheet: View {
    @Bindable var viewModel: WorkspaceViewModel
    let section: ArrangementSection

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoadingLyricCatalog {
                    ProgressView("Loading slides from Lyriora…")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if let catalog = viewModel.lyricCatalog {
                    catalogList(catalog)
                } else {
                    unavailableState
                }
            }
            .navigationTitle("Assign Lyric Slide")
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
        .frame(minWidth: 420, minHeight: 480)
        #endif
    }

    private func catalogList(_ catalog: LyricSlideCatalog) -> some View {
        List {
            Section {
                Text(catalog.lyricTitle)
                    .font(.headline)
                Text("\(catalog.slides.count) slides available")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Section("Slides") {
                ForEach(catalog.slides) { slide in
                    Button {
                        viewModel.assignLyricSlide(
                            sectionID: section.id,
                            slide: slide,
                            catalog: catalog
                        )
                        dismiss()
                    } label: {
                        HStack(spacing: 12) {
                            Text("\(slide.order + 1)")
                                .font(.caption.monospacedDigit())
                                .foregroundStyle(.secondary)
                                .frame(width: 28, alignment: .trailing)

                            VStack(alignment: .leading, spacing: 4) {
                                Text(slide.preview)
                                    .font(.body)
                                    .foregroundStyle(DAWTheme.textPrimary)
                                    .lineLimit(2)

                                if !slide.tag.isEmpty, slide.tag != "unknown" {
                                    Text(slide.tag.capitalized)
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                            }

                            Spacer()

                            if section.lyricSlideID == slide.slideID {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundStyle(.green)
                            } else if slide.linkedSectionID == section.id {
                                Image(systemName: "link.circle.fill")
                                    .foregroundStyle(.blue)
                            }
                        }
                    }
                    .buttonStyle(.plain)
                }
            }
        }
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
