# Graph Report - SimplePlay  (2026-08-14)

## Corpus Check
- 125 files · ~66,236 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 2237 nodes · 5510 edges · 101 communities (93 shown, 8 thin omitted)
- Extraction: 89% EXTRACTED · 11% INFERRED · 0% AMBIGUOUS · INFERRED: 606 edges (avg confidence: 0.8)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `2d6638b7`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- ArrangementSection
- MIDIInputService
- AudioTrack
- SupportedAudioFormats
- .stem
- IOSPlaybackStrategy
- TimelineWorkspacePanel
- CodingKeys
- AudioImportService
- AudioEngineService
- SectionMarkerChipView
- DAWProject
- MIDIMappingBarView
- DAWVerticalFaderView
- TrackOrganizationService
- AudioSettings
- Foundation
- .body
- WaveformCache
- ProjectPersistenceService
- View
- .standardize
- WorkspaceViewModel
- What You Must Do When Invoked
- PitchShiftSettings
- StandardTrackRole
- LyricSlidePickerRow
- .selectedMarkerEditor
- UUID
- CGFloat
- TimeInterval
- TransportToolbarButton
- iPhoneTimelinePanel
- MixerPanelView
- WaveformClipView
- .presentImportPanel
- .importAudioFiles
- TransportBarView
- TimelineOverviewBar
- Float
- DAWGlassChrome
- .stop
- SingleLaneTrackHeaderCell
- TrackHeaderRowView
- .applyRestoredProject
- SectionLoopContext
- Equatable
- .play
- AudioClip
- SectionPlaybackStatus
- LyricPlaySyncClient
- SimplePlay
- ConnectionState
- TrackPitchControlView
- .sectionMappingCard
- ProjectEditHistory
- .transportCircleButton
- TimelineScaleControls
- TransportRightToolbar
- .frames
- TrimEdge
- DAWTheme
- .makeSynchronizedPlaybackAnchor
- TrackGroup
- Bool
- UIKitToolbarMenuButtonRepresentable
- Double
- Audio Engine — Agent Guide
- .recordEditSnapshot
- WorkspaceLayoutContext
- graphify reference: extra exports and benchmark
- iPhoneMIDIMappingBarView
- PinnedTimelineHeaderStrip
- .hex
- graphify reference: query, path, explain
- .body
- WorkspaceSettingsView
- SwiftUI
- graphify reference: add a URL and watch a folder
- graphify reference: commit hook and native AGENTS.md integration
- graphify reference: incremental update and cluster-only
- TopToolbarView.swift
- graphify reference: GitHub clone and cross-repo merge
- graphify reference: transcribe video and audio
- SectionLyricLinkSheet
- extraction-spec.md
- LyricPlaySyncStatusView
- AudioEngineService
- Sendable
- SectionPlaybackMode
- .majorTickInterval
- .sessionManagement
- WorkspacePresentationModifier
- AudioEngineError
- .body
- PropertiesSidebarView
- Panel
- CodingKeys
- AudioDropOverlay
- MIDILearnTarget
- Kind

## God Nodes (most connected - your core abstractions)
1. `WorkspaceViewModel` - 346 edges
2. `DAWProject` - 115 edges
3. `AudioEngineService` - 107 edges
4. `ArrangementSection` - 74 edges
5. `DAWTheme` - 72 edges
6. `MIDIMappingBarView` - 54 edges
7. `AudioTrack` - 49 edges
8. `StandardTrackRole` - 43 edges
9. `ArrangementPlaybackEngine` - 36 edges
10. `MixerPanelView` - 36 edges

## Surprising Connections (you probably didn't know these)
- `.midiLabel` --calls--> `MIDINoteAssignment`  [INFERRED]
  SimplePlay/Features/Workspace/Views/SectionAssignSheetView.swift → SimplePlay/Core/Models/MIDILearnTarget.swift
- `.previewText` --references--> `LyricSlideCatalogItem`  [INFERRED]
  SimplePlay/Features/Workspace/Views/LyricSlidePickerViews.swift → SimplePlay/Core/Services/LyricPlaySyncProtocol.swift
- `TrackOrganizationServiceTests` --calls--> `TrackOrganizationService`  [EXTRACTED]
  SimplePlayTests/TrackOrganizationServiceTests.swift → SimplePlay/Core/Services/TrackOrganizationService.swift
