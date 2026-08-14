# Graph Report - SimplePlay  (2026-08-14)

## Corpus Check
- 107 files · ~56,094 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 1920 nodes · 4540 edges · 105 communities (86 shown, 19 thin omitted)
- Extraction: 90% EXTRACTED · 10% INFERRED · 0% AMBIGUOUS · INFERRED: 456 edges (avg confidence: 0.8)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `d7e820e5`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- ArrangementSection
- MIDIInputService
- .body
- SupportedAudioFormats
- .peaks
- AudioClip
- TimelineWorkspacePanel
- CodingKeys
- AudioImportService
- AudioEngineService
- SectionMarkerLaneView
- .selectedMarkerEditor
- MIDIMappingBarView
- DAWVerticalFaderView
- TrackOrganizationService
- AudioSettings
- Foundation
- MacWindowTitleBarHidden.swift
- .play
- SimplePlayProjectArchive
- TopToolbarView
- WorkspaceViewModel
- TrackNameStandardizer
- What You Must Do When Invoked
- PitchShiftSettings
- StandardTrackRole
- Equatable
- .refreshLyricCatalog
- TransportBarView
- DAWProject
- TimeInterval
- IOSPlaybackStrategy
- MacOSPlaybackStrategy
- MixerPanelView
- SavedProjectDocument
- WorkspaceSettingsView
- .applyImportedStems
- View
- TimelineOverviewBar
- Float
- DAWTheme
- .stop
- View
- TrackControlButton
- .applyLoadedProject
- .log
- PropertiesSidebarView
- .attachClip
- .format
- SwiftUI
- LyricPlaySyncClient
- Testing
- FaderMeterStripView
- AudioEngineError
- AppKit
- SimplePlayUITests
- .renderClockIsLive
- TrackPitchControlView
- .setZoom
- .importInitial
- MIDINoteAssignment
- .sessionManagement
- ProjectPersistenceService
- TrackGroup
- WorkspaceView
- SectionPlaybackMode
- AudioTrack
- Audio Engine — Agent Guide
- .snap
- AVAudioFrameCount
- graphify reference: extra exports and benchmark
- ProjectPersistenceError
- SectionMarkerChipView
- .hex
- TimelineHorizontalMirror
- graphify reference: query, path, explain
- .mixerChannelStrip
- LyricPlaySyncMessageKind
- UUID
- SectionPlaybackStatus
- TrackWaveformProgressBar
- graphify reference: add a URL and watch a folder
- graphify reference: commit hook and native AGENTS.md integration
- graphify reference: incremental update and cluster-only
- SimplePlayProjectArchiveError
- graphify reference: GitHub clone and cross-repo merge
- graphify reference: transcribe video and audio
- AudioEngineServiceIOS.swift
- extraction-spec.md
- ConnectionState
- .loadBucket
- Sendable
- .mergesNumberedElectricGuitarsAcrossMultitracks
- SectionMarkerDensity
- LyricPlaySyncCodec
- Decoder
- Encoder
- Int32
- Int64
- Date
- Float
- Set
- Timer
- Content
- Void

## God Nodes (most connected - your core abstractions)
1. `WorkspaceViewModel` - 264 edges
2. `AudioEngineService` - 106 edges
3. `DAWProject` - 90 edges
4. `ArrangementSection` - 55 edges
5. `DAWTheme` - 52 edges
6. `MIDIMappingBarView` - 48 edges
7. `AudioTrack` - 42 edges
8. `StandardTrackRole` - 38 edges
9. `MixerPanelView` - 35 edges
10. `ArrangementPlaybackEngine` - 33 edges

## Surprising Connections (you probably didn't know these)
- `TrackOrganizationServiceTests` --calls--> `TrackOrganizationService`  [EXTRACTED]
  SimplePlayTests/TrackOrganizationServiceTests.swift → SimplePlay/Core/Services/TrackOrganizationService.swift
