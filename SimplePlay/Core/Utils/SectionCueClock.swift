//
//  SectionCueClock.swift
//  SimplePlay
//
//  Ableton/Reaper-style cut: the next clip is cued to a host timestamp at arm
//  time, not started from `.dataPlayedBack` (that is always one quantum late).
//

import AVFoundation
import Foundation

/// Pure timing for gapless section cuts. No extra lead-in on the audible body —
/// the live cap occupies time until the boundary. Standby starts a short silent
/// preroll first so HAL's first-render skip lands on silence, not the loop body.
enum SectionCueClock {
    /// Silent frames rendered on standby before the audible cut.
    /// ~one macOS 4096-frame I/O cycle at 44.1 kHz; covers `skipping cycle due to overload`.
    static let cutPrerollSeconds: TimeInterval = 0.08

    /// `play(at:)` must stay in the future; never consume the whole remaining into preroll.
    static let minFutureCueSeconds: TimeInterval = 0.02

    /// Seconds until the audible cut. Never negative.
    static func remaining(to boundary: TimeInterval, playhead: TimeInterval) -> TimeInterval {
        max(0, boundary - playhead)
    }

    /// Silence to schedule ahead of the body so the node is already in the IO cycle.
    static func preroll(forRemaining remaining: TimeInterval) -> TimeInterval {
        guard remaining > minFutureCueSeconds else { return 0 }
        return min(cutPrerollSeconds, remaining - minFutureCueSeconds)
    }

    /// Host-time remaining passed to `play(at:)`. Body starts after preroll.
    static func cueRemaining(toBoundary remaining: TimeInterval) -> TimeInterval {
        remaining - preroll(forRemaining: remaining)
    }

    /// Host time when the next player must start.
    static func cueHostTime(remaining: TimeInterval, renderHostTime: UInt64) -> UInt64 {
        renderHostTime &+ AVAudioTime.hostTime(forSeconds: remaining)
    }

    /// `nil` when remaining is 0 or the render clock has no valid host time —
    /// the boundary path then falls back to an immediate `play()`.
    static func makeCueHostTime(
        remaining: TimeInterval,
        renderHostTime: UInt64,
        isHostTimeValid: Bool
    ) -> UInt64? {
        guard remaining > 0, isHostTimeValid else { return nil }
        return cueHostTime(remaining: remaining, renderHostTime: renderHostTime)
    }

    /// Host time only. Never attach the output node's sample time to a cold
    /// player — that is HAL `got N want: 1` (player timeline is still 1).
    static func makeCueTime(remaining: TimeInterval, renderTime: AVAudioTime) -> AVAudioTime? {
        guard let host = makeCueHostTime(
            remaining: remaining,
            renderHostTime: renderTime.hostTime,
            isHostTimeValid: renderTime.isHostTimeValid
        ) else { return nil }
        return AVAudioTime(hostTime: host)
    }

    /// Cue relative to a player that has already rendered (second wrap / jump onto a hot node).
    static func makePlayerRelativeCueTime(
        remaining: TimeInterval,
        playerTime: AVAudioTime
    ) -> AVAudioTime? {
        guard remaining > 0, playerTime.isSampleTimeValid, playerTime.sampleRate > 0 else {
            return makeCueTime(remaining: remaining, renderTime: playerTime)
        }
        let extra = AVAudioFramePosition((remaining * playerTime.sampleRate).rounded())
        let sample = playerTime.sampleTime + extra
        if playerTime.isHostTimeValid {
            let host = cueHostTime(remaining: remaining, renderHostTime: playerTime.hostTime)
            return AVAudioTime(hostTime: host, sampleTime: sample, atRate: playerTime.sampleRate)
        }
        return AVAudioTime(sampleTime: sample, atRate: playerTime.sampleRate)
    }

    /// Silence a cold standby must render so `play()` happens at arm, not at the cut.
    static func fillSilenceSeconds(remaining: TimeInterval, startLead: TimeInterval) -> TimeInterval {
        max(0, remaining - max(0, startLead))
    }
}
