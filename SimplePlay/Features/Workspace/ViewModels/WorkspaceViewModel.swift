//
//  WorkspaceViewModel.swift
//  SimplePlay
//

import Foundation
import Observation
import SwiftUI

@MainActor
@Observable
final class WorkspaceViewModel {
    var project = DAWProject(name: "Designing to Digital")
    var playheadTime: TimeInterval = 0
    var zoom: Double = 1.0
    var selectedClipID: UUID?
    var selectedSectionID: UUID?
    var selectionRange: ClosedRange<TimeInterval>?
    var isPlaying = false
    var errorMessage: String?
    var showImportPanel = false
    var showOpenProjectPanel = false
    var showSaveProjectPanel = false
    var projectFileDocument: SimplePlayProjectFileDocument?
    var currentProjectURL: URL?
    var isDropTargeted = false
    var isPropertiesSidebarVisible = true
    var propertiesSidebarWidth: CGFloat = DAWTheme.propertiesDefaultWidth
    var selectedClipIDs: Set<UUID> = []
    var timelineViewportWidth: CGFloat = 800
    var availableOutputDevices: [AudioOutputDevice] = AudioDeviceService.listOutputDevices()
    var draggingTrackID: UUID?
    private(set) var trackDragTranslation: CGFloat = 0
    private(set) var trackDropIndicatorIndex: Int?

    let audioEngine = AudioEngineService()
    let arrangementEngine = ArrangementPlaybackEngine()
    let midiOutput = MIDIOutputService.shared

    private let importService = AudioImportService()
    private let organizationService = TrackOrganizationService()
    private let projectPersistence = ProjectPersistenceService()
    private var playbackTimer: Timer?

    var pixelsPerSecond: CGFloat {
        DAWTheme.pixelsPerSecond * zoom
    }

    var formattedCurrentTime: String {
        TimeFormatting.format(playheadTime)
    }

    var formattedDuration: String {
        TimeFormatting.format(project.duration)
    }

    var timelineContentWidth: CGFloat {
        max(800, CGFloat(project.duration + 30) * pixelsPerSecond)
    }

