//
//  MIDIOutputService.swift
//  SimplePlay
//

import CoreMIDI
import Foundation

/// Sends MIDI note events to external apps (e.g. lyrics presentation software).
final class MIDIOutputService: @unchecked Sendable {
    static let shared = MIDIOutputService()

    private var client = MIDIClientRef()
    private var outputPort = MIDIPortRef()
    private var destination: MIDIEndpointRef?

    init() {
        MIDIClientCreate("SimplePlay" as CFString, nil, nil, &client)
        MIDIOutputPortCreate(client, "SimplePlay Out" as CFString, &outputPort)
        refreshDestinations()
    }

    func refreshDestinations() {
        let count = MIDIGetNumberOfDestinations()
        destination = count > 0 ? MIDIGetDestination(0) : nil
    }

    func sendNoteOn(note: UInt8, velocity: UInt8 = 127, channel: UInt8 = 0) {
        sendNote(note: note, velocity: velocity, channel: channel, isOn: true)
    }

    func sendNoteOff(note: UInt8, channel: UInt8 = 0) {
        sendNote(note: note, velocity: 0, channel: channel, isOn: false)
    }

    func sendSectionTrigger(_ section: ArrangementSection) {
        sendNoteOn(note: section.midiNote, channel: section.midiChannel)
    }

    private func sendNote(note: UInt8, velocity: UInt8, channel: UInt8, isOn: Bool) {
        guard let destination else { return }

        var packet = MIDIPacket()
        packet.timeStamp = 0
        packet.length = 3
        let status: UInt8 = isOn ? 0x90 : 0x80
        packet.data.0 = status | (channel & 0x0F)
        packet.data.1 = note
        packet.data.2 = velocity

        var packetList = MIDIPacketList(numPackets: 1, packet: packet)
        MIDISend(outputPort, destination, &packetList)
    }
}
