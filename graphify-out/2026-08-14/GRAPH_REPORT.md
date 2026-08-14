# Graph Report - SimplePlay  (2026-08-14)

## Corpus Check
- 110 files · ~60,104 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 2002 nodes · 4931 edges · 92 communities (86 shown, 6 thin omitted)
- Extraction: 90% EXTRACTED · 10% INFERRED · 0% AMBIGUOUS · INFERRED: 493 edges (avg confidence: 0.8)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `10cc11d4`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- ArrangementSection
- MIDIInputService
- WorkspaceViewModel
- SupportedAudioFormats
- WaveformClipView
- Foundation
- TimelineWorkspacePanel
- CodingKeys
- AudioImportService
- AudioEngineService
- SectionMarkerChipView
- .refreshLyricCatalog
- MIDIMappingBarView
- DAWVerticalFaderView
- TrackOrganizationService
- AudioSettings
- WaveformCache
- MacWindowTitleBarHidden.swift
- .play
- SimplePlayProjectArchive
- TopToolbarView
- SwiftUI
- TopToolbarView.swift
- What You Must Do When Invoked
- PitchShiftSettings
- StandardTrackRole
- Equatable
- MacOSPlaybackStrategy
- .standardize
- DAWProject
- TimeInterval
- IOSPlaybackStrategy
- TransportBarView
- MixerPanelView
- View
- .hex
- .importAudioFiles
- TrackPitchControlView
- TimelineOverviewBar
- Float
- DAWGlassChrome
- .stop
- LyricPlaySyncTransportError
- .applyImportedStems
- LyricPlaySyncMessageKind
- .log
- PropertiesSidebarView
- UUID
- .majorTickInterval
- LyricPlaySyncCodec
- LyricPlaySyncClient
- Testing
- .previewRangeForSectionDrag
- FaderMeterStripView
- TrackHeaderRowView
- SimplePlayUITests
- SavedProjectDocument
- ProjectPersistenceService
- UIKitToolbarMenuButtonRepresentable
- .attachClip
- .presentImportPanel
- AudioSampleRate
- .encode
- TrackGroup
- WorkspaceView
- SectionPlaybackMode
- AudioTrack
- Audio Engine — Agent Guide
- AudioClip
- MIDINoteAssignment
- graphify reference: extra exports and benchmark
- WorkspaceSettingsView
- TrackNameStandardizerTests
- ImportToolbarMenuButton.swift
- ProjectPersistenceError
- graphify reference: query, path, explain
- .stop
- .setZoom
- .tracks
- SectionPlaybackStatus
- AVAudioPlayerNode
- graphify reference: add a URL and watch a folder
- graphify reference: commit hook and native AGENTS.md integration
- graphify reference: incremental update and cluster-only
- .selectedMarkerEditor
- graphify reference: GitHub clone and cross-repo merge
- graphify reference: transcribe video and audio
- CGFloat
- extraction-spec.md
- .mixerChannelStrip
- TimelineEditTool
- Sendable

## God Nodes (most connected - your core abstractions)
1. `WorkspaceViewModel` - 303 edges
2. `AudioEngineService` - 107 edges
3. `DAWProject` - 106 edges
4. `ArrangementSection` - 70 edges
5. `DAWTheme` - 54 edges
6. `MIDIMappingBarView` - 48 edges
7. `AudioTrack` - 47 edges
8. `StandardTrackRole` - 43 edges
9. `ArrangementPlaybackEngine` - 36 edges
10. `AudioClip` - 35 edges

## Surprising Connections (you probably didn't know these)
- `.phoneBottomDock` --calls--> `TimelineOverviewBar`  [INFERRED]
  SimplePlay/Features/Workspace/Views/TransportBarView.swift → SimplePlay/Features/Workspace/Views/TimelineOverviewBar.swift
- `.standardTransportBar` --calls--> `TimelineOverviewBar`  [INFERRED]
  SimplePlay/Features/Workspace/Views/TransportBarView.swift → SimplePlay/Features/Workspace/Views/TimelineOverviewBar.swift
