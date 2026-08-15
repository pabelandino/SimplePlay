# Graph Report - SimplePlay  (2026-08-14)

## Corpus Check
- 123 files · ~64,959 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 2184 nodes · 5391 edges · 102 communities (94 shown, 8 thin omitted)
- Extraction: 89% EXTRACTED · 11% INFERRED · 0% AMBIGUOUS · INFERRED: 588 edges (avg confidence: 0.8)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `c3d252ac`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- ArrangementSection
- MIDIInputService
- DAWProject
- SupportedAudioFormats
- WaveformClipView
- MacOSPlaybackStrategy
- TimelineWorkspacePanel
- CodingKeys
- AudioImportService
- AudioEngineService
- SectionMarkerChipView
- .selectedMarkerEditor
- MIDIMappingBarView
- DAWVerticalFaderView
- TrackOrganizationService
- AudioSettings
- Foundation
- MacWindowTitleBarHidden.swift
- SwiftUI
- ProjectPersistenceService
- TopToolbarView
- .snap
- WorkspaceViewModel
- What You Must Do When Invoked
- PitchShiftSettings
- StandardTrackRole
- Equatable
- AudioTrack
- UUID
- View
- TimeInterval
- IOSPlaybackStrategy
- TimelineView.swift
- MixerPanelView
- WaveformCache
- UIKitToolbarMenuButtonRepresentable
- .importAudioFiles
- .majorTickInterval
- TimelineOverviewBar
- Float
- DAWGlassChrome
- .stop
- .standardize
- TrackHeaderRowView
- .applyRestoredProject
- .log
- iPhoneTimelinePanel
- .play
- ClipEditService
- Color
- LyricPlaySyncClient
- SimplePlay
- LyricPlaySyncTransportError
- TrackPitchControlView
- .sectionLyricAssignRow
- SimplePlayUITests
- .commitSectionDragPreview
- .clipContent
- TransportRightToolbar
- .frames
- SingleLaneTrackHeaderCell
- MacAppDelegate
- .attachClip
- TrackGroup
- TransportBarView
- SectionPlaybackMode
- .stem
- Audio Engine — Agent Guide
- ViewModifier
- WorkspaceLayoutContext
- graphify reference: extra exports and benchmark
- iPhoneMIDIMappingBarView
- iPhoneTrackHeaderRow
- AudioClip
- SidebarPanel
- graphify reference: query, path, explain
- LyricPlaySyncCodec
- SectionPlaybackStatus
- LyricPlaySyncMessageKind
- WorkspaceSettingsView
- .playbackRenderClockIsLive
- graphify reference: add a URL and watch a folder
- graphify reference: commit hook and native AGENTS.md integration
- graphify reference: incremental update and cluster-only
- .sessionManagement
- graphify reference: GitHub clone and cross-repo merge
- graphify reference: transcribe video and audio
- TimelineHorizontalMirror
- extraction-spec.md
- DAWTheme
- AudioEngineService
- Sendable
- AVAudioTime
- .refreshLyricCatalog
- AudioEngineService
- TrimEdge
- .body
- PinnedTimelineHeaderStrip
- .body
- Double
- PropertiesSidebarView
- WorkspaceLifecycleModifier

## God Nodes (most connected - your core abstractions)
1. `WorkspaceViewModel` - 340 edges
2. `DAWProject` - 114 edges
3. `AudioEngineService` - 107 edges
4. `ArrangementSection` - 73 edges
5. `DAWTheme` - 66 edges
6. `MIDIMappingBarView` - 55 edges
7. `AudioTrack` - 49 edges
8. `StandardTrackRole` - 43 edges
9. `ArrangementPlaybackEngine` - 36 edges
10. `MixerPanelView` - 36 edges

## Surprising Connections (you probably didn't know these)
- `TrackOrganizationServiceTests` --calls--> `TrackOrganizationService`  [EXTRACTED]
  SimplePlayTests/TrackOrganizationServiceTests.swift → SimplePlay/Core/Services/TrackOrganizationService.swift
- `.collapsedBar` --references--> `WorkspaceViewModel`  [INFERRED]
  SimplePlay/Features/Workspace/Views/iPhoneMIDIMappingBarView.swift → SimplePlay/Features/Workspace/ViewModels/WorkspaceViewModel.swift