- `.collapsedBar` --references--> `WorkspaceViewModel`  [INFERRED]
  SimplePlay/Features/Workspace/Views/iPhoneMIDIMappingBarView.swift → SimplePlay/Features/Workspace/ViewModels/WorkspaceViewModel.swift
- `.body` --calls--> `TrackLaneView`  [INFERRED]
  SimplePlay/Features/Workspace/Views/iPhoneTimelinePanel.swift → SimplePlay/Features/Workspace/Views/TimelineView.swift

## Import Cycles
- None detected.

## Communities (101 total, 8 thin omitted)

### Community 0 - "ArrangementSection"
Cohesion: 0.06
Nodes (51): ArrangementSection, .color, .duration, .hasLyricSlideLink, CodingKeys, colorHex, endTime, id (+43 more)

### Community 1 - "MIDIInputService"
Cohesion: 0.08
Nodes (24): MIDINotifyProc, MIDIPacket, MIDIPacketList, MIDIInputEvent, MIDIInputService, Bool, Int, Int32 (+16 more)

### Community 2 - "AudioTrack"
Cohesion: 0.20
Nodes (10): AudioTrack, .color, .displayName, Bool, Double, String, UUID, .duration (+2 more)

### Community 3 - "SupportedAudioFormats"
Cohesion: 0.05
Nodes (37): FileDocument, FileWrapper, ReadConfiguration, SimplePlayProjectFileDocument, .readableContentTypes, Data, DropURLLoader, NSItemProvider (+29 more)

### Community 4 - ".stem"
Cohesion: 0.29
Nodes (4): Int, String, TimeInterval, TrackOrganizationServiceTests

### Community 5 - "IOSPlaybackStrategy"
Cohesion: 0.09
Nodes (23): IOSPlaybackStrategy, .meterTapBufferSize, AudioEngineService, AVAudioFile, AVAudioFrameCount, AVAudioFramePosition, AVAudioPlayerNode, AVAudioTime (+15 more)

### Community 6 - "TimelineWorkspacePanel"
Cohesion: 0.17
Nodes (19): ScrollPosition, PlayheadView, .body, .playheadDragGesture, CGFloat, Double, Gesture, String (+11 more)

### Community 7 - "CodingKeys"
Cohesion: 0.08
Nodes (25): CodingKeys, audioSettings, colorHex, id, isLocked, isMuted, isPitchEnabled, isSnapEnabled (+17 more)

### Community 8 - "AudioImportService"
Cohesion: 0.12
Nodes (19): LocalizedError, AudioFileStorageService, String, URL, UUID, AudioImportError, emptySelection, .errorDescription (+11 more)

### Community 9 - "AudioEngineService"
Cohesion: 0.07
Nodes (20): AVAudioEngine, AVAudioUnitEQ, AudioEngineService, .avEngine, .engineIsRunning, .isAnyPlayerPlaying, .isMeterMonitoringEnabled, .isPlaybackGraphReady (+12 more)

### Community 10 - "SectionMarkerChipView"
Cohesion: 0.06
Nodes (48): Bool, String, TimeInterval, .formattedCurrentTime, .formattedDuration, .timelineGuideOverlays, ResizeEdge, end (+40 more)

### Community 11 - "DAWProject"
Cohesion: 0.10
Nodes (18): DAWProject, Bool, Double, Int32, String, TimeInterval, UInt8, UUID (+10 more)

### Community 12 - "MIDIMappingBarView"
Cohesion: 0.10
Nodes (22): Animation, AnyTransition, Color, MIDIMappingBarView, .assignModeToggleTitle, .collapsedBar, .devicePickerLabel, .devicePickerTitle (+14 more)

### Community 13 - "DAWVerticalFaderView"
Cohesion: 0.09
Nodes (25): ClosedRange, Double, Float, String, TrackVolumeSettings, .trackRange, DAWVerticalFaderView, .body (+17 more)

### Community 14 - "TrackOrganizationService"
Cohesion: 0.20
Nodes (11): ImportedStem, ImportPlacement, appendNewGroup, insertIntoGroup, Int, String, TimeInterval, URL (+3 more)

### Community 15 - "AudioSettings"
Cohesion: 0.07
Nodes (26): AnyObject, AVAudioSession, Hashable, AudioOutputDevice, AudioSettings, .usesCustomOutputDevice, Bool, Int (+18 more)

