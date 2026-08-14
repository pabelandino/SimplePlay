# Graph Report - SimplePlay  (2026-08-14)

## Corpus Check
- 108 files · ~54,847 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 1896 nodes · 4458 edges · 127 communities (81 shown, 46 thin omitted)
- Extraction: 90% EXTRACTED · 10% INFERRED · 0% AMBIGUOUS · INFERRED: 455 edges (avg confidence: 0.8)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `908e7c51`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- ArrangementPlaybackEngine
- MIDIInputService
- WorkspaceViewModel
- SupportedAudioFormats
- .peaks
- TrackLaneView
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
- Bool
- SimplePlayProjectArchive
- TopToolbarView
- CGFloat
- TrackPitchControlView
- What You Must Do When Invoked
- AudioOutputDevice
- StandardTrackRole
- .log
- View
- Sendable
- DAWProject
- TimeInterval
- IOSPlaybackStrategy
- MacOSPlaybackStrategy
- MixerPanelView
- TimelineOverviewBar
- WorkspaceSettingsView
- .workspaceRoot
- .sectionMappingCard
- TransportBarView
- Float
- DAWTheme
- SavedProjectDocument
- .applyLoadedProject
- AudioSampleRate
- .body
- .frames
- PropertiesSidebarView
- .play
- .attachClip
- SwiftUI
- LyricPlaySyncClient
- Testing
- ArrangementSection
- ProjectPersistenceService
- CodingKeys
- SimplePlayUITests
- .nextDistinctHex
- UIKitToolbarMenuButtonRepresentable
- PlatformPlaybackStrategy
- .importInitial
- .refreshLyricCatalog
- .sessionManagement
- .hex
- TrackGroup
- AudioClip
- SectionPlaybackMode
- AudioTrack
- Audio Engine — Agent Guide
- ProjectPersistenceError
- .log
- graphify reference: extra exports and benchmark
- Color
- SettingsFieldLabel
- PlaybackState
- SectionTriggerResult
- graphify reference: query, path, explain
- SnapGrid.swift
- .addSection
- TrackHeaderRowView
- SectionPlaybackStatus
- TrackWaveformProgressBar
- graphify reference: add a URL and watch a folder
- graphify reference: commit hook and native AGENTS.md integration
- graphify reference: incremental update and cluster-only
- graphify reference: GitHub clone and cross-repo merge
- graphify reference: transcribe video and audio
- .loadBucket
- extraction-spec.md
- ArrangementSection
- AudioTrack
- AVAudioFile
- AVAudioFrameCount
- AVAudioFramePosition
- AVAudioPlayerNode
- AVAudioUnitTimePitch
- CGFloat
- ClosedRange
- Date
- Int64
- LyricSlideCatalog
- LyricSlideCatalogItem
- MIDIInputEvent
- MIDILearnTarget
- MIDISourceInfo
- PlatformPlaybackStrategy
- SavedProjectDocument
- SectionPlaybackMode
- Set
- StandardTrackRole
- DAWProject
- StandardTrackRole
- AudioClip
- DAWProject
- SectionLoopContext
- DAWProject
- DAWProject
- StandardTrackRole
- StandardTrackRole
- AudioClip
- DAWProject
- SectionLoopContext
- SimplePlayProjectFileDocument
- TimelineEditTool
- TrackOrganizationService
- UInt64
- UInt8
- Void

## God Nodes (most connected - your core abstractions)
1. `WorkspaceViewModel` - 262 edges
2. `AudioEngineService` - 106 edges
3. `DAWProject` - 94 edges
4. `ArrangementSection` - 70 edges
5. `DAWTheme` - 52 edges
6. `MIDIMappingBarView` - 48 edges
7. `AudioTrack` - 44 edges
8. `StandardTrackRole` - 42 edges
9. `ArrangementPlaybackEngine` - 36 edges
10. `MixerPanelView` - 35 edges

## Surprising Connections (you probably didn't know these)
- `TrackOrganizationServiceTests` --calls--> `TrackOrganizationService`  [EXTRACTED]
  SimplePlayTests/TrackOrganizationServiceTests.swift → SimplePlay/Core/Services/TrackOrganizationService.swift
- `WorkspaceViewModel` --calls--> `ArrangementPlaybackEngine`  [INFERRED]
  SimplePlay/Features/Workspace/ViewModels/WorkspaceViewModel.swift → SimplePlay/Core/Services/ArrangementPlaybackEngine.swift