- `.body` --calls--> `TrackLaneView`  [INFERRED]
  SimplePlay/Features/Workspace/Views/iPhoneTimelinePanel.swift → SimplePlay/Features/Workspace/Views/TimelineView.swift
- `.body` --references--> `ArrangementSection`  [INFERRED]
  SimplePlay/Features/Workspace/Views/SectionMarkerLaneView.swift → SimplePlay/Core/Models/ArrangementSection.swift
- `.duration` --references--> `AudioTrack`  [INFERRED]
  SimplePlay/Core/Models/DAWProject.swift → SimplePlay/Core/Models/AudioTrack.swift

## Import Cycles
- None detected.

## Communities (102 total, 8 thin omitted)

### Community 0 - "ArrangementSection"
Cohesion: 0.05
Nodes (52): ArrangementSection, .color, .duration, .hasLyricSlideLink, CodingKeys, colorHex, endTime, id (+44 more)

### Community 1 - "MIDIInputService"
Cohesion: 0.05
Nodes (35): CoreMIDI, MIDINotifyProc, MIDIPacket, MIDIPacketList, MIDILearnTarget, section, MIDINoteAssignment, .displayName (+27 more)

### Community 2 - "DAWProject"
Cohesion: 0.14
Nodes (15): DAWProject, Bool, Double, Int32, String, TimeInterval, UInt8, UUID (+7 more)

### Community 3 - "SupportedAudioFormats"
Cohesion: 0.06
Nodes (37): FileDocument, FileWrapper, ReadConfiguration, SimplePlayProjectFileDocument, .readableContentTypes, Data, DropURLLoader, NSItemProvider (+29 more)

### Community 4 - "WaveformClipView"
Cohesion: 0.09
Nodes (28): Float, Int, TimeInterval, URL, WaveformClipPeakStore, CGFloat, Float, Int (+20 more)

### Community 5 - "MacOSPlaybackStrategy"
Cohesion: 0.19
Nodes (11): MacOSPlaybackStrategy, .meterTapBufferSize, AudioEngineService, AVAudioFile, AVAudioFrameCount, AVAudioFramePosition, AVAudioPlayerNode, AVAudioTime (+3 more)

### Community 6 - "TimelineWorkspacePanel"
Cohesion: 0.19
Nodes (19): ScrollPosition, PlayheadView, .body, .playheadDragGesture, CGFloat, Double, Gesture, String (+11 more)

### Community 7 - "CodingKeys"
Cohesion: 0.08
Nodes (25): CodingKeys, audioSettings, colorHex, id, isLocked, isMuted, isPitchEnabled, isSnapEnabled (+17 more)

### Community 8 - "AudioImportService"
Cohesion: 0.12
Nodes (18): AudioFileStorageService, String, URL, UUID, AudioImportError, emptySelection, .errorDescription, storageUnavailable (+10 more)

### Community 9 - "AudioEngineService"
Cohesion: 0.07
Nodes (20): AVAudioEngine, AVAudioUnitEQ, AudioEngineService, .avEngine, .engineIsRunning, .isAnyPlayerPlaying, .isMeterMonitoringEnabled, .isPlaybackGraphReady (+12 more)

### Community 10 - "SectionMarkerChipView"
Cohesion: 0.06
Nodes (47): Bool, String, TimeInterval, .formattedCurrentTime, .formattedDuration, .timelineGuideOverlays, ResizeEdge, end (+39 more)

### Community 11 - ".selectedMarkerEditor"
Cohesion: 0.12
Nodes (30): Selection, .audioSettings, .playbackSettings, .sectionEditor, .selectedMarkerEditor, .selectionInfo, .trackPitch, DAWSecondaryButtonStyle (+22 more)

### Community 12 - "MIDIMappingBarView"
Cohesion: 0.10
Nodes (22): Animation, AnyTransition, MIDIMappingBarView, .assignModeToggleTitle, .body, .collapsedBar, .devicePickerLabel, .devicePickerTitle (+14 more)

### Community 13 - "DAWVerticalFaderView"
Cohesion: 0.09
Nodes (25): ClosedRange, Double, Float, String, TrackVolumeSettings, .trackRange, DAWVerticalFaderView, .body (+17 more)

### Community 14 - "TrackOrganizationService"
Cohesion: 0.21
Nodes (11): ImportedStem, ImportPlacement, appendNewGroup, insertIntoGroup, Int, String, TimeInterval, URL (+3 more)