- `WorkspaceViewModel` --calls--> `AudioImportService`  [INFERRED]
  SimplePlay/Features/Workspace/ViewModels/WorkspaceViewModel.swift → SimplePlay/Core/Services/AudioImportService.swift
- `WorkspaceViewModel` --calls--> `LyricPlaySyncClient`  [INFERRED]
  SimplePlay/Features/Workspace/ViewModels/WorkspaceViewModel.swift → SimplePlay/Core/Services/LyricPlaySyncClient.swift
- `WorkspaceViewModel` --calls--> `ProjectPersistenceService`  [INFERRED]
  SimplePlay/Features/Workspace/ViewModels/WorkspaceViewModel.swift → SimplePlay/Core/Services/ProjectPersistenceService.swift
- `.selectedDeviceID` --references--> `WorkspaceViewModel`  [INFERRED]
  SimplePlay/Features/Workspace/Views/PropertiesSidebarView.swift → SimplePlay/Features/Workspace/ViewModels/WorkspaceViewModel.swift

## Import Cycles
- None detected.

## Communities (105 total, 19 thin omitted)

### Community 0 - "ArrangementSection"
Cohesion: 0.06
Nodes (52): ArrangementSection, .color, .duration, .hasLyricSlideLink, CodingKeys, colorHex, endTime, id (+44 more)

### Community 1 - "MIDIInputService"
Cohesion: 0.07
Nodes (28): CoreMIDI, Identifiable, MIDINotifyProc, MIDIPacket, MIDIPacketList, MIDISourceInfo, Kind, controlChange (+20 more)

### Community 3 - "SupportedAudioFormats"
Cohesion: 0.06
Nodes (37): FileDocument, FileWrapper, ReadConfiguration, SimplePlayProjectFileDocument, .readableContentTypes, Data, DropURLLoader, NSItemProvider (+29 more)

### Community 4 - ".peaks"
Cohesion: 0.09
Nodes (30): AVAudioPCMBuffer, CheckedContinuation, clips, Double, Float, Int, MainActor, Never (+22 more)

### Community 5 - "AudioClip"
Cohesion: 0.07
Nodes (34): G, GraphicsContext, AudioClip, .endTime, Int, String, TimeInterval, URL (+26 more)

### Community 6 - "TimelineWorkspacePanel"
Cohesion: 0.12
Nodes (31): Content, ScrollPosition, PinnedTimelineHeaderStrip, .timeHeaderCell, PlayheadView, .body, .playheadDragGesture, Bool (+23 more)

### Community 7 - "CodingKeys"
Cohesion: 0.08
Nodes (25): CodingKeys, audioSettings, colorHex, id, isLocked, isMuted, isPitchEnabled, isSnapEnabled (+17 more)

### Community 8 - "AudioImportService"
Cohesion: 0.12
Nodes (18): AudioFileStorageService, String, URL, UUID, AudioImportError, emptySelection, .errorDescription, storageUnavailable (+10 more)

### Community 9 - "AudioEngineService"
Cohesion: 0.06
Nodes (21): AVAudioEngine, AVAudioUnitEQ, AudioEnginePlatformServices, AudioEngineService, .avEngine, .engineIsRunning, .isAnyPlayerPlaying, .isMeterMonitoringEnabled (+13 more)

### Community 10 - "SectionMarkerLaneView"
Cohesion: 0.24
Nodes (12): SectionCreationPreviewView, .body, SectionDragSession, SectionMarkerLaneView, .body, .creationDragMinimumDistance, .creationHint, CGFloat (+4 more)

### Community 11 - ".selectedMarkerEditor"
Cohesion: 0.09
Nodes (39): Selection, .audioSettings, .playbackSettings, .sectionEditor, .selectedMarkerEditor, .selectionInfo, .trackPitch, .volumeControls (+31 more)

### Community 12 - "MIDIMappingBarView"
Cohesion: 0.10
Nodes (19): Animation, AnyTransition, Color, MIDIMappingBarView, .assignModeToggleTitle, .body, .collapsedBar, .collapsedBarContent (+11 more)

