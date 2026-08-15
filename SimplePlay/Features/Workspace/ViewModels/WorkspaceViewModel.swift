//
//  WorkspaceViewModel.swift
//  SimplePlay
//

import AVFoundation
import Foundation
import Observation
import SwiftUI

@MainActor
@Observable
final class WorkspaceViewModel {
    var project = DAWProject()
    var playheadTime: TimeInterval = 0
    var zoom: Double = 1.0
    var trackRowZoom: Double = DAWTheme.defaultTrackRowZoom
    /// Updated by the timeline panel so drag math matches the visible row height.
    var trackRowHeightForInteraction: CGFloat = DAWTheme.trackRowHeight
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
    private(set) var isTimelineScrolling = false
    private(set) var timelineScrollRequest: TimelineScrollRequest?
    var availableOutputDevices: [AudioOutputDevice] = AudioDeviceService.listOutputDevices()
    var draggingTrackID: UUID?
    var draggingSectionID: UUID?
    private(set) var trackDragTranslation: CGFloat = 0
    private(set) var trackDropIndicatorIndex: Int?
    private var sectionDragKind: SectionDragKind = .move
    private(set) var clipTrimPreview: AudioClip?
    private var clipTrimTrackID: UUID?
    private var clipTrimClipID: UUID?
    private var clipTrimEdge: ClipEditService.TrimEdge?
    private var clipTrimAnchorTime: TimeInterval?
    private var clipTrimFileDuration: TimeInterval?
    private(set) var clipSplitPreview: (clipID: UUID, time: TimeInterval)?
    private var clipSplitTrackID: UUID?
    private var clipSplitClipID: UUID?
    private(set) var clipMovePreview: ClipMovePreview?

    struct ClipMovePreview: Equatable {
        struct Item: Equatable, Identifiable {
            var id: UUID { clipID }
            let clipID: UUID
            let trackID: UUID
            let anchorStartTime: TimeInterval
            let clip: AudioClip
        }

        var items: [Item]
        var deltaTime: TimeInterval
    }

    var isClipMoveActive: Bool {
        clipMovePreview != nil
    }

    var isClipTrimActive: Bool {
        clipTrimPreview != nil
    }

    var isClipSplitActive: Bool {
        clipSplitPreview != nil
    }

    func clipSplitPreviewTime(for clipID: UUID) -> TimeInterval? {
        guard clipSplitPreview?.clipID == clipID else { return nil }
        return clipSplitPreview?.time
    }

    var canSplitSelectedClipAtPlayhead: Bool {
        guard selectedClipIDs.count == 1,
              let clipID = selectedClipIDs.first,
              let clip = clip(id: clipID) else {
            return false
        }
        return playheadTime > clip.startTime + ClipEditService.minimumClipDuration
            && playheadTime < clip.endTime - ClipEditService.minimumClipDuration
    }

    func displayClip(_ clip: AudioClip) -> AudioClip {
        if clipTrimPreview?.id == clip.id {
            return clipTrimPreview ?? clip
        }
        return clip
    }

    func timelineTime(fromLaneX x: CGFloat) -> TimeInterval {
        SnapGrid.snap(
            max(0, TimeInterval(x / pixelsPerSecond)),
            interval: project.snapInterval,
            enabled: project.isSnapEnabled
        )
    }

    func rawTimelineTime(fromLaneX x: CGFloat) -> TimeInterval {
        rawTimeFromTimelineX(x)
    }

    func beginClipTrim(trackID: UUID, clipID: UUID, edge: ClipEditService.TrimEdge) {
        guard timelineTool == .trim,
              let clip = clip(id: clipID),
              project.tracks.first(where: { $0.id == trackID }) != nil else {
            return
        }

        selectedClipIDs = [clipID]
        syncSelectedTrackFromClipSelection()
        clipTrimTrackID = trackID
        clipTrimClipID = clipID
        clipTrimEdge = edge
        clipTrimAnchorTime = edge == .start ? clip.startTime : clip.endTime
        clipTrimFileDuration = ClipEditService.fileDuration(for: clip)
        clipTrimPreview = clip
    }

    func updateClipTrim(laneLocationX: CGFloat) {
        guard let trackID = clipTrimTrackID,
              let clipID = clipTrimClipID,
              let edge = clipTrimEdge,
              let anchorTime = clipTrimAnchorTime,
              let original = clip(id: clipID) else {
            return
        }

        let targetTime = rawTimelineTime(fromLaneX: laneLocationX)
        let fileDuration = clipTrimFileDuration

        let preview: AudioClip?
        switch edge {
        case .start:
            preview = ClipEditService.trimStart(clip: original, to: min(targetTime, original.endTime - ClipEditService.minimumClipDuration), fileDuration: fileDuration)
        case .end:
            preview = ClipEditService.trimEnd(clip: original, to: max(targetTime, original.startTime + ClipEditService.minimumClipDuration), fileDuration: fileDuration)
        }

        if let preview {
            clipTrimPreview = preview
        } else {
            clipTrimPreview = original
        }

        _ = trackID
        _ = anchorTime
    }

    func commitClipTrim() {
        defer { cancelClipTrim() }

        guard let trackID = clipTrimTrackID,
              let clipID = clipTrimClipID,
              let preview = clipTrimPreview,
              preview.id == clipID,
              let original = clip(id: clipID),
              preview != original else {
            return
        }

        applyClipReplacement(trackID: trackID, clipID: clipID, updated: preview)
    }

    func cancelClipTrim() {
        clipTrimPreview = nil
        clipTrimTrackID = nil
        clipTrimClipID = nil
        clipTrimEdge = nil
        clipTrimAnchorTime = nil
        clipTrimFileDuration = nil
    }

    func cancelClipSplitPreview() {
        clipSplitPreview = nil
        clipSplitTrackID = nil
        clipSplitClipID = nil
    }

    func cancelClipMovePreview() {
        clipMovePreview = nil
    }

    func cancelClipEditing() {
        cancelClipTrim()
        cancelClipSplitPreview()
        cancelClipMovePreview()
    }

