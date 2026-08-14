# Graph Report - SimplePlay  (2026-08-14)

## Corpus Check
- 108 files · ~54,745 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 1869 nodes · 4402 edges · 104 communities (97 shown, 7 thin omitted)
- Extraction: 91% EXTRACTED · 9% INFERRED · 0% AMBIGUOUS · INFERRED: 398 edges (avg confidence: 0.8)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `fb08932b`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- SimplePlayUITests
- SectionMarkerChipView
- MacOSPlaybackStrategy
- What You Must Do When Invoked
- TrackLaneView
- graphify reference: extra exports and benchmark
- SimplePlayProjectArchive
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
- AudioDeviceService
- AudioEngineService
- StandardTrackRole
- CGFloat
- .applyImportedStems
- MIDIMappingBarView
- LyricPlaySyncTransportError
- TransportBarView
- TrackGroup
- .frames
- Sendable
- CodingKeys
- Testing
- TrackOrganizationService
- .sectionMappingCard
- SupportedAudioFormats
- View
- Float
- UUID
- PitchShiftSettings
- LyricPlaySyncCodec
- ImportDocumentPickerSession
- LyricPlaySyncClient
- AudioImportService
- SwiftUI
- FaderMeterStripView
- .peaks
- PropertiesSidebarView
- TrackPitchControlView
- MIDIInputService
- AudioEngineServiceIOS
- AudioSettings
- AudioTrack
- PinnedTimelineHeaderStrip
- LyricPlaySyncMessageKind
- WorkspaceView
- TrackVolumeSettings
- TimeInterval
- Foundation
- DAWProject
- .body
- .stop
- DAWProject
- .hex
- Audio Engine — Agent Guide
- .play
- Bool
- Color
- TopToolbarView
- WorkspaceViewModel
- WorkspaceSettingsView
- AudioEngineService
- UIKitToolbarMenuButtonRepresentable
- DAWGlassChrome
- .log
- .triggerSection
- SettingsFieldLabel
- .selectedMarkerEditor
- AudioOutputDevice
- TrackMeterIndicatorView
- AudioDropTargetModifier
- DAWTheme
- LyricPlaySyncMessage
- SimplePlayProjectFileDocument
- Task
- IOSPlaybackStrategy
- TrackControlButton
- DAWVerticalFaderView
- AudioSampleRate
- SectionPlaybackStatus
- .stem
- AudioEngineError
- .stop
- DropURLLoader
- .setZoom
- .attachClip
- .loadBucket
- .presentImportPanel
- .sessionManagement
- .setMasterVolume
- WorkspaceViewModel.swift
- TimelineScrollAlignment
- TransportBarStyle
- SimplePlayTests.swift
- SnapGrid.swift

## God Nodes (most connected - your core abstractions)
1. `WorkspaceViewModel` - 262 edges
2. `AudioEngineService` - 106 edges
3. `ArrangementSection` - 70 edges
4. `DAWTheme` - 52 edges
5. `MIDIMappingBarView` - 48 edges
6. `AudioTrack` - 44 edges
7. `ArrangementPlaybackEngine` - 36 edges
8. `MixerPanelView` - 35 edges
9. `PropertiesSidebarView` - 32 edges
10. `CodingKeys` - 31 edges

## Surprising Connections (you probably didn't know these)
- `.duration` --references--> `AudioTrack`  [INFERRED]
  SimplePlay/Core/Models/DAWProject.swift → SimplePlay/Core/Models/AudioTrack.swift
- `TrackOrganizationServiceTests` --calls--> `TrackOrganizationService`  [EXTRACTED]
  SimplePlayTests/TrackOrganizationServiceTests.swift → SimplePlay/Core/Services/TrackOrganizationService.swift
- `.actionButtons` --calls--> `TrackPitchControlView`  [INFERRED]
  SimplePlay/Features/Workspace/Views/TopToolbarView.swift → SimplePlay/Features/Workspace/Views/TrackPitchControlView.swift