### Community 13 - "DAWVerticalFaderView"
Cohesion: 0.09
Nodes (25): ClosedRange, Double, Float, String, TrackVolumeSettings, .trackRange, DAWVerticalFaderView, .body (+17 more)

### Community 14 - "TrackOrganizationService"
Cohesion: 0.27
Nodes (9): ImportedStem, ImportPlacement, appendNewGroup, insertIntoGroup, Int, String, TimeInterval, URL (+1 more)

### Community 15 - "AudioSettings"
Cohesion: 0.07
Nodes (28): AnyObject, AVAudioSession, Double, Hashable, AudioOutputDevice, AudioSampleRate, .displayName, .id (+20 more)

### Community 16 - "Foundation"
Cohesion: 0.12
Nodes (9): AudioUnit, AVFoundation, CoreAudio, Foundation, Observation, os, AudioEnginePlatformServicesFactory, PlatformPlaybackStrategyFactory (+1 more)

### Community 17 - "MacWindowTitleBarHidden.swift"
Cohesion: 0.11
Nodes (15): Notification, NSApplicationDelegate, NSEvent, NSObject, NSView, NSViewRepresentable, NSWindow, .body (+7 more)

### Community 18 - ".play"
Cohesion: 0.20
Nodes (11): SectionLoopContext, .duration, TimeInterval, UUID, AVAudioFrameCount, Bool, Int, Int64 (+3 more)

### Community 19 - "SimplePlayProjectArchive"
Cohesion: 0.25
Nodes (9): Asset, SimplePlayProjectArchive, Bool, Data, Int, UInt32, UInt64, URL (+1 more)

### Community 20 - "TopToolbarView"
Cohesion: 0.13
Nodes (19): Bool, String, Void, ToolbarMenuButtonStyleModifier, TopToolbarView, .importButton, .importMenuItems, .isCompact (+11 more)

### Community 21 - "WorkspaceViewModel"
Cohesion: 0.06
Nodes (31): AudioOutputDevice, Date, SectionPlaybackMode, Set, SectionDragKind, move, resizeEnd, resizeStart (+23 more)

### Community 22 - "TrackNameStandardizer"
Cohesion: 0.21
Nodes (8): StandardizedName, Bool, Int, StandardTrackRole, String, URL, TrackNameStandardizer, TrackNameStandardizerTests

### Community 23 - "What You Must Do When Invoked"
Cohesion: 0.08
Nodes (24): For /graphify add and --watch, For /graphify query, For the commit hook and native AGENTS.md integration, For --update and --cluster-only, /graphify, Honesty Rules, Interpreter guard for subcommands, Part A - Structural extraction for code files (+16 more)

### Community 24 - "PitchShiftSettings"
Cohesion: 0.24
Nodes (6): PitchShiftSettings, AVAudioUnitTimePitch, Bool, Double, Float, PitchShiftSettingsTests

### Community 25 - "StandardTrackRole"
Cohesion: 0.08
Nodes (25): StandardTrackRole, acousticGuitar, backingVocal, bass, brass, click, countIn, cue (+17 more)

### Community 26 - "Equatable"
Cohesion: 0.17
Nodes (21): AudioSettings, Decoder, Encoder, Equatable, Int32, MIDILearnTarget, section, UUID (+13 more)

### Community 27 - ".refreshLyricCatalog"
Cohesion: 0.32
Nodes (5): .expandedPanel, .lyricCatalogStatus, SectionLyricLinkSheet, .body, .unavailableState

### Community 28 - "TransportBarView"
Cohesion: 0.11
Nodes (20): Bool, CGFloat, Double, String, Void, TransportBarStyle, phoneBottomDock, standard (+12 more)

### Community 29 - "DAWProject"
Cohesion: 0.12
Nodes (16): MIDIInputEvent, MIDILearnTarget, DAWProject, Bool, Double, Int32, String, TimeInterval (+8 more)

### Community 30 - "TimeInterval"
Cohesion: 0.11
Nodes (11): SectionEdgeGuides, ArrangementSection, Bool, SectionLoopContext, TimeInterval, TimelineScrollAlignment, center, leading (+3 more)