- `.actionButtons` --calls--> `TrackPitchControlView`  [INFERRED]
  SimplePlay/Features/Workspace/Views/TopToolbarView.swift → SimplePlay/Features/Workspace/Views/TrackPitchControlView.swift
- `.body` --calls--> `WorkspaceView`  [INFERRED]
  SimplePlay/ContentView.swift → SimplePlay/Features/Workspace/Views/WorkspaceView.swift
- `.body` --references--> `ArrangementSection`  [INFERRED]
  SimplePlay/Features/Workspace/Views/SectionMarkerLaneView.swift → SimplePlay/Core/Models/ArrangementSection.swift

## Import Cycles
- None detected.

## Communities (92 total, 6 thin omitted)

### Community 0 - "ArrangementSection"
Cohesion: 0.05
Nodes (52): ArrangementSection, .color, .duration, .hasLyricSlideLink, CodingKeys, colorHex, endTime, id (+44 more)

### Community 1 - "MIDIInputService"
Cohesion: 0.07
Nodes (27): CoreMIDI, MIDINotifyProc, MIDIPacket, MIDIPacketList, Kind, controlChange, noteOn, MIDIInputEvent (+19 more)

### Community 2 - "WorkspaceViewModel"
Cohesion: 0.06
Nodes (23): Date, Int, Set, Timer, WorkspaceViewModel, .activePlaybackSection, .canSaveDirectlyToCurrentURL, .isArrangementSectionControllingPlayback (+15 more)

### Community 3 - "SupportedAudioFormats"
Cohesion: 0.06
Nodes (37): FileDocument, FileWrapper, ReadConfiguration, SimplePlayProjectFileDocument, .readableContentTypes, Data, DropURLLoader, NSItemProvider (+29 more)

### Community 4 - "WaveformClipView"
Cohesion: 0.09
Nodes (28): Float, Int, TimeInterval, URL, WaveformClipPeakStore, CGFloat, Float, Int (+20 more)

### Community 5 - "Foundation"
Cohesion: 0.11
Nodes (9): AudioUnit, AVFoundation, CoreAudio, Foundation, Observation, AudioEnginePlatformServicesFactory, PlatformPlaybackStrategyFactory, SnapGrid (+1 more)

### Community 6 - "TimelineWorkspacePanel"
Cohesion: 0.09
Nodes (37): ScrollPosition, Bool, CGFloat, Content, TimelineHorizontalMirror, .body, TimelineScrollCoordinator, PinnedTimelineHeaderStrip (+29 more)

### Community 7 - "CodingKeys"
Cohesion: 0.08
Nodes (25): CodingKeys, audioSettings, colorHex, id, isLocked, isMuted, isPitchEnabled, isSnapEnabled (+17 more)

### Community 8 - "AudioImportService"
Cohesion: 0.12
Nodes (18): AudioFileStorageService, String, URL, UUID, AudioImportError, emptySelection, .errorDescription, storageUnavailable (+10 more)

### Community 9 - "AudioEngineService"
Cohesion: 0.07
Nodes (22): AVAudioEngine, AVAudioUnitEQ, AudioEnginePlatformServices, AudioEngineService, .avEngine, .engineIsRunning, .isAnyPlayerPlaying, .isMeterMonitoringEnabled (+14 more)

### Community 10 - "SectionMarkerChipView"
Cohesion: 0.07
Nodes (44): Bool, String, TimeInterval, .formattedCurrentTime, .formattedDuration, ResizeEdge, end, start (+36 more)

### Community 11 - ".refreshLyricCatalog"
Cohesion: 0.32
Nodes (5): .expandedPanel, .lyricCatalogStatus, SectionLyricLinkSheet, .body, .unavailableState

### Community 12 - "MIDIMappingBarView"
Cohesion: 0.09
Nodes (24): Animation, AnyTransition, ButtonStyle, Color, MIDIMappingBarView, .assignModeToggleTitle, .collapsedBar, .collapsedBarContent (+16 more)