    func beginClipSplit(trackID: UUID, clipID: UUID) {
        guard timelineTool == .split,
              project.tracks.first(where: { $0.id == trackID }) != nil,
              clip(id: clipID) != nil else {
            return
        }

        clipSplitTrackID = trackID
        clipSplitClipID = clipID
        selectedClipIDs = [clipID]
        syncSelectedTrackFromClipSelection()
    }

    func updateClipSplitPreview(trackID: UUID, clipID: UUID, laneLocationX: CGFloat) {
        guard timelineTool == .split,
              project.tracks.first(where: { $0.id == trackID }) != nil,
              let clip = clip(id: clipID) else {
            return
        }

        if clipSplitClipID != clipID {
            beginClipSplit(trackID: trackID, clipID: clipID)
        }

        let targetTime = rawTimelineTime(fromLaneX: laneLocationX)
        let minimum = ClipEditService.minimumClipDuration
        let clamped = min(
            max(targetTime, clip.startTime + minimum),
            clip.endTime - minimum
        )
        clipSplitPreview = (clipID, clamped)
    }

    func commitClipSplit(trackID: UUID, clipID: UUID) {
        defer { cancelClipSplitPreview() }

        guard let preview = clipSplitPreview,
              preview.clipID == clipID else {
            return
        }

        performSplit(trackID: trackID, clipID: clipID, at: preview.time)
    }

    func beginClipMove(primaryClipID: UUID) {
        guard timelineTool == .hand, clipMovePreview == nil else { return }

        var items: [ClipMovePreview.Item] = []

        if selectedClipIDs.contains(primaryClipID), selectedClipIDs.count > 1 {
            for track in project.tracks {
                for clip in track.clips where selectedClipIDs.contains(clip.id) {
                    items.append(
                        ClipMovePreview.Item(
                            clipID: clip.id,
                            trackID: track.id,
                            anchorStartTime: clip.startTime,
                            clip: clip
                        )
                    )
                }
            }
        } else if let track = project.track(containing: primaryClipID),
                  let clip = clip(id: primaryClipID) {
            selectedClipIDs = [primaryClipID]
            syncSelectedTrackFromClipSelection()
            items = [
                ClipMovePreview.Item(
                    clipID: clip.id,
                    trackID: track.id,
                    anchorStartTime: clip.startTime,
                    clip: clip
                ),
            ]
        }

        guard !items.isEmpty else { return }
        clipMovePreview = ClipMovePreview(items: items, deltaTime: 0)
    }

    func updateClipMovePreview(translationWidth: CGFloat) {
        guard clipMovePreview != nil else { return }
        clipMovePreview?.deltaTime = TimeInterval(translationWidth / pixelsPerSecond)
    }

    func commitClipMovePreview() {
        guard let preview = clipMovePreview else { return }

        recordEditSnapshot()

        for item in preview.items {
            guard let trackIndex = project.tracks.firstIndex(where: { $0.id == item.trackID }),
                  let clipIndex = project.tracks[trackIndex].clips.firstIndex(where: { $0.id == item.clipID }) else {
                continue
            }

            project.tracks[trackIndex].clips[clipIndex].startTime = max(
                0,
                item.anchorStartTime + preview.deltaTime
            )
        }

        clipMovePreview = nil
        updateSelectionRangeFromClips()
        audioEngine.syncClipLayout(from: project)
        resyncPlaybackIfNeeded()
    }

    func clipMovePreviewItems(for trackID: UUID) -> [ClipMovePreview.Item] {
        clipMovePreview?.items.filter { $0.trackID == trackID } ?? []
    }

    func previewStartTime(for clipID: UUID) -> TimeInterval? {
        guard let preview = clipMovePreview,
              let item = preview.items.first(where: { $0.clipID == clipID }) else {
            return nil
        }
        return max(0, item.anchorStartTime + preview.deltaTime)
    }

    func isClipBeingMoved(_ clipID: UUID) -> Bool {
        clipMovePreview?.items.contains(where: { $0.clipID == clipID }) ?? false
    }

    func splitClip(trackID: UUID, clipID: UUID, at timelineTime: TimeInterval) {
        guard timelineTool == .split else { return }
        performSplit(trackID: trackID, clipID: clipID, at: timelineTime)
    }

    func splitSelectedClipAtPlayhead() {
        guard canSplitSelectedClipAtPlayhead,
              let clipID = selectedClipIDs.first,
              let track = project.track(containing: clipID) else {
            return
        }

        performSplit(trackID: track.id, clipID: clipID, at: playheadTime)
    }

    private func performSplit(trackID: UUID, clipID: UUID, at timelineTime: TimeInterval) {
        recordEditSnapshot()

        guard let trackIndex = project.tracks.firstIndex(where: { $0.id == trackID }),
              let clipIndex = project.tracks[trackIndex].clips.firstIndex(where: { $0.id == clipID }),
              let split = ClipEditService.split(
                clip: project.tracks[trackIndex].clips[clipIndex],
                at: timelineTime
              ) else {
            return
        }

        project.tracks[trackIndex].clips[clipIndex] = split.left
        project.tracks[trackIndex].clips.insert(split.right, at: clipIndex + 1)
        finishClipStructureChange(selectClipID: split.right.id)
    }

    private func applyClipReplacement(trackID: UUID, clipID: UUID, updated: AudioClip) {
        recordEditSnapshot()

        guard let trackIndex = project.tracks.firstIndex(where: { $0.id == trackID }),
              let clipIndex = project.tracks[trackIndex].clips.firstIndex(where: { $0.id == clipID }) else {
            return
        }

        project.tracks[trackIndex].clips[clipIndex] = updated
        finishClipStructureChange(selectClipID: updated.id)
    }

    private func finishClipStructureChange(selectClipID: UUID) {
        selectedClipIDs = [selectClipID]
        syncSelectedTrackFromClipSelection()
        updateSelectionRangeFromClips()
        _ = configureAudioEngine()
        resyncPlaybackIfNeeded()
    }

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

