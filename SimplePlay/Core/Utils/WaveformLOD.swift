//
//  WaveformLOD.swift
//  SimplePlay
//

import CoreGraphics

/// Level-of-detail selection for waveform peak data based on on-screen width.
enum WaveformLOD {
    static let minSamples = 200
    static let maxSamples = 8192

    /// Target peak count for a clip at the current zoom level (~1 peak per pixel).
    static func targetSampleCount(clipWidth: CGFloat) -> Int {
        min(maxSamples, max(minSamples, Int(ceil(clipWidth))))
    }

    /// Quantized bucket used for cache keys and incremental reloads while zooming in.
    static func loadBucket(for clipWidth: CGFloat) -> Int {
        let target = targetSampleCount(clipWidth: clipWidth)
        guard target > minSamples else { return minSamples }

        let exponent = round(log2(Double(target)))
        return min(maxSamples, max(minSamples, Int(pow(2.0, exponent))))
    }
}
