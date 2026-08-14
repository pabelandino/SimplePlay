# Graph Report - SimplePlay  (2026-08-13)

## Corpus Check
- 103 files · ~53,564 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 1860 nodes · 4362 edges · 91 communities (79 shown, 12 thin omitted)
- Extraction: 90% EXTRACTED · 10% INFERRED · 0% AMBIGUOUS · INFERRED: 432 edges (avg confidence: 0.8)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `584a4add`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- SimplePlayUITests
- View
- MacOSPlaybackStrategy
- What You Must Do When Invoked
- TrackLaneView
- graphify reference: extra exports and benchmark
- CGFloat
- graphify reference: query, path, explain
- graphify reference: add a URL and watch a folder
- graphify reference: commit hook and native AGENTS.md integration
- graphify reference: incremental update and cluster-only
- graphify reference: GitHub clone and cross-repo merge
- graphify reference: transcribe video and audio
- extraction-spec.md
- ArrangementSection
- MixerPanelView
- TimelineWorkspacePanel
- TimelineOverviewBar
- PropertiesSidebarView
- AudioEngineService
- StandardTrackRole
- .applyImportedStems
- PitchShiftSettings
- MIDIMappingBarView
- LyricPlaySyncTransportError
- Equatable
- TransportBarView
- .frames
- ProjectPersistenceService
- CodingKeys
- Testing
- TrackGroup
- DAWProject
- SupportedAudioFormats
- TopToolbarView.swift
- Float
- UUID
- AudioTrack
- WorkspaceView
- MacWindowTitleBarHidden.swift
- LyricPlaySyncClient
- AudioImportService
- FaderMeterStripView
- SwiftUI
- .peaks
- AudioSettings
- TrackPitchControlView
- MIDIInputService
- .configure
- .format
- .setZoom
- ConnectionState
- LyricPlaySyncMessageKind
- .applyMIDILearn
- DAWVerticalFaderView
- TimeInterval
- Foundation
- TransportBarStyle
- .activeGroupIndex
- .stop
- .sectionLyricAssignRow
- .sectionMappingCard
- ResizeEdge
- .play
- DAWProject
- WorkspaceSettingsView
- TopToolbarView
- WorkspaceViewModel
- SimplePlayTests.swift
- Encoder
- UIKitToolbarMenuButtonRepresentable
- DAWTheme
- Int64
- .log
- AudioEngineService.swift
- SidebarPanel
- Color
- UInt64
- Never
- View
- LyricSlideCatalogItem
- AudioClip
- Date
- IOSPlaybackStrategy
- Configuration
- .loadBucket
- SectionPlaybackMode
- SectionPlaybackStatus
- .setMasterVolume
- .applyLoadedProject
- Sendable

## God Nodes (most connected - your core abstractions)
1. `WorkspaceViewModel` - 262 edges
2. `AudioEngineService` - 128 edges
3. `ArrangementSection` - 70 edges
4. `DAWTheme` - 52 edges
5. `MIDIMappingBarView` - 48 edges
6. `AudioTrack` - 44 edges
7. `MixerPanelView` - 35 edges
8. `ArrangementPlaybackEngine` - 33 edges
9. `PropertiesSidebarView` - 32 edges
10. `CodingKeys` - 31 edges

## Surprising Connections (you probably didn't know these)
- `.duration` --references--> `AudioTrack`  [INFERRED]
  SimplePlay/Core/Models/DAWProject.swift → SimplePlay/Core/Models/AudioTrack.swift
- `.body` --references--> `ArrangementSection`  [INFERRED]
  SimplePlay/Features/Workspace/Views/SectionMarkerLaneView.swift → SimplePlay/Core/Models/ArrangementSection.swift
- `.body` --references--> `ArrangementSection`  [INFERRED]
  SimplePlay/Features/Workspace/Views/SectionMarkerLaneView.swift → SimplePlay/Core/Models/ArrangementSection.swift
- `.hasSoloTracks` --references--> `AudioTrack`  [INFERRED]
  SimplePlay/Core/Utils/TrackColorPalette.swift → SimplePlay/Core/Models/AudioTrack.swift
- `WorkspaceViewModel` --calls--> `AudioEngineService`  [INFERRED]
  SimplePlay/Features/Workspace/ViewModels/WorkspaceViewModel.swift → SimplePlay/Core/Services/AudioEngineService.swift