    func importMultitrack(
        urls: [URL],
        startTime: TimeInterval? = nil,
        groupName: String? = nil
    ) {
        do {
            let stems = try importService.loadStems(from: urls, projectID: project.id)
            let resolvedStart = resolveImportStartTime(startTime)
            if project.tracks.isEmpty {
                project = organizationService.importInitial(
                    project: project,
                    stems: stems,
                    groupName: groupName ?? "Multitrack 1",
                    startTime: resolvedStart
                )
            } else {
                project = organizationService.merge(
                    project: project,
                    newStems: stems,
                    groupName: groupName ?? "Multitrack \(project.groups.count + 1)",
                    startTime: startTime == nil ? nil : resolvedStart
                )
            }
            arrangementEngine.configure(sections: project.sections)
            try audioEngine.configure(project: project)
            audioEngine.masterVolume = project.masterVolume
            WaveformLoadMonitor.shared.reset()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func saveProject() {
        do {
#if os(macOS)
            if let currentProjectURL {
                try projectPersistence.save(document: makeSavedDocument(), to: currentProjectURL)
                return
            }

            guard let url = ProjectFilePanel.chooseSaveURL(defaultName: project.name) else { return }
            try projectPersistence.save(document: makeSavedDocument(), to: url)
            currentProjectURL = url
#else
            projectFileDocument = SimplePlayProjectFileDocument(
                data: try projectPersistence.exportData(document: makeSavedDocument())
            )
            showSaveProjectPanel = true
#endif
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func saveProjectAs() {
        do {
#if os(macOS)
            guard let url = ProjectFilePanel.chooseSaveURL(defaultName: project.name) else { return }
            try projectPersistence.save(document: makeSavedDocument(), to: url)
            currentProjectURL = url
#else
            projectFileDocument = SimplePlayProjectFileDocument(
                data: try projectPersistence.exportData(document: makeSavedDocument())
            )
            showSaveProjectPanel = true
#endif
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func openProject() {
#if os(macOS)
        guard let url = ProjectFilePanel.chooseOpenURL() else { return }
        loadProject(from: url)
#else
        showOpenProjectPanel = true
#endif
    }

    func handleProjectSaveResult(_ result: Result<URL, Error>) {
        switch result {
        case .success(let url):
            currentProjectURL = url
        case .failure(let error):
            errorMessage = error.localizedDescription
        }
    }

    func loadProject(from url: URL) {
        beginAccessIfNeeded(for: url)

        do {
            let resolvedURL = normalizedProjectURL(url)
            let document = try projectPersistence.load(from: resolvedURL)
            applyLoadedProject(document)
            currentProjectURL = resolvedURL
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func normalizedProjectURL(_ url: URL) -> URL {
        if url.pathExtension.isEmpty {
            let withExtension = url.appendingPathExtension(ProjectPersistenceService.packageExtension)
            if FileManager.default.fileExists(atPath: withExtension.path) {
                return withExtension
            }
        }
        return url
    }

    private func makeSavedDocument() -> SavedProjectDocument {
        SavedProjectDocument(
            project: project,
            workspace: .init(
                playheadTime: playheadTime,
                zoom: zoom,
                isPropertiesSidebarVisible: isPropertiesSidebarVisible,
                propertiesSidebarWidth: Double(propertiesSidebarWidth)
            )
        )
    }

    private func applyLoadedProject(_ document: SavedProjectDocument) {
        stop()
        WaveformLoadMonitor.shared.reset()

        project = document.project
        playheadTime = document.workspace.playheadTime
        zoom = document.workspace.zoom
        isPropertiesSidebarVisible = document.workspace.isPropertiesSidebarVisible
        propertiesSidebarWidth = CGFloat(document.workspace.propertiesSidebarWidth)
        selectedClipIDs.removeAll()
        selectedSectionID = nil
        selectionRange = nil

        arrangementEngine.configure(sections: project.sections)
        arrangementEngine.seek(to: playheadTime)

        do {
            try audioEngine.configure(project: project)
            audioEngine.masterVolume = project.masterVolume
            applyAudioSettings()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func importMultitrackFolder(
        _ folderURL: URL,
        startTime: TimeInterval? = nil,
        groupName: String? = nil
    ) {
        do {
            let stems = try importService.loadStemsFromFolder(folderURL, projectID: project.id)
            importMultitrack(
                urls: stems.map(\.url),
                startTime: startTime,
                groupName: groupName ?? folderURL.lastPathComponent
            )
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func importDroppedItems(urls: [URL], startTime: TimeInterval? = nil) {
        var fileURLs: [URL] = []
        let resolvedStart = startTime.map {
            SnapGrid.snap($0, interval: project.snapInterval, enabled: project.isSnapEnabled)
        }

        for url in urls {
            beginAccessIfNeeded(for: url)

            var isDirectory: ObjCBool = false
            guard FileManager.default.fileExists(atPath: url.path, isDirectory: &isDirectory) else {
                continue
            }

            if isDirectory.boolValue {
                importMultitrackFolder(
                    url,
                    startTime: resolvedStart,
                    groupName: url.lastPathComponent
                )
            } else if SupportedAudioFormats.isSupported(url: url) {
                fileURLs.append(url)
            }
        }

        if !fileURLs.isEmpty {
            importMultitrack(
                urls: fileURLs,
                startTime: resolvedStart,
                groupName: "Dropped Files"
            )
        }
    }

    private func resolveImportStartTime(_ startTime: TimeInterval?) -> TimeInterval {
        let fallback = project.tracks.isEmpty ? 0 : project.duration
        let raw = startTime ?? fallback
        return SnapGrid.snap(raw, interval: project.snapInterval, enabled: project.isSnapEnabled)
    }

    func beginAccessIfNeeded(for url: URL) {
        _ = url.startAccessingSecurityScopedResource()
    }

    func setZoom(_ value: Double) {
        zoom = min(DAWTheme.maxZoom, max(DAWTheme.minZoom, value))
    }

    func adjustZoom(by factor: Double) {
        setZoom(zoom * factor)
    }

    func zoomToFitTimeline() {
        guard project.duration > 0 else { return }
        let availableWidth = max(400, timelineViewportWidth - 32)
        let fitZoom = Double(availableWidth / (CGFloat(project.duration) * DAWTheme.pixelsPerSecond))
        setZoom(fitZoom)
    }

    func updateTimelineViewportWidth(_ width: CGFloat) {
        timelineViewportWidth = width
    }

    func toggleMute(trackID: UUID) {
        guard let index = project.tracks.firstIndex(where: { $0.id == trackID }) else { return }
        project.tracks[index].isMuted.toggle()
        audioEngine.updateTrackMixing(project: project)
    }

    func toggleSolo(trackID: UUID) {
        guard let index = project.tracks.firstIndex(where: { $0.id == trackID }) else { return }
        project.tracks[index].isSolo.toggle()
        audioEngine.updateTrackMixing(project: project)
    }

    func setPan(trackID: UUID, pan: Double) {
        guard let index = project.tracks.firstIndex(where: { $0.id == trackID }) else { return }
        project.tracks[index].pan = min(1, max(-1, pan))
        audioEngine.updateTrackMixing(project: project)
    }

    func applyAudioSettings() {
        do {
            try audioEngine.apply(settings: project.audioSettings)
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func refreshAudioDevices() {
        availableOutputDevices = AudioDeviceService.listOutputDevices()
    }

    func handleClipTap(_ clipID: UUID, extendSelection: Bool) {
        if extendSelection {
            if selectedClipIDs.contains(clipID) {
                selectedClipIDs.remove(clipID)
            } else {
                selectedClipIDs.insert(clipID)
            }
        } else {
            selectedClipIDs = [clipID]
        }
    }

    func selectAllClips() {
        selectedClipIDs = Set(project.tracks.flatMap { track in
            track.clips.map(\.id)
        })
    }

    func clearClipSelection() {
        selectedClipIDs.removeAll()
    }

    func clearTimelineSelection() {
        selectionRange = nil
    }

    func trackDragVisualOffset(for trackID: UUID) -> CGFloat {
        draggingTrackID == trackID ? trackDragTranslation : 0
    }

    func showsTrackDropIndicator(at index: Int) -> Bool {
        trackDropIndicatorIndex == index
    }

    func beginTrackDrag(trackID: UUID) {
        if draggingTrackID == nil {
            clearTimelineSelection()
            clearClipSelection()
        }
        draggingTrackID = trackID
    }

    func updateTrackDrag(trackID: UUID, translation: CGFloat) {
        guard draggingTrackID == trackID,
              let sourceIndex = project.tracks.firstIndex(where: { $0.id == trackID })
        else { return }

        trackDragTranslation = translation
        let deltaRows = Int((translation / DAWTheme.trackRowHeight).rounded())
        let destination = min(max(0, sourceIndex + deltaRows), project.tracks.count - 1)
        trackDropIndicatorIndex = destination
    }

    func endTrackDrag(trackID: UUID) {
        defer {
            draggingTrackID = nil
            trackDragTranslation = 0
            trackDropIndicatorIndex = nil
        }

        guard let sourceIndex = project.tracks.firstIndex(where: { $0.id == trackID }),
              let destination = trackDropIndicatorIndex,
              sourceIndex != destination
        else { return }

        moveTrack(from: sourceIndex, to: destination)
    }

    func isClipSelected(_ clipID: UUID) -> Bool {
        selectedClipIDs.contains(clipID)
    }

    func selectClipsIntersecting(range: ClosedRange<TimeInterval>) {
        let matching = project.tracks.flatMap { track in
            track.clips.filter { clip in
                clip.startTime <= range.upperBound && clip.endTime >= range.lowerBound
            }.map(\.id)
        }
        if !matching.isEmpty {
            selectedClipIDs = Set(matching)
        }
    }

    func moveClips(anchorTimes: [UUID: TimeInterval], delta: TimeInterval) {
        for trackIndex in project.tracks.indices {
            for clipIndex in project.tracks[trackIndex].clips.indices {
                let clipID = project.tracks[trackIndex].clips[clipIndex].id
                guard let anchor = anchorTimes[clipID] else { continue }

                let snapped = SnapGrid.snap(
                    anchor + delta,
                    interval: project.snapInterval,
                    enabled: project.isSnapEnabled
                )
                project.tracks[trackIndex].clips[clipIndex].startTime = max(0, snapped)
            }
        }
    }

    func moveClip(trackID: UUID, clipID: UUID, newStartTime: TimeInterval) {
        guard let trackIndex = project.tracks.firstIndex(where: { $0.id == trackID }),
              let clipIndex = project.tracks[trackIndex].clips.firstIndex(where: { $0.id == clipID })
        else { return }

        let snapped = SnapGrid.snap(newStartTime, interval: project.snapInterval, enabled: project.isSnapEnabled)
        project.tracks[trackIndex].clips[clipIndex].startTime = max(0, snapped)
    }

    private func moveTrack(from source: Int, to destination: Int) {
        guard source != destination,
              project.tracks.indices.contains(source),
              project.tracks.indices.contains(destination)
        else { return }

        let track = project.tracks.remove(at: source)
        project.tracks.insert(track, at: destination)
    }

    func addSection(name: String, range: ClosedRange<TimeInterval>, mode: SectionPlaybackMode) {
        let note = UInt8(60 + project.sections.count)
        let section = ArrangementSection(
            name: name,
            startTime: range.lowerBound,
            endTime: range.upperBound,
            midiNote: note,
            playbackMode: mode
        )
        project.sections.append(section)
        arrangementEngine.configure(sections: project.sections)
    }

    func triggerSection(_ section: ArrangementSection) {
        arrangementEngine.triggerSection(midiNote: section.midiNote, channel: section.midiChannel)
        midiOutput.sendSectionTrigger(section)
    }

    func togglePlayback() {
        if isPlaying {
            pause()
        } else {
            play()
        }
    }

    func play() {
        isPlaying = true
        arrangementEngine.seek(to: playheadTime)
        arrangementEngine.play()
        audioEngine.play(from: playheadTime, project: project)
        startPlaybackTimer()
    }

    func pause() {
        isPlaying = false
        audioEngine.pause()
        arrangementEngine.pause()
        stopPlaybackTimer()
    }

    func stop() {
        isPlaying = false
        playheadTime = 0
        audioEngine.stop()
        arrangementEngine.stop()
        stopPlaybackTimer()
    }

    func seek(to time: TimeInterval) {
        let clamped = max(0, time)
        playheadTime = project.duration > 0 ? min(clamped, project.duration) : clamped
        arrangementEngine.seek(to: playheadTime)

        if isPlaying {
            audioEngine.play(from: playheadTime, project: project)
        }
    }

    private func startPlaybackTimer() {
        stopPlaybackTimer()

        let timer = Timer(timeInterval: 1.0 / 60.0, repeats: true) { [weak self] _ in
            guard let self else { return }
            self.tickPlayback()
        }
        playbackTimer = timer
        RunLoop.main.add(timer, forMode: .common)
    }

    private func stopPlaybackTimer() {
        playbackTimer?.invalidate()
        playbackTimer = nil
    }

    private func tickPlayback() {
        arrangementEngine.tick(delta: 1.0 / 60.0, projectDuration: project.duration)
        playheadTime = arrangementEngine.currentTime

        if playheadTime >= project.duration, project.duration > 0 {
            pause()
            return
        }

        if !arrangementEngine.isPlaying {
            pause()
        }
    }
}
