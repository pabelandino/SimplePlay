//
//  MIDIInputService.swift
//  SimplePlay
//

import Foundation

#if os(macOS) || os(iOS)
import CoreMIDI
#if os(iOS)
import AVFoundation
#endif

struct MIDISourceInfo: Identifiable, Equatable, Sendable {
    let uniqueID: Int32
    let name: String

    var id: Int32 { uniqueID }
}

struct MIDIInputEvent: Sendable, Equatable {
    enum Kind: Sendable, Equatable {
        case noteOn
        case controlChange
    }

    let kind: Kind
    let number: UInt8
    let channel: UInt8
    let sourceUniqueID: Int32?
}

/// Listens for incoming MIDI note-on and control-change events to trigger arrangement sections.
final class MIDIInputService: @unchecked Sendable {
    static let shared = MIDIInputService()

    var onEvent: (@MainActor (MIDIInputEvent) -> Void)?
    var preferredSourceUniqueID: Int32?
    var acceptAllSources = false

    private(set) var connectedSourceUniqueID: Int32?
    private(set) var connectedSourceName: String?
    private(set) var isReady = false

    private var client = MIDIClientRef()
    private var inputPort = MIDIPortRef()
    private let connectionLock = NSLock()
    private var sourceConnectionRefs: [Int32: UnsafeMutablePointer<Int32>] = [:]

    private init() {}

    func ensureReady() {
        connectionLock.lock()
        defer { connectionLock.unlock() }

#if os(iOS)
        activateAudioSessionForMIDI()
#endif

        if !isReady {
            guard configureClientAndPort() else { return }
            isReady = true
        }

        connectToAllSourcesUnlocked()
    }

    func availableSources() -> [MIDISourceInfo] {
        ensureReady()

        let count = MIDIGetNumberOfSources()
        var sources: [MIDISourceInfo] = []

        for index in 0..<count {
            let endpoint = MIDIGetSource(index)
            guard endpoint != 0 else { continue }

            let uniqueID = endpointUniqueID(endpoint)
            let name = endpointDisplayName(endpoint) ?? "MIDI Source \(index + 1)"
            sources.append(MIDISourceInfo(uniqueID: uniqueID, name: name))
        }

        return sources.sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
    }

    @discardableResult
    func connect(to source: MIDISourceInfo?) -> Bool {
        ensureReady()

        preferredSourceUniqueID = source?.uniqueID
        connectedSourceUniqueID = source?.uniqueID
        connectedSourceName = source?.name ?? (availableSources().isEmpty ? nil : "All Inputs")

        connectionLock.lock()
        connectToAllSourcesUnlocked()
        connectionLock.unlock()

        return true
    }

    @discardableResult
    func reconnectSavedDevice(name: String?, uniqueID: Int32?) -> Bool {
        ensureReady()

        if let uniqueID,
           let source = availableSources().first(where: { $0.uniqueID == uniqueID }) {
            return connect(to: source)
        }

        if let name,
           let match = availableSources().first(where: { $0.name == name }) {
            return connect(to: match)
        }

        return connect(to: nil)
    }

    private func configureClientAndPort() -> Bool {
        let ref = Unmanaged.passUnretained(self).toOpaque()

        guard MIDIClientCreate("SimplePlay MIDI In" as CFString, Self.clientNotify, ref, &client) == noErr else {
            return false
        }

        let readBlock: MIDIReadBlock = { packetList, srcConnRefCon in
            let service = Unmanaged<MIDIInputService>.fromOpaque(ref).takeUnretainedValue()
            let sourceUniqueID = srcConnRefCon?.assumingMemoryBound(to: Int32.self).pointee
            service.handlePacketList(packetList, sourceUniqueID: sourceUniqueID)
        }

        guard MIDIInputPortCreateWithBlock(
            client,
            "SimplePlay In" as CFString,
            &inputPort,
                     readBlock
        ) == noErr else {
            return false
        }

        return true
    }

    private func connectToAllSourcesUnlocked() {
        disconnectAllSourcesUnlocked()

        let count = MIDIGetNumberOfSources()
        for index in 0..<count {
            let endpoint = MIDIGetSource(index)
            guard endpoint != 0 else { continue }

            let uniqueID = endpointUniqueID(endpoint)
            let ref = UnsafeMutablePointer<Int32>.allocate(capacity: 1)
            ref.initialize(to: uniqueID)
            sourceConnectionRefs[uniqueID] = ref
            MIDIPortConnectSource(inputPort, endpoint, ref)
        }

        if connectedSourceUniqueID == nil {
            connectedSourceName = count > 0 ? "All Inputs" : nil
        }
    }

    private func disconnectAllSourcesUnlocked() {
        let count = MIDIGetNumberOfSources()
        for index in 0..<count {
            MIDIPortDisconnectSource(inputPort, MIDIGetSource(index))
        }

        for ref in sourceConnectionRefs.values {
            ref.deinitialize(count: 1)
            ref.deallocate()
        }
        sourceConnectionRefs.removeAll()
    }