## Import Cycles
- None detected.

## Communities (91 total, 12 thin omitted)

### Community 0 - "SimplePlayUITests"
Cohesion: 0.15
Nodes (6): SimplePlayUITests, SimplePlayUITestsLaunchTests, .runsForEachTargetApplicationUIConfiguration, Bool, XCTest, XCTestCase

### Community 1 - "View"
Cohesion: 0.14
Nodes (26): NSCursor, SectionCreationPreviewView, .body, SectionDragSession, SectionEdgeGuideOverlay, .body, SectionMarkerChipView, .chipWidth (+18 more)

### Community 2 - "MacOSPlaybackStrategy"
Cohesion: 0.15
Nodes (9): MacOSPlaybackStrategy, .meterTapBufferSize, AVAudioFile, AVAudioFrameCount, AVAudioFramePosition, AVAudioPlayerNode, AVAudioTime, Double (+1 more)

### Community 3 - "What You Must Do When Invoked"
Cohesion: 0.08
Nodes (24): For /graphify add and --watch, For /graphify query, For the commit hook and native AGENTS.md integration, For --update and --cluster-only, /graphify, Honesty Rules, Interpreter guard for subcommands, Part A - Structural extraction for code files (+16 more)

### Community 4 - "TrackLaneView"
Cohesion: 0.08
Nodes (30): G, GraphicsContext, Path, CGFloat, String, TimeInterval, TimelineRulerScale, ClipDragInteractionModifier (+22 more)

### Community 5 - "graphify reference: extra exports and benchmark"
Cohesion: 0.22
Nodes (8): graphify reference: extra exports and benchmark, Step 6b - Wiki (only if --wiki flag), Step 7 - Neo4j export (only if --neo4j or --neo4j-push flag), Step 7a - FalkorDB export (only if --falkordb or --falkordb-push flag), Step 7b - SVG export (only if --svg flag), Step 7c - GraphML export (only if --graphml flag), Step 7d - MCP server (only if --mcp flag), Step 8 - Token reduction benchmark (only if total_words > 5000)

### Community 6 - "CGFloat"
Cohesion: 0.12
Nodes (10): SectionDragKind, move, resizeEnd, resizeStart, CGFloat, TimelineScrollRequest, .minimumTimelineZoom, .timelineContentWidth (+2 more)

### Community 7 - "graphify reference: query, path, explain"
Cohesion: 0.33
Nodes (5): For /graphify explain, For /graphify path, graphify reference: query, path, explain, Step 0 — Constrained query expansion (REQUIRED before traversal), Step 1 — Traversal

### Community 8 - "graphify reference: add a URL and watch a folder"
Cohesion: 0.50
Nodes (3): For /graphify add, For --watch, graphify reference: add a URL and watch a folder

### Community 9 - "graphify reference: commit hook and native AGENTS.md integration"
Cohesion: 0.50
Nodes (3): For git commit hook, For native AGENTS.md integration, graphify reference: commit hook and native AGENTS.md integration

### Community 10 - "graphify reference: incremental update and cluster-only"
Cohesion: 0.50
Nodes (3): For --cluster-only, For --update (incremental re-extraction), graphify reference: incremental update and cluster-only

### Community 14 - "ArrangementSection"
Cohesion: 0.07
Nodes (39): ArrangementSection, .color, .duration, .hasLyricSlideLink, Bool, Color, Decoder, Int (+31 more)

### Community 15 - "MixerPanelView"
Cohesion: 0.10
Nodes (24): MixerPanelView, .body, .channelFaderHeight, .channelFaderWidth, .channelStripWidth, .groupDivider, .isCompact, .masterFaderHeight (+16 more)

### Community 16 - "TimelineWorkspacePanel"
Cohesion: 0.09
Nodes (36): ScrollPosition, Bool, CGFloat, Content, TimelineHorizontalMirror, .body, TimelineScrollCoordinator, PinnedTimelineHeaderStrip (+28 more)

### Community 17 - "TimelineOverviewBar"
Cohesion: 0.11
Nodes (20): Bool, CGFloat, CGSize, ClosedRange, Gesture, TimeInterval, TimelineOverviewBar, .barHeight (+12 more)

