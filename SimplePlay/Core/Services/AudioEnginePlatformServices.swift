//
//  AudioEnginePlatformServices.swift
//  SimplePlay
//

import AVFoundation
import Foundation

/// Host surface used by platform-specific audio engine helpers.
/// Keeps macOS/iOS code out of `AudioEngineService.swift`.
@MainActor
protocol AudioEngineServiceHost: AnyObject {
    var avEngine: AVAudioEngine { get }
    var engineIsRunning: Bool { get set }

    func hostStartEngine() throws
    func hostStopEngineIfRunning()
    func hostRenderClockIsLive() -> Bool
}

/// Device/session routing only. Playback timing lives in `Playback/*PlaybackStrategy.swift`.
@MainActor
protocol AudioEnginePlatformServices {
    func configureSessionBeforeEngineGraph(settings: AudioSettings, host: AudioEngineServiceHost) throws
    func apply(settings: AudioSettings, host: AudioEngineServiceHost) throws
    func applyOutputRouting(settings: AudioSettings, host: AudioEngineServiceHost) throws
    func reactivateSessionIfNeeded(host: AudioEngineServiceHost) throws
}

enum AudioEnginePlatformServicesFactory {
    @MainActor
    static func make() -> AudioEnginePlatformServices {
#if os(macOS)
        AudioEngineServiceMacOS()
#else
        AudioEngineServiceIOS()
#endif
    }
}