- `.selectedMarkerEditor` --calls--> `MIDINoteAssignment`  [INFERRED]
  SimplePlay/Features/Workspace/Views/PropertiesSidebarView.swift → SimplePlay/Core/Models/MIDILearnTarget.swift
- `.body` --calls--> `SectionEdgeGuideOverlay`  [INFERRED]
  SimplePlay/Features/Workspace/Views/TimelineWorkspacePanel.swift → SimplePlay/Features/Workspace/Views/SectionMarkerLaneView.swift
- `.body` --calls--> `SectionMarkerLaneView`  [INFERRED]
  SimplePlay/Features/Workspace/Views/TimelineWorkspacePanel.swift → SimplePlay/Features/Workspace/Views/SectionMarkerLaneView.swift

## Import Cycles
- None detected.

## Communities (127 total, 46 thin omitted)

### Community 0 - "ArrangementPlaybackEngine"
Cohesion: 0.25
Nodes (7): ArrangementPlaybackEngine, UInt8, UUID, ArrangementPlaybackEngineTests, String, TimeInterval, UInt8

### Community 1 - "MIDIInputService"
Cohesion: 0.06
Nodes (32): Identifiable, MIDINotifyProc, MIDIPacket, MIDIPacketList, MIDILearnTarget, section, MIDINoteAssignment, .displayName (+24 more)

### Community 2 - "WorkspaceViewModel"
Cohesion: 0.08
Nodes (24): Bool, Date, Double, Float, Set, UUID, WorkspaceViewModel, .activePlaybackSection (+16 more)

### Community 3 - "SupportedAudioFormats"
Cohesion: 0.06
Nodes (37): FileDocument, FileWrapper, ReadConfiguration, SimplePlayProjectFileDocument, .readableContentTypes, Data, DropURLLoader, NSItemProvider (+29 more)

### Community 4 - ".peaks"
Cohesion: 0.10
Nodes (29): AVAudioPCMBuffer, CheckedContinuation, clips, Double, Float, Int, MainActor, Never (+21 more)

### Community 5 - "TrackLaneView"
Cohesion: 0.09
Nodes (26): G, GraphicsContext, CGFloat, String, TimeInterval, TimelineRulerScale, ClipDragInteractionModifier, ClipSelectionModifiers (+18 more)

### Community 6 - "TimelineWorkspacePanel"
Cohesion: 0.07
Nodes (42): ScrollPosition, Bool, CGFloat, Content, TimelineHorizontalMirror, .body, TimelineScrollCoordinator, PinnedTimelineHeaderStrip (+34 more)

### Community 7 - "CodingKeys"
Cohesion: 0.06
Nodes (34): CodingKeys, audioSettings, colorHex, groups, id, isLocked, isMuted, isPitchEnabled (+26 more)

### Community 8 - "AudioImportService"
Cohesion: 0.08
Nodes (24): AudioFileStorageService, String, URL, UUID, AudioImportError, emptySelection, .errorDescription, storageUnavailable (+16 more)

### Community 9 - "AudioEngineService"
Cohesion: 0.07
Nodes (21): AVAudioEngine, AVAudioUnitEQ, AudioEnginePlatformServices, AudioEngineService, .avEngine, .engineIsRunning, .isAnyPlayerPlaying, .isMeterMonitoringEnabled (+13 more)

### Community 10 - "SectionMarkerChipView"
Cohesion: 0.08
Nodes (36): NSCursor, Bool, String, TimeInterval, TimeFormatting, .formattedCurrentTime, .formattedDuration, ResizeEdge (+28 more)

### Community 11 - ".selectedMarkerEditor"
Cohesion: 0.12
Nodes (30): Selection, .audioSettings, .playbackSettings, .sectionEditor, .selectedMarkerEditor, .selectionInfo, .trackPitch, DAWSecondaryButtonStyle (+22 more)

### Community 12 - "MIDIMappingBarView"
Cohesion: 0.12
Nodes (15): Animation, AnyTransition, MIDIMappingBarView, .assignModeToggleTitle, .collapsedBar, .collapsedBarContent, .devicePickerLabel, .devicePickerTitle (+7 more)

### Community 13 - "DAWVerticalFaderView"
Cohesion: 0.09
Nodes (25): ClosedRange, Double, Float, String, TrackVolumeSettings, .trackRange, DAWVerticalFaderView, .body (+17 more)

