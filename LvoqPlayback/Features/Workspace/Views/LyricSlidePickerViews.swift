//
//  LyricSlidePickerViews.swift
//  LvoqPlayback
//

import SwiftUI

struct LyricSlideUsage: Equatable, Identifiable, Hashable {
    let id: UUID
    let name: String
}

struct LyricSlideAssignmentState: Equatable {
    let isSelectedHere: Bool
    let usages: [LyricSlideUsage]

    var isAvailable: Bool { usages.isEmpty }
}

enum LyricSlideAssignment {
    static func state(
        slideID: UUID,
        currentSectionID: UUID,
        sections: [ArrangementSection],
        catalogLinkedSectionID: UUID? = nil
    ) -> LyricSlideAssignmentState {
        var seen = Set<UUID>()
        var usages: [LyricSlideUsage] = []

        for section in sections where section.lyricSlideID == slideID {
            guard seen.insert(section.id).inserted else { continue }
            usages.append(LyricSlideUsage(id: section.id, name: section.name))
        }

        if let catalogLinkedSectionID,
           seen.insert(catalogLinkedSectionID).inserted,
           let extra = sections.first(where: { $0.id == catalogLinkedSectionID }) {
            usages.append(LyricSlideUsage(id: extra.id, name: extra.name))
        }

        return LyricSlideAssignmentState(
            isSelectedHere: usages.contains(where: { $0.id == currentSectionID }),
            usages: usages
        )
    }
}

struct LyricSlidePickerCard: View {
    let slide: LyricSlideCatalogItem
    let assignment: LyricSlideAssignmentState
    let onSelect: () -> Void

    private var slideText: String {
        let trimmed = slide.displayText
        return trimmed.isEmpty ? L10n.Lyric.slideNumber(slide.order + 1) : trimmed
    }

    var body: some View {
        Button(action: onSelect) {
            VStack(alignment: .leading, spacing: 10) {
                HStack(alignment: .top, spacing: 10) {
                    Text("\(slide.order + 1)")
                        .font(.caption.bold().monospacedDigit())
                        .foregroundStyle(DAWTheme.textPrimary)
                        .frame(width: 28, height: 28)
                        .background(DAWTheme.surface)
                        .clipShape(.rect(cornerRadius: 7))

                    if !slide.tag.isEmpty, slide.tag != "unknown" {
                        Text(slide.tag.capitalized)
                            .font(.caption)
                            .foregroundStyle(DAWTheme.textSecondary)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 3)
                            .background(DAWTheme.background.opacity(0.55))
                            .clipShape(Capsule())
                    }

                    Spacer(minLength: 0)

                    selectionIndicator
                }

                Text(slideText)
                    .font(.body)
                    .foregroundStyle(DAWTheme.textPrimary)
                    .multilineTextAlignment(.leading)
                    .lineSpacing(4)
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(maxWidth: .infinity, alignment: .leading)

                if !assignment.usages.isEmpty {
                    usageChips
                }
            }
            .padding(14)
            .frame(maxWidth: .infinity, minHeight: 44, alignment: .topLeading)
            .background(cardBackground)
            .clipShape(.rect(cornerRadius: DAWGlassChrome.panelCornerRadius))
            .overlay {
                RoundedRectangle(cornerRadius: DAWGlassChrome.panelCornerRadius)
                    .stroke(cardBorderColor, lineWidth: assignment.isSelectedHere ? 1.5 : 1)
            }
        }
        .buttonStyle(.plain)
        .accessibilityLabel(accessibilityLabel)
    }

    @ViewBuilder
    private var selectionIndicator: some View {
        if assignment.isSelectedHere {
            Image(systemName: "checkmark.circle.fill")
                .font(.title3)
                .foregroundStyle(.green)
        } else if !assignment.usages.isEmpty {
            Image(systemName: "link.circle.fill")
                .font(.body)
                .foregroundStyle(DAWTheme.accent)
        } else {
            Image(systemName: "plus.circle")
                .font(.body)
                .foregroundStyle(DAWTheme.textSecondary)
        }
    }

    private var usageChips: some View {
        HStack(alignment: .firstTextBaseline, spacing: 6) {
            Image(systemName: "link")
                .font(.caption)
                .foregroundStyle(assignment.isSelectedHere ? Color.green : DAWTheme.accent)

            Text(assignment.usages.map(\.name).joined(separator: " · "))
                .font(.caption.bold())
                .foregroundStyle(assignment.isSelectedHere ? Color.green : DAWTheme.accent)
                .fixedSize(horizontal: false, vertical: true)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .accessibilityLabel(L10n.Lyric.usedBy(assignment.usages.map(\.name).joined(separator: ", ")))
    }

    private var cardBackground: Color {
        if assignment.isSelectedHere {
            Color.green.opacity(0.12)
        } else if !assignment.usages.isEmpty {
            DAWTheme.accent.opacity(0.1)
        } else {
            DAWTheme.surfaceElevated
        }
    }

    private var cardBorderColor: Color {
        if assignment.isSelectedHere {
            Color.green.opacity(0.55)
        } else if !assignment.usages.isEmpty {
            DAWTheme.accent.opacity(0.4)
        } else {
            DAWTheme.border.opacity(0.9)
        }
    }

    private var accessibilityLabel: String {
        if assignment.usages.isEmpty {
            return L10n.Lyric.accessibilitySlide(slide.order + 1, text: slideText)
        }
        let names = assignment.usages.map(\.name).joined(separator: ", ")
        if assignment.isSelectedHere {
            return L10n.Lyric.accessibilitySelected(slide.order + 1, names: names, text: slideText)
        }
        return L10n.Lyric.accessibilityUsed(slide.order + 1, names: names, text: slideText)
    }
}

struct LyricSlidePickerList: View {
    @Bindable var viewModel: WorkspaceViewModel
    let sectionID: UUID
    let catalog: LyricSlideCatalog

    var body: some View {
        LazyVStack(spacing: 12) {
            ForEach(catalog.slides) { slide in
                LyricSlidePickerCard(
                    slide: slide,
                    assignment: viewModel.lyricSlideAssignmentState(
                        slide: slide,
                        for: sectionID
                    ),
                    onSelect: {
                        viewModel.assignLyricSlide(
                            sectionID: sectionID,
                            slide: slide,
                            catalog: catalog
                        )
                    }
                )
            }
        }
    }
}