### Community 16 - "Foundation"
Cohesion: 0.11
Nodes (9): AudioUnit, AVFoundation, CoreAudio, CoreMIDI, Foundation, Observation, os, SnapGrid (+1 more)

### Community 17 - ".body"
Cohesion: 0.11
Nodes (16): Notification, NSApplicationDelegate, NSEvent, NSObject, NSView, NSViewRepresentable, NSWindow, .body (+8 more)

### Community 18 - "WaveformCache"
Cohesion: 0.22
Nodes (15): AVAudioPCMBuffer, CheckedContinuation, Bool, Double, Float, Int, MainActor, Never (+7 more)

### Community 19 - "ProjectPersistenceService"
Cohesion: 0.06
Nodes (37): SavedProjectDocument, Int, JSONDecoder, .projectDecoder, JSONEncoder, .pretty, ManifestFile, ProjectPersistenceError (+29 more)

### Community 20 - "View"
Cohesion: 0.14
Nodes (19): Bool, Configuration, String, Void, ToolbarMenuButtonStyleModifier, TopToolbarView, .addTrackMenu, .importButton (+11 more)

### Community 21 - ".standardize"
Cohesion: 0.20
Nodes (7): StandardizedName, Bool, Int, String, URL, TrackNameStandardizer, TrackNameStandardizerTests

### Community 22 - "WorkspaceViewModel"
Cohesion: 0.05
Nodes (33): ClosedRange, Date, Float, Int, Set, WorkspaceViewModel, .activePlaybackSection, .canRedo (+25 more)

### Community 23 - "What You Must Do When Invoked"
Cohesion: 0.08
Nodes (24): For /graphify add and --watch, For /graphify query, For the commit hook and native AGENTS.md integration, For --update and --cluster-only, /graphify, Honesty Rules, Interpreter guard for subcommands, Part A - Structural extraction for code files (+16 more)

### Community 24 - "PitchShiftSettings"
Cohesion: 0.22
Nodes (6): PitchShiftSettings, AVAudioUnitTimePitch, Bool, Double, Float, PitchShiftSettingsTests

### Community 25 - "StandardTrackRole"
Cohesion: 0.08
Nodes (25): StandardTrackRole, acousticGuitar, backingVocal, bass, brass, click, countIn, cue (+17 more)

### Community 26 - "LyricSlidePickerRow"
Cohesion: 0.15
Nodes (16): LyricSlideAssignmentState, available, selectedHere, usedByOtherSection, LyricSlidePickerList, LyricSlidePickerRow, .assignmentBadge, .body (+8 more)

### Community 27 - ".selectedMarkerEditor"
Cohesion: 0.09
Nodes (38): Selection, .audioSettings, .playbackSettings, .sectionEditor, .selectedMarkerEditor, .selectionInfo, .trackPitch, .volumeControls (+30 more)

### Community 28 - "UUID"
Cohesion: 0.11
Nodes (7): ClipMovePreview, Item, .id, UUID, .canSplitSelectedClipAtPlayhead, .splitGesture, .trimGesture

### Community 29 - "CGFloat"
Cohesion: 0.09
Nodes (12): SectionDragKind, move, resizeEnd, resizeStart, CGFloat, TimelineScrollRequest, .minimumTimelineZoom, .timelineContentWidth (+4 more)

### Community 30 - "TimeInterval"
Cohesion: 0.14
Nodes (8): Bool, TimeInterval, Timer, TimelineScrollAlignment, center, leading, start, Content

### Community 31 - "TransportToolbarButton"
Cohesion: 0.25
Nodes (7): .body, Bool, CGFloat, String, Void, TransportToolbarButton, .body

### Community 32 - "iPhoneTimelinePanel"
Cohesion: 0.11
Nodes (20): iPhoneSectionsLabelHeaderCell, .body, iPhoneTimelinePanel, .body, .laneAreaHeight, .magnificationGesture, .phonePinnedHeader, .phoneTrackHeaderColumn (+12 more)

### Community 33 - "MixerPanelView"
Cohesion: 0.06
Nodes (38): MixerPanelView, .body, .channelFaderHeight, .channelFaderWidth, .channelStripWidth, .groupDivider, .isCompact, .masterFaderHeight (+30 more)