### Community 15 - "AudioSettings"
Cohesion: 0.06
Nodes (31): AnyObject, AVAudioSession, Double, Hashable, AudioOutputDevice, AudioSampleRate, .displayName, .id (+23 more)

### Community 16 - "Foundation"
Cohesion: 0.10
Nodes (9): AudioUnit, AVFoundation, CoreAudio, CoreGraphics, Foundation, Observation, os, SnapGrid (+1 more)

### Community 17 - "MacWindowTitleBarHidden.swift"
Cohesion: 0.19
Nodes (9): NSEvent, NSView, NSViewRepresentable, .body, MacWindowDragRegion, MacWindowTitleBarHidden, Context, WindowDragView (+1 more)

### Community 18 - "SwiftUI"
Cohesion: 0.10
Nodes (14): App, AppKit, Commands, Scene, ContentView, EditCommands, FileCommands, TransportCommands (+6 more)

### Community 19 - "ProjectPersistenceService"
Cohesion: 0.05
Nodes (41): SavedProjectDocument, Int, JSONDecoder, .projectDecoder, ManifestFile, ProjectPersistenceError, .errorDescription, invalidPackage (+33 more)

### Community 20 - "TopToolbarView"
Cohesion: 0.13
Nodes (19): Bool, String, Void, ToolbarMenuButtonStyleModifier, TopToolbarView, .addTrackMenu, .importButton, .isCompact (+11 more)

### Community 21 - ".snap"
Cohesion: 0.13
Nodes (5): Bool, TimeInterval, Int, .trackHeaderActions, .trackHeaderColumnTracksOnly

### Community 22 - "WorkspaceViewModel"
Cohesion: 0.06
Nodes (35): ClipMovePreview, SectionEdgeGuides, CGFloat, ClosedRange, Date, Set, TimelineScrollRequest, WorkspaceViewModel (+27 more)

### Community 23 - "What You Must Do When Invoked"
Cohesion: 0.08
Nodes (24): For /graphify add and --watch, For /graphify query, For the commit hook and native AGENTS.md integration, For --update and --cluster-only, /graphify, Honesty Rules, Interpreter guard for subcommands, Part A - Structural extraction for code files (+16 more)

### Community 24 - "PitchShiftSettings"
Cohesion: 0.24
Nodes (6): PitchShiftSettings, AVAudioUnitTimePitch, Bool, Double, Float, PitchShiftSettingsTests

### Community 25 - "StandardTrackRole"
Cohesion: 0.07
Nodes (29): StandardTrackRole, acousticGuitar, backingVocal, bass, brass, click, countIn, cue (+21 more)

### Community 26 - "Equatable"
Cohesion: 0.23
Nodes (17): Equatable, PersistedClip, PersistedProject, PersistedTrack, Bool, Decoder, Double, Encoder (+9 more)

### Community 27 - "AudioTrack"
Cohesion: 0.14
Nodes (13): AudioTrack, .color, .displayName, Bool, Double, String, UUID, .duration (+5 more)

### Community 28 - "UUID"
Cohesion: 0.08
Nodes (10): Float, UInt8, UUID, .canSplitSelectedClipAtPlayhead, .selectedTrackPitchBinding, .splitGesture, .trimGesture, .faderStrip (+2 more)

### Community 29 - "View"
Cohesion: 0.22
Nodes (9): ButtonStyle, DAWIconToolbarButtonStyle, DAWLabeledToolbarButtonStyle, DAWPrimaryButtonStyle, Configuration, Content, .body, .settingsHeader (+1 more)

### Community 30 - "TimeInterval"
Cohesion: 0.14
Nodes (8): Bool, TimeInterval, Timer, TimelineScrollAlignment, center, leading, start, .transportControls

### Community 31 - "IOSPlaybackStrategy"
Cohesion: 0.19
Nodes (11): IOSPlaybackStrategy, .meterTapBufferSize, AudioEngineService, AVAudioFile, AVAudioFrameCount, AVAudioFramePosition, AVAudioPlayerNode, AVAudioTime (+3 more)

### Community 32 - "TimelineView.swift"
Cohesion: 0.23
Nodes (10): GraphicsContext, .body, CGSize, NSCursor, TimeInterval, Void, TimelineRulerTicksView, TimelineRulerView (+2 more)

