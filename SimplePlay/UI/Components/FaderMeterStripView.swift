//
//  FaderMeterStripView.swift
//  SimplePlay
//

import SwiftUI

/// Volume fader with a vertical LED meter placed side-by-side.
struct FaderMeterStripView: View {
    @Binding var value: Double
    let level: Float
    let isAudible: Bool
    var faderWidth: CGFloat = 24
    var faderHeight: CGFloat = 120
    var valueRange: ClosedRange<Double> = TrackVolumeSettings.trackRange
    var segmentCount: Int = 10
    var dotSize: CGFloat = 5

    private var showsUnityMark: Bool {
        usesUnityCenterDecibelScale || valueRange.upperBound > TrackVolumeSettings.unityLinear + 0.001
    }

    private var usesUnityCenterDecibelScale: Bool {
        valueRange.upperBound > TrackVolumeSettings.unityLinear + 0.001
    }

    var body: some View {
        HStack(alignment: .bottom, spacing: 3) {
            DAWVerticalFaderView(
                value: $value,
                accentColor: DAWTheme.faderFill,
                width: faderWidth,
                height: faderHeight,
                valueRange: valueRange,
                showsValueLabel: false,
                showsUnityMark: showsUnityMark,
                usesUnityCenterDecibelScale: usesUnityCenterDecibelScale
            )

            TrackMeterIndicatorView(
                level: level,
                isAudible: isAudible,
                segmentCount: segmentCount,
                dotSize: dotSize
            )
            .frame(width: dotSize + 4, height: faderHeight)
        }
        .frame(height: faderHeight, alignment: .bottom)
    }
}