### Community 18 - "PropertiesSidebarView"
Cohesion: 0.15
Nodes (16): PropertiesSidebarView, .body, .pitchIsOriginal, .pitchLabel, .sectionCreationHint, .selectedDevice, .selectedDeviceID, .selectedSection (+8 more)

### Community 19 - "AudioEngineService"
Cohesion: 0.06
Nodes (21): AVAudioEngine, AudioEngineService, .isAnyPlayerPlaying, .isMeterMonitoringEnabled, .isPlaybackGraphReady, .isSamplePlaybackClockEstablished, .isSectionLoopPlaybackActive, .masterVolume (+13 more)

### Community 20 - "StandardTrackRole"
Cohesion: 0.08
Nodes (24): StandardTrackRole, acousticGuitar, backingVocal, bass, brass, click, countIn, cue (+16 more)

### Community 21 - ".applyImportedStems"
Cohesion: 0.16
Nodes (9): Error, Result, ImportPanelKind, audioFiles, folder, String, URL, .workspaceRoot (+1 more)

### Community 22 - "PitchShiftSettings"
Cohesion: 0.22
Nodes (6): PitchShiftSettings, AVAudioUnitTimePitch, Bool, Double, Float, PitchShiftSettingsTests

### Community 23 - "MIDIMappingBarView"
Cohesion: 0.11
Nodes (18): Animation, AnyTransition, MIDIMappingBarView, .assignModeToggleTitle, .body, .collapsedBar, .collapsedBarContent, .devicePickerLabel (+10 more)

### Community 24 - "LyricPlaySyncTransportError"
Cohesion: 0.25
Nodes (7): LocalizedError, Network, LyricPlaySyncTransportError, emptyResponse, .errorDescription, noLyrioraHost, unexpectedResponse

### Community 25 - "Equatable"
Cohesion: 0.20
Nodes (21): Codable, Encoder, Equatable, PersistedClip, PersistedProject, PersistedTrack, SavedProjectDocument, Bool (+13 more)

### Community 26 - "TransportBarView"
Cohesion: 0.12
Nodes (17): Bool, CGFloat, Double, String, Void, TransportBarView, .body, .isCompact (+9 more)

### Community 27 - ".frames"
Cohesion: 0.12
Nodes (16): SectionLoopContext, .duration, TimeInterval, UUID, SectionLoopDiagnostics, AVAudioFrameCount, Double, Int64 (+8 more)

### Community 28 - "ProjectPersistenceService"
Cohesion: 0.05
Nodes (40): JSONDecoder, .projectDecoder, JSONEncoder, .pretty, ProjectPersistenceError, .errorDescription, invalidPackage, missingAudioFile (+32 more)

### Community 29 - "CodingKeys"
Cohesion: 0.04
Nodes (48): CodingKey, CodingKeys, colorHex, endTime, id, lyricDocumentID, lyricSlideID, lyricSlideOrder (+40 more)

### Community 30 - "Testing"
Cohesion: 0.22
Nodes (4): CoreGraphics, SimplePlay, ProjectArchiveTests, Testing

### Community 31 - "TrackGroup"
Cohesion: 0.12
Nodes (21): Date, Decoder, Double, Encoder, String, TimeInterval, UUID, TrackGroup (+13 more)

### Community 32 - "DAWProject"
Cohesion: 0.29
Nodes (10): DAWProject, .duration, Bool, Double, Int32, String, TimeInterval, TrackGroup (+2 more)

### Community 33 - "SupportedAudioFormats"
Cohesion: 0.06
Nodes (37): FileDocument, FileWrapper, ReadConfiguration, SimplePlayProjectFileDocument, .readableContentTypes, Data, DropURLLoader, NSItemProvider (+29 more)

### Community 34 - "TopToolbarView.swift"
Cohesion: 0.24
Nodes (8): ButtonStyle, DAWIconToolbarButtonStyle, DAWLabeledToolbarButtonStyle, DAWPrimaryButtonStyle, Content, .body, .settingsHeader, UIKit

### Community 35 - "Float"
Cohesion: 0.24
Nodes (5): AVAudioMixerNode, MeterPeakBuffer, Float, UUID, Void

### Community 36 - "UUID"
Cohesion: 0.09
Nodes (17): Bool, TimeInterval, Double, Float, UUID, .mixerScrollWithPinnedMasters, .selectedSectionNameBinding, Binding (+9 more)