### Community 34 - "WaveformClipView"
Cohesion: 0.09
Nodes (28): Float, Int, TimeInterval, URL, WaveformClipPeakStore, CGFloat, Float, Int (+20 more)

### Community 35 - ".presentImportPanel"
Cohesion: 0.21
Nodes (7): ProjectFilePanel, URL, ImportPanelKind, audioFiles, folder, .importMenuItems, .body

### Community 36 - ".importAudioFiles"
Cohesion: 0.14
Nodes (6): Error, Result, String, URL, Content, View

### Community 37 - "TransportBarView"
Cohesion: 0.15
Nodes (13): CGFloat, TransportBarStyle, phoneBottomDock, standard, TransportBarView, .body, .isCompact, .loopButtonColor (+5 more)

### Community 38 - "TimelineOverviewBar"
Cohesion: 0.11
Nodes (20): Path, Bool, CGFloat, CGSize, ClosedRange, Gesture, TimeInterval, TimelineOverviewBar (+12 more)

### Community 39 - "Float"
Cohesion: 0.24
Nodes (5): AVAudioMixerNode, MeterPeakBuffer, Float, UUID, Void

### Community 40 - "DAWGlassChrome"
Cohesion: 0.17
Nodes (10): Glass, DAWGlassChrome, .controlGlass, .panelGlass, CGFloat, Double, LinearGradient, View (+2 more)

### Community 42 - "SingleLaneTrackHeaderCell"
Cohesion: 0.23
Nodes (11): SingleLaneMarkerHeaderCell, .body, SingleLaneStackedClipsLane, .body, SingleLaneTimelineViews, SingleLaneTrackHeaderCell, .body, Bool (+3 more)

### Community 43 - "TrackHeaderRowView"
Cohesion: 0.06
Nodes (37): clips, Bool, Double, UUID, WaveformLoadMonitor, Density, compact, full (+29 more)

### Community 45 - "SectionLoopContext"
Cohesion: 0.17
Nodes (13): SectionLoopContext, .duration, TimeInterval, UUID, SectionLoopDiagnostics, SectionTriggerDiagnostics, AVAudioFrameCount, Bool (+5 more)

### Community 46 - "Equatable"
Cohesion: 0.28
Nodes (14): Equatable, PersistedClip, PersistedProject, PersistedTrack, Bool, Decoder, Double, Encoder (+6 more)

### Community 47 - ".play"
Cohesion: 0.18
Nodes (10): ScheduledClip, AVAudioFile, AVAudioFrameCount, AVAudioPlayerNode, AVAudioTime, AVAudioUnitTimePitch, Int, Int64 (+2 more)

### Community 48 - "AudioClip"
Cohesion: 0.06
Nodes (40): G, GraphicsContext, AudioClip, .endTime, Int, String, TimeInterval, URL (+32 more)

### Community 49 - "SectionPlaybackStatus"
Cohesion: 0.33
Nodes (5): SectionPlaybackStatus, idle, playing, queued, repeatingAtEnd

### Community 50 - "LyricPlaySyncClient"
Cohesion: 0.12
Nodes (13): NWBrowser, NWEndpoint, LyricPlaySyncClient, .isHeartbeatSuspended, serverError, Bool, Never, Set (+5 more)

### Community 51 - "SimplePlay"
Cohesion: 0.20
Nodes (5): SimplePlay, ProjectArchiveTests, SectionMarkerPaletteTests, SimplePlayTests, Testing

### Community 52 - "ConnectionState"
Cohesion: 0.15
Nodes (12): Network, ConnectionState, connected, failed, idle, searching, LyricPlaySyncTransportError, emptyResponse (+4 more)

### Community 53 - "TrackPitchControlView"
Cohesion: 0.15
Nodes (14): .actionButtons, Binding, Bool, Double, String, UUID, TrackPitchControlView, .menuTitle (+6 more)

### Community 54 - ".sectionMappingCard"
Cohesion: 0.16
Nodes (10): MIDINoteAssignment, .displayName, Bool, String, UInt8, SectionMappingAssignButtonStyle, SectionMappingCardGlow, SectionMappingPlayButtonStyle (+2 more)