### Community 33 - "MixerPanelView"
Cohesion: 0.05
Nodes (43): MixerPanelView, .body, .channelFaderHeight, .channelFaderWidth, .channelStripWidth, .isCompact, .masterFaderHeight, .mastersStripRow (+35 more)

### Community 34 - "WaveformCache"
Cohesion: 0.22
Nodes (15): AVAudioPCMBuffer, CheckedContinuation, Bool, Double, Float, Int, MainActor, Never (+7 more)

### Community 35 - "UIKitToolbarMenuButtonRepresentable"
Cohesion: 0.33
Nodes (7): Coordinator, Context, String, Void, UIKitToolbarMenuButtonRepresentable, UIButton, UIViewRepresentable

### Community 36 - ".importAudioFiles"
Cohesion: 0.19
Nodes (6): Error, Result, String, URL, Content, View

### Community 37 - ".majorTickInterval"
Cohesion: 0.27
Nodes (6): CGFloat, String, TimeInterval, TimelineRulerScale, .body, TimelineRulerScaleTests

### Community 38 - "TimelineOverviewBar"
Cohesion: 0.11
Nodes (21): Path, Bool, CGFloat, CGSize, ClosedRange, Gesture, TimeInterval, TimelineOverviewBar (+13 more)

### Community 39 - "Float"
Cohesion: 0.24
Nodes (5): AVAudioMixerNode, MeterPeakBuffer, Float, UUID, Void

### Community 40 - "DAWGlassChrome"
Cohesion: 0.17
Nodes (10): Glass, DAWGlassChrome, .controlGlass, .panelGlass, CGFloat, Double, LinearGradient, View (+2 more)

### Community 41 - ".stop"
Cohesion: 0.19
Nodes (3): AVAudioNode, .playbackGraphIsHealthy, AVAudioPlayerNode

### Community 42 - ".standardize"
Cohesion: 0.22
Nodes (7): StandardizedName, Bool, Int, String, URL, TrackNameStandardizer, TrackNameStandardizerTests

### Community 43 - "TrackHeaderRowView"
Cohesion: 0.08
Nodes (30): clips, Bool, Double, UUID, WaveformLoadMonitor, Density, compact, full (+22 more)

### Community 45 - ".log"
Cohesion: 0.24
Nodes (9): SectionLoopDiagnostics, SectionTriggerDiagnostics, AVAudioFrameCount, Bool, Double, Int64, String, TimeInterval (+1 more)

### Community 46 - "iPhoneTimelinePanel"
Cohesion: 0.16
Nodes (14): iPhoneSectionsLabelHeaderCell, .body, iPhoneTimelinePanel, .body, .laneAreaHeight, .magnificationGesture, .phonePinnedHeader, .phoneTrackHeaderColumn (+6 more)

### Community 47 - ".play"
Cohesion: 0.15
Nodes (12): SectionLoopContext, .duration, TimeInterval, UUID, AVAudioFrameCount, Bool, Int, Int64 (+4 more)

### Community 48 - "ClipEditService"
Cohesion: 0.26
Nodes (4): ClipEditService, TimeInterval, ClipEditServiceTests, TimeInterval

### Community 49 - "Color"
Cohesion: 0.21
Nodes (5): Color, SectionMappingCardGlow, Bool, CGFloat, Content

### Community 50 - "LyricPlaySyncClient"
Cohesion: 0.23
Nodes (8): NWBrowser, NWEndpoint, LyricPlaySyncClient, Never, Set, TimeInterval, Void, Task

### Community 51 - "SimplePlay"
Cohesion: 0.21
Nodes (4): SimplePlay, ProjectArchiveTests, SimplePlayTests, Testing

### Community 52 - "LyricPlaySyncTransportError"
Cohesion: 0.14
Nodes (13): LocalizedError, Network, ConnectionState, connected, failed, idle, searching, LyricPlaySyncTransportError (+5 more)

### Community 53 - "TrackPitchControlView"
Cohesion: 0.16
Nodes (13): .actionButtons, Binding, Bool, Double, String, UUID, TrackPitchControlView, .menuTitle (+5 more)

### Community 54 - ".sectionLyricAssignRow"
Cohesion: 0.18
Nodes (4): SectionMappingAssignButtonStyle, SectionMappingPlayButtonStyle, Configuration, UIKit

### Community 55 - "SimplePlayUITests"
Cohesion: 0.14
Nodes (7): ProjectEditHistoryTests, SimplePlayUITests, SimplePlayUITestsLaunchTests, .runsForEachTargetApplicationUIConfiguration, Bool, XCTest, XCTestCase

