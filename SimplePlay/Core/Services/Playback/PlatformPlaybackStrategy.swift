//
//  PlatformPlaybackStrategy.swift
//  SimplePlay
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
    func scheduleFileSegment(
        player: AVAudioPlayerNode,
        file: AVAudioFile,
        startingFrame: AVAudioFramePosition,
        frameCount: AVAudioFrameCount,
        at: AVAudioTime?,
        in engine: AudioEngineService
    )
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