### Community 31 - "IOSPlaybackStrategy"
Cohesion: 0.19
Nodes (11): IOSPlaybackStrategy, .meterTapBufferSize, AudioEngineService, AVAudioFile, AVAudioFrameCount, AVAudioFramePosition, AVAudioPlayerNode, AVAudioTime (+3 more)

### Community 32 - "MacOSPlaybackStrategy"
Cohesion: 0.19
Nodes (11): MacOSPlaybackStrategy, .meterTapBufferSize, AudioEngineService, AVAudioFile, AVAudioFrameCount, AVAudioFramePosition, AVAudioPlayerNode, AVAudioTime (+3 more)

### Community 33 - "MixerPanelView"
Cohesion: 0.10
Nodes (21): MixerPanelView, .body, .channelFaderHeight, .channelFaderWidth, .channelStripWidth, .groupDivider, .isCompact, .masterFaderHeight (+13 more)

### Community 34 - "SavedProjectDocument"
Cohesion: 0.19
Nodes (9): SavedProjectDocument, DAWProject, Int, Data, ProjectFilePanel, String, URL, .body (+1 more)

### Community 35 - "WorkspaceSettingsView"
Cohesion: 0.33
Nodes (6): Binding, Bool, String, WorkspaceSettingsView, .deleteSectionDialogTitle, .sectionDeletionDialogBinding

### Community 36 - ".applyImportedStems"
Cohesion: 0.12
Nodes (10): Error, Result, ImportPanelKind, audioFiles, folder, String, TrackOrganizationService, URL (+2 more)

### Community 37 - "View"
Cohesion: 0.12
Nodes (15): ButtonStyle, SectionMappingAssignButtonStyle, SectionMappingCardGlow, SectionMappingPlayButtonStyle, Bool, Configuration, Content, DAWIconToolbarButtonStyle (+7 more)

### Community 38 - "TimelineOverviewBar"
Cohesion: 0.11
Nodes (21): Path, Bool, CGFloat, CGSize, ClosedRange, Gesture, TimeInterval, TimelineOverviewBar (+13 more)

### Community 39 - "Float"
Cohesion: 0.24
Nodes (5): AVAudioMixerNode, MeterPeakBuffer, Float, UUID, Void

### Community 40 - "DAWTheme"
Cohesion: 0.09
Nodes (24): Glass, .assignModeToggle, .learnBanner, .markerHeaderRow, AudioDropOverlay, .body, String, TimelineEmptyDropHint (+16 more)

### Community 42 - "View"
Cohesion: 0.25
Nodes (14): Color, sectionChipSurface(), SectionEdgeGuideOverlay, .body, SectionMarkerGhostChipView, .body, SectionMarkerLabelContent, .body (+6 more)

### Community 43 - "TrackControlButton"
Cohesion: 0.22
Nodes (8): PanKnobView, .body, Bool, Double, String, Void, TrackControlButton, .body

### Community 45 - ".log"
Cohesion: 0.12
Nodes (17): ArrangementPlaybackEngine, AVAudioFrameCount, Int64, SectionLoopDiagnostics, SectionTriggerDiagnostics, Bool, Double, SectionLoopContext (+9 more)

### Community 46 - "PropertiesSidebarView"
Cohesion: 0.14
Nodes (17): PropertiesSidebarView, .body, .pitchIsOriginal, .pitchLabel, .sectionCreationHint, .selectedDevice, .selectedDeviceID, .selectedSection (+9 more)

### Community 47 - ".attachClip"
Cohesion: 0.23
Nodes (6): ScheduledClip, AVAudioFile, AVAudioFramePosition, AVAudioPlayerNode, AVAudioTime, AVAudioUnitTimePitch

### Community 48 - ".format"
Cohesion: 0.25
Nodes (6): Bool, String, TimeInterval, TimeFormatting, .formattedCurrentTime, .formattedDuration

