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
        guard let sampleTimeline = engine.playbackTimelineFromSampleClocks(preferMinimumElapsed: true) else {
            return nil
        }
        let compensated = sampleTimeline - engine.playbackHeardAudioLatencySeconds()
        return max(engine.playbackStartTimeValue, compensated)
    }

    func resolvePlaybackStartAnchor(in engine: AudioEngineService) -> AVAudioTime {
        // Segment scheduling is sample-relative; play anchor is resolved in startScheduledPlayers.
        AVAudioTime(sampleTime: 0, atRate: engine.playbackPrimaryClipSampleRate ?? 48_000)
    }

    func segmentScheduleTime(
        offsetSamplesFromPlayhead: AVAudioFramePosition,
        sampleRate: Double,
        playerStartAnchor: AVAudioTime,
        in engine: AudioEngineService
    ) -> AVAudioTime? {
        _ = playerStartAnchor
        _ = engine
        guard offsetSamplesFromPlayhead > 0, sampleRate > 0 else { return nil }
        return AVAudioTime(sampleTime: offsetSamplesFromPlayhead, atRate: sampleRate)
    }

    func playerScheduleTime(
        player: AVAudioPlayerNode,
        framesFromNow: AVAudioFramePosition,
        sampleRate: Double,
        playheadTime: TimeInterval,
        in engine: AudioEngineService
    ) -> AVAudioTime? {
        _ = playheadTime
        _ = engine
        guard framesFromNow >= 0, sampleRate > 0 else { return nil }

        if Double(framesFromNow) / sampleRate <= 0.1 {
            return nil
        }

        if player.isPlaying,
           let nodeTime = player.lastRenderTime,
           nodeTime.isSampleTimeValid,
           nodeTime.sampleRate > 0 {
            return AVAudioTime(
                sampleTime: nodeTime.sampleTime + framesFromNow,
                atRate: nodeTime.sampleRate
            )
        }

        return nil
    }

    func startScheduledPlayers(
        _ players: [AVAudioPlayerNode],
        anchor: AVAudioTime,
        in engine: AudioEngineService
    ) {
        _ = anchor
        engine.playbackClearSampleReference()

        if let playAnchor = engine.playbackMakeMacPlayAnchor() {
            for player in players {
                _ = engine.playbackSafelyPlayPlayer(player, at: playAnchor)
            }
            if playAnchor.isHostTimeValid {
                engine.playbackReferenceHostTimeValue = playAnchor.hostTime
            } else {
                engine.playbackMarkReferenceTime()
            }
            return
        }

        for player in players {
            _ = engine.playbackSafelyPlayPlayer(player, at: nil)
        }
        engine.playbackMarkReferenceTime()
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
