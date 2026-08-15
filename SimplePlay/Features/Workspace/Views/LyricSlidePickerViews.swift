//
//  LyricSlidePickerViews.swift
//  SimplePlay
//

import SwiftUI

enum LyricSlideAssignmentState: Equatable {
    case available
    case selectedHere
    case usedByOtherSection(String)
}

struct LyricSlidePickerRow: View {
    let slide: LyricSlideCatalogItem
    let assignment: LyricSlideAssignmentState
    var isCompact: Bool = false
    let onSelect: () -> Void

    private var previewText: String {
        let trimmed = slide.displayText.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty ? "Slide \(slide.order + 1)" : trimmed
    }

    var body: some View {
        Button(action: onSelect) {
            HStack(alignment: .top, spacing: isCompact ? 8 : 10) {
                slideNumberBadge

                VStack(alignment: .leading, spacing: isCompact ? 4 : 6) {
                    Text(previewText)
                        .font(.system(size: isCompact ? 11 : 12))
                        .foregroundStyle(DAWTheme.textPrimary)
                        .multilineTextAlignment(.leading)
                        .lineSpacing(isCompact ? 2 : 3)
                        .fixedSize(horizontal: false, vertical: true)

                    HStack(spacing: 6) {
                        if !slide.tag.isEmpty, slide.tag != "unknown" {
                            Text(slide.tag.capitalized)
                                .font(.caption2.weight(.medium))
                                .foregroundStyle(DAWTheme.textSecondary)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(DAWTheme.background.opacity(0.55))
                                .clipShape(Capsule())
                        }

                        assignmentBadge
                    }
                }

                Spacer(minLength: 0)

                selectionIndicator
            }
            .padding(.horizontal, isCompact ? 10 : 12)
            .padding(.vertical, isCompact ? 8 : 10)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(rowBackground)
            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .stroke(rowBorder, lineWidth: assignment == .selectedHere ? 1.5 : 1)
            }
        }
        .buttonStyle(.plain)
    }

    private var slideNumberBadge: some View {
        Text("\(slide.order + 1)")
            .font(.caption2.weight(.bold).monospacedDigit())
            .foregroundStyle(DAWTheme.textPrimary)
            .frame(width: isCompact ? 22 : 26, height: isCompact ? 22 : 26)
            .background(DAWTheme.surfaceElevated)
            .clipShape(RoundedRectangle(cornerRadius: 6, style: .continuous))
    }

    @ViewBuilder
    private var assignmentBadge: some View {
        switch assignment {
        case .available:
            EmptyView()
        case .selectedHere:
            Label("This section", systemImage: "checkmark.circle.fill")
                .font(.caption2.weight(.semibold))
                .foregroundStyle(.green)
        case .usedByOtherSection(let name):
            Label("In \(name)", systemImage: "link.circle.fill")
                .font(.caption2.weight(.semibold))
                .foregroundStyle(DAWTheme.accent)
                .lineLimit(1)
        }
    }

    @ViewBuilder
    private var selectionIndicator: some View {
        switch assignment {
        case .selectedHere:
            Image(systemName: "checkmark.circle.fill")
                .font(.body.weight(.semibold))
                .foregroundStyle(.green)
        case .usedByOtherSection:
            Image(systemName: "arrow.right.circle")
                .font(.caption.weight(.semibold))
                .foregroundStyle(DAWTheme.textSecondary)
        case .available:
            Image(systemName: "plus.circle")
                .font(.caption.weight(.semibold))
                .foregroundStyle(DAWTheme.textSecondary.opacity(0.8))
        }
    }

    private var rowBackground: Color {
        switch assignment {
        case .selectedHere:
            return Color.green.opacity(0.1)
        case .usedByOtherSection:
            return DAWTheme.accent.opacity(0.08)
        case .available:
            return DAWTheme.surfaceElevated.opacity(0.85)
        }
    }

    private var rowBorder: Color {
        switch assignment {
        case .selectedHere:
            return Color.green.opacity(0.55)
        case .usedByOtherSection:
            return DAWTheme.accent.opacity(0.35)
        case .available:
            return DAWTheme.border
        }
    }
}

struct LyricSlidePickerList: View {
    @Bindable var viewModel: WorkspaceViewModel
    let section: ArrangementSection
    let catalog: LyricSlideCatalog
    var isCompact: Bool = false
    var onAssigned: (() -> Void)?

    var body: some View {
        VStack(spacing: isCompact ? 6 : 8) {
            ForEach(catalog.slides) { slide in
                LyricSlidePickerRow(
                    slide: slide,
                    assignment: viewModel.lyricSlideAssignmentState(
                        slide: slide,
                        for: section.id
                    ),
                    isCompact: isCompact
                ) {
                    viewModel.assignLyricSlide(
                        sectionID: section.id,
                        slide: slide,
                        catalog: catalog
                    )
                    onAssigned?()
                }
            }
        }
    }
}