### Community 56 - ".commitSectionDragPreview"
Cohesion: 0.20
Nodes (6): SectionDragKind, move, resizeEnd, resizeStart, .chipMoveOrTapGesture, Gesture

### Community 57 - ".clipContent"
Cohesion: 0.19
Nodes (10): ClipSplitOverlay, .body, .clipWidth, ClipTrimHandle, .handleHitWidth, CGFloat, Gesture, TrackLaneView (+2 more)

### Community 58 - "TransportRightToolbar"
Cohesion: 0.07
Nodes (33): Bool, CGFloat, Double, String, Void, TimelineScaleControls, .body, .buttonCornerRadius (+25 more)

### Community 59 - ".frames"
Cohesion: 0.27
Nodes (6): Bool, Double, Int64, TimeInterval, TimelineSampleGrid, TimelineSampleGridTests

### Community 60 - "SingleLaneTrackHeaderCell"
Cohesion: 0.18
Nodes (13): .singleLaneHeight, SingleLaneMarkerHeaderCell, .body, SingleLaneStackedClipsLane, .body, SingleLaneTimelineViews, SingleLaneTrackHeaderCell, .body (+5 more)

### Community 61 - "MacAppDelegate"
Cohesion: 0.27
Nodes (6): Notification, NSApplicationDelegate, NSObject, NSWindow, MacAppDelegate, MacWindowConfigurator

### Community 62 - ".attachClip"
Cohesion: 0.18
Nodes (10): AudioEngineError, clipLoadFailed, deviceSelectionFailed, engineStartFailed, .errorDescription, noPlayableClips, playbackUnavailable, ScheduledClip (+2 more)

### Community 63 - "TrackGroup"
Cohesion: 0.12
Nodes (19): CodingKey, Identifiable, CodingKeys, horizontalOffset, id, importedAt, name, pitchSemitones (+11 more)

### Community 64 - "TransportBarView"
Cohesion: 0.14
Nodes (15): Bool, CGFloat, String, Void, TransportBarStyle, phoneBottomDock, standard, TransportBarView (+7 more)

### Community 65 - "SectionPlaybackMode"
Cohesion: 0.13
Nodes (13): CaseIterable, SectionPlaybackMode, continueTimeline, continueToNext, .displayName, .id, oneShot, repeatSection (+5 more)

### Community 66 - ".stem"
Cohesion: 0.33
Nodes (3): String, TimeInterval, TrackOrganizationServiceTests

### Community 67 - "Audio Engine — Agent Guide"
Cohesion: 0.20
Nodes (9): Architecture (do not collapse), Audio Engine — Agent Guide, Before you edit, iOS session rules (critical), Log messages, macOS device rules, Red flags (stop and reconsider), Safe change map (+1 more)

### Community 68 - "ViewModifier"
Cohesion: 0.20
Nodes (9): G, ClipDragInteractionModifier, ClipSelectionModifiers, .isExtending, Bool, Content, UUID, TrackLaneDropModifier (+1 more)

### Community 69 - "WorkspaceLayoutContext"
Cohesion: 0.10
Nodes (21): EnvironmentKey, iPhoneWorkspaceView, .body, .phoneLayout, StandardWorkspaceView, .body, .workspaceLayout, EnvironmentValues (+13 more)

### Community 70 - "graphify reference: extra exports and benchmark"
Cohesion: 0.22
Nodes (8): graphify reference: extra exports and benchmark, Step 6b - Wiki (only if --wiki flag), Step 7 - Neo4j export (only if --neo4j or --neo4j-push flag), Step 7a - FalkorDB export (only if --falkordb or --falkordb-push flag), Step 7b - SVG export (only if --svg flag), Step 7c - GraphML export (only if --graphml flag), Step 7d - MCP server (only if --mcp flag), Step 8 - Token reduction benchmark (only if total_words > 5000)

### Community 71 - "iPhoneMIDIMappingBarView"
Cohesion: 0.21
Nodes (8): iPhoneMIDIMappingBarView, .collapsedBar, .devicePickerButton, .phoneDevicePickerSheet, .sectionQuickPads, Bool, String, Void

### Community 72 - "iPhoneTrackHeaderRow"
Cohesion: 0.25
Nodes (7): iPhoneTrackHeaderRow, .body, .displayColor, .liveTrack, Bool, String, Void

