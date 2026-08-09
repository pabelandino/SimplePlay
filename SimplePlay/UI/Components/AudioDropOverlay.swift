//
//  AudioDropOverlay.swift
//  SimplePlay
//

import SwiftUI

struct AudioDropOverlay: View {
    var message: String = "Drop audio files or folders to import"

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

                Text("WAV · AIFF · MP3 · M4A")
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
            Text("Drag and drop stems here")
                .font(.subheadline.weight(.medium))
                .foregroundStyle(DAWTheme.textSecondary)
            Text("Or use Import in the toolbar")
                .font(.caption)
                .foregroundStyle(DAWTheme.textSecondary.opacity(0.8))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .allowsHitTesting(false)
    }
}