### Community 13 - "DAWVerticalFaderView"
Cohesion: 0.09
Nodes (25): ClosedRange, Double, Float, String, TrackVolumeSettings, .trackRange, DAWVerticalFaderView, .body (+17 more)

### Community 14 - "TrackOrganizationService"
Cohesion: 0.21
Nodes (12): ImportedStem, ImportPlacement, appendNewGroup, insertIntoGroup, Int, String, TimeInterval, URL (+4 more)

### Community 15 - "AudioSettings"
Cohesion: 0.07
Nodes (25): AnyObject, AVAudioSession, Hashable, AudioOutputDevice, AudioSettings, .usesCustomOutputDevice, Bool, Int (+17 more)

### Community 16 - "WaveformCache"
Cohesion: 0.22
Nodes (15): AVAudioPCMBuffer, CheckedContinuation, Bool, Double, Float, Int, MainActor, Never (+7 more)

### Community 17 - "MacWindowTitleBarHidden.swift"
Cohesion: 0.11
Nodes (15): Notification, NSApplicationDelegate, NSEvent, NSObject, NSView, NSViewRepresentable, NSWindow, .body (+7 more)

### Community 18 - ".play"
Cohesion: 0.14
Nodes (11): SectionLoopContext, .duration, TimeInterval, UUID, AVAudioFrameCount, Bool, Int, Int64 (+3 more)

### Community 19 - "SimplePlayProjectArchive"
Cohesion: 0.16
Nodes (15): Asset, SimplePlayProjectArchive, SimplePlayProjectArchiveError, corruptAsset, corruptManifest, .errorDescription, invalidArchive, Bool (+7 more)

### Community 20 - "TopToolbarView"
Cohesion: 0.19
Nodes (14): Bool, String, Void, ToolbarMenuButtonStyleModifier, TopToolbarView, .actionButtons, .addTrackMenu, .isCompact (+6 more)

### Community 21 - "SwiftUI"
Cohesion: 0.10
Nodes (15): App, AppKit, Commands, Scene, ContentView, .body, FileCommands, TransportCommands (+7 more)

### Community 22 - "TopToolbarView.swift"
Cohesion: 0.25
Nodes (5): DAWIconToolbarButtonStyle, DAWLabeledToolbarButtonStyle, Content, .body, UIKit

### Community 23 - "What You Must Do When Invoked"
Cohesion: 0.08
Nodes (24): For /graphify add and --watch, For /graphify query, For the commit hook and native AGENTS.md integration, For --update and --cluster-only, /graphify, Honesty Rules, Interpreter guard for subcommands, Part A - Structural extraction for code files (+16 more)

### Community 24 - "PitchShiftSettings"
Cohesion: 0.38
Nodes (5): PitchShiftSettings, AVAudioUnitTimePitch, Bool, Double, Float

### Community 25 - "StandardTrackRole"
Cohesion: 0.08
Nodes (25): StandardTrackRole, acousticGuitar, backingVocal, bass, brass, click, countIn, cue (+17 more)

### Community 26 - "Equatable"
Cohesion: 0.30
Nodes (13): Equatable, PersistedClip, PersistedProject, PersistedTrack, Bool, Decoder, Double, Int32 (+5 more)

### Community 27 - "MacOSPlaybackStrategy"
Cohesion: 0.19
Nodes (11): MacOSPlaybackStrategy, .meterTapBufferSize, AudioEngineService, AVAudioFile, AVAudioFrameCount, AVAudioFramePosition, AVAudioPlayerNode, AVAudioTime (+3 more)

### Community 28 - ".standardize"
Cohesion: 0.30
Nodes (6): StandardizedName, Bool, Int, String, URL, TrackNameStandardizer

### Community 29 - "DAWProject"
Cohesion: 0.12
Nodes (17): DAWProject, Bool, Double, Int32, String, TimeInterval, UInt8, UUID (+9 more)