    var activeClipMoveGuides: SectionEdgeGuides? {
        guard let preview = clipMovePreview, !preview.items.isEmpty else { return nil }

        var minStart = TimeInterval.greatestFiniteMagnitude
        var maxEnd: TimeInterval = 0
        var colorHex = project.tracks.first?.colorHex ?? "#FF9500"

        for item in preview.items {
            let start = max(0, item.anchorStartTime + preview.deltaTime)
            let end = start + item.clip.duration
            minStart = min(minStart, start)
            maxEnd = max(maxEnd, end)
            if let track = project.tracks.first(where: { $0.id == item.trackID }) {
                colorHex = track.colorHex
            }
        }

        guard minStart <= maxEnd else { return nil }

        return SectionEdgeGuides(
            startTime: minStart,
            endTime: maxEnd,
            colorHex: colorHex,
            showStartEdge: true,
            showEndEdge: true
        )
    }

    var activeClipSplitGuide: SectionEdgeGuides? {
        guard let preview = clipSplitPreview,
              let clip = clip(id: preview.clipID),
              let track = project.track(containing: preview.clipID) else {
            return nil
        }

        return SectionEdgeGuides(
            startTime: preview.time,
            endTime: preview.time,
            colorHex: track.colorHex,
            showStartEdge: true,
            showEndEdge: false
        )
    }

    var midiLearnTarget: MIDILearnTarget?
    var midiLearnStatusMessage: String?
    var lastMIDIInputDebugMessage: String?
    var availableMIDISources: [MIDISourceInfo] = []
    var connectedMIDISourceName: String?
    var isMIDIMappingExpanded = false
    var isMIDIMappingAssignModeEnabled = false
    /// iPad/mac: all tracks by default; true = stack into one lane.
    var isTimelineWrappedCompact = false
    /// iPhone: single lane by default; true = show all track lanes.
    var isPhoneTimelineExpanded = false
    var isPhoneSectionAssignSheetPresented = false

    var showsSingleTimelineLaneOnPhone: Bool {
        !isPhoneTimelineExpanded
    }

    var showsSingleTimelineLaneOnStandard: Bool {
        isTimelineWrappedCompact
    }

    let audioEngine = AudioEngineService()
    let arrangementEngine = ArrangementPlaybackEngine()
    let midiOutput = MIDIOutputService.shared
    let lyricSync = LyricPlaySyncClient()

    var isSectionLyricLinkSheetPresented = false
    var sectionIDForLyricLink: UUID?
    var lyricCatalog: LyricSlideCatalog?
    var isLoadingLyricCatalog = false
    var lyricSyncErrorMessage: String?

    private let importService = AudioImportService()
    private let organizationService = TrackOrganizationService()
    private let projectPersistence = ProjectPersistenceService()
    private var playbackTimer: Timer?
    private var playheadPublishAccumulator: TimeInterval = 0
    private let playheadPublishInterval: TimeInterval = 1.0 / 10.0
    private var isApplicationActive = true
    private var loopPrebufferTriggered = false
    private var arrangementSyncedToAudioThisTick = false
    private var suppressTimelineJumpRestartUntil: Date?
    private var lastLyricSyncedSectionID: UUID?
    private var lastAudioRestartWallTime: TimeInterval = 0
    private var lastAudioRestartTimelineTime: TimeInterval = -1
    private var editHistory = ProjectEditHistory()
    private var isApplyingEditHistory = false

    var canUndo: Bool { editHistory.canUndo }
    var canRedo: Bool { editHistory.canRedo }

    init() {
        MIDIInputService.shared.onEvent = { [weak self] event in
            self?.handleIncomingMIDI(event)
        }
        prepareMIDIInput()
        lyricSync.startBrowsing()
        lyricSync.startHeartbeat()
#if !os(macOS)
        NotificationCenter.default.addObserver(
            forName: AVAudioSession.routeChangeNotification,
            object: AVAudioSession.sharedInstance(),
            queue: .main
        ) { [weak self] _ in
            Task { @MainActor in
                self?.handleAudioRouteChange()
            }
        }
#endif
    }

#if !os(macOS)
    private func handleAudioRouteChange() {
        refreshAudioDevices()
        reconcileStoredOutputDevice()
        guard !project.tracks.isEmpty else { return }
        applyAudioSettings()
    }

    private func reconcileStoredOutputDevice() {
        guard let device = AudioDeviceService.device(
            matching: project.audioSettings,
            in: availableOutputDevices
        ) else {
            project.audioSettings.outputDeviceID = nil
            project.audioSettings.outputPortUID = nil
            project.audioSettings.outputDeviceName = AudioOutputDevice.systemDefault.name
            return
        }

        project.audioSettings.outputDeviceID = device.id == 0 ? nil : device.id
        project.audioSettings.outputPortUID = device.portUID
        project.audioSettings.outputDeviceName = device.name
    }
#endif

    func presentLyricLinkSheet(for sectionID: UUID) {
        sectionIDForLyricLink = sectionID
        isSectionLyricLinkSheetPresented = true
    }

    func refreshLyricCatalog() async {
        isLoadingLyricCatalog = true
        lyricSyncErrorMessage = nil
        defer { isLoadingLyricCatalog = false }

        do {
            lyricCatalog = try await lyricSync.requestCatalog()
        } catch {
            lyricCatalog = nil
            lyricSyncErrorMessage = error.localizedDescription
        }
    }

    func assignLyricSlide(
        sectionID: UUID,
        slide: LyricSlideCatalogItem,
        catalog: LyricSlideCatalog
    ) {
        guard let index = project.sections.firstIndex(where: { $0.id == sectionID }) else { return }

        recordEditSnapshot()

        project.sections[index].lyricDocumentID = catalog.lyricID
        project.sections[index].lyricSlideID = slide.slideID
        project.sections[index].lyricSlideOrder = slide.order
        project.linkedLyricDocumentID = catalog.lyricID
        project.linkedLyricTitle = catalog.lyricTitle

        let command = LinkSectionCommand(
            lyricID: catalog.lyricID,
            slideID: slide.slideID,
            sectionID: sectionID,
            projectID: project.id,
            projectName: project.name
        )

        Task {
            try? await lyricSync.linkSection(command)
        }
    }