### Community 14 - "TrackOrganizationService"
Cohesion: 0.28
Nodes (9): ImportedStem, ImportPlacement, appendNewGroup, insertIntoGroup, Int, String, TimeInterval, URL (+1 more)

### Community 15 - "AudioSettings"
Cohesion: 0.13
Nodes (12): AnyObject, AVAudioSession, AudioSettings, .usesCustomOutputDevice, Bool, AudioEngineServiceHost, AudioEngineService, AudioEngineServiceIOS (+4 more)

### Community 16 - "Foundation"
Cohesion: 0.12
Nodes (8): AudioUnit, AVFoundation, CoreAudio, CoreMIDI, Foundation, Observation, os, AudioEnginePlatformServicesFactory

### Community 17 - "MacWindowTitleBarHidden.swift"
Cohesion: 0.11
Nodes (15): Notification, NSApplicationDelegate, NSEvent, NSObject, NSView, NSViewRepresentable, NSWindow, .body (+7 more)

### Community 18 - "Bool"
Cohesion: 0.14
Nodes (11): SectionLoopContext, .duration, TimeInterval, UUID, Bool, Int, Int64, String (+3 more)

### Community 19 - "SimplePlayProjectArchive"
Cohesion: 0.16
Nodes (15): Asset, SimplePlayProjectArchive, SimplePlayProjectArchiveError, corruptAsset, corruptManifest, .errorDescription, invalidArchive, Bool (+7 more)

### Community 20 - "TopToolbarView"
Cohesion: 0.14
Nodes (18): Bool, String, Void, ToolbarMenuButtonStyleModifier, TopToolbarView, .importButton, .isCompact, .openButton (+10 more)

### Community 21 - "CGFloat"
Cohesion: 0.11
Nodes (10): SectionDragKind, move, resizeEnd, resizeStart, CGFloat, TimelineScrollRequest, .minimumTimelineZoom, .timelineContentWidth (+2 more)

### Community 22 - "TrackPitchControlView"
Cohesion: 0.16
Nodes (13): .actionButtons, Binding, Bool, Double, String, UUID, TrackPitchControlView, .menuTitle (+5 more)

### Community 23 - "What You Must Do When Invoked"
Cohesion: 0.08
Nodes (24): For /graphify add and --watch, For /graphify query, For the commit hook and native AGENTS.md integration, For --update and --cluster-only, /graphify, Honesty Rules, Interpreter guard for subcommands, Part A - Structural extraction for code files (+16 more)

### Community 24 - "AudioOutputDevice"
Cohesion: 0.16
Nodes (12): Hashable, AudioOutputDevice, Int, String, UInt32, AudioDeviceService, AudioDeviceID, Bool (+4 more)

### Community 25 - "StandardTrackRole"
Cohesion: 0.08
Nodes (25): StandardTrackRole, acousticGuitar, backingVocal, bass, brass, click, countIn, cue (+17 more)

### Community 26 - ".log"
Cohesion: 0.42
Nodes (5): SectionTriggerDiagnostics, Bool, String, TimeInterval, UUID

### Community 27 - "View"
Cohesion: 0.15
Nodes (11): SectionLyricLinkSheet, .body, .unavailableState, DAWIconToolbarButtonStyle, DAWLabeledToolbarButtonStyle, DAWPrimaryButtonStyle, Configuration, Content (+3 more)

### Community 28 - "Sendable"
Cohesion: 0.22
Nodes (19): Codable, Equatable, Sendable, PersistedClip, PersistedProject, PersistedTrack, Bool, Decoder (+11 more)

### Community 29 - "DAWProject"
Cohesion: 0.13
Nodes (13): DAWProject, Bool, Double, Int32, String, TimeInterval, UInt8, UUID (+5 more)

### Community 30 - "TimeInterval"
Cohesion: 0.15
Nodes (9): SectionEdgeGuides, Bool, TimeInterval, Timer, TimelineScrollAlignment, center, leading, start (+1 more)

### Community 31 - "IOSPlaybackStrategy"
Cohesion: 0.19
Nodes (11): IOSPlaybackStrategy, .meterTapBufferSize, AudioEngineService, AVAudioFile, AVAudioFrameCount, AVAudioFramePosition, AVAudioPlayerNode, AVAudioTime (+3 more)

### Community 32 - "MacOSPlaybackStrategy"
Cohesion: 0.19
Nodes (11): MacOSPlaybackStrategy, .meterTapBufferSize, AudioEngineService, AVAudioFile, AVAudioFrameCount, AVAudioFramePosition, AVAudioPlayerNode, AVAudioTime (+3 more)