### Community 30 - "TimeInterval"
Cohesion: 0.17
Nodes (6): Bool, TimeInterval, TimelineScrollAlignment, center, leading, start

### Community 31 - "IOSPlaybackStrategy"
Cohesion: 0.19
Nodes (11): IOSPlaybackStrategy, .meterTapBufferSize, AudioEngineService, AVAudioFile, AVAudioFrameCount, AVAudioFramePosition, AVAudioPlayerNode, AVAudioTime (+3 more)

### Community 32 - "TransportBarView"
Cohesion: 0.10
Nodes (22): Bool, CGFloat, Double, String, Void, TransportBarStyle, phoneBottomDock, standard (+14 more)

### Community 33 - "MixerPanelView"
Cohesion: 0.09
Nodes (21): MixerPanelView, .body, .channelFaderHeight, .channelFaderWidth, .channelStripWidth, .groupDivider, .isCompact, .masterFaderHeight (+13 more)

### Community 34 - "View"
Cohesion: 0.13
Nodes (16): .assignModeToggle, Configuration, .markerHeaderRow, Configuration, AudioDropOverlay, .body, String, TimelineEmptyDropHint (+8 more)

### Community 35 - ".hex"
Cohesion: 0.26
Nodes (5): .defaultColor, Int, Int, String, TrackColorPalette

### Community 36 - ".importAudioFiles"
Cohesion: 0.20
Nodes (5): Error, Result, String, URL, .workspaceRoot

### Community 37 - "TrackPitchControlView"
Cohesion: 0.16
Nodes (13): Binding, Bool, Double, String, UUID, TrackPitchControlView, .menuTitle, .pitchIsOriginal (+5 more)

### Community 38 - "TimelineOverviewBar"
Cohesion: 0.12
Nodes (19): Path, Bool, CGFloat, CGSize, ClosedRange, Gesture, TimeInterval, TimelineOverviewBar (+11 more)

### Community 39 - "Float"
Cohesion: 0.24
Nodes (5): AVAudioMixerNode, MeterPeakBuffer, Float, UUID, Void

### Community 40 - "DAWGlassChrome"
Cohesion: 0.17
Nodes (10): Glass, DAWGlassChrome, .controlGlass, .panelGlass, CGFloat, Double, LinearGradient, View (+2 more)

### Community 42 - "LyricPlaySyncTransportError"
Cohesion: 0.14
Nodes (13): LocalizedError, Network, ConnectionState, connected, failed, idle, searching, LyricPlaySyncTransportError (+5 more)

### Community 44 - "LyricPlaySyncMessageKind"
Cohesion: 0.22
Nodes (9): LyricPlaySyncMessageKind, catalogRequest, catalogResponse, error, linkSection, linkSectionAck, presence, presenceAck (+1 more)

### Community 45 - ".log"
Cohesion: 0.11
Nodes (16): os, SectionLoopDiagnostics, SectionTriggerDiagnostics, AVAudioFrameCount, Bool, Double, Int64, String (+8 more)

### Community 46 - "PropertiesSidebarView"
Cohesion: 0.15
Nodes (16): PropertiesSidebarView, .body, .pitchIsOriginal, .pitchLabel, .sectionCreationHint, .selectedDeviceID, .selectedSection, .selectedSectionNameBinding (+8 more)

### Community 47 - "UUID"
Cohesion: 0.09
Nodes (10): ClipMovePreview, Item, .id, Float, UUID, .canSplitSelectedClipAtPlayhead, .splitGesture, .trimGesture (+2 more)

### Community 48 - ".majorTickInterval"
Cohesion: 0.19
Nodes (7): CoreGraphics, CGFloat, String, TimeInterval, TimelineRulerScale, .body, TimelineRulerScaleTests

### Community 49 - "LyricPlaySyncCodec"
Cohesion: 0.40
Nodes (4): LyricPlaySyncCodec, Data, JSONEncoder, .pretty

### Community 50 - "LyricPlaySyncClient"
Cohesion: 0.23
Nodes (8): NWBrowser, NWEndpoint, LyricPlaySyncClient, Never, Set, TimeInterval, Void, Task

