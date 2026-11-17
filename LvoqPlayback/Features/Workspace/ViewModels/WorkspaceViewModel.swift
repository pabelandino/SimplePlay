//
//  WorkspaceViewModel.swift
//  LvoqPlayback
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
    var projectFileDocument: LvoqPlaybackProjectFileDocument?
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
        audioEngine.prepareGaplessCuts(for: project)
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
    private var isApplicationActive = true
    private var transportState = PlaybackTransportController.TickState(
        loopPrebufferTriggered: false,
        suppressTimelineJumpRestartUntil: nil,
        skipSectionExitHandlingUntil: nil,
        lastAudioTimelineTime: nil,
        lastTransportReanchorWallTime: nil
    )
    private var transportDisplayClock = TransportDisplayClock()
    private var playheadDisplayTimer: Timer?
    private var lastLyricSyncedSectionID: UUID?
    private var lastAudioRestartWallTime: TimeInterval = 0
    private var lastAudioRestartTimelineTime: TimeInterval = -1
    private var editHistory = ProjectEditHistory()
    private var isApplyingEditHistory = false
    private var isSectionTriggerInProgress = false

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

    var sectionForLyricLink: ArrangementSection? {
        guard let sectionIDForLyricLink else { return nil }
        return project.sections.first(where: { $0.id == sectionIDForLyricLink })
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

        if var updatedCatalog = lyricCatalog {
            updatedCatalog.slides = updatedCatalog.slides.map { item in
                var next = item
                if item.slideID == slide.slideID {
                    next.linkedSectionID = sectionID
                } else if item.linkedSectionID == sectionID {
                    next.linkedSectionID = nil
                }
                return next
            }
            lyricCatalog = updatedCatalog
        }

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

        lyricCatalog = lyricCatalog?.clearingSectionLinks(sectionID)
    }

    func lyricSlideLabel(for section: ArrangementSection, catalog: LyricSlideCatalog?) -> String {
        guard section.hasLyricSlideLink else { return L10n.Lyric.noSlide }
        if let catalog,
           let slide = catalog.slides.first(where: { $0.slideID == section.lyricSlideID }) {
            let preview = slide.preview.trimmingCharacters(in: .whitespacesAndNewlines)
            if preview.isEmpty {
                return L10n.Lyric.slideNumber(slide.order + 1)
            }
            return L10n.Lyric.slideNumberPreview(slide.order + 1, preview: preview)
        }
        if let order = section.lyricSlideOrder {
            return L10n.Lyric.slideNumber(order + 1)
        }
        return L10n.Lyric.linkedSlide
    }

    func lyricSlideAssignmentState(
        slide: LyricSlideCatalogItem,
        for sectionID: UUID
    ) -> LyricSlideAssignmentState {
        LyricSlideAssignment.state(
            slideID: slide.slideID,
            currentSectionID: sectionID,
            sections: project.sections,
            catalogLinkedSectionID: slide.linkedSectionID
        )
    }

    var isLvoqShowReachable: Bool {
        if case .connected = lyricSync.connectionState { return true }
        return lyricCatalog != nil
    }

    private func resyncLyricLinksWithLvoqShow() async {
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
        isApplicationActive
            ? TransportClock.activeDisplayInterval
            : TransportClock.backgroundDisplayInterval
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
        SectionCueQueueMonitor.shared.reset()
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
        let notice = L10n.Audio.sampleRateMatched(detected.displayName)
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
        DAWProject(name: L10n.App.untitledProject)
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
        transportState = PlaybackTransportController.TickState(
            loopPrebufferTriggered: false,
            suppressTimelineJumpRestartUntil: nil,
            skipSectionExitHandlingUntil: nil,
            lastAudioTimelineTime: nil,
            lastTransportReanchorWallTime: nil
        )
        transportDisplayClock.clear()
        lastAudioRestartTimelineTime = -1
        lastAudioRestartWallTime = 0

        audioEngine.stop()
        arrangementEngine.pause()

        WaveformLoadMonitor.shared.reset()
        SectionCueQueueMonitor.shared.reset()
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
        normalizeStoredSectionBounds()
        arrangementEngine.configure(sections: project.sections)
        arrangementEngine.seek(to: playheadTime)
        _ = configureAudioEngine()
        applySavedMIDIDeviceConnection()
        clampZoomToTimelineLimits()
        lastLyricSyncedSectionID = nil
        Task { await resyncLyricLinksWithLvoqShow() }
    }

    private func replaceProject(with newProject: DAWProject) {
        stop()
        WaveformLoadMonitor.shared.reset()
        SectionCueQueueMonitor.shared.reset()
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

        // Always play linearly, capped at the section boundary.
        // Loop repetitions are armed with 2 file-segment cycles on the live FIFO
        // (`adoptSectionLoopDuringPlayback`); do not dump cached PCM or pre-queue 16 cycles.
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
        sectionLoop: SectionLoopContext?
    ) -> Bool {
        let scheduleUntil = sectionLoop == nil
            ? SectionPlaybackCoordinator.linearScheduleCap(
                arrangementState: arrangementEngine.state,
                activeSection: arrangementEngine.activeSection,
                pendingSection: arrangementEngine.pendingSection,
                playheadTime: time
            )
            : nil

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

    @discardableResult
    private func armRepeatAudio(loop: SectionLoopContext, playheadTime: TimeInterval) -> Bool {
        let armed: Bool
        if audioEngine.isSectionLoopPlaybackActive {
            // Must actually append. Returning true without a new body leaves
            // `loopPrebufferTriggered` set, so the next wrap finds an empty FIFO.
            armed = audioEngine.appendSectionLoopCycles(project: project, loop: loop)
        } else {
            armed = audioEngine.adoptSectionLoopDuringPlayback(
                project: project,
                loop: loop,
                playheadTime: playheadTime
            )
        }
        if armed {
            SectionTriggerDiagnostics.log(
                String(format: "armRepeatAudio — live FIFO at:nil at %.3fs -> %.3fs", loop.endTime, loop.startTime)
            )
        }
        return armed
    }

    private func completeRepeatAtBoundary(section: ArrangementSection, loop: SectionLoopContext) {
        transportState.loopPrebufferTriggered = false
        let destination = loop.startTime

        SectionLoopDiagnostics.log(String(
            format: "audio-led repeat boundary %.6fs -> %.6fs",
            loop.endTime,
            destination
        ))

        transportState.suppressTimelineJumpRestartUntil = Date().addingTimeInterval(
            TransportClock.boundaryRestartSuppression
        )
        transportState.skipSectionExitHandlingUntil = Date().addingTimeInterval(
            TransportClock.sectionExitSuppression
        )

        arrangementEngine.completeRepeatAtEndBoundary(for: section)

        let preScheduled = audioEngine.hasQueuedLoopBody

        if preScheduled {
            audioEngine.completeRepeatBoundaryJump(at: destination)
            // One-shot wrap: drop loop bookkeeping so the extra cycle is linear
            // `playingSection`. Continuation is armed near the extra cycle's end
            // (`armLinearContinuation`); a pad tap during that cycle can arm
            // another wrap because the FIFO still only holds the extra body.
            audioEngine.releaseRepeatBoundaryLoopMetadata()
            transportState.loopPrebufferTriggered = false
            forcePlaybackClocks(to: destination)
            publishPlayheadTime(destination, force: true)
            syncLyricSlideForCurrentPlayhead()
            SectionLoopDiagnostics.log(
                "one-shot wrap consumed — extra cycle is playingSection (no further loop)"
            )
            return
        }

        audioEngine.clearSectionLoopState()
        audioEngine.cancelArmedBoundaryJump(flushScheduledAudio: false)

        let restarted = audioEngine.seamlessJumpPlayback(
            to: destination,
            project: project,
            scheduleUntil: loop.endTime
        )
        if !restarted, !restartAudioPlayback(from: destination) {
            SectionLoopDiagnostics.log(String(
                format: "repeat boundary audio restart failed at %.6fs",
                destination
            ))
            pause()
            return
        }

        forcePlaybackClocks(to: destination)
        publishPlayheadTime(destination, force: true)
        syncLyricSlideForCurrentPlayhead()
        audioEngine.releaseRepeatBoundaryLoopMetadata()
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

    private func releaseAudioSectionLoopContinuingLinear() {
        guard audioEngine.isSectionLoopPlaybackActive else { return }

        let projectTimelineTime = arrangementEngine.currentTime

        transportState.loopPrebufferTriggered = false
        transportState.lastAudioTimelineTime = projectTimelineTime

        audioEngine.detachSectionLoopKeepingPlayback(at: projectTimelineTime)
    }

    private func forcePlaybackClocks(to time: TimeInterval) {
        arrangementEngine.seek(to: time)
        transportState.lastAudioTimelineTime = time
        lastAudioRestartTimelineTime = time
        playheadTime = time
        playheadPublishAccumulator = 0
        lastAudioRestartWallTime = ProcessInfo.processInfo.systemUptime
        transportDisplayClock.reset(to: time, wallTime: lastAudioRestartWallTime)
    }

    @discardableResult
    private func resolveTimelineAudioJump(to newTime: TimeInterval) -> Bool {
        if audioEngine.hasArmedBoundaryJump(matchingDestination: newTime) {
            transportState.suppressTimelineJumpRestartUntil = Date().addingTimeInterval(
                TransportClock.boundaryRestartSuppression
            )
            transportState.skipSectionExitHandlingUntil = Date().addingTimeInterval(
                TransportClock.sectionExitSuppression
            )

            if audioEngine.isAnyPlayerPlaying {
                audioEngine.completeSectionBoundaryJump(at: newTime)
            } else {
                audioEngine.startAllPrimedStandbys(allowImmediateStart: false)
                audioEngine.completeSectionBoundaryJump(at: newTime)
            }
            transportState.loopPrebufferTriggered = false
            forcePlaybackClocks(to: newTime)

            if !audioEngine.isAnyPlayerPlaying {
                // Destination players are stopped (pre-arm scheduled into a stopped player,
                // or continuation was queued ahead). Use restartAudioPlayback so audio is
                // capped at linearScheduleCap — this keeps loop arm scheduling compatible.
                SectionLoopDiagnostics.log(String(
                    format: "section jump boundary silent — restart to %.6fs",
                    newTime
                ))
                return restartAudioPlayback(from: newTime)
            }
            return true
        }

        // No pre-armed jump: restart with linearScheduleCap so any subsequent loop arm
        // can schedule its cycle at the correct player-relative sample offset.
        audioEngine.clearSectionLoopState()
        return restartAudioPlayback(from: newTime)
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
            projectFileDocument = LvoqPlaybackProjectFileDocument(
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
            projectFileDocument = LvoqPlaybackProjectFileDocument(
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
        SectionCueQueueMonitor.shared.reset()
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
        Task { await resyncLyricLinksWithLvoqShow() }
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
        scrollTimelineToTime(playheadTime, alignment: alignment)
    }

    func scrollTimelineToTime(_ time: TimeInterval, alignment: TimelineScrollAlignment = .center) {
        let playheadX = CGFloat(time) * pixelsPerSecond
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

    func scrollTimelineToTimeIfOffScreen(_ time: TimeInterval) {
        guard TransportClock.isPlayheadOffScreen(
            time: time,
            pixelsPerSecond: Double(pixelsPerSecond),
            visibleOffsetX: Double(timelineVisibleOffsetX),
            viewportWidth: Double(timelineViewportWidth)
        ) else { return }

        scrollTimelineToTime(time, alignment: .center)
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
        audioEngine.prepareGaplessCuts(for: section, in: project)
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

    /// Re-aligns stored section edges so arrangement, UI, and audio loop share the same boundaries.
    private func normalizeStoredSectionBounds() {
        var didChange = false
        for index in project.sections.indices {
            let normalized = normalizedSectionRange(
                start: project.sections[index].startTime,
                end: project.sections[index].endTime
            )
            if project.sections[index].startTime != normalized.start
                || project.sections[index].endTime != normalized.end {
                project.sections[index].startTime = normalized.start
                project.sections[index].endTime = normalized.end
                didChange = true
            }
        }
        if didChange {
            arrangementEngine.configure(sections: project.sections)
        }
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
        let lower = max(0, min(start, end))
        let upper = max(0, max(start, end))
        sectionDragPreviewRange = lower...upper
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

    private func committedSectionRange(from preview: ClosedRange<TimeInterval>) -> (start: TimeInterval, end: TimeInterval) {
        let sampleRate = timelineSampleRate
        let start = TimelineSampleGrid.quantize(preview.lowerBound, sampleRate: sampleRate)
        let end = TimelineSampleGrid.quantize(preview.upperBound, sampleRate: sampleRate)
        let minimumDuration = max(
            project.snapInterval,
            0.25,
            TimelineSampleGrid.sampleDuration(sampleRate: sampleRate)
        )
        return (start, max(end, start + minimumDuration))
    }

    /// Commits the live drag preview with sample-accurate boundaries (no edit-grid snap).
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
            let oldSection = project.sections[index]
            let committed = committedSectionRange(from: previewRange)
            project.sections[index].startTime = committed.start
            project.sections[index].endTime = committed.end
            arrangementEngine.configure(sections: project.sections)

            syncPlaybackAfterSectionBoundsChange(
                oldSection: oldSection,
                newSection: project.sections[index],
                kind: kind
            )
            audioEngine.prepareGaplessCuts(for: project.sections[index], in: project)
        }

        clearSectionDragState()
        clearSectionMovePreview()
    }

    private func syncPlaybackAfterSectionBoundsChange(
        oldSection: ArrangementSection,
        newSection: ArrangementSection,
        kind: SectionDragKind
    ) {
        guard isPlaying else { return }

        let current = arrangementEngine.currentTime
        let wasPlayingThisSection: Bool = {
            switch arrangementEngine.state {
            case .playingSection(let active), .repeatingSectionAtEnd(let active):
                return active.id == oldSection.id
            default:
                return oldSection.contains(time: current)
            }
        }()

        if kind == .move, wasPlayingThisSection {
            let delta = newSection.startTime - oldSection.startTime
            let shifted = max(0, current + delta)
            arrangementEngine.seek(to: shifted)
            publishPlayheadTime(shifted, force: true)
        } else if kind == .resizeStart || kind == .resizeEnd {
            let seekTime = arrangementEngine.currentTime
            if seekTime < newSection.startTime {
                arrangementEngine.seek(to: newSection.startTime)
                publishPlayheadTime(newSection.startTime, force: true)
            } else if seekTime >= newSection.endTime {
                let clamped = max(newSection.startTime, newSection.endTime - 0.001)
                arrangementEngine.seek(to: clamped)
                publishPlayheadTime(clamped, force: true)
            }
        }

        if audioEngine.isSectionLoopPlaybackActive {
            releaseAudioSectionLoopContinuingLinear()
        }

        transportState.lastAudioTimelineTime = nil
        let seekTime = arrangementEngine.currentTime
        if !restartAudioPlayback(from: seekTime, force: true) {
            pause()
        }
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
        purgeReferences(forDeletedSection: sectionID)
        project.sections.removeAll { $0.id == sectionID }
        if selectedSectionID == sectionID {
            selectedSectionID = project.sections.first?.id
        }
        arrangementEngine.configure(sections: project.sections)
        audioEngine.cancelGaplessCuts(for: sectionID)
    }

    private func purgeReferences(forDeletedSection sectionID: UUID) {
        if case .section(let targetID) = midiLearnTarget, targetID == sectionID {
            cancelMIDILearn()
        }
        if lastLyricSyncedSectionID == sectionID {
            lastLyricSyncedSectionID = nil
        }
        if sectionIDForLyricLink == sectionID {
            sectionIDForLyricLink = nil
            isSectionLyricLinkSheetPresented = false
        }
        lyricCatalog = lyricCatalog?.clearingSectionLinks(sectionID)
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

        syncArrangementAndPlaybackClock(fallbackTime: time)

        if shouldResumeTimer {
            startPlaybackTimer()
        }
        return true
    }

    /// After any audio restart/jump, arrangement and UI clocks must match the engine clock.
    private func syncArrangementAndPlaybackClock(fallbackTime: TimeInterval) {
        let wallTime = ProcessInfo.processInfo.systemUptime
        if audioEngine.isSamplePlaybackClockEstablished,
           let resolved = audioEngine.currentTimelineTime() {
            arrangementEngine.seek(to: resolved)
            transportState.lastAudioTimelineTime = resolved
            lastAudioRestartTimelineTime = resolved
            playheadTime = resolved
            transportDisplayClock.reset(to: resolved, wallTime: wallTime)
        } else {
            arrangementEngine.seek(to: fallbackTime)
            transportState.lastAudioTimelineTime = fallbackTime
            lastAudioRestartTimelineTime = fallbackTime
            playheadTime = fallbackTime
            transportDisplayClock.reset(to: fallbackTime, wallTime: wallTime)
        }
        lastAudioRestartWallTime = wallTime
        playheadPublishAccumulator = 0
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
        transportState.suppressTimelineJumpRestartUntil = Date().addingTimeInterval(1.0)
        arrangementEngine.seek(to: playheadTime)
        arrangementEngine.play()
        arrangementEngine.ensureSectionPlaybackContext(at: playheadTime)
        audioEngine.clearSectionLoopState()

        // Seamless is preferred: stops/resets all players and reschedules with an 8 ms
        // lead-in anchor, avoiding a full engine warm-up cycle. scheduleUntil must match
        // linearScheduleCap so capped segments end at the section boundary — this lets
        // adoptSectionLoopDuringPlayback queue file-segment loop cycles at the correct
        // player-relative sample offset without conflicting with an uncapped segment.
        let seamlessCap = SectionPlaybackCoordinator.linearScheduleCap(
            arrangementState: arrangementEngine.state,
            activeSection: arrangementEngine.activeSection,
            pendingSection: arrangementEngine.pendingSection,
            playheadTime: playheadTime
        )
        let started: Bool
        if audioEngine.isAnyPlayerPlaying,
           audioEngine.seamlessJumpPlayback(to: playheadTime, project: project, scheduleUntil: seamlessCap) {
            syncArrangementAndPlaybackClock(fallbackTime: playheadTime)
            started = true
        } else {
            started = restartAudioPlayback(from: playheadTime)
        }

        guard started else {
            SectionTriggerDiagnostics.log("resumeSectionTriggerPlayback audio start failed")
            return false
        }

        isPlaying = true
        transportState.loopPrebufferTriggered = false
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
        isSectionTriggerInProgress = true
        defer { isSectionTriggerInProgress = false }

        if preparesImmediateSectionJump(to: section) {
            audioEngine.cancelArmedBoundaryJump(flushScheduledAudio: false)
            audioEngine.clearSectionLoopState()
            transportState.suppressTimelineJumpRestartUntil = Date().addingTimeInterval(0.5)
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
            if isPlaying,
               let active = arrangementEngine.activeSection,
               let pending = arrangementEngine.pendingSection {

                transportState.loopPrebufferTriggered = audioEngine.armTimelineJumpAtBoundary(
                    boundaryTime: active.endTime,
                    destinationTime: pending.startTime,
                    playheadTime: arrangementEngine.currentTime,
                    destinationEndTime: pending.endTime,
                    destinationSectionID: pending.id
                )
                SectionTriggerDiagnostics.logEarlyReturn("queuedForEnd while playing", sectionName: section.name)
                return
            }
        case .enabledRepeatAtEnd:
            if isPlaying {
                transportState.suppressTimelineJumpRestartUntil = Date().addingTimeInterval(
                    TransportClock.boundaryRestartSuppression
                )
                transportState.skipSectionExitHandlingUntil = Date().addingTimeInterval(
                    TransportClock.sectionExitSuppression
                )
                transportState.loopPrebufferTriggered = false
                if !audioEngine.isAnyPlayerPlaying {
                    SectionTriggerDiagnostics.log(
                        "enabledRepeatAtEnd with silent audio — restarting playback"
                    )
                    if !resumeSectionTriggerPlayback(from: arrangementEngine.currentTime) {
                        pause()
                    }
                } else if let loop = currentSectionLoopContext(at: arrangementEngine.currentTime) {
                    let playhead = arrangementEngine.currentTime
                    let remaining = loop.endTime - playhead
                    if remaining <= SectionPlaybackCoordinator.repeatPrearmLeadTime {
                        transportState.loopPrebufferTriggered = armRepeatAudio(
                            loop: loop,
                            playheadTime: playhead
                        )
                        SectionTriggerDiagnostics.log(
                            "enabledRepeatAtEnd — spliced loop body onto live FIFO (at:nil)"
                        )
                    } else {
                        audioEngine.armLoopBoundaryMetadataOnly(loop: loop)
                        transportState.loopPrebufferTriggered = false
                        SectionTriggerDiagnostics.log(
                            "enabledRepeatAtEnd — metadata only (body spliced near boundary)"
                        )
                    }
                } else {
                    SectionTriggerDiagnostics.log(
                        "enabledRepeatAtEnd — no loop context at playhead"
                    )
                }
                return
            }
        case .disabledRepeatAtEnd:
            if isPlaying {
                transportState.suppressTimelineJumpRestartUntil = Date().addingTimeInterval(
                    TransportClock.boundaryRestartSuppression
                )
                transportState.skipSectionExitHandlingUntil = Date().addingTimeInterval(
                    TransportClock.sectionExitSuppression
                )
                transportState.loopPrebufferTriggered = false

                let playhead = audioEngine.currentTimelineTime() ?? arrangementEngine.currentTime
                if audioEngine.hasQueuedLoopBody {
                    // The extra cycle is already in the FIFO and cannot be unscheduled.
                    // Rebuild linear audio from the real playhead so we do not play that
                    // body (visual ahead / audio looping once more).
                    let restarted = audioEngine.exitSectionLoopToLinearPlayback(
                        at: playhead,
                        project: project
                    ) || restartAudioPlayback(from: playhead)
                    if restarted {
                        forcePlaybackClocks(to: playhead)
                        publishPlayheadTime(playhead, force: true)
                        SectionTriggerDiagnostics.log(
                            String(format: "disabledRepeatAtEnd — flushed extra cycle, linear from %.3fs", playhead)
                        )
                    } else {
                        SectionTriggerDiagnostics.log(
                            "disabledRepeatAtEnd — linear rebuild failed"
                        )
                        pause()
                    }
                } else {
                    audioEngine.cancelArmedBoundaryJump(flushScheduledAudio: false)
                    audioEngine.clearSectionLoopState()
                    SectionTriggerDiagnostics.log(
                        "disabledRepeatAtEnd — metadata cleared, live audio uninterrupted"
                    )
                }
            }
            return
        case .activatedImmediately:
            break
        }

        playheadTime = arrangementEngine.currentTime
        scrollTimelineToTimeIfOffScreen(playheadTime)
        scrollTimelineToPlayhead(alignment: .center)

        if isPlaying {
            guard resumeSectionTriggerPlayback(from: playheadTime) else {
                SectionTriggerDiagnostics.log(
                    "resumeSectionTriggerPlayback failed — pausing transport"
                )
                pause()
                return
            }
            publishPlayheadTime(playheadTime, force: true)
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
                midiLearnStatusMessage = L10n.MIDI.mapped(section: section.name, assignment: assignment.displayName)
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
                midiLearnStatusMessage = L10n.MIDI.connected(source.name)
            } else if !availableMIDISources.isEmpty {
                midiLearnStatusMessage = L10n.MIDI.listeningAll
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
                midiLearnStatusMessage = L10n.MIDI.pressForSection(section.name)
            }
        }
    }

    func cancelMIDILearn() {
        midiLearnTarget = nil
        MIDIInputService.shared.acceptAllSources = false
        lastMIDIInputDebugMessage = nil
        midiLearnStatusMessage = nil
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
        transportState.loopPrebufferTriggered = false
        transportState.lastAudioTimelineTime = nil
        transportState.lastTransportReanchorWallTime = nil
        transportDisplayClock.reset(to: playheadTime, wallTime: ProcessInfo.processInfo.systemUptime)
        lastLyricSyncedSectionID = nil
        lastAudioRestartTimelineTime = playheadTime
        lastAudioRestartWallTime = ProcessInfo.processInfo.systemUptime
        transportState.suppressTimelineJumpRestartUntil = Date().addingTimeInterval(1.0)
        startPlaybackTimer()
        syncLyricSlideForCurrentPlayhead(force: true)
    }

    func pause() {
        isPlaying = false
        transportState.suppressTimelineJumpRestartUntil = nil
        transportState.skipSectionExitHandlingUntil = nil
        audioEngine.pause()
        arrangementEngine.pause()
        playheadTime = arrangementEngine.currentTime
        playheadPublishAccumulator = 0
        transportState.loopPrebufferTriggered = false
        transportState.lastAudioTimelineTime = nil
        transportState.lastTransportReanchorWallTime = nil
        stopPlaybackTimer()
    }

    func stop() {
        isPlaying = false
        transportState.suppressTimelineJumpRestartUntil = nil
        transportState.skipSectionExitHandlingUntil = nil
        playheadTime = 0
        playheadPublishAccumulator = 0
        transportState.loopPrebufferTriggered = false
        transportState.lastAudioTimelineTime = nil
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

    private func publishPlayheadTime(_ time: TimeInterval, force: Bool = false) {
        if force || isPlaying {
            playheadPublishAccumulator = 0
            playheadTime = time
            return
        }

        playheadPublishAccumulator += playbackTickInterval
        guard playheadPublishAccumulator >= TransportClock.backgroundDisplayInterval else { return }
        playheadPublishAccumulator = 0
        playheadTime = time
    }

    private func startPlaybackTimer() {
        stopPlaybackTimer()
        playheadPublishAccumulator = 0
        startPlayheadDisplayTimer()

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
        stopPlayheadDisplayTimer()
    }

    private func resolvedTransportTime(wallTime: TimeInterval = ProcessInfo.processInfo.systemUptime) -> TimeInterval? {
        let sampleTime = audioEngine.currentTimelineTime()
        if let sampleTime {
            transportDisplayClock.commitSample(sampleTime, wallTime: wallTime)
        }
        return transportDisplayClock.resolvedTime(
            isPlaying: isPlaying,
            wallTime: wallTime,
            sampleTime: sampleTime
        ) ?? arrangementEngine.currentTime
    }

    private func tickPlayheadDisplayOnly() {
        guard isPlaying else { return }
        guard let time = resolvedTransportTime() else { return }
        playheadTime = time
    }

    private func startPlayheadDisplayTimer() {
        stopPlayheadDisplayTimer()
        let timer = Timer(timeInterval: TransportClock.activeDisplayInterval, repeats: true) { [weak self] _ in
            guard let self else { return }
            self.tickPlayheadDisplayOnly()
        }
        playheadDisplayTimer = timer
        RunLoop.main.add(timer, forMode: .common)
    }

    private func stopPlayheadDisplayTimer() {
        playheadDisplayTimer?.invalidate()
        playheadDisplayTimer = nil
    }

    private func makeTransportTickInput() -> PlaybackTransportController.TickInput {
        let wallTime = ProcessInfo.processInfo.systemUptime
        let suppressFlags = PlaybackTransportController.resolveSuppressFlags(
            now: Date(),
            state: transportState
        )
        let transportTime = resolvedTransportTime(wallTime: wallTime)

        return PlaybackTransportController.TickInput(
            isPlaying: isPlaying,
            projectDuration: project.duration,
            sampleRate: timelineSampleRate,
            isSelectionLoopEnabled: isSelectionLoopEnabled,
            selectionRange: selectionRange,
            audioTime: transportTime,
            arrangementState: arrangementEngine.state,
            arrangementTime: arrangementEngine.currentTime,
            arrangementIsPlaying: arrangementEngine.isPlaying,
            activeSection: arrangementEngine.activeSection,
            pendingSection: arrangementEngine.pendingSection,
            loopPrebufferTriggered: transportState.loopPrebufferTriggered,
            lastAudioTime: transportState.lastAudioTimelineTime,
            suppressTimelineJumpRestart: suppressFlags.suppressJump,
            skipSectionExitHandling: suppressFlags.skipExit,
            isSectionLoopActive: audioEngine.isSectionLoopPlaybackActive,
            isAnyPlayerPlaying: audioEngine.isAnyPlayerPlaying,
            hasArmedBoundaryJump: audioEngine.hasArmedBoundaryJump
                || audioEngine.isCachedSectionLoopActive,
            isSampleClockEstablished: audioEngine.isSamplePlaybackClockEstablished,
            sections: project.sections,
            wallTime: wallTime
        )
    }

    private func tickPlayback() {
        let output = PlaybackTransportController.tick(
            input: makeTransportTickInput(),
            state: transportState
        ) { [arrangementEngine] time, duration in
            arrangementEngine.advance(to: time, projectDuration: duration)
        }

        transportState = output.state
        applyTransportCommands(output.commands)
        if isPlaying {
            audioEngine.refillLinearContinuation(
                playheadTime: audioEngine.currentTimelineTime() ?? arrangementEngine.currentTime,
                project: project
            )
        }
    }

    private func applyTransportCommands(_ commands: [PlaybackTransportController.TickCommand]) {
        for command in commands {
            switch command {
            case .none:
                break

            case .pauseTransport:
                pause()

            case .publishPlayhead(let time, let force):
                publishPlayheadTime(time, force: force)

            case .seekArrangement(let time):
                arrangementEngine.seek(to: time)

            case .syncLyrics:
                syncLyricSlideForCurrentPlayhead()

            case .scrollToTimeIfOffScreen(let time):
                scrollTimelineToTimeIfOffScreen(time)

            case .completeRepeatBoundary(let section, let loop):
                completeRepeatAtBoundary(section: section, loop: loop)

            case .armRepeatAudio(let loop, let playheadTime):
                transportState.loopPrebufferTriggered = armRepeatAudio(
                    loop: loop,
                    playheadTime: playheadTime
                )

            case .resolveTimelineAudioJump(let time):
                if !resolveTimelineAudioJump(to: time) {
                    pause()
                }

            case .reanchorTransport(let time):
                audioEngine.reanchorPlaybackTimeline(at: time)
                forcePlaybackClocks(to: time)
                transportDisplayClock.reset(to: time, wallTime: ProcessInfo.processInfo.systemUptime)

            case .restartAudioAfterSectionExit(let time, let hadActiveLoop):
                resumeLinearPlaybackAfterSectionExit(at: time, hadActiveLoop: hadActiveLoop)

            case .restartSelectionLoop(at: let time, range: let range):
                if !restartSelectionLoopAudio(at: time, range: range) {
                    pause()
                }

            case .armQueuedSectionJump(let boundary, let destination, let playhead):
                guard !audioEngine.hasArmedBoundaryJump else { break }
                let destEndTime = arrangementEngine.pendingSection?.endTime
                    ?? project.sections.first(where: { abs($0.startTime - destination) < 0.001 })?.endTime
                transportState.loopPrebufferTriggered = audioEngine.armTimelineJumpAtBoundary(
                    boundaryTime: boundary,
                    destinationTime: destination,
                    playheadTime: playhead,
                    destinationEndTime: destEndTime,
                    destinationSectionID: arrangementEngine.pendingSection?.id
                        ?? project.sections.first(where: { abs($0.startTime - destination) < 0.001 })?.id
                )

            case .armContinueToNextJump:
                guard !audioEngine.hasArmedBoundaryJump else { break }
                guard case .playingSection(let section) = arrangementEngine.state,
                      section.playbackMode == .continueToNext,
                      let nextID = section.nextSectionID,
                      let next = project.sections.first(where: { $0.id == nextID }) else { break }

                transportState.loopPrebufferTriggered = audioEngine.armTimelineJumpAtBoundary(
                    boundaryTime: section.endTime,
                    destinationTime: next.startTime,
                    playheadTime: arrangementEngine.currentTime,
                    destinationEndTime: next.endTime,
                    destinationSectionID: next.id
                )

            case .armLinearContinuation(let sectionEnd, let playheadTime):
                guard !audioEngine.hasArmedBoundaryJump else { break }
                guard !audioEngine.isLinearContinuationQueued else { break }
                if audioEngine.armLinearContinuationAtSectionEnd(
                    sectionEnd: sectionEnd,
                    playheadTime: playheadTime,
                    sectionID: arrangementEngine.activeSection?.id
                ) {
                    transportState.loopPrebufferTriggered = true
                }

            }
        }
    }

    private func resumeLinearPlaybackAfterSectionExit(at time: TimeInterval, hadActiveLoop: Bool) {
        // Loop/continuation now live on the same FIFO. If players are still
        // rendering, only reanchor the clock — never play() standbys (got N want: 1).
        if audioEngine.isAnyPlayerPlaying {
            if hadActiveLoop {
                audioEngine.releaseRepeatBoundaryLoopMetadata()
            }
            if audioEngine.isLinearContinuationQueued {
                // Continuation is already on the live FIFO. Reanchoring to section
                // end here (and dumping more file segments) gaps the join.
                syncArrangementAndPlaybackClock(
                    fallbackTime: audioEngine.currentTimelineTime() ?? time
                )
            } else {
                audioEngine.reanchorPlaybackTimeline(at: time)
                audioEngine.clearLinearContinuationQueuedFlag()
                syncArrangementAndPlaybackClock(fallbackTime: time)
            }
            SectionLoopDiagnostics.log(String(
                format: "section exit — live FIFO continue at %.6fs",
                time
            ))
            return
        }

        if audioEngine.hasPrimedStandbyTakeover {
            audioEngine.startAllPrimedStandbys(allowImmediateStart: false)
            if audioEngine.isAnyPlayerPlaying {
                if hadActiveLoop {
                    audioEngine.releaseRepeatBoundaryLoopMetadata()
                }
                audioEngine.reanchorPlaybackTimeline(at: time)
                audioEngine.clearLinearContinuationQueuedFlag()
                syncArrangementAndPlaybackClock(fallbackTime: time)
                SectionLoopDiagnostics.log(String(
                    format: "section exit — standby takeover at %.6fs",
                    time
                ))
                return
            }
        }

        if audioEngine.isAnyPlayerPlaying && audioEngine.isLinearContinuationQueued {
            if hadActiveLoop {
                audioEngine.releaseRepeatBoundaryLoopMetadata()
            }
            audioEngine.reanchorPlaybackTimeline(at: time)
            audioEngine.clearLinearContinuationQueuedFlag()
            syncArrangementAndPlaybackClock(fallbackTime: time)
            SectionLoopDiagnostics.log(String(
                format: "section exit — reanchor in-flight audio at %.6fs",
                time
            ))
            return
        }

        if hadActiveLoop {
            audioEngine.clearSectionLoopState()
        } else {
            releaseAudioSectionLoopContinuingLinear()
        }

        // Seamless path (~8 ms lead-in) only when continuation was not pre-queued.
        if audioEngine.seamlessJumpPlayback(to: time, project: project) {
            syncArrangementAndPlaybackClock(fallbackTime: time)
            SectionLoopDiagnostics.log(String(
                format: "section exit — seamless continue at %.6fs",
                time
            ))
            return
        }

        SectionLoopDiagnostics.log(String(
            format: "section exit — full restart at %.6fs",
            time
        ))
        if !restartAudioPlayback(from: time) {
            pause()
        }
    }
}