- `.body` --calls--> `WorkspaceView`  [INFERRED]
  SimplePlay/ContentView.swift → SimplePlay/Features/Workspace/Views/WorkspaceView.swift
- `.body` --references--> `ArrangementSection`  [INFERRED]
  SimplePlay/Features/Workspace/Views/SectionMarkerLaneView.swift → SimplePlay/Core/Models/ArrangementSection.swift

## Import Cycles
- None detected.

## Communities (104 total, 7 thin omitted)

### Community 0 - "SimplePlayUITests"
Cohesion: 0.15
Nodes (6): SimplePlayUITests, SimplePlayUITestsLaunchTests, .runsForEachTargetApplicationUIConfiguration, Bool, XCTest, XCTestCase

### Community 1 - "SectionMarkerChipView"
Cohesion: 0.06
Nodes (41): NSCursor, Bool, String, TimeInterval, TimeFormatting, SectionDragKind, move, resizeEnd (+33 more)

### Community 2 - "MacOSPlaybackStrategy"
Cohesion: 0.19
Nodes (11): MacOSPlaybackStrategy, .meterTapBufferSize, AudioEngineService, AVAudioFile, AVAudioFrameCount, AVAudioFramePosition, AVAudioPlayerNode, AVAudioTime (+3 more)

### Community 3 - "What You Must Do When Invoked"
Cohesion: 0.08
Nodes (24): For /graphify add and --watch, For /graphify query, For the commit hook and native AGENTS.md integration, For --update and --cluster-only, /graphify, Honesty Rules, Interpreter guard for subcommands, Part A - Structural extraction for code files (+16 more)

### Community 4 - "TrackLaneView"
Cohesion: 0.09
Nodes (26): G, GraphicsContext, CGFloat, String, TimeInterval, TimelineRulerScale, ClipDragInteractionModifier, ClipSelectionModifiers (+18 more)

### Community 5 - "graphify reference: extra exports and benchmark"
Cohesion: 0.22
Nodes (8): graphify reference: extra exports and benchmark, Step 6b - Wiki (only if --wiki flag), Step 7 - Neo4j export (only if --neo4j or --neo4j-push flag), Step 7a - FalkorDB export (only if --falkordb or --falkordb-push flag), Step 7b - SVG export (only if --svg flag), Step 7c - GraphML export (only if --graphml flag), Step 7d - MCP server (only if --mcp flag), Step 8 - Token reduction benchmark (only if total_words > 5000)

### Community 6 - "SimplePlayProjectArchive"
Cohesion: 0.16
Nodes (15): Asset, SimplePlayProjectArchive, SimplePlayProjectArchiveError, corruptAsset, corruptManifest, .errorDescription, invalidArchive, Bool (+7 more)

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
Cohesion: 0.06
Nodes (44): ArrangementSection, .color, .duration, .hasLyricSlideLink, Bool, Decoder, Int, String (+36 more)

### Community 15 - "MixerPanelView"
Cohesion: 0.11
Nodes (19): MixerPanelView, .body, .channelFaderHeight, .channelFaderWidth, .channelStripWidth, .groupDivider, .isCompact, .masterFaderHeight (+11 more)

### Community 16 - "TimelineWorkspacePanel"
Cohesion: 0.17
Nodes (21): ScrollPosition, PlayheadView, .body, .playheadDragGesture, CGFloat, Double, Gesture, Int (+13 more)

### Community 17 - "TimelineOverviewBar"
Cohesion: 0.11
Nodes (21): Path, Bool, CGFloat, CGSize, ClosedRange, Gesture, TimeInterval, TimelineOverviewBar (+13 more)

### Community 18 - "AudioDeviceService"
Cohesion: 0.20
Nodes (7): AudioDeviceService, AudioDeviceID, Bool, Int, String, UInt32, .selectedDevice

### Community 19 - "AudioEngineService"
Cohesion: 0.06
Nodes (23): AVAudioEngine, AVAudioUnitEQ, AudioEngineService, .avEngine, .engineIsRunning, .isAnyPlayerPlaying, .isMeterMonitoringEnabled, .isPlaybackGraphReady (+15 more)