    func clearLyricSlideLink(for sectionID: UUID) {
        guard let index = project.sections.firstIndex(where: { $0.id == sectionID }) else { return }

        recordEditSnapshot()
        project.sections[index].lyricDocumentID = nil
        project.sections[index].lyricSlideID = nil
        project.sections[index].lyricSlideOrder = nil
    }

    func lyricSlideLabel(for section: ArrangementSection, catalog: LyricSlideCatalog?) -> String {
        guard section.hasLyricSlideLink else { return "No slide" }
        if let catalog,
           let slide = catalog.slides.first(where: { $0.slideID == section.lyricSlideID }) {
            let preview = slide.preview.trimmingCharacters(in: .whitespacesAndNewlines)
            if preview.isEmpty {
                return "Slide \(slide.order + 1)"
            }
            return "Slide \(slide.order + 1) · \(preview)"
        }
        if let order = section.lyricSlideOrder {
            return "Slide \(order + 1)"
        }
        return "Linked slide"
    }

    var isLyrioraReachable: Bool {
        if case .connected = lyricSync.connectionState { return true }
        return lyricCatalog != nil
    }

    private func resyncLyricLinksWithLyriora() async {
        for section in project.sections where section.hasLyricSlideLink {
            guard let lyricID = section.lyricDocumentID,
                  let slideID = section.lyricSlideID else { continue }

            let command = LinkSectionCommand(
                lyricID: lyricID,
                slideID: slideID,
                sectionID: section.id,
                projectID: project.id,
                projectName: project.name
            )
            try? await lyricSync.linkSection(command)
        }
    }

    private func sendLyricSlideTrigger(for section: ArrangementSection) {
        guard section.hasLyricSlideLink else { return }

        let command = ShowSlideCommand(
            lyricID: section.lyricDocumentID!,
            slideID: section.lyricSlideID!,
            sectionID: section.id,
            projectID: project.id
        )

        Task {
            try? await lyricSync.showSlide(command)
        }
    }

    private func section(at time: TimeInterval) -> ArrangementSection? {
        project.sections.first(where: { $0.contains(time: time) })
    }

