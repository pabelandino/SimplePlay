//
//  PlatformPlaybackStrategy.swift
//  LvoqPlayback
//

import AVFoundation
import Foundation

/// Platform-specific playback transport (macOS vs iPad/iPhone).
@MainActor
protocol PlatformPlaybackStrategy {
    var meterTapBufferSize: AVAudioFrameCount { get }

    func finishEngineConfiguration(in engine: AudioEngineService) throws
    func warmUpEngineForPlayback(in engine: AudioEngineService) -> Bool
    func pause(in engine: AudioEngineService)
    func stop(in engine: AudioEngineService)

    func currentTimelineTime(in engine: AudioEngineService) -> TimeInterval?
    func resolvePlaybackStartAnchor(in engine: AudioEngineService) -> AVAudioTime
    /// Host/sample anchor used when `startScheduledPlayers` begins a linear pass (Logic-style queue origin).
    func capturePlaybackStartAnchor(in engine: AudioEngineService) -> AVAudioTime?
    func segmentScheduleTime(
        offsetSamplesFromPlayhead: AVAudioFramePosition,
        sampleRate: Double,
        playerStartAnchor: AVAudioTime,
        in engine: AudioEngineService
    ) -> AVAudioTime?
    func playerScheduleTime(
        player: AVAudioPlayerNode,
        framesFromNow: AVAudioFramePosition,
        sampleRate: Double,
        playheadTime: TimeInterval,
        in engine: AudioEngineService
    ) -> AVAudioTime?
    func startScheduledPlayers(
        _ players: [AVAudioPlayerNode],
        anchor: AVAudioTime,
        in engine: AudioEngineService
    )
    /// Host time when a cued standby must start so the cut has no extra lead-in.
    func boundaryCueTime(remaining: TimeInterval, in engine: AudioEngineService) -> AVAudioTime?
    func scheduleFileSegment(
        player: AVAudioPlayerNode,
        file: AVAudioFile,
        startingFrame: AVAudioFramePosition,
        frameCount: AVAudioFrameCount,
        at: AVAudioTime?,
        completionHandler: (@Sendable () -> Void)?,
        in engine: AudioEngineService
    )
}

extension PlatformPlaybackStrategy {
    func boundaryCueTime(remaining: TimeInterval, in engine: AudioEngineService) -> AVAudioTime? {
        guard let render = engine.playbackLastRenderTime() else { return nil }
        return SectionCueClock.makeCueTime(remaining: remaining, renderTime: render)
    }
}

enum PlatformPlaybackStrategyFactory {
    @MainActor
    static func make() -> PlatformPlaybackStrategy {
#if os(macOS)
        MacOSPlaybackStrategy()
#else
        IOSPlaybackStrategy()
#endif
    }
}
