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
        case repeatingSectionAtEnd(ArrangementSection)
        case waitingToJump(to: ArrangementSection)
        case continuingTimeline
    }

    private(set) var state: PlaybackState = .idle
    private(set) var activeSection: ArrangementSection?
    private(set) var pendingSection: ArrangementSection?

    var currentTime: TimeInterval = 0
    var isPlaying = false
    var isRepeatEnabled = false

    private var sections: [ArrangementSection] = []
    private var lastExitedSectionID: UUID?

    func configure(sections: [ArrangementSection]) {
        self.sections = sections.sorted { $0.startTime < $1.startTime }

        if let activeSection,
           let refreshed = self.sections.first(where: { $0.id == activeSection.id }) {
            self.activeSection = refreshed
            switch state {
            case .playingSection:
                state = .playingSection(refreshed)
            case .repeatingSectionAtEnd:
                state = .repeatingSectionAtEnd(refreshed)
            default:
                break
            }
        }

        if let pendingSection,
           let refreshed = self.sections.first(where: { $0.id == pendingSection.id }) {
            self.pendingSection = refreshed
        }
    }

    enum SectionTriggerResult: Equatable {
        case activatedImmediately
        case queuedForEnd
        case enabledRepeatAtEnd
    }

    /// When playback was started with the transport (not a section pad), the engine stays in
    /// `idle` / `continuingTimeline` even while the playhead is inside a section. Call this
    /// before handling a pad press so queue/repeat-at-end logic applies to the visible section.
    func ensureSectionPlaybackContext(at time: TimeInterval) {
        guard isPlaying else { return }

        switch state {
        case .playingSection(let current), .repeatingSectionAtEnd(let current):
            syncActiveSectionToPlayhead(current: current, at: time)
        case .waitingToJump:
            if let current = activeSection {
                syncActiveSectionToPlayhead(current: current, at: time)
                state = .playingSection(activeSection ?? current)
            }
        case .idle, .continuingTimeline:
            guard let playheadSection = sectionContaining(time: time) else { return }
            activeSection = playheadSection
            currentTime = time
            state = .playingSection(playheadSection)
        }
    }

    func triggerSection(_ section: ArrangementSection) -> SectionTriggerResult {
        if shouldJumpImmediatelyAfterSectionExit(to: section) {
            activate(section)
            return .activatedImmediately
        }

        ensureSectionPlaybackContext(at: currentTime)

        if canRepeatSameSectionAtEnd(section) {
            if case .repeatingSectionAtEnd = state {
                return .enabledRepeatAtEnd
            }
            if case .playingSection(let current) = state {
                state = .repeatingSectionAtEnd(current)
                pendingSection = nil
                return .enabledRepeatAtEnd
            }
        }

        if let current = currentPlaybackSection() {
            if current.id != section.id {
                if section.waitForCurrentToFinish {
                    queueSectionJump(to: section)
                    return .queuedForEnd
                }
                activate(section)
                return .activatedImmediately
            }

            activate(section)
            return .activatedImmediately
        }

        if case .waitingToJump = state {
            queueSectionJump(to: section)
            return .queuedForEnd
        }

        activate(section)
        return .activatedImmediately
    }

    private func queueSectionJump(to section: ArrangementSection) {
        pendingSection = section
        if case .repeatingSectionAtEnd(let current) = state {
            state = .playingSection(current)
        }
    }

    func triggerSection(midiNote: UInt8, channel: UInt8 = 0) {
        guard let section = sections.first(where: {
            !$0.midiUsesControlChange &&
            $0.midiNote == midiNote &&
            $0.midiChannel == channel
        }) else { return }

        _ = triggerSection(section)
    }

    func setRepeatEnabled(_ enabled: Bool) {
        isRepeatEnabled = enabled
    }

    func tick(delta: TimeInterval, projectDuration: TimeInterval) {
        guard isPlaying else { return }
        currentTime += delta

        switch state {
        case .playingSection(let section), .repeatingSectionAtEnd(let section):
            handleSectionPlayback(section, projectDuration: projectDuration)
        case .waitingToJump:
            if let current = activeSection {
                handleSectionPlayback(current, projectDuration: projectDuration)
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
        lastExitedSectionID = nil
        state = .idle
    }

    private func activate(_ section: ArrangementSection) {
        activeSection = section
        currentTime = section.startTime
        state = .playingSection(section)
        isPlaying = true
        lastExitedSectionID = nil
    }

    private func shouldJumpImmediatelyAfterSectionExit(to section: ArrangementSection) -> Bool {
        guard lastExitedSectionID != nil else { return false }

        switch state {
        case .idle, .continuingTimeline:
            return true
        default:
            return false
        }
    }

    private func currentPlaybackSection() -> ArrangementSection? {
        switch state {
        case .playingSection(let section), .repeatingSectionAtEnd(let section):
            return section
        case .waitingToJump:
            return activeSection
        default:
            return nil
        }
    }

    private func canRepeatSameSectionAtEnd(_ section: ArrangementSection) -> Bool {
        guard let current = currentPlaybackSection() else { return false }
        guard current.id == section.id, section.contains(time: currentTime) else { return false }

        if let playheadSection = sectionContaining(time: currentTime), playheadSection.id != section.id {
            return false
        }

        return true
    }

    private func syncActiveSectionToPlayhead(current: ArrangementSection, at time: TimeInterval) {
        guard let playheadSection = sectionContaining(time: time) else {
            if !current.contains(time: time) {
                activeSection = nil
            }
            return
        }

        if playheadSection.id == current.id {
            return
        }

        if playheadSection.duration < current.duration {
            activeSection = playheadSection
            state = .playingSection(playheadSection)
            return
        }

        if !current.contains(time: time) {
            activeSection = playheadSection
            state = .playingSection(playheadSection)
        }
    }

    /// Prefer the narrowest marker when ranges overlap (e.g. a chorus inside a longer verse).
    private func sectionContaining(time: TimeInterval) -> ArrangementSection? {
        let matches = sections.filter { $0.contains(time: time) }
        guard !matches.isEmpty else { return nil }

        if let activeSection,
           matches.contains(where: { $0.id == activeSection.id }) {
            return activeSection
        }

        return matches.min(by: { $0.duration < $1.duration })
    }

    private func handleSectionPlayback(_ section: ArrangementSection, projectDuration: TimeInterval) {
        guard currentTime >= section.endTime else { return }

        if let pending = pendingSection {
            activate(pending)
            pendingSection = nil
            return
        }

        if case .repeatingSectionAtEnd = state {
            currentTime = section.startTime
            state = .playingSection(section)
            return
        }

        if isRepeatEnabled {
            currentTime = section.startTime
            return
        }

        switch section.playbackMode {
        case .repeatSection:
            state = .continuingTimeline
            activeSection = nil
            lastExitedSectionID = section.id
        case .continueTimeline:
            state = .continuingTimeline
            activeSection = nil
            lastExitedSectionID = section.id
        case .continueToNext:
            if let nextID = section.nextSectionID,
               let next = sections.first(where: { $0.id == nextID }) {
                activate(next)
            } else {
                state = .continuingTimeline
                activeSection = nil
                lastExitedSectionID = section.id
            }
        case .oneShot:
            pause()
            state = .idle
            activeSection = nil
            lastExitedSectionID = section.id
        }

        if case .continuingTimeline = state, currentTime >= projectDuration {
            stop()
        }
    }
}