### Community 51 - "Testing"
Cohesion: 0.17
Nodes (5): SimplePlay, PitchShiftSettingsTests, ProjectArchiveTests, SimplePlayTests, Testing

### Community 52 - ".previewRangeForSectionDrag"
Cohesion: 0.18
Nodes (6): SectionDragKind, move, resizeEnd, resizeStart, ClosedRange, .chipMoveOrTapGesture

### Community 53 - "FaderMeterStripView"
Cohesion: 0.15
Nodes (12): .projectMasterStrip, .mainVolumeControl, FaderMeterStripView, .reservesThumbClearance, .showsUnityMark, .usesUnityCenterDecibelScale, Bool, CGFloat (+4 more)

### Community 54 - "TrackHeaderRowView"
Cohesion: 0.06
Nodes (38): clips, Bool, Double, UUID, WaveformLoadMonitor, Density, compact, full (+30 more)

### Community 55 - "SimplePlayUITests"
Cohesion: 0.15
Nodes (6): SimplePlayUITests, SimplePlayUITestsLaunchTests, .runsForEachTargetApplicationUIConfiguration, Bool, XCTest, XCTestCase

### Community 56 - "SavedProjectDocument"
Cohesion: 0.35
Nodes (5): SavedProjectDocument, Int, ManifestFile, Data, .body

### Community 57 - "ProjectPersistenceService"
Cohesion: 0.33
Nodes (5): unsupportedVersion, ProjectPersistenceService, Bool, URL, UUID

### Community 58 - "UIKitToolbarMenuButtonRepresentable"
Cohesion: 0.33
Nodes (7): Coordinator, Context, String, Void, UIKitToolbarMenuButtonRepresentable, UIButton, UIViewRepresentable

### Community 59 - ".attachClip"
Cohesion: 0.19
Nodes (10): AudioEngineError, clipLoadFailed, deviceSelectionFailed, engineStartFailed, .errorDescription, noPlayableClips, playbackUnavailable, ScheduledClip (+2 more)

### Community 60 - ".presentImportPanel"
Cohesion: 0.23
Nodes (7): ProjectFilePanel, String, URL, ImportPanelKind, audioFiles, folder, .importMenuItems

### Community 61 - "AudioSampleRate"
Cohesion: 0.22
Nodes (8): CaseIterable, Double, AudioSampleRate, .displayName, .id, rate44100, rate48000, URL

### Community 63 - "TrackGroup"
Cohesion: 0.14
Nodes (16): CodingKey, CodingKeys, horizontalOffset, id, importedAt, name, pitchSemitones, volume (+8 more)

### Community 64 - "WorkspaceView"
Cohesion: 0.22
Nodes (10): ScenePhase, Binding, Bool, String, WorkspaceLifecycleModifier, WorkspaceView, .body, .deleteSectionDialogTitle (+2 more)

### Community 65 - "SectionPlaybackMode"
Cohesion: 0.25
Nodes (7): SectionPlaybackMode, continueTimeline, continueToNext, .displayName, .id, oneShot, repeatSection

### Community 66 - "AudioTrack"
Cohesion: 0.18
Nodes (10): AudioTrack, .color, .displayName, Bool, Double, String, UUID, .duration (+2 more)

### Community 67 - "Audio Engine — Agent Guide"
Cohesion: 0.20
Nodes (9): Architecture (do not collapse), Audio Engine — Agent Guide, Before you edit, iOS session rules (critical), Log messages, macOS device rules, Red flags (stop and reconsider), Safe change map (+1 more)

### Community 68 - "AudioClip"
Cohesion: 0.06
Nodes (43): G, GraphicsContext, AudioClip, .endTime, Int, String, TimeInterval, URL (+35 more)

### Community 69 - "MIDINoteAssignment"
Cohesion: 0.22
Nodes (8): MIDILearnTarget, section, MIDINoteAssignment, .displayName, Bool, String, UInt8, UUID