### Community 33 - "MixerPanelView"
Cohesion: 0.05
Nodes (44): MixerPanelView, .body, .channelFaderHeight, .channelFaderWidth, .channelStripWidth, .isCompact, .masterFaderHeight, .mastersStripRow (+36 more)

### Community 34 - "TimelineOverviewBar"
Cohesion: 0.11
Nodes (21): Path, Bool, CGFloat, CGSize, ClosedRange, Gesture, TimeInterval, TimelineOverviewBar (+13 more)

### Community 35 - "WorkspaceSettingsView"
Cohesion: 0.28
Nodes (7): Binding, Bool, String, WorkspaceSettingsView, .body, .deleteSectionDialogTitle, .sectionDeletionDialogBinding

### Community 36 - ".workspaceRoot"
Cohesion: 0.20
Nodes (5): Error, Result, String, URL, .workspaceRoot

### Community 37 - ".sectionMappingCard"
Cohesion: 0.18
Nodes (9): ButtonStyle, SectionMappingAssignButtonStyle, SectionMappingCardGlow, SectionMappingPlayButtonStyle, Bool, CGFloat, Configuration, Content (+1 more)

### Community 38 - "TransportBarView"
Cohesion: 0.06
Nodes (34): ScenePhase, .masterVolumeBinding, Binding, Bool, CGFloat, Double, String, Void (+26 more)

### Community 39 - "Float"
Cohesion: 0.24
Nodes (5): AVAudioMixerNode, MeterPeakBuffer, Float, UUID, Void

### Community 40 - "DAWTheme"
Cohesion: 0.11
Nodes (19): Glass, .groupDivider, .pinnedMastersColumn, DAWGlassChrome, .controlGlass, .panelGlass, CGFloat, Double (+11 more)

### Community 41 - "SavedProjectDocument"
Cohesion: 0.21
Nodes (8): SavedProjectDocument, Int, ManifestFile, Data, ProjectFilePanel, String, URL, .body

### Community 43 - "AudioSampleRate"
Cohesion: 0.14
Nodes (11): CaseIterable, Double, AudioSampleRate, .displayName, .id, rate44100, rate48000, URL (+3 more)

### Community 44 - ".body"
Cohesion: 0.14
Nodes (10): Commands, ContentView, .body, FileCommands, Content, View, TransportCommands, View (+2 more)

### Community 45 - ".frames"
Cohesion: 0.30
Nodes (6): Bool, Double, Int64, TimeInterval, TimelineSampleGrid, TimelineSampleGridTests

### Community 46 - "PropertiesSidebarView"
Cohesion: 0.15
Nodes (15): PropertiesSidebarView, .body, .pitchIsOriginal, .pitchLabel, .sectionCreationHint, .selectedDeviceID, .selectedSection, .selectedSectionNameBinding (+7 more)

### Community 47 - ".play"
Cohesion: 0.20
Nodes (3): AVAudioNode, .playbackGraphIsHealthy, AVAudioPlayerNode

### Community 48 - ".attachClip"
Cohesion: 0.17
Nodes (10): AudioEngineError, clipLoadFailed, deviceSelectionFailed, engineStartFailed, .errorDescription, noPlayableClips, playbackUnavailable, ScheduledClip (+2 more)

### Community 49 - "SwiftUI"
Cohesion: 0.15
Nodes (7): App, AppKit, Scene, SimplePlayApp, ResizablePropertiesSidebar, .body, SwiftUI

### Community 50 - "LyricPlaySyncClient"
Cohesion: 0.06
Nodes (45): LocalizedError, Network, NWBrowser, NWEndpoint, ConnectionState, connected, failed, idle (+37 more)

### Community 51 - "Testing"
Cohesion: 0.22
Nodes (4): SimplePlay, ProjectArchiveTests, SimplePlayTests, Testing

### Community 52 - "ArrangementSection"
Cohesion: 0.16
Nodes (13): ArrangementSection, .color, .duration, .hasLyricSlideLink, Bool, Decoder, Int, String (+5 more)

### Community 53 - "ProjectPersistenceService"
Cohesion: 0.33
Nodes (5): unsupportedVersion, ProjectPersistenceService, Bool, URL, UUID

### Community 54 - "CodingKeys"
Cohesion: 0.13
Nodes (15): CodingKeys, colorHex, endTime, id, lyricDocumentID, lyricSlideID, lyricSlideOrder, midiChannel (+7 more)

