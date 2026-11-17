//
//  SectionAssignSheetView.swift
//  LvoqPlayback
//

import SwiftUI

/// Full-screen assign flow for iPhone (keeps timeline visible underneath).
struct SectionAssignSheetView: View {
    @Bindable var viewModel: WorkspaceViewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    Text(L10n.Lyric.assignEachSection)
                        .font(.caption)
                        .foregroundStyle(DAWTheme.textSecondary)

                    lyricStatusBanner

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(viewModel.project.sections) { section in
                                SectionAssignCardView(section: section, viewModel: viewModel)
                            }
                        }
                        .padding(.vertical, 2)
                    }
                }
                .padding(16)
            }
            .background(DAWTheme.background)
            .navigationTitle(L10n.Lyric.assignSections)
#if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
#endif
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(L10n.Common.done) {
                        viewModel.setMIDIMappingAssignModeEnabled(false)
                        dismiss()
                    }
                    .fontWeight(.semibold)
                }
                ToolbarItem(placement: .primaryAction) {
                    Button(L10n.Common.refresh) {
                        Task { await viewModel.refreshLyricCatalog() }
                    }
                    .disabled(viewModel.isLoadingLyricCatalog)
                }
            }
        }
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
        .sheet(isPresented: $viewModel.isSectionLyricLinkSheetPresented, onDismiss: {
            viewModel.sectionIDForLyricLink = nil
        }) {
            if let section = viewModel.sectionForLyricLink {
                SectionLyricLinkSheet(viewModel: viewModel, section: section)
            }
        }
        .task {
            await viewModel.refreshLyricCatalog()
        }
    }

    @ViewBuilder
    private var lyricStatusBanner: some View {
        HStack(spacing: 8) {
            Circle()
                .fill(viewModel.isLvoqShowReachable ? Color.green : Color.red)
                .frame(width: 7, height: 7)

            if viewModel.isLoadingLyricCatalog {
                Text(L10n.Lyric.loading)
            } else if let catalog = viewModel.lyricCatalog {
                Text(L10n.Lyric.slidesCount(catalog.slides.count, title: catalog.lyricTitle))
            } else {
                Text(viewModel.lyricSyncErrorMessage ?? L10n.Lyric.notOnNetwork)
            }

            Spacer(minLength: 0)
        }
        .font(.caption2)
        .foregroundStyle(DAWTheme.textSecondary)
        .padding(.horizontal, 10)
        .padding(.vertical, 8)
        .background(DAWTheme.surfaceElevated)
        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
    }
}

private struct SectionAssignCardView: View {
    let section: ArrangementSection
    @Bindable var viewModel: WorkspaceViewModel

    var body: some View {
        VStack(spacing: 0) {
            Button {
                viewModel.triggerSection(section)
            } label: {
                HStack(spacing: 8) {
                    Circle().fill(section.color).frame(width: 8, height: 8)
                    Text(section.name)
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(DAWTheme.textPrimary)
                        .lineLimit(1)
                    Spacer(minLength: 0)
                    Image(systemName: "play.fill")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(DAWTheme.textSecondary)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 10)
            }
            .buttonStyle(.plain)

            Rectangle().fill(DAWTheme.border).frame(height: 1)

            Button {
                if viewModel.midiLearnTarget == .section(section.id) {
                    viewModel.cancelMIDILearn()
                } else {
                    viewModel.startMIDILearn(for: .section(section.id))
                }
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: "pianokeys")
                        .font(.caption2)
                    Text(midiLabel)
                        .font(.caption2.weight(.semibold))
                        .lineLimit(1)
                    Spacer(minLength: 0)
                }
                .foregroundStyle(
                    viewModel.midiLearnTarget == .section(section.id)
                        ? DAWTheme.accent
                        : DAWTheme.textSecondary
                )
                .padding(.horizontal, 12)
                .padding(.vertical, 10)
            }
            .buttonStyle(.plain)

            Rectangle().fill(DAWTheme.border).frame(height: 1)

            Button {
                viewModel.presentLyricLinkSheet(for: section.id)
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: "text.below.photo")
                        .font(.caption2.weight(.semibold))
                        .foregroundStyle(section.hasLyricSlideLink ? DAWTheme.playhead : DAWTheme.textSecondary)

                    Text(slideLabel)
                        .font(.caption2.weight(.semibold))
                        .foregroundStyle(section.hasLyricSlideLink ? DAWTheme.textPrimary : DAWTheme.textSecondary)
                        .lineLimit(3)
                        .multilineTextAlignment(.leading)

                    Spacer(minLength: 0)

                    Text(section.hasLyricSlideLink ? L10n.Common.change : L10n.Lyric.slideShort)
                        .font(.caption2.weight(.bold))
                        .foregroundStyle(DAWTheme.textSecondary)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 10)
            }
            .buttonStyle(.plain)
        }
        .frame(width: 168)
        .background(DAWTheme.surfaceElevated)
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .stroke(DAWTheme.border, lineWidth: 1)
        }
    }

    private var midiLabel: String {
        if viewModel.midiLearnTarget == .section(section.id) {
            return L10n.MIDI.listening
        }
        return MIDINoteAssignment(
            note: section.midiNote,
            channel: section.midiChannel,
            usesControlChange: section.midiUsesControlChange
        ).displayName
    }

    private var slideLabel: String {
        if viewModel.isLoadingLyricCatalog {
            return L10n.Lyric.loadingShort
        }
        guard viewModel.lyricCatalog != nil else {
            return L10n.Lyric.unavailable
        }
        return viewModel.lyricSlideLabel(for: section, catalog: viewModel.lyricCatalog)
    }
}