### Community 73 - "AudioClip"
Cohesion: 0.36
Nodes (7): AudioClip, .endTime, Int, String, TimeInterval, URL, UUID

### Community 74 - "SidebarPanel"
Cohesion: 0.28
Nodes (8): .volumeControls, SettingsSectionHeader, SidebarLabeledRow, .body, SidebarPanel, .body, Content, String

### Community 75 - "graphify reference: query, path, explain"
Cohesion: 0.33
Nodes (5): For /graphify explain, For /graphify path, graphify reference: query, path, explain, Step 0 — Constrained query expansion (REQUIRED before traversal), Step 1 — Traversal

### Community 76 - "LyricPlaySyncCodec"
Cohesion: 0.40
Nodes (4): LyricPlaySyncCodec, Data, JSONEncoder, .pretty

### Community 77 - "SectionPlaybackStatus"
Cohesion: 0.33
Nodes (5): SectionPlaybackStatus, idle, playing, queued, repeatingAtEnd

### Community 78 - "LyricPlaySyncMessageKind"
Cohesion: 0.22
Nodes (9): LyricPlaySyncMessageKind, catalogRequest, catalogResponse, error, linkSection, linkSectionAck, presence, presenceAck (+1 more)

### Community 79 - "WorkspaceSettingsView"
Cohesion: 0.15
Nodes (13): Binding, Bool, String, WorkspacePresentationModifier, .deleteSectionDialogTitle, .sectionDeletionDialogBinding, Binding, Bool (+5 more)

### Community 81 - "graphify reference: add a URL and watch a folder"
Cohesion: 0.50
Nodes (3): For /graphify add, For --watch, graphify reference: add a URL and watch a folder

### Community 82 - "graphify reference: commit hook and native AGENTS.md integration"
Cohesion: 0.50
Nodes (3): For git commit hook, For native AGENTS.md integration, graphify reference: commit hook and native AGENTS.md integration

### Community 83 - "graphify reference: incremental update and cluster-only"
Cohesion: 0.50
Nodes (3): For --cluster-only, For --update (incremental re-extraction), graphify reference: incremental update and cluster-only

### Community 84 - ".sessionManagement"
Cohesion: 0.60
Nodes (3): .sessionManagement, .projectSessionMenuItems, .body

### Community 87 - "TimelineHorizontalMirror"
Cohesion: 0.40
Nodes (4): Content, TimelineHorizontalMirror, .body, .body

### Community 89 - "DAWTheme"
Cohesion: 0.11
Nodes (19): .assignButton, .body, .assignModeHeader, .assignModeToggle, .collapsedBarContent, .learnBanner, .groupDivider, .pinnedMastersColumn (+11 more)

### Community 90 - "AudioEngineService"
Cohesion: 0.40
Nodes (3): AudioEngineService, AVAudioTime, TimeInterval

### Community 91 - "Sendable"
Cohesion: 0.22
Nodes (13): Codable, Sendable, serverError, LinkSectionCommand, LyricPlaySync, LyricPlaySyncMessage, LyricSlideCatalog, LyricSlideCatalogItem (+5 more)

### Community 93 - ".refreshLyricCatalog"
Cohesion: 0.32
Nodes (5): .expandedPanel, .lyricCatalogStatus, SectionLyricLinkSheet, .body, .unavailableState

### Community 96 - "TrimEdge"
Cohesion: 0.67
Nodes (3): TrimEdge, end, start

### Community 97 - ".body"
Cohesion: 0.21
Nodes (7): .body, Content, View, View, WorkspaceKeyboardShortcuts, .historyControls, .timeDisplay

### Community 98 - "PinnedTimelineHeaderStrip"
Cohesion: 0.24
Nodes (9): PinnedTimelineHeaderStrip, .timeHeaderCell, Bool, Content, Int, Void, TimelineAudioDropModifier, TimelineTrackLaneBackground (+1 more)

### Community 99 - ".body"
Cohesion: 0.17
Nodes (12): iPhoneMultitrackLaneContent, .body, .phoneTimelineScroll, Bool, CGFloat, TimelineScrollCoordinator, .body, AudioDropOverlay (+4 more)

