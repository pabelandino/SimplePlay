//
//  WaveformClipView.swift
//  SimplePlay
//

import SwiftUI

struct WaveformClipView: View {
    let clip: AudioClip
    let trackID: UUID
    let trackColor: Color
    let pixelsPerSecond: CGFloat
    let isSelected: Bool
    var clipHeight: CGFloat = DAWTheme.trackRowHeight - 16
    var isTimelineScrolling = false

    @State private var peaks: [Float] = []
    @State private var isLoading = false
    @State private var loadedLOD = 0
    @State private var loadGeneration = 0
    @State private var deferredLOD: Int?

    private var clipWidth: CGFloat {
        max(48, CGFloat(clip.duration) * pixelsPerSecond)
    }

    private var requiredLOD: Int {
        WaveformLOD.loadBucket(for: clipWidth)
    }

    var body: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 8)
                .fill(trackColor.opacity(0.18))
                .overlay {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(trackColor.opacity(isSelected ? 1 : 0.65), lineWidth: isSelected ? 2 : 1)
                }

            WaveformEnvelopeView(peaks: peaks, color: trackColor, isLoading: isLoading)
                .equatable()
                .padding(.horizontal, 4)
                .padding(.vertical, 6)

            Text(clip.name)
                .font(.caption2.weight(.semibold))
                .foregroundStyle(.white.opacity(0.95))
                .lineLimit(1)
                .padding(.horizontal, 8)
                .padding(.top, 4)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        }
        .frame(width: clipWidth, height: clipHeight)
        .id(clip.id)
        .task(id: clip.fileURL) {
            startLoadGeneration()
            peaks = []
            loadedLOD = 0
            isLoading = false
            await fetchPeaks(lod: requiredLOD, reportToMonitor: true)
        }
        .onChange(of: requiredLOD) { _, newLOD in
            guard newLOD > loadedLOD else { return }
            if isTimelineScrolling {
                deferredLOD = max(deferredLOD ?? 0, newLOD)
                return
            }
            scheduleLODUpgrade(to: newLOD)
        }
        .onChange(of: isTimelineScrolling) { _, isScrolling in
            guard !isScrolling, let pendingLOD = deferredLOD, pendingLOD > loadedLOD else { return }
            deferredLOD = nil
            scheduleLODUpgrade(to: pendingLOD)
        }
    }

    private func scheduleLODUpgrade(to newLOD: Int) {
        loadGeneration += 1
        let generation = loadGeneration
        Task {
            await fetchPeaks(lod: newLOD, reportToMonitor: false, expectedGeneration: generation)
        }
    }

    private func startLoadGeneration() {
        loadGeneration += 1
    }

    @MainActor
    private func fetchPeaks(
        lod: Int,
        reportToMonitor: Bool,
        expectedGeneration: Int? = nil
    ) async {
        if let expectedGeneration, expectedGeneration != loadGeneration {
            return
        }

        let generation = expectedGeneration ?? loadGeneration
        let shouldShowClipSpinner = reportToMonitor

        if reportToMonitor {
            WaveformLoadMonitor.shared.beginClip(trackID: trackID, clipID: clip.id)
        }

        if shouldShowClipSpinner {
            isLoading = true
        }

        defer {
            if shouldShowClipSpinner {
                isLoading = false
            }
            if reportToMonitor {
                WaveformLoadMonitor.shared.completeClip(trackID: trackID, clipID: clip.id)
            }
        }

        var onProgress: (@MainActor @Sendable (Double) -> Void)?
        if reportToMonitor {
            onProgress = { progress in
                WaveformLoadMonitor.shared.setClipProgress(
                    trackID: trackID,
                    clipID: clip.id,
                    progress: progress
                )
            }
        }

        do {
            let loaded = try await WaveformCache.shared.peaks(
                for: clip.fileURL,
                sampleCount: lod,
                onProgress: onProgress
            )
            guard generation == loadGeneration else { return }
            if lod >= loadedLOD {
                peaks = loaded
                loadedLOD = lod
            }
        } catch {
            guard generation == loadGeneration else { return }
            if peaks.isEmpty {
                peaks = []
            }
        }
    }
}

struct WaveformEnvelopeView: View, Equatable {
    let peaks: [Float]
    let color: Color
    let isLoading: Bool

    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.peaks == rhs.peaks
            && lhs.isLoading == rhs.isLoading
            && lhs.color == rhs.color
    }

    var body: some View {
        GeometryReader { proxy in
            Canvas { context, size in
                let renderPeaks = peaks.isEmpty && isLoading
                    ? placeholderPeaks(for: size)
                    : peaks

                guard !renderPeaks.isEmpty else { return }

                let envelope = WaveformPathBuilder.envelopePath(
                    peaks: renderPeaks,
                    size: size
                )

                context.fill(
                    envelope,
                    with: .color(color.opacity(isLoading ? 0.4 : 0.82))
                )

                context.stroke(
                    envelope,
                    with: .color(color.opacity(0.95)),
                    lineWidth: 0.6
                )
            }
        }
    }

    private func placeholderPeaks(for size: CGSize) -> [Float] {
        let count = max(120, Int(size.width))
        return (0..<count).map { index in
            let t = Float(index) / Float(max(count - 1, 1))
            return abs(sin(t * .pi * 10)) * 0.35 + 0.18
        }
    }
}

enum WaveformPathBuilder {
    static func envelopePath(peaks: [Float], size: CGSize) -> Path {
        guard peaks.count > 1, size.width > 1, size.height > 1 else { return Path() }

        let pointCount = max(peaks.count, Int(size.width))
        let midY = size.height / 2
        let verticalScale = midY * 0.94

        var path = Path()

        for index in 0..<pointCount {
            let x = CGFloat(index) / CGFloat(pointCount - 1) * size.width
            let peak = peakValue(atPixel: index, pointCount: pointCount, peaks: peaks)
            let y = midY - CGFloat(peak) * verticalScale

            if index == 0 {
                path.move(to: CGPoint(x: x, y: y))
            } else {
                path.addLine(to: CGPoint(x: x, y: y))
            }
        }

        for index in stride(from: pointCount - 1, through: 0, by: -1) {
            let x = CGFloat(index) / CGFloat(pointCount - 1) * size.width
            let peak = peakValue(atPixel: index, pointCount: pointCount, peaks: peaks)
            let y = midY + CGFloat(peak) * verticalScale
            path.addLine(to: CGPoint(x: x, y: y))
        }

        path.closeSubpath()
        return path
    }

    /// Uses max-pooling when downsampling so transients stay visible at low zoom.
    private static func peakValue(atPixel index: Int, pointCount: Int, peaks: [Float]) -> Float {
        guard peaks.count >= pointCount else {
            return interpolatedPeak(
                at: CGFloat(index) / CGFloat(max(pointCount - 1, 1)) * CGFloat(peaks.count - 1),
                peaks: peaks
            )
        }

        let start = index * peaks.count / pointCount
        let end = max(start + 1, (index + 1) * peaks.count / pointCount)
        return peaks[start..<min(end, peaks.count)].max() ?? 0
    }

    private static func interpolatedPeak(at index: CGFloat, peaks: [Float]) -> Float {
        let clampedIndex = min(max(index, 0), CGFloat(peaks.count - 1))
        let lower = Int(floor(clampedIndex))
        let upper = min(lower + 1, peaks.count - 1)
        let fraction = Float(clampedIndex - CGFloat(lower))
        return peaks[lower] + (peaks[upper] - peaks[lower]) * fraction
    }
}
