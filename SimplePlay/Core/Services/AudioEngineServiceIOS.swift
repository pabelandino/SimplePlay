//
//  AudioEngineServiceIOS.swift
//  SimplePlay
//

#if !os(macOS)

import AVFoundation
import Foundation

@MainActor
final class AudioEngineServiceIOS: AudioEnginePlatformServices {
    func configureSessionBeforeEngineGraph(settings: AudioSettings, host: AudioEngineServiceHost) throws {
        try configureAudioSession(settings: settings)
    }

    func apply(settings: AudioSettings, host: AudioEngineServiceHost) throws {
        try configureAudioSession(settings: settings)
    }

    func applyOutputRouting(settings: AudioSettings, host: AudioEngineServiceHost) throws {
        // iOS session + route are configured in configureSessionBeforeEngineGraph before the graph
        // is built. Re-running setCategory/setActive while AVAudioEngine is running breaks startup.
    }

    func reactivateSessionIfNeeded(host: AudioEngineServiceHost) throws {
        try AVAudioSession.sharedInstance().setActive(true)
    }

    private func configureAudioSession(settings: AudioSettings) throws {
        let session = AVAudioSession.sharedInstance()

        guard activatePlaybackCategory(on: session) else {
            throw AudioEngineError.engineStartFailed
        }

        // Preferences only; never fail engine startup if the device rejects them.
        try? session.setPreferredSampleRate(settings.sampleRate.rawValue)
        try? session.setPreferredIOBufferDuration(0.005)

        applyIOSOutputRoute(settings: settings, session: session)

        guard activateSession(session) else {
            throw AudioEngineError.engineStartFailed
        }
    }

    private func activatePlaybackCategory(on session: AVAudioSession) -> Bool {
        let optionSets: [AVAudioSession.CategoryOptions] = [
            [.allowBluetoothA2DP, .allowBluetoothHFP],
            [.allowBluetoothA2DP],
            []
        ]
        for options in optionSets {
            do {
                try session.setCategory(.playback, mode: .default, options: options)
                return true
            } catch {
                continue
            }
        }
        return false
    }

    private func activateSession(_ session: AVAudioSession) -> Bool {
        try? session.setActive(false, options: .notifyOthersOnDeactivation)
        do {
            try session.setActive(true)
            return true
        } catch {
            return (try? session.setActive(true)) != nil
        }
    }

    private func applyIOSOutputRoute(settings: AudioSettings, session: AVAudioSession) {
        if settings.outputDeviceID == AudioOutputDevice.builtInSpeaker.id
            || settings.outputPortUID == AudioDeviceService.builtInSpeakerPortUID {
            try? session.overrideOutputAudioPort(.speaker)
        } else {
            try? session.overrideOutputAudioPort(.none)
        }

        // Never call setPreferredInput on a .playback session — it triggers SessionCore paramErr (-50)
        // and breaks engine startup when a saved USB interface is disconnected.
    }
}

extension AudioEngineService {
    func playbackHeardAudioLatencySeconds() -> TimeInterval {
        let session = AVAudioSession.sharedInstance()
        return session.outputLatency + (session.ioBufferDuration * 0.5)
    }

    func playbackMakeIOSPlayAnchor() -> AVAudioTime? {
        guard playbackRenderClockIsLive(),
              let nodeTime = playbackEngine.outputNode.lastRenderTime,
              nodeTime.isHostTimeValid else {
            return nil
        }
        let leadHost = nodeTime.hostTime &+ AVAudioTime.hostTime(forSeconds: Self.playbackLeadInSeconds)
        return AVAudioTime(hostTime: leadHost)
    }

    func playbackReactivateAudioSession() throws {
        try platformServices.reactivateSessionIfNeeded(host: self)
    }
}

#endif
