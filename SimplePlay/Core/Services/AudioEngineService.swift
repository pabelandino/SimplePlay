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
    case clipLoadFailed(name: String, reason: String)
    case noPlayableClips
    case playbackUnavailable

    var errorDescription: String? {
        switch self {
        case .deviceSelectionFailed:
            "Could not select the audio output device."
        case .engineStartFailed:
            "Could not start the audio engine."
        case .clipLoadFailed(let name, let reason):
            "Could not load “\(name)”: \(reason)"
        case .noPlayableClips:
            "No playable audio clips could be loaded."
        case .playbackUnavailable:
            "Audio playback is unavailable. Try importing tracks again."
        }
    }
}

private struct ScheduledClip {
    let clip: AudioClip
    let trackID: UUID
    let file: AVAudioFile
    let player: AVAudioPlayerNode
    let timePitch: AVAudioUnitTimePitch
}

/// Multi-track audio playback engine built on AVAudioEngine.
@MainActor
@Observable
final class AudioEngineService {
    private let engine = AVAudioEngine()
    private let mainMixer = AVAudioMixerNode()
    private var trackMixers: [UUID: AVAudioMixerNode] = [:]
    private var trackGainUnits: [UUID: AVAudioUnitEQ] = [:]
    private var groupMixers: [UUID: AVAudioMixerNode] = [:]
    private var groupGainUnits: [UUID: AVAudioUnitEQ] = [:]
    private var scheduledClips: [UUID: ScheduledClip] = [:]

    private(set) var isEngineRunning = false
    private(set) var playbackStartTime: TimeInterval = 0
    private(set) var trackMeterLevels: [UUID: Float] = [:]
    private(set) var groupMeterLevels: [UUID: Float] = [:]
    private(set) var masterMeterLevel: Float = 0
    private(set) var configurationWarnings: [String] = []
    private(set) var lastPlaybackError: String?
    private var metersInstalled = false
    private var configuredProjectClipCount = 0

    var masterVolume: Double = 1.0 {
        didSet { mainMixer.outputVolume = Float(masterVolume) }
    }

    init() {
        engine.attach(mainMixer)
        engine.connect(mainMixer, to: engine.outputNode, format: nil)
    }

    func configure(project: DAWProject) throws {
        stop()
        stopEngineIfRunning()
        tearDownPlayers()
        configurationWarnings.removeAll()
        lastPlaybackError = nil
        try apply(settings: project.audioSettings)

        for group in project.groups {
            let groupMixer = AVAudioMixerNode()
            let groupGain = AVAudioUnitEQ(numberOfBands: 1)
            groupGain.globalGain = 0

            engine.attach(groupMixer)
            engine.attach(groupGain)
            engine.connect(groupMixer, to: groupGain, format: nil)
            engine.connect(groupGain, to: mainMixer, format: nil)
            groupMixers[group.id] = groupMixer
            groupGainUnits[group.id] = groupGain
        }

        var clipLoadFailures: [String] = []

        for track in project.tracks {
            let trackMixer = AVAudioMixerNode()
            let gainUnit = AVAudioUnitEQ(numberOfBands: 1)
            gainUnit.globalGain = 0

            engine.attach(trackMixer)
            engine.attach(gainUnit)

            let destination: AVAudioNode = {
                if let groupID = project.primaryGroupID(for: track),
                   let groupMixer = groupMixers[groupID] {
                    return groupMixer
                }
                return mainMixer
            }()

            engine.connect(trackMixer, to: gainUnit, format: nil)
            engine.connect(gainUnit, to: destination, format: nil)
            trackMixers[track.id] = trackMixer
            trackGainUnits[track.id] = gainUnit

            for clip in track.clips {
                do {
                    try attachClip(clip, trackID: track.id, to: trackMixer, project: project)
                } catch {
                    let message = (error as? LocalizedError)?.errorDescription ?? error.localizedDescription
                    clipLoadFailures.append("\(clip.name): \(message)")
                }
            }
        }

        if !clipLoadFailures.isEmpty {
            configurationWarnings = clipLoadFailures
        }

        guard !scheduledClips.isEmpty || project.tracks.flatMap(\.clips).isEmpty else {
            throw AudioEngineError.noPlayableClips
        }

        updateTrackMixing(project: project)
        configuredProjectClipCount = project.tracks.reduce(0) { $0 + $1.clips.count }
        installMetersSafely()

#if os(macOS)
        do {
            try startEngine()
        } catch {
            throw AudioEngineError.engineStartFailed
        }
#else
        // Keep the engine stopped until playback on iOS/iPadOS to avoid stale graph state.
        isEngineRunning = false
#endif
    }