    private func syncLyricSlideForCurrentPlayhead(force: Bool = false) {
        guard isPlaying else { return }

        guard let section = section(at: arrangementEngine.currentTime) else {
            lastLyricSyncedSectionID = nil
            return
        }

        guard force || section.id != lastLyricSyncedSectionID else { return }

        lastLyricSyncedSectionID = section.id
        sendLyricSlideTrigger(for: section)
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

    private var playbackTickInterval: TimeInterval {
        if !isApplicationActive {
            return 1.0 / 10.0
        }
        return 1.0 / 30.0
    }

    func syncMeterMonitoring() {
        audioEngine.isMeterMonitoringEnabled = showMixerPanel && isApplicationActive
    }

    func setApplicationSceneActive(_ active: Bool) {
        guard isApplicationActive != active else { return }
        isApplicationActive = active
        syncMeterMonitoring()
        guard isPlaying else { return }
        startPlaybackTimer()
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
        let presentPicker = { [self] in
            ImportDocumentPickerPresenter.present(
                contentTypes: contentTypes,
                allowsMultipleSelection: kind != .folder,
                copiesAsFiles: kind != .folder,
                onPick: { [self] urls in
                    handleImportPickerResults(urls)
                }
            )
        }
        if afterMenuDismiss {
            DispatchQueue.main.async {
                presentPicker()
            }
        } else {
            presentPicker()
        }
#else
        switch kind {
        case .audioFiles:
            guard let urls = ProjectFilePanel.chooseAudioFilesForImport() else { return }
            handleImportPickerResults(urls)
        case .folder:
            guard let url = ProjectFilePanel.chooseFolderForImport() else { return }
            handleImportPickerResults([url])
        }
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

    func addEmptyTrack() {
        recordEditSnapshot()

        let nextIndex = project.tracks.count + 1
        var track = AudioTrack(
            originalName: "Track \(nextIndex)",
            standardCode: "TR\(nextIndex)",
            role: .unknown,
            colorHex: TrackColorPalette.hex(for: .unknown),
            clips: []
        )
        project.tracks.append(track)
        TrackColorPalette.ensureDistinctColors(on: &project.tracks)
        selectedClipIDs.removeAll()
        selectedTrackIDForPitch = track.id
        syncSelectedTrackFromClipSelection()
    }

    func importDroppedItems(urls: [URL], startTime: TimeInterval? = nil, targetTrackID: UUID? = nil) {
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
            if let targetTrackID {
                importAudioFiles(to: targetTrackID, urls: fileURLs, startTime: resolvedStart ?? playheadTime)
            } else {
                importMultitrack(
                    urls: fileURLs,
                    startTime: resolvedStart,
                    groupName: "Dropped Files",
                    placement: .appendNewGroup(startTime: resolvedStart)
                )
            }
        }
    }

    func importAudioFiles(to trackID: UUID, urls: [URL], startTime: TimeInterval) {
        guard let trackIndex = project.tracks.firstIndex(where: { $0.id == trackID }) else { return }

        do {
            let result = try importService.loadStems(from: urls, projectID: project.id)
            if let notice = result.notice {
                importNoticeMessage = notice
            }
            guard !result.stems.isEmpty else { return }

            recordEditSnapshot()

            if isPlaying {
                pause()
            }

            let resolvedStart = SnapGrid.snap(
                startTime,
                interval: project.snapInterval,
                enabled: project.isSnapEnabled
            )
            let groupIndex = project.tracks[trackIndex].clips.first?.groupIndex ?? activeGroupIndex()
            var lastClipID: UUID?

            for stem in result.stems {
                let clip = AudioClip(
                    name: stem.name,
                    fileURL: stem.url,
                    startTime: resolvedStart,
                    duration: stem.duration,
                    groupIndex: groupIndex
                )
                project.tracks[trackIndex].clips.append(clip)
                lastClipID = clip.id
            }

            project.tracks[trackIndex].clips.sort { $0.startTime < $1.startTime }

            if project.tracks[trackIndex].clips.isEmpty == false,
               project.tracks[trackIndex].originalName.hasPrefix("Track "),
               project.tracks[trackIndex].role == .unknown,
               let firstStem = result.stems.first {
                let standardized = TrackNameStandardizer.standardize(firstStem.name)
                project.tracks[trackIndex].originalName = standardized.originalName
                project.tracks[trackIndex].standardCode = standardized.standardCode
                project.tracks[trackIndex].role = standardized.role
                TrackColorPalette.ensureDistinctColors(on: &project.tracks)
            }

            alignProjectSampleRateToImportedStems(result.stems)

            if let lastClipID {
                finishClipStructureChange(selectClipID: lastClipID)
            } else {
                _ = configureAudioEngine()
            }
        } catch {
            reportError(error)
        }
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

        recordEditSnapshot()

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
        WaveformClipPeakStore.reset()
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

    func undo() {
        guard let restored = editHistory.undo(current: project) else { return }
        applyRestoredProject(restored)
    }

    func redo() {
        guard let restored = editHistory.redo(current: project) else { return }
        applyRestoredProject(restored)
    }

    private func recordEditSnapshot() {
        guard !isApplyingEditHistory else { return }
        editHistory.recordSnapshot(project)
    }

    private func applyRestoredProject(_ restored: DAWProject) {
        isApplyingEditHistory = true
        defer { isApplyingEditHistory = false }

        cancelClipEditing()
        cancelSectionCreation()
        clearSectionDragState()
        clearSectionMovePreview()

        stopPlaybackTimer()
        isPlaying = false
        suppressTimelineJumpRestartUntil = nil
        loopPrebufferTriggered = false
        lastAudioRestartTimelineTime = -1
        lastAudioRestartWallTime = 0

        audioEngine.stop()
        arrangementEngine.pause()

        WaveformLoadMonitor.shared.reset()
        WaveformClipPeakStore.reset()

        project = restored
        SectionMarkerPalette.ensureDistinctColors(on: &project.sections)

        selectedClipIDs = Set(selectedClipIDs.filter { clip(id: $0) != nil })
        syncSelectedTrackFromClipSelection()
        if selectedClipIDs.isEmpty {
            selectedTrackIDForPitch = nil
        }

        if let selectedSectionID,
           !project.sections.contains(where: { $0.id == selectedSectionID }) {
            self.selectedSectionID = project.sections.first?.id
        }

        if let selectedGroupID,
           !project.groups.contains(where: { $0.id == selectedGroupID }) {
            self.selectedGroupID = project.groups.first?.id
        }

        updateSelectionRangeFromClips()
        arrangementEngine.configure(sections: project.sections)
        arrangementEngine.seek(to: playheadTime)
        _ = configureAudioEngine()
        applySavedMIDIDeviceConnection()
        clampZoomToTimelineLimits()
        lastLyricSyncedSectionID = nil
        Task { await resyncLyricLinksWithLyriora() }
    }

    private func replaceProject(with newProject: DAWProject) {
        stop()
        WaveformLoadMonitor.shared.reset()
        WaveformClipPeakStore.reset()
        editHistory.clear()

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
            syncMeterMonitoring()
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

        if let loop {
            if attemptAudioPlayback(from: time, sectionLoop: loop) {
                SectionTriggerDiagnostics.logAudioStart(
                    source: "startAudioPlayback",
                    time: time,
                    started: true,
                    sectionLoop: true,
                    error: nil
                )
                return true
            }
            let restarted = configureAudioEngine() && attemptAudioPlayback(from: time, sectionLoop: loop)
            SectionTriggerDiagnostics.logAudioStart(
                source: "startAudioPlayback(reconfigure)",
                time: time,
                started: restarted,
                sectionLoop: true,
                error: audioEngine.lastPlaybackError
            )
            return restarted
        }

        if attemptAudioPlayback(from: time, sectionLoop: nil) {
            SectionTriggerDiagnostics.logAudioStart(
                source: "startAudioPlayback",
                time: time,
                started: true,
                sectionLoop: false,
                error: nil
            )
            return true
        }

        let restarted = configureAudioEngine() && attemptAudioPlayback(from: time, sectionLoop: nil)
        SectionTriggerDiagnostics.logAudioStart(
            source: "startAudioPlayback(reconfigure)",
            time: time,
            started: restarted,
            sectionLoop: false,
            error: audioEngine.lastPlaybackError
        )
        return restarted
    }

    private func attemptAudioPlayback(
        from time: TimeInterval,
        sectionLoop: SectionLoopContext?,
        scheduleUntil: TimeInterval? = nil
    ) -> Bool {
        let started = audioEngine.play(
            from: time,
            project: project,
            sectionLoop: sectionLoop,
            scheduleUntil: scheduleUntil
        )
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
        guard repeatsAtEnd else { return nil }

        let aligned = sampleAlignedSectionBounds(section)
        return SectionLoopContext(
            sectionID: section.id,
            startTime: aligned.start,
            endTime: aligned.end
        )
    }

    private func isSectionLoopWrap(from previousTime: TimeInterval, to newTime: TimeInterval) -> Bool {
        guard newTime + 0.001 < previousTime else { return false }

        let loop = currentSectionLoopContext(at: newTime)
            ?? currentSectionLoopContext(at: previousTime)
        guard let loop else { return false }

        let nearEnd = abs(previousTime - loop.endTime) <= playbackTickInterval * 3
            || previousTime >= loop.endTime - 0.001
        guard nearEnd else { return false }
        return abs(newTime - loop.startTime) <= playbackTickInterval * 3
    }

    /// Arrangement repeat-at-end wrap (second tap on section pad) back to section start.
    private func isSectionRepeatWrap(from previousTime: TimeInterval, to newTime: TimeInterval) -> Bool {
        guard newTime + 0.001 < previousTime else { return false }

        return project.sections.contains { section in
            abs(newTime - section.startTime) <= playbackTickInterval * 3
                && abs(previousTime - section.endTime) <= playbackTickInterval * 3
        }
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

    /// True when the playhead jumps between arrangement sections (pad trigger, continue-to-next, pending jump).
    private func isArrangementSectionTransition(from previousTime: TimeInterval, to newTime: TimeInterval) -> Bool {
        guard abs(newTime - previousTime) > 0.05 else { return false }

        // continueTimeline / repeatSection exit keeps the same audio running — only the playhead advances.
        if case .continuingTimeline = arrangementEngine.state {
            return false
        }

        let previousSection = project.sections.first(where: { $0.contains(time: previousTime) })
        let newSection = project.sections.first(where: { $0.contains(time: newTime) })

        if let previousSection, let newSection {
            return previousSection.id != newSection.id
        }

        switch arrangementEngine.state {
        case .playingSection(let section):
            return abs(newTime - section.startTime) <= playbackTickInterval * 2
        default:
            return previousSection != nil && newSection == nil
        }
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
                trackRowZoom: trackRowZoom,
                isPropertiesSidebarVisible: false,
                propertiesSidebarWidth: Double(propertiesSidebarWidth)
            )
        )
    }

    private func applyLoadedProject(_ document: SavedProjectDocument) {
        stop()
        WaveformLoadMonitor.shared.reset()
        WaveformClipPeakStore.reset()
        editHistory.clear()

        project = document.project
        SectionMarkerPalette.ensureDistinctColors(on: &project.sections)
        applySavedMIDIDeviceConnection()
        playheadTime = document.workspace.playheadTime
        zoom = document.workspace.zoom
        trackRowZoom = document.workspace.trackRowZoom
        propertiesSidebarWidth = CGFloat(document.workspace.propertiesSidebarWidth)
        selectedClipIDs.removeAll()
        selectedSectionID = nil
        selectionRange = nil

        arrangementEngine.configure(sections: project.sections)
        arrangementEngine.seek(to: playheadTime)

#if !os(macOS)
        refreshAudioDevices()
        reconcileStoredOutputDevice()
#endif
        if configureAudioEngine() {
            reconcileProjectSampleRateWithLoadedClips()
            applyAudioSettings()
        }
        clampZoomToTimelineLimits()
        lastLyricSyncedSectionID = nil
        Task { await resyncLyricLinksWithLyriora() }
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

    /// Maps current zoom to a 0...1 slider position with `referenceTimelineZoom` at 0.5.
    func timelineZoomSliderPosition(
        reference: Double = DAWTheme.referenceTimelineZoom
    ) -> Double {
        let minZoom = minimumTimelineZoom
        let maxZoom = DAWTheme.maxZoom
        let referenceZoom = min(max(reference, minZoom), maxZoom)

        if referenceZoom <= minZoom + 0.000_001 {
            return 0.5
        }

        if zoom <= referenceZoom {
            return 0.5 * (zoom - minZoom) / (referenceZoom - minZoom)
        }

        guard maxZoom > referenceZoom else { return 1 }
        return 0.5 + 0.5 * (zoom - referenceZoom) / (maxZoom - referenceZoom)
    }

    func setTimelineZoomFromSliderPosition(
        _ position: Double,
        reference: Double = DAWTheme.referenceTimelineZoom
    ) {
        let minZoom = minimumTimelineZoom
        let maxZoom = DAWTheme.maxZoom
        let referenceZoom = min(max(reference, minZoom), maxZoom)
        let clampedPosition = min(max(position, 0), 1)

        let resolvedZoom: Double
        if referenceZoom <= minZoom + 0.000_001 {
            resolvedZoom = minZoom + (maxZoom - minZoom) * clampedPosition
        } else if clampedPosition <= 0.5 {
            let local = clampedPosition / 0.5
            resolvedZoom = minZoom + (referenceZoom - minZoom) * local
        } else {
            let local = (clampedPosition - 0.5) / 0.5
            resolvedZoom = referenceZoom + (maxZoom - referenceZoom) * local
        }

        setZoom(resolvedZoom)
    }

    func setTrackRowZoom(_ value: Double) {
        trackRowZoom = min(DAWTheme.maxTrackRowZoom, max(DAWTheme.minTrackRowZoom, value))
    }

    func toggleTimelineWrappedCompact() {
        isTimelineWrappedCompact.toggle()
    }

    func togglePhoneTimelineExpanded() {
        isPhoneTimelineExpanded.toggle()
    }

    func phoneTrackRowHeight(for trackID: UUID) -> CGFloat {
        DAWTheme.phoneTrackRowHeight
    }

    func singleLaneRowHeight(isPhone: Bool) -> CGFloat {
        SingleLaneTimelineViews.rowHeight(isPhone: isPhone)
    }

    func trackRowHeight(isCompact: Bool) -> CGFloat {
        let base = isCompact ? DAWTheme.compactTrackRowHeight : DAWTheme.trackRowHeight
        return max(DAWTheme.minTrackRowHeight, base * trackRowZoom)
    }

    func updateTrackRowHeightForInteraction(_ height: CGFloat) {
        trackRowHeightForInteraction = max(DAWTheme.minTrackRowHeight, height)
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
        let clamped = max(0, offset)
        let quantized = (clamped / 4).rounded(.down) * 4
        guard abs(quantized - timelineVisibleOffsetX) >= 4 else { return }
        timelineVisibleOffsetX = quantized
    }

    func flushTimelineVisibleOffset(_ offset: CGFloat) {
        timelineVisibleOffsetX = max(0, offset)
    }

    func setTimelineScrolling(_ isScrolling: Bool) {
        isTimelineScrolling = isScrolling
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
        recordEditSnapshot()
        project.tracks[index].isMuted.toggle()
        audioEngine.updateTrackMixing(project: project)
    }

    func toggleSolo(trackID: UUID) {
        guard let index = project.tracks.firstIndex(where: { $0.id == trackID }) else { return }
        recordEditSnapshot()
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
            if !project.tracks.isEmpty {
                guard configureAudioEngine() else { return }
            }
            refreshAudioDevices()
            reconcileStoredOutputDeviceIfNeeded()
            if wasPlaying {
                playheadTime = resumeTime
                play()
            }
        } catch {
            refreshAudioDevices()
            reportError(error)
        }
    }

#if !os(macOS)
    private func reconcileStoredOutputDeviceIfNeeded() {
        reconcileStoredOutputDevice()
    }
#else
    private func reconcileStoredOutputDeviceIfNeeded() {}
#endif

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

        let wasProcessing = project.usesPitchProcessing(forTrackID: trackID)
        let clamped = PitchShiftSettings.clampSemitones(semitones)
        project.tracks[index].pitchSemitones = clamped
        project.tracks[index].isPitchEnabled = abs(clamped) >= 0.001

        let isProcessing = project.usesPitchProcessing(forTrackID: trackID)
        if wasProcessing != isProcessing {
            _ = configureAudioEngine()
        } else if isProcessing {
            audioEngine.updateTrackPitch(project: project)
        }
        resyncPlaybackIfNeeded()
    }

