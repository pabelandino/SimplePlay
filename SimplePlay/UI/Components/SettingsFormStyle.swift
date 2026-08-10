//
//  SettingsFormStyle.swift
//  SimplePlay
//

import SwiftUI

struct SettingsFieldLabel<Content: View>: View {
    let title: String
    @ViewBuilder var content: () -> Content

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.caption.weight(.semibold))
                .foregroundStyle(DAWTheme.textSecondary)
            content()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct SettingsControlSurface<Content: View>: View {
    @ViewBuilder var content: () -> Content

    var body: some View {
        content()
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .frame(maxWidth: .infinity, alignment: .leading)
            .dawSettingsControlGlass()
    }
}

struct SettingsMenuRow<Selection: Hashable>: View {
    let title: String
    let options: [(Selection, String)]
    @Binding var selection: Selection

    private var selectedTitle: String {
        options.first(where: { $0.0 == selection })?.1 ?? "—"
    }

    var body: some View {
        SettingsFieldLabel(title: title) {
            Menu {
                ForEach(options, id: \.0) { option in
                    Button {
                        selection = option.0
                    } label: {
                        if selection == option.0 {
                            Label(option.1, systemImage: "checkmark")
                        } else {
                            Text(option.1)
                        }
                    }
                }
            } label: {
                SettingsControlSurface {
                    HStack(spacing: 8) {
                        Text(selectedTitle)
                            .font(.subheadline.weight(.medium))
                            .foregroundStyle(DAWTheme.textPrimary)
                            .lineLimit(1)
                        Spacer(minLength: 0)
                        Image(systemName: "chevron.up.chevron.down")
                            .font(.caption2.weight(.semibold))
                            .foregroundStyle(DAWTheme.textSecondary)
                    }
                }
            }
        }
    }
}

struct SettingsTextInput: View {
    let title: String
    @Binding var text: String
    var prompt: String = ""

    var body: some View {
        SettingsFieldLabel(title: title) {
            TextField(prompt, text: $text)
                .textFieldStyle(.plain)
                .font(.subheadline)
                .foregroundStyle(DAWTheme.textPrimary)
                .padding(.horizontal, 12)
                .padding(.vertical, 10)
                .dawSettingsControlGlass()
        }
    }
}

struct SettingsNumberInput: View {
    let title: String
    @Binding var value: Double

    var body: some View {
        SettingsFieldLabel(title: title) {
            TextField(title, value: $value, format: .number)
                .textFieldStyle(.plain)
                .font(.system(.subheadline, design: .monospaced))
                .foregroundStyle(DAWTheme.textPrimary)
                .padding(.horizontal, 12)
                .padding(.vertical, 10)
                .dawSettingsControlGlass()
#if os(iOS)
                .keyboardType(.decimalPad)
#endif
        }
    }
}

struct SettingsValueRow: View {
    let title: String
    let value: String
    var valueColor: Color = DAWTheme.textSecondary
    var monospaced = false

    var body: some View {
        HStack {
            Text(title)
                .font(.subheadline)
                .foregroundStyle(DAWTheme.textSecondary)
            Spacer(minLength: 8)
            Text(value)
                .font(monospaced ? .system(.subheadline, design: .monospaced) : .subheadline.weight(.medium))
                .foregroundStyle(valueColor)
                .multilineTextAlignment(.trailing)
        }
    }
}

struct SettingsToggleRow: View {
    let title: String
    @Binding var isOn: Bool

    var body: some View {
        Toggle(isOn: $isOn) {
            Text(title)
                .font(.subheadline)
                .foregroundStyle(DAWTheme.textPrimary)
        }
        .tint(DAWTheme.accent)
    }
}

struct SettingsSectionHeader: View {
    let title: String
    let icon: String

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .font(.caption.weight(.bold))
                .foregroundStyle(DAWTheme.accent)
                .frame(width: 28, height: 28)
                .background(DAWTheme.accent.opacity(0.14))
                .clipShape(RoundedRectangle(cornerRadius: 7, style: .continuous))

            Text(title)
                .font(.subheadline.weight(.bold))
                .foregroundStyle(DAWTheme.textPrimary)
        }
    }
}

struct SettingsFootnote: View {
    let text: String

    var body: some View {
        Text(text)
            .font(.caption)
            .foregroundStyle(DAWTheme.textSecondary)
            .fixedSize(horizontal: false, vertical: true)
    }
}

struct SettingsBadge: View {
    let text: String
    var isHighlighted = false

    var body: some View {
        Text(text)
            .font(.caption.weight(.semibold))
            .foregroundStyle(isHighlighted ? DAWTheme.accent : DAWTheme.textSecondary)
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .glassEffect(
                isHighlighted
                    ? .regular.tint(DAWTheme.accent.opacity(0.12))
                    : DAWGlassChrome.controlGlass,
                in: .capsule
            )
            .overlay {
                Capsule()
                    .stroke(DAWGlassChrome.borderGradient(), lineWidth: 0.75)
            }
    }
}
