//
//  DAWGlassChrome.swift
//  SimplePlay
//

import SwiftUI

enum DAWGlassChrome {
    static let windowCornerRadius: CGFloat = 20
    static let panelCornerRadius: CGFloat = 14
    static let controlCornerRadius: CGFloat = 8

    static var panelGlass: Glass {
        .regular.tint(DAWTheme.surface.opacity(0.16))
    }

    static var controlGlass: Glass {
        .clear.tint(DAWTheme.background.opacity(0.28))
    }

    static func headerBlurBackground() -> some View {
        ZStack {
            Rectangle()
                .fill(.regularMaterial)

            LinearGradient(
                colors: [
                    DAWTheme.surface.opacity(0.88),
                    DAWTheme.surface.opacity(0.74)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
        }
    }

    static func borderGradient(opacity: Double = 1) -> LinearGradient {
        LinearGradient(
            colors: [
                Color.white.opacity(0.26 * opacity),
                Color.white.opacity(0.07 * opacity),
                DAWTheme.border.opacity(0.95 * opacity)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}

extension View {
    func dawGlassBorder(cornerRadius: CGFloat, lineWidth: CGFloat = 1) -> some View {
        overlay {
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .stroke(DAWGlassChrome.borderGradient(), lineWidth: lineWidth)
        }
    }

    func dawSettingsPanelGlass() -> some View {
        glassEffect(
            DAWGlassChrome.panelGlass,
            in: .rect(cornerRadius: DAWGlassChrome.panelCornerRadius, style: .continuous)
        )
        .dawGlassBorder(cornerRadius: DAWGlassChrome.panelCornerRadius)
    }

    func dawSettingsControlGlass() -> some View {
        glassEffect(
            DAWGlassChrome.controlGlass,
            in: .rect(cornerRadius: DAWGlassChrome.controlCornerRadius, style: .continuous)
        )
        .dawGlassBorder(cornerRadius: DAWGlassChrome.controlCornerRadius, lineWidth: 0.75)
    }

    func dawSettingsHeaderChrome() -> some View {
        background {
            DAWGlassChrome.headerBlurBackground()
        }
        .overlay(alignment: .bottom) {
            Rectangle()
                .fill(DAWGlassChrome.borderGradient(opacity: 0.8))
                .frame(height: 1)
        }
        .compositingGroup()
    }
}
