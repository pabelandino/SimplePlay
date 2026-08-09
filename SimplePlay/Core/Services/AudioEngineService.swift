//
//  AudioEngineService.swift
//  SimplePlay
//

import AVFoundation
import Foundation
import Observation

#if os(macOS)
import CoreAudio
#endif

enum AudioEngineError: LocalizedError {
    case deviceSelectionFailed
    case engineStartFailed

    var errorDescription: String? {
        switch self {
        case .deviceSelectionFailed: "Could not select the audio output device."
        case .engineStartFailed: "Could not start the audio engine."
        }
    }
}

private struct ScheduledClip {
    let clip: AudioClip
    let trackID: UUID
    let file: AVAudioFile
    let player: AVAudioPlayerNode
}

/// Multi-track audio playback engine built on AVAudioEngine.
@MainActor
@Observable
final class AudioEngineService {
    private let engine = AVAudioEngine()
    private let mainMixer = AVAudioMixerNode()
    private var trackMixers: [UUID: AVAudioMixerNode] = [:]
    private var scheduledClips: [UUID: ScheduledClip] = [:]

    private(set) var isEngineRunning = false
    private(set) var playbackStartTime: TimeInterval = 0

    var masterVolume: Double = 1.0 {
        didSet { mainMixer.outputVolume = Float(masterVolume) }
    }

    init() {
        engine.attach(mainMixer)
        engine.connect(mainMixer, to: engine.outputNode, format: nil)
    }

    func configure(project: DAWProject) throws {
        stop()
        tearDownPlayers()
        try apply(settings: project.audioSettings)

        for track in project.tracks {
            let trackMixer = AVAudioMixerNode()
            engine.attach(trackMixer)
            engine.connect(trackMixer, to: mainMixer, format: nil)
            trackMixers[track.id] = trackMixer

            for clip in track.clips {
                let file = try AVAudioFile(forReading: clip.fileURL)
                let player = AVAudioPlayerNode()
                engine.attach(player)
                engine.connect(player, to: trackMixer, format: file.processingFormat)

                scheduledClips[clip.id] = ScheduledClip(
                    clip: clip,
                    trackID: track.id,
                    file: file,
                    player: player
                )
            }
        }

        updateTrackMixing(project: project)

        if !isEngineRunning {
            try engine.start()
            isEngineRunning = true
        }
    }

    func apply(settings: AudioSettings) throws {
#if os(macOS)
        if let deviceID = settings.outputDeviceID, deviceID != 0 {
            try setDefaultOutputDevice(deviceID)
        }
#else
        try configureAudioSession(sampleRate: settings.sampleRate)
#endif
    }

    func updateTrackMixing(project: DAWProject) {
        let hasSolo = project.tracks.contains(where: \.isSolo)

        for track in project.tracks {
            guard let mixer = trackMixers[track.id] else { continue }
            mixer.pan = Float(track.pan)
            let effectivelyMuted = track.isMuted || (hasSolo && !track.isSolo)
            mixer.outputVolume = effectivelyMuted ? 0 : 1
        }
    }

    /// Starts playback from the given timeline position (playhead).
    func play(from time: TimeInterval, project: DAWProject) {
        playbackStartTime = max(0, time)

        for scheduled in scheduledClips.values {
            scheduled.player.stop()
            if shouldPlayClip(scheduled.clip, at: playbackStartTime) {
                scheduleClip(scheduled, from: playbackStartTime)
                scheduled.player.play()
            }
        }
    }

    func pause() {
        for scheduled in scheduledClips.values {
            scheduled.player.pause()
        }
    }

    func stop() {
        playbackStartTime = 0
        for scheduled in scheduledClips.values {
            scheduled.player.stop()
        }
    }

    private func shouldPlayClip(_ clip: AudioClip, at playheadTime: TimeInterval) -> Bool {
        playheadTime < clip.endTime
    }

    private func scheduleClip(_ scheduled: ScheduledClip, from playheadTime: TimeInterval) {
        let clip = scheduled.clip
        let file = scheduled.file
        let player = scheduled.player
        let sampleRate = file.processingFormat.sampleRate

        if playheadTime <= clip.startTime {
            let startFrame = AVAudioFramePosition(clip.sourceOffset * sampleRate)
            let frameCount = AVAudioFrameCount(clip.duration * sampleRate)
            let delaySeconds = clip.startTime - playheadTime
            let when = AVAudioTime(
                sampleTime: AVAudioFramePosition(delaySeconds * sampleRate),
                atRate: sampleRate
            )

            player.scheduleSegment(
                file,
                startingFrame: startFrame,
                frameCount: frameCount,
                at: when
            )
            return
        }

        let elapsedInClip = playheadTime - clip.startTime
        guard elapsedInClip < clip.duration else { return }

        let sourceStart = clip.sourceOffset + elapsedInClip
        let remainingDuration = clip.duration - elapsedInClip
        let startFrame = AVAudioFramePosition(sourceStart * sampleRate)
        let frameCount = AVAudioFrameCount(remainingDuration * sampleRate)

        player.scheduleSegment(
            file,
            startingFrame: startFrame,
            frameCount: frameCount,
            at: nil
        )
    }

    private func tearDownPlayers() {
        for scheduled in scheduledClips.values {
            engine.detach(scheduled.player)
        }
        for (_, mixer) in trackMixers {
            engine.detach(mixer)
        }
        scheduledClips.removeAll()
        trackMixers.removeAll()
    }

#if os(macOS)
    private func setDefaultOutputDevice(_ deviceID: UInt32) throws {
        var device = deviceID
        var propertyAddress = AudioObjectPropertyAddress(
            mSelector: kAudioHardwarePropertyDefaultOutputDevice,
            mScope: kAudioObjectPropertyScopeGlobal,
            mElement: kAudioObjectPropertyElementMain
        )

        let status = AudioObjectSetPropertyData(
            AudioObjectID(kAudioObjectSystemObject),
            &propertyAddress,
            0,
            nil,
            UInt32(MemoryLayout<AudioDeviceID>.size),
            &device
        )

        guard status == noErr else {
            throw AudioEngineError.deviceSelectionFailed
        }
    }
#else
    private func configureAudioSession(sampleRate: AudioSampleRate) throws {
        let session = AVAudioSession.sharedInstance()
        try session.setCategory(.playback, mode: .default, options: [])
        try session.setPreferredSampleRate(sampleRate.rawValue)
        try session.setActive(true)
    }
#endif
}