### Community 55 - "ProjectEditHistory"
Cohesion: 0.10
Nodes (12): ProjectEditHistory, .canRedo, .canUndo, Bool, Int, ProjectEditHistoryTests, SimplePlayUITests, SimplePlayUITestsLaunchTests (+4 more)

### Community 56 - ".transportCircleButton"
Cohesion: 0.60
Nodes (3): Bool, String, Void

### Community 57 - "TimelineScaleControls"
Cohesion: 0.16
Nodes (11): Bool, CGFloat, Double, String, Void, TimelineScaleControls, .buttonCornerRadius, .buttonSize (+3 more)

### Community 58 - "TransportRightToolbar"
Cohesion: 0.24
Nodes (10): .standardTransportBar, Binding, Double, TransportRightToolbar, .buttonCornerRadius, .buttonSize, .mainVolumeIconName, .mainVolumePanel (+2 more)

### Community 59 - ".frames"
Cohesion: 0.24
Nodes (6): Bool, Double, Int64, TimeInterval, TimelineSampleGrid, TimelineSampleGridTests

### Community 60 - "TrimEdge"
Cohesion: 0.67
Nodes (3): TrimEdge, end, start

### Community 61 - "DAWTheme"
Cohesion: 0.20
Nodes (11): .assignButton, .assignModeHeader, .assignModeToggle, .collapsedBarContent, .body, DAWTheme, .isPhone, Bool (+3 more)

### Community 63 - "TrackGroup"
Cohesion: 0.15
Nodes (15): CodingKeys, horizontalOffset, id, importedAt, name, pitchSemitones, volume, Date (+7 more)

### Community 64 - "Bool"
Cohesion: 0.21
Nodes (4): Bool, TimeInterval, UInt64, AVAudioTime

### Community 65 - "UIKitToolbarMenuButtonRepresentable"
Cohesion: 0.33
Nodes (7): Coordinator, Context, String, Void, UIKitToolbarMenuButtonRepresentable, UIButton, UIViewRepresentable

### Community 67 - "Audio Engine — Agent Guide"
Cohesion: 0.20
Nodes (9): Architecture (do not collapse), Audio Engine — Agent Guide, Before you edit, iOS session rules (critical), Log messages, macOS device rules, Red flags (stop and reconsider), Safe change map (+1 more)

### Community 68 - ".recordEditSnapshot"
Cohesion: 0.13
Nodes (4): Bool, TimeInterval, .body, .trackHeaderActions

### Community 69 - "WorkspaceLayoutContext"
Cohesion: 0.10
Nodes (20): EnvironmentKey, iPhoneWorkspaceView, .body, .phoneLayout, StandardWorkspaceView, .workspaceLayout, EnvironmentValues, .workspaceLayout (+12 more)

### Community 70 - "graphify reference: extra exports and benchmark"
Cohesion: 0.22
Nodes (8): graphify reference: extra exports and benchmark, Step 6b - Wiki (only if --wiki flag), Step 7 - Neo4j export (only if --neo4j or --neo4j-push flag), Step 7a - FalkorDB export (only if --falkordb or --falkordb-push flag), Step 7b - SVG export (only if --svg flag), Step 7c - GraphML export (only if --graphml flag), Step 7d - MCP server (only if --mcp flag), Step 8 - Token reduction benchmark (only if total_words > 5000)

### Community 71 - "iPhoneMIDIMappingBarView"
Cohesion: 0.26
Nodes (6): iPhoneMIDIMappingBarView, .collapsedBar, .sectionQuickPads, Bool, String, Void

### Community 72 - "PinnedTimelineHeaderStrip"
Cohesion: 0.24
Nodes (10): PinnedTimelineHeaderStrip, .standardMarkerHeaderRow, .timeHeaderCell, Bool, Content, Int, Void, TimelineAudioDropModifier (+2 more)

### Community 74 - ".hex"
Cohesion: 0.31
Nodes (4): .defaultColor, Int, String, TrackColorPalette

### Community 75 - "graphify reference: query, path, explain"
Cohesion: 0.33
Nodes (5): For /graphify explain, For /graphify path, graphify reference: query, path, explain, Step 0 — Constrained query expansion (REQUIRED before traversal), Step 1 — Traversal

### Community 76 - ".body"
Cohesion: 0.33
Nodes (6): .body, Content, View, .historyControls, .historyControls, .timeDisplay

