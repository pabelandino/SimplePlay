//
//  SectionCueQueueMonitorTests.swift
//  LvoqPlaybackTests
//

import Foundation
import Testing
@testable import LvoqPlayback

@MainActor
struct SectionCueQueueMonitorTests {
    @Test func reportsProgressUntilComplete() {
        let monitor = SectionCueQueueMonitor()
        let id = UUID()
        let generation = monitor.begin(sectionID: id, total: 2)
        #expect(monitor.isQueuing(sectionID: id))
        #expect(monitor.isAnySectionQueuing)
        #expect(abs(monitor.progress(for: id) - 0) < 0.001)

        monitor.completeOne(sectionID: id, generation: generation)
        #expect(abs(monitor.progress(for: id) - 0.5) < 0.001)
        #expect(monitor.isQueuing(sectionID: id))

        monitor.completeOne(sectionID: id, generation: generation)
        #expect(abs(monitor.progress(for: id) - 1) < 0.001)
        #expect(!monitor.isQueuing(sectionID: id))
    }

    @Test func ignoresStaleGeneration() {
        let monitor = SectionCueQueueMonitor()
        let id = UUID()
        let first = monitor.begin(sectionID: id, total: 2)
        let second = monitor.begin(sectionID: id, total: 4)
        monitor.completeOne(sectionID: id, generation: first)
        #expect(abs(monitor.progress(for: id) - 0) < 0.001)
        monitor.completeOne(sectionID: id, generation: second)
        #expect(abs(monitor.progress(for: id) - 0.25) < 0.001)
    }

    @Test func emptyJobIsNotQueuing() {
        let monitor = SectionCueQueueMonitor()
        let id = UUID()
        monitor.begin(sectionID: id, total: 0)
        #expect(!monitor.isQueuing(sectionID: id))
        #expect(!monitor.isAnySectionQueuing)
        #expect(monitor.progress(for: id) == 0)
    }

    @Test func overallProgressAveragesActiveJobs() {
        let monitor = SectionCueQueueMonitor()
        let first = UUID()
        let second = UUID()
        let firstGeneration = monitor.begin(sectionID: first, total: 4)
        monitor.begin(sectionID: second, total: 4)
        #expect(monitor.isAnySectionQueuing)
        #expect(abs(monitor.overallProgress) < 0.001)
        monitor.completeOne(sectionID: first, generation: firstGeneration)
        #expect(abs(monitor.overallProgress - 0.125) < 0.001)
    }

    @Test func visibleQueuingSectionIsTheOldestActiveJob() {
        let monitor = SectionCueQueueMonitor()
        let first = UUID()
        let second = UUID()
        let firstGeneration = monitor.begin(sectionID: first, total: 2)
        monitor.begin(sectionID: second, total: 2)
        #expect(monitor.visibleQueuingSectionID == first)
        monitor.completeOne(sectionID: first, generation: firstGeneration)
        monitor.completeOne(sectionID: first, generation: firstGeneration)
        #expect(monitor.visibleQueuingSectionID == second)
    }
}
