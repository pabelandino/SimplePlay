//
//  AudioEngineServiceMacOS.swift
//  SimplePlay
//

#if os(macOS)

import AudioUnit
import AVFoundation
import CoreAudio
import Foundation

@MainActor
final class AudioEngineServiceMacOS: AudioEnginePlatformServices {
    func configureSessionBeforeEngineGraph(settings: AudioSettings, host: AudioEngineServiceHost) throws {
        // macOS uses the system default session; output device is selected on the output unit after start.
    }

    func apply(settings: AudioSettings, host: AudioEngineServiceHost) throws {
        guard host.avEngine.isRunning else { return }
        try applyOutputRouting(settings: settings, host: host)
    }

    func applyOutputRouting(settings: AudioSettings, host: AudioEngineServiceHost) throws {
        guard host.avEngine.isRunning else { return }
        try applyMacOutputDevice(settings: settings, host: host)
        host.avEngine.stop()
        try host.hostStartEngine()
        host.engineIsRunning = true
    }

    func reactivateSessionIfNeeded(host: AudioEngineServiceHost) throws {}

    private func applyMacOutputDevice(settings: AudioSettings, host: AudioEngineServiceHost) throws {
        guard let audioUnit = host.avEngine.outputNode.audioUnit else {
            throw AudioEngineError.deviceSelectionFailed
        }

        let deviceID: AudioDeviceID
        if let selected = settings.outputDeviceID, selected != 0,
           AudioDeviceService.listOutputDevices().contains(where: { $0.id == selected }) {
            deviceID = selected
        } else {
            deviceID = try macOSDefaultOutputDeviceID()
        }

        var device = deviceID
        let status = AudioUnitSetProperty(
            audioUnit,
            kAudioOutputUnitProperty_CurrentDevice,
            kAudioUnitScope_Global,
            0,
            &device,
            UInt32(MemoryLayout<AudioDeviceID>.size)
        )

        guard status == noErr else {
            throw AudioEngineError.deviceSelectionFailed
        }
    }

    private func macOSDefaultOutputDeviceID() throws -> AudioDeviceID {
        var deviceID = AudioDeviceID(0)
        var propertyAddress = AudioObjectPropertyAddress(
            mSelector: kAudioHardwarePropertyDefaultOutputDevice,
            mScope: kAudioObjectPropertyScopeGlobal,
            mElement: kAudioObjectPropertyElementMain
        )
        var dataSize = UInt32(MemoryLayout<AudioDeviceID>.size)
        let status = AudioObjectGetPropertyData(
            AudioObjectID(kAudioObjectSystemObject),
            &propertyAddress,
            0,
            nil,
            &dataSize,
            &deviceID
        )
        guard status == noErr, deviceID != 0 else {
            throw AudioEngineError.deviceSelectionFailed
        }
        return deviceID
    }
}

#endif