    func resetSelectedTrackPitch() {
        guard let trackID = activePitchTrack?.id,
              let index = project.tracks.firstIndex(where: { $0.id == trackID })
        else { return }

        let wasProcessing = project.tracks[index].isPitchEnabled
        project.tracks[index].pitchSemitones = 0
        project.tracks[index].isPitchEnabled = false

        if wasProcessing {
            _ = configureAudioEngine()
        }
        resyncPlaybackIfNeeded()
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
        switch timelineTool {
        case .trim:
            guard selectedClipIDs != [clipID] else { return }
            cancelClipTrim()
            selectedClipIDs = [clipID]
        case .arrow:
            if extendSelection {
                if selectedClipIDs.contains(clipID) {
                    selectedClipIDs.remove(clipID)
                } else {
                    selectedClipIDs.insert(clipID)
                }
            } else {
                selectedClipIDs = [clipID]
            }
        default:
            return
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
        let deltaRows = Int((translation / trackRowHeightForInteraction).rounded())
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

        recordEditSnapshot()
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

    func moveClips(anchorTimes: [UUID: TimeInterval], delta: TimeInterval, snap: Bool = true) {
        recordEditSnapshot()

        for trackIndex in project.tracks.indices {
            for clipIndex in project.tracks[trackIndex].clips.indices {
                let clipID = project.tracks[trackIndex].clips[clipIndex].id
                guard let anchor = anchorTimes[clipID] else { continue }

                let rawTime = max(0, anchor + delta)
                let resolvedTime = snap
                    ? SnapGrid.snap(rawTime, interval: project.snapInterval, enabled: project.isSnapEnabled)
                    : rawTime
                project.tracks[trackIndex].clips[clipIndex].startTime = resolvedTime
            }
        }
        audioEngine.syncClipLayout(from: project)
        resyncPlaybackIfNeeded()
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
        recordEditSnapshot()

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
        recordEditSnapshot()
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
            recordEditSnapshot()
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
        recordEditSnapshot()
        project.sections[index].midiNote = min(127, note)
        project.sections[index].midiChannel = min(15, channel)
        project.sections[index].midiUsesControlChange = usesControlChange
        arrangementEngine.configure(sections: project.sections)
    }

    func deleteSection(_ sectionID: UUID) {
        recordEditSnapshot()
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

    @discardableResult
    private func restartAudioPlayback(from time: TimeInterval, force: Bool = false) -> Bool {
        let shouldResumeTimer = playbackTimer != nil
        if shouldResumeTimer {
            stopPlaybackTimer()
        }

        guard startAudioPlayback(from: time) else {
            return false
        }

        lastAudioRestartTimelineTime = time
        lastAudioRestartWallTime = ProcessInfo.processInfo.systemUptime

        if shouldResumeTimer {
            startPlaybackTimer()
        }
        return true
    }

    /// Starts audio for a section trigger using the same path as transport play (reliable on iPad).
    @discardableResult
    private func resumeSectionTriggerPlayback(from time: TimeInterval) -> Bool {
        SectionTriggerDiagnostics.log(String(
            format: "resumeSectionTriggerPlayback at %.3fs (vmPlaying=%d audioPlaying=%d)",
            time,
            isPlaying ? 1 : 0,
            audioEngine.isAnyPlayerPlaying ? 1 : 0
        ))

        playheadTime = time
        playheadPublishAccumulator = 0
        suppressTimelineJumpRestartUntil = Date().addingTimeInterval(1.0)
        arrangementEngine.seek(to: playheadTime)
        arrangementEngine.play()
        arrangementEngine.ensureSectionPlaybackContext(at: playheadTime)
        audioEngine.clearSectionLoopState()

        guard restartAudioPlayback(from: playheadTime, force: true) else {
            SectionTriggerDiagnostics.log("resumeSectionTriggerPlayback restartAudioPlayback failed")
            return false
        }

        if let syncedTime = audioEngine.currentTimelineTime() {
            playheadTime = syncedTime
            arrangementEngine.seek(to: syncedTime)
            lastAudioRestartTimelineTime = syncedTime
        }

        isPlaying = true
        loopPrebufferTriggered = false
        if playbackTimer == nil {
            startPlaybackTimer()
        }
        return true
    }

    /// True when triggering another section should jump immediately instead of waiting for the current one to finish.
    private func preparesImmediateSectionJump(to section: ArrangementSection) -> Bool {
        guard isPlaying, !section.waitForCurrentToFinish else { return false }

        if let current = currentPlaybackSection(), current.id != section.id {
            return true
        }

        if case .waitingToJump = arrangementEngine.state,
           let active = arrangementEngine.activeSection,
           active.id != section.id {
            return true
        }

        return false
    }

    private func currentPlaybackSection() -> ArrangementSection? {
        switch arrangementEngine.state {
        case .playingSection(let section), .repeatingSectionAtEnd(let section):
            return section
        case .waitingToJump:
            return arrangementEngine.activeSection
        case .idle, .continuingTimeline:
            return project.sections.first(where: { $0.contains(time: arrangementEngine.currentTime) })
        }
    }

    func triggerSection(_ section: ArrangementSection) {
        isSelectionLoopEnabled = false
        selectedSectionID = section.id

        if isPlaying {
            arrangementEngine.ensureSectionPlaybackContext(at: arrangementEngine.currentTime)
        }

        if preparesImmediateSectionJump(to: section) {
            suppressTimelineJumpRestartUntil = Date().addingTimeInterval(0.5)
        }

        let result = arrangementEngine.triggerSection(section)
        SectionTriggerDiagnostics.logTrigger(
            sectionName: section.name,
            sectionID: section.id,
            result: result,
            workspacePlaying: isPlaying,
            arrangementPlaying: arrangementEngine.isPlaying,
            audioPlaying: audioEngine.isAnyPlayerPlaying,
            playheadTime: playheadTime,
            arrangementTime: arrangementEngine.currentTime
        )

        midiOutput.sendSectionTrigger(section)
        lastLyricSyncedSectionID = section.id
        sendLyricSlideTrigger(for: section)

        switch result {
        case .queuedForEnd:
            if isPlaying {
                loopPrebufferTriggered = true
                SectionTriggerDiagnostics.logEarlyReturn("queuedForEnd while playing", sectionName: section.name)
                return
            }
        case .enabledRepeatAtEnd:
            if isPlaying {
                if !audioEngine.isAnyPlayerPlaying {
                    SectionTriggerDiagnostics.log(
                        "enabledRepeatAtEnd with silent audio — restarting playback"
                    )
                    if !resumeSectionTriggerPlayback(from: arrangementEngine.currentTime) {
                        pause()
                    }
                } else if let loop = currentSectionLoopContext(at: arrangementEngine.currentTime) {
                    loopPrebufferTriggered = audioEngine.adoptSectionLoopDuringPlayback(
                        project: project,
                        loop: loop,
                        playheadTime: arrangementEngine.currentTime
                    )
                    SectionTriggerDiagnostics.log(
                        "enabledRepeatAtEnd — adopted loop cycles without restart"
                    )
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
                SectionTriggerDiagnostics.log(
                    "resumeSectionTriggerPlayback failed — pausing transport"
                )
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
        }
    }

    func refreshMIDIDevices() {
        MIDIInputService.shared.ensureReady()
        availableMIDISources = MIDIInputService.shared.availableSources()
        connectedMIDISourceName = MIDIInputService.shared.connectedSourceName
    }

    func selectMIDIDevice(_ source: MIDISourceInfo?) {
        recordEditSnapshot()

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
        isMIDIMappingExpanded = enabled
#if os(iOS)
        if DAWTheme.isPhone {
            isPhoneSectionAssignSheetPresented = enabled
        }
#endif
        if enabled {
            Task { await refreshLyricCatalog() }
        } else {
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
            SectionTriggerDiagnostics.log("play() startAudioPlayback failed — pausing arrangement")
            arrangementEngine.pause()
            return
        }

        isPlaying = true
        loopPrebufferTriggered = false
        lastLyricSyncedSectionID = nil
        lastAudioRestartTimelineTime = playheadTime
        lastAudioRestartWallTime = ProcessInfo.processInfo.systemUptime
        suppressTimelineJumpRestartUntil = Date().addingTimeInterval(1.0)
        startPlaybackTimer()
        syncLyricSlideForCurrentPlayhead(force: true)
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
        lastLyricSyncedSectionID = nil
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
            if !restartAudioPlayback(from: playheadTime, force: true) {
                pause()
            }
            syncLyricSlideForCurrentPlayhead(force: true)
        }
    }

    private func shouldSuppressTimelineJumpRestart() -> Bool {
        suppressTimelineJumpRestartUntil.map { Date() < $0 } ?? false
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
            return 0
        }

        let rawDelta = audioTime - previousTime
        if rawDelta >= 0, rawDelta <= 0.5 {
            return rawDelta
        }
        if rawDelta > 0.5, rawDelta <= 1.0, audioTime <= project.duration + 0.25 {
            arrangementEngine.seek(to: audioTime)
            arrangementSyncedToAudioThisTick = true
            SectionTriggerDiagnostics.log(String(
                format: "audio drift sync %.3fs -> %.3fs (delta %.3fs)",
                previousTime,
                audioTime,
                rawDelta
            ))
        } else if rawDelta > 1.0 {
            SectionTriggerDiagnostics.log(String(
                format: "ignored stale audio clock jump %.3fs -> %.3fs (delta %.3fs)",
                previousTime,
                audioTime,
                rawDelta
            ))
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
        syncLyricSlideForCurrentPlayhead()

        if didJumpTimeline, newTime + 0.5 < previousTime {
            scrollTimelineToPlayhead(alignment: .center)
        }

        if isPlaying,
           didJumpTimeline,
           !arrangementSyncedToAudioThisTick {
            if isSectionLoopWrap(from: previousTime, to: newTime)
                || isSectionRepeatWrap(from: previousTime, to: newTime) {
                loopPrebufferTriggered = false
                audioEngine.reanchorPlaybackTimeline(at: newTime)
                let canAppend = audioEngine.isSectionLoopPlaybackActive
                    && appendSectionLoopAudioIfNeeded(from: previousTime, to: newTime)
                if !canAppend {
                    if !restartAudioPlayback(from: newTime, force: true) {
                        pause()
                        return
                    }
                }
            } else if isArrangementSectionTransition(from: previousTime, to: newTime) {
                guard !shouldSuppressTimelineJumpRestart() else { return }
                loopPrebufferTriggered = false
                SectionLoopDiagnostics.log(String(
                    format: "section transition restart %.6fs -> %.6fs",
                    previousTime,
                    newTime
                ))
                if !restartAudioPlayback(from: newTime, force: true) {
                    pause()
                    return
                }
            } else if !shouldSuppressTimelineJumpRestart(),
                      audioEngine.isSamplePlaybackClockEstablished {
                SectionTriggerDiagnostics.log(String(
                    format: "timeline jump restart %.6fs -> %.6fs",
                    previousTime,
                    newTime
                ))
                if !restartAudioPlayback(from: newTime) {
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