### Community 20 - "StandardTrackRole"
Cohesion: 0.08
Nodes (24): StandardTrackRole, acousticGuitar, backingVocal, bass, brass, click, countIn, cue (+16 more)

### Community 21 - "CGFloat"
Cohesion: 0.18
Nodes (6): CGFloat, TimelineScrollRequest, .minimumTimelineZoom, .timelineContentWidth, .chipMoveOrTapGesture, .sectionCreationGesture

### Community 22 - ".applyImportedStems"
Cohesion: 0.13
Nodes (6): Error, Result, DAWProject, String, URL, .workspaceRoot

### Community 23 - "MIDIMappingBarView"
Cohesion: 0.12
Nodes (17): Animation, AnyTransition, MIDIMappingBarView, .assignModeToggleTitle, .body, .collapsedBar, .collapsedBarContent, .devicePickerLabel (+9 more)

### Community 24 - "LyricPlaySyncTransportError"
Cohesion: 0.14
Nodes (13): LocalizedError, Network, ConnectionState, connected, failed, idle, searching, LyricPlaySyncTransportError (+5 more)

### Community 25 - "TransportBarView"
Cohesion: 0.13
Nodes (16): Bool, CGFloat, Double, String, Void, TransportBarView, .body, .isCompact (+8 more)

### Community 26 - "TrackGroup"
Cohesion: 0.27
Nodes (8): Date, Decoder, Double, Encoder, String, TimeInterval, UUID, TrackGroup

### Community 27 - ".frames"
Cohesion: 0.29
Nodes (6): Bool, Double, Int64, TimeInterval, TimelineSampleGrid, TimelineSampleGridTests

### Community 28 - "Sendable"
Cohesion: 0.05
Nodes (54): Codable, Equatable, Sendable, AudioClip, .endTime, Int, String, TimeInterval (+46 more)

### Community 29 - "CodingKeys"
Cohesion: 0.04
Nodes (48): CodingKey, CodingKeys, colorHex, endTime, id, lyricDocumentID, lyricSlideID, lyricSlideOrder (+40 more)

### Community 30 - "Testing"
Cohesion: 0.22
Nodes (4): CoreGraphics, SimplePlay, ProjectArchiveTests, Testing

### Community 31 - "TrackOrganizationService"
Cohesion: 0.28
Nodes (10): ImportedStem, ImportPlacement, appendNewGroup, insertIntoGroup, DAWProject, Int, String, TimeInterval (+2 more)

### Community 32 - ".sectionMappingCard"
Cohesion: 0.29
Nodes (6): MIDINoteAssignment, .displayName, Bool, String, UInt8, .expandedPanel

### Community 33 - "SupportedAudioFormats"
Cohesion: 0.19
Nodes (11): SimplePlayProjectType, UTType, SupportedAudioFormats, .contentTypes, .dropTypes, .filePickerTypes, .folderPickerTypes, .importPickerTypes (+3 more)

### Community 34 - "View"
Cohesion: 0.22
Nodes (9): ButtonStyle, DAWIconToolbarButtonStyle, DAWLabeledToolbarButtonStyle, DAWPrimaryButtonStyle, Configuration, Content, .body, .settingsHeader (+1 more)

### Community 35 - "Float"
Cohesion: 0.22
Nodes (6): AVAudioMixerNode, AVAudioPCMBuffer, MeterPeakBuffer, Float, UUID, Void

### Community 36 - "UUID"
Cohesion: 0.09
Nodes (17): Double, Float, UUID, .mixerScrollWithPinnedMasters, Binding, Double, UUID, Binding (+9 more)

### Community 37 - "PitchShiftSettings"
Cohesion: 0.22
Nodes (6): PitchShiftSettings, AVAudioUnitTimePitch, Bool, Double, Float, PitchShiftSettingsTests

### Community 38 - "LyricPlaySyncCodec"
Cohesion: 0.40
Nodes (4): LyricPlaySyncCodec, Data, JSONEncoder, .pretty

