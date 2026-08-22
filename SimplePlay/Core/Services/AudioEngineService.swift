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
    var player: AVAudioPlayerNode
    var standby: AVAudioPlayerNode
    let clipMixer: AVAudioMixerNode
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
    private let sectionAudioCache = SectionAudioCache()
    private let sectionStandby = SectionStandbyCoordinator()

    private(set) var isEngineRunning = false
    private(set) var playbackStartTime: TimeInterval = 0
    private var playbackReferenceHostTime: UInt64?
    /// Host time when the current player session started (`play` / seamless jump). Join math uses
    /// this even if `playbackReferenceHostTime` is later overwritten by a reanchor.
    private var playerSessionHostOrigin: UInt64?
    private var playbackReferencePlayerSample: AVAudioFramePosition?
    private var activeSectionLoop: SectionLoopContext?
    /// Batches of file-segment loop cycles queued on live players (adopt/append).
    private var scheduledLoopCycleCount = 0
    /// Sample offset from `loopPlayAnchor` where the next loop cycle should be scheduled.
    private var loopTrackSchedule: [UUID: LoopTrackScheduleState] = [:]
    private var loopPlayAnchor: AVAudioTime?
    /// Player-sample time where the currently queued audio ends (origin = last play()/jump).
    /// Used to splice the next loop/jump buffer sample-accurately instead of `at: nil`.
    private var playerQueueEndFrames: [UUID: AVAudioFramePosition] = [:]
    /// Anchor from the active linear `play()` pass — repeat pre-schedule must use the same queue origin.
    private var linearPlaybackAnchor: AVAudioTime?
    private var armedBoundaryJump: ArmedBoundaryJump?
    /// True while a linear continuation segment (past section end) is sitting in player queues.
    /// Any arm operation that appends segments to the queue MUST flush first when this is true,
    /// because the continuation sits ahead in the FIFO queue and would play before the new content.
    private(set) var isLinearContinuationQueued: Bool = false
    /// End of the last continuation slice actually scheduled (timeline seconds).
    private var continuationQueuedUntil: TimeInterval?
    /// Timeline end we still need to cover with later continuation slices.
    private var continuationLimit: TimeInterval?
    private static let maxImmediateContinuationSlices = 1
    private static let continuationRefillLeadTime: TimeInterval = 4
    /// Live node is already looping the cached section body — wrap is clock-only.
    private var cachedSectionLoopActive = false

    private struct ArmedBoundaryJump {
        let boundaryTime: TimeInterval
        let destinationTime: TimeInterval
        /// False when arm carries only scheduling metadata (no audio pre-queued in player FIFO).
        /// Enables gap-free loop toggle: disable just clears metadata, no player flush needed.
        var isPreScheduled: Bool = true
    }

    private struct LoopTrackScheduleState {
        var nextOffsetFrames: Int64
        let bodyFrameCount: Int64
        let bodyStart: Int64
        let bodyEnd: Int64
    }

    var isSectionLoopPlaybackActive: Bool {
        activeSectionLoop != nil
    }

    /// True when a loop body is already sitting on the live FIFO. Disable must
    /// flush in that case; metadata-only arms can be cleared with no restart.
    var hasQueuedLoopBody: Bool {
        scheduledLoopCycleCount > 0
    }

    /// Cached section body is looping on a live node. Transport must not re-arm.
    var isCachedSectionLoopActive: Bool {
        cachedSectionLoopActive
    }

    var activeSectionLoopContext: SectionLoopContext? {
        activeSectionLoop
    }

    var isAnyPlayerPlaying: Bool {
        scheduledClips.keys.contains { id in
            let live = sectionStandby.liveNode(for: id) ?? scheduledClips[id]?.player
            return live?.isPlaying == true
        }
    }

    var hasPrimedStandbyTakeover: Bool {
        sectionStandby.hasAnyPrime
            || sectionStandby.hasAnyCued
            || sectionStandby.currentIntent != .none
    }

    /// Promotes cued/primed standbys to live. Incoming nodes are already in the
    /// IO cycle — never `play()` or mute the outgoing cap here (that was the
    /// enlarged wrap gap: live was cut while the next body had not started).
    func startAllPrimedStandbys(allowImmediateStart: Bool = true) {
        for clipID in scheduledClips.keys {
            sectionStandby.startPrimedStandby(
                clipID: clipID,
                allowImmediateStart: allowImmediateStart
            )
        }
        syncLanesFromStandbyCoordinator()
    }

    var hasArmedBoundaryJump: Bool {
        armedBoundaryJump != nil
    }

    func hasArmedBoundaryJump(matchingDestination time: TimeInterval) -> Bool {
        guard let armed = armedBoundaryJump else { return false }
        return abs(armed.destinationTime - time) <= 0.05
    }

    /// True when the armed boundary jump has audio pre-scheduled in the player FIFO.
    /// False for metadata-only arms (lazy loop arm) where no player queue flush is needed on disable.
    var armedBoundaryJumpIsPreScheduled: Bool {
        armedBoundaryJump?.isPreScheduled ?? false
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
        for (clipID, scheduled) in scheduledClips {
            let node = sectionStandby.liveNode(for: clipID) ?? scheduled.player
            guard node.isPlaying,
                  let nodeTime = node.lastRenderTime,
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

        for (clipID, scheduled) in scheduledClips {
            let node = sectionStandby.liveNode(for: clipID) ?? scheduled.player
            guard node.isPlaying,
                  let nodeTime = node.lastRenderTime,
                  nodeTime.isSampleTimeValid,
                  nodeTime.sampleRate > 0 else { continue }

            if let anchorSample, nodeTime.sampleTime >= anchorSample { continue }
            anchorSample = nodeTime.sampleTime
        }

        playbackReferencePlayerSample = anchorSample
    }

    private func clearPlaybackClockState() {
        playbackReferenceHostTime = nil
        playerSessionHostOrigin = nil
        playbackReferencePlayerSample = nil
        linearPlaybackAnchor = nil
        playerQueueEndFrames.removeAll()
        isLinearContinuationQueued = false
        continuationQueuedUntil = nil
        continuationLimit = nil
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
    private var cutPrerollSilenceBuffers: [String: AVAudioPCMBuffer] = [:]
    private var renderedPlayerIDs: Set<ObjectIdentifier> = []
    var isMeterMonitoringEnabled = false {
        didSet { refreshMeterMonitoring() }
    }

    private let platformPlayback: PlatformPlaybackStrategy = PlatformPlaybackStrategyFactory.make()
    internal let platformServices: AudioEnginePlatformServices = AudioEnginePlatformServicesFactory.make()

    static let playbackLeadInSeconds: TimeInterval = 0.02
    private static let seamlessJumpLeadInSeconds: TimeInterval = 0.008
    private static let initialLoopCycles = 2
    private static let adoptedLoopCycles = 1
    private static let appendedLoopCycles = 1
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

        prepareGaplessCuts(for: project)
    }

    var isPlaybackGraphReady: Bool {
        !scheduledClips.isEmpty
    }

    func syncClipLayout(from project: DAWProject) {
        for track in project.tracks {
            for clip in track.clips {
                guard var scheduled = scheduledClips[clip.id] else { continue }
                scheduled.clip = clip
                scheduledClips[clip.id] = scheduled
            }
        }
    }

    /// Pre-decodes every section body on a background queue so the first loop/jump
    /// can `scheduleBuffer` instead of hitting disk at the cut.
    func prepareGaplessCuts(for project: DAWProject) {
        for section in project.sections {
            prepareGaplessCuts(for: section, in: project)
        }
    }

    func prepareGaplessCuts(for section: ArrangementSection, in project: DAWProject) {
        var slices: [SectionAudioCache.WarmSlice] = []
        for track in project.tracks {
            for clip in track.clips {
                // Prefer the live file so warm/arm share the same sample rate.
                // Header-only fallback still uses the file rate, never the project rate.
                let scheduledFile = scheduledClips[clip.id]?.file
                let fileURL = scheduledFile?.url ?? clip.fileURL
                let sampleRate = scheduledFile?.processingFormat.sampleRate
                    ?? (try? AVAudioFile(forReading: fileURL))?.processingFormat.sampleRate
                    ?? 0
                guard sampleRate > 0 else { continue }
                guard let layout = SectionAudioCache.padLayout(
                    clip: clip,
                    sectionStart: section.startTime,
                    sectionEnd: section.endTime,
                    sampleRate: sampleRate
                ) else { continue }
                slices.append(
                    SectionAudioCache.WarmSlice(
                        clipID: clip.id,
                        fileURL: fileURL,
                        sourceStartFrame: layout.sourceStart,
                        frameCount: layout.overlapFrames,
                        sampleRate: sampleRate,
                        destOffsetFrames: layout.destOffset,
                        sectionFrameCount: layout.sectionFrames
                    )
                )
                if let tail = SectionAudioCache.continuationTailRange(
                    clip: clip,
                    sectionEnd: section.endTime,
                    sampleRate: sampleRate
                ) {
                    slices.append(
                        SectionAudioCache.WarmSlice(
                            clipID: clip.id,
                            fileURL: fileURL,
                            sourceStartFrame: tail.sourceStart,
                            frameCount: tail.frameCount,
                            sampleRate: sampleRate
                        )
                    )
                }
            }
        }
        sectionAudioCache.warm(sectionID: section.id, name: section.name, slices: slices)
    }

    func cancelGaplessCuts(for sectionID: UUID) {
        SectionCueQueueMonitor.shared.cancel(sectionID: sectionID)
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
        let standby = AVAudioPlayerNode()
        let clipMixer = AVAudioMixerNode()
        engine.attach(player)
        engine.attach(standby)
        engine.attach(clipMixer)

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
        engine.connect(player, to: clipMixer, format: file.processingFormat)
        engine.connect(standby, to: clipMixer, format: file.processingFormat)
        engine.connect(clipMixer, to: unit, format: file.processingFormat)
        engine.connect(unit, to: trackMixer, format: file.processingFormat)
        timePitch = unit

        scheduledClips[clip.id] = ScheduledClip(
            clip: clip,
            trackID: trackID,
            file: file,
            player: player,
            standby: standby,
            clipMixer: clipMixer,
            timePitch: timePitch
        )
        sectionStandby.register(clipID: clip.id, live: player, standby: standby)
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
        cancelArmedBoundaryJump()
        activeSectionLoop = sectionLoop
        scheduledLoopCycleCount = 0
        loopTrackSchedule.removeAll()
        loopPlayAnchor = nil
        syncClipLayout(from: project)

        // A stale section cap at or before `time` schedules an empty range and
        // surfaces as "Audio playback is unavailable" after looping then seeking later.
        let effectiveScheduleUntil = scheduleUntil.flatMap { $0 > time + 0.001 ? $0 : nil }

        guard !scheduledClips.isEmpty else {
            lastPlaybackError = AudioEngineError.playbackUnavailable.errorDescription
            return false
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

        let orderedClips = orderedScheduledClips(for: project)

        for scheduled in orderedClips {
            safelyStopPlayer(scheduled.player)
            safelyStopPlayer(scheduled.standby)
            scheduled.player.volume = 1
            scheduled.standby.volume = 1
            sectionStandby.register(
                clipID: scheduled.clip.id,
                live: scheduled.player,
                standby: scheduled.standby
            )
            // Full restart: clear the live FIFO even while the engine stays running
            // (iPad). After a section loop, stop-without-reset + play(at:) is
            // HALC `got N want: 1` and the next play reports playbackUnavailable.
            safelyResetPlayer(scheduled.player)
            safelyResetPlayer(scheduled.standby)
        }
        sectionStandby.clearPrimes()

        var playersToStart: [AVAudioPlayerNode] = []

        let playbackAnchor = platformPlayback.resolvePlaybackStartAnchor(in: self)
        if sectionLoop != nil {
            loopPlayAnchor = playbackAnchor
            linearPlaybackAnchor = nil
        } else {
            linearPlaybackAnchor = platformPlayback.capturePlaybackStartAnchor(in: self)
            loopPlayAnchor = nil
        }

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
                    scheduleUntil: effectiveScheduleUntil,
                    playerStartAnchor: playbackAnchor
                ) else { continue }
                playersToStart.append(scheduled.player)
            }
        }

        if playersToStart.isEmpty, sectionLoop != nil {
            lastPlaybackError = AudioEngineError.playbackUnavailable.errorDescription
            activeSectionLoop = nil
            scheduledLoopCycleCount = 0
            loopTrackSchedule.removeAll()
            loopPlayAnchor = nil
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
        startLiveAndIdlePlayers(sortedPlayers, anchor: playbackAnchor)
        capturePlayerSessionHostOrigin()

        if sectionLoop != nil {
            scheduledLoopCycleCount = Self.initialLoopCycles
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

    /// Starts the live players that already have audio queued. Idle standbys stay
    /// stopped until a jump/continuation needs them — starting 12 empty nodes at
    /// `play()` overloads HAL and does not make loops gapless (Reaper keeps one
    /// stream and splices the wrap onto it).
    private func startLiveAndIdlePlayers(_ live: [AVAudioPlayerNode], anchor: AVAudioTime) {
        platformPlayback.startScheduledPlayers(live, anchor: anchor, in: self)
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

    /// Arms section loop by appending one body onto the live FIFO (`at: nil`).
    /// The linear cap already ends at section end; a timed `lastRenderTime + remaining`
    /// schedule leaves a gap, the node starves, and the future buffer never plays.
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

        var adopted = 0
        var cached = 0
        for scheduled in scheduledClips.values {
            let result = scheduleLoopBody(
                scheduled,
                loop: loop,
                cycles: Self.adoptedLoopCycles,
                labelPrefix: "adopt"
            )
            if result.scheduled {
                adopted += 1
                if result.cached { cached += 1 }
            }
        }

        if adopted > 0 {
            scheduledLoopCycleCount += Self.adoptedLoopCycles
            armedBoundaryJump = ArmedBoundaryJump(
                boundaryTime: loop.endTime,
                destinationTime: loop.startTime,
                isPreScheduled: true
            )
            SectionLoopDiagnostics.log(String(
                format: "adopted %d live FIFO cycle(s) at:nil cached %d/%d without restart",
                adopted,
                cached,
                adopted
            ))
            logLivePlayerClock(reason: "adopt", destinationTime: loop.endTime)
            return true
        }

        activeSectionLoop = nil
        scheduledLoopCycleCount = 0
        loopTrackSchedule.removeAll()

        guard !isAnyPlayerPlaying else {
            SectionLoopDiagnostics.log("adopt failed while players are live — skipping restart")
            return false
        }

        return enableSectionLoopDuringPlayback(
            project: project,
            loop: loop,
            playheadTime: playheadTime
        )
    }

    /// Rebuilds the player queue for gapless section looping from the current timeline position.
    @discardableResult
    func enableSectionLoopDuringPlayback(
        project: DAWProject,
        loop: SectionLoopContext,
        playheadTime: TimeInterval
    ) -> Bool {
        activeSectionLoop = loop
        scheduledLoopCycleCount = 0
        loopTrackSchedule.removeAll()
        syncClipLayout(from: project)

        guard !scheduledClips.isEmpty else {
            activeSectionLoop = nil
            return false
        }

        playbackStartTime = max(0, playheadTime)
        clearPlaybackClockState()

        let orderedClips = orderedScheduledClips(for: project)
        for scheduled in orderedClips {
            stopAndResetLane(scheduled)
        }
        sectionStandby.clearPrimes()

        var playersToStart: [AVAudioPlayerNode] = []

        let playbackAnchor = platformPlayback.resolvePlaybackStartAnchor(in: self)
        loopPlayAnchor = playbackAnchor

        for scheduled in orderedClips {
            if scheduleClipWithSectionLoop(
                scheduled,
                from: playbackStartTime,
                loop: loop,
                initialCycles: Self.initialLoopCycles,
                labelPrefix: "enable-loop",
                playerStartAnchor: playbackAnchor
            ) {
                playersToStart.append(scheduled.player)
            }
        }

        guard !playersToStart.isEmpty else {
            clearSectionLoopState()
            return false
        }

        let sortedPlayers = sortedPlayersForPlayback(
            playersToStart,
            trackOrder: trackOrderLookup(for: project)
        )
        startLiveAndIdlePlayers(sortedPlayers, anchor: playbackAnchor)
        capturePlayerSessionHostOrigin()
        scheduledLoopCycleCount = Self.initialLoopCycles

        SectionLoopDiagnostics.log(
            "enabled section loop from \(String(format: "%.6f", playbackStartTime))s with full reschedule"
        )
        return true
    }

    /// Drops loop bookkeeping while players keep rendering (no queue flush).
    func detachSectionLoopKeepingPlayback(at projectTimelineTime: TimeInterval) {
        activeSectionLoop = nil
        scheduledLoopCycleCount = 0
        loopTrackSchedule.removeAll()
        playbackStartTime = max(0, projectTimelineTime)
        reanchorPlaybackTimeline(at: projectTimelineTime)
        SectionLoopDiagnostics.log(
            "detached section loop at project time \(String(format: "%.6f", projectTimelineTime))s without restart"
        )
    }

    /// Arms the loop boundary with metadata only — no audio is pre-scheduled in player queues.
    /// Disabling loop is gap-free because nothing is in the FIFO to flush.
    /// The loop body restart (8 ms seamless lead-in) happens at boundary in completeRepeatAtBoundary.
    func armLoopBoundaryMetadataOnly(loop: SectionLoopContext) {
        cancelArmedBoundaryJump(flushScheduledAudio: false)
        activeSectionLoop = loop
        armedBoundaryJump = ArmedBoundaryJump(
            boundaryTime: loop.endTime,
            destinationTime: loop.startTime,
            isPreScheduled: false
        )
        SectionLoopDiagnostics.log(String(
            format: "armed loop boundary (metadata-only) at %.6fs",
            loop.endTime
        ))
    }

    /// Rebuilds the player queue with lead-in to section end plus one loop cycle (used when arm-only fails).
    @discardableResult
    func prepareSingleShotRepeatDuringPlayback(
        project: DAWProject,
        loop: SectionLoopContext,
        playheadTime: TimeInterval
    ) -> Bool {
        isLinearContinuationQueued = false
        cancelArmedBoundaryJump()
        syncClipLayout(from: project)

        guard !scheduledClips.isEmpty else { return false }
        guard platformPlayback.warmUpEngineForPlayback(in: self) else { return false }

        playbackStartTime = max(0, playheadTime)
        clearPlaybackSampleReference()

        let orderedClips = orderedScheduledClips(for: project)
        for scheduled in orderedClips {
            stopAndResetLane(scheduled)
        }
        sectionStandby.clearPrimes()

        let playbackAnchor = platformPlayback.resolvePlaybackStartAnchor(in: self)
        loopPlayAnchor = playbackAnchor
        linearPlaybackAnchor = platformPlayback.capturePlaybackStartAnchor(in: self)

        var playersToStart: [AVAudioPlayerNode] = []
        for scheduled in orderedClips {
            if scheduleClipWithSectionLoop(
                scheduled,
                from: playbackStartTime,
                loop: loop,
                initialCycles: 1,
                labelPrefix: "repeat-prep",
                playerStartAnchor: playbackAnchor
            ) {
                playersToStart.append(scheduled.player)
            }
        }

        guard !playersToStart.isEmpty else { return false }

        let sortedPlayers = sortedPlayersForPlayback(
            playersToStart,
            trackOrder: trackOrderLookup(for: project)
        )
        startLiveAndIdlePlayers(sortedPlayers, anchor: playbackAnchor)
        markPlaybackReferenceTime()
        capturePlayerSessionHostOrigin()

        armedBoundaryJump = ArmedBoundaryJump(
            boundaryTime: loop.endTime,
            destinationTime: loop.startTime
        )
        SectionLoopDiagnostics.log(
            "prepared single-shot repeat from \(String(format: "%.6f", playbackStartTime))s"
        )
        return true
    }

    /// Pre-schedules a linear jump at a future boundary (queued section / continue-to-next).
    @discardableResult
    func armTimelineJumpAtBoundary(
        boundaryTime: TimeInterval,
        destinationTime: TimeInterval,
        playheadTime: TimeInterval,
        destinationEndTime: TimeInterval? = nil,
        destinationSectionID: UUID? = nil
    ) -> Bool {
        activeSectionLoop = nil
        loopTrackSchedule.removeAll()
        loopPlayAnchor = nil
        cancelArmedBoundaryJump(flushScheduledAudio: false)

        if isAnyPlayerPlaying,
           appendLivePlayback(
            from: destinationTime,
            until: destinationEndTime,
            label: "live-jump",
            isLinearContinuation: false
           ) {
            armedBoundaryJump = ArmedBoundaryJump(
                boundaryTime: boundaryTime,
                destinationTime: destinationTime,
                isPreScheduled: true
            )
            SectionLoopDiagnostics.log(String(
                format: "armed timeline jump %.6fs -> %.6fs on live FIFO",
                boundaryTime,
                destinationTime
            ))
            return true
        }

        let playhead = currentTimelineTime() ?? playheadTime
        let cue = snapshotStandbyCue(boundary: boundaryTime, playhead: playhead)

        var armed = false
        var cachedCount = 0
        var cuedCount = 0
        for scheduled in scheduledClips.values {
            let result = primeStandbyWithTimelineRange(
                scheduled,
                timelineStart: destinationTime,
                timelineEnd: destinationEndTime ?? scheduled.clip.endTime,
                cue: cue,
                cacheSectionID: destinationSectionID
            )
            if result.primed {
                armed = true
                cuedCount += 1
                if result.cached { cachedCount += 1 }
            }
        }
        if armed {
            sectionStandby.setIntent(.jump)
            logStandbyCue(cue, clipCount: cuedCount, cachedCount: cachedCount)
        }

        if armed {
            armedBoundaryJump = ArmedBoundaryJump(
                boundaryTime: boundaryTime,
                destinationTime: destinationTime
            )
            SectionLoopDiagnostics.log(String(
                format: "armed timeline jump %.6fs -> %.6fs",
                boundaryTime,
                destinationTime
            ))
            return true
        }

        return false
    }

    /// Cues uncapped linear audio on standby to start at `sectionEnd` (host time).
    @discardableResult
    func armLinearContinuationAtSectionEnd(
        sectionEnd: TimeInterval,
        playheadTime: TimeInterval,
        sectionID: UUID? = nil
    ) -> Bool {
        if isAnyPlayerPlaying,
           appendLivePlayback(
            from: sectionEnd,
            until: nil,
            cacheSectionID: sectionID,
            label: "live-cont"
           ) {
            return true
        }

        if SectionStandbyCoordinator.shouldSkipRearm(
            currentIntent: sectionStandby.currentIntent,
            expectedIntent: .continuation,
            hasPrimeOrCue: sectionStandby.hasAnyPrime || sectionStandby.hasAnyCued
        ) {
            isLinearContinuationQueued = true
            return true
        }

        loopTrackSchedule.removeAll()
        loopPlayAnchor = nil
        resetIdleStandbyPlayers()

        let playhead = currentTimelineTime() ?? playheadTime
        let cue = snapshotStandbyCue(boundary: sectionEnd, playhead: playhead)

        var armed = false
        var cachedCount = 0
        var cuedCount = 0
        for scheduled in scheduledClips.values {
            let cachedEnd = min(
                scheduled.clip.endTime,
                sectionEnd + SectionAudioCache.continuationCacheSeconds
            )
            let result = primeStandbyWithTimelineRange(
                scheduled,
                timelineStart: sectionEnd,
                timelineEnd: cachedEnd,
                cue: cue,
                cacheSectionID: sectionID
            )
            if result.primed {
                armed = true
                cuedCount += 1
                if result.cached { cachedCount += 1 }
                if scheduled.clip.endTime > cachedEnd {
                    appendFileAfterCachedHead(scheduled, fromTimeline: cachedEnd)
                }
            }
        }
        if armed {
            sectionStandby.setIntent(.continuation)
        }

        if armed {
            isLinearContinuationQueued = true
            logStandbyCue(cue, clipCount: cuedCount, cachedCount: cachedCount)
            SectionLoopDiagnostics.log(String(
                format: "armed linear continuation at section end %.6fs",
                sectionEnd
            ))
            return true
        }

        return false
    }

    /// Re-syncs metadata after a repeat-at-end boundary. Requires loop audio already queued.
    func completeRepeatBoundaryJump(at projectTimelineTime: TimeInterval) {
        logLivePlayerClock(reason: "wrap-before", destinationTime: projectTimelineTime)
        cachedSectionLoopActive = false
        armedBoundaryJump = nil
        scheduledLoopCycleCount = max(0, scheduledLoopCycleCount - 1)
        reanchorPlaybackTimeline(at: projectTimelineTime)
        logLivePlayerClock(reason: "wrap-after", destinationTime: projectTimelineTime)
        SectionLoopDiagnostics.log(String(
            format: "completed repeat boundary jump at %.6fs without restart",
            projectTimelineTime
        ))
    }

    /// Re-syncs metadata after linear continuation past section end (pre-armed, no player restart).
    func completeLinearContinuationAtSectionEnd(at projectTimelineTime: TimeInterval) {
        armedBoundaryJump = nil
        activeSectionLoop = nil
        loopTrackSchedule.removeAll()
        loopPlayAnchor = nil
        playbackStartTime = max(0, projectTimelineTime)
        clearPlaybackSampleReference()
        SectionLoopDiagnostics.log(String(
            format: "completed linear continuation at section end %.6fs without restart",
            projectTimelineTime
        ))
    }

    /// Re-syncs after a queued section / continue-to-next boundary jump.
    func completeSectionBoundaryJump(at projectTimelineTime: TimeInterval) {
        armedBoundaryJump = nil
        activeSectionLoop = nil
        loopTrackSchedule.removeAll()
        loopPlayAnchor = nil
        playbackStartTime = max(0, projectTimelineTime)
        reanchorPlaybackTimeline(at: projectTimelineTime)
        syncLanesFromStandbyCoordinator()
        retireFinishedPlayers()
        startIdlePlayersCovering(time: projectTimelineTime)
        SectionLoopDiagnostics.log(String(
            format: "completed section boundary jump at %.6fs without restart",
            projectTimelineTime
        ))
    }

    /// Starts players that have a destination buffer queued but were never started in the
    /// current section (clips that only exist at the jump target).
    private func startIdlePlayersCovering(time: TimeInterval) {
        syncLanesFromStandbyCoordinator()
        for scheduled in scheduledClips.values {
            guard scheduled.clip.startTime <= time, time < scheduled.clip.endTime else { continue }
            let live = sectionStandby.liveNode(for: scheduled.clip.id) ?? scheduled.player
            let wasCued = sectionStandby.isCued(clipID: scheduled.clip.id)
            if live.isPlaying { continue }
            sectionStandby.startPrimedStandby(
                clipID: scheduled.clip.id,
                allowImmediateStart: false
            )
            let started = sectionStandby.liveNode(for: scheduled.clip.id) ?? live
            // Cued `play(at:)` owns the start. Untimed play() is HAL `got N want: 1`.
            if !started.isPlaying, !wasCued {
                safelyPlayPlayer(started)
            }
        }
    }

    private func syncLanesFromStandbyCoordinator() {
        for id in scheduledClips.keys {
            guard let live = sectionStandby.liveNode(for: id),
                  let standby = sectionStandby.standbyNode(for: id),
                  var scheduled = scheduledClips[id] else { continue }
            scheduled.player = live
            scheduled.standby = standby
            scheduledClips[id] = scheduled
        }
    }

    /// Pauses the retired A/B node so it cannot keep the transport clock at section end.
    /// Never pauses a cued standby — that cancels the gapless cut.
    private func retireFinishedPlayers() {
        for (clipID, scheduled) in scheduledClips {
            let live = sectionStandby.liveNode(for: clipID) ?? scheduled.player
            let standby = sectionStandby.standbyNode(for: clipID) ?? scheduled.standby
            guard standby !== live, standby.isPlaying, isNodeConnected(standby) else { continue }
            let shouldPause = SectionStandbyCoordinator.shouldPauseRetiredStandby(
                isCued: sectionStandby.isCued(clipID: clipID),
                standbyIsLive: false,
                incomingLiveIsRendering: isPlayerAudiblyRendering(live)
            )
            guard shouldPause else { continue }
            standby.pause()
        }
    }

    /// Re-syncs the project clock after a pre-scheduled boundary jump fired (no player restart).
    func completeArmedBoundaryJump(at projectTimelineTime: TimeInterval) {
        armedBoundaryJump = nil
        loopTrackSchedule.removeAll()
        loopPlayAnchor = nil
        playbackStartTime = max(0, projectTimelineTime)
        reanchorPlaybackTimeline(at: projectTimelineTime)
        SectionLoopDiagnostics.log(String(
            format: "completed armed boundary jump at %.6fs without restart",
            projectTimelineTime
        ))
    }

    func cancelArmedBoundaryJump(flushScheduledAudio: Bool = false) {
        armedBoundaryJump = nil
        loopTrackSchedule.removeAll()
        resetIdleStandbyPlayers()
        sectionStandby.clearPrimes()
        isLinearContinuationQueued = false
        // Next intent lives on standby only — never flush the live player.
        _ = flushScheduledAudio
    }

    /// Jumps playback to a timeline position without resetting the audio graph (minimal gap).
    @discardableResult
    func seamlessJumpPlayback(
        to time: TimeInterval,
        project: DAWProject,
        scheduleUntil: TimeInterval? = nil
    ) -> Bool {
        lastPlaybackError = nil
        isLinearContinuationQueued = false
        cancelArmedBoundaryJump()
        activeSectionLoop = nil
        loopTrackSchedule.removeAll()
        loopPlayAnchor = nil
        syncClipLayout(from: project)

        guard !scheduledClips.isEmpty else {
            lastPlaybackError = AudioEngineError.playbackUnavailable.errorDescription
            return false
        }

        guard platformPlayback.warmUpEngineForPlayback(in: self) else {
            lastPlaybackError = AudioEngineError.playbackUnavailable.errorDescription
            return false
        }

        playbackStartTime = max(0, time)
        playerQueueEndFrames.removeAll()
        let jumpAnchor = makeSynchronizedPlaybackAnchor(leadInSeconds: Self.seamlessJumpLeadInSeconds)
            ?? platformPlayback.resolvePlaybackStartAnchor(in: self)

        let orderedClips = orderedScheduledClips(for: project)
        for scheduled in orderedClips {
            stopAndResetLane(scheduled)
        }
        sectionStandby.clearPrimes()

        var playersToStart: [AVAudioPlayerNode] = []
        for scheduled in orderedClips {
            guard shouldPlayClip(scheduled.clip, at: playbackStartTime) else { continue }
            guard scheduleClip(
                scheduled,
                from: playbackStartTime,
                scheduleUntil: scheduleUntil,
                playerStartAnchor: jumpAnchor
            ) else { continue }
            playersToStart.append(scheduled.player)
        }

        guard !playersToStart.isEmpty else {
            lastPlaybackError = AudioEngineError.playbackUnavailable.errorDescription
            return false
        }

        let sortedPlayers = sortedPlayersForPlayback(
            playersToStart,
            trackOrder: trackOrderLookup(for: project)
        )
        startLiveAndIdlePlayers(sortedPlayers, anchor: jumpAnchor)
        linearPlaybackAnchor = platformPlayback.capturePlaybackStartAnchor(in: self)
        capturePlayerSessionHostOrigin()

        SectionLoopDiagnostics.log(String(
            format: "seamless jump to %.6fs without graph reset",
            playbackStartTime
        ))
        return true
    }

    /// Re-schedules linear playback from `time` through `boundary` without entering loop mode.
    /// Used when repeat-at-end is armed so already-queued audio cannot run past the section end.
    @discardableResult
    func rescheduleLinearUntilBoundary(
        from time: TimeInterval,
        boundary: TimeInterval,
        project: DAWProject
    ) -> Bool {
        guard boundary > time else { return false }

        lastPlaybackError = nil
        isLinearContinuationQueued = false
        cancelArmedBoundaryJump()
        activeSectionLoop = nil
        loopTrackSchedule.removeAll()
        loopPlayAnchor = nil
        syncClipLayout(from: project)

        guard !scheduledClips.isEmpty else {
            lastPlaybackError = AudioEngineError.playbackUnavailable.errorDescription
            return false
        }

        guard platformPlayback.warmUpEngineForPlayback(in: self) else {
            lastPlaybackError = AudioEngineError.playbackUnavailable.errorDescription
            return false
        }

        playbackStartTime = max(0, time)
        clearPlaybackSampleReference()
        playerQueueEndFrames.removeAll()

        let orderedClips = orderedScheduledClips(for: project)
        for scheduled in orderedClips {
            stopAndResetLane(scheduled)
        }
        sectionStandby.clearPrimes()

        let playbackAnchor = platformPlayback.resolvePlaybackStartAnchor(in: self)
        var playersToStart: [AVAudioPlayerNode] = []
        for scheduled in orderedClips {
            guard shouldPlayClip(scheduled.clip, at: playbackStartTime) else { continue }
            guard scheduleClip(
                scheduled,
                from: playbackStartTime,
                scheduleUntil: boundary,
                playerStartAnchor: playbackAnchor
            ) else { continue }
            playersToStart.append(scheduled.player)
        }

        guard !playersToStart.isEmpty else {
            lastPlaybackError = AudioEngineError.playbackUnavailable.errorDescription
            return false
        }

        let sortedPlayers = sortedPlayersForPlayback(
            playersToStart,
            trackOrder: trackOrderLookup(for: project)
        )
        startLiveAndIdlePlayers(sortedPlayers, anchor: playbackAnchor)
        linearPlaybackAnchor = platformPlayback.capturePlaybackStartAnchor(in: self)
        capturePlayerSessionHostOrigin()

        SectionLoopDiagnostics.log(String(
            format: "rescheduled linear %.6fs -> boundary %.6fs",
            playbackStartTime,
            boundary
        ))
        return true
    }

    /// Appends a timeline range onto already-playing live nodes (`at: nil`).
    /// Used for loop-exit continuation and queued jumps so we never `play()` standbys.
    ///
    /// Prefer cached PCM tails at a section cut (`scheduleBuffer`). File slices
    /// at that quantum overload HAL (`skipping cycle`) and leave a silence gap.
    @discardableResult
    func appendLivePlayback(
        from startTime: TimeInterval,
        until endTime: TimeInterval?,
        project: DAWProject? = nil,
        cacheSectionID: UUID? = nil,
        label: String,
        isLinearContinuation: Bool = true
    ) -> Bool {
        if let project {
            syncClipLayout(from: project)
        }
        var appended = 0
        var usedCachedTail = false
        var farthestScheduled = startTime
        let sliceWindow = SectionAudioCache.continuationCacheSeconds
            * TimeInterval(Self.maxImmediateContinuationSlices)
        for scheduled in scheduledClips.values {
            let live = sectionStandby.liveNode(for: scheduled.clip.id) ?? scheduled.player
            guard isNodeConnected(live), live.isPlaying else { continue }
            let sampleRate = scheduled.file.processingFormat.sampleRate
            guard sampleRate > 0 else { continue }

            let startFrame = TimelineSampleGrid.frames(at: startTime, sampleRate: sampleRate)
            let clipEndFrame = TimelineSampleGrid.frames(at: scheduled.clip.endTime, sampleRate: sampleRate)
            let capEndFrame = endTime.map {
                TimelineSampleGrid.frames(at: $0, sampleRate: sampleRate)
            } ?? clipEndFrame
            let endFrame = min(clipEndFrame, capEndFrame)
            guard endFrame > startFrame else { continue }

            var target = scheduled
            target.player = live

            if let cached = cachedContinuationTail(
                sectionID: cacheSectionID,
                clip: scheduled.clip,
                sectionEnd: startTime,
                sampleRate: sampleRate
            ) {
                live.scheduleBuffer(cached, at: nil, options: [])
                appended += 1
                usedCachedTail = true
                farthestScheduled = max(
                    farthestScheduled,
                    startTime + Double(cached.frameLength) / sampleRate
                )
                SectionLoopDiagnostics.log(String(
                    format: "%@ | clip \"%@\" cached tail frames %u at:nil",
                    label,
                    scheduled.clip.name,
                    cached.frameLength
                ))
                continue
            }

            if scheduleTimelineRangeInSlices(
                target,
                timelineStartFrame: startFrame,
                timelineEndFrame: endFrame,
                at: nil,
                label: label,
                maxSlices: Self.maxImmediateContinuationSlices
            ) {
                appended += 1
                let fileEnd = min(
                    min(scheduled.clip.endTime, startTime + sliceWindow),
                    endTime ?? (startTime + sliceWindow)
                )
                farthestScheduled = max(farthestScheduled, fileEnd)
            }
        }
        guard appended > 0 else { return false }
        activeSectionLoop = nil
        scheduledLoopCycleCount = 0
        if isLinearContinuation {
            isLinearContinuationQueued = true
            let clipMax = scheduledClips.values.map(\.clip.endTime).max() ?? startTime
            if continuationLimit == nil {
                continuationLimit = endTime ?? clipMax
            }
            let cap = continuationLimit ?? clipMax
            continuationQueuedUntil = min(cap, farthestScheduled)
            SectionLoopDiagnostics.log(String(
                format: "appended live FIFO %@ from %.6fs to %.6fs (%d clips, more until %.3fs)%@",
                label,
                startTime,
                continuationQueuedUntil ?? startTime,
                appended,
                cap,
                usedCachedTail ? " cached-tail" : ""
            ))
        } else {
            SectionLoopDiagnostics.log(String(
                format: "appended live FIFO %@ from %.6fs to %.6fs (%d clips, more until %.3fs)",
                label,
                startTime,
                endTime ?? farthestScheduled,
                appended,
                endTime ?? farthestScheduled
            ))
        }
        return true
    }

    private func cachedContinuationTail(
        sectionID: UUID?,
        clip: AudioClip,
        sectionEnd: TimeInterval,
        sampleRate: Double
    ) -> AVAudioPCMBuffer? {
        guard let sectionID else { return nil }
        guard let range = SectionAudioCache.continuationTailRange(
            clip: clip,
            sectionEnd: sectionEnd,
            sampleRate: sampleRate
        ) else { return nil }
        return sectionAudioCache.cachedIfPresent(
            sectionID: sectionID,
            clipID: clip.id,
            sourceStartFrame: range.sourceStart,
            frameCount: range.frameCount
        )
    }

    /// Keeps a short continuation window on the live FIFO so we never dump the rest
    /// of the song at the section cut (that HAL-skips and leaves a silence gap).
    func refillLinearContinuation(playheadTime: TimeInterval, project: DAWProject) {
        guard isLinearContinuationQueued, isAnyPlayerPlaying,
              let queuedUntil = continuationQueuedUntil,
              let limit = continuationLimit,
              queuedUntil + 0.01 < limit,
              playheadTime >= queuedUntil - Self.continuationRefillLeadTime else { return }
        _ = appendLivePlayback(
            from: queuedUntil,
            until: limit,
            project: project,
            label: "live-cont-refill"
        )
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

        var appended = 0
        var cached = 0
        for scheduled in scheduledClips.values {
            let result = scheduleLoopBody(
                scheduled,
                loop: loop,
                cycles: cycleCount,
                labelPrefix: "append"
            )
            if result.scheduled {
                appended += 1
                if result.cached { cached += 1 }
            }
        }

        if appended > 0 {
            scheduledLoopCycleCount += cycleCount
            if let loop = activeSectionLoop {
                armedBoundaryJump = ArmedBoundaryJump(
                    boundaryTime: loop.endTime,
                    destinationTime: loop.startTime,
                    isPreScheduled: true
                )
            }
            SectionLoopDiagnostics.log(String(
                format: "appended %d live FIFO cycle(s) at:nil cached %d/%d; queued batches=%d",
                appended,
                cached,
                appended,
                scheduledLoopCycleCount
            ))
        }

        return appended > 0
    }

    func clearSectionLoopState() {
        activeSectionLoop = nil
        scheduledLoopCycleCount = 0
        loopTrackSchedule.removeAll()
        loopPlayAnchor = nil
        isLinearContinuationQueued = false
        continuationQueuedUntil = nil
        continuationLimit = nil
        cachedSectionLoopActive = false
        cancelArmedBoundaryJump()
    }

    /// Marks the queued linear continuation as consumed (section exited, audio is now normal linear).
    func clearLinearContinuationQueuedFlag() {
        isLinearContinuationQueued = false
        continuationQueuedUntil = nil
        continuationLimit = nil
    }

    /// Clears repeat-at-end bookkeeping after the boundary fired; player queue keeps running.
    func releaseRepeatBoundaryLoopMetadata() {
        armedBoundaryJump = nil
        activeSectionLoop = nil
        scheduledLoopCycleCount = 0
        loopTrackSchedule.removeAll()
        cachedSectionLoopActive = false
    }

    /// Pre-queues linear audio from `loop.endTime` into the player queue so it plays
    /// immediately after the loop body ends — zero-gap section exit after a repeat.
    ///
    /// **Must be called BEFORE `releaseRepeatBoundaryLoopMetadata()`** so that
    /// `loopTrackSchedule` is still populated with the exact player-sample offset at
    /// which the loop body ends (pre-scheduled path).  When `loopTrackSchedule` is
    /// empty (seamless/non-pre-scheduled path) the loop body duration is derived from
    /// `loop.endTime – destination` instead.
    func scheduleLinearContinuationAfterLoopBody(
        loop: SectionLoopContext,
        destination: TimeInterval,
        project: DAWProject
    ) {
        syncClipLayout(from: project)
        let orderedClips = orderedScheduledClips(for: project)

        for scheduled in orderedClips {
            let sampleRate = scheduled.file.processingFormat.sampleRate
            guard sampleRate > 0 else { continue }

            let continuationStartFrame = TimelineSampleGrid.frames(at: loop.endTime, sampleRate: sampleRate)
            let clipEndFrame = TimelineSampleGrid.frames(at: scheduled.clip.endTime, sampleRate: sampleRate)
            guard clipEndFrame > continuationStartFrame else { continue }

            // Player sample time at which the loop body ends — where continuation starts.
            let nextOffset: Int64
            if let trackState = loopTrackSchedule[scheduled.clip.id] {
                // Pre-scheduled path: loopTrackSchedule carries the exact offset.
                nextOffset = trackState.nextOffsetFrames
            } else {
                // Seamless path: loop body spans [destination → loop.endTime].
                let loopBodyFrames = continuationStartFrame
                    - TimelineSampleGrid.frames(at: destination, sampleRate: sampleRate)
                guard loopBodyFrames > 0 else { continue }
                nextOffset = loopBodyFrames
            }
            guard nextOffset > 0 else { continue }

            // Both iOS and macOS schedule relative to player sample time (anchor ignored).
            let scheduleAt = AVAudioTime(sampleTime: nextOffset, atRate: sampleRate)

            scheduleTimelineSegment(
                scheduled,
                timelineStartFrame: continuationStartFrame,
                timelineEndFrame: clipEndFrame,
                at: scheduleAt,
                label: "loop-exit-cont"
            )
        }

        if linearPlaybackAnchor == nil {
            linearPlaybackAnchor = loopPlayAnchor
        }

        isLinearContinuationQueued = true
        SectionLoopDiagnostics.log(String(
            format: "queued linear continuation from %.6fs after loop body (continuation queued)",
            loop.endTime
        ))
    }

    private func ensureLoopPlayAnchorForLivePlayback() {
        guard loopPlayAnchor == nil else { return }

        for scheduled in scheduledClips.values {
            guard scheduled.player.isPlaying,
                  let nodeTime = scheduled.player.lastRenderTime,
                  nodeTime.isSampleTimeValid else { continue }
            loopPlayAnchor = nodeTime
            return
        }

        // No playing player (all stopped after a FIFO flush for a section jump).
        // Fall back to the engine output node so arm segments for the destination
        // section receive a valid sample-time anchor and start at the correct boundary.
        if let outputTime = engine.outputNode.lastRenderTime,
           outputTime.isSampleTimeValid {
            loopPlayAnchor = outputTime
        }
    }

    /// Leaves section loop mode and resumes linear scheduling without a full engine warm-up.
    @discardableResult
    func exitSectionLoopToLinearPlayback(at time: TimeInterval, project: DAWProject) -> Bool {
        clearSectionLoopState()
        syncClipLayout(from: project)

        guard !scheduledClips.isEmpty else {
            lastPlaybackError = AudioEngineError.playbackUnavailable.errorDescription
            return false
        }

        playbackStartTime = max(0, time)
        clearPlaybackClockState()

        let orderedClips = orderedScheduledClips(for: project)
        for scheduled in orderedClips {
            stopAndResetLane(scheduled)
        }
        sectionStandby.clearPrimes()

        var playersToStart: [AVAudioPlayerNode] = []

        let playbackAnchor = platformPlayback.resolvePlaybackStartAnchor(in: self)
        for scheduled in orderedClips {
            guard shouldPlayClip(scheduled.clip, at: playbackStartTime) else { continue }
            guard scheduleClip(
                scheduled,
                from: playbackStartTime,
                scheduleUntil: nil,
                playerStartAnchor: playbackAnchor
            ) else { continue }
            playersToStart.append(scheduled.player)
        }

        guard !playersToStart.isEmpty else {
            lastPlaybackError = AudioEngineError.playbackUnavailable.errorDescription
            return false
        }

        let sortedPlayers = sortedPlayersForPlayback(
            playersToStart,
            trackOrder: trackOrderLookup(for: project)
        )
        startLiveAndIdlePlayers(sortedPlayers, anchor: playbackAnchor)
        capturePlayerSessionHostOrigin()
        return true
    }

    /// True when fewer than `minCyclesAhead` loop cycles remain scheduled in the player queue.
    func needsLoopCycleTopUp(minCyclesAhead: Int = 3) -> Bool {
        guard activeSectionLoop != nil, !loopTrackSchedule.isEmpty else { return false }

        let elapsedSeconds: TimeInterval
        if let timeline = currentTimelineTime() {
            elapsedSeconds = max(0, timeline - playbackStartTime)
        } else {
            return true
        }

        for (clipID, state) in loopTrackSchedule {
            guard let scheduled = scheduledClips[clipID] else { continue }
            let sampleRate = scheduled.file.processingFormat.sampleRate
            guard sampleRate > 0, state.bodyFrameCount > 0 else { continue }

            let elapsedFrames = TimelineSampleGrid.frames(at: elapsedSeconds, sampleRate: sampleRate)
            let framesAhead = state.nextOffsetFrames - elapsedFrames
            let cyclesAhead = framesAhead / state.bodyFrameCount
            if cyclesAhead < minCyclesAhead {
                return true
            }
        }

        return false
    }

    /// Stops queued audio immediately without clearing section loop bookkeeping.
    func flushPlayerQueues() {
        isLinearContinuationQueued = false
        continuationQueuedUntil = nil
        continuationLimit = nil
        for scheduled in scheduledClips.values {
            stopAndResetLane(scheduled)
        }
        sectionStandby.clearPrimes()
        playbackReferenceHostTime = nil
        playerSessionHostOrigin = nil
        clearPlaybackSampleReference()
        playerQueueEndFrames.removeAll()
        resetMeters()
    }

    /// Diagnostic only: live player sample clocks vs playhead. Does not start, stop, or recapture.
    private func logLivePlayerClock(reason: String, destinationTime: TimeInterval?) {
        var liveCount = 0
        var playingCount = 0
        var minSample: AVAudioFramePosition?
        var maxSample: AVAudioFramePosition?
        var minTimeline: TimeInterval?
        var maxTimeline: TimeInterval?
        var exampleName: String?
        var examplePlaying: Bool?
        var exampleSample: AVAudioFramePosition?
        var exampleElapsed: TimeInterval?
        var exampleTimeline: TimeInterval?

        let reference = playbackReferencePlayerSample
        for scheduled in scheduledClips.values.sorted(by: { $0.clip.name < $1.clip.name }) {
            let live = sectionStandby.liveNode(for: scheduled.clip.id) ?? scheduled.player
            liveCount += 1
            let isPlaying = live.isPlaying
            if isPlaying { playingCount += 1 }
            guard let nodeTime = live.lastRenderTime,
                  nodeTime.isSampleTimeValid,
                  nodeTime.sampleRate > 0 else { continue }

            let sampleTime = nodeTime.sampleTime
            minSample = min(minSample ?? sampleTime, sampleTime)
            maxSample = max(maxSample ?? sampleTime, sampleTime)

            var elapsed: TimeInterval?
            var timeline: TimeInterval?
            if let reference {
                let elapsedValue = Double(sampleTime - reference) / nodeTime.sampleRate
                elapsed = elapsedValue
                timeline = playbackStartTime + elapsedValue
            }
            if let timeline {
                minTimeline = min(minTimeline ?? timeline, timeline)
                maxTimeline = max(maxTimeline ?? timeline, timeline)
            }
            if exampleName == nil {
                exampleName = scheduled.clip.name
                examplePlaying = isPlaying
                exampleSample = sampleTime
                exampleElapsed = elapsed
                exampleTimeline = timeline
            }
        }

        let outputSample: AVAudioFramePosition? = {
            guard let outputTime = engine.outputNode.lastRenderTime, outputTime.isSampleTimeValid else {
                return nil
            }
            return outputTime.sampleTime
        }()

        let sampleRange: (AVAudioFramePosition, AVAudioFramePosition)? = {
            guard let minSample, let maxSample else { return nil }
            return (minSample, maxSample)
        }()
        let timelineRange: (TimeInterval, TimeInterval)? = {
            guard let minTimeline, let maxTimeline else { return nil }
            return (minTimeline, maxTimeline)
        }()

        SectionLoopDiagnostics.logPlayerClockSnapshot(
            reason: reason,
            destinationTime: destinationTime,
            playbackStartTime: playbackStartTime,
            engineTime: timelineRange.map(\.1),
            referenceSample: reference,
            outputSample: outputSample,
            liveCount: liveCount,
            playingCount: playingCount,
            sampleRange: sampleRange,
            timelineRange: timelineRange,
            exampleName: exampleName,
            examplePlaying: examplePlaying,
            exampleSample: exampleSample,
            exampleElapsed: exampleElapsed,
            exampleTimeline: exampleTimeline
        )
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
            safelyStopPlayer(scheduled.standby)
            scheduled.player.volume = 1
            scheduled.standby.volume = 1
            scheduled.player.reset()
            scheduled.standby.reset()
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
            safelyStopPlayer(scheduled.standby)
            scheduled.player.volume = 1
            scheduled.standby.volume = 1
            scheduled.player.reset()
            scheduled.standby.reset()
        }
        renderedPlayerIDs.removeAll(keepingCapacity: false)
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

        let coordinator = sectionStandby
        let clipID = clip.id
        let capCompletion: (@Sendable () -> Void)?
        if scheduleUntil != nil {
            capCompletion = {
                coordinator.startPrimedStandby(clipID: clipID)
            }
        } else {
            capCompletion = nil
        }
        platformPlayback.scheduleFileSegment(
            player: player,
            file: file,
            startingFrame: sourceStartFrame,
            frameCount: frameCount,
            at: scheduleAt,
            completionHandler: capCompletion,
            in: self
        )
        noteQueuedPlayerFrames(
            clipID: clip.id,
            startSample: scheduleAt?.isSampleTimeValid == true ? scheduleAt!.sampleTime : 0,
            frameCount: frameCount
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
        var firstCycleOffsetFrames: Int64 = 0

        if playheadFrame < loopEndFrame {
            let segmentStart = max(playheadFrame, clipStartFrame)
            let segmentEnd = min(loopEndFrame, clipEndFrame)
            if segmentEnd > segmentStart {
                firstCycleOffsetFrames = segmentEnd - playheadFrame
                if scheduleTimelineSegment(
                    scheduled,
                    timelineStartFrame: segmentStart,
                    timelineEndFrame: segmentEnd,
                    at: nil,
                    label: "\(labelPrefix)-lead-in"
                ) {
                    scheduledAny = true
                }
            }
        }

        if scheduleLoopCycles(
            scheduled,
            loop: loop,
            cycles: initialCycles,
            labelPrefix: labelPrefix,
            playerStartAnchor: playerStartAnchor,
            firstCycleOffsetFrames: firstCycleOffsetFrames
        ) {
            scheduledAny = true
        }

        return scheduledAny
    }

    private struct LoopBodyBounds {
        let bodyStart: Int64
        let bodyEnd: Int64

        var frameCount: Int64 { bodyEnd - bodyStart }
    }

    private func loopBodyBounds(for scheduled: ScheduledClip, loop: SectionLoopContext) -> LoopBodyBounds? {
        let sampleRate = scheduled.file.processingFormat.sampleRate
        guard sampleRate > 0 else { return nil }

        let clipStartFrame = TimelineSampleGrid.frames(at: scheduled.clip.startTime, sampleRate: sampleRate)
        let clipEndFrame = TimelineSampleGrid.frames(at: scheduled.clip.endTime, sampleRate: sampleRate)
        let loopStartFrame = TimelineSampleGrid.frames(at: loop.startTime, sampleRate: sampleRate)
        let loopEndFrame = TimelineSampleGrid.frames(at: loop.endTime, sampleRate: sampleRate)

        let bodyStart = max(loopStartFrame, clipStartFrame)
        let bodyEnd = min(loopEndFrame, clipEndFrame)
        guard bodyEnd > bodyStart else { return nil }
        return LoopBodyBounds(bodyStart: bodyStart, bodyEnd: bodyEnd)
    }

    /// One loop body on the live node. `at: nil` appends after the current cap (sample-accurate).
    /// Timed `lastRenderTime + remaining` is not used: a 60 ms miss starves the node and the
    /// future buffer never plays.
    @discardableResult
    private func scheduleLoopBody(
        _ scheduled: ScheduledClip,
        loop: SectionLoopContext,
        cycles: Int,
        labelPrefix: String
    ) -> (scheduled: Bool, cached: Bool) {
        guard cycles > 0 else { return (false, false) }
        guard let bounds = loopBodyBounds(for: scheduled, loop: loop) else { return (false, false) }

        let live = sectionStandby.liveNode(for: scheduled.clip.id) ?? scheduled.player
        guard isNodeConnected(live) else { return (false, false) }

        var target = scheduled
        target.player = live

        let cachedBody = sectionAudioCache.sectionBody(
            sectionID: loop.sectionID,
            clipID: scheduled.clip.id
        )

        var scheduledAny = false
        var usedCache = false
        for cycle in 0..<cycles {
            if let cachedBody {
                live.scheduleBuffer(cachedBody, at: nil, options: [])
                scheduledAny = true
                usedCache = true
                SectionLoopDiagnostics.log(String(
                    format: "%@-cycle-%d | clip \"%@\" cached body frames %u at:nil",
                    labelPrefix,
                    cycle + 1,
                    scheduled.clip.name,
                    cachedBody.frameLength
                ))
                continue
            }
            if scheduleTimelineSegment(
                target,
                timelineStartFrame: bounds.bodyStart,
                timelineEndFrame: bounds.bodyEnd,
                at: nil,
                label: "\(labelPrefix)-cycle-\(cycle + 1)"
            ) {
                scheduledAny = true
            }
        }
        return (scheduledAny, usedCache)
    }

    /// Schedules loop cycles at sample-accurate offsets from the shared play anchor (gapless).
    @discardableResult
    private func scheduleLoopCycles(
        _ scheduled: ScheduledClip,
        loop: SectionLoopContext,
        cycles: Int,
        labelPrefix: String,
        playerStartAnchor: AVAudioTime? = nil,
        firstCycleOffsetFrames: Int64 = 0,
        firstCycleTimelineTime: TimeInterval? = nil,
        playheadTime: TimeInterval? = nil
    ) -> Bool {
        let sampleRate = scheduled.file.processingFormat.sampleRate
        guard sampleRate > 0, cycles > 0 else { return false }
        guard let bounds = loopBodyBounds(for: scheduled, loop: loop) else { return false }

        let bodyFrameCount = bounds.frameCount
        guard bodyFrameCount > 0 else { return false }

        let clipID = scheduled.clip.id
        var nextOffset: Int64

        if let firstCycleTimelineTime, let playheadTime {
            let playheadFrame = TimelineSampleGrid.frames(at: playheadTime, sampleRate: sampleRate)
            let firstCycleFrame = TimelineSampleGrid.frames(at: firstCycleTimelineTime, sampleRate: sampleRate)
            nextOffset = max(0, firstCycleFrame - playheadFrame)
            loopTrackSchedule[clipID] = LoopTrackScheduleState(
                nextOffsetFrames: nextOffset,
                bodyFrameCount: bodyFrameCount,
                bodyStart: bounds.bodyStart,
                bodyEnd: bounds.bodyEnd
            )
        } else if var state = loopTrackSchedule[clipID] {
            nextOffset = state.nextOffsetFrames
        } else {
            nextOffset = max(0, firstCycleOffsetFrames)
            loopTrackSchedule[clipID] = LoopTrackScheduleState(
                nextOffsetFrames: nextOffset,
                bodyFrameCount: bodyFrameCount,
                bodyStart: bounds.bodyStart,
                bodyEnd: bounds.bodyEnd
            )
        }

        let usesPlayerRelativeSchedule = firstCycleTimelineTime != nil && playheadTime != nil
        let playAnchor: AVAudioTime?
        if usesPlayerRelativeSchedule {
            playAnchor = loopPlayAnchor ?? playerStartAnchor
        } else {
            guard let anchor = loopPlayAnchor ?? playerStartAnchor else { return false }
            playAnchor = anchor
        }

        var scheduledAny = false
        for cycle in 0..<cycles {
            let offsetFrames = nextOffset + (Int64(cycle) * bodyFrameCount)
            let scheduleAt: AVAudioTime?
            if let firstCycleTimelineTime, let playheadTime {
                let playheadFrame = TimelineSampleGrid.frames(at: playheadTime, sampleRate: sampleRate)
                let firstCycleFrame = TimelineSampleGrid.frames(at: firstCycleTimelineTime, sampleRate: sampleRate)
                let framesFromNow = (firstCycleFrame - playheadFrame) + (Int64(cycle) * bodyFrameCount)
                guard let playerRelativeTime = platformPlayback.playerScheduleTime(
                    player: scheduled.player,
                    framesFromNow: framesFromNow,
                    sampleRate: sampleRate,
                    playheadTime: playheadTime,
                    in: self
                ) else { continue }
                scheduleAt = playerRelativeTime
            } else {
                guard let playAnchor else { continue }
                scheduleAt = platformPlayback.segmentScheduleTime(
                    offsetSamplesFromPlayhead: offsetFrames,
                    sampleRate: sampleRate,
                    playerStartAnchor: playAnchor,
                    in: self
                )
            }

            if scheduleTimelineSegment(
                scheduled,
                timelineStartFrame: bounds.bodyStart,
                timelineEndFrame: bounds.bodyEnd,
                at: scheduleAt,
                label: "\(labelPrefix)-cycle-\(cycle + 1)@\(offsetFrames)"
            ) {
                scheduledAny = true
            }
        }

        if scheduledAny {
            nextOffset += Int64(cycles) * bodyFrameCount
            if var state = loopTrackSchedule[clipID] {
                state.nextOffsetFrames = nextOffset
                loopTrackSchedule[clipID] = state
            }
        }

        return scheduledAny
    }

    @discardableResult
    private func scheduleLinearJumpAtBoundary(
        _ scheduled: ScheduledClip,
        boundaryTime: TimeInterval,
        jumpToTime: TimeInterval,
        playheadTime: TimeInterval,
        scheduleUntil: TimeInterval? = nil,
        label: String
    ) -> Bool {
        let sampleRate = scheduled.file.processingFormat.sampleRate
        guard sampleRate > 0 else { return false }

        let clipStartFrame = TimelineSampleGrid.frames(at: scheduled.clip.startTime, sampleRate: sampleRate)
        let clipEndFrame = TimelineSampleGrid.frames(at: scheduled.clip.endTime, sampleRate: sampleRate)
        let playheadFrame = TimelineSampleGrid.frames(at: playheadTime, sampleRate: sampleRate)
        let boundaryFrame = TimelineSampleGrid.frames(at: boundaryTime, sampleRate: sampleRate)
        let jumpFrame = TimelineSampleGrid.frames(at: jumpToTime, sampleRate: sampleRate)

        let framesFromNow = boundaryFrame - playheadFrame
        guard framesFromNow > 0 else { return false }

        let segmentStart = max(jumpFrame, clipStartFrame)
        // Cap at scheduleUntil (destination section end) when provided so the queued
        // destination segment ends at its section boundary. This is required for the
        // NEXT arm to schedule cleanly without conflicting with an unbounded segment.
        let cappedClipEnd = scheduleUntil.map { TimelineSampleGrid.frames(at: $0, sampleRate: sampleRate) } ?? clipEndFrame
        let segmentEnd = min(clipEndFrame, cappedClipEnd)
        guard segmentEnd > segmentStart else { return false }

        return scheduleTimelineSegment(
            scheduled,
            timelineStartFrame: segmentStart,
            timelineEndFrame: segmentEnd,
            at: nil,
            label: label
        )
    }

    @discardableResult
    private func scheduleLinearContinuationAtBoundary(
        _ scheduled: ScheduledClip,
        boundaryTime: TimeInterval,
        playheadTime: TimeInterval,
        label: String
    ) -> Bool {
        let sampleRate = scheduled.file.processingFormat.sampleRate
        guard sampleRate > 0 else { return false }

        let clipStartFrame = TimelineSampleGrid.frames(at: scheduled.clip.startTime, sampleRate: sampleRate)
        let clipEndFrame = TimelineSampleGrid.frames(at: scheduled.clip.endTime, sampleRate: sampleRate)
        let playheadFrame = TimelineSampleGrid.frames(at: playheadTime, sampleRate: sampleRate)
        let boundaryFrame = TimelineSampleGrid.frames(at: boundaryTime, sampleRate: sampleRate)

        guard playheadFrame < boundaryFrame else { return false }

        let segmentStart = max(boundaryFrame, clipStartFrame)
        let segmentEnd = clipEndFrame
        guard segmentEnd > segmentStart else { return false }

        return scheduleTimelineRangeInSlices(
            scheduled,
            timelineStartFrame: segmentStart,
            timelineEndFrame: segmentEnd,
            at: nil,
            label: label,
            maxSlices: Self.maxImmediateContinuationSlices
        )
    }

    /// At most `maxSlices` windows of `continuationCacheSeconds`. Dumping the
    /// rest of the song at the section cut overloads HAL (silence on the join).
    @discardableResult
    private func scheduleTimelineRangeInSlices(
        _ scheduled: ScheduledClip,
        timelineStartFrame: Int64,
        timelineEndFrame: Int64,
        at: AVAudioTime?,
        label: String,
        maxSlices: Int = .max
    ) -> Bool {
        let sampleRate = scheduled.file.processingFormat.sampleRate
        let maxSliceFrames = TimelineSampleGrid.frames(
            at: SectionAudioCache.continuationCacheSeconds,
            sampleRate: sampleRate
        )
        guard maxSliceFrames > 0, timelineEndFrame > timelineStartFrame, maxSlices > 0 else { return false }

        var start = timelineStartFrame
        var sliceIndex = 0
        var scheduledAny = false
        while start < timelineEndFrame, sliceIndex < maxSlices {
            let end = min(timelineEndFrame, start + maxSliceFrames)
            let sliceLabel = sliceIndex == 0 ? label : "\(label)-\(sliceIndex + 1)"
            let sliceAt: AVAudioTime? = sliceIndex == 0 ? at : nil
            if scheduleTimelineSegment(
                scheduled,
                timelineStartFrame: start,
                timelineEndFrame: end,
                at: sliceAt,
                label: sliceLabel,
                log: sliceIndex == 0
            ) {
                scheduledAny = true
            }
            start = end
            sliceIndex += 1
        }
        return scheduledAny
    }

    @discardableResult
    private func scheduleTimelineSegment(
        _ scheduled: ScheduledClip,
        timelineStartFrame: Int64,
        timelineEndFrame: Int64,
        at: AVAudioTime?,
        label: String,
        log: Bool = true
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
            completionHandler: nil,
            in: self
        )

        let startSample: AVAudioFramePosition
        if let at, at.isSampleTimeValid {
            startSample = at.sampleTime
        } else {
            startSample = playerQueueEndFrames[clip.id] ?? 0
        }
        noteQueuedPlayerFrames(clipID: clip.id, startSample: startSample, frameCount: frameCount)

        if log {
            SectionLoopDiagnostics.logScheduledSegment(
                clipName: clip.name,
                timelineStart: TimelineSampleGrid.timeFromFrame(timelineStartFrame, sampleRate: sampleRate),
                timelineEnd: TimelineSampleGrid.timeFromFrame(timelineEndFrame, sampleRate: sampleRate),
                sourceStartFrame: sourceStartFrame,
                frameCount: frameCount,
                sampleRate: sampleRate,
                label: label
            )
        }
        return true
    }

    private func capturePlayerSessionHostOrigin() {
        playerSessionHostOrigin = playbackReferenceHostTime
    }

    private func noteQueuedPlayerFrames(
        clipID: UUID,
        startSample: AVAudioFramePosition,
        frameCount: AVAudioFrameCount
    ) {
        playerQueueEndFrames[clipID] = startSample + AVAudioFramePosition(frameCount)
    }

    private func resetIdleStandbyPlayers() {
        for scheduled in scheduledClips.values {
            let live = sectionStandby.liveNode(for: scheduled.clip.id) ?? scheduled.player
            let standby = sectionStandby.standbyNode(for: scheduled.clip.id) ?? scheduled.standby
            guard standby !== live, isNodeConnected(standby) else { continue }
            // stop() resets the node sample time to 1. The next play() is
            // HAL `got N want: 1` and skips a cycle of the live players.
            if standby.isPlaying {
                continue
            }
        }
        sectionStandby.clearCues()
    }

    private func cutPrerollSilenceBuffer(format: AVAudioFormat, seconds: TimeInterval) -> AVAudioPCMBuffer? {
        let frames = AVAudioFrameCount((seconds * format.sampleRate).rounded())
        guard frames > 0 else { return nil }
        let key = "\(format.sampleRate)-\(format.channelCount)-\(frames)"
        if let existing = cutPrerollSilenceBuffers[key] {
            return existing
        }
        guard let buffer = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: frames) else {
            return nil
        }
        buffer.frameLength = frames
        cutPrerollSilenceBuffers[key] = buffer
        return buffer
    }

    private func snapshotStandbyCue(
        boundary: TimeInterval,
        playhead: TimeInterval
    ) -> (boundary: TimeInterval, remaining: TimeInterval, preroll: TimeInterval, when: AVAudioTime?) {
        let remaining = SectionCueClock.remaining(to: boundary, playhead: playhead)
        let preroll = SectionCueClock.preroll(forRemaining: remaining)
        let when = platformPlayback.boundaryCueTime(
            remaining: SectionCueClock.cueRemaining(toBoundary: remaining),
            in: self
        )
        return (boundary, remaining, preroll, when)
    }

    private func logStandbyCue(
        _ cue: (boundary: TimeInterval, remaining: TimeInterval, preroll: TimeInterval, when: AVAudioTime?),
        clipCount: Int,
        cachedCount: Int
    ) {
        guard clipCount > 0 else { return }
        SectionLoopDiagnostics.log(String(
            format: "cued %d standbys at %.6fs (remaining %.6fs, preroll %.3fs, cached %d/%d)",
            clipCount,
            cue.boundary,
            cue.remaining,
            cue.preroll,
            cachedCount,
            clipCount
        ))
    }

    @discardableResult
    private func primeStandbyWithLoopBody(
        loop: SectionLoopContext,
        playheadTime: TimeInterval?
    ) -> Bool {
        sectionStandby.clearPrimes()
        sectionStandby.setIntent(.loopBody)
        let playhead = playheadTime ?? currentTimelineTime() ?? playbackStartTime
        let cue = snapshotStandbyCue(boundary: loop.endTime, playhead: playhead)
        var armed = false
        var cuedCount = 0
        var cachedCount = 0
        for scheduled in scheduledClips.values {
            guard let bounds = loopBodyBounds(for: scheduled, loop: loop) else { continue }
            let result = primeStandby(
                scheduled,
                timelineStartFrame: bounds.bodyStart,
                timelineEndFrame: bounds.bodyEnd,
                remaining: cue.remaining,
                cueWhen: nil,
                preroll: 0,
                cacheSectionID: loop.sectionID,
                loopCachedBody: true
            )
            if result.primed {
                armed = true
                cuedCount += 1
                if result.cached { cachedCount += 1 }
            }
        }
        if armed {
            logStandbyCue(cue, clipCount: cuedCount, cachedCount: cachedCount)
        }
        return armed
    }

    @discardableResult
    private func primeStandbyWithTimelineRange(
        _ scheduled: ScheduledClip,
        timelineStart: TimeInterval,
        timelineEnd: TimeInterval,
        cue: (boundary: TimeInterval, remaining: TimeInterval, preroll: TimeInterval, when: AVAudioTime?),
        cacheSectionID: UUID? = nil
    ) -> (primed: Bool, cached: Bool) {
        let sampleRate = scheduled.file.processingFormat.sampleRate
        guard sampleRate > 0 else { return (false, false) }
        let startFrame = TimelineSampleGrid.frames(at: timelineStart, sampleRate: sampleRate)
        let endFrame = TimelineSampleGrid.frames(at: timelineEnd, sampleRate: sampleRate)
        return primeStandby(
            scheduled,
            timelineStartFrame: startFrame,
            timelineEndFrame: endFrame,
            remaining: cue.remaining,
            cueWhen: cue.when,
            preroll: cue.preroll,
            cacheSectionID: cacheSectionID
        )
    }

    @discardableResult
    private func primeStandby(
        _ scheduled: ScheduledClip,
        timelineStartFrame: Int64,
        timelineEndFrame: Int64,
        remaining: TimeInterval,
        cueWhen: AVAudioTime?,
        preroll: TimeInterval = 0,
        cacheSectionID: UUID? = nil,
        loopCachedBody: Bool = false
    ) -> (primed: Bool, cached: Bool) {
        _ = cueWhen
        _ = preroll
        let standby = sectionStandby.standbyNode(for: scheduled.clip.id) ?? scheduled.standby
        let clipID = scheduled.clip.id
        if sectionStandby.isCued(clipID: clipID), standby.isPlaying {
            return (false, false)
        }

        let clip = scheduled.clip
        let file = scheduled.file
        let sampleRate = file.processingFormat.sampleRate
        guard sampleRate > 0 else { return (false, false) }

        let clipStartFrame = TimelineSampleGrid.frames(at: clip.startTime, sampleRate: sampleRate)
        let sourceOffsetFrame = TimelineSampleGrid.frames(at: clip.sourceOffset, sampleRate: sampleRate)
        let sourceStartFrame = sourceOffsetFrame + (timelineStartFrame - clipStartFrame)
        let frameCount = AVAudioFrameCount(max(0, timelineEndFrame - timelineStartFrame))
        guard frameCount > 0,
              sourceStartFrame >= 0,
              sourceStartFrame < file.length else {
            return (false, false)
        }

        let generation = sectionStandby.beginPrime(clipID: clipID)
        let coordinator = sectionStandby
        let completion: @Sendable () -> Void = {
            coordinator.onScheduledBufferEnded(clipID: clipID, generation: generation)
        }

        // Join IO without a timestamp if this lane missed the transport start.
        // Never play(at:) — that stamps sample time 1 against a live IO cycle.
        if isNodeConnected(standby), !standby.isPlaying {
            _ = safelyPlayPlayer(standby, at: nil)
        }
        standby.volume = 1

        let framesFromNow = TimelineSampleGrid.frames(at: max(0, remaining), sampleRate: sampleRate)
        let scheduleAt = platformPlayback.playerScheduleTime(
            player: standby,
            framesFromNow: max(0, framesFromNow),
            sampleRate: sampleRate,
            playheadTime: remaining,
            in: self
        ) ?? (remaining > SectionCueClock.minFutureCueSeconds
              ? platformPlayback.boundaryCueTime(remaining: remaining, in: self)
              : nil)

        let sectionBuffer: AVAudioPCMBuffer?
        if loopCachedBody, let sectionID = cacheSectionID {
            sectionBuffer = sectionAudioCache.sectionBody(sectionID: sectionID, clipID: clipID)
        } else {
            sectionBuffer = nil
        }
        let overlapBuffer: AVAudioPCMBuffer?
        if sectionBuffer == nil, let sectionID = cacheSectionID {
            overlapBuffer = sectionAudioCache.cachedIfPresent(
                sectionID: sectionID,
                clipID: clipID,
                sourceStartFrame: sourceStartFrame,
                frameCount: frameCount
            )
        } else {
            overlapBuffer = nil
        }
        let usedCache = sectionBuffer ?? overlapBuffer
        if let buffer = usedCache {
            var options: AVAudioPlayerNodeBufferOptions = []
            if loopCachedBody, sectionBuffer != nil {
                options.insert(.loops)
            }
            if options.contains(.loops) {
                standby.scheduleBuffer(buffer, at: scheduleAt, options: options)
            } else {
                standby.scheduleBuffer(
                    buffer,
                    at: scheduleAt,
                    options: options,
                    completionCallbackType: .dataPlayedBack
                ) { _ in
                    completion()
                }
            }
        } else {
            platformPlayback.scheduleFileSegment(
                player: standby,
                file: file,
                startingFrame: sourceStartFrame,
                frameCount: frameCount,
                at: scheduleAt,
                completionHandler: loopCachedBody ? nil : completion,
                in: self
            )
        }

        sectionStandby.markPrimed(clipID: clipID)
        if standby.isPlaying {
            sectionStandby.markCued(clipID: clipID)
        }
        return (true, usedCache != nil)
    }

    private func appendFileAfterCachedHead(_ scheduled: ScheduledClip, fromTimeline: TimeInterval) {
        let standby = sectionStandby.standbyNode(for: scheduled.clip.id) ?? scheduled.standby
        let file = scheduled.file
        let sampleRate = file.processingFormat.sampleRate
        guard sampleRate > 0 else { return }
        let clip = scheduled.clip
        let clipStart = TimelineSampleGrid.frames(at: clip.startTime, sampleRate: sampleRate)
        let rangeStart = TimelineSampleGrid.frames(at: fromTimeline, sampleRate: sampleRate)
        let clipEnd = TimelineSampleGrid.frames(at: clip.endTime, sampleRate: sampleRate)
        let sourceOffset = TimelineSampleGrid.frames(at: clip.sourceOffset, sampleRate: sampleRate)
        let sourceStart = sourceOffset + (rangeStart - clipStart)
        let frameCount = AVAudioFrameCount(max(0, clipEnd - rangeStart))
        guard sourceStart >= 0, frameCount > 0, sourceStart < file.length else { return }
        platformPlayback.scheduleFileSegment(
            player: standby,
            file: file,
            startingFrame: sourceStart,
            frameCount: frameCount,
            at: nil,
            completionHandler: nil,
            in: self
        )
    }

    /// Issues `play(at:)` so HAL starts the silent preroll; the body follows in the FIFO.
    private func cueStandbyIfPossible(
        clipID: UUID,
        standby: AVAudioPlayerNode,
        when: AVAudioTime?
    ) {
        guard let when else { return }
        guard safelyPlayPlayer(standby, at: when) else { return }
        sectionStandby.markCued(clipID: clipID)
    }

    private func isPlayerAudiblyRendering(_ player: AVAudioPlayerNode) -> Bool {
        guard player.isPlaying,
              let nodeTime = player.lastRenderTime,
              nodeTime.isSampleTimeValid else { return false }
        return true
    }

    private func stopAndResetLane(_ scheduled: ScheduledClip) {
        safelyStopPlayer(scheduled.player)
        safelyStopPlayer(scheduled.standby)
        sectionStandby.register(
            clipID: scheduled.clip.id,
            live: scheduled.player,
            standby: scheduled.standby
        )
        if engine.isRunning { return }
        safelyResetPlayer(scheduled.player)
        safelyResetPlayer(scheduled.standby)
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
        renderedPlayerIDs.insert(ObjectIdentifier(player))
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

    private func makeSynchronizedPlaybackAnchor(
        leadInSeconds: TimeInterval = playbackLeadInSeconds
    ) -> AVAudioTime? {
        guard let nodeTime = engine.outputNode.lastRenderTime,
              nodeTime.isHostTimeValid else {
            return nil
        }

        let leadHost = nodeTime.hostTime &+ AVAudioTime.hostTime(forSeconds: leadInSeconds)
        let outputRate = engine.outputNode.outputFormat(forBus: 0).sampleRate
        let sampleRate = outputRate > 0
            ? outputRate
            : (nodeTime.sampleRate > 0 ? nodeTime.sampleRate : (primaryClipSampleRate ?? 48_000))

        if nodeTime.isSampleTimeValid, sampleRate > 0 {
            let leadSamples = AVAudioFramePosition(leadInSeconds * sampleRate)
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
        sectionStandby.unregisterAll()
        sectionAudioCache.evictAll()
        SectionCueQueueMonitor.shared.reset()
        renderedPlayerIDs.removeAll(keepingCapacity: false)
        cutPrerollSilenceBuffers.removeAll(keepingCapacity: false)
        for scheduled in scheduledClips.values {
            engine.detach(scheduled.player)
            engine.detach(scheduled.standby)
            engine.detach(scheduled.clipMixer)
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
    func playbackLastRenderTime() -> AVAudioTime? { engine.outputNode.lastRenderTime }

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
