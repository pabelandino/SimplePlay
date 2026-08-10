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
    var sectionIDPendingDeletion: UUID?
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

    var isSectionResizeActive: Bool {
        draggingSectionID != nil
            && (sectionDragKind == .resizeStart || sectionDragKind == .resizeEnd)
    }

    var isSectionRepeatEnabled: Bool {
        arrangementEngine.isRepeatEnabled
    }

    var queuedSectionName: String? {
        arrangementEngine.pendingSection?.name
    }

    enum SectionPlaybackStatus: Equatable {
        case idle
        case playing
        case queued
        case repeatingAtEnd
    }

    var activePlaybackSection: ArrangementSection? {
        switch arrangementEngine.state {
        case .playingSection(let section), .repeatingSectionAtEnd(let section):
            return section
        case .waitingToJump:
            return arrangementEngine.activeSection
        default:
            return nil
        }
    }

    func sectionPlaybackStatus(for section: ArrangementSection) -> SectionPlaybackStatus {
        if arrangementEngine.pendingSection?.id == section.id {
            return .queued
        }
        if case .repeatingSectionAtEnd(let active) = arrangementEngine.state, active.id == section.id {
            return .repeatingAtEnd
        }
        if isPlaying, activePlaybackSection?.id == section.id {
            return .playing
        }
        return .idle
    }

    var repeatingSectionName: String? {
        switch arrangementEngine.state {
        case .repeatingSectionAtEnd(let section):
            return section.name
        default:
            return nil
        }
    }

    var sectionCreationPreview: ClosedRange<TimeInterval>?
    private(set) var sectionDragPreviewRange: ClosedRange<TimeInterval>?
    private(set) var sectionMovePreviewRange: ClosedRange<TimeInterval>?
    private(set) var sectionMovePreviewSectionID: UUID?
    var preferredMarkerPreset: String = "Verse"
    private var sectionCreationStartTime: TimeInterval?

    struct SectionEdgeGuides: Equatable {
        let startTime: TimeInterval
        let endTime: TimeInterval
        let colorHex: String
        let showStartEdge: Bool
        let showEndEdge: Bool
    }

    var activeSectionEdgeGuides: SectionEdgeGuides? {
        if sectionDragKind == .resizeStart,
           let preview = sectionDragPreviewRange,
           let sectionID = draggingSectionID,
           let section = project.sections.first(where: { $0.id == sectionID }) {
            return SectionEdgeGuides(
                startTime: preview.lowerBound,
                endTime: section.endTime,
                colorHex: section.colorHex,
                showStartEdge: true,
                showEndEdge: false
            )
        }

        if sectionDragKind == .resizeEnd,
           let preview = sectionDragPreviewRange,
           let sectionID = draggingSectionID,
           let section = project.sections.first(where: { $0.id == sectionID }) {
            return SectionEdgeGuides(
                startTime: section.startTime,
                endTime: preview.upperBound,
                colorHex: section.colorHex,
                showStartEdge: false,
                showEndEdge: true
            )
        }

        if let preview = sectionMovePreviewRange,
           let sectionID = sectionMovePreviewSectionID,
           let section = project.sections.first(where: { $0.id == sectionID }) {
            return SectionEdgeGuides(
                startTime: preview.lowerBound,
                endTime: preview.upperBound,
                colorHex: section.colorHex,
                showStartEdge: true,
                showEndEdge: true
            )
        }

        return nil
    }

    var midiLearnTarget: MIDILearnTarget?
    var midiLearnStatusMessage: String?
    var lastMIDIInputDebugMessage: String?
    var availableMIDISources: [MIDISourceInfo] = []
    var connectedMIDISourceName: String?
    var isMIDIMappingExpanded = false
    var isMIDIMappingAssignModeEnabled = false

    let audioEngine = AudioEngineService()
    let arrangementEngine = ArrangementPlaybackEngine()
    let midiOutput = MIDIOutputService.shared

    private let importService = AudioImportService()
    private let organizationService = TrackOrganizationService()
    private let projectPersistence = ProjectPersistenceService()
    private var playbackTimer: Timer?
    private var playheadPublishAccumulator: TimeInterval = 0
    private let playbackTickInterval: TimeInterval = 1.0 / 30.0
    private let playheadPublishInterval: TimeInterval = 1.0 / 10.0
    private var loopPrebufferTriggered = false
    private var arrangementSyncedToAudioThisTick = false
    private var suppressTimelineJumpRestartUntil: Date?

    init() {
        MIDIInputService.shared.onEvent = { [weak self] event in
            self?.handleIncomingMIDI(event)
        }
        prepareMIDIInput()
    }

    func prepareMIDIInput() {
        MIDIInputService.shared.ensureReady()
        MIDIInputService.shared.preferredSourceUniqueID = project.preferredMIDISourceUniqueID
        refreshMIDIDevices()
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

    func presentImportPanel(
        for kind: ImportPanelKind,
        placement: TrackOrganizationService.ImportPlacement = .appendNewGroup(startTime: nil),
        afterMenuDismiss: Bool = false
    ) {
        pendingImportPlacement = placement
        importPanelKind = kind
#if os(iOS)
        let contentTypes = kind == .folder
            ? SupportedAudioFormats.folderPickerTypes
            : SupportedAudioFormats.filePickerTypes
        let delay = afterMenuDismiss ? 0.45 : 0.1
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [self] in
            ImportDocumentPickerPresenter.present(
                contentTypes: contentTypes,
                allowsMultipleSelection: kind != .folder,
                copiesAsFiles: kind != .folder,
                onPick: { [self] urls in
                    handleImportPickerResults(urls)
                }
            )
        }
#else
        showImportPanel = true
#endif
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

        alignProjectSampleRateToImportedStems(stems)

        arrangementEngine.configure(sections: project.sections)
        configureAudioEngine()
        WaveformLoadMonitor.shared.reset()
        clampZoomToTimelineLimits()
    }

    private func clampZoomToTimelineLimits() {
        guard project.duration > 0, zoom < minimumTimelineZoom else { return }
        zoom = minimumTimelineZoom
    }

    private func alignProjectSampleRateToImportedStems(_ stems: [TrackOrganizationService.ImportedStem]) {
        let urls = stems.map(\.url)
        guard let detected = AudioSampleRate.dominantSampleRate(fileURLs: urls),
              project.audioSettings.sampleRate != detected else { return }

        project.audioSettings.sampleRate = detected
        let notice = "Project sample rate set to \(detected.displayName) to match imported audio."
        if let existing = importNoticeMessage, !existing.isEmpty {
            importNoticeMessage = "\(existing)\n\(notice)"
        } else {
            importNoticeMessage = notice
        }
    }

    private func reconcileProjectSampleRateWithLoadedClips() {
        guard let clipRate = audioEngine.primaryClipSampleRate,
              let matched = AudioSampleRate.nearest(to: clipRate),
              project.audioSettings.sampleRate != matched else { return }

        project.audioSettings.sampleRate = matched
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

        let loop = currentSectionLoopContext(at: time)

        if attemptAudioPlayback(from: time, sectionLoop: loop) {
            return true
        }

        if loop != nil, attemptAudioPlayback(from: time, sectionLoop: nil) {
            return true
        }

        guard configureAudioEngine(), attemptAudioPlayback(from: time, sectionLoop: loop) else {
            if loop != nil, attemptAudioPlayback(from: time, sectionLoop: nil) {
                return true
            }
            return false
        }

        return true
    }

    private func attemptAudioPlayback(from time: TimeInterval, sectionLoop: SectionLoopContext?) -> Bool {
        let started = audioEngine.play(from: time, project: project, sectionLoop: sectionLoop)
        if !started, let playbackError = audioEngine.lastPlaybackError {
            reportError(playbackError)
        } else if !started {
            reportError("Could not start audio playback.")
        }
        return started
    }

    private func currentSectionLoopContext(at time: TimeInterval) -> SectionLoopContext? {
        let section: ArrangementSection? = {
            if let match = project.sections.first(where: { $0.contains(time: time) }) {
                return match
            }
            switch arrangementEngine.state {
            case .playingSection(let active), .repeatingSectionAtEnd(let active):
                return active
            case .waitingToJump:
                return arrangementEngine.activeSection
            default:
                return nil
            }
        }()

        guard let section else { return nil }

        let repeatsAtEnd: Bool = {
            if case .repeatingSectionAtEnd = arrangementEngine.state { return true }
            return false
        }()

        let globalLoop: Bool = {
            guard arrangementEngine.isRepeatEnabled, arrangementEngine.isPlaying else { return false }
            switch arrangementEngine.state {
            case .playingSection, .repeatingSectionAtEnd, .waitingToJump:
                return true
            case .idle, .continuingTimeline:
                return false
            }
        }()
        guard repeatsAtEnd || globalLoop else { return nil }

        let aligned = sampleAlignedSectionBounds(section)
        return SectionLoopContext(
            sectionID: section.id,
            startTime: aligned.start,
            endTime: aligned.end
        )
    }

    private func isSectionLoopWrap(from previousTime: TimeInterval, to newTime: TimeInterval) -> Bool {
        guard newTime + 0.001 < previousTime,
              let loop = currentSectionLoopContext(at: previousTime) else {
            return false
        }
        let nearEnd = abs(previousTime - loop.endTime) <= playbackTickInterval * 3
            || previousTime >= loop.endTime - 0.001
        guard nearEnd else { return false }
        return abs(newTime - loop.startTime) <= playbackTickInterval * 3
    }

    private func appendSectionLoopAudioIfNeeded(from previousTime: TimeInterval, to newTime: TimeInterval) -> Bool {
        guard let loop = currentSectionLoopContext(at: newTime) else { return false }

        SectionLoopDiagnostics.logTimelineWrap(
            previousTime: previousTime,
            newTime: newTime,
            loop: loop,
            action: "append audio cycles (no restart)"
        )

        return audioEngine.appendSectionLoopCycles(project: project, loop: loop)
    }

    @discardableResult
    private func restartSelectionLoopAudio(
        at time: TimeInterval,
        range: ClosedRange<TimeInterval>
    ) -> Bool {
        let loop = SectionLoopContext(
            sectionID: SectionLoopContext.selectionLoopPlaceholderID,
            startTime: range.lowerBound,
            endTime: range.upperBound
        )
        return attemptAudioPlayback(from: time, sectionLoop: loop)
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
            reconcileProjectSampleRateWithLoadedClips()
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
        let wasPlaying = isPlaying
        let resumeTime = arrangementEngine.currentTime
        if wasPlaying {
            pause()
        }

        do {
            try audioEngine.apply(settings: project.audioSettings)
            if audioEngine.isPlaybackGraphReady {
                _ = configureAudioEngine()
            }
            if wasPlaying {
                playheadTime = resumeTime
                play()
            }
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
        if !restartAudioPlayback(from: arrangementEngine.currentTime) {
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
        let normalized = normalizedSectionRange(start: range.lowerBound, end: range.upperBound)
        guard normalized.end > normalized.start else { return }

        let note = UInt8(min(127, 60 + project.sections.count))
        let section = ArrangementSection(
            name: name,
            startTime: normalized.start,
            endTime: normalized.end,
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

        let snappedLower = normalizedSectionBoundary(preview.lowerBound)
        let snappedUpper = normalizedSectionBoundary(preview.upperBound)
        guard snappedUpper > snappedLower else { return }

        addSection(
            name: nextSectionMarkerName(),
            range: snappedLower...snappedUpper,
            mode: .continueTimeline
        )
    }

    func cancelSectionCreation() {
        sectionCreationPreview = nil
        sectionCreationStartTime = nil
    }

    private func timeFromTimelineX(_ x: CGFloat) -> TimeInterval {
        normalizedSectionBoundary(max(0, TimeInterval(x / pixelsPerSecond)))
    }

    private func normalizedSectionBoundary(_ time: TimeInterval) -> TimeInterval {
        TimelineSampleGrid.snapSectionBoundary(
            time,
            snapInterval: project.snapInterval,
            snapEnabled: project.isSnapEnabled,
            sampleRate: timelineSampleRate
        )
    }

    private func normalizedSectionRange(start: TimeInterval, end: TimeInterval) -> (start: TimeInterval, end: TimeInterval) {
        let normalizedStart = normalizedSectionBoundary(start)
        let normalizedEnd = normalizedSectionBoundary(end)
        return (
            normalizedStart,
            max(normalizedStart + TimelineSampleGrid.sampleDuration(sampleRate: timelineSampleRate), normalizedEnd)
        )
    }

    /// Prefer the sample rate of loaded clips so section edges align with audible content.
    private var timelineSampleRate: Double {
        if let clipRate = audioEngine.primaryClipSampleRate {
            return clipRate
        }
        return project.audioSettings.sampleRate.rawValue
    }

    private func sampleAlignedSectionBounds(_ section: ArrangementSection) -> (start: TimeInterval, end: TimeInterval) {
        let sampleRate = timelineSampleRate
        let start = TimelineSampleGrid.timeFromFrame(
            TimelineSampleGrid.frames(at: section.startTime, sampleRate: sampleRate),
            sampleRate: sampleRate
        )
        let end = TimelineSampleGrid.timeFromFrame(
            TimelineSampleGrid.frames(at: section.endTime, sampleRate: sampleRate),
            sampleRate: sampleRate
        )
        return (start, end)
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

    func updateSectionMovePreview(
        sectionID: UUID,
        anchorStart: TimeInterval,
        anchorEnd: TimeInterval,
        laneLocationX: CGFloat,
        grabOffsetX: CGFloat
    ) {
        sectionMovePreviewSectionID = sectionID
        sectionMovePreviewRange = previewRangeForSectionDrag(
            kind: .move,
            anchorStart: anchorStart,
            anchorEnd: anchorEnd,
            laneLocationX: laneLocationX,
            grabOffsetX: grabOffsetX
        )
    }

    func clearSectionMovePreview() {
        sectionMovePreviewSectionID = nil
        sectionMovePreviewRange = nil
    }

    func beginSectionDrag(sectionID: UUID, kind: SectionDragKind) {
        guard kind == .resizeStart || kind == .resizeEnd else { return }
        guard draggingSectionID == nil else { return }

        draggingSectionID = sectionID
        sectionDragKind = kind
        selectedSectionID = sectionID
        clearSectionMovePreview()

        if let section = project.sections.first(where: { $0.id == sectionID }) {
            updateSectionDragPreview(start: section.startTime, end: section.endTime)
        }
    }

    func cancelSectionDrag() {
        clearSectionDragState()
    }

    func updateSectionDragPreview(start: TimeInterval, end: TimeInterval) {
        sectionDragPreviewRange = min(start, end)...max(start, end)
    }

    func updateSectionDragPreview(
        kind: SectionDragKind,
        anchorStart: TimeInterval,
        anchorEnd: TimeInterval,
        laneLocationX: CGFloat,
        grabOffsetX: CGFloat = 0
    ) {
        let range = previewRangeForSectionDrag(
            kind: kind,
            anchorStart: anchorStart,
            anchorEnd: anchorEnd,
            laneLocationX: laneLocationX,
            grabOffsetX: grabOffsetX
        )
        updateSectionDragPreview(start: range.lowerBound, end: range.upperBound)
    }

    func rawTimeFromTimelineX(_ x: CGFloat) -> TimeInterval {
        max(0, TimeInterval(x / pixelsPerSecond))
    }

    func previewRangeForSectionDrag(
        kind: SectionDragKind,
        anchorStart: TimeInterval,
        anchorEnd: TimeInterval,
        laneLocationX: CGFloat,
        grabOffsetX: CGFloat = 0
    ) -> ClosedRange<TimeInterval> {
        let minimumDuration = max(project.snapInterval, 0.25)

        switch kind {
        case .move:
            let duration = anchorEnd - anchorStart
            let startTime = max(0, rawTimeFromTimelineX(laneLocationX - grabOffsetX))
            let endTime = startTime + duration
            return startTime...endTime

        case .resizeStart:
            let startTime = max(
                0,
                min(
                    anchorEnd - minimumDuration,
                    rawTimeFromTimelineX(laneLocationX - grabOffsetX)
                )
            )
            return startTime...anchorEnd

        case .resizeEnd:
            let endTime = max(
                anchorStart + minimumDuration,
                rawTimeFromTimelineX(laneLocationX - grabOffsetX)
            )
            return anchorStart...endTime
        }
    }

    /// Commits the live drag preview exactly as shown (no snap or recomputation).
    func commitSectionDragPreview(sectionID: UUID, kind: SectionDragKind) {
        guard let index = project.sections.firstIndex(where: { $0.id == sectionID }) else {
            clearSectionDragState()
            clearSectionMovePreview()
            return
        }

        let previewRange: ClosedRange<TimeInterval>?
        switch kind {
        case .move:
            previewRange = sectionMovePreviewRange
        case .resizeStart, .resizeEnd:
            previewRange = sectionDragPreviewRange
        }

        if let previewRange {
            project.sections[index].startTime = previewRange.lowerBound
            project.sections[index].endTime = previewRange.upperBound
            arrangementEngine.configure(sections: project.sections)
        }

        clearSectionDragState()
        clearSectionMovePreview()
    }

    private func clearSectionDragState() {
        draggingSectionID = nil
        sectionDragKind = .move
        sectionDragPreviewRange = nil
    }

    func updateSectionMIDI(
        _ sectionID: UUID,
        note: UInt8,
        channel: UInt8,
        usesControlChange: Bool = false
    ) {
        guard let index = project.sections.firstIndex(where: { $0.id == sectionID }) else { return }
        project.sections[index].midiNote = min(127, note)
        project.sections[index].midiChannel = min(15, channel)
        project.sections[index].midiUsesControlChange = usesControlChange
        arrangementEngine.configure(sections: project.sections)
    }

    func deleteSection(_ sectionID: UUID) {
        project.sections.removeAll { $0.id == sectionID }
        if selectedSectionID == sectionID {
            selectedSectionID = project.sections.first?.id
        }
        arrangementEngine.configure(sections: project.sections)
    }

    func requestDeleteSection(_ sectionID: UUID) {
        selectSection(sectionID)
        sectionIDPendingDeletion = sectionID
    }

    func cancelSectionDeletion() {
        sectionIDPendingDeletion = nil
    }

    func confirmPendingSectionDeletion() {
        guard let sectionID = sectionIDPendingDeletion else { return }
        deleteSection(sectionID)
        sectionIDPendingDeletion = nil
    }

    var pendingSectionDeletionName: String? {
        guard let sectionID = sectionIDPendingDeletion else { return nil }
        return project.sections.first(where: { $0.id == sectionID })?.name
    }

    func toggleSectionRepeat() {
        setSectionRepeatEnabled(!arrangementEngine.isRepeatEnabled)
    }

    @discardableResult
    private func restartAudioPlayback(from time: TimeInterval) -> Bool {
        let shouldResumeTimer = playbackTimer != nil
        if shouldResumeTimer {
            stopPlaybackTimer()
        }

        guard startAudioPlayback(from: time) else {
            return false
        }

        if shouldResumeTimer {
            startPlaybackTimer()
        }
        return true
    }

    /// Starts audio for a section trigger using the same path as transport play (reliable on iPad).
    @discardableResult
    private func resumeSectionTriggerPlayback(from time: TimeInterval) -> Bool {
        playheadTime = time
        suppressTimelineJumpRestartUntil = Date().addingTimeInterval(0.35)
        arrangementEngine.seek(to: playheadTime)
        arrangementEngine.play()
        arrangementEngine.ensureSectionPlaybackContext(at: playheadTime)

        guard restartAudioPlayback(from: playheadTime) else {
            return false
        }

        isPlaying = true
        loopPrebufferTriggered = false
        return true
    }

    func setSectionRepeatEnabled(_ enabled: Bool) {
        arrangementEngine.setRepeatEnabled(enabled)

        guard enabled, isPlaying else { return }
        arrangementEngine.ensureSectionPlaybackContext(at: arrangementEngine.currentTime)
        guard currentSectionLoopContext(at: arrangementEngine.currentTime) != nil else { return }
        if !restartAudioPlayback(from: arrangementEngine.currentTime) {
            pause()
        }
    }

    func triggerSection(_ section: ArrangementSection) {
        isSelectionLoopEnabled = false
        selectedSectionID = section.id

        if isPlaying {
            arrangementEngine.ensureSectionPlaybackContext(at: arrangementEngine.currentTime)
        }

        let result = arrangementEngine.triggerSection(section)
        midiOutput.sendSectionTrigger(section)

        switch result {
        case .queuedForEnd:
            if isPlaying {
                loopPrebufferTriggered = true
                return
            }
        case .enabledRepeatAtEnd:
            if isPlaying {
                if !audioEngine.isAnyPlayerPlaying,
                   !resumeSectionTriggerPlayback(from: arrangementEngine.currentTime) {
                    pause()
                }
                return
            }
        case .activatedImmediately:
            break
        }

        playheadTime = arrangementEngine.currentTime
        scrollTimelineToPlayhead(alignment: .center)

        if isPlaying {
            guard resumeSectionTriggerPlayback(from: playheadTime) else {
                pause()
                return
            }
        } else {
            play()
        }
    }

    func handleIncomingMIDI(_ event: MIDIInputEvent) {
        lastMIDIInputDebugMessage = midiDebugDescription(for: event)

        if let target = midiLearnTarget {
            if applyMIDILearn(event: event, target: target) {
                midiLearnTarget = nil
                MIDIInputService.shared.acceptAllSources = false
            }
            return
        }

        if project.sectionRepeatMIDIMapped,
           event.kind == .noteOn,
           event.number == project.sectionRepeatMIDINote,
           event.channel == project.sectionRepeatMIDIChannel {
            toggleSectionRepeat()
            return
        }

        guard let section = project.sections.first(where: { section in
            section.midiChannel == event.channel &&
            section.midiNote == event.number &&
            section.midiUsesControlChange == (event.kind == .controlChange)
        }) else { return }

        guard event.kind == .noteOn || event.kind == .controlChange else { return }

        triggerSection(section)
    }

    private func midiDebugDescription(for event: MIDIInputEvent) -> String {
        let assignment = MIDINoteAssignment(
            note: event.number,
            channel: event.channel,
            usesControlChange: event.kind == .controlChange
        )
        if let sourceUniqueID = event.sourceUniqueID,
           let sourceName = availableMIDISources.first(where: { $0.uniqueID == sourceUniqueID })?.name {
            return "\(assignment.displayName) · \(sourceName)"
        }
        return assignment.displayName
    }

    @discardableResult
    private func applyMIDILearn(event: MIDIInputEvent, target: MIDILearnTarget) -> Bool {
        let assignment = MIDINoteAssignment(
            note: event.number,
            channel: event.channel,
            usesControlChange: event.kind == .controlChange
        )

        switch target {
        case .section(let sectionID):
            updateSectionMIDI(
                sectionID,
                note: event.number,
                channel: event.channel,
                usesControlChange: event.kind == .controlChange
            )
            if let section = project.sections.first(where: { $0.id == sectionID }) {
                midiLearnStatusMessage = "Mapped “\(section.name)” → \(assignment.displayName)"
            }
            return true
        case .loopToggle:
            guard event.kind == .noteOn else {
                midiLearnStatusMessage = "Loop Repeat needs a note message. Try another pad."
                return false
            }
            project.sectionRepeatMIDINote = event.number
            project.sectionRepeatMIDIChannel = event.channel
            project.sectionRepeatMIDIMapped = true
            midiLearnStatusMessage = "Loop Repeat → \(assignment.displayName)"
            return true
        }
    }

    func refreshMIDIDevices() {
        MIDIInputService.shared.ensureReady()
        availableMIDISources = MIDIInputService.shared.availableSources()
        connectedMIDISourceName = MIDIInputService.shared.connectedSourceName
    }

    func selectMIDIDevice(_ source: MIDISourceInfo?) {
        if let source {
            project.preferredMIDISourceName = source.name
            project.preferredMIDISourceUniqueID = source.uniqueID
        } else {
            project.preferredMIDISourceName = nil
            project.preferredMIDISourceUniqueID = nil
        }

        MIDIInputService.shared.preferredSourceUniqueID = project.preferredMIDISourceUniqueID
        _ = MIDIInputService.shared.connect(to: source)
        refreshMIDIDevices()

        if !isMIDILearnActive {
            if let source {
                midiLearnStatusMessage = "Connected to “\(source.name)”."
            } else if !availableMIDISources.isEmpty {
                midiLearnStatusMessage = "Listening on all MIDI inputs."
            }
        }
    }

    func applySavedMIDIDeviceConnection() {
        prepareMIDIInput()

        if project.preferredMIDISourceUniqueID != nil || project.preferredMIDISourceName != nil {
            _ = MIDIInputService.shared.reconnectSavedDevice(
                name: project.preferredMIDISourceName,
                uniqueID: project.preferredMIDISourceUniqueID
            )
        } else {
            _ = MIDIInputService.shared.connect(to: nil)
        }

        MIDIInputService.shared.preferredSourceUniqueID = project.preferredMIDISourceUniqueID
        refreshMIDIDevices()
    }

    func setMIDIMappingAssignModeEnabled(_ enabled: Bool) {
        isMIDIMappingAssignModeEnabled = enabled
        if !enabled {
            cancelMIDILearn()
        }
    }

    func startMIDILearn(for target: MIDILearnTarget) {
        isMIDIMappingAssignModeEnabled = true
        isMIDIMappingExpanded = true
        applySavedMIDIDeviceConnection()
        MIDIInputService.shared.acceptAllSources = true
        lastMIDIInputDebugMessage = nil
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
        MIDIInputService.shared.acceptAllSources = false
        lastMIDIInputDebugMessage = nil
        midiLearnStatusMessage = nil
    }

    private var isArrangementSectionControllingPlayback: Bool {
        switch arrangementEngine.state {
        case .playingSection, .repeatingSectionAtEnd, .waitingToJump:
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
        arrangementEngine.ensureSectionPlaybackContext(at: playheadTime)

        guard startAudioPlayback(from: playheadTime) else {
            arrangementEngine.pause()
            return
        }

        isPlaying = true
        loopPrebufferTriggered = false
        startPlaybackTimer()
    }

    func pause() {
        isPlaying = false
        suppressTimelineJumpRestartUntil = nil
        audioEngine.pause()
        arrangementEngine.pause()
        playheadTime = arrangementEngine.currentTime
        playheadPublishAccumulator = 0
        loopPrebufferTriggered = false
        stopPlaybackTimer()
    }

    func stop() {
        isPlaying = false
        suppressTimelineJumpRestartUntil = nil
        playheadTime = 0
        playheadPublishAccumulator = 0
        loopPrebufferTriggered = false
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
            arrangementEngine.ensureSectionPlaybackContext(at: playheadTime)
            if !restartAudioPlayback(from: playheadTime) {
                pause()
            }
        }
    }

    private func playbackTimelineDidJump(
        from previousTime: TimeInterval,
        to newTime: TimeInterval,
        delta: TimeInterval
    ) -> Bool {
        abs(newTime - (previousTime + delta)) > max(0.05, delta * 0.5)
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

    private func computePlaybackDelta(previousTime: TimeInterval) -> TimeInterval {
        guard isPlaying else { return 0 }

        guard let audioTime = audioEngine.currentTimelineTime() else {
            return audioEngine.isAnyPlayerPlaying ? playbackTickInterval : 0
        }

        let rawDelta = audioTime - previousTime
        if rawDelta >= 0, rawDelta <= 0.5 {
            return rawDelta
        }
        if rawDelta > 0.5 {
            guard audioTime <= project.duration + 0.25 else {
                return playbackTickInterval
            }
            arrangementEngine.seek(to: audioTime)
            arrangementSyncedToAudioThisTick = true
            return 0
        }
        return 0
    }

    private func tickPlayback() {
        arrangementSyncedToAudioThisTick = false
        let previousTime = arrangementEngine.currentTime
        let delta = computePlaybackDelta(previousTime: previousTime)
        let inSectionLoop = currentSectionLoopContext(at: previousTime) != nil

        if isSelectionLoopEnabled,
           let range = selectionRange,
           range.upperBound > range.lowerBound,
           !isArrangementSectionControllingPlayback {
            var nextTime = arrangementEngine.currentTime + delta
            if nextTime >= range.upperBound {
                nextTime = range.lowerBound
                if !restartSelectionLoopAudio(at: range.lowerBound, range: range) {
                    pause()
                    return
                }
            }
            arrangementEngine.seek(to: nextTime)
            publishPlayheadTime(nextTime, force: true)
            return
        }

        arrangementEngine.tick(delta: delta, projectDuration: project.duration)
        let newTime = arrangementEngine.currentTime

        let didJumpTimeline = playbackTimelineDidJump(
            from: previousTime,
            to: newTime,
            delta: delta
        )
        publishPlayheadTime(newTime, force: didJumpTimeline || inSectionLoop)

        if didJumpTimeline, newTime + 0.5 < previousTime {
            scrollTimelineToPlayhead(alignment: .center)
        }

        if isPlaying,
           didJumpTimeline,
           !arrangementSyncedToAudioThisTick,
           suppressTimelineJumpRestartUntil.map({ Date() >= $0 }) ?? true {
            if isSectionLoopWrap(from: previousTime, to: newTime) {
                audioEngine.reanchorPlaybackTimeline(at: newTime)
                loopPrebufferTriggered = false
                let canAppend = audioEngine.isSectionLoopPlaybackActive
                    && appendSectionLoopAudioIfNeeded(from: previousTime, to: newTime)
                if !canAppend {
                    SectionLoopDiagnostics.log(String(
                        format: "loop wrap audio restart %.6fs -> %.6fs",
                        previousTime,
                        newTime
                    ))
                    if !startAudioPlayback(from: newTime) {
                        pause()
                        return
                    }
                }
            } else {
                loopPrebufferTriggered = false
                SectionLoopDiagnostics.log(String(
                    format: "timeline jump restart %.6fs -> %.6fs",
                    previousTime,
                    newTime
                ))
                if !startAudioPlayback(from: newTime) {
                    pause()
                    return
                }
            }
        }

        if isPlaying,
           arrangementEngine.pendingSection == nil,
           let loop = currentSectionLoopContext(at: newTime) {
            let remaining = loop.endTime - newTime
            if remaining > 0, remaining <= 0.12, !loopPrebufferTriggered {
                loopPrebufferTriggered = true
                SectionLoopDiagnostics.log(String(
                    format: "prebuffer loop %.1f ms before end %.6fs",
                    remaining * 1000,
                    loop.endTime
                ))
                _ = audioEngine.appendSectionLoopCycles(project: project, loop: loop)
            }
        } else if !isPlaying {
            loopPrebufferTriggered = false
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