### Community 39 - "ImportDocumentPickerSession"
Cohesion: 0.06
Nodes (29): App, AppKit, Notification, NSApplicationDelegate, NSEvent, NSObject, NSView, NSViewRepresentable (+21 more)

### Community 40 - "LyricPlaySyncClient"
Cohesion: 0.25
Nodes (7): NWBrowser, NWEndpoint, LyricPlaySyncClient, Never, Set, TimeInterval, Void

### Community 41 - "AudioImportService"
Cohesion: 0.08
Nodes (25): AudioFileStorageService, String, URL, UUID, AudioImportError, emptySelection, .errorDescription, storageUnavailable (+17 more)

### Community 42 - "SwiftUI"
Cohesion: 0.20
Nodes (5): Bool, Double, TrackWaveformProgressBar, .body, SwiftUI

### Community 43 - "FaderMeterStripView"
Cohesion: 0.12
Nodes (14): .mastersStripRow, .projectMasterStrip, String, .mainVolumeControl, FaderMeterStripView, .reservesThumbClearance, .showsUnityMark, .usesUnityCenterDecibelScale (+6 more)

### Community 44 - ".peaks"
Cohesion: 0.09
Nodes (29): CheckedContinuation, clips, Double, Float, Int, MainActor, Never, Sendable (+21 more)

### Community 45 - "PropertiesSidebarView"
Cohesion: 0.15
Nodes (16): PropertiesSidebarView, .body, .pitchIsOriginal, .pitchLabel, .sectionCreationHint, .selectedDeviceID, .selectedSection, .selectedSectionNameBinding (+8 more)

### Community 46 - "TrackPitchControlView"
Cohesion: 0.16
Nodes (13): Binding, Bool, Double, String, UUID, TrackPitchControlView, .menuTitle, .pitchIsOriginal (+5 more)

### Community 47 - "MIDIInputService"
Cohesion: 0.08
Nodes (22): MIDINotifyProc, MIDIPacket, MIDIPacketList, MIDIInputEvent, MIDIInputService, MIDISourceInfo, .id, Bool (+14 more)

### Community 48 - "AudioEngineServiceIOS"
Cohesion: 0.33
Nodes (3): AVAudioSession, AudioEngineServiceIOS, Bool

### Community 49 - "AudioSettings"
Cohesion: 0.19
Nodes (9): AnyObject, AudioSettings, .usesCustomOutputDevice, Bool, AudioEnginePlatformServices, AudioEnginePlatformServicesFactory, AudioEngineServiceHost, AudioEngineServiceMacOS (+1 more)

### Community 50 - "AudioTrack"
Cohesion: 0.24
Nodes (11): AudioTrack, .color, .displayName, Bool, Double, StandardTrackRole, String, UUID (+3 more)

### Community 51 - "PinnedTimelineHeaderStrip"
Cohesion: 0.16
Nodes (12): Bool, CGFloat, Content, TimelineHorizontalMirror, .body, TimelineScrollCoordinator, PinnedTimelineHeaderStrip, .body (+4 more)

### Community 52 - "LyricPlaySyncMessageKind"
Cohesion: 0.22
Nodes (9): LyricPlaySyncMessageKind, catalogRequest, catalogResponse, error, linkSection, linkSectionAck, presence, presenceAck (+1 more)

### Community 53 - "WorkspaceView"
Cohesion: 0.22
Nodes (10): ScenePhase, Binding, Bool, String, WorkspaceLifecycleModifier, WorkspaceView, .body, .deleteSectionDialogTitle (+2 more)

### Community 54 - "TrackVolumeSettings"
Cohesion: 0.20
Nodes (9): ClosedRange, Double, Float, String, TrackVolumeSettings, .trackRange, .body, .normalizedPosition (+1 more)

### Community 55 - "TimeInterval"
Cohesion: 0.14
Nodes (6): SectionEdgeGuides, Bool, TimeInterval, Timer, .activeSectionEdgeGuides, Content