### Community 79 - "WorkspaceSettingsView"
Cohesion: 0.28
Nodes (7): Binding, Bool, String, WorkspaceSettingsView, .body, .deleteSectionDialogTitle, .sectionDeletionDialogBinding

### Community 80 - "SwiftUI"
Cohesion: 0.10
Nodes (16): App, AppKit, Commands, Scene, ContentView, EditCommands, FileCommands, TransportCommands (+8 more)

### Community 81 - "graphify reference: add a URL and watch a folder"
Cohesion: 0.50
Nodes (3): For /graphify add, For --watch, graphify reference: add a URL and watch a folder

### Community 82 - "graphify reference: commit hook and native AGENTS.md integration"
Cohesion: 0.50
Nodes (3): For git commit hook, For native AGENTS.md integration, graphify reference: commit hook and native AGENTS.md integration

### Community 83 - "graphify reference: incremental update and cluster-only"
Cohesion: 0.50
Nodes (3): For --cluster-only, For --update (incremental re-extraction), graphify reference: incremental update and cluster-only

### Community 84 - "TopToolbarView.swift"
Cohesion: 0.21
Nodes (9): ButtonStyle, DAWIconToolbarButtonStyle, DAWLabeledToolbarButtonStyle, DAWPrimaryButtonStyle, Content, .wrapLayoutButton, .body, .settingsHeader (+1 more)

### Community 87 - "SectionLyricLinkSheet"
Cohesion: 0.28
Nodes (6): .expandedPanel, SectionLyricLinkSheet, .body, .isCompact, .unavailableState, Bool

### Community 89 - "LyricPlaySyncStatusView"
Cohesion: 0.10
Nodes (16): .body, LyricPlaySyncStatusView, .statusColor, .statusSubtitle, .statusTitle, Bool, String, .learnBanner (+8 more)

### Community 91 - "Sendable"
Cohesion: 0.13
Nodes (26): Codable, Sendable, LinkSectionCommand, LyricPlaySync, LyricPlaySyncCodec, LyricPlaySyncMessage, LyricPlaySyncMessageKind, catalogRequest (+18 more)

### Community 92 - "SectionPlaybackMode"
Cohesion: 0.08
Nodes (23): CaseIterable, Double, Identifiable, AudioSampleRate, .displayName, .id, rate44100, rate48000 (+15 more)

### Community 93 - ".majorTickInterval"
Cohesion: 0.19
Nodes (7): CoreGraphics, CGFloat, String, TimeInterval, TimelineRulerScale, .body, TimelineRulerScaleTests

### Community 94 - ".sessionManagement"
Cohesion: 0.60
Nodes (3): .sessionManagement, .projectSessionMenuItems, .body

### Community 95 - "WorkspacePresentationModifier"
Cohesion: 0.20
Nodes (11): ScenePhase, .body, Binding, Bool, String, WorkspacePresentationModifier, .deleteSectionDialogTitle, .sectionDeletionDialogBinding (+3 more)

### Community 96 - "AudioEngineError"
Cohesion: 0.29
Nodes (7): AudioEngineError, clipLoadFailed, deviceSelectionFailed, engineStartFailed, .errorDescription, noPlayableClips, playbackUnavailable

### Community 99 - ".body"
Cohesion: 0.20
Nodes (10): iPhoneMultitrackLaneContent, .body, .phoneTimelineScroll, Bool, CGFloat, Content, TimelineHorizontalMirror, .body (+2 more)

### Community 102 - "PropertiesSidebarView"
Cohesion: 0.15
Nodes (16): PropertiesSidebarView, .body, .pitchIsOriginal, .pitchLabel, .sectionCreationHint, .selectedDeviceID, .selectedSection, .selectedSectionNameBinding (+8 more)

### Community 108 - "Panel"
Cohesion: 0.33
Nodes (5): Panel, mainVolume, none, timelineScale, .body

### Community 115 - "CodingKeys"
Cohesion: 0.25
Nodes (8): CodingKey, CodingKeys, linkedSectionID, order, preview, slideID, tag, text

### Community 120 - "AudioDropOverlay"
Cohesion: 0.33
Nodes (5): AudioDropOverlay, .body, String, TimelineEmptyDropHint, .body

### Community 124 - "MIDILearnTarget"
Cohesion: 0.50
Nodes (3): MIDILearnTarget, section, UUID