    private func endpointUniqueID(_ endpoint: MIDIEndpointRef) -> Int32 {
        var uniqueID: Int32 = 0
        MIDIObjectGetIntegerProperty(endpoint, kMIDIPropertyUniqueID, &uniqueID)
        return uniqueID
    }

    private func endpointDisplayName(_ endpoint: MIDIEndpointRef) -> String? {
        var name: Unmanaged<CFString>?
        guard MIDIObjectGetStringProperty(endpoint, kMIDIPropertyDisplayName, &name) == noErr,
              let value = name?.takeRetainedValue() as String? else {
            return nil
        }
        return value
    }

    private func restoreConnectionAfterSetupChange() {
        connectionLock.lock()
        defer { connectionLock.unlock() }
        connectToAllSourcesUnlocked()
    }

#if os(iOS)
    private func activateAudioSessionForMIDI() {
        let session = AVAudioSession.sharedInstance()
        try? session.setCategory(.playback, mode: .default, options: [.mixWithOthers])
        try? session.setActive(true)
    }
#endif

    private static let clientNotify: MIDINotifyProc = { notification, refCon in
        guard let refCon else { return }

        switch notification.pointee.messageID {
        case .msgSetupChanged, .msgObjectAdded, .msgObjectRemoved:
            let service = Unmanaged<MIDIInputService>.fromOpaque(refCon).takeUnretainedValue()
            service.restoreConnectionAfterSetupChange()
        default:
            break
        }
    }

    private func handlePacketList(_ list: UnsafePointer<MIDIPacketList>, sourceUniqueID: Int32?) {
        guard shouldAccept(from: sourceUniqueID) else { return }

        var packet = list.pointee.packet

        for index in 0..<Int(list.pointee.numPackets) {
            parseMIDIPacket(packet, sourceUniqueID: sourceUniqueID)
            if index + 1 < Int(list.pointee.numPackets) {
                packet = MIDIPacketNext(&packet).pointee
            }
        }
    }

    private func shouldAccept(from sourceUniqueID: Int32?) -> Bool {
        if acceptAllSources { return true }
        guard let preferredSourceUniqueID else { return true }
        guard let sourceUniqueID else { return true }
        return sourceUniqueID == preferredSourceUniqueID
    }

    private func parseMIDIPacket(_ packet: MIDIPacket, sourceUniqueID: Int32?) {
        let length = Int(packet.length)
        guard length > 0 else { return }

        let bytes = packetBytes(packet)
        var runningStatus: UInt8 = 0
        var offset = 0

        while offset < bytes.count {
            let byte = bytes[offset]

            if byte >= 0xF0 {
                if byte == 0xF0 {
                    offset += 1
                    while offset < bytes.count, bytes[offset] != 0xF7 {
                        offset += 1
                    }
                    if offset < bytes.count {
                        offset += 1
                    }
                } else if byte >= 0xF8 {
                    offset += 1
                } else {
                    offset = min(bytes.count, offset + systemMessageLength(for: byte))
                }
                runningStatus = 0
                continue
            }

            if byte & 0x80 != 0 {
                runningStatus = byte
                offset += 1
            } else if runningStatus == 0 {
                offset += 1
                continue
            }

            let status = runningStatus
            let command = status & 0xF0
            let channel = status & 0x0F
            let dataLength = voiceMessageDataLength(for: command)

            guard dataLength > 0, offset + dataLength <= bytes.count else { break }

            let data1 = bytes[offset]
            let data2 = dataLength > 1 ? bytes[offset + 1] : 0
            offset += dataLength

            if command == 0x90, data2 > 0 {
                deliver(
                    MIDIInputEvent(
                        kind: .noteOn,
                        number: data1,
                        channel: channel,
                        sourceUniqueID: sourceUniqueID
                    )
                )
            } else if command == 0xB0, data2 > 0 {
                deliver(
                    MIDIInputEvent(
                        kind: .controlChange,
                        number: data1,
                        channel: channel,
                        sourceUniqueID: sourceUniqueID
                    )
                )
            }
        }
    }

    private func packetBytes(_ packet: MIDIPacket) -> [UInt8] {
        withUnsafePointer(to: packet.data) { pointer in
            pointer.withMemoryRebound(to: UInt8.self, capacity: Int(packet.length)) {
                Array(UnsafeBufferPointer(start: $0, count: Int(packet.length)))
            }
        }
    }

    private func systemMessageLength(for status: UInt8) -> Int {
        switch status {
        case 0xF1, 0xF3:
            return 2
        case 0xF2:
            return 3
        default:
            return 1
        }
    }

    private func voiceMessageDataLength(for command: UInt8) -> Int {
        switch command {
        case 0xC0, 0xD0:
            return 1
        case 0x80, 0x90, 0xA0, 0xB0, 0xE0:
            return 2
        default:
            return 0
        }
    }

    private func deliver(_ event: MIDIInputEvent) {
        guard let onEvent else { return }

        Task { @MainActor in
            onEvent(event)
        }
    }
}
#endif
