//
//  AudioSettings.swift
//  SimplePlay
//

import AVFoundation
import Foundation

enum AudioSampleRate: Double, CaseIterable, Identifiable, Codable, Sendable {
    case rate44100 = 44100
    case rate48000 = 48000

    var id: Double { rawValue }

    var displayName: String {
        switch self {
        case .rate44100: "44.1 kHz"
        case .rate48000: "48 kHz"
        }
    }

    /// Maps a file or device rate to the closest supported project rate.
    static func nearest(to sampleRate: Double) -> AudioSampleRate? {
        guard sampleRate > 0 else { return nil }
        if abs(sampleRate - AudioSampleRate.rate44100.rawValue) < 1 { return .rate44100 }
        if abs(sampleRate - AudioSampleRate.rate48000.rawValue) < 1 { return .rate48000 }
        return abs(sampleRate - AudioSampleRate.rate44100.rawValue)
            < abs(sampleRate - AudioSampleRate.rate48000.rawValue)
            ? .rate44100
            : .rate48000
    }

    /// Picks the most common sample rate across imported audio files.
    static func dominantSampleRate(fileURLs: [URL]) -> AudioSampleRate? {
        var counts: [AudioSampleRate: Int] = [:]
        for url in fileURLs {
            guard let file = try? AVAudioFile(forReading: url),
                  let rate = nearest(to: file.processingFormat.sampleRate) else { continue }
            counts[rate, default: 0] += 1
        }
        return counts.max(by: { $0.value < $1.value })?.key
    }
}

/// User-selected audio output configuration.
struct AudioSettings: Codable, Sendable, Equatable {
    var outputDeviceID: UInt32?
    var outputDeviceName: String
    /// Stable AVAudioSession port UID on iPad/iPhone (optional).
    var outputPortUID: String?
    var outputChannelPair: Int
    var sampleRate: AudioSampleRate

    init(
        outputDeviceID: UInt32? = nil,
        outputDeviceName: String = "System Default",
        outputPortUID: String? = nil,
        outputChannelPair: Int = 0,
        sampleRate: AudioSampleRate = .rate44100
    ) {
        self.outputDeviceID = outputDeviceID
        self.outputDeviceName = outputDeviceName
        self.outputPortUID = outputPortUID
        self.outputChannelPair = outputChannelPair
        self.sampleRate = sampleRate
    }

    var usesCustomOutputDevice: Bool {
        if let deviceID = outputDeviceID, deviceID != 0 {
            return true
        }
        if let portUID = outputPortUID, !portUID.isEmpty {
            return true
        }
        return false
    }

    mutating func resetOutputToSystemDefault() {
        outputDeviceID = nil
        outputPortUID = nil
        outputDeviceName = AudioOutputDevice.systemDefault.name
    }
}

struct AudioOutputDevice: Identifiable, Hashable, Sendable {
    let id: UInt32
    let name: String
    let outputChannelCount: Int
    /// AVAudioSession port UID when listed from a route (nil for system default).
    let portUID: String?

    init(id: UInt32, name: String, outputChannelCount: Int, portUID: String? = nil) {
        self.id = id
        self.name = name
        self.outputChannelCount = outputChannelCount
        self.portUID = portUID
    }

    static let systemDefault = AudioOutputDevice(
        id: 0,
        name: "System Default",
        outputChannelCount: 2,
        portUID: nil
    )

#if !os(macOS)
    static let builtInSpeaker = AudioOutputDevice(
        id: 1,
        name: "iPad Speaker",
        outputChannelCount: 2,
        portUID: AudioDeviceService.builtInSpeakerPortUID
    )
#endif
}