### Community 55 - "SimplePlayUITests"
Cohesion: 0.15
Nodes (6): SimplePlayUITests, SimplePlayUITestsLaunchTests, .runsForEachTargetApplicationUIConfiguration, Bool, XCTest, XCTestCase

### Community 56 - ".nextDistinctHex"
Cohesion: 0.27
Nodes (7): sections, SectionMarkerPalette, .palette, Int, Set, String, SectionMarkerPaletteTests

### Community 57 - "UIKitToolbarMenuButtonRepresentable"
Cohesion: 0.33
Nodes (7): Coordinator, Context, String, Void, UIKitToolbarMenuButtonRepresentable, UIButton, UIViewRepresentable

### Community 58 - "PlatformPlaybackStrategy"
Cohesion: 0.24
Nodes (5): AVAudioFrameCount, AVAudioFramePosition, AVAudioTime, PlatformPlaybackStrategy, PlatformPlaybackStrategyFactory

### Community 59 - ".importInitial"
Cohesion: 0.32
Nodes (3): String, TimeInterval, TrackOrganizationServiceTests

### Community 60 - ".refreshLyricCatalog"
Cohesion: 0.29
Nodes (4): .assignModeToggle, .expandedPanel, .learnBanner, .lyricCatalogStatus

### Community 61 - ".sessionManagement"
Cohesion: 0.60
Nodes (3): .sessionManagement, .projectSessionMenuItems, .body

### Community 62 - ".hex"
Cohesion: 0.39
Nodes (4): .defaultColor, Int, String, TrackColorPalette

### Community 63 - "TrackGroup"
Cohesion: 0.14
Nodes (16): CodingKey, CodingKeys, horizontalOffset, id, importedAt, name, pitchSemitones, volume (+8 more)

### Community 64 - "AudioClip"
Cohesion: 0.36
Nodes (7): AudioClip, .endTime, Int, String, TimeInterval, URL, UUID

### Community 65 - "SectionPlaybackMode"
Cohesion: 0.25
Nodes (7): SectionPlaybackMode, continueTimeline, continueToNext, .displayName, .id, oneShot, repeatSection

### Community 66 - "AudioTrack"
Cohesion: 0.18
Nodes (10): AudioTrack, .color, .displayName, Bool, Double, String, UUID, .duration (+2 more)

### Community 67 - "Audio Engine — Agent Guide"
Cohesion: 0.20
Nodes (9): Architecture (do not collapse), Audio Engine — Agent Guide, Before you edit, iOS session rules (critical), Log messages, macOS device rules, Red flags (stop and reconsider), Safe change map (+1 more)

### Community 68 - "ProjectPersistenceError"
Cohesion: 0.20
Nodes (9): JSONDecoder, .projectDecoder, ProjectPersistenceError, .errorDescription, invalidPackage, missingAudioFile, missingManifest, Int (+1 more)

### Community 69 - ".log"
Cohesion: 0.38
Nodes (6): SectionLoopDiagnostics, AVAudioFrameCount, Double, Int64, String, TimeInterval

### Community 70 - "graphify reference: extra exports and benchmark"
Cohesion: 0.22
Nodes (8): graphify reference: extra exports and benchmark, Step 6b - Wiki (only if --wiki flag), Step 7 - Neo4j export (only if --neo4j or --neo4j-push flag), Step 7a - FalkorDB export (only if --falkordb or --falkordb-push flag), Step 7b - SVG export (only if --svg flag), Step 7c - GraphML export (only if --graphml flag), Step 7d - MCP server (only if --mcp flag), Step 8 - Token reduction benchmark (only if total_words > 5000)

### Community 72 - "SettingsFieldLabel"
Cohesion: 0.29
Nodes (8): .volumeControls, SettingsControlSurface, .body, SettingsFieldLabel, .body, .body, .body, Content

### Community 73 - "PlaybackState"
Cohesion: 0.33
Nodes (6): PlaybackState, continuingTimeline, idle, playingSection, repeatingSectionAtEnd, waitingToJump

### Community 74 - "SectionTriggerResult"
Cohesion: 0.50
Nodes (4): SectionTriggerResult, activatedImmediately, enabledRepeatAtEnd, queuedForEnd

### Community 75 - "graphify reference: query, path, explain"
Cohesion: 0.33
Nodes (5): For /graphify explain, For /graphify path, graphify reference: query, path, explain, Step 0 — Constrained query expansion (REQUIRED before traversal), Step 1 — Traversal

