//
//  WaveformClipPeakStore.swift
//  SimplePlay
//

import Foundation

/// In-memory peak cache keyed by audio file so clip views keep waveforms across SwiftUI rebuilds.
@MainActor
enum WaveformClipPeakStore {
    private static var peaksByURL: [URL: [Int: [Float]]] = [:]
    private static var fileDurationByURL: [URL: TimeInterval] = [:]

    static func fileDuration(for url: URL) -> TimeInterval? {
        fileDurationByURL[url]
    }

    static func setFileDuration(_ duration: TimeInterval, for url: URL) {
        guard duration > 0 else { return }
        fileDurationByURL[url] = duration
    }

    static func peaks(for url: URL, lod: Int) -> [Float]? {
        peaksByURL[url]?[lod]
    }

    static func bestPeaks(for url: URL, minimumLOD: Int) -> (lod: Int, peaks: [Float])? {
        guard let byLOD = peaksByURL[url], !byLOD.isEmpty else { return nil }

        if let exact = byLOD[minimumLOD] {
            return (minimumLOD, exact)
        }

        if let best = byLOD.filter({ $0.key >= minimumLOD }).max(by: { $0.key < $1.key }) {
            return (best.key, best.value)
        }

        if let fallback = byLOD.max(by: { $0.key < $1.key }) {
            return (fallback.key, fallback.value)
        }

        return nil
    }

    static func store(peaks: [Float], for url: URL, lod: Int) {
        guard !peaks.isEmpty else { return }
        var byLOD = peaksByURL[url] ?? [:]
        byLOD[lod] = peaks
        peaksByURL[url] = byLOD
    }

    static func reset() {
        peaksByURL.removeAll()
        fileDurationByURL.removeAll()
    }
}
