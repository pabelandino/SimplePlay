//
//  SectionCueQueueMonitor.swift
//  LvoqPlayback
//
//  Background PCM queue for section cuts. Decode never runs on the arm/wrap path.
//

import Foundation
import Observation

@MainActor
@Observable
final class SectionCueQueueMonitor {
    static let shared = SectionCueQueueMonitor()

    struct JobState: Equatable {
        var total: Int
        var completed: Int
        var generation: UInt64
    }

    private(set) var jobs: [UUID: JobState] = [:]
    private var generation: UInt64 = 0

    var isAnySectionQueuing: Bool {
        jobs.values.contains { $0.total > 0 && $0.completed < $0.total }
    }

    /// Oldest in-flight job. UI shows a loader only on this section's play pad.
    var visibleQueuingSectionID: UUID? {
        jobs
            .filter { $0.value.total > 0 && $0.value.completed < $0.value.total }
            .min(by: { $0.value.generation < $1.value.generation })?
            .key
    }

    var overallProgress: Double {
        let active = jobs.values.filter { $0.total > 0 && $0.completed < $0.total }
        guard !active.isEmpty else { return 0 }
        let total = active.reduce(0) { $0 + $1.total }
        let done = active.reduce(0) { $0 + $1.completed }
        guard total > 0 else { return 0 }
        return min(1, Double(done) / Double(total))
    }

    func progress(for sectionID: UUID) -> Double {
        guard let job = jobs[sectionID], job.total > 0 else { return 0 }
        return min(1, Double(job.completed) / Double(job.total))
    }

    func isQueuing(sectionID: UUID) -> Bool {
        guard let job = jobs[sectionID] else { return false }
        return job.total > 0 && job.completed < job.total
    }

    @discardableResult
    func begin(sectionID: UUID, total: Int) -> UInt64 {
        generation &+= 1
        if total <= 0 {
            jobs.removeValue(forKey: sectionID)
            return generation
        }
        jobs[sectionID] = JobState(total: total, completed: 0, generation: generation)
        return generation
    }

    func completeOne(sectionID: UUID, generation: UInt64) {
        guard var job = jobs[sectionID], job.generation == generation else { return }
        job.completed = min(job.total, job.completed + 1)
        jobs[sectionID] = job
        if job.completed >= job.total {
            scheduleCleanup(sectionID, generation: generation)
        }
    }

    func cancel(sectionID: UUID) {
        jobs.removeValue(forKey: sectionID)
    }

    func reset() {
        jobs.removeAll()
    }

    private func scheduleCleanup(_ sectionID: UUID, generation: UInt64) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) { [weak self] in
            guard let self,
                  let current = self.jobs[sectionID],
                  current.generation == generation,
                  current.completed >= current.total
            else { return }
            self.jobs.removeValue(forKey: sectionID)
        }
    }
}