### Community 49 - "SwiftUI"
Cohesion: 0.15
Nodes (9): Commands, ContentView, .body, FileCommands, TransportCommands, View, WorkspaceKeyboardShortcuts, .body (+1 more)

### Community 50 - "LyricPlaySyncClient"
Cohesion: 0.20
Nodes (9): NWBrowser, NWEndpoint, LyricPlaySyncClient, serverError, Never, Set, TimeInterval, Void (+1 more)

### Community 51 - "Testing"
Cohesion: 0.17
Nodes (5): CoreGraphics, SimplePlay, ProjectArchiveTests, SimplePlayTests, Testing

### Community 52 - "FaderMeterStripView"
Cohesion: 0.15
Nodes (12): .projectMasterStrip, .mainVolumeControl, FaderMeterStripView, .reservesThumbClearance, .showsUnityMark, .usesUnityCenterDecibelScale, Bool, CGFloat (+4 more)

### Community 53 - "AudioEngineError"
Cohesion: 0.13
Nodes (14): LocalizedError, Network, AudioEngineError, clipLoadFailed, deviceSelectionFailed, engineStartFailed, .errorDescription, noPlayableClips (+6 more)

### Community 54 - "AppKit"
Cohesion: 0.22
Nodes (6): App, AppKit, Scene, SimplePlayApp, ResizablePropertiesSidebar, .body

### Community 55 - "SimplePlayUITests"
Cohesion: 0.15
Nodes (6): SimplePlayUITests, SimplePlayUITestsLaunchTests, .runsForEachTargetApplicationUIConfiguration, Bool, XCTest, XCTestCase

### Community 57 - "TrackPitchControlView"
Cohesion: 0.11
Nodes (21): .actionButtons, Binding, Bool, Double, String, UUID, TrackPitchControlView, .menuTitle (+13 more)

### Community 58 - ".setZoom"
Cohesion: 0.31
Nodes (5): .masterVolumeBinding, .masterVolumeBinding, Binding, .masterVolumeBinding, .zoomControls

### Community 59 - ".importInitial"
Cohesion: 0.38
Nodes (3): String, TimeInterval, TrackOrganizationServiceTests

### Community 60 - "MIDINoteAssignment"
Cohesion: 0.47
Nodes (5): MIDINoteAssignment, .displayName, Bool, String, UInt8

### Community 61 - ".sessionManagement"
Cohesion: 0.60
Nodes (3): .sessionManagement, .projectSessionMenuItems, .body

### Community 62 - "ProjectPersistenceService"
Cohesion: 0.33
Nodes (5): unsupportedVersion, ProjectPersistenceService, Bool, URL, UUID

### Community 63 - "TrackGroup"
Cohesion: 0.14
Nodes (16): CodingKey, CodingKeys, horizontalOffset, id, importedAt, name, pitchSemitones, volume (+8 more)

### Community 64 - "WorkspaceView"
Cohesion: 0.22
Nodes (10): ScenePhase, Binding, Bool, String, WorkspaceLifecycleModifier, WorkspaceView, .body, .deleteSectionDialogTitle (+2 more)

### Community 65 - "SectionPlaybackMode"
Cohesion: 0.15
Nodes (11): CaseIterable, SectionPlaybackMode, continueTimeline, continueToNext, .displayName, .id, oneShot, repeatSection (+3 more)

### Community 66 - "AudioTrack"
Cohesion: 0.22
Nodes (10): AudioTrack, .color, .displayName, Bool, Double, String, UUID, .duration (+2 more)

### Community 67 - "Audio Engine — Agent Guide"
Cohesion: 0.20
Nodes (9): Architecture (do not collapse), Audio Engine — Agent Guide, Before you edit, iOS session rules (critical), Log messages, macOS device rules, Red flags (stop and reconsider), Safe change map (+1 more)

### Community 68 - ".snap"
Cohesion: 0.22
Nodes (3): AudioClip, Bool, TimeInterval

