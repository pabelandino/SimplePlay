//
//  SectionStandbyCoordinator.swift
//  LvoqPlayback
//
//  Exclusive next-intent lives on a standby player. The live FIFO is never
//  appended to for loop / jump / continuation — toggling intent only repreimes
//  the idle node.
//
//  Gapless cuts cue standby with `play(at: boundaryHostTime)` at arm time.
//  A cued node reports `isPlaying == true` while waiting for that timestamp;
//  it must not be paused, and the boundary must not call `play()` again.
//
//  Idle `scheduleBuffer` completions must not take over: iOS can invoke
//  `.dataPlayedBack` immediately on a stopped player. Stopping the live node
//  from that callback crashes the render thread.
//

import AVFoundation
import Foundation
import os

enum SectionNextIntent: Equatable {
    case none
    case loopBody
    case continuation
    case jump
}

/// Thread-safe A/B lanes so the render-thread completion can promote the next buffer.
final class SectionStandbyCoordinator: @unchecked Sendable {
    private struct Lane {
        var live: AVAudioPlayerNode
        var standby: AVAudioPlayerNode
        var primed: Bool
        var cued: Bool
        var scheduleGeneration: UInt64
        var playingGeneration: UInt64
    }

    private let lock = OSAllocatedUnfairLock()
    private var lanes: [UUID: Lane] = [:]
    private var intent: SectionNextIntent = .none

    var currentIntent: SectionNextIntent {
        lock.withLock { intent }
    }

    /// Completions from a buffer that is not actually playing must be ignored.
    /// A cued `play(at:)` already owns the cut — chaining would call `play()`
    /// without a timestamp (`HALC … got N want: 1`) and gap the first wrap.
    static func shouldChainFromBufferEnd(
        endedGeneration: UInt64,
        playingGeneration: UInt64,
        isCued: Bool = false
    ) -> Bool {
        !isCued && playingGeneration != 0 && endedGeneration == playingGeneration
    }

    /// Cued standbys already have `play(at:)` issued — do not start them again.
    static func needsImmediateStart(standbyIsPlaying: Bool, isCued: Bool = false) -> Bool {
        !isCued && !standbyIsPlaying
    }

    /// Never pause a cued node (cancels the cut). Never pause the live node.
    /// Only retire the outgoing cap once the incoming live is rendering.
    static func shouldPauseRetiredStandby(
        isCued: Bool,
        standbyIsLive: Bool,
        incomingLiveIsRendering: Bool
    ) -> Bool {
        !isCued && !standbyIsLive && incomingLiveIsRendering
    }

    /// Re-arming stops a live `play(at:)` cue and is what made the first wrap click.
    static func shouldSkipRearm(
        currentIntent: SectionNextIntent,
        expectedIntent: SectionNextIntent,
        hasPrimeOrCue: Bool
    ) -> Bool {
        currentIntent == expectedIntent && hasPrimeOrCue
    }

    func register(clipID: UUID, live: AVAudioPlayerNode, standby: AVAudioPlayerNode) {
        lock.withLock {
            lanes[clipID] = Lane(
                live: live,
                standby: standby,
                primed: false,
                cued: false,
                scheduleGeneration: 0,
                playingGeneration: 0
            )
        }
    }

    func unregisterAll() {
        lock.withLock {
            lanes.removeAll()
            intent = .none
        }
    }

    func setIntent(_ newIntent: SectionNextIntent) {
        lock.withLock { intent = newIntent }
    }

    /// Increments the standby schedule generation. Capture the return value in the
    /// completion so a stale/immediate callback cannot start playback.
    func beginPrime(clipID: UUID) -> UInt64 {
        lock.withLock {
            guard var lane = lanes[clipID] else { return 0 }
            lane.scheduleGeneration &+= 1
            lane.primed = false
            lane.cued = false
            lanes[clipID] = lane
            return lane.scheduleGeneration
        }
    }

    var hasAnyPrime: Bool {
        lock.withLock { lanes.values.contains(where: \.primed) }
    }

    var hasAnyCued: Bool {
        lock.withLock { lanes.values.contains(where: \.cued) }
    }

    func markPrimed(clipID: UUID) {
        lock.withLock { lanes[clipID]?.primed = true }
    }

    func markCued(clipID: UUID) {
        lock.withLock { lanes[clipID]?.cued = true }
    }

    func isCued(clipID: UUID) -> Bool {
        lock.withLock { lanes[clipID]?.cued ?? false }
    }

    func clearPrimes() {
        lock.withLock {
            for id in lanes.keys {
                lanes[id]?.primed = false
                lanes[id]?.cued = false
            }
            intent = .none
        }
    }

    func clearCues() {
        lock.withLock {
            for id in lanes.keys {
                lanes[id]?.cued = false
            }
        }
    }

    func standbyNode(for clipID: UUID) -> AVAudioPlayerNode? {
        lock.withLock { lanes[clipID]?.standby }
    }

    func liveNode(for clipID: UUID) -> AVAudioPlayerNode? {
        lock.withLock { lanes[clipID]?.live }
    }

    /// If the standby was already cued with `play(at:)`, only swap lanes.
    func startPrimedStandby(clipID: UUID, allowImmediateStart: Bool = true) {
        lock.withLock {
            takeOverIfPrimedLocked(clipID: clipID, allowImmediateStart: allowImmediateStart)
        }
    }

    /// Completion from a scheduled standby/live buffer. Ignored unless that
    /// generation is the one currently playing.
    func onScheduledBufferEnded(clipID: UUID, generation: UInt64) {
        lock.withLock {
            let lane = lanes[clipID]
            let playing = lane?.playingGeneration ?? 0
            let isCued = lane?.cued ?? false
            guard Self.shouldChainFromBufferEnd(
                endedGeneration: generation,
                playingGeneration: playing,
                isCued: isCued
            ) else { return }
            takeOverIfPrimedLocked(clipID: clipID, allowImmediateStart: !isCued)
        }
    }

    private func takeOverIfPrimedLocked(clipID: UUID, allowImmediateStart: Bool) {
        guard var lane = lanes[clipID], lane.primed else { return }
        if allowImmediateStart, Self.needsImmediateStart(
            standbyIsPlaying: lane.standby.isPlaying,
            isCued: lane.cued
        ) {
            lane.standby.play()
        }
        lane.playingGeneration = lane.scheduleGeneration
        let previousLive = lane.live
        lane.live = lane.standby
        lane.standby = previousLive
        lane.primed = false
        lane.cued = false
        lanes[clipID] = lane
    }
}
