//
//  MIDIInputService.swift
//  SimplePlay
//

import Foundation

#if os(macOS) || os(iOS)
import CoreMIDI

struct MIDISourceInfo: Identifiable, Equatable, Sendable {
    let uniqueID: Int32
    let name: String

    var id: Int32 { uniqueID }
}

/// Listens for incoming MIDI note-on events to trigger arrangement sections.
final class MIDIInputService: @unchecked Sendable {
    static let shared = MIDIInputService()

    var onNoteOn: (@MainActor (UInt8, UInt8) -> Void)?
    private(set) var connectedSourceUniqueID: Int32?
    private(set) var connectedSourceName: String?

    private var client = MIDIClientRef()
    private var inputPort = MIDIPortRef()

    private init() {
        guard MIDIClientCreate("SimplePlay MIDI In" as CFString, Self.clientNotify, nil, &client) == noErr else {
            return
        }

        let ref = Unmanaged.passUnretained(self).toOpaque()
        guard MIDIInputPortCreate(
            client,
            "SimplePlay In" as CFString,
            Self.readProc,
            ref,
            &inputPort
        ) == noErr else {
            return
        }

        connectToAllSources()
    }

    func availableSources() -> [MIDISourceInfo] {
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
        disconnectAllSources()

        guard let source else {
            connectToAllSources()
            connectedSourceUniqueID = nil
            connectedSourceName = "All Inputs"
            return true
        }

        guard let endpoint = endpoint(forUniqueID: source.uniqueID) else {
            connectedSourceUniqueID = nil
            connectedSourceName = nil
            return false
        }

        let status = MIDIPortConnectSource(inputPort, endpoint, nil)
        guard status == noErr else {
            connectedSourceUniqueID = nil
            connectedSourceName = nil
            return false
        }

        connectedSourceUniqueID = source.uniqueID
        connectedSourceName = source.name
        return true
    }

    @discardableResult
    func reconnectSavedDevice(name: String?, uniqueID: Int32?) -> Bool {
        if let uniqueID,
           let endpoint = endpoint(forUniqueID: uniqueID) {
            disconnectAllSources()
            guard MIDIPortConnectSource(inputPort, endpoint, nil) == noErr else { return false }
            connectedSourceUniqueID = uniqueID
            connectedSourceName = endpointDisplayName(endpoint) ?? name
            return true
        }

        if let name,
           let match = availableSources().first(where: { $0.name == name }) {
            return connect(to: match)
        }

        connectToAllSources()
        return false
    }

    private func connectToAllSources() {
        let count = MIDIGetNumberOfSources()
        for index in 0..<count {
            MIDIPortConnectSource(inputPort, MIDIGetSource(index), nil)
        }
        connectedSourceUniqueID = nil
        connectedSourceName = count > 0 ? "All Inputs" : nil
    }

    private func disconnectAllSources() {
        let count = MIDIGetNumberOfSources()
        for index in 0..<count {
            MIDIPortDisconnectSource(inputPort, MIDIGetSource(index))
        }
    }

    private func endpoint(forUniqueID uniqueID: Int32) -> MIDIEndpointRef? {
        var object = MIDIObjectRef()
        var objectType = MIDIObjectType.other
        guard MIDIObjectFindByUniqueID(uniqueID, &object, &objectType) == noErr, object != 0 else {
            return nil
        }
        return object
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

    private static let clientNotify: MIDINotifyProc = { _, _ in
        // Hot-plug refresh is handled by the view model polling on appear / manual refresh.
    }

    private static let readProc: MIDIReadProc = { packetList, _, refCon in
        guard let refCon else { return }
        let service = Unmanaged<MIDIInputService>.fromOpaque(refCon).takeUnretainedValue()
        service.handlePacketList(packetList)
    }

    private func handlePacketList(_ list: UnsafePointer<MIDIPacketList>) {
        var packet = list.pointee.packet

        for index in 0..<Int(list.pointee.numPackets) {
            let length = Int(packet.length)
            if length >= 3 {
                let status = packet.data.0
                let command = status & 0xF0
                let channel = status & 0x0F

                if command == 0x90, packet.data.2 > 0 {
                    let note = packet.data.1
                    if let onNoteOn {
                        Task { @MainActor in
                            onNoteOn(note, channel)
                        }
                    }
                }
            }

            if index + 1 < Int(list.pointee.numPackets) {
                packet = MIDIPacketNext(&packet).pointee
            }
        }
    }
}
#endif