### Community 70 - "graphify reference: extra exports and benchmark"
Cohesion: 0.22
Nodes (8): graphify reference: extra exports and benchmark, Step 6b - Wiki (only if --wiki flag), Step 7 - Neo4j export (only if --neo4j or --neo4j-push flag), Step 7a - FalkorDB export (only if --falkordb or --falkordb-push flag), Step 7b - SVG export (only if --svg flag), Step 7c - GraphML export (only if --graphml flag), Step 7d - MCP server (only if --mcp flag), Step 8 - Token reduction benchmark (only if total_words > 5000)

### Community 71 - "ProjectPersistenceError"
Cohesion: 0.17
Nodes (12): JSONDecoder, .projectDecoder, JSONEncoder, .pretty, ManifestFile, ProjectPersistenceError, .errorDescription, invalidPackage (+4 more)

### Community 72 - "SectionMarkerChipView"
Cohesion: 0.20
Nodes (10): NSCursor, ResizeEdge, end, start, SectionMarkerChipView, .body, .liveSection, .resizeGripIndicator (+2 more)

### Community 73 - ".hex"
Cohesion: 0.33
Nodes (5): .defaultColor, Int, Int, String, TrackColorPalette

### Community 74 - "TimelineHorizontalMirror"
Cohesion: 0.24
Nodes (7): Bool, CGFloat, Content, TimelineHorizontalMirror, .body, TimelineScrollCoordinator, .body

### Community 75 - "graphify reference: query, path, explain"
Cohesion: 0.33
Nodes (5): For /graphify explain, For /graphify path, graphify reference: query, path, explain, Step 0 — Constrained query expansion (REQUIRED before traversal), Step 1 — Traversal

### Community 76 - ".mixerChannelStrip"
Cohesion: 0.43
Nodes (4): .mixerScrollWithPinnedMasters, Binding, Double, UUID

### Community 77 - "LyricPlaySyncMessageKind"
Cohesion: 0.22
Nodes (9): LyricPlaySyncMessageKind, catalogRequest, catalogResponse, error, linkSection, linkSectionAck, presence, presenceAck (+1 more)

### Community 78 - "UUID"
Cohesion: 0.08
Nodes (16): AudioTrack, Float, Double, Int, UUID, .trackHeaderColumnTracksOnly, Binding, Double (+8 more)

### Community 79 - "SectionPlaybackStatus"
Cohesion: 0.40
Nodes (5): SectionPlaybackStatus, idle, playing, queued, repeatingAtEnd

### Community 80 - "TrackWaveformProgressBar"
Cohesion: 0.40
Nodes (4): Bool, Double, TrackWaveformProgressBar, .body

### Community 81 - "graphify reference: add a URL and watch a folder"
Cohesion: 0.50
Nodes (3): For /graphify add, For --watch, graphify reference: add a URL and watch a folder

### Community 82 - "graphify reference: commit hook and native AGENTS.md integration"
Cohesion: 0.50
Nodes (3): For git commit hook, For native AGENTS.md integration, graphify reference: commit hook and native AGENTS.md integration

### Community 83 - "graphify reference: incremental update and cluster-only"
Cohesion: 0.50
Nodes (3): For --cluster-only, For --update (incremental re-extraction), graphify reference: incremental update and cluster-only

### Community 84 - "SimplePlayProjectArchiveError"
Cohesion: 0.29
Nodes (6): SimplePlayProjectArchiveError, corruptAsset, corruptManifest, .errorDescription, invalidArchive, String

### Community 87 - "AudioEngineServiceIOS.swift"
Cohesion: 0.33
Nodes (3): AudioEngineService, AVAudioTime, TimeInterval

### Community 89 - "ConnectionState"
Cohesion: 0.33
Nodes (6): ConnectionState, connected, failed, idle, searching, String

### Community 90 - ".loadBucket"
Cohesion: 0.53
Nodes (4): CGFloat, Int, WaveformLOD, .requiredLOD

