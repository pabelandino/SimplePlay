//
//  AudioEngineService.swift
//  SimplePlay
//

import AVFoundation
import Foundation
import Observation
import os

/// See `SimplePlay/Core/Services/AUDIO_ENGINE_AGENT_GUIDE.md` before editing this file.

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
    var clip: AudioClip
    let trackID: UUID
    let file: AVAudioFile
    let player: AVAudioPlayerNode
    let timePitch: AVAudioUnitTimePitch?
}

/// Thread-safe peak accumulator fed from audio render taps; flushed on the main actor.
private final class MeterPeakBuffer: @unchecked Sendable {
    private let lock = OSAllocatedUnfairLock()

    private var trackPeaks: [UUID: Float] = [:]
    private var groupPeaks: [UUID: Float] = [:]
    private var masterPeak: Float = 0

    func recordTrack(_ trackID: UUID, peak: Float) {
        lock.withLock {
            trackPeaks[trackID] = max(trackPeaks[trackID] ?? 0, peak)
        }
    }

    func recordGroup(_ groupID: UUID, peak: Float) {
        lock.withLock {
            groupPeaks[groupID] = max(groupPeaks[groupID] ?? 0, peak)
        }
    }

    func recordMaster(_ peak: Float) {
        lock.withLock {
            masterPeak = max(masterPeak, peak)
        }
    }

    func drain() -> (tracks: [UUID: Float], groups: [UUID: Float], master: Float) {
        lock.withLock {
            let tracks = trackPeaks
            let groups = groupPeaks
            let master = masterPeak
            trackPeaks.removeAll()
            groupPeaks.removeAll()
            masterPeak = 0
            return (tracks, groups, master)
        }
    }

    func reset() {
        lock.withLock {
            trackPeaks.removeAll()
            groupPeaks.removeAll()
            masterPeak = 0
        }
    }
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
    private var playbackReferenceHostTime: UInt64?
    private var playbackReferencePlayerSample: AVAudioFramePosition?
    private var activeSectionLoop: SectionLoopContext?
    private var scheduledLoopCycleCount = 0

    var isSectionLoopPlaybackActive: Bool {
        activeSectionLoop != nil
    }

    var isAnyPlayerPlaying: Bool {
        scheduledClips.values.contains { $0.player.isPlaying }
    }

    /// True once player sample clocks are reporting (audible playback has started rendering).
    var isSamplePlaybackClockEstablished: Bool {
        playbackReferencePlayerSample != nil
    }

    /// Timeline position derived from the audio engine render clock (stays in sync under CPU load).
    func currentTimelineTime() -> TimeInterval? {
        platformPlayback.currentTimelineTime(in: self)
    }

    /// Sample-accurate timeline from player render clocks.
    private func timelineTimeFromPlayingPlayers(preferMinimumElapsed: Bool = false) -> TimeInterval? {
        capturePlaybackSampleReferenceIfNeeded()
        guard let referenceSample = playbackReferencePlayerSample else { return nil }

        var aggregated: TimeInterval?
        for scheduled in scheduledClips.values {
            guard scheduled.player.isPlaying,
                  let nodeTime = scheduled.player.lastRenderTime,
                  nodeTime.isSampleTimeValid,
                  nodeTime.sampleRate > 0 else { continue }

            let sampleDelta = nodeTime.sampleTime - referenceSample
            guard sampleDelta >= 0 else { continue }
            let elapsed = Double(sampleDelta) / nodeTime.sampleRate
            if preferMinimumElapsed {
                aggregated = min(aggregated ?? elapsed, elapsed)
            } else {
                aggregated = max(aggregated ?? elapsed, elapsed)
            }
        }

        guard let aggregated else { return nil }
        return playbackStartTime + aggregated
    }

    private func capturePlaybackSampleReferenceIfNeeded() {
        guard playbackReferencePlayerSample == nil else { return }

        var anchorSample: AVAudioFramePosition?

        for scheduled in scheduledClips.values {
            guard scheduled.player.isPlaying,
                  let nodeTime = scheduled.player.lastRenderTime,
                  nodeTime.isSampleTimeValid,
                  nodeTime.sampleRate > 0 else { continue }

            if let anchorSample, nodeTime.sampleTime >= anchorSample { continue }
            anchorSample = nodeTime.sampleTime
        }

        playbackReferencePlayerSample = anchorSample
    }