### Community 56 - "Foundation"
Cohesion: 0.17
Nodes (6): AudioUnit, AVFoundation, CoreAudio, CoreMIDI, Foundation, os

### Community 57 - "DAWProject"
Cohesion: 0.31
Nodes (9): DAWProject, .duration, Bool, Double, Int32, String, TimeInterval, UInt8 (+1 more)

### Community 58 - ".body"
Cohesion: 0.11
Nodes (8): Bool, TimeInterval, Int, Content, TimelineAudioDropModifier, .body, .body, .trackHeaderColumnTracksOnly

### Community 59 - ".stop"
Cohesion: 0.22
Nodes (3): AVAudioNode, .playbackGraphIsHealthy, AVAudioPlayerNode

### Community 60 - "DAWProject"
Cohesion: 0.38
Nodes (4): groups, DAWProject, Int, UUID

### Community 61 - ".hex"
Cohesion: 0.40
Nodes (5): .defaultColor, Int, StandardTrackRole, String, TrackColorPalette

### Community 62 - "Audio Engine — Agent Guide"
Cohesion: 0.20
Nodes (9): Architecture (do not collapse), Audio Engine — Agent Guide, Before you edit, iOS session rules (critical), Log messages, macOS device rules, Red flags (stop and reconsider), Safe change map (+1 more)

### Community 63 - ".play"
Cohesion: 0.17
Nodes (13): SectionLoopContext, .duration, TimeInterval, UUID, AVAudioFrameCount, AVAudioTime, Bool, DAWProject (+5 more)

### Community 64 - "Bool"
Cohesion: 0.20
Nodes (7): SectionMappingAssignButtonStyle, SectionMappingCardGlow, SectionMappingPlayButtonStyle, Bool, CGFloat, Configuration, Content

### Community 65 - "Color"
Cohesion: 0.27
Nodes (3): Color, StandardTrackRole, .fallbackColor

### Community 66 - "TopToolbarView"
Cohesion: 0.14
Nodes (18): Bool, String, Void, ToolbarMenuButtonStyleModifier, TopToolbarView, .actionButtons, .importButton, .isCompact (+10 more)

### Community 67 - "WorkspaceViewModel"
Cohesion: 0.06
Nodes (21): ClosedRange, Date, Set, UInt8, WorkspaceViewModel, .activePitchTrack, .activePlaybackSection, .canSaveDirectlyToCurrentURL (+13 more)

### Community 68 - "WorkspaceSettingsView"
Cohesion: 0.28
Nodes (7): Binding, Bool, String, WorkspaceSettingsView, .body, .deleteSectionDialogTitle, .sectionDeletionDialogBinding

### Community 69 - "AudioEngineService"
Cohesion: 0.40
Nodes (3): AudioEngineService, AVAudioTime, TimeInterval

### Community 70 - "UIKitToolbarMenuButtonRepresentable"
Cohesion: 0.33
Nodes (7): Coordinator, Context, String, Void, UIKitToolbarMenuButtonRepresentable, UIButton, UIViewRepresentable

### Community 71 - "DAWGlassChrome"
Cohesion: 0.17
Nodes (10): Glass, DAWGlassChrome, .controlGlass, .panelGlass, CGFloat, Double, LinearGradient, View (+2 more)

### Community 72 - ".log"
Cohesion: 0.38
Nodes (6): SectionLoopDiagnostics, AVAudioFrameCount, Double, Int64, String, TimeInterval

### Community 73 - ".triggerSection"
Cohesion: 0.27
Nodes (5): SectionTriggerDiagnostics, Bool, String, TimeInterval, UUID

### Community 74 - "SettingsFieldLabel"
Cohesion: 0.29
Nodes (8): .volumeControls, SettingsControlSurface, .body, SettingsFieldLabel, .body, .body, .body, Content

### Community 75 - ".selectedMarkerEditor"
Cohesion: 0.12
Nodes (30): Selection, .audioSettings, .playbackSettings, .sectionEditor, .selectedMarkerEditor, .selectionInfo, .trackPitch, DAWSecondaryButtonStyle (+22 more)

