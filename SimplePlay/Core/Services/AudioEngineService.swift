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

    /// Timeline position derived from the audio engine render clock (stays in sync under CPU load).
    func currentTimelineTime() -> TimeInterval? {
        guard playbackReferenceHostTime != nil else { return nil }

        if let sampleTimeline = timelineTimeFromPlayingPlayers() {
            return sampleTimeline
        }

        guard let reference = playbackReferenceHostTime else { return nil }
        let now = engine.outputNode.lastRenderTime?.hostTime ?? mach_absolute_time()
        guard now >= reference else { return playbackStartTime }
        return playbackStartTime + Self.secondsBetweenHostTimes(from: reference, to: now)
    }

    /// Sample-accurate timeline from player render clocks (matches audible playback on iOS).
    private func timelineTimeFromPlayingPlayers() -> TimeInterval? {
        capturePlaybackSampleReferenceIfNeeded()
        guard let referenceSample = playbackReferencePlayerSample else { return nil }

        var maxElapsed: TimeInterval?
        for scheduled in scheduledClips.values {
            guard scheduled.player.isPlaying,
                  let nodeTime = scheduled.player.lastRenderTime,
                  nodeTime.isSampleTimeValid,
                  nodeTime.sampleRate > 0 else { continue }

            let sampleDelta = nodeTime.sampleTime - referenceSample
            guard sampleDelta >= 0 else { continue }
            let elapsed = Double(sampleDelta) / nodeTime.sampleRate
            maxElapsed = max(maxElapsed ?? elapsed, elapsed)
        }

        guard let maxElapsed else { return nil }
        return playbackStartTime + maxElapsed
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
    private var meterFlushScheduled = false
    private var pendingTrackPeaks: [UUID: Float] = [:]
    private var pendingGroupPeaks: [UUID: Float] = [:]
    private var pendingMasterPeak: Float = 0

    private static let playbackLeadInSeconds: TimeInterval = 0.02
    private static let initialLoopCycles = 2
    private static let appendedLoopCycles = 2
    private static let meterTapBufferSize: AVAudioFrameCount = 4096

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
    func play(
        from time: TimeInterval,
        project: DAWProject,
        sectionLoop: SectionLoopContext? = nil
    ) -> Bool {
        lastPlaybackError = nil
        activeSectionLoop = sectionLoop
        scheduledLoopCycleCount = 0

        guard !scheduledClips.isEmpty else {
            lastPlaybackError = AudioEngineError.playbackUnavailable.errorDescription
            return false
        }

        guard warmUpEngineForPlayback() else {
            lastPlaybackError = AudioEngineError.playbackUnavailable.errorDescription
            return false
        }

        playbackStartTime = max(0, time)
        playbackReferenceHostTime = nil
        clearPlaybackSampleReference()
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

        for scheduled in scheduledClips.values {
            safelyStopPlayer(scheduled.player)
        }

        let playerStartAnchor = resolvePlaybackStartAnchor()

        var playersToStart: [AVAudioPlayerNode] = []

        for scheduled in scheduledClips.values {
            safelyResetPlayer(scheduled.player)

            if let sectionLoop {
                let queued = scheduleClipWithSectionLoop(
                    scheduled,
                    from: playbackStartTime,
                    loop: sectionLoop,
                    initialCycles: Self.initialLoopCycles,
                    labelPrefix: "initial",
                    playerStartAnchor: playerStartAnchor
                )
                if queued {
                    playersToStart.append(scheduled.player)
                }
            } else {
                guard shouldPlayClip(scheduled.clip, at: playbackStartTime) else { continue }
                guard scheduleClip(
                    scheduled,
                    from: playbackStartTime,
                    playerStartAnchor: playerStartAnchor
                ) else { continue }
                playersToStart.append(scheduled.player)
            }
        }

        if playersToStart.isEmpty, sectionLoop != nil {
            for scheduled in scheduledClips.values {
                safelyResetPlayer(scheduled.player)
                guard shouldPlayClip(scheduled.clip, at: playbackStartTime) else { continue }
                guard scheduleClip(
                    scheduled,
                    from: playbackStartTime,
                    playerStartAnchor: playerStartAnchor
                ) else { continue }
                playersToStart.append(scheduled.player)
            }
            activeSectionLoop = nil
            scheduledLoopCycleCount = 0
        }

        guard !playersToStart.isEmpty else {
            lastPlaybackError = AudioEngineError.playbackUnavailable.errorDescription
            return false
        }

        startScheduledPlayers(playersToStart, anchor: playerStartAnchor)

        if playbackStartTime < project.duration {
            return true
        }

        return true
    }

    private func startScheduledPlayers(_ players: [AVAudioPlayerNode], anchor: AVAudioTime) {
#if os(iOS)
        // iPad/iPhone: play(at: nil) is required when segments start mid-file (seek / sections).
        for player in players {
            _ = safelyPlayPlayer(player, at: nil)
        }
        markPlaybackReferenceTime()
#else
        for player in players {
            _ = safelyPlayPlayer(player, at: anchor)
        }
        playbackReferenceHostTime = anchor.hostTime
#endif
    }

    /// Host-time anchor for sample-accurate player start and segment scheduling (macOS).
    private func resolvePlaybackStartAnchor() -> AVAudioTime {
        if renderClockIsLive(),
           let anchor = makeSynchronizedPlaybackAnchor() {
            return anchor
        }

        let sampleRate = primaryClipSampleRate ?? 48_000
        let leadHost = mach_absolute_time() &+ AVAudioTime.hostTime(forSeconds: Self.playbackLeadInSeconds)
        return AVAudioTime(hostTime: leadHost, sampleTime: 0, atRate: sampleRate)
    }

    private func segmentScheduleTime(
        offsetSamplesFromPlayhead: AVAudioFramePosition,
        sampleRate: Double,
        playerStartAnchor: AVAudioTime
    ) -> AVAudioTime? {
        guard offsetSamplesFromPlayhead > 0 else { return nil }

#if os(iOS)
        // Relative to the player timeline when using play(at: nil) on iOS.
        return AVAudioTime(
            sampleTime: offsetSamplesFromPlayhead,
            atRate: sampleRate
        )
#else
        let offsetSeconds = Double(offsetSamplesFromPlayhead) / sampleRate
        let hostTime = playerStartAnchor.hostTime &+ AVAudioTime.hostTime(forSeconds: offsetSeconds)

        if playerStartAnchor.isSampleTimeValid, playerStartAnchor.sampleRate > 0 {
            return AVAudioTime(
                hostTime: hostTime,
                sampleTime: playerStartAnchor.sampleTime + offsetSamplesFromPlayhead,
                atRate: playerStartAnchor.sampleRate
            )
        }

        return AVAudioTime(hostTime: hostTime, sampleTime: offsetSamplesFromPlayhead, atRate: sampleRate)
#endif
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

    /// Queues additional loop cycles without stopping active players (seamless section repeat).
    @discardableResult
    func appendSectionLoopCycles(project: DAWProject, loop: SectionLoopContext, cycles: Int? = nil) -> Bool {
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
        playbackReferenceHostTime = nil
        clearPlaybackSampleReference()
        clearSectionLoopState()
        resetMeters()
    }

    func stop() {
        playbackStartTime = 0
        playbackReferenceHostTime = nil
        clearPlaybackSampleReference()
        clearSectionLoopState()
        for scheduled in scheduledClips.values {
            safelyStopPlayer(scheduled.player)
            scheduled.player.reset()
        }
        resetMeters()
#if !os(macOS)
        stopEngineIfRunning()
#endif
    }

    private func shouldPlayClip(_ clip: AudioClip, at playheadTime: TimeInterval) -> Bool {
        playheadTime < clip.endTime
    }

    @discardableResult
    private func scheduleClip(
        _ scheduled: ScheduledClip,
        from playheadTime: TimeInterval,
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

        guard playheadFrame < clipEndFrame, clipEndFrame > clipStartFrame else { return false }

        let playbackStartFrame = max(clipStartFrame, playheadFrame)
        let sourceStartFrame = sourceOffsetFrame + (playbackStartFrame - clipStartFrame)
        let frameCount = AVAudioFrameCount(clipEndFrame - playbackStartFrame)
        guard frameCount > 0, sourceStartFrame >= 0, sourceStartFrame < file.length else { return false }

        let scheduleAt = segmentScheduleTime(
            offsetSamplesFromPlayhead: playbackStartFrame - playheadFrame,
            sampleRate: sampleRate,
            playerStartAnchor: playerStartAnchor
        )

        scheduleFileSegment(
            player: player,
            file: file,
            startingFrame: sourceStartFrame,
            frameCount: frameCount,
            at: scheduleAt
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
        labelPrefix: String
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
            if scheduleTimelineSegment(
                scheduled,
                timelineStartFrame: bodyStart,
                timelineEndFrame: bodyEnd,
                at: nil,
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

        scheduleFileSegment(
            player: player,
            file: file,
            startingFrame: sourceStartFrame,
            frameCount: frameCount,
            at: at
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

    private func scheduleFileSegment(
        player: AVAudioPlayerNode,
        file: AVAudioFile,
        startingFrame: AVAudioFramePosition,
        frameCount: AVAudioFrameCount,
        at: AVAudioTime?
    ) {
#if os(iOS)
        if startingFrame > 0 {
            player.prepare(withFrameCount: frameCount)
        }
#endif
        player.scheduleSegment(
            file,
            startingFrame: startingFrame,
            frameCount: frameCount,
            at: at
        )
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
        let sampleRate = nodeTime.sampleRate > 0
            ? nodeTime.sampleRate
            : (primaryClipSampleRate ?? 48_000)

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
            engine.prepare()
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
        scheduledClips.values.contains { scheduled in
            isNodeConnected(scheduled.player) && isNodeConnected(scheduled.timePitch)
        }
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
        try session.setActive(true)
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
                self?.enqueueTrackMeterPeak(trackID: trackID, peak: peak)
            }
        }

        for (groupID, mixer) in groupMixers {
            installMeterTap(on: mixer) { [weak self] peak in
                self?.enqueueGroupMeterPeak(groupID: groupID, peak: peak)
            }
        }

        installMeterTap(on: mainMixer) { [weak self] peak in
            self?.enqueueMasterMeterPeak(peak)
        }

        metersInstalled = true
    }

    private func installMeterTap(on mixer: AVAudioMixerNode, handler: @escaping (Float) -> Void) {
        let format = mixer.outputFormat(forBus: 0)
        guard format.sampleRate > 0 else { return }

        mixer.installTap(onBus: 0, bufferSize: Self.meterTapBufferSize, format: format) { buffer, _ in
            let peak = Self.peakLevel(from: buffer)
            Task { @MainActor [weak self] in
                guard self != nil else { return }
                handler(peak)
            }
        }
    }

    private func enqueueTrackMeterPeak(trackID: UUID, peak: Float) {
        pendingTrackPeaks[trackID] = max(pendingTrackPeaks[trackID] ?? 0, peak)
        scheduleMeterFlush()
    }

    private func enqueueGroupMeterPeak(groupID: UUID, peak: Float) {
        pendingGroupPeaks[groupID] = max(pendingGroupPeaks[groupID] ?? 0, peak)
        scheduleMeterFlush()
    }

    private func enqueueMasterMeterPeak(_ peak: Float) {
        pendingMasterPeak = max(pendingMasterPeak, peak)
        scheduleMeterFlush()
    }

    private func scheduleMeterFlush() {
        guard !meterFlushScheduled else { return }
        meterFlushScheduled = true
        Task { @MainActor in
            self.flushPendingMeterPeaks()
        }
    }

    private func flushPendingMeterPeaks() {
        meterFlushScheduled = false

        for (trackID, peak) in pendingTrackPeaks {
            updateTrackMeterLevel(trackID: trackID, peak: peak)
        }
        pendingTrackPeaks.removeAll()

        for (groupID, peak) in pendingGroupPeaks {
            updateGroupMeterLevel(groupID: groupID, peak: peak)
        }
        pendingGroupPeaks.removeAll()

        if pendingMasterPeak > 0 {
            updateMasterMeterLevel(peak: pendingMasterPeak)
            pendingMasterPeak = 0
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