### Community 91 - "Sendable"
Cohesion: 0.24
Nodes (14): Codable, LyricSlideCatalog, LyricSlideCatalogItem, Sendable, LinkSectionCommand, LyricPlaySync, LyricPlaySyncMessage, LyricSlideCatalog (+6 more)

### Community 92 - ".mergesNumberedElectricGuitarsAcrossMultitracks"
Cohesion: 0.47
Nodes (3): String, TimeInterval, TrackOrganizationService

### Community 93 - "SectionMarkerDensity"
Cohesion: 0.40
Nodes (5): SectionMarkerDensity, compact, dot, full, minimal

## Knowledge Gaps
- **331 isolated node(s):** `id`, `originalName`, `standardCode`, `role`, `colorHex` (+326 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **19 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `WorkspaceViewModel` connect `WorkspaceViewModel` to `MIDIInputService`, `.body`, `SupportedAudioFormats`, `AudioClip`, `TimelineWorkspacePanel`, `AudioImportService`, `SectionMarkerLaneView`, `MIDIMappingBarView`, `AudioSettings`, `Foundation`, `TopToolbarView`, `.refreshLyricCatalog`, `TransportBarView`, `DAWProject`, `TimeInterval`, `MixerPanelView`, `SavedProjectDocument`, `WorkspaceSettingsView`, `.applyImportedStems`, `View`, `TimelineOverviewBar`, `.applyLoadedProject`, `PropertiesSidebarView`, `.format`, `SwiftUI`, `LyricPlaySyncClient`, `AppKit`, `TrackPitchControlView`, `.setZoom`, `.sessionManagement`, `ProjectPersistenceService`, `WorkspaceView`, `.snap`, `SectionMarkerChipView`, `.mixerChannelStrip`, `UUID`, `SectionPlaybackStatus`, `Sendable`?**
  _High betweenness centrality (0.345) - this node is a cross-community bridge._
- **Why does `Foundation` connect `Foundation` to `MIDIInputService`, `SupportedAudioFormats`, `AudioClip`, `AudioImportService`, `DAWVerticalFaderView`, `AudioSettings`, `Equatable`, `.log`, `.format`, `SwiftUI`, `Testing`, `AudioEngineError`, `AppKit`, `TrackGroup`, `SectionPlaybackMode`, `ProjectPersistenceError`, `SimplePlayProjectArchiveError`, `AudioEngineServiceIOS.swift`, `Sendable`?**
  _High betweenness centrality (0.130) - this node is a cross-community bridge._
- **Why does `DAWProject` connect `DAWProject` to `ArrangementSection`, `MIDIInputService`, `.body`, `AudioEngineService`, `MIDIMappingBarView`, `TrackOrganizationService`, `AudioSettings`, `Foundation`, `.play`, `WorkspaceViewModel`, `Equatable`, `TimeInterval`, `.applyImportedStems`, `.applyLoadedProject`, `.attachClip`, `.importInitial`, `ProjectPersistenceService`, `TrackGroup`, `AudioTrack`, `.snap`, `.hex`, `UUID`, `Sendable`, `.mergesNumberedElectricGuitarsAcrossMultitracks`?**
  _High betweenness centrality (0.093) - this node is a cross-community bridge._
- **Are the 10 inferred relationships involving `WorkspaceViewModel` (e.g. with `AudioImportService` and `LyricPlaySyncClient`) actually correct?**
  _`WorkspaceViewModel` has 10 INFERRED edges - model-reasoned connections that need verification._
- **Are the 44 inferred relationships involving `DAWProject` (e.g. with `.activeGroupIndex()` and `.activeGroupName()`) actually correct?**
  _`DAWProject` has 44 INFERRED edges - model-reasoned connections that need verification._
- **Are the 3 inferred relationships involving `ArrangementSection` (e.g. with `.body` and `.assignsDistinctColorsForDuplicateNames()`) actually correct?**
  _`ArrangementSection` has 3 INFERRED edges - model-reasoned connections that need verification._
- **What connects `id`, `originalName`, `standardCode` to the rest of the system?**
  _331 weakly-connected nodes found - possible documentation gaps or missing edges._