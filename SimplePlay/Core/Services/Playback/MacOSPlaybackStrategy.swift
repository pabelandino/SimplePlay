//
//  MacOSPlaybackStrategy.swift
//  SimplePlay
//

#if os(macOS)

import AVFoundation
import Foundation

@MainActor
final class MacOSPlaybackStrategy: PlatformPlaybackStrategy {
    var meterTapBufferSize: AVAudioFrameCount { 4096 }

    func finishEngineConfiguration(in engine: AudioEngineService) throws {
        try engine.playbackStartEngine()
    }

    func warmUpEngineForPlayback(in engine: AudioEngineService) -> Bool {
        if engine.playbackEngine.isRunning, engine.playbackGraphIsHealthy {
            engine.playbackPrepareEngine()
            engine.playbackIsEngineRunning = true
            engine.playbackRefreshMeterMonitoring()
            return true
        }

        engine.playbackStopEngineIfRunning()
        engine.playbackPrepareEngine()

        do {
            try engine.playbackStartEngine()
            engine.playbackRefreshMeterMonitoring()
            return engine.playbackGraphIsHealthy
        } catch {
            engine.playbackIsEngineRunning = false
            return false
        }
    }

    func pause(in engine: AudioEngineService) {
        // macOS keeps AVAudioEngine running between pause and resume.
    }

    func stop(in engine: AudioEngineService) {
        // macOS keeps the engine running after stop(); configure() handles teardown.
    }

    func currentTimelineTime(in engine: AudioEngineService) -> TimeInterval? {
        guard engine.playbackReferenceHostTimeValue != nil else { return nil }

        if let sampleTimeline = engine.playbackTimelineFromSampleClocks(preferMinimumElapsed: false) {
            return sampleTimeline
        }

        guard let reference = engine.playbackReferenceHostTimeValue else { return nil }
        let now = engine.playbackEngine.outputNode.lastRenderTime?.hostTime ?? mach_absolute_time()
        guard now >= reference else { return engine.playbackStartTimeValue }
        return engine.playbackStartTimeValue
            + engine.playbackSecondsBetweenHostTimes(from: reference, to: now)
    }

    func resolvePlaybackStartAnchor(in engine: AudioEngineService) -> AVAudioTime {
        if engine.playbackRenderClockIsLive(),
           let anchor = engine.playbackMakeSynchronizedAnchor() {
            return anchor
        }

        let sampleRate = engine.playbackEngine.outputNode.outputFormat(forBus: 0).sampleRate
        let resolvedRate = sampleRate > 0 ? sampleRate : (engine.playbackPrimaryClipSampleRate ?? 48_000)
        let leadHost = mach_absolute_time() &+ AVAudioTime.hostTime(forSeconds: AudioEngineService.playbackLeadInSeconds)
        return AVAudioTime(hostTime: leadHost, sampleTime: 0, atRate: resolvedRate)
    }

    func segmentScheduleTime(
        offsetSamplesFromPlayhead: AVAudioFramePosition,
        sampleRate: Double,
        playerStartAnchor: AVAudioTime,
        in engine: AudioEngineService
    ) -> AVAudioTime? {
        guard offsetSamplesFromPlayhead > 0 else { return nil }

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
    }

    func playerScheduleTime(
        player: AVAudioPlayerNode,
        framesFromNow: AVAudioFramePosition,
        sampleRate: Double,
        playheadTime: TimeInterval,
        in engine: AudioEngineService
    ) -> AVAudioTime? {
        guard framesFromNow >= 0 else { return nil }

        if Double(framesFromNow) / sampleRate <= 0.1 {
            return nil
        }

        guard engine.playbackRenderClockIsLive(),
              let nodeTime = engine.playbackEngine.outputNode.lastRenderTime,
              nodeTime.isHostTimeValid else {
            let leadHost = mach_absolute_time() &+ AVAudioTime.hostTime(forSeconds: AudioEngineService.playbackLeadInSeconds)
            let offsetHost = AVAudioTime.hostTime(forSeconds: Double(framesFromNow) / sampleRate)
            return AVAudioTime(hostTime: leadHost &+ offsetHost, sampleTime: 0, atRate: sampleRate)
        }

        let offsetHost = AVAudioTime.hostTime(forSeconds: Double(framesFromNow) / sampleRate)
        if nodeTime.isSampleTimeValid, nodeTime.sampleRate > 0 {
            return AVAudioTime(
                hostTime: nodeTime.hostTime &+ offsetHost,
                sampleTime: nodeTime.sampleTime + framesFromNow,
                atRate: nodeTime.sampleRate
            )
        }

        return AVAudioTime(hostTime: nodeTime.hostTime &+ offsetHost, sampleTime: framesFromNow, atRate: sampleRate)
    }

    func startScheduledPlayers(
        _ players: [AVAudioPlayerNode],
        anchor: AVAudioTime,
        in engine: AudioEngineService
    ) {
        engine.playbackClearSampleReference()

        var startedAny = false
        for player in players {
            if engine.playbackSafelyPlayPlayer(player, at: anchor) {
                startedAny = true
            }
        }

        if startedAny, anchor.isHostTimeValid {
            engine.playbackReferenceHostTimeValue = anchor.hostTime
        } else {
            for player in players where !player.isPlaying {
                _ = engine.playbackSafelyPlayPlayer(player, at: nil)
            }
            engine.playbackMarkReferenceTime()
        }
    }

    func scheduleFileSegment(
        player: AVAudioPlayerNode,
        file: AVAudioFile,
        startingFrame: AVAudioFramePosition,
        frameCount: AVAudioFrameCount,
        at: AVAudioTime?,
        in engine: AudioEngineService
    ) {
        player.scheduleSegment(
            file,
            startingFrame: startingFrame,
            frameCount: frameCount,
            at: at
        )
    }
}

#endif
