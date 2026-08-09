//
//  ArrangementPlaybackEngine.swift
//  SimplePlay
//

import Foundation
import Observation

/// Handles section-triggered playback logic (repeat, continue, wait-and-jump).
@MainActor
@Observable
final class ArrangementPlaybackEngine {
    enum PlaybackState: Equatable {
        case idle
        case playingSection(ArrangementSection)
        case waitingToJump(to: ArrangementSection)
        case continuingTimeline
    }

    private(set) var state: PlaybackState = .idle
    private(set) var activeSection: ArrangementSection?
    private(set) var pendingSection: ArrangementSection?

    var currentTime: TimeInterval = 0
    var isPlaying = false

    private var sections: [ArrangementSection] = []

    func configure(sections: [ArrangementSection]) {
        self.sections = sections.sorted { $0.startTime < $1.startTime }
    }

    func triggerSection(midiNote: UInt8, channel: UInt8 = 0) {
        guard let section = sections.first(where: {
            $0.midiNote == midiNote && $0.midiChannel == channel
        }) else { return }

        switch state {
        case .playingSection(let current) where current.id != section.id:
            if section.waitForCurrentToFinish {
                pendingSection = section
                state = .waitingToJump(to: section)
            } else {
                activate(section)
            }
        default:
            activate(section)
        }
    }

    func tick(delta: TimeInterval, projectDuration: TimeInterval) {
        guard isPlaying else { return }
        currentTime += delta

        switch state {
        case .playingSection(let section):
            handleSectionPlayback(section, projectDuration: projectDuration)
        case .waitingToJump:
            if let current = activeSection, currentTime >= current.endTime {
                if let pending = pendingSection {
                    activate(pending)
                    pendingSection = nil
                }
            }
        case .continuingTimeline:
            if currentTime >= projectDuration {
                stop()
            }
        case .idle:
            if currentTime >= projectDuration {
                stop()
            }
        }
    }

    func seek(to time: TimeInterval) {
        currentTime = max(0, time)
    }

    func play() {
        isPlaying = true
    }

    func pause() {
        isPlaying = false
    }

    func stop() {
        isPlaying = false
        currentTime = 0
        activeSection = nil
        pendingSection = nil
        state = .idle
    }

    private func activate(_ section: ArrangementSection) {
        activeSection = section
        currentTime = section.startTime
        state = .playingSection(section)
        isPlaying = true
    }

    private func handleSectionPlayback(_ section: ArrangementSection, projectDuration: TimeInterval) {
        guard currentTime >= section.endTime else { return }

        switch section.playbackMode {
        case .repeatSection:
            currentTime = section.startTime
        case .continueTimeline:
            state = .continuingTimeline
            activeSection = nil
        case .continueToNext:
            if let nextID = section.nextSectionID,
               let next = sections.first(where: { $0.id == nextID }) {
                activate(next)
            } else {
                state = .continuingTimeline
                activeSection = nil
            }
        case .oneShot:
            pause()
            state = .idle
            activeSection = nil
        }

        if case .continuingTimeline = state, currentTime >= projectDuration {
            stop()
        }
    }
}