### Community 70 - "graphify reference: extra exports and benchmark"
Cohesion: 0.22
Nodes (8): graphify reference: extra exports and benchmark, Step 6b - Wiki (only if --wiki flag), Step 7 - Neo4j export (only if --neo4j or --neo4j-push flag), Step 7a - FalkorDB export (only if --falkordb or --falkordb-push flag), Step 7b - SVG export (only if --svg flag), Step 7c - GraphML export (only if --graphml flag), Step 7d - MCP server (only if --mcp flag), Step 8 - Token reduction benchmark (only if total_words > 5000)

### Community 71 - "WorkspaceSettingsView"
Cohesion: 0.22
Nodes (9): DAWPrimaryButtonStyle, Binding, Bool, String, WorkspaceSettingsView, .body, .deleteSectionDialogTitle, .sectionDeletionDialogBinding (+1 more)

### Community 72 - "TrackNameStandardizerTests"
Cohesion: 0.22
Nodes (3): String, TimeInterval, TrackNameStandardizerTests

### Community 73 - "ImportToolbarMenuButton.swift"
Cohesion: 0.22
Nodes (7): .importButton, .projectSessionButton, .projectSessionMenuItems, ImportToolbarMenuButton, .body, ProjectSessionToolbarMenuButton, .body

### Community 74 - "ProjectPersistenceError"
Cohesion: 0.20
Nodes (9): JSONDecoder, .projectDecoder, ProjectPersistenceError, .errorDescription, invalidPackage, missingAudioFile, missingManifest, Int (+1 more)

### Community 75 - "graphify reference: query, path, explain"
Cohesion: 0.33
Nodes (5): For /graphify explain, For /graphify path, graphify reference: query, path, explain, Step 0 — Constrained query expansion (REQUIRED before traversal), Step 1 — Traversal

### Community 76 - ".stop"
Cohesion: 0.28
Nodes (4): Content, View, .body, .transportControls

### Community 77 - ".setZoom"
Cohesion: 0.31
Nodes (5): .masterVolumeBinding, .masterVolumeBinding, Binding, .masterVolumeBinding, .zoomControls

### Community 78 - ".tracks"
Cohesion: 0.14
Nodes (3): Bool, TimeInterval, Double

### Community 79 - "SectionPlaybackStatus"
Cohesion: 0.40
Nodes (5): SectionPlaybackStatus, idle, playing, queued, repeatingAtEnd

### Community 80 - "AVAudioPlayerNode"
Cohesion: 0.36
Nodes (3): AVAudioFramePosition, AVAudioPlayerNode, AVAudioTime

### Community 81 - "graphify reference: add a URL and watch a folder"
Cohesion: 0.50
Nodes (3): For /graphify add, For --watch, graphify reference: add a URL and watch a folder

### Community 82 - "graphify reference: commit hook and native AGENTS.md integration"
Cohesion: 0.50
Nodes (3): For git commit hook, For native AGENTS.md integration, graphify reference: commit hook and native AGENTS.md integration

### Community 83 - "graphify reference: incremental update and cluster-only"
Cohesion: 0.50
Nodes (3): For --cluster-only, For --update (incremental re-extraction), graphify reference: incremental update and cluster-only

### Community 84 - ".selectedMarkerEditor"
Cohesion: 0.09
Nodes (41): Selection, .learnBanner, .audioSettings, .playbackSettings, .sectionEditor, .selectedMarkerEditor, .selectionInfo, .sessionManagement (+33 more)

### Community 87 - "CGFloat"
Cohesion: 0.11
Nodes (5): CGFloat, TimelineScrollRequest, .minimumTimelineZoom, .timelineContentWidth, .sectionCreationGesture

### Community 89 - ".mixerChannelStrip"
Cohesion: 0.43
Nodes (4): .mixerScrollWithPinnedMasters, Binding, Double, UUID

### Community 90 - "TimelineEditTool"
Cohesion: 0.29
Nodes (6): TimelineEditTool, arrow, hand, split, trim, String