### Community 37 - "AudioTrack"
Cohesion: 0.21
Nodes (13): AudioTrack, .color, .displayName, AudioClip, Bool, Color, Double, StandardTrackRole (+5 more)

### Community 38 - "WorkspaceView"
Cohesion: 0.22
Nodes (10): ScenePhase, Binding, Bool, String, WorkspaceLifecycleModifier, WorkspaceView, .body, .deleteSectionDialogTitle (+2 more)

### Community 39 - "MacWindowTitleBarHidden.swift"
Cohesion: 0.11
Nodes (15): Notification, NSApplicationDelegate, NSEvent, NSObject, NSView, NSViewRepresentable, NSWindow, .body (+7 more)

### Community 40 - "LyricPlaySyncClient"
Cohesion: 0.15
Nodes (13): Never, NWBrowser, NWEndpoint, LyricPlaySyncClient, serverError, Set, TimeInterval, Void (+5 more)

### Community 41 - "AudioImportService"
Cohesion: 0.08
Nodes (25): AudioFileStorageService, String, URL, UUID, AudioImportError, emptySelection, .errorDescription, storageUnavailable (+17 more)

### Community 42 - "FaderMeterStripView"
Cohesion: 0.15
Nodes (12): .projectMasterStrip, .mainVolumeControl, FaderMeterStripView, .reservesThumbClearance, .showsUnityMark, .usesUnityCenterDecibelScale, Bool, CGFloat (+4 more)

### Community 43 - "SwiftUI"
Cohesion: 0.07
Nodes (20): App, AppKit, Commands, Scene, ContentView, .body, FileCommands, SimplePlayApp (+12 more)

### Community 44 - ".peaks"
Cohesion: 0.09
Nodes (32): AVAudioPCMBuffer, CheckedContinuation, clips, Double, Float, Int, MainActor, Never (+24 more)

### Community 45 - "AudioSettings"
Cohesion: 0.11
Nodes (19): Double, Hashable, AudioOutputDevice, AudioSampleRate, .displayName, .id, rate44100, rate48000 (+11 more)

### Community 46 - "TrackPitchControlView"
Cohesion: 0.15
Nodes (14): .actionButtons, Binding, Bool, Double, String, UUID, TrackPitchControlView, .menuTitle (+6 more)

### Community 47 - "MIDIInputService"
Cohesion: 0.08
Nodes (24): Identifiable, MIDINotifyProc, MIDIPacket, MIDIPacketList, MIDISourceInfo, MIDIInputEvent, MIDIInputService, MIDISourceInfo (+16 more)

### Community 48 - ".configure"
Cohesion: 0.22
Nodes (3): AVAudioSession, AVAudioUnitEQ, AudioDeviceID

### Community 49 - ".format"
Cohesion: 0.20
Nodes (8): Bool, String, TimeInterval, TimeFormatting, .formattedCurrentTime, .formattedDuration, .chipLabelBlock, .body

### Community 51 - "ConnectionState"
Cohesion: 0.33
Nodes (6): ConnectionState, connected, failed, idle, searching, String

### Community 52 - "LyricPlaySyncMessageKind"
Cohesion: 0.22
Nodes (9): LyricPlaySyncMessageKind, catalogRequest, catalogResponse, error, linkSection, linkSectionAck, presence, presenceAck (+1 more)

### Community 53 - ".applyMIDILearn"
Cohesion: 0.24
Nodes (4): MIDIInputEvent, MIDILearnTarget, UInt8, .body

### Community 54 - "DAWVerticalFaderView"
Cohesion: 0.09
Nodes (25): ClosedRange, Double, Float, String, TrackVolumeSettings, .trackRange, DAWVerticalFaderView, .body (+17 more)

### Community 55 - "TimeInterval"
Cohesion: 0.12
Nodes (10): SectionEdgeGuides, Bool, SectionLoopContext, TimeInterval, Timer, TimelineScrollAlignment, center, leading (+2 more)

### Community 56 - "Foundation"
Cohesion: 0.17
Nodes (6): AVFoundation, CoreMIDI, Foundation, Observation, PlatformPlaybackStrategyFactory, SnapGrid

### Community 57 - "TransportBarStyle"
Cohesion: 0.50
Nodes (3): TransportBarStyle, phoneBottomDock, standard

