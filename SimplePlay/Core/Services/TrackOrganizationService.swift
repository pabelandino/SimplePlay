//
//  TrackOrganizationService.swift
//  SimplePlay
//

import Foundation

/// Imports multitrack folders/files and organizes tracks with smart grouping and ordering.
struct TrackOrganizationService: Sendable {
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
        var updated = project
        let groupIndex = updated.groups.count
        let maxEndTime = updated.duration
        let resolvedStart = startTime ?? (maxEndTime > 0 ? maxEndTime : 0)
        let newGroup = TrackGroup(name: groupName, horizontalOffset: resolvedStart)
        updated.groups.append(newGroup)

        let newTracks = buildTracks(from: newStems, group: newGroup, groupIndex: groupIndex)
        updated.tracks = mergeTracks(existing: updated.tracks, incoming: newTracks)
        return updated
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