    var isPlaybackGraphReady: Bool {
        !scheduledClips.isEmpty
    }

    private func attachClip(
        _ clip: AudioClip,
        trackID: UUID,
        to trackMixer: AVAudioMixerNode,
        project: DAWProject
    ) throws {
        guard FileManager.default.fileExists(atPath: clip.fileURL.path) else {
            throw AudioEngineError.clipLoadFailed(
                name: clip.name,
                reason: "Audio file is missing."
            )
        }

        let file: AVAudioFile
        do {
            file = try AVAudioFile(forReading: clip.fileURL)
        } catch {
            throw AudioEngineError.clipLoadFailed(name: clip.name, reason: error.localizedDescription)
        }

        let player = AVAudioPlayerNode()
        let timePitch = AVAudioUnitTimePitch()
        PitchShiftSettings.apply(
            semitones: project.pitchSemitones(forTrackID: trackID),
            to: timePitch
        )

        engine.attach(player)
        engine.attach(timePitch)
        engine.connect(player, to: timePitch, format: file.processingFormat)
        engine.connect(timePitch, to: trackMixer, format: file.processingFormat)

        scheduledClips[clip.id] = ScheduledClip(
            clip: clip,
            trackID: trackID,
            file: file,
            player: player,
            timePitch: timePitch
        )
    }

    func meterLevel(for trackID: UUID) -> Float {
        trackMeterLevels[trackID] ?? 0
    }

    func meterLevel(forGroupID groupID: UUID) -> Float {
        groupMeterLevels[groupID] ?? 0
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
            guard let mixer = trackMixers[track.id],
                  let gainUnit = trackGainUnits[track.id] else { continue }

            mixer.pan = Float(track.pan)
            let effectivelyMuted = track.isMuted || (hasSolo && !track.isSolo)
            let gain = TrackVolumeSettings.engineGainComponents(for: track.volume)

            if effectivelyMuted {
                mixer.outputVolume = 0
                gainUnit.globalGain = 0
            } else {
                mixer.outputVolume = gain.mixer
                gainUnit.globalGain = gain.boostDB
            }
        }

