//
//  AudioDropOverlay.swift
//  LvoqPlayback
//

import SwiftUI

struct AudioDropOverlay: View {
    var message: String = L10n.Import.drop

    var body: some View {
        ZStack {
            DAWTheme.accent.opacity(0.12)

            RoundedRectangle(cornerRadius: 16)
                .strokeBorder(DAWTheme.accent, style: StrokeStyle(lineWidth: 2, dash: [8, 6]))
                .padding(24)

            VStack(spacing: 12) {
                Image(systemName: "arrow.down.doc.fill")
                    .font(.system(size: 36))
                    .foregroundStyle(DAWTheme.accent)

                Text(message)
                    .font(.headline)
                    .foregroundStyle(DAWTheme.textPrimary)

                Text(L10n.Import.formats)
                    .font(.caption)
                    .foregroundStyle(DAWTheme.textSecondary)
            }
            .padding(32)
        }
        .allowsHitTesting(false)
        .transition(.opacity)
    }
}

struct TimelineEmptyDropHint: View {
    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: "waveform.path")
                .font(.title)
                .foregroundStyle(DAWTheme.textSecondary)
            Text(L10n.Import.dragStems)
                .font(.subheadline.weight(.medium))
                .foregroundStyle(DAWTheme.textSecondary)
            Text(L10n.Import.orToolbar)
                .font(.caption)
                .foregroundStyle(DAWTheme.textSecondary.opacity(0.8))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .allowsHitTesting(false)
    }
}
