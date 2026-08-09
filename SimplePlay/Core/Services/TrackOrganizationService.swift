//
//  TrackOrganizationService.swift
//  SimplePlay
//

import Foundation

/// Imports multitrack folders/files and organizes tracks with smart grouping and ordering.
struct TrackOrganizationService: Sendable {
    enum ImportPlacement: Sendable, Equatable {
        case appendNewGroup(startTime: TimeInterval?)
        case insertIntoGroup(groupIndex: Int, startTime: TimeInterval?)
    }

    struct ImportedStem: Sendable {
        let url: URL
        let name: String
        let duration: TimeInterval
    }

    func buildTracks(from stems: [ImportedStem], group: TrackGroup, groupIndex: Int) -> [AudioTrack] {
        stems.map { stem in
            let standardized = TrackNameStandardizer.standardize(stem.name)
            let clip = AudioClip(
                name: stem.name,
                fileURL: stem.url,
                startTime: group.horizontalOffset,
                duration: stem.duration,
                groupIndex: groupIndex
            )
            return AudioTrack(
                originalName: standardized.originalName,
                standardCode: standardized.standardCode,
                role: standardized.role,
                colorHex: TrackColorPalette.hex(for: standardized.role),
                clips: [clip]
            )
        }
    }

    /// Merges a new multitrack import into an existing project with intelligent alignment.
    func merge(
        project: DAWProject,
        newStems: [ImportedStem],
        groupName: String,
        startTime: TimeInterval? = nil
    ) -> DAWProject {
        importStems(
            project: project,
            newStems: newStems,
            groupName: groupName,
            placement: .appendNewGroup(startTime: startTime)
        )
    }

    func importStems(
        project: DAWProject,
        newStems: [ImportedStem],
        groupName: String,
        placement: ImportPlacement
    ) -> DAWProject {
        guard !newStems.isEmpty else { return project }

        switch placement {
        case .appendNewGroup(let startTime):
            return appendNewGroup(
                project: project,
                newStems: newStems,
                groupName: groupName,
                startTime: startTime
            )
        case .insertIntoGroup(let groupIndex, let startTime):
            return insertIntoGroup(
                project: project,
                newStems: newStems,
                groupIndex: groupIndex,
                startTime: startTime
            )
        }
    }

    private func appendNewGroup(
        project: DAWProject,
        newStems: [ImportedStem],
        groupName: String,
        startTime: TimeInterval?
    ) -> DAWProject {
        var updated = project
        let groupIndex = updated.groups.count
        let maxEndTime = updated.duration
        let resolvedStart = startTime ?? (maxEndTime > 0 ? maxEndTime : 0)
        let newGroup = TrackGroup(name: groupName, horizontalOffset: resolvedStart)
        updated.groups.append(newGroup)

        let newTracks = buildTracks(from: newStems, group: newGroup, groupIndex: groupIndex)
        updated.tracks = mergeTracks(existing: updated.tracks, incoming: newTracks)
        TrackColorPalette.ensureDistinctColors(on: &updated.tracks)
        return updated
    }

    private func insertIntoGroup(
        project: DAWProject,
        newStems: [ImportedStem],
        groupIndex: Int,
        startTime: TimeInterval?
    ) -> DAWProject {
        var updated = project

        if updated.groups.isEmpty {
            return importInitial(
                project: updated,
                stems: newStems,
                groupName: "Multitrack 1",
                startTime: startTime ?? 0
            )
        }

        let resolvedGroupIndex = min(max(0, groupIndex), updated.groups.count - 1)
        let group = updated.groups[resolvedGroupIndex]
        let clipStart = startTime ?? group.horizontalOffset

        let newTracks = buildTracks(
            from: newStems,
            group: TrackGroup(
                id: group.id,
                name: group.name,
                importedAt: group.importedAt,
                horizontalOffset: clipStart,
                pitchSemitones: group.pitchSemitones,
                volume: group.volume
            ),
            groupIndex: resolvedGroupIndex
        )

        let insertIndex = insertionIndexAfterGroup(resolvedGroupIndex, in: updated.tracks)
        updated.tracks = insertTracksIntoGroup(
            existing: updated.tracks,
            incoming: newTracks,
            groupIndex: resolvedGroupIndex,
            startingAt: insertIndex
        )
        TrackColorPalette.ensureDistinctColors(on: &updated.tracks)
        return updated
    }

