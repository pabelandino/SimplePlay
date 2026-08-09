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
    var isSelectionLoopEnabled = false
    var timelineTool: TimelineEditTool = .hand
    var isPlaying = false
    var errorMessage: String?
    var showImportPanel = false
    var importPanelKind: ImportPanelKind = .audioFiles

    enum ImportPanelKind {
        case audioFiles
        case folder
    }
    var showOpenProjectPanel = false
    var showSaveProjectPanel = false
    var projectFileDocument: SimplePlayProjectFileDocument?
    var currentProjectURL: URL?
    var isDropTargeted = false
    var importNoticeMessage: String?
    var showSettings = false
    var showMixerPanel = false
    var showResetSessionConfirmation = false
    var showNewProjectConfirmation = false
    var pendingNewProjectAfterSave = false
    var pendingImportPlacement: TrackOrganizationService.ImportPlacement = .appendNewGroup(startTime: nil)
    var propertiesSidebarWidth: CGFloat = DAWTheme.propertiesDefaultWidth
    var selectedClipIDs: Set<UUID> = []
    var selectedTrackIDForPitch: UUID?
    var selectedGroupID: UUID?
    var timelineViewportWidth: CGFloat = 800
    var timelineVisibleOffsetX: CGFloat = 0
    private(set) var timelineScrollRequest: TimelineScrollRequest?
    var availableOutputDevices: [AudioOutputDevice] = AudioDeviceService.listOutputDevices()
    var draggingTrackID: UUID?
    var draggingSectionID: UUID?
    private(set) var trackDragTranslation: CGFloat = 0
    private(set) var trackDropIndicatorIndex: Int?
    private var sectionDragKind: SectionDragKind = .move

    enum SectionDragKind {
        case move
        case resizeStart
        case resizeEnd
    }

    struct TimelineScrollRequest: Equatable {
        let id: UUID
        let offsetX: CGFloat
    }

    enum TimelineScrollAlignment {
        case start
        case center
        case leading
    }

    var isSectionInteractionActive: Bool {
        draggingSectionID != nil
    }

    var isSectionRepeatEnabled: Bool {
        arrangementEngine.isRepeatEnabled
    }

    var queuedSectionName: String? {
        arrangementEngine.pendingSection?.name
    }

    var sectionCreationPreview: ClosedRange<TimeInterval>?
    var preferredMarkerPreset: String = "Verse"
    private var sectionCreationStartTime: TimeInterval?

    var midiLearnTarget: MIDILearnTarget?
    var midiLearnStatusMessage: String?
    var availableMIDISources: [MIDISourceInfo] = []
    var connectedMIDISourceName: String?
    var isMIDIMappingExpanded = false

    let audioEngine = AudioEngineService()
    let arrangementEngine = ArrangementPlaybackEngine()
    let midiOutput = MIDIOutputService.shared

    private let importService = AudioImportService()
    private let organizationService = TrackOrganizationService()
    private let projectPersistence = ProjectPersistenceService()
    private var playbackTimer: Timer?
    private var playheadPublishAccumulator: TimeInterval = 0
    private let playbackTickInterval: TimeInterval = 1.0 / 30.0
    private let playheadPublishInterval: TimeInterval = 1.0 / 15.0

    init() {
        MIDIInputService.shared.onNoteOn = { [weak self] note, channel in
            self?.handleIncomingMIDINote(note: note, channel: channel)
        }
        refreshMIDIDevices()
        applySavedMIDIDeviceConnection()
    }

    var isMIDILearnActive: Bool {
        midiLearnTarget != nil
    }

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
        let scaledWidth = CGFloat(project.duration + DAWTheme.timelineTailPaddingSeconds) * pixelsPerSecond
        if project.duration <= 0 {
            return max(DAWTheme.emptyTimelineMinimumWidth, scaledWidth)
        }
        return scaledWidth
    }

    /// Lowest zoom that keeps the entire timeline visible without horizontal scrolling.
    var minimumTimelineZoom: Double {
        guard project.duration > 0, timelineViewportWidth > DAWTheme.timelineZoomHorizontalInset else {
            return DAWTheme.absoluteMinZoom
        }

        let availableWidth = timelineViewportWidth - DAWTheme.timelineZoomHorizontalInset
        let fitZoom = Double(
            availableWidth / (CGFloat(project.duration + DAWTheme.timelineTailPaddingSeconds) * DAWTheme.pixelsPerSecond)
        )
        return min(DAWTheme.maxZoom, max(DAWTheme.absoluteMinZoom, fitZoom))
    }

    func importMultitrack(
        urls: [URL],
        startTime: TimeInterval? = nil,
        groupName: String? = nil,
        placement: TrackOrganizationService.ImportPlacement? = nil
    ) {
        do {
            let result = try importService.loadStems(from: urls, projectID: project.id)
            if let notice = result.notice {
                importNoticeMessage = notice
            }
            applyImportedStems(
                result.stems,
                startTime: startTime,
                groupName: resolvedImportGroupName(explicit: groupName),
                placement: placement ?? pendingImportPlacement
            )
        } catch {
            reportError(error)
        }
    }

    func handleImportPickerResults(_ urls: [URL]) {
        guard !urls.isEmpty else { return }

        var audioFiles: [URL] = []
        var importedFolderCount = 0

        for url in urls {
            beginAccessIfNeeded(for: url)

            if url.hasDirectoryPath || isDirectoryURL(url) {
                importMultitrackFolder(
                    url,
                    groupName: url.lastPathComponent
                )
                importedFolderCount += 1
            } else if SupportedAudioFormats.isSupported(url: url) {
                audioFiles.append(url)
            }
        }

        if !audioFiles.isEmpty {
            importMultitrack(
                urls: audioFiles,
                groupName: "Imported Files",
                placement: pendingImportPlacement
            )
        } else if importedFolderCount == 0 {
            reportError("No supported audio files were found. Supported formats: \(SupportedAudioFormats.fileExtensions.sorted().joined(separator: ", ")).")
        }

        pendingImportPlacement = .appendNewGroup(startTime: nil)
    }

    func presentImportPanel(for kind: ImportPanelKind, placement: TrackOrganizationService.ImportPlacement = .appendNewGroup(startTime: nil)) {
        pendingImportPlacement = placement
        importPanelKind = kind
        showImportPanel = true
    }

    func presentAddTrackImport() {
        presentImportPanel(
            for: .audioFiles,
            placement: .insertIntoGroup(
                groupIndex: activeGroupIndex(),
                startTime: resolvedAddTrackStartTime()
            )
        )
    }

    private func isDirectoryURL(_ url: URL) -> Bool {
        (try? url.resourceValues(forKeys: [.isDirectoryKey]).isDirectory) == true
    }

    private func applyImportedStems(
        _ stems: [TrackOrganizationService.ImportedStem],
        startTime: TimeInterval?,
        groupName: String,
        placement: TrackOrganizationService.ImportPlacement
    ) {
        guard !stems.isEmpty else { return }

        if isPlaying {
            pause()
        }

        let resolvedStart = resolveImportStartTime(startTime)
        let resolvedPlacement: TrackOrganizationService.ImportPlacement = {
            switch placement {
            case .appendNewGroup:
                return .appendNewGroup(startTime: startTime == nil ? nil : resolvedStart)
            case .insertIntoGroup(let groupIndex, _):
                return .insertIntoGroup(
                    groupIndex: groupIndex,
                    startTime: resolvedAddTrackStartTime()
                )
            }
        }()

        if project.tracks.isEmpty {
            project = organizationService.importInitial(
                project: project,
                stems: stems,
                groupName: groupName,
                startTime: resolvedStart
            )
        } else {
            switch resolvedPlacement {
            case .insertIntoGroup:
                project = organizationService.importStems(
                    project: project,
                    newStems: stems,
                    groupName: activeGroupName(fallback: groupName),
                    placement: resolvedPlacement
                )
            case .appendNewGroup:
                project = organizationService.importStems(
                    project: project,
                    newStems: stems,
                    groupName: groupName,
                    placement: .appendNewGroup(startTime: startTime == nil ? nil : resolvedStart)
                )
            }
        }

        if case .insertIntoGroup(let groupIndex, _) = resolvedPlacement,
           project.groups.indices.contains(groupIndex) {
            selectedGroupID = project.groups[groupIndex].id
        }

        arrangementEngine.configure(sections: project.sections)
        configureAudioEngine()
        WaveformLoadMonitor.shared.reset()
        clampZoomToTimelineLimits()
    }

    private func clampZoomToTimelineLimits() {
        guard project.duration > 0, zoom < minimumTimelineZoom else { return }
        zoom = minimumTimelineZoom
    }

    func requestResetSession() {
        showResetSessionConfirmation = true
    }

    func requestNewProject() {
        showNewProjectConfirmation = true
    }

    func performResetSession() {
        replaceProject(with: makeEmptyProject())
    }

    func createNewProject(saveCurrent: Bool) {
        if saveCurrent {
            if canSaveDirectlyToCurrentURL {
                saveProject()
                performResetSession()
            } else {
                pendingNewProjectAfterSave = true
                saveProject()
            }
        } else {
            performResetSession()
        }
    }

    private var canSaveDirectlyToCurrentURL: Bool {
#if os(macOS)
        currentProjectURL != nil
#else
        false
#endif
    }

    private func makeEmptyProject() -> DAWProject {
        DAWProject(name: "Untitled Project")
    }

    private func replaceProject(with newProject: DAWProject) {
        stop()
        WaveformLoadMonitor.shared.reset()

        project = newProject
        playheadTime = 0
        zoom = 1.0
        currentProjectURL = nil
        projectFileDocument = nil
        selectedClipIDs.removeAll()
        selectedSectionID = nil
        selectedTrackIDForPitch = nil
        selectedGroupID = nil
        selectionRange = nil
        isSelectionLoopEnabled = false
        showMixerPanel = false
        midiLearnTarget = nil
        midiLearnStatusMessage = nil
        pendingImportPlacement = .appendNewGroup(startTime: nil)

        arrangementEngine.configure(sections: [])
        arrangementEngine.seek(to: 0)
        configureAudioEngine()
        applySavedMIDIDeviceConnection()
    }

    func activeGroupIndex() -> Int {
        if let selectedGroupID,
           let index = project.groups.firstIndex(where: { $0.id == selectedGroupID }) {
            return index
        }

        if selectedClipIDs.count == 1,
           let clipID = selectedClipIDs.first,
           let clip = clip(id: clipID),
           project.groups.indices.contains(clip.groupIndex) {
            return clip.groupIndex
        }

        if let selectedTrackIDForPitch,
           let track = project.tracks.first(where: { $0.id == selectedTrackIDForPitch }),
           let groupIndex = track.clips.first?.groupIndex,
           project.groups.indices.contains(groupIndex) {
            return groupIndex
        }

        return max(0, project.groups.count - 1)
    }

    private func activeGroupName(fallback: String) -> String {
        let index = activeGroupIndex()
        guard project.groups.indices.contains(index) else { return fallback }
        return project.groups[index].name
    }

    private func resolvedAddTrackStartTime() -> TimeInterval {
        let groupIndex = activeGroupIndex()
        guard project.groups.indices.contains(groupIndex) else {
            return SnapGrid.snap(
                playheadTime,
                interval: project.snapInterval,
                enabled: project.isSnapEnabled
            )
        }

        let groupStart = project.groups[groupIndex].horizontalOffset
        let snappedPlayhead = SnapGrid.snap(
            playheadTime,
            interval: project.snapInterval,
            enabled: project.isSnapEnabled
        )
        return max(groupStart, snappedPlayhead)
    }

    private func reportError(_ error: Error) {
        errorMessage = error.localizedDescription
    }

    private func reportError(_ message: String) {
        errorMessage = message
    }

    @discardableResult
    private func configureAudioEngine() -> Bool {
        do {
            try audioEngine.configure(project: project)
            audioEngine.masterVolume = project.masterVolume
            if !audioEngine.configurationWarnings.isEmpty {
                importNoticeMessage = audioEngine.configurationWarnings.joined(separator: "\n")
            }
            return true
        } catch {
            reportError(error)
            return false
        }
    }

    @discardableResult
    private func startAudioPlayback(from time: TimeInterval) -> Bool {
        guard !project.tracks.isEmpty else {
            reportError("No tracks are loaded.")
            return false
        }

        if !audioEngine.isPlaybackGraphReady {
            guard configureAudioEngine() else { return false }
        }

        if attemptAudioPlayback(from: time) {
            return true
        }

        guard configureAudioEngine(), attemptAudioPlayback(from: time) else {
            return false
        }

        return true
    }

    private func attemptAudioPlayback(from time: TimeInterval) -> Bool {
        let started = audioEngine.play(from: time, project: project)
        if !started, let playbackError = audioEngine.lastPlaybackError {
            reportError(playbackError)
        } else if !started {
            reportError("Could not start audio playback.")
        }
        return started
    }

    private func resolvedImportGroupName(explicit groupName: String?) -> String {
        if let groupName, !groupName.isEmpty {
            return groupName
        }
        if project.tracks.isEmpty {
            return "Multitrack 1"
        }
        return "Multitrack \(project.groups.count + 1)"
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
            if pendingNewProjectAfterSave {
                pendingNewProjectAfterSave = false
                performResetSession()
            }
        case .failure(let error):
            pendingNewProjectAfterSave = false
            reportError(error)
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
                isPropertiesSidebarVisible: false,
                propertiesSidebarWidth: Double(propertiesSidebarWidth)
            )
        )
    }

    private func applyLoadedProject(_ document: SavedProjectDocument) {
        stop()
        WaveformLoadMonitor.shared.reset()

        project = document.project
        SectionMarkerPalette.ensureDistinctColors(on: &project.sections)
        applySavedMIDIDeviceConnection()
        playheadTime = document.workspace.playheadTime
        zoom = document.workspace.zoom
        propertiesSidebarWidth = CGFloat(document.workspace.propertiesSidebarWidth)
        selectedClipIDs.removeAll()
        selectedSectionID = nil
        selectionRange = nil

        arrangementEngine.configure(sections: project.sections)
        arrangementEngine.seek(to: playheadTime)

        if configureAudioEngine() {
            applyAudioSettings()
        }
        clampZoomToTimelineLimits()
    }

    func importMultitrackFolder(
        _ folderURL: URL,
        startTime: TimeInterval? = nil,
        groupName: String? = nil,
        placement: TrackOrganizationService.ImportPlacement? = nil
    ) {
        do {
            let result = try importService.loadStemsFromFolder(folderURL, projectID: project.id)
            if let notice = result.notice {
                importNoticeMessage = notice
            }
            applyImportedStems(
                result.stems,
                startTime: startTime,
                groupName: groupName ?? folderURL.lastPathComponent,
                placement: placement ?? pendingImportPlacement
            )
        } catch {
            reportError(error)
        }
    }

    func importDroppedItems(urls: [URL], startTime: TimeInterval? = nil) {
        var fileURLs: [URL] = []
        let resolvedStart = startTime.map {
            SnapGrid.snap($0, interval: project.snapInterval, enabled: project.isSnapEnabled)
        }

        for url in urls {
            beginAccessIfNeeded(for: url)

            if url.hasDirectoryPath || isDirectoryURL(url) {
                importMultitrackFolder(
                    url,
                    startTime: resolvedStart,
                    groupName: url.lastPathComponent,
                    placement: .appendNewGroup(startTime: resolvedStart)
                )
            } else if SupportedAudioFormats.isSupported(url: url) {
                fileURLs.append(url)
            }
        }

        if !fileURLs.isEmpty {
            importMultitrack(
                urls: fileURLs,
                startTime: resolvedStart,
                groupName: "Dropped Files",
                placement: .appendNewGroup(startTime: resolvedStart)
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
        zoom = min(DAWTheme.maxZoom, max(minimumTimelineZoom, value))
    }

    func adjustZoom(by factor: Double) {
        setZoom(zoom * factor)
    }

    func zoomOutOneStep() {
        let target = zoom * 0.85
        if target <= minimumTimelineZoom {
            zoomToFitTimeline()
        } else {
            setZoom(target)
        }
    }

    func zoomInOneStep() {
        adjustZoom(by: 1.15)
    }

    func zoomToFitTimeline() {
        guard project.duration > 0 else { return }
        setZoom(minimumTimelineZoom)
    }

    func updateTimelineViewportWidth(_ width: CGFloat) {
        timelineViewportWidth = width
        if project.duration > 0, zoom < minimumTimelineZoom {
            zoom = minimumTimelineZoom
        }
    }

    func updateTimelineVisibleOffset(_ offset: CGFloat) {
        timelineVisibleOffsetX = max(0, offset)
    }

    func scrollTimelineToPlayhead(alignment: TimelineScrollAlignment = .center) {
        let playheadX = CGFloat(playheadTime) * pixelsPerSecond
        let viewport = max(1, timelineViewportWidth)
        let maxOffset = max(0, timelineContentWidth - viewport)

        let target: CGFloat
        switch alignment {
        case .start:
            target = 0
        case .center:
            target = min(maxOffset, max(0, playheadX - viewport * 0.5))
        case .leading:
            target = min(maxOffset, max(0, playheadX - viewport * 0.12))
        }

        requestTimelineScroll(offsetX: target)
    }

    func scrollTimelineToStart() {
        requestTimelineScroll(offsetX: 0)
    }

    private func requestTimelineScroll(offsetX: CGFloat) {
        let viewport = max(1, timelineViewportWidth)
        let maxOffset = max(0, timelineContentWidth - viewport)
        timelineScrollRequest = TimelineScrollRequest(
            id: UUID(),
            offsetX: min(max(0, offsetX), maxOffset)
        )
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

    func setTrackVolume(trackID: UUID, volume: Double) {
        guard let index = project.tracks.firstIndex(where: { $0.id == trackID }) else { return }
        project.tracks[index].volume = TrackVolumeSettings.clamp(volume)
        audioEngine.updateTrackMixing(project: project)
    }

    func setMasterVolume(_ volume: Double) {
        project.masterVolume = min(1, max(0, volume))
        audioEngine.masterVolume = project.masterVolume
    }

    func setGroupVolume(groupID: UUID, volume: Double) {
        guard let index = project.groups.firstIndex(where: { $0.id == groupID }) else { return }
        project.groups[index].volume = TrackVolumeSettings.clamp(volume)
        audioEngine.updateTrackMixing(project: project)
    }

    func tracks(forGroupIndex index: Int) -> [AudioTrack] {
        project.tracks(forGroupIndex: index)
    }

    func trackMeterLevel(for trackID: UUID) -> Float {
        audioEngine.meterLevel(for: trackID)
    }

    func groupMeterLevel(for groupID: UUID) -> Float {
        audioEngine.meterLevel(forGroupID: groupID)
    }

    var masterMeterLevel: Float {
        audioEngine.masterMeterLevel
    }

    func isTrackAudibleAtPlayhead(_ trackID: UUID) -> Bool {
        guard isPlaying else { return false }
        guard let track = project.tracks.first(where: { $0.id == trackID }) else { return false }

        let hasSolo = project.tracks.contains(where: \.isSolo)
        if track.isMuted || (hasSolo && !track.isSolo) { return false }

        return track.clips.contains { clip in
            playheadTime >= clip.startTime && playheadTime < clip.endTime
        }
    }

    func applyAudioSettings() {
        do {
            try audioEngine.apply(settings: project.audioSettings)
        } catch {
            reportError(error)
        }
    }

    func refreshAudioDevices() {
        availableOutputDevices = AudioDeviceService.listOutputDevices()
    }

    var activePitchTrack: AudioTrack? {
        if let selectedTrackIDForPitch,
           let track = project.tracks.first(where: { $0.id == selectedTrackIDForPitch }) {
            return track
        }
        if selectedClipIDs.count == 1,
           let clipID = selectedClipIDs.first,
           let track = project.track(containing: clipID) {
            return track
        }
        return project.tracks.first
    }

    func setSelectedTrackPitch(_ semitones: Double) {
        guard let trackID = activePitchTrack?.id,
              let index = project.tracks.firstIndex(where: { $0.id == trackID })
        else { return }

        project.tracks[index].pitchSemitones = PitchShiftSettings.clampSemitones(semitones)
        audioEngine.updateTrackPitch(project: project)
        resyncPlaybackIfNeeded()
    }

    func resetSelectedTrackPitch() {
        setSelectedTrackPitch(0)
    }

    func toggleSelectionLoop() {
        guard selectionRange != nil else { return }
        isSelectionLoopEnabled.toggle()
    }

    private func syncSelectedTrackFromClipSelection() {
        guard selectedClipIDs.count == 1,
              let clipID = selectedClipIDs.first,
              let track = project.track(containing: clipID)
        else { return }

        selectedTrackIDForPitch = track.id
    }

    private func clip(id: UUID) -> AudioClip? {
        for track in project.tracks {
            if let clip = track.clips.first(where: { $0.id == id }) {
                return clip
            }
        }
        return nil
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
        syncSelectedTrackFromClipSelection()
        updateSelectionRangeFromClips()
    }

    private func syncSelectedGroupFromClipSelection() {
        guard selectedClipIDs.count == 1,
              let clipID = selectedClipIDs.first,
              let clip = clip(id: clipID),
              let group = project.group(containing: clip)
        else { return }

        selectedGroupID = group.id
    }

    private func resyncPlaybackIfNeeded() {
        guard isPlaying else { return }
        if !startAudioPlayback(from: playheadTime) {
            pause()
        }
    }

    func selectAllClips() {
        selectedClipIDs = Set(project.tracks.flatMap { track in
            track.clips.map(\.id)
        })
        updateSelectionRangeFromClips()
    }

    func clearClipSelection() {
        selectedClipIDs.removeAll()
        updateSelectionRangeFromClips()
    }

    func clearTimelineSelection() {
        selectionRange = nil
        isSelectionLoopEnabled = false
    }

    private func updateSelectionRangeFromClips() {
        guard !selectedClipIDs.isEmpty else {
            selectionRange = nil
            if isSelectionLoopEnabled {
                isSelectionLoopEnabled = false
            }
            return
        }

        var minStart = TimeInterval.greatestFiniteMagnitude
        var maxEnd: TimeInterval = 0

        for track in project.tracks {
            for clip in track.clips where selectedClipIDs.contains(clip.id) {
                minStart = min(minStart, clip.startTime)
                maxEnd = max(maxEnd, clip.endTime)
            }
        }

        if minStart <= maxEnd {
            selectionRange = minStart...maxEnd
        } else {
            selectionRange = nil
        }
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
        guard range.upperBound > range.lowerBound else { return }

        let note = UInt8(min(127, 60 + project.sections.count))
        let section = ArrangementSection(
            name: name,
            startTime: range.lowerBound,
            endTime: range.upperBound,
            colorHex: SectionMarkerPalette.nextDistinctHex(sections: project.sections, name: name),
            midiNote: note,
            playbackMode: mode
        )
        project.sections.append(section)
        selectedSectionID = section.id
        arrangementEngine.configure(sections: project.sections)
    }

    func beginSectionCreation(atX x: CGFloat) {
        guard draggingSectionID == nil else { return }

        let time = timeFromTimelineX(x)
        sectionCreationStartTime = time
        sectionCreationPreview = time...time
    }

    func updateSectionCreation(toX x: CGFloat) {
        guard let anchor = sectionCreationStartTime else { return }

        let end = timeFromTimelineX(x)
        sectionCreationPreview = min(anchor, end)...max(anchor, end)
    }

    func commitSectionCreation() {
        defer { cancelSectionCreation() }

        guard let preview = sectionCreationPreview else { return }

        let minimumDuration = max(project.snapInterval, 0.25)
        guard preview.upperBound - preview.lowerBound >= minimumDuration else { return }

        let snappedLower = SnapGrid.snap(
            preview.lowerBound,
            interval: project.snapInterval,
            enabled: project.isSnapEnabled
        )
        let snappedUpper = SnapGrid.snap(
            preview.upperBound,
            interval: project.snapInterval,
            enabled: project.isSnapEnabled
        )
        guard snappedUpper > snappedLower else { return }

        addSection(
            name: nextSectionMarkerName(),
            range: snappedLower...snappedUpper,
            mode: .repeatSection
        )
    }

    func cancelSectionCreation() {
        sectionCreationPreview = nil
        sectionCreationStartTime = nil
    }

    private func timeFromTimelineX(_ x: CGFloat) -> TimeInterval {
        max(0, TimeInterval(x / pixelsPerSecond))
    }

    private func nextSectionMarkerName() -> String {
        let preset = preferredMarkerPreset
        if !project.sections.contains(where: { $0.name == preset }) {
            return preset
        }

        var index = 2
        while project.sections.contains(where: { $0.name == "\(preset) \(index)" }) {
            index += 1
        }
        return "\(preset) \(index)"
    }

    func selectSection(_ sectionID: UUID) {
        selectedSectionID = sectionID
    }

    func renameSection(_ sectionID: UUID, name: String) {
        guard let index = project.sections.firstIndex(where: { $0.id == sectionID }) else { return }
        project.sections[index].name = name
        arrangementEngine.configure(sections: project.sections)
    }

    func beginSectionDrag(sectionID: UUID, kind: SectionDragKind) {
        guard draggingSectionID == nil else { return }

        draggingSectionID = sectionID
        sectionDragKind = kind
        selectedSectionID = sectionID
    }

    func commitSectionDrag(sectionID: UUID, kind: SectionDragKind, translation: CGFloat) {
        defer { clearSectionDragState() }

        guard let index = project.sections.firstIndex(where: { $0.id == sectionID }) else { return }

        let anchorStart = project.sections[index].startTime
        let anchorEnd = project.sections[index].endTime
        let delta = TimeInterval(translation / pixelsPerSecond)
        let minimumDuration: TimeInterval = max(project.snapInterval, 0.25)

        let finalStart: TimeInterval
        let finalEnd: TimeInterval

        switch kind {
        case .move:
            let duration = anchorEnd - anchorStart
            let rawStart = max(0, anchorStart + delta)
            finalStart = SnapGrid.snap(
                rawStart,
                interval: project.snapInterval,
                enabled: project.isSnapEnabled
            )
            finalEnd = finalStart + duration

        case .resizeStart:
            let rawStart = max(0, min(anchorEnd - minimumDuration, anchorStart + delta))
            finalStart = SnapGrid.snap(
                rawStart,
                interval: project.snapInterval,
                enabled: project.isSnapEnabled
            )
            finalEnd = anchorEnd

        case .resizeEnd:
            let rawEnd = max(anchorStart + minimumDuration, anchorEnd + delta)
            finalStart = anchorStart
            finalEnd = SnapGrid.snap(
                rawEnd,
                interval: project.snapInterval,
                enabled: project.isSnapEnabled
            )
        }

        project.sections[index].startTime = finalStart
        project.sections[index].endTime = finalEnd
        arrangementEngine.configure(sections: project.sections)
    }

    private func clearSectionDragState() {
        draggingSectionID = nil
        sectionDragKind = .move
    }

    func updateSectionMIDI(_ sectionID: UUID, note: UInt8, channel: UInt8) {
        guard let index = project.sections.firstIndex(where: { $0.id == sectionID }) else { return }
        project.sections[index].midiNote = min(127, note)
        project.sections[index].midiChannel = min(15, channel)
        arrangementEngine.configure(sections: project.sections)
    }

    func deleteSection(_ sectionID: UUID) {
        project.sections.removeAll { $0.id == sectionID }
        if selectedSectionID == sectionID {
            selectedSectionID = project.sections.first?.id
        }
        arrangementEngine.configure(sections: project.sections)
    }

    func toggleSectionRepeat() {
        setSectionRepeatEnabled(!arrangementEngine.isRepeatEnabled)
    }

    func setSectionRepeatEnabled(_ enabled: Bool) {
        arrangementEngine.setRepeatEnabled(enabled)
    }

    func triggerSection(_ section: ArrangementSection) {
        isSelectionLoopEnabled = false
        selectedSectionID = section.id

        arrangementEngine.triggerSection(section)
        midiOutput.sendSectionTrigger(section)

        if arrangementEngine.isRepeatEnabled,
           arrangementEngine.pendingSection?.id == section.id,
           case .playingSection(let current) = arrangementEngine.state,
           current.id != section.id {
            return
        }

        playheadTime = arrangementEngine.currentTime

        arrangementEngine.play()
        guard startAudioPlayback(from: playheadTime) else {
            arrangementEngine.pause()
            return
        }

        isPlaying = true
        startPlaybackTimer()
    }

    func handleIncomingMIDINote(note: UInt8, channel: UInt8) {
        if let target = midiLearnTarget {
            applyMIDILearn(note: note, channel: channel, target: target)
            midiLearnTarget = nil
            return
        }

        if note == project.sectionRepeatMIDINote,
           channel == project.sectionRepeatMIDIChannel {
            toggleSectionRepeat()
            return
        }

        guard let section = project.sections.first(where: {
            $0.midiNote == note && $0.midiChannel == channel
        }) else { return }

        triggerSection(section)
    }

    private func applyMIDILearn(note: UInt8, channel: UInt8, target: MIDILearnTarget) {
        switch target {
        case .section(let sectionID):
            updateSectionMIDI(sectionID, note: note, channel: channel)
            if let section = project.sections.first(where: { $0.id == sectionID }) {
                midiLearnStatusMessage = "Mapped “\(section.name)” → \(MIDINoteAssignment(note: note, channel: channel).displayName)"
            }
        case .loopToggle:
            project.sectionRepeatMIDINote = note
            project.sectionRepeatMIDIChannel = channel
            midiLearnStatusMessage = "Loop Repeat → \(MIDINoteAssignment(note: note, channel: channel).displayName)"
        }
    }

    func refreshMIDIDevices() {
        availableMIDISources = MIDIInputService.shared.availableSources()
        connectedMIDISourceName = MIDIInputService.shared.connectedSourceName
    }

    func selectMIDIDevice(_ source: MIDISourceInfo?) {
        if let source {
            project.preferredMIDISourceName = source.name
            project.preferredMIDISourceUniqueID = source.uniqueID
            _ = MIDIInputService.shared.connect(to: source)
        } else {
            project.preferredMIDISourceName = nil
            project.preferredMIDISourceUniqueID = nil
            _ = MIDIInputService.shared.connect(to: nil)
        }
        refreshMIDIDevices()
    }

    func applySavedMIDIDeviceConnection() {
        refreshMIDIDevices()

        if project.preferredMIDISourceUniqueID != nil || project.preferredMIDISourceName != nil {
            _ = MIDIInputService.shared.reconnectSavedDevice(
                name: project.preferredMIDISourceName,
                uniqueID: project.preferredMIDISourceUniqueID
            )
        }

        refreshMIDIDevices()
    }

    func startMIDILearn(for target: MIDILearnTarget) {
        midiLearnTarget = target
        switch target {
        case .section(let id):
            if let section = project.sections.first(where: { $0.id == id }) {
                selectedSectionID = id
                midiLearnStatusMessage = "Press a pad/key for “\(section.name)”…"
            }
        case .loopToggle:
            midiLearnStatusMessage = "Press the controller button for Loop Repeat…"
        }
    }

    func cancelMIDILearn() {
        midiLearnTarget = nil
        midiLearnStatusMessage = nil
    }

    private var isArrangementSectionControllingPlayback: Bool {
        switch arrangementEngine.state {
        case .playingSection, .waitingToJump:
            return true
        case .idle, .continuingTimeline:
            return false
        }
    }

    func togglePlayback() {
        if isPlaying {
            pause()
        } else {
            play()
        }
    }

    func play() {
        if isSelectionLoopEnabled, let range = selectionRange {
            if playheadTime < range.lowerBound || playheadTime >= range.upperBound {
                playheadTime = range.lowerBound
            }
        }

        arrangementEngine.seek(to: playheadTime)
        arrangementEngine.play()

        guard startAudioPlayback(from: playheadTime) else {
            arrangementEngine.pause()
            return
        }

        isPlaying = true
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
        scrollTimelineToStart()
    }

    func seek(
        to time: TimeInterval,
        scrollTimeline: Bool = false,
        scrollAlignment: TimelineScrollAlignment = .center
    ) {
        let clamped = max(0, time)
        playheadTime = project.duration > 0 ? min(clamped, project.duration) : clamped
        playheadPublishAccumulator = 0
        arrangementEngine.seek(to: playheadTime)

        if scrollTimeline {
            scrollTimelineToPlayhead(alignment: scrollAlignment)
        }

        if isPlaying {
            if !startAudioPlayback(from: playheadTime) {
                pause()
            }
        }
    }

    private func publishPlayheadTime(_ time: TimeInterval, force: Bool = false) {
        if force {
            playheadPublishAccumulator = 0
            playheadTime = time
            return
        }

        playheadPublishAccumulator += playbackTickInterval
        guard playheadPublishAccumulator >= playheadPublishInterval else { return }
        playheadPublishAccumulator = 0
        playheadTime = time
    }

    private func startPlaybackTimer() {
        stopPlaybackTimer()
        playheadPublishAccumulator = 0

        let timer = Timer(timeInterval: playbackTickInterval, repeats: true) { [weak self] _ in
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
        let delta = playbackTickInterval

        if isSelectionLoopEnabled,
           let range = selectionRange,
           range.upperBound > range.lowerBound,
           !isArrangementSectionControllingPlayback {
            var nextTime = arrangementEngine.currentTime + delta
            if nextTime >= range.upperBound {
                nextTime = range.lowerBound
                if !startAudioPlayback(from: range.lowerBound) {
                    pause()
                    return
                }
            }
            arrangementEngine.seek(to: nextTime)
            publishPlayheadTime(nextTime, force: true)
            return
        }

        let previousTime = arrangementEngine.currentTime
        arrangementEngine.tick(delta: delta, projectDuration: project.duration)
        let newTime = arrangementEngine.currentTime

        let jumpedSections = newTime < previousTime - 0.01 || abs(newTime - previousTime) > delta * 2
        publishPlayheadTime(newTime, force: jumpedSections)

        if newTime < previousTime - 0.01 {
            if !startAudioPlayback(from: newTime) {
                pause()
                return
            }
        }

        if newTime >= project.duration,
           project.duration > 0,
           !isArrangementSectionControllingPlayback {
            publishPlayheadTime(newTime, force: true)
            pause()
            return
        }

        if !arrangementEngine.isPlaying {
            publishPlayheadTime(newTime, force: true)
            pause()
        }
    }
}