    private func clearPlaybackClockState() {
        playbackReferenceHostTime = nil
        playbackReferencePlayerSample = nil
    }

    private func clearPlaybackSampleReference() {
        playbackReferencePlayerSample = nil
    }

    var primaryClipSampleRate: Double? {
        scheduledClips.values.first?.file.processingFormat.sampleRate
    }
    private(set) var trackMeterLevels: [UUID: Float] = [:]
    private(set) var groupMeterLevels: [UUID: Float] = [:]
    private(set) var masterMeterLevel: Float = 0
    private(set) var configurationWarnings: [String] = []
    private(set) var lastPlaybackError: String?
    private var metersInstalled = false
    private var configuredProjectClipCount = 0
    private var meterPeakBuffer = MeterPeakBuffer()
    private var meterFlushTimer: Timer?
    var isMeterMonitoringEnabled = false {
        didSet { refreshMeterMonitoring() }
    }

    private let platformPlayback: PlatformPlaybackStrategy = PlatformPlaybackStrategyFactory.make()
    internal let platformServices: AudioEnginePlatformServices = AudioEnginePlatformServicesFactory.make()

    static let playbackLeadInSeconds: TimeInterval = 0.02
    private static let initialLoopCycles = 2
    private static let appendedLoopCycles = 2
    private static let maxQueuedLoopBatches = 4
    private static let meterFlushInterval: TimeInterval = 1.0 / 15.0
    private var meterTapBufferSize: AVAudioFrameCount {
        platformPlayback.meterTapBufferSize
    }

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
        try platformServices.configureSessionBeforeEngineGraph(settings: project.audioSettings, host: self)

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

        let clipRates = Set(
            scheduledClips.values.map { $0.file.processingFormat.sampleRate.rounded(.toNearestOrAwayFromZero) }
        )
        if clipRates.count == 1,
           let clipRate = clipRates.first,
           abs(clipRate - project.audioSettings.sampleRate.rawValue) > 1 {
            configurationWarnings.append(
                "Clip sample rate (\(Int(clipRate)) Hz) differs from project (\(Int(project.audioSettings.sampleRate.rawValue)) Hz). Match project sample rate to clips for tighter sync."
            )
        }

        guard !scheduledClips.isEmpty || project.tracks.flatMap(\.clips).isEmpty else {
            throw AudioEngineError.noPlayableClips
        }

        updateTrackMixing(project: project)
        configuredProjectClipCount = project.tracks.reduce(0) { $0 + $1.clips.count }
        refreshMeterMonitoring()