    func insertionIndexAfterGroup(_ groupIndex: Int, in tracks: [AudioTrack]) -> Int {
        var lastIndex = -1
        for (index, track) in tracks.enumerated() {
            if track.clips.contains(where: { $0.groupIndex == groupIndex }) {
                lastIndex = index
            }
        }
        return lastIndex + 1
    }

    private func insertTracksIntoGroup(
        existing: [AudioTrack],
        incoming: [AudioTrack],
        groupIndex: Int,
        startingAt insertIndex: Int
    ) -> [AudioTrack] {
        var merged = existing
        var nextInsert = min(max(0, insertIndex), merged.count)

        for track in incoming {
            if let index = merged.firstIndex(where: { existingTrack in
                existingTrack.standardCode == track.standardCode
                    && existingTrack.role == track.role
                    && existingTrack.clips.contains { $0.groupIndex == groupIndex }
            }) {
                merged[index].clips.append(contentsOf: track.clips)
                merged[index].clips.sort { $0.startTime < $1.startTime }
            } else {
                merged.insert(track, at: min(nextInsert, merged.count))
                nextInsert += 1
            }
        }

        return sortTracksPreservingGroupBlocks(merged)
    }

    /// Keeps group blocks intact while sorting lanes inside each block.
    private func sortTracksPreservingGroupBlocks(_ tracks: [AudioTrack]) -> [AudioTrack] {
        var grouped: [Int: [AudioTrack]] = [:]
        var orphanTracks: [AudioTrack] = []

        for track in tracks {
            if let groupIndex = track.clips.first?.groupIndex {
                grouped[groupIndex, default: []].append(track)
            } else {
                orphanTracks.append(track)
            }
        }

        var ordered: [AudioTrack] = []
        for groupIndex in grouped.keys.sorted() {
            ordered.append(contentsOf: sortTracks(grouped[groupIndex] ?? []))
        }
        ordered.append(contentsOf: sortTracks(orphanTracks))
        return ordered
    }

    func importInitial(
        project: DAWProject,
        stems: [ImportedStem],
        groupName: String,
        startTime: TimeInterval = 0
    ) -> DAWProject {
        var updated = project
        let group = TrackGroup(name: groupName, horizontalOffset: startTime)
        updated.groups = [group]
        updated.tracks = buildTracks(from: stems, group: group, groupIndex: 0)
        updated.tracks = sortTracks(updated.tracks)
        TrackColorPalette.assignDistinctColors(to: &updated.tracks)
        return updated
    }

    func sortTracks(_ tracks: [AudioTrack]) -> [AudioTrack] {
        tracks.sorted { lhs, rhs in
            if lhs.role.sortPriority != rhs.role.sortPriority {
                return lhs.role.sortPriority < rhs.role.sortPriority
            }
            if lhs.standardCode != rhs.standardCode {
                return lhs.standardCode < rhs.standardCode
            }
            return lhs.originalName.localizedCaseInsensitiveCompare(rhs.originalName) == .orderedAscending
        }
    }

    /// Aligns tracks from multiple groups side-by-side by standard code / role.
    private func mergeTracks(existing: [AudioTrack], incoming: [AudioTrack]) -> [AudioTrack] {
        var merged = existing

        for track in incoming {
            if let index = merged.firstIndex(where: {
                $0.standardCode == track.standardCode && $0.role == track.role
            }) {
                merged[index].clips.append(contentsOf: track.clips)
                merged[index].clips.sort { $0.startTime < $1.startTime }
            } else {
                merged.append(track)
            }
        }

        return sortTracks(merged)
    }
}