### Community 78 - "TrackHeaderRowView"
Cohesion: 0.09
Nodes (16): Bool, TimeInterval, ImportPanelKind, audioFiles, folder, Int, .trackHeaderColumnTracksOnly, .importMenuItems (+8 more)

### Community 79 - "SectionPlaybackStatus"
Cohesion: 0.33
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

### Community 87 - ".loadBucket"
Cohesion: 0.31
Nodes (5): CoreGraphics, CGFloat, Int, WaveformLOD, .requiredLOD

## Knowledge Gaps
- **324 isolated node(s):** `Usage`, `What graphify is for`, `Step 0 - GitHub repos and multi-path merge (only if a URL or several paths)`, `Step 1 - Ensure graphify is installed`, `Step 2 - Detect files` (+319 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **46 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `WorkspaceViewModel` connect `WorkspaceViewModel` to `ArrangementPlaybackEngine`, `MIDIInputService`, `SupportedAudioFormats`, `TrackLaneView`, `TimelineWorkspacePanel`, `AudioImportService`, `SectionMarkerChipView`, `MIDIMappingBarView`, `TrackOrganizationService`, `Foundation`, `TopToolbarView`, `CGFloat`, `TrackPitchControlView`, `AudioOutputDevice`, `View`, `DAWProject`, `TimeInterval`, `MixerPanelView`, `TimelineOverviewBar`, `WorkspaceSettingsView`, `.workspaceRoot`, `.sectionMappingCard`, `TransportBarView`, `SavedProjectDocument`, `.applyLoadedProject`, `AudioSampleRate`, `.body`, `.frames`, `PropertiesSidebarView`, `SwiftUI`, `LyricPlaySyncClient`, `ArrangementSection`, `ProjectPersistenceService`, `.refreshLyricCatalog`, `.sessionManagement`, `AudioTrack`, `Color`, `.addSection`, `TrackHeaderRowView`, `SectionPlaybackStatus`?**
  _High betweenness centrality (0.369) - this node is a cross-community bridge._
- **Why does `DAWProject` connect `DAWProject` to `MIDIInputService`, `WorkspaceViewModel`, `CodingKeys`, `AudioEngineService`, `TrackOrganizationService`, `AudioSettings`, `Foundation`, `Bool`, `CGFloat`, `View`, `Sendable`, `TimeInterval`, `.workspaceRoot`, `SavedProjectDocument`, `.applyLoadedProject`, `.body`, `.play`, `.attachClip`, `LyricPlaySyncClient`, `ArrangementSection`, `ProjectPersistenceService`, `.importInitial`, `TrackGroup`, `AudioTrack`, `Color`, `.addSection`, `TrackHeaderRowView`?**
  _High betweenness centrality (0.099) - this node is a cross-community bridge._
- **Why does `ArrangementSection` connect `ArrangementSection` to `ArrangementPlaybackEngine`, `MIDIInputService`, `WorkspaceViewModel`, `SectionMarkerChipView`, `.selectedMarkerEditor`, `MIDIMappingBarView`, `View`, `Sendable`, `DAWProject`, `TimeInterval`, `.sectionMappingCard`, `.frames`, `PropertiesSidebarView`, `SwiftUI`, `LyricPlaySyncClient`, `CodingKeys`, `.nextDistinctHex`, `SectionPlaybackMode`, `Color`, `PlaybackState`, `.addSection`, `SectionPlaybackStatus`?**
  _High betweenness centrality (0.098) - this node is a cross-community bridge._
- **Are the 11 inferred relationships involving `WorkspaceViewModel` (e.g. with `ArrangementPlaybackEngine` and `AudioImportService`) actually correct?**
  _`WorkspaceViewModel` has 11 INFERRED edges - model-reasoned connections that need verification._
- **Are the 43 inferred relationships involving `DAWProject` (e.g. with `.activeGroupIndex()` and `.activeGroupName()`) actually correct?**
  _`DAWProject` has 43 INFERRED edges - model-reasoned connections that need verification._
- **Are the 4 inferred relationships involving `ArrangementSection` (e.g. with `.body` and `.body`) actually correct?**
  _`ArrangementSection` has 4 INFERRED edges - model-reasoned connections that need verification._
- **What connects `Usage`, `What graphify is for`, `Step 0 - GitHub repos and multi-path merge (only if a URL or several paths)` to the rest of the system?**
  _324 weakly-connected nodes found - possible documentation gaps or missing edges._