        do {
            try platformPlayback.finishEngineConfiguration(in: self)
            try platformServices.applyOutputRouting(settings: project.audioSettings, host: self)
        } catch {
            throw AudioEngineError.engineStartFailed
        }
    }

    var isPlaybackGraphReady: Bool {
        !scheduledClips.isEmpty
    }

    /// Updates timeline placement for already-attached clips without rebuilding the audio graph.
    func syncClipLayout(from project: DAWProject) {
        for track in project.tracks {
            for clip in track.clips {
                guard var scheduled = scheduledClips[clip.id] else { continue }
                scheduled.clip = clip
                scheduledClips[clip.id] = scheduled
            }
        }
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
        engine.attach(player)

        var timePitch: AVAudioUnitTimePitch?
        let unit = AVAudioUnitTimePitch()
        if project.usesPitchProcessing(forTrackID: trackID) {
            PitchShiftSettings.apply(
                semitones: project.pitchSemitones(forTrackID: trackID),
                to: unit
            )
        } else {
            PitchShiftSettings.applyNeutral(to: unit)
        }
        engine.attach(unit)
        engine.connect(player, to: unit, format: file.processingFormat)
        engine.connect(unit, to: trackMixer, format: file.processingFormat)
        timePitch = unit

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
        try platformServices.apply(settings: settings, host: self)
    }

    /// Applies the selected output interface and restarts the engine when it is already running.
    func applyOutputRouting(settings: AudioSettings) throws {
        try platformServices.applyOutputRouting(settings: settings, host: self)
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
            guard let timePitch = scheduled.timePitch else { continue }
            if project.usesPitchProcessing(forTrackID: scheduled.trackID) {
                let semitones = project.pitchSemitones(forTrackID: scheduled.trackID)
                PitchShiftSettings.apply(semitones: semitones, to: timePitch)
            } else {
                PitchShiftSettings.applyNeutral(to: timePitch)
            }
        }
    }

    /// Starts playback from the given timeline position (playhead).
    @discardableResult
    func play(
        from time: TimeInterval,
        project: DAWProject,
        sectionLoop: SectionLoopContext? = nil,
        scheduleUntil: TimeInterval? = nil
    ) -> Bool {
        lastPlaybackError = nil
        activeSectionLoop = sectionLoop
        scheduledLoopCycleCount = 0
        syncClipLayout(from: project)

        guard !scheduledClips.isEmpty else {
            lastPlaybackError = AudioEngineError.playbackUnavailable.errorDescription
            return false
        }

        let orderedClips = orderedScheduledClips(for: project)

        for scheduled in orderedClips {
            safelyStopPlayer(scheduled.player)
        }

        for scheduled in orderedClips {
            safelyResetPlayer(scheduled.player)
        }

        guard platformPlayback.warmUpEngineForPlayback(in: self) else {
            lastPlaybackError = AudioEngineError.playbackUnavailable.errorDescription
            return false
        }

        playbackStartTime = max(0, time)
        clearPlaybackClockState()
        let clipRate = primaryClipSampleRate ?? project.audioSettings.sampleRate.rawValue
        if abs(clipRate - project.audioSettings.sampleRate.rawValue) > 1 {
            SectionLoopDiagnostics.log(String(
                format: "sample-rate note: project %.0f Hz, clips %.0f Hz — section loop uses clip rate",
                project.audioSettings.sampleRate.rawValue,
                clipRate
            ))
        }
        SectionLoopDiagnostics.logPlaybackStart(
            from: playbackStartTime,
            loop: sectionLoop,
            sampleRate: clipRate
        )

        var playersToStart: [AVAudioPlayerNode] = []

        let playbackAnchor = platformPlayback.resolvePlaybackStartAnchor(in: self)

        for scheduled in orderedClips {
            if let sectionLoop {
                let queued = scheduleClipWithSectionLoop(
                    scheduled,
                    from: playbackStartTime,
                    loop: sectionLoop,
                    initialCycles: Self.initialLoopCycles,
                    labelPrefix: "initial",
                    playerStartAnchor: playbackAnchor
                )
                if queued {
                    playersToStart.append(scheduled.player)
                }
            } else {
                guard shouldPlayClip(scheduled.clip, at: playbackStartTime) else { continue }
                guard scheduleClip(
                    scheduled,
                    from: playbackStartTime,
                    scheduleUntil: scheduleUntil,
                    playerStartAnchor: playbackAnchor
                ) else { continue }
                playersToStart.append(scheduled.player)
            }
        }

        if playersToStart.isEmpty, sectionLoop != nil {
            lastPlaybackError = AudioEngineError.playbackUnavailable.errorDescription
            activeSectionLoop = nil
            scheduledLoopCycleCount = 0
            return false
        }

        guard !playersToStart.isEmpty else {
            lastPlaybackError = AudioEngineError.playbackUnavailable.errorDescription
            return false
        }

        let sortedPlayers = sortedPlayersForPlayback(
            playersToStart,
            trackOrder: trackOrderLookup(for: project)
        )
        platformPlayback.startScheduledPlayers(sortedPlayers, anchor: playbackAnchor, in: self)

        if playbackStartTime < project.duration {
            return true
        }

        return true
    }

    private func trackOrderLookup(for project: DAWProject) -> [UUID: Int] {
        Dictionary(uniqueKeysWithValues: project.tracks.enumerated().map { ($0.element.id, $0.offset) })
    }

    private func orderedScheduledClips(for project: DAWProject) -> [ScheduledClip] {
        let trackOrder = trackOrderLookup(for: project)
        return scheduledClips.values.sorted { lhs, rhs in
            let leftOrder = trackOrder[lhs.trackID] ?? Int.max
            let rightOrder = trackOrder[rhs.trackID] ?? Int.max
            if leftOrder != rightOrder { return leftOrder < rightOrder }
            return lhs.clip.id.uuidString < rhs.clip.id.uuidString
        }
    }

    private func sortedPlayersForPlayback(
        _ players: [AVAudioPlayerNode],
        trackOrder: [UUID: Int]
    ) -> [AVAudioPlayerNode] {
        let playerToTrack = Dictionary(uniqueKeysWithValues: scheduledClips.values.map { ($0.player, $0.trackID) })
        return players.sorted { lhs, rhs in
            let leftOrder = trackOrder[playerToTrack[lhs] ?? UUID()] ?? Int.max
            let rightOrder = trackOrder[playerToTrack[rhs] ?? UUID()] ?? Int.max
            if leftOrder != rightOrder { return leftOrder < rightOrder }
            return ObjectIdentifier(lhs) < ObjectIdentifier(rhs)
        }
    }

    /// True when the engine render clock was updated recently (avoids stale host times after stop).
    private func renderClockIsLive() -> Bool {
        guard let nodeTime = engine.outputNode.lastRenderTime,
              nodeTime.isHostTimeValid else {
            return false
        }

        let now = mach_absolute_time()
        guard now >= nodeTime.hostTime else { return true }

        let age = Self.secondsBetweenHostTimes(from: nodeTime.hostTime, to: now)
        return age < 0.25
    }

    /// Arms section loop on linear playback by scheduling loop cycles at the section boundary
    /// without stopping active players (avoids blink when toggling loop mid-playback).
    @discardableResult
    func adoptSectionLoopDuringPlayback(
        project: DAWProject,
        loop: SectionLoopContext,
        playheadTime: TimeInterval
    ) -> Bool {
        if activeSectionLoop == loop, scheduledLoopCycleCount > 0 {
            return true
        }

        activeSectionLoop = loop

        var adopted = false
        for scheduled in scheduledClips.values {
            if scheduleLoopBody(
                scheduled,
                loop: loop,
                cycles: Self.initialLoopCycles,
                labelPrefix: "adopt",
                firstCycleTimelineTime: loop.endTime,
                playheadTime: playheadTime
            ) {
                adopted = true
            }
        }

        if adopted {
            scheduledLoopCycleCount += Self.initialLoopCycles
            SectionLoopDiagnostics.log(
                "adopted section loop at \(String(format: "%.6f", loop.endTime))s without restart"
            )
        } else {
            activeSectionLoop = nil
            scheduledLoopCycleCount = 0
        }

        return adopted
    }

    /// Queues additional loop cycles without stopping active players (seamless section repeat).
    @discardableResult
    func appendSectionLoopCycles(project: DAWProject, loop: SectionLoopContext, cycles: Int? = nil) -> Bool {
        guard scheduledLoopCycleCount < Self.maxQueuedLoopBatches else {
            SectionLoopDiagnostics.log(
                "append skipped: queued loop batches=\(scheduledLoopCycleCount) (max \(Self.maxQueuedLoopBatches))"
            )
            return false
        }

        let cycleCount = cycles ?? Self.appendedLoopCycles
        if activeSectionLoop == nil {
            activeSectionLoop = loop
        } else if activeSectionLoop != loop {
            SectionLoopDiagnostics.log("append skipped: active loop context mismatch")
            return false
        }

        var appended = false
        for scheduled in scheduledClips.values {
            if scheduleLoopBody(
                scheduled,
                loop: loop,
                cycles: cycleCount,
                labelPrefix: "append"
            ) {
                appended = true
            }
        }

        if appended {
            scheduledLoopCycleCount += cycleCount
            SectionLoopDiagnostics.log(
                "appended \(cycleCount) loop cycle(s); total queued batches=\(scheduledLoopCycleCount)"
            )
        }

        return appended
    }

    func clearSectionLoopState() {
        activeSectionLoop = nil
        scheduledLoopCycleCount = 0
    }

    /// Stops queued audio immediately without clearing section loop bookkeeping.
    func flushPlayerQueues() {
        for scheduled in scheduledClips.values {
            safelyStopPlayer(scheduled.player)
            scheduled.player.reset()
        }
        playbackReferenceHostTime = nil
        clearPlaybackSampleReference()
        resetMeters()
    }

    /// Re-syncs the host playback clock to a timeline position (e.g. after a seamless section loop wrap).
    func reanchorPlaybackTimeline(at time: TimeInterval) {
        playbackStartTime = max(0, time)
        clearPlaybackSampleReference()
        markPlaybackReferenceTime()
    }

    func pause() {
        for scheduled in scheduledClips.values {
            safelyStopPlayer(scheduled.player)
            scheduled.player.reset()
        }
        clearPlaybackClockState()
        clearSectionLoopState()
        resetMeters()
        platformPlayback.pause(in: self)
    }

    func stop() {
        playbackStartTime = 0
        clearPlaybackClockState()
        clearSectionLoopState()
        for scheduled in scheduledClips.values {
            safelyStopPlayer(scheduled.player)
            scheduled.player.reset()
        }
        resetMeters()
        platformPlayback.stop(in: self)
    }

    private func shouldPlayClip(_ clip: AudioClip, at playheadTime: TimeInterval) -> Bool {
        playheadTime < clip.endTime
    }

    @discardableResult
    private func scheduleClip(
        _ scheduled: ScheduledClip,
        from playheadTime: TimeInterval,
        scheduleUntil: TimeInterval? = nil,
        playerStartAnchor: AVAudioTime
    ) -> Bool {
        let clip = scheduled.clip
        let file = scheduled.file
        let player = scheduled.player
        let sampleRate = file.processingFormat.sampleRate
        guard sampleRate > 0 else { return false }

        let clipStartFrame = TimelineSampleGrid.frames(at: clip.startTime, sampleRate: sampleRate)
        let clipEndFrame = TimelineSampleGrid.frames(at: clip.endTime, sampleRate: sampleRate)
        let playheadFrame = TimelineSampleGrid.frames(at: playheadTime, sampleRate: sampleRate)
        let sourceOffsetFrame = TimelineSampleGrid.frames(at: clip.sourceOffset, sampleRate: sampleRate)
        let cappedEndFrame = scheduleUntil.map {
            TimelineSampleGrid.frames(at: $0, sampleRate: sampleRate)
        } ?? clipEndFrame
        let effectiveEndFrame = min(clipEndFrame, cappedEndFrame)

        guard playheadFrame < effectiveEndFrame, effectiveEndFrame > clipStartFrame else { return false }

        let playbackStartFrame = max(clipStartFrame, playheadFrame)
        let sourceStartFrame = sourceOffsetFrame + (playbackStartFrame - clipStartFrame)
        let frameCount = AVAudioFrameCount(effectiveEndFrame - playbackStartFrame)
        guard frameCount > 0, sourceStartFrame >= 0, sourceStartFrame < file.length else { return false }

        let scheduleAt = platformPlayback.segmentScheduleTime(
            offsetSamplesFromPlayhead: playbackStartFrame - playheadFrame,
            sampleRate: sampleRate,
            playerStartAnchor: playerStartAnchor,
            in: self
        )

        platformPlayback.scheduleFileSegment(
            player: player,
            file: file,
            startingFrame: sourceStartFrame,
            frameCount: frameCount,
            at: scheduleAt,
            in: self
        )
        return true
    }

    @discardableResult
    private func scheduleClipWithSectionLoop(
        _ scheduled: ScheduledClip,
        from playheadTime: TimeInterval,
        loop: SectionLoopContext,
        initialCycles: Int,
        labelPrefix: String,
        playerStartAnchor: AVAudioTime
    ) -> Bool {
        let sampleRate = scheduled.file.processingFormat.sampleRate
        guard sampleRate > 0 else { return false }

        let clipStartFrame = TimelineSampleGrid.frames(at: scheduled.clip.startTime, sampleRate: sampleRate)
        let clipEndFrame = TimelineSampleGrid.frames(at: scheduled.clip.endTime, sampleRate: sampleRate)
        let loopStartFrame = TimelineSampleGrid.frames(at: loop.startTime, sampleRate: sampleRate)
        let loopEndFrame = TimelineSampleGrid.frames(at: loop.endTime, sampleRate: sampleRate)
        let playheadFrame = TimelineSampleGrid.frames(at: playheadTime, sampleRate: sampleRate)

        guard clipEndFrame > clipStartFrame,
              loopEndFrame > loopStartFrame,
              clipStartFrame < loopEndFrame,
              clipEndFrame > loopStartFrame else {
            return false
        }

        var scheduledAny = false

        if playheadFrame < loopEndFrame {
            let segmentStart = max(playheadFrame, clipStartFrame)
            let segmentEnd = min(loopEndFrame, clipEndFrame)
            if segmentEnd > segmentStart,
               scheduleTimelineSegment(
                   scheduled,
                   timelineStartFrame: segmentStart,
                   timelineEndFrame: segmentEnd,
                   at: nil,
                   label: "\(labelPrefix)-lead-in"
               ) {
                scheduledAny = true
            }
        }

        if scheduleLoopBody(
            scheduled,
            loop: loop,
            cycles: initialCycles,
            labelPrefix: labelPrefix
        ) {
            scheduledAny = true
        }

        if scheduledAny {
            scheduledLoopCycleCount += initialCycles
        }

        return scheduledAny
    }

    @discardableResult
    private func scheduleLoopBody(
        _ scheduled: ScheduledClip,
        loop: SectionLoopContext,
        cycles: Int,
        labelPrefix: String,
        firstCycleTimelineTime: TimeInterval? = nil,
        playheadTime: TimeInterval? = nil
    ) -> Bool {
        let sampleRate = scheduled.file.processingFormat.sampleRate
        guard sampleRate > 0, cycles > 0 else { return false }

        let clipStartFrame = TimelineSampleGrid.frames(at: scheduled.clip.startTime, sampleRate: sampleRate)
        let clipEndFrame = TimelineSampleGrid.frames(at: scheduled.clip.endTime, sampleRate: sampleRate)
        let loopStartFrame = TimelineSampleGrid.frames(at: loop.startTime, sampleRate: sampleRate)
        let loopEndFrame = TimelineSampleGrid.frames(at: loop.endTime, sampleRate: sampleRate)

        let bodyStart = max(loopStartFrame, clipStartFrame)
        let bodyEnd = min(loopEndFrame, clipEndFrame)
        guard bodyEnd > bodyStart else { return false }

        var scheduledAny = false
        for cycle in 0..<cycles {
            let scheduleAt: AVAudioTime?
            if let firstCycleTimelineTime, let playheadTime {
                let cycleStartTimeline = firstCycleTimelineTime + (Double(cycle) * loop.duration)
                let cycleStartFrame = TimelineSampleGrid.frames(at: cycleStartTimeline, sampleRate: sampleRate)
                let playheadFrame = TimelineSampleGrid.frames(at: playheadTime, sampleRate: sampleRate)
                let framesFromNow = cycleStartFrame - playheadFrame
                scheduleAt = platformPlayback.playerScheduleTime(
                    player: scheduled.player,
                    framesFromNow: framesFromNow,
                    sampleRate: sampleRate,
                    playheadTime: playheadTime,
                    in: self
                )
            } else {
                scheduleAt = nil
            }

            if scheduleTimelineSegment(
                scheduled,
                timelineStartFrame: bodyStart,
                timelineEndFrame: bodyEnd,
                at: scheduleAt,
                label: "\(labelPrefix)-cycle-\(cycle + 1)"
            ) {
                scheduledAny = true
            }
        }
        return scheduledAny
    }

    @discardableResult
    private func scheduleTimelineSegment(
        _ scheduled: ScheduledClip,
        timelineStartFrame: Int64,
        timelineEndFrame: Int64,
        at: AVAudioTime?,
        label: String
    ) -> Bool {
        let clip = scheduled.clip
        let file = scheduled.file
        let player = scheduled.player
        let sampleRate = file.processingFormat.sampleRate
        guard sampleRate > 0 else { return false }

        let clipStartFrame = TimelineSampleGrid.frames(at: clip.startTime, sampleRate: sampleRate)
        let sourceOffsetFrame = TimelineSampleGrid.frames(at: clip.sourceOffset, sampleRate: sampleRate)
        let sourceStartFrame = sourceOffsetFrame + (timelineStartFrame - clipStartFrame)
        let frameCount = AVAudioFrameCount(timelineEndFrame - timelineStartFrame)

        guard frameCount > 0,
              sourceStartFrame >= 0,
              sourceStartFrame < file.length else {
            return false
        }

        platformPlayback.scheduleFileSegment(
            player: player,
            file: file,
            startingFrame: sourceStartFrame,
            frameCount: frameCount,
            at: at,
            in: self
        )

        SectionLoopDiagnostics.logScheduledSegment(
            clipName: clip.name,
            timelineStart: TimelineSampleGrid.timeFromFrame(timelineStartFrame, sampleRate: sampleRate),
            timelineEnd: TimelineSampleGrid.timeFromFrame(timelineEndFrame, sampleRate: sampleRate),
            sourceStartFrame: sourceStartFrame,
            frameCount: frameCount,
            sampleRate: sampleRate,
            label: label
        )
        return true
    }

    private func safelyResetPlayer(_ player: AVAudioPlayerNode) {
        guard isNodeConnected(player) else { return }
        player.stop()
        player.reset()
    }

    @discardableResult
    private func safelyPlayPlayer(_ player: AVAudioPlayerNode, at when: AVAudioTime? = nil) -> Bool {
        guard isNodeConnected(player), engine.isRunning else { return false }
        player.play(at: when)
        return true
    }

    @discardableResult
    private func safelyPlayPlayer(_ player: AVAudioPlayerNode) -> Bool {
        return safelyPlayPlayer(player, at: nil)
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

    private func markPlaybackReferenceTime() {
        if let hostTime = engine.outputNode.lastRenderTime?.hostTime {
            playbackReferenceHostTime = hostTime
        } else {
            playbackReferenceHostTime = mach_absolute_time()
        }
    }

    private func makeSynchronizedPlaybackAnchor() -> AVAudioTime? {
        guard let nodeTime = engine.outputNode.lastRenderTime,
              nodeTime.isHostTimeValid else {
            return nil
        }

        let leadHost = nodeTime.hostTime &+ AVAudioTime.hostTime(forSeconds: Self.playbackLeadInSeconds)
        let outputRate = engine.outputNode.outputFormat(forBus: 0).sampleRate
        let sampleRate = outputRate > 0
            ? outputRate
            : (nodeTime.sampleRate > 0 ? nodeTime.sampleRate : (primaryClipSampleRate ?? 48_000))

        if nodeTime.isSampleTimeValid, sampleRate > 0 {
            let leadSamples = AVAudioFramePosition(Self.playbackLeadInSeconds * sampleRate)
            return AVAudioTime(
                hostTime: leadHost,
                sampleTime: nodeTime.sampleTime + leadSamples,
                atRate: sampleRate
            )
        }

        return AVAudioTime(hostTime: leadHost)
    }

    private static func secondsBetweenHostTimes(from start: UInt64, to end: UInt64) -> TimeInterval {
        guard end >= start else { return 0 }
        var timebase = mach_timebase_info_data_t()
        mach_timebase_info(&timebase)
        let nanoseconds = Double(end - start) * Double(timebase.numer) / Double(timebase.denom)
        return nanoseconds / 1_000_000_000
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

    private func tearDownPlayers() {
        removeMetersSafely()
        for scheduled in scheduledClips.values {
            engine.detach(scheduled.player)
            if let timePitch = scheduled.timePitch {
                engine.detach(timePitch)
            }
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

    private func refreshMeterMonitoring() {
        guard isMeterMonitoringEnabled, engine.isRunning, !trackMixers.isEmpty else {
            stopMeterFlushTimer()
            removeMetersSafely()
            return
        }

        installMetersSafely()
        startMeterFlushTimer()
    }

    private func installMetersSafely() {
        removeMetersSafely()
        let peakBuffer = meterPeakBuffer

        for (trackID, mixer) in trackMixers {
            installMeterTap(on: mixer) { peak in
                peakBuffer.recordTrack(trackID, peak: peak)
            }
        }

        for (groupID, mixer) in groupMixers {
            installMeterTap(on: mixer) { peak in
                peakBuffer.recordGroup(groupID, peak: peak)
            }
        }

        installMeterTap(on: mainMixer) { peak in
            peakBuffer.recordMaster(peak)
        }

        metersInstalled = true
    }

    private func installMeterTap(on mixer: AVAudioMixerNode, handler: @escaping (Float) -> Void) {
        let format = mixer.outputFormat(forBus: 0)
        guard format.sampleRate > 0 else { return }

        mixer.installTap(onBus: 0, bufferSize: meterTapBufferSize, format: format) { buffer, _ in
            handler(Self.peakLevel(from: buffer))
        }
    }

    private func startMeterFlushTimer() {
        guard meterFlushTimer == nil else { return }

        let timer = Timer(timeInterval: Self.meterFlushInterval, repeats: true) { [weak self] _ in
            Task { @MainActor in
                self?.flushMeterPeaksFromBuffer()
            }
        }
        meterFlushTimer = timer
        RunLoop.main.add(timer, forMode: .common)
    }

    private func stopMeterFlushTimer() {
        meterFlushTimer?.invalidate()
        meterFlushTimer = nil
    }

    private func flushMeterPeaksFromBuffer() {
        let snapshot = meterPeakBuffer.drain()

        for (trackID, peak) in snapshot.tracks {
            updateTrackMeterLevel(trackID: trackID, peak: peak)
        }
        for (groupID, peak) in snapshot.groups {
            updateGroupMeterLevel(groupID: groupID, peak: peak)
        }
        if snapshot.master > 0 {
            updateMasterMeterLevel(peak: snapshot.master)
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
        meterPeakBuffer.reset()
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
        stopMeterFlushTimer()
        meterPeakBuffer.reset()
        trackMeterLevels.removeAll()
        groupMeterLevels.removeAll()
        masterMeterLevel = 0
    }

    private static func peakLevel(from buffer: AVAudioPCMBuffer) -> Float {
        guard buffer.format.commonFormat == .pcmFormatFloat32,
              buffer.frameLength > 0,
              let channelData = buffer.floatChannelData else {
            return 0
        }

        let channelCount = Int(buffer.format.channelCount)
        let frameLength = Int(buffer.frameLength)
        guard channelCount > 0, frameLength > 0 else { return 0 }

        var peak: Float = 0
        var sumSquares: Float = 0
        let sampleCount = Float(frameLength * channelCount)

        for channel in 0..<channelCount {
            let samples = channelData[channel]
            for frame in 0..<frameLength {
                let sample = abs(samples[frame])
                peak = max(peak, sample)
                sumSquares += sample * sample
            }
        }

        let rms = sqrt(sumSquares / sampleCount)
        let blended = peak * 0.35 + rms * 0.65
        return min(1, blended)
    }
}

// MARK: - Platform host + playback bridge

extension AudioEngineService: AudioEngineServiceHost {
    var avEngine: AVAudioEngine { engine }

    var engineIsRunning: Bool {
        get { isEngineRunning }
        set { isEngineRunning = newValue }
    }

    func hostStartEngine() throws {
        try startEngine()
    }

    func hostStopEngineIfRunning() {
        stopEngineIfRunning()
    }

    func hostRenderClockIsLive() -> Bool {
        renderClockIsLive()
    }
}

extension AudioEngineService {
    var playbackEngine: AVAudioEngine { engine }

    var playbackStartTimeValue: TimeInterval {
        get { playbackStartTime }
        set { playbackStartTime = newValue }
    }

    var playbackReferenceHostTimeValue: UInt64? {
        get { playbackReferenceHostTime }
        set { playbackReferenceHostTime = newValue }
    }

    var playbackIsEngineRunning: Bool {
        get { isEngineRunning }
        set { isEngineRunning = newValue }
    }

    var playbackPrimaryClipSampleRate: Double? { primaryClipSampleRate }

    var playbackGraphIsHealthy: Bool {
        scheduledClips.values.contains { scheduled in
            guard isNodeConnected(scheduled.player) else { return false }
            if let timePitch = scheduled.timePitch {
                return isNodeConnected(timePitch)
            }
            return true
        }
    }

    func playbackMarkReferenceTime() { markPlaybackReferenceTime() }
    func playbackClearSampleReference() { clearPlaybackSampleReference() }

    @discardableResult
    func playbackSafelyPlayPlayer(_ player: AVAudioPlayerNode, at when: AVAudioTime?) -> Bool {
        safelyPlayPlayer(player, at: when)
    }

    func playbackRenderClockIsLive() -> Bool { renderClockIsLive() }
    func playbackMakeSynchronizedAnchor() -> AVAudioTime? { makeSynchronizedPlaybackAnchor() }

    func playbackSecondsBetweenHostTimes(from start: UInt64, to end: UInt64) -> TimeInterval {
        Self.secondsBetweenHostTimes(from: start, to: end)
    }

    func playbackStopEngineIfRunning() { stopEngineIfRunning() }

    @discardableResult
    func playbackStartEngine() throws -> Bool {
        try startEngine()
        return playbackGraphIsHealthy
    }

    func playbackPrepareEngine() { engine.prepare() }
    func playbackRefreshMeterMonitoring() { refreshMeterMonitoring() }

    func playbackTimelineFromSampleClocks(preferMinimumElapsed: Bool = false) -> TimeInterval? {
        timelineTimeFromPlayingPlayers(preferMinimumElapsed: preferMinimumElapsed)
    }
}
