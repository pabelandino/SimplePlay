//
//  PitchShiftSettings.swift
//  SimplePlay
//

import AVFoundation
import Foundation

enum PitchShiftSettings {
    static let minSemitones: Double = -5
    static let maxSemitones: Double = 5
    static let qualityOverlap: Float = 12

    static func clampSemitones(_ value: Double) -> Double {
        min(maxSemitones, max(minSemitones, value))
    }

    static func cents(from semitones: Double) -> Float {
        Float(semitones * 100)
    }

    static func apply(semitones: Double, to unit: AVAudioUnitTimePitch) {
        unit.rate = 1.0
        unit.pitch = cents(from: clampSemitones(semitones))
        unit.overlap = qualityOverlap
    }
}

extension DAWProject {
    func pitchSemitones(forTrackID trackID: UUID) -> Double {
        tracks.first(where: { $0.id == trackID })?.pitchSemitones ?? 0
    }

    func track(containing clipID: UUID) -> AudioTrack? {
        tracks.first { track in
            track.clips.contains { $0.id == clipID }
        }
    }

    func pitchSemitones(forGroupIndex index: Int) -> Double {
        guard groups.indices.contains(index) else { return 0 }
        return groups[index].pitchSemitones
    }

    func group(containing clip: AudioClip) -> TrackGroup? {
        guard groups.indices.contains(clip.groupIndex) else { return nil }
        return groups[clip.groupIndex]
    }

    func group(id: UUID) -> TrackGroup? {
        groups.first { $0.id == id }
    }

    func primaryGroupID(for track: AudioTrack) -> UUID? {
        guard let index = track.clips.first?.groupIndex,
              groups.indices.contains(index) else { return nil }
        return groups[index].id
    }

    func tracks(forGroupIndex index: Int) -> [AudioTrack] {
        guard groups.indices.contains(index) else { return [] }
        return tracks.filter { track in
            track.clips.contains { $0.groupIndex == index }
        }
    }
}