### Community 58 - ".activeGroupIndex"
Cohesion: 0.20
Nodes (3): AudioClip, Int, .trackHeaderColumnTracksOnly

### Community 60 - ".sectionLyricAssignRow"
Cohesion: 0.20
Nodes (5): .expandedPanel, .lyricCatalogStatus, SectionLyricLinkSheet, .body, .unavailableState

### Community 61 - ".sectionMappingCard"
Cohesion: 0.19
Nodes (8): Configuration, MIDINoteAssignment, SectionMappingAssignButtonStyle, SectionMappingCardGlow, SectionMappingPlayButtonStyle, Bool, CGFloat, Content

### Community 62 - "ResizeEdge"
Cohesion: 0.67
Nodes (3): ResizeEdge, end, start

### Community 63 - ".play"
Cohesion: 0.18
Nodes (15): Int64, ScheduledClip, AudioClip, AVAudioFile, AVAudioFrameCount, AVAudioPlayerNode, AVAudioTime, AVAudioUnitTimePitch (+7 more)

### Community 64 - "DAWProject"
Cohesion: 0.29
Nodes (6): groups, DAWProject, AudioClip, Int, TrackGroup, UUID

### Community 65 - "WorkspaceSettingsView"
Cohesion: 0.22
Nodes (7): Binding, Bool, String, WorkspaceSettingsView, .body, .deleteSectionDialogTitle, .sectionDeletionDialogBinding

### Community 66 - "TopToolbarView"
Cohesion: 0.15
Nodes (18): Bool, String, Void, ToolbarMenuButtonStyleModifier, TopToolbarView, .importButton, .importMenuItems, .isCompact (+10 more)

### Community 67 - "WorkspaceViewModel"
Cohesion: 0.07
Nodes (22): Date, ClosedRange, DAWProject, SectionPlaybackMode, Set, WorkspaceViewModel, .activePitchTrack, .activePlaybackSection (+14 more)

### Community 70 - "UIKitToolbarMenuButtonRepresentable"
Cohesion: 0.23
Nodes (9): .projectSessionMenuItems, Coordinator, .body, Context, String, Void, UIKitToolbarMenuButtonRepresentable, UIButton (+1 more)

### Community 71 - "DAWTheme"
Cohesion: 0.11
Nodes (20): Glass, .assignModeToggle, .learnBanner, .markerHeaderRow, DAWGlassChrome, .controlGlass, .panelGlass, CGFloat (+12 more)

### Community 73 - ".log"
Cohesion: 0.38
Nodes (6): ArrangementPlaybackEngine, SectionTriggerDiagnostics, Bool, String, TimeInterval, UUID

### Community 74 - "AudioEngineService.swift"
Cohesion: 0.17
Nodes (10): AudioUnit, CoreAudio, os, AudioEngineError, clipLoadFailed, deviceSelectionFailed, engineStartFailed, .errorDescription (+2 more)

### Community 75 - "SidebarPanel"
Cohesion: 0.11
Nodes (35): Selection, .audioSettings, .playbackSettings, .sectionEditor, .selectedMarkerEditor, .selectionInfo, .sessionManagement, .trackPitch (+27 more)

### Community 76 - "Color"
Cohesion: 0.25
Nodes (8): .defaultColor, Color, StandardTrackRole, .fallbackColor, Int, StandardTrackRole, String, TrackColorPalette

### Community 79 - "View"
Cohesion: 0.12
Nodes (15): Configuration, AudioDropOverlay, .body, String, TimelineEmptyDropHint, .body, PanKnobView, .body (+7 more)

### Community 80 - "LyricSlideCatalogItem"
Cohesion: 0.27
Nodes (8): LinkSectionCommand, LyricPlaySync, LyricSlideCatalog, LyricSlideCatalogItem, .id, Int, UUID, String

### Community 81 - "AudioClip"
Cohesion: 0.36
Nodes (7): AudioClip, .endTime, Int, String, TimeInterval, URL, UUID

### Community 83 - "IOSPlaybackStrategy"
Cohesion: 0.20
Nodes (9): IOSPlaybackStrategy, .meterTapBufferSize, AVAudioFile, AVAudioFrameCount, AVAudioFramePosition, AVAudioPlayerNode, AVAudioTime, Double (+1 more)

