//
//  PanKnobView.swift
//  SimplePlay
//

import SwiftUI

struct PanKnobView: View {
    @Binding var pan: Double
    @State private var dragStartPan: Double?

    var body: some View {
        ZStack {
            Circle()
                .fill(DAWTheme.surfaceElevated)
                .overlay {
                    Circle()
                        .stroke(DAWTheme.border, lineWidth: 1)
                }

            Rectangle()
                .fill(DAWTheme.accent)
                .frame(width: 2, height: 7)
                .offset(y: -4)
                .rotationEffect(.degrees(pan * 135))
        }
        .frame(width: 22, height: 22)
        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged { value in
                    if dragStartPan == nil {
                        dragStartPan = pan
                    }
                    let delta = value.translation.width / 60
                    pan = min(1, max(-1, (dragStartPan ?? pan) + delta))
                }
                .onEnded { _ in
                    dragStartPan = nil
                }
        )
        .help("Pan")
    }
}

struct TrackControlButton: View {
    let title: String
    let isActive: Bool
    let activeColor: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.caption2.weight(.bold))
                .foregroundStyle(isActive ? .black : DAWTheme.textSecondary)
                .frame(width: 20, height: 18)
                .background(isActive ? activeColor : DAWTheme.surfaceElevated)
                .clipShape(RoundedRectangle(cornerRadius: 4))
        }
        .buttonStyle(.plain)
    }
}