        for group in project.groups {
            guard let mixer = groupMixers[group.id],
                  let gainUnit = groupGainUnits[group.id] else { continue }

            let gain = TrackVolumeSettings.engineGainComponents(for: group.volume)
            mixer.outputVolume = gain.mixer
            gainUnit.globalGain = gain.boostDB
        }
    }

    func updateTrackPitch(project: DAWProject) {
        for scheduled in scheduledClips.values {
            let semitones = project.pitchSemitones(forTrackID: scheduled.trackID)
            PitchShiftSettings.apply(semitones: semitones, to: scheduled.timePitch)
        }
    }

    /// Starts playback from the given timeline position (playhead).
    @discardableResult
    func play(from time: TimeInterval, project: DAWProject) -> Bool {
        lastPlaybackError = nil

        guard !scheduledClips.isEmpty else {
            lastPlaybackError = AudioEngineError.playbackUnavailable.errorDescription
            return false
        }

        guard warmUpEngineForPlayback() else {
            lastPlaybackError = AudioEngineError.playbackUnavailable.errorDescription
            return false
        }

        playbackStartTime = max(0, time)
        var startedAnyPlayer = false

        for scheduled in scheduledClips.values {
            safelyResetPlayer(scheduled.player)
            guard shouldPlayClip(scheduled.clip, at: playbackStartTime) else { continue }
            guard scheduleClip(scheduled, from: playbackStartTime) else { continue }
            if safelyPlayPlayer(scheduled.player) {
                startedAnyPlayer = true
            }
        }

        if !startedAnyPlayer, playbackStartTime < project.duration {
            // Clips may start later on the timeline; still keep the engine running.
            return true
        }

        return true
    }

    func pause() {
        for scheduled in scheduledClips.values {
            safelyPausePlayer(scheduled.player)
        }
        resetMeters()
#if !os(macOS)
        stopEngineIfRunning()
#endif
    }

    func stop() {
        playbackStartTime = 0
        for scheduled in scheduledClips.values {
            safelyStopPlayer(scheduled.player)
        }
        resetMeters()
    }

    private func shouldPlayClip(_ clip: AudioClip, at playheadTime: TimeInterval) -> Bool {
        playheadTime < clip.endTime
    }

    @discardableResult
    private func scheduleClip(_ scheduled: ScheduledClip, from playheadTime: TimeInterval) -> Bool {
        let clip = scheduled.clip
        let file = scheduled.file
        let player = scheduled.player
        let sampleRate = file.processingFormat.sampleRate

        if playheadTime <= clip.startTime {
            let startFrame = AVAudioFramePosition(clip.sourceOffset * sampleRate)
            let frameCount = AVAudioFrameCount(clip.duration * sampleRate)
            guard frameCount > 0 else { return false }

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
            return true
        }

        let elapsedInClip = playheadTime - clip.startTime
        guard elapsedInClip < clip.duration else { return false }

        let sourceStart = clip.sourceOffset + elapsedInClip
        let remainingDuration = clip.duration - elapsedInClip
        let startFrame = AVAudioFramePosition(sourceStart * sampleRate)
        let frameCount = AVAudioFrameCount(remainingDuration * sampleRate)
        guard frameCount > 0 else { return false }

        player.scheduleSegment(
            file,
            startingFrame: startFrame,
            frameCount: frameCount,
            at: nil
        )
        return true
    }

    private func safelyResetPlayer(_ player: AVAudioPlayerNode) {
        guard isNodeConnected(player) else { return }
        player.stop()
        player.reset()
    }

    @discardableResult
    private func safelyPlayPlayer(_ player: AVAudioPlayerNode) -> Bool {
        guard isNodeConnected(player), engine.isRunning else { return false }
        player.play()
        return true
    }

    private func safelyPausePlayer(_ player: AVAudioPlayerNode) {
        guard isNodeConnected(player) else { return }
        player.pause()
    }

    private func safelyStopPlayer(_ player: AVAudioPlayerNode) {
        guard isNodeConnected(player) else { return }
        player.stop()
    }

    private func isNodeConnected(_ node: AVAudioNode) -> Bool {
        node.engine === engine && engine.attachedNodes.contains(where: { $0 === node })
    }

    @discardableResult
    private func warmUpEngineForPlayback() -> Bool {
#if !os(macOS)
        do {
            try reactivateAudioSessionIfNeeded()
        } catch {
            return false
        }
#endif

        if engine.isRunning, playbackGraphIsHealthy {
            isEngineRunning = true
            return true
        }

        stopEngineIfRunning()
        engine.prepare()

        do {
            try engine.start()
            isEngineRunning = true
            installMetersSafely()
            return playbackGraphIsHealthy
        } catch {
            isEngineRunning = false
            return false
        }
    }

    private var playbackGraphIsHealthy: Bool {
        scheduledClips.values.contains { isNodeConnected($0.player) && isNodeConnected($0.timePitch) }
    }

    private func stopEngineIfRunning() {
        guard isEngineRunning || engine.isRunning else { return }
        engine.stop()
        isEngineRunning = false
    }

    private func startEngine() throws {
        if engine.isRunning {
            isEngineRunning = true
            return
        }
        engine.prepare()
        try engine.start()
        isEngineRunning = true
    }

#if !os(macOS)
    private func reactivateAudioSessionIfNeeded() throws {
        let session = AVAudioSession.sharedInstance()
        if !session.isOtherAudioPlaying {
            try session.setActive(true)
        }
    }
