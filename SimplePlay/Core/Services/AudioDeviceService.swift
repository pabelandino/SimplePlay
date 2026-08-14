//
//  AudioDeviceService.swift
//  SimplePlay
//

import AVFoundation
import Foundation

#if os(macOS)
import CoreAudio
#endif

enum AudioDeviceService {
#if !os(macOS)
    static let builtInSpeakerPortUID = "__simpleplay_builtin_speaker__"
#endif

    static func listOutputDevices() -> [AudioOutputDevice] {
#if os(macOS)
        listOutputDevicesMac()
#else
        listOutputDevicesIOS()
#endif
    }

    static func device(
        matching settings: AudioSettings,
        in devices: [AudioOutputDevice] = listOutputDevices()
    ) -> AudioOutputDevice? {
        if let deviceID = settings.outputDeviceID,
           let device = devices.first(where: { $0.id == deviceID }) {
            return device
        }
        if let portUID = settings.outputPortUID,
           let device = devices.first(where: { $0.portUID == portUID }) {
            return device
        }
        if settings.outputDeviceID == nil || settings.outputDeviceID == 0 {
            return .systemDefault
        }
        if let device = devices.first(where: { $0.name == settings.outputDeviceName }) {
            return device
        }
        return nil
    }

    static func channelPairOptions(for device: AudioOutputDevice) -> [Int] {
#if os(macOS)
        guard device.outputChannelCount > 2 else { return [0] }
        let pairCount = device.outputChannelCount / 2
        return Array(0..<pairCount)
#else
        _ = device
        return [0]
#endif
    }

    static func channelPairLabel(pairIndex: Int) -> String {
        let left = pairIndex * 2 + 1
        let right = left + 1
        return "Out \(left)-\(right)"
    }

    static func stableDeviceID(forPortUID portUID: String) -> UInt32 {
        var hash: UInt32 = 2_166_136_261
        for byte in portUID.utf8 {
            hash ^= UInt32(byte)
            hash = hash &* 1_677_761_9
        }
        return hash | 0x8000_0000
    }

#if os(macOS)
    private static func listOutputDevicesMac() -> [AudioOutputDevice] {
        var devices = [AudioOutputDevice.systemDefault]

        var propertyAddress = AudioObjectPropertyAddress(
            mSelector: kAudioHardwarePropertyDevices,
            mScope: kAudioObjectPropertyScopeGlobal,
            mElement: kAudioObjectPropertyElementMain
        )

        var dataSize: UInt32 = 0
        guard AudioObjectGetPropertyDataSize(
            AudioObjectID(kAudioObjectSystemObject),
            &propertyAddress,
            0,
            nil,
            &dataSize
        ) == noErr else {
            return devices
        }

        let deviceCount = Int(dataSize) / MemoryLayout<AudioDeviceID>.size
        var deviceIDs = [AudioDeviceID](repeating: 0, count: deviceCount)

        guard AudioObjectGetPropertyData(
            AudioObjectID(kAudioObjectSystemObject),
            &propertyAddress,
            0,
            nil,
            &dataSize,
            &deviceIDs
        ) == noErr else {
            return devices
        }

        for deviceID in deviceIDs where deviceHasOutput(deviceID) {
            let name = deviceName(deviceID) ?? "Unknown Device"
            let channels = outputChannelCount(deviceID)
            devices.append(
                AudioOutputDevice(
                    id: deviceID,
                    name: name,
                    outputChannelCount: max(2, channels)
                )
            )
        }

        return devices
    }

    private static func deviceHasOutput(_ deviceID: AudioDeviceID) -> Bool {
        outputChannelCount(deviceID) > 0
    }

    private static func outputChannelCount(_ deviceID: AudioDeviceID) -> Int {
        var propertyAddress = AudioObjectPropertyAddress(
            mSelector: kAudioDevicePropertyStreamConfiguration,
            mScope: kAudioDevicePropertyScopeOutput,
            mElement: kAudioObjectPropertyElementMain
        )

        var dataSize: UInt32 = 0
        guard AudioObjectGetPropertyDataSize(deviceID, &propertyAddress, 0, nil, &dataSize) == noErr else {
            return 0
        }

        let bufferListPointer = UnsafeMutablePointer<AudioBufferList>.allocate(capacity: 1)
        defer { bufferListPointer.deallocate() }

        guard AudioObjectGetPropertyData(deviceID, &propertyAddress, 0, nil, &dataSize, bufferListPointer) == noErr else {
            return 0
        }

        let buffers = UnsafeMutableAudioBufferListPointer(bufferListPointer)
        return buffers.reduce(0) { $0 + Int($1.mNumberChannels) }
    }

    private static func deviceName(_ deviceID: AudioDeviceID) -> String? {
        var propertyAddress = AudioObjectPropertyAddress(
            mSelector: kAudioDevicePropertyDeviceNameCFString,
            mScope: kAudioObjectPropertyScopeGlobal,
            mElement: kAudioObjectPropertyElementMain
        )

        var name: CFString = "" as CFString
        var dataSize = UInt32(MemoryLayout<CFString>.size)
        let status = AudioObjectGetPropertyData(deviceID, &propertyAddress, 0, nil, &dataSize, &name)
        guard status == noErr else { return nil }
        return name as String
    }
#else
    private static func listOutputDevicesIOS() -> [AudioOutputDevice] {
        let session = AVAudioSession.sharedInstance()
        var devices: [AudioOutputDevice] = [.systemDefault, .builtInSpeaker]
        var seenUIDs = Set<String>()

        func appendPort(_ port: AVAudioSessionPortDescription) {
            guard seenUIDs.insert(port.uid).inserted else { return }
            devices.append(
                AudioOutputDevice(
                    id: stableDeviceID(forPortUID: port.uid),
                    name: port.portName,
                    outputChannelCount: 2,
                    portUID: port.uid
                )
            )
        }

        for port in session.currentRoute.outputs {
            appendPort(port)
        }

        session.availableInputs?.forEach { appendPort($0) }

        return devices
    }
#endif
}