### Community 102 - "PropertiesSidebarView"
Cohesion: 0.14
Nodes (16): PropertiesSidebarView, .body, .masterVolumeBinding, .pitchIsOriginal, .pitchLabel, .sectionCreationHint, .selectedDeviceID, .selectedSection (+8 more)

### Community 104 - "WorkspaceLifecycleModifier"
Cohesion: 0.40
Nodes (5): ScenePhase, .body, WorkspaceLifecycleModifier, WorkspaceView, .body

## Knowledge Gaps
- **377 isolated node(s):** `id`, `name`, `startTime`, `endTime`, `colorHex` (+372 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **8 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `WorkspaceViewModel` connect `WorkspaceViewModel` to `ArrangementSection`, `MIDIInputService`, `DAWProject`, `SupportedAudioFormats`, `TimelineWorkspacePanel`, `AudioImportService`, `SectionMarkerChipView`, `MIDIMappingBarView`, `TrackOrganizationService`, `AudioSettings`, `Foundation`, `SwiftUI`, `ProjectPersistenceService`, `TopToolbarView`, `.snap`, `StandardTrackRole`, `AudioTrack`, `UUID`, `TimeInterval`, `MixerPanelView`, `.importAudioFiles`, `TimelineOverviewBar`, `TrackHeaderRowView`, `.applyRestoredProject`, `iPhoneTimelinePanel`, `ClipEditService`, `Color`, `LyricPlaySyncClient`, `TrackPitchControlView`, `.sectionLyricAssignRow`, `.commitSectionDragPreview`, `.clipContent`, `TransportRightToolbar`, `.frames`, `SingleLaneTrackHeaderCell`, `TransportBarView`, `SectionPlaybackMode`, `ViewModifier`, `WorkspaceLayoutContext`, `iPhoneMIDIMappingBarView`, `iPhoneTrackHeaderRow`, `AudioClip`, `SectionPlaybackStatus`, `WorkspaceSettingsView`, `.sessionManagement`, `DAWTheme`, `Sendable`, `.refreshLyricCatalog`, `.body`, `PinnedTimelineHeaderStrip`, `.body`, `Double`, `PropertiesSidebarView`, `WorkspaceLifecycleModifier`?**
  _High betweenness centrality (0.409) - this node is a cross-community bridge._
- **Why does `DAWProject` connect `DAWProject` to `ArrangementSection`, `MIDIInputService`, `AudioEngineService`, `TrackOrganizationService`, `AudioSettings`, `Foundation`, `ProjectPersistenceService`, `.snap`, `WorkspaceViewModel`, `StandardTrackRole`, `Equatable`, `AudioTrack`, `UUID`, `TimeInterval`, `.importAudioFiles`, `.applyRestoredProject`, `.play`, `.sectionLyricAssignRow`, `.commitSectionDragPreview`, `.attachClip`, `TrackGroup`, `.stem`, `iPhoneTrackHeaderRow`, `Sendable`, `.body`, `Double`?**
  _High betweenness centrality (0.128) - this node is a cross-community bridge._
- **Why does `Foundation` connect `Foundation` to `MIDIInputService`, `SectionPlaybackMode`, `SupportedAudioFormats`, `WaveformClipView`, `DAWProject`, `AudioImportService`, `AudioClip`, `.frames`, `DAWVerticalFaderView`, `AudioSettings`, `.play`, `SwiftUI`, `ProjectPersistenceService`, `LyricPlaySyncTransportError`, `SimplePlay`, `Equatable`, `Sendable`, `TrackGroup`?**
  _High betweenness centrality (0.096) - this node is a cross-community bridge._
- **Are the 13 inferred relationships involving `WorkspaceViewModel` (e.g. with `ArrangementPlaybackEngine` and `AudioImportService`) actually correct?**
  _`WorkspaceViewModel` has 13 INFERRED edges - model-reasoned connections that need verification._
- **Are the 57 inferred relationships involving `DAWProject` (e.g. with `.clear()` and `.activeClipMoveGuides`) actually correct?**
  _`DAWProject` has 57 INFERRED edges - model-reasoned connections that need verification._
- **Are the 3 inferred relationships involving `ArrangementSection` (e.g. with `.body` and `.assignsDistinctColorsForDuplicateNames()`) actually correct?**
  _`ArrangementSection` has 3 INFERRED edges - model-reasoned connections that need verification._
- **What connects `id`, `name`, `startTime` to the rest of the system?**
  _377 weakly-connected nodes found - possible documentation gaps or missing edges._