#endif

    private func tearDownPlayers() {
        removeMetersSafely()
        for scheduled in scheduledClips.values {
            engine.detach(scheduled.player)
            engine.detach(scheduled.timePitch)
        }
        for (_, mixer) in trackMixers {
            engine.detach(mixer)
        }
        for (_, gainUnit) in trackGainUnits {
            engine.detach(gainUnit)
        }
        for (_, mixer) in groupMixers {
            engine.detach(mixer)
        }
        for (_, gainUnit) in groupGainUnits {
            engine.detach(gainUnit)
        }
        scheduledClips.removeAll()
        trackMixers.removeAll()
        trackGainUnits.removeAll()
        groupMixers.removeAll()
        groupGainUnits.removeAll()
        configuredProjectClipCount = 0
        resetMeters()
    }

    private func installMetersSafely() {
        removeMetersSafely()

        for (trackID, mixer) in trackMixers {
            installMeterTap(on: mixer) { [weak self] peak in
                self?.updateTrackMeterLevel(trackID: trackID, peak: peak)
            }
        }

        for (groupID, mixer) in groupMixers {
            installMeterTap(on: mixer) { [weak self] peak in
                self?.updateGroupMeterLevel(groupID: groupID, peak: peak)
            }
        }

        installMeterTap(on: mainMixer) { [weak self] peak in
            self?.updateMasterMeterLevel(peak: peak)
        }

        metersInstalled = true
    }

    private func installMeterTap(on mixer: AVAudioMixerNode, handler: @escaping (Float) -> Void) {
        let format = mixer.outputFormat(forBus: 0)
        guard format.sampleRate > 0 else { return }

        mixer.installTap(onBus: 0, bufferSize: 1024, format: format) { buffer, _ in
            let peak = Self.peakLevel(from: buffer)
            Task { @MainActor in
                handler(peak)
            }
        }
    }

    private func removeMetersSafely() {
        guard metersInstalled else { return }

        for mixer in trackMixers.values {
            mixer.removeTap(onBus: 0)
        }
        for mixer in groupMixers.values {
            mixer.removeTap(onBus: 0)
        }
        mainMixer.removeTap(onBus: 0)
        metersInstalled = false
    }

    private func updateTrackMeterLevel(trackID: UUID, peak: Float) {
        let current = trackMeterLevels[trackID] ?? 0
        if peak >= current {
            trackMeterLevels[trackID] = peak
        } else {
            trackMeterLevels[trackID] = max(peak, current * 0.88)
        }
    }

    private func updateGroupMeterLevel(groupID: UUID, peak: Float) {
        let current = groupMeterLevels[groupID] ?? 0
        if peak >= current {
            groupMeterLevels[groupID] = peak
        } else {
            groupMeterLevels[groupID] = max(peak, current * 0.88)
        }
    }

    private func updateMasterMeterLevel(peak: Float) {
        if peak >= masterMeterLevel {
            masterMeterLevel = peak
        } else {
            masterMeterLevel = max(peak, masterMeterLevel * 0.88)
        }
    }

    private func decayMeters() {
        trackMeterLevels = trackMeterLevels.mapValues { $0 * 0.65 }
        groupMeterLevels = groupMeterLevels.mapValues { $0 * 0.65 }
        masterMeterLevel *= 0.65
    }

    private func resetMeters() {
        trackMeterLevels.removeAll()
        groupMeterLevels.removeAll()
        masterMeterLevel = 0
    }

    private static func peakLevel(from buffer: AVAudioPCMBuffer) -> Float {
        guard let channelData = buffer.floatChannelData else { return 0 }
        let channelCount = Int(buffer.format.channelCount)
        let frameLength = Int(buffer.frameLength)
        guard frameLength > 0 else { return 0 }

        var peak: Float = 0
        var sumSquares: Float = 0
        let sampleCount = Float(frameLength * max(channelCount, 1))

        for channel in 0..<channelCount {
            let samples = channelData[channel]
            for frame in 0..<frameLength {
                let sample = abs(samples[frame])
                peak = max(peak, sample)
                sumSquares += sample * sample
            }
        }

        let rms = sqrt(sumSquares / sampleCount)
        // Blend RMS with peak so brief spikes do not instantly hit red.
        let blended = peak * 0.35 + rms * 0.65
        return min(1, blended)
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
        do {
            try session.setCategory(.playback, mode: .default, options: [])
            try session.setPreferredSampleRate(sampleRate.rawValue)
            try session.setActive(true)
        } catch {
            throw AudioEngineError.engineStartFailed
        }
    }
#endif
}