### Community 91 - "Sendable"
Cohesion: 0.23
Nodes (13): Codable, Identifiable, Sendable, serverError, LinkSectionCommand, LyricPlaySync, LyricPlaySyncMessage, LyricSlideCatalog (+5 more)

## Knowledge Gaps
- **346 isolated node(s):** `id`, `name`, `startTime`, `endTime`, `colorHex` (+341 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **6 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `WorkspaceViewModel` connect `WorkspaceViewModel` to `ArrangementSection`, `MIDIInputService`, `SupportedAudioFormats`, `Foundation`, `TimelineWorkspacePanel`, `AudioImportService`, `SectionMarkerChipView`, `.refreshLyricCatalog`, `MIDIMappingBarView`, `TrackOrganizationService`, `AudioSettings`, `TopToolbarView`, `SwiftUI`, `DAWProject`, `TimeInterval`, `TransportBarView`, `MixerPanelView`, `.importAudioFiles`, `TrackPitchControlView`, `TimelineOverviewBar`, `.applyImportedStems`, `.log`, `PropertiesSidebarView`, `UUID`, `LyricPlaySyncClient`, `.previewRangeForSectionDrag`, `TrackHeaderRowView`, `SavedProjectDocument`, `ProjectPersistenceService`, `.presentImportPanel`, `WorkspaceView`, `AudioTrack`, `AudioClip`, `MIDINoteAssignment`, `WorkspaceSettingsView`, `ImportToolbarMenuButton.swift`, `.stop`, `.setZoom`, `.tracks`, `SectionPlaybackStatus`, `CGFloat`, `.mixerChannelStrip`, `TimelineEditTool`, `Sendable`?**
  _High betweenness centrality (0.367) - this node is a cross-community bridge._
- **Why does `DAWProject` connect `DAWProject` to `ArrangementSection`, `WorkspaceViewModel`, `Foundation`, `AudioEngineService`, `TrackOrganizationService`, `AudioSettings`, `.play`, `Equatable`, `TimeInterval`, `.hex`, `.importAudioFiles`, `.applyImportedStems`, `UUID`, `.previewRangeForSectionDrag`, `SavedProjectDocument`, `ProjectPersistenceService`, `.attachClip`, `TrackGroup`, `AudioTrack`, `MIDINoteAssignment`, `TrackNameStandardizerTests`, `.stop`, `.tracks`, `CGFloat`, `Sendable`?**
  _High betweenness centrality (0.092) - this node is a cross-community bridge._
- **Why does `ArrangementSection` connect `ArrangementSection` to `SectionPlaybackMode`, `MIDIInputService`, `WorkspaceViewModel`, `SectionMarkerChipView`, `.refreshLyricCatalog`, `MIDIMappingBarView`, `.log`, `PropertiesSidebarView`, `.selectedMarkerEditor`, `SwiftUI`, `CGFloat`, `Equatable`, `Sendable`, `DAWProject`, `TimeInterval`?**
  _High betweenness centrality (0.091) - this node is a cross-community bridge._
- **Are the 10 inferred relationships involving `WorkspaceViewModel` (e.g. with `ArrangementPlaybackEngine` and `AudioImportService`) actually correct?**
  _`WorkspaceViewModel` has 10 INFERRED edges - model-reasoned connections that need verification._
- **Are the 54 inferred relationships involving `DAWProject` (e.g. with `.activeClipMoveGuides` and `.activeGroupIndex()`) actually correct?**
  _`DAWProject` has 54 INFERRED edges - model-reasoned connections that need verification._
- **Are the 3 inferred relationships involving `ArrangementSection` (e.g. with `.body` and `.assignsDistinctColorsForDuplicateNames()`) actually correct?**
  _`ArrangementSection` has 3 INFERRED edges - model-reasoned connections that need verification._
- **What connects `id`, `name`, `startTime` to the rest of the system?**
  _346 weakly-connected nodes found - possible documentation gaps or missing edges._