### Community 76 - "AudioOutputDevice"
Cohesion: 0.52
Nodes (5): Hashable, AudioOutputDevice, Int, String, UInt32

### Community 77 - "TrackMeterIndicatorView"
Cohesion: 0.25
Nodes (9): .body, Bool, CGFloat, Double, Float, Int, TrackMeterIndicatorView, .body (+1 more)

### Community 78 - "AudioDropTargetModifier"
Cohesion: 0.27
Nodes (7): AudioDropTargetModifier, Content, NSItemProvider, String, TimeInterval, View, View

### Community 79 - "DAWTheme"
Cohesion: 0.14
Nodes (14): .assignModeToggle, .learnBanner, AudioDropOverlay, .body, String, TimelineEmptyDropHint, .body, .body (+6 more)

### Community 80 - "LyricPlaySyncMessage"
Cohesion: 0.24
Nodes (11): serverError, LinkSectionCommand, LyricPlaySync, LyricPlaySyncMessage, LyricSlideCatalog, LyricSlideCatalogItem, .id, ShowSlideCommand (+3 more)

### Community 81 - "SimplePlayProjectFileDocument"
Cohesion: 0.22
Nodes (7): FileDocument, FileWrapper, ReadConfiguration, SimplePlayProjectFileDocument, .readableContentTypes, Data, WriteConfiguration

### Community 82 - "Task"
Cohesion: 0.31
Nodes (5): .lyricCatalogStatus, SectionLyricLinkSheet, .body, .unavailableState, Task

### Community 83 - "IOSPlaybackStrategy"
Cohesion: 0.19
Nodes (11): IOSPlaybackStrategy, .meterTapBufferSize, AudioEngineService, AVAudioFile, AVAudioFrameCount, AVAudioFramePosition, AVAudioPlayerNode, AVAudioTime (+3 more)

### Community 84 - "TrackControlButton"
Cohesion: 0.22
Nodes (8): PanKnobView, .body, Bool, Double, String, Void, TrackControlButton, .body

### Community 85 - "DAWVerticalFaderView"
Cohesion: 0.25
Nodes (7): DAWVerticalFaderView, .span, .thumbHeight, CGFloat, ClosedRange, Double, String

### Community 86 - "AudioSampleRate"
Cohesion: 0.15
Nodes (12): CaseIterable, Double, Identifiable, AudioSampleRate, .displayName, .id, rate44100, rate48000 (+4 more)

### Community 87 - "SectionPlaybackStatus"
Cohesion: 0.33
Nodes (5): SectionPlaybackStatus, idle, playing, queued, repeatingAtEnd

### Community 88 - ".stem"
Cohesion: 0.36
Nodes (3): String, TimeInterval, TrackOrganizationServiceTests

### Community 89 - "AudioEngineError"
Cohesion: 0.29
Nodes (7): AudioEngineError, clipLoadFailed, deviceSelectionFailed, engineStartFailed, .errorDescription, noPlayableClips, playbackUnavailable

### Community 90 - ".stop"
Cohesion: 0.12
Nodes (12): Commands, ContentView, .body, FileCommands, Content, View, TransportCommands, .body (+4 more)

### Community 91 - "DropURLLoader"
Cohesion: 0.62
Nodes (4): DropURLLoader, NSItemProvider, String, URL

### Community 93 - ".attachClip"
Cohesion: 0.47
Nodes (3): ScheduledClip, AVAudioFile, AVAudioUnitTimePitch

### Community 94 - ".loadBucket"
Cohesion: 0.53
Nodes (4): CGFloat, Int, WaveformLOD, .requiredLOD

### Community 95 - ".presentImportPanel"
Cohesion: 0.33
Nodes (5): ImportPanelKind, audioFiles, folder, .importMenuItems, .body

### Community 96 - ".sessionManagement"
Cohesion: 0.60
Nodes (3): .sessionManagement, .projectSessionMenuItems, .body