### Community 85 - ".loadBucket"
Cohesion: 0.53
Nodes (4): CGFloat, Int, WaveformLOD, .requiredLOD

### Community 86 - "SectionPlaybackMode"
Cohesion: 0.15
Nodes (11): CaseIterable, SectionPlaybackMode, continueTimeline, continueToNext, .displayName, .id, oneShot, repeatSection (+3 more)

### Community 87 - "SectionPlaybackStatus"
Cohesion: 0.33
Nodes (5): SectionPlaybackStatus, idle, playing, queued, repeatingAtEnd

### Community 88 - ".setMasterVolume"
Cohesion: 0.40
Nodes (4): .masterVolumeBinding, .masterVolumeBinding, Binding, .masterVolumeBinding

### Community 90 - ".applyLoadedProject"
Cohesion: 0.09
Nodes (7): Content, View, TransportCommands, .body, View, WorkspaceKeyboardShortcuts, Content

### Community 92 - "Sendable"
Cohesion: 0.18
Nodes (12): Sendable, MIDILearnTarget, section, MIDINoteAssignment, .displayName, Bool, String, UInt8 (+4 more)

## Knowledge Gaps
- **315 isolated node(s):** `id`, `name`, `startTime`, `endTime`, `colorHex` (+310 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **12 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `WorkspaceViewModel` connect `WorkspaceViewModel` to `View`, `TrackLaneView`, `CGFloat`, `ArrangementSection`, `MixerPanelView`, `TimelineWorkspacePanel`, `TimelineOverviewBar`, `PropertiesSidebarView`, `AudioEngineService`, `.applyImportedStems`, `MIDIMappingBarView`, `TransportBarView`, `ProjectPersistenceService`, `SupportedAudioFormats`, `UUID`, `AudioTrack`, `WorkspaceView`, `LyricPlaySyncClient`, `AudioImportService`, `SwiftUI`, `AudioSettings`, `TrackPitchControlView`, `MIDIInputService`, `.format`, `.setZoom`, `.applyMIDILearn`, `TimeInterval`, `Foundation`, `.activeGroupIndex`, `.sectionLyricAssignRow`, `.sectionMappingCard`, `WorkspaceSettingsView`, `TopToolbarView`, `UIKitToolbarMenuButtonRepresentable`, `LyricSlideCatalogItem`, `SectionPlaybackStatus`, `.setMasterVolume`, `.applyLoadedProject`?**
  _High betweenness centrality (0.484) - this node is a cross-community bridge._
- **Why does `AudioEngineService` connect `AudioEngineService` to `MacOSPlaybackStrategy`, `Float`, `UUID`, `WorkspaceViewModel`, `AudioEngineService.swift`, `.configure`, `IOSPlaybackStrategy`, `.applyLoadedProject`, `.stop`, `.play`?**
  _High betweenness centrality (0.154) - this node is a cross-community bridge._
- **Why does `ArrangementSection` connect `ArrangementSection` to `View`, `PropertiesSidebarView`, `MIDIMappingBarView`, `Equatable`, `CodingKeys`, `DAWProject`, `LyricPlaySyncClient`, `SwiftUI`, `MIDIInputService`, `.format`, `.applyMIDILearn`, `TimeInterval`, `.sectionLyricAssignRow`, `.sectionMappingCard`, `WorkspaceViewModel`, `SidebarPanel`, `LyricSlideCatalogItem`, `SectionPlaybackStatus`, `Sendable`?**
  _High betweenness centrality (0.095) - this node is a cross-community bridge._
- **Are the 11 inferred relationships involving `WorkspaceViewModel` (e.g. with `AudioEngineService` and `AudioImportService`) actually correct?**
  _`WorkspaceViewModel` has 11 INFERRED edges - model-reasoned connections that need verification._
- **Are the 2 inferred relationships involving `AudioEngineService` (e.g. with `WorkspaceViewModel` and `.configureAudioEngine()`) actually correct?**
  _`AudioEngineService` has 2 INFERRED edges - model-reasoned connections that need verification._
- **Are the 4 inferred relationships involving `ArrangementSection` (e.g. with `.body` and `.body`) actually correct?**
  _`ArrangementSection` has 4 INFERRED edges - model-reasoned connections that need verification._
- **What connects `id`, `name`, `startTime` to the rest of the system?**
  _315 weakly-connected nodes found - possible documentation gaps or missing edges._