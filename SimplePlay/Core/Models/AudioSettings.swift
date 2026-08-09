//
//  AudioSettings.swift
//  SimplePlay
//

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
}

/// User-selected audio output configuration.
struct AudioSettings: Codable, Sendable, Equatable {
    var outputDeviceID: UInt32?
    var outputDeviceName: String
    var outputChannelPair: Int
    var sampleRate: AudioSampleRate

    init(
        outputDeviceID: UInt32? = nil,
        outputDeviceName: String = "System Default",
        outputChannelPair: Int = 0,
        sampleRate: AudioSampleRate = .rate48000
    ) {
        self.outputDeviceID = outputDeviceID
        self.outputDeviceName = outputDeviceName
        self.outputChannelPair = outputChannelPair
        self.sampleRate = sampleRate
    }
}

struct AudioOutputDevice: Identifiable, Hashable, Sendable {
    let id: UInt32
    let name: String
    let outputChannelCount: Int

    static let systemDefault = AudioOutputDevice(id: 0, name: "System Default", outputChannelCount: 2)
}