### Community 127 - "Kind"
Cohesion: 0.67
Nodes (3): Kind, controlChange, noteOn

## Knowledge Gaps
- **392 isolated node(s):** `id`, `name`, `startTime`, `endTime`, `colorHex` (+387 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **8 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `WorkspaceViewModel` connect `WorkspaceViewModel` to `ArrangementSection`, `MIDIInputService`, `AudioTrack`, `SupportedAudioFormats`, `TimelineWorkspacePanel`, `AudioImportService`, `SectionMarkerChipView`, `DAWProject`, `MIDIMappingBarView`, `TrackOrganizationService`, `AudioSettings`, `Foundation`, `ProjectPersistenceService`, `View`, `LyricSlidePickerRow`, `UUID`, `CGFloat`, `TimeInterval`, `iPhoneTimelinePanel`, `MixerPanelView`, `.presentImportPanel`, `.importAudioFiles`, `TransportBarView`, `TimelineOverviewBar`, `SingleLaneTrackHeaderCell`, `TrackHeaderRowView`, `.applyRestoredProject`, `AudioClip`, `SectionPlaybackStatus`, `LyricPlaySyncClient`, `TrackPitchControlView`, `ProjectEditHistory`, `TimelineScaleControls`, `TransportRightToolbar`, `.frames`, `DAWTheme`, `Double`, `.recordEditSnapshot`, `WorkspaceLayoutContext`, `iPhoneMIDIMappingBarView`, `PinnedTimelineHeaderStrip`, `.body`, `WorkspaceSettingsView`, `SwiftUI`, `SectionLyricLinkSheet`, `LyricPlaySyncStatusView`, `Sendable`, `SectionPlaybackMode`, `.sessionManagement`, `WorkspacePresentationModifier`, `.body`, `PropertiesSidebarView`, `Panel`, `MIDILearnTarget`?**
  _High betweenness centrality (0.405) - this node is a cross-community bridge._
- **Why does `DAWProject` connect `DAWProject` to `ArrangementSection`, `AudioTrack`, `.stem`, `AudioEngineService`, `TrackOrganizationService`, `AudioSettings`, `Foundation`, `ProjectPersistenceService`, `WorkspaceViewModel`, `UUID`, `CGFloat`, `TimeInterval`, `.importAudioFiles`, `.applyRestoredProject`, `SectionLoopContext`, `Equatable`, `.play`, `ProjectEditHistory`, `TrackGroup`, `Double`, `.recordEditSnapshot`, `.hex`, `Sendable`, `SectionPlaybackMode`?**
  _High betweenness centrality (0.101) - this node is a cross-community bridge._
- **Why does `ArrangementSection` connect `ArrangementSection` to `MIDIInputService`, `SectionMarkerChipView`, `DAWProject`, `MIDIMappingBarView`, `WorkspaceViewModel`, `LyricSlidePickerRow`, `.selectedMarkerEditor`, `TimeInterval`, `Equatable`, `SectionPlaybackStatus`, `LyricPlaySyncClient`, `SimplePlay`, `.sectionMappingCard`, `.frames`, `iPhoneMIDIMappingBarView`, `SwiftUI`, `SectionLyricLinkSheet`, `LyricPlaySyncStatusView`, `Sendable`, `SectionPlaybackMode`, `PropertiesSidebarView`?**
  _High betweenness centrality (0.091) - this node is a cross-community bridge._
- **Are the 12 inferred relationships involving `WorkspaceViewModel` (e.g. with `ArrangementPlaybackEngine` and `AudioImportService`) actually correct?**
  _`WorkspaceViewModel` has 12 INFERRED edges - model-reasoned connections that need verification._
- **Are the 58 inferred relationships involving `DAWProject` (e.g. with `.clear()` and `.activeClipMoveGuides`) actually correct?**
  _`DAWProject` has 58 INFERRED edges - model-reasoned connections that need verification._
- **Are the 3 inferred relationships involving `ArrangementSection` (e.g. with `.body` and `.assignsDistinctColorsForDuplicateNames()`) actually correct?**
  _`ArrangementSection` has 3 INFERRED edges - model-reasoned connections that need verification._
- **What connects `id`, `name`, `startTime` to the rest of the system?**
  _392 weakly-connected nodes found - possible documentation gaps or missing edges._