### Community 98 - ".setMasterVolume"
Cohesion: 0.40
Nodes (4): .masterVolumeBinding, .masterVolumeBinding, Binding, .masterVolumeBinding

### Community 100 - "TimelineScrollAlignment"
Cohesion: 0.50
Nodes (4): TimelineScrollAlignment, center, leading, start

### Community 101 - "TransportBarStyle"
Cohesion: 0.50
Nodes (3): TransportBarStyle, phoneBottomDock, standard

## Knowledge Gaps
- **326 isolated node(s):** `id`, `name`, `startTime`, `endTime`, `colorHex` (+321 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **7 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `WorkspaceViewModel` connect `WorkspaceViewModel` to `SectionMarkerChipView`, `TrackLaneView`, `ArrangementSection`, `MixerPanelView`, `TimelineWorkspacePanel`, `TimelineOverviewBar`, `AudioDeviceService`, `CGFloat`, `.applyImportedStems`, `MIDIMappingBarView`, `TransportBarView`, `Sendable`, `TrackOrganizationService`, `.sectionMappingCard`, `UUID`, `ImportDocumentPickerSession`, `LyricPlaySyncClient`, `AudioImportService`, `PropertiesSidebarView`, `TrackPitchControlView`, `MIDIInputService`, `AudioTrack`, `PinnedTimelineHeaderStrip`, `WorkspaceView`, `TimeInterval`, `.body`, `Bool`, `Color`, `TopToolbarView`, `WorkspaceSettingsView`, `.triggerSection`, `AudioOutputDevice`, `AudioDropTargetModifier`, `LyricPlaySyncMessage`, `SimplePlayProjectFileDocument`, `Task`, `AudioSampleRate`, `SectionPlaybackStatus`, `.stop`, `.setZoom`, `.presentImportPanel`, `.sessionManagement`, `.sectionLyricAssignRow`, `.setMasterVolume`, `WorkspaceViewModel.swift`, `TimelineScrollAlignment`?**
  _High betweenness centrality (0.361) - this node is a cross-community bridge._
- **Why does `ArrangementSection` connect `ArrangementSection` to `.sectionMappingCard`, `Color`, `.sectionLyricAssignRow`, `WorkspaceViewModel`, `SectionMarkerChipView`, `.triggerSection`, `SwiftUI`, `.selectedMarkerEditor`, `PropertiesSidebarView`, `MIDIInputService`, `Task`, `MIDIMappingBarView`, `AudioSampleRate`, `TimeInterval`, `SectionPlaybackStatus`, `DAWProject`, `Sendable`, `CodingKeys`?**
  _High betweenness centrality (0.117) - this node is a cross-community bridge._
- **Why does `Foundation` connect `Foundation` to `SectionMarkerChipView`, `SimplePlayProjectArchive`, `ArrangementSection`, `LyricPlaySyncTransportError`, `TrackGroup`, `.frames`, `Sendable`, `Testing`, `SupportedAudioFormats`, `AudioImportService`, `SwiftUI`, `AudioSettings`, `TrackVolumeSettings`, `DAWProject`, `.play`, `LyricPlaySyncMessage`, `AudioSampleRate`, `WorkspaceViewModel.swift`, `SnapGrid.swift`?**
  _High betweenness centrality (0.105) - this node is a cross-community bridge._
- **Are the 11 inferred relationships involving `WorkspaceViewModel` (e.g. with `ArrangementPlaybackEngine` and `AudioImportService`) actually correct?**
  _`WorkspaceViewModel` has 11 INFERRED edges - model-reasoned connections that need verification._
- **Are the 4 inferred relationships involving `ArrangementSection` (e.g. with `.body` and `.body`) actually correct?**
  _`ArrangementSection` has 4 INFERRED edges - model-reasoned connections that need verification._
- **What connects `id`, `name`, `startTime` to the rest of the system?**
  _326 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `SectionMarkerChipView` be split into smaller, more focused modules?**
  _Cohesion score 0.06298701298701298 - nodes in this community are weakly interconnected._