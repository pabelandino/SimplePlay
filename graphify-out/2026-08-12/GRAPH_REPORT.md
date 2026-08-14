# Graph Report - SimplePlay  (2026-08-12)

## Corpus Check
- 100 files · ~52,280 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 1749 nodes · 4194 edges · 77 communities (72 shown, 5 thin omitted)
- Extraction: 90% EXTRACTED · 10% INFERRED · 0% AMBIGUOUS · INFERRED: 408 edges (avg confidence: 0.8)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `a0b2df27`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- SimplePlayUITests
- SectionMarkerChipView
- CGFloat
- What You Must Do When Invoked
- TrackLaneView
- graphify reference: extra exports and benchmark
- LyricPlaySyncTransportError
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
- SimplePlayProjectFileDocument
- ProjectPersistenceService
- AudioEngineService
- StandardTrackRole
- .applyImportedStems
- .log
- MIDIMappingBarView
- PropertiesSidebarView
- SupportedAudioFormats
- LyricPlaySyncMessageKind
- .frames
- WorkspaceView
- CodingKeys
- Testing
- TrackOrganizationService
- DAWProject
- AudioDropTargetModifier
- UUID
- Float
- AudioSampleRate
- .play
- MIDILearnTarget
- ImportDocumentPickerSession
- DAWSecondaryButtonStyle
- View
- LyricPlaySyncClient
- AVFoundation
- .peaks
- AudioDeviceService
- DropURLLoader
- MIDIInputService
- SectionLyricLinkSheet
- AudioImportService
- TrackControlButton
- TrackGroup
- .applyLoadedProject
- SectionLoopContext
- DAWVerticalFaderView
- TimeInterval
- Foundation
- FileCommands
- .presentImportPanel
- .scheduleLoopBody
- AppKit
- MIDINoteAssignment
- AudioTrack
- .loadBucket
- PitchShiftSettings
- .workspaceRoot
- TopToolbarView
- WorkspaceViewModel
- ScheduledClip
- UniformTypeIdentifiers
- DAWTheme
- .hex
- Sendable
- TransportBarView
- DAWProject
- AudioClip
- SectionPlaybackMode

## God Nodes (most connected - your core abstractions)
1. `WorkspaceViewModel` - 260 edges
2. `AudioEngineService` - 87 edges
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
- `.selectedDevice` --references--> `WorkspaceViewModel`  [INFERRED]
  SimplePlay/Features/Workspace/Views/PropertiesSidebarView.swift → SimplePlay/Features/Workspace/ViewModels/WorkspaceViewModel.swift
- `.body` --calls--> `ContentView`  [INFERRED]
  SimplePlay/SimplePlayApp.swift → SimplePlay/ContentView.swift
- `.body` --references--> `ArrangementSection`  [INFERRED]
  SimplePlay/Features/Workspace/Views/SectionMarkerLaneView.swift → SimplePlay/Core/Models/ArrangementSection.swift
- `.body` --references--> `ArrangementSection`  [INFERRED]
  SimplePlay/Features/Workspace/Views/SectionMarkerLaneView.swift → SimplePlay/Core/Models/ArrangementSection.swift

## Import Cycles
- None detected.

## Communities (77 total, 5 thin omitted)

### Community 0 - "SimplePlayUITests"
Cohesion: 0.15
Nodes (6): SimplePlayUITests, SimplePlayUITestsLaunchTests, .runsForEachTargetApplicationUIConfiguration, Bool, XCTest, XCTestCase

### Community 1 - "SectionMarkerChipView"
Cohesion: 0.08
Nodes (36): NSCursor, Bool, String, TimeInterval, TimeFormatting, .formattedCurrentTime, .formattedDuration, ResizeEdge (+28 more)

### Community 2 - "CGFloat"
Cohesion: 0.11
Nodes (10): SectionDragKind, move, resizeEnd, resizeStart, CGFloat, TimelineScrollRequest, .minimumTimelineZoom, .timelineContentWidth (+2 more)

### Community 3 - "What You Must Do When Invoked"
Cohesion: 0.08
Nodes (24): For /graphify add and --watch, For /graphify query, For the commit hook and native AGENTS.md integration, For --update and --cluster-only, /graphify, Honesty Rules, Interpreter guard for subcommands, Part A - Structural extraction for code files (+16 more)

### Community 4 - "TrackLaneView"
Cohesion: 0.09
Nodes (26): G, GraphicsContext, CGFloat, String, TimeInterval, TimelineRulerScale, ClipDragInteractionModifier, ClipSelectionModifiers (+18 more)

### Community 5 - "graphify reference: extra exports and benchmark"
Cohesion: 0.22
Nodes (8): graphify reference: extra exports and benchmark, Step 6b - Wiki (only if --wiki flag), Step 7 - Neo4j export (only if --neo4j or --neo4j-push flag), Step 7a - FalkorDB export (only if --falkordb or --falkordb-push flag), Step 7b - SVG export (only if --svg flag), Step 7c - GraphML export (only if --graphml flag), Step 7d - MCP server (only if --mcp flag), Step 8 - Token reduction benchmark (only if total_words > 5000)

### Community 6 - "LyricPlaySyncTransportError"
Cohesion: 0.14
Nodes (13): LocalizedError, Network, ConnectionState, connected, failed, idle, searching, LyricPlaySyncTransportError (+5 more)

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
Cohesion: 0.05
Nodes (52): ArrangementSection, .color, .duration, .hasLyricSlideLink, CodingKeys, colorHex, endTime, id (+44 more)

### Community 15 - "MixerPanelView"
Cohesion: 0.06
Nodes (39): MixerPanelView, .body, .channelFaderHeight, .channelFaderWidth, .channelStripWidth, .groupDivider, .isCompact, .masterFaderHeight (+31 more)

### Community 16 - "TimelineWorkspacePanel"
Cohesion: 0.09
Nodes (36): ScrollPosition, Bool, CGFloat, Content, TimelineHorizontalMirror, .body, TimelineScrollCoordinator, PinnedTimelineHeaderStrip (+28 more)

### Community 17 - "SimplePlayProjectFileDocument"
Cohesion: 0.22
Nodes (7): FileDocument, FileWrapper, ReadConfiguration, SimplePlayProjectFileDocument, .readableContentTypes, Data, WriteConfiguration

### Community 18 - "ProjectPersistenceService"
Cohesion: 0.06
Nodes (40): SavedProjectDocument, DAWProject, JSONDecoder, .projectDecoder, JSONEncoder, .pretty, ManifestFile, ProjectPersistenceError (+32 more)

### Community 19 - "AudioEngineService"
Cohesion: 0.12
Nodes (11): AVAudioUnitEQ, AudioEngineService, .isAnyPlayerPlaying, .isMeterMonitoringEnabled, .isPlaybackGraphReady, .isSectionLoopPlaybackActive, .masterVolume, .primaryClipSampleRate (+3 more)

### Community 20 - "StandardTrackRole"
Cohesion: 0.08
Nodes (24): StandardTrackRole, acousticGuitar, backingVocal, bass, brass, click, countIn, cue (+16 more)

### Community 21 - ".applyImportedStems"
Cohesion: 0.22
Nodes (4): Error, Result, String, URL

### Community 22 - ".log"
Cohesion: 0.42
Nodes (5): SectionTriggerDiagnostics, Bool, String, TimeInterval, UUID

### Community 23 - "MIDIMappingBarView"
Cohesion: 0.09
Nodes (23): Animation, AnyTransition, Color, MIDIMappingBarView, .assignModeToggleTitle, .collapsedBar, .collapsedBarContent, .devicePickerLabel (+15 more)

### Community 24 - "PropertiesSidebarView"
Cohesion: 0.06
Nodes (56): Selection, PropertiesSidebarView, .audioSettings, .body, .pitchIsOriginal, .pitchLabel, .playbackSettings, .sectionCreationHint (+48 more)

### Community 25 - "SupportedAudioFormats"
Cohesion: 0.31
Nodes (9): UTType, SupportedAudioFormats, .contentTypes, .dropTypes, .filePickerTypes, .folderPickerTypes, .importPickerTypes, Set (+1 more)

### Community 26 - "LyricPlaySyncMessageKind"
Cohesion: 0.22
Nodes (9): LyricPlaySyncMessageKind, catalogRequest, catalogResponse, error, linkSection, linkSectionAck, presence, presenceAck (+1 more)

### Community 27 - ".frames"
Cohesion: 0.29
Nodes (6): Bool, Double, Int64, TimeInterval, TimelineSampleGrid, TimelineSampleGridTests

### Community 28 - "WorkspaceView"
Cohesion: 0.15
Nodes (13): ScenePhase, ContentView, .body, Binding, Bool, String, WorkspaceLifecycleModifier, WorkspaceView (+5 more)

### Community 29 - "CodingKeys"
Cohesion: 0.06
Nodes (49): Equatable, CodingKeys, audioSettings, colorHex, id, isLocked, isMuted, isPitchEnabled (+41 more)

### Community 30 - "Testing"
Cohesion: 0.18
Nodes (5): CoreGraphics, SimplePlay, ProjectArchiveTests, SimplePlayTests, Testing

### Community 31 - "TrackOrganizationService"
Cohesion: 0.19
Nodes (13): ImportedStem, ImportPlacement, appendNewGroup, insertIntoGroup, DAWProject, Int, String, TimeInterval (+5 more)

### Community 32 - "DAWProject"
Cohesion: 0.31
Nodes (9): DAWProject, .duration, Bool, Double, Int32, String, TimeInterval, UInt8 (+1 more)

### Community 33 - "AudioDropTargetModifier"
Cohesion: 0.27
Nodes (7): AudioDropTargetModifier, Content, NSItemProvider, String, TimeInterval, View, View

### Community 34 - "UUID"
Cohesion: 0.09
Nodes (15): Bool, TimeInterval, Double, Float, UUID, Binding, Double, TrackHeaderRowView (+7 more)

### Community 35 - "Float"
Cohesion: 0.24
Nodes (5): AVAudioMixerNode, MeterPeakBuffer, Float, UUID, Void

### Community 36 - "AudioSampleRate"
Cohesion: 0.19
Nodes (14): Double, Hashable, Identifiable, AudioOutputDevice, AudioSampleRate, .displayName, .id, rate44100 (+6 more)

### Community 37 - ".play"
Cohesion: 0.17
Nodes (4): AVAudioNode, AVAudioPlayerNode, .playbackGraphIsHealthy, DAWProject

### Community 38 - "MIDILearnTarget"
Cohesion: 0.18
Nodes (5): MIDILearnTarget, section, UUID, UInt8, .body

### Community 39 - "ImportDocumentPickerSession"
Cohesion: 0.08
Nodes (23): Notification, NSApplicationDelegate, NSEvent, NSObject, NSView, NSViewRepresentable, NSWindow, .body (+15 more)

### Community 40 - "DAWSecondaryButtonStyle"
Cohesion: 0.20
Nodes (11): ButtonStyle, .learnBanner, .lyricCatalogStatus, DAWIconToolbarButtonStyle, DAWLabeledToolbarButtonStyle, DAWPrimaryButtonStyle, DAWSecondaryButtonStyle, Content (+3 more)

### Community 41 - "View"
Cohesion: 0.11
Nodes (13): Configuration, Content, Configuration, AudioDropOverlay, .body, String, TimelineEmptyDropHint, .body (+5 more)

### Community 42 - "LyricPlaySyncClient"
Cohesion: 0.18
Nodes (9): NWBrowser, NWEndpoint, LyricPlaySyncClient, serverError, Never, Set, TimeInterval, Void (+1 more)

### Community 43 - "AVFoundation"
Cohesion: 0.25
Nodes (3): AVFoundation, CoreAudio, os

### Community 44 - ".peaks"
Cohesion: 0.09
Nodes (30): AVAudioPCMBuffer, CheckedContinuation, clips, Double, Float, Int, MainActor, Never (+22 more)

### Community 45 - "AudioDeviceService"
Cohesion: 0.26
Nodes (5): AudioDeviceID, AudioDeviceService, Bool, Int, String

### Community 46 - "DropURLLoader"
Cohesion: 0.62
Nodes (4): DropURLLoader, NSItemProvider, String, URL

### Community 47 - "MIDIInputService"
Cohesion: 0.08
Nodes (24): CoreMIDI, MIDINotifyProc, MIDIPacket, MIDIPacketList, MIDIInputEvent, MIDIInputService, MIDISourceInfo, .id (+16 more)

### Community 49 - "AudioImportService"
Cohesion: 0.08
Nodes (25): AudioFileStorageService, String, URL, UUID, AudioImportError, emptySelection, .errorDescription, storageUnavailable (+17 more)

### Community 50 - "TrackControlButton"
Cohesion: 0.22
Nodes (8): PanKnobView, .body, Bool, Double, String, Void, TrackControlButton, .body

### Community 51 - "TrackGroup"
Cohesion: 0.14
Nodes (16): CodingKey, CodingKeys, horizontalOffset, id, importedAt, name, pitchSemitones, volume (+8 more)

### Community 52 - ".applyLoadedProject"
Cohesion: 0.12
Nodes (5): Content, View, .body, .transportControls, Content

### Community 53 - "SectionLoopContext"
Cohesion: 0.24
Nodes (10): SectionLoopContext, .duration, TimeInterval, UUID, SectionLoopDiagnostics, AVAudioFrameCount, Double, Int64 (+2 more)

### Community 54 - "DAWVerticalFaderView"
Cohesion: 0.09
Nodes (25): ClosedRange, Double, Float, String, TrackVolumeSettings, .trackRange, DAWVerticalFaderView, .body (+17 more)

### Community 55 - "TimeInterval"
Cohesion: 0.13
Nodes (9): SectionEdgeGuides, Bool, TimeInterval, Timer, TimelineScrollAlignment, center, leading, start (+1 more)

### Community 56 - "Foundation"
Cohesion: 0.17
Nodes (4): Foundation, Observation, SnapGrid, SwiftUI

### Community 57 - "FileCommands"
Cohesion: 0.20
Nodes (9): App, Commands, Scene, FileCommands, TransportCommands, View, WorkspaceKeyboardShortcuts, SimplePlayApp (+1 more)

### Community 58 - ".presentImportPanel"
Cohesion: 0.18
Nodes (5): ImportPanelKind, audioFiles, folder, Int, .trackHeaderColumnTracksOnly

### Community 59 - ".scheduleLoopBody"
Cohesion: 0.20
Nodes (9): AVAudioFramePosition, AVAudioTime, AVAudioFrameCount, Bool, Double, Int, Int64, String (+1 more)

### Community 60 - "AppKit"
Cohesion: 0.33
Nodes (3): AppKit, ResizablePropertiesSidebar, .body

### Community 61 - "MIDINoteAssignment"
Cohesion: 0.47
Nodes (5): MIDINoteAssignment, .displayName, Bool, String, UInt8

### Community 62 - "AudioTrack"
Cohesion: 0.24
Nodes (11): AudioTrack, .color, .displayName, Bool, Double, StandardTrackRole, String, UUID (+3 more)

### Community 63 - ".loadBucket"
Cohesion: 0.53
Nodes (4): CGFloat, Int, WaveformLOD, .requiredLOD

### Community 64 - "PitchShiftSettings"
Cohesion: 0.23
Nodes (6): PitchShiftSettings, AVAudioUnitTimePitch, Bool, Double, Float, PitchShiftSettingsTests

### Community 65 - ".workspaceRoot"
Cohesion: 0.17
Nodes (9): DAWProject, Binding, Bool, String, WorkspaceSettingsView, .body, .deleteSectionDialogTitle, .sectionDeletionDialogBinding (+1 more)

### Community 66 - "TopToolbarView"
Cohesion: 0.06
Nodes (41): Bool, String, Void, ToolbarMenuButtonStyleModifier, TopToolbarView, .actionButtons, .importButton, .importMenuItems (+33 more)

### Community 67 - "WorkspaceViewModel"
Cohesion: 0.07
Nodes (20): ClosedRange, Date, Set, WorkspaceViewModel, .activePitchTrack, .activePlaybackSection, .canSaveDirectlyToCurrentURL, .isArrangementSectionControllingPlayback (+12 more)

### Community 68 - "ScheduledClip"
Cohesion: 0.21
Nodes (10): AVAudioFile, AudioEngineError, clipLoadFailed, deviceSelectionFailed, engineStartFailed, .errorDescription, noPlayableClips, playbackUnavailable (+2 more)

### Community 71 - "DAWTheme"
Cohesion: 0.12
Nodes (18): Glass, .assignModeToggle, .markerHeaderRow, DAWGlassChrome, .controlGlass, .panelGlass, CGFloat, Double (+10 more)

### Community 72 - ".hex"
Cohesion: 0.24
Nodes (7): .defaultColor, StandardTrackRole, .fallbackColor, Int, StandardTrackRole, String, TrackColorPalette

### Community 76 - "Sendable"
Cohesion: 0.23
Nodes (14): Codable, Sendable, LinkSectionCommand, LyricPlaySync, LyricPlaySyncCodec, LyricPlaySyncMessage, LyricSlideCatalog, LyricSlideCatalogItem (+6 more)

### Community 77 - "TransportBarView"
Cohesion: 0.05
Nodes (44): Path, Bool, CGFloat, CGSize, ClosedRange, Gesture, TimeInterval, TimelineOverviewBar (+36 more)

### Community 80 - "DAWProject"
Cohesion: 0.38
Nodes (4): groups, DAWProject, Int, UUID

### Community 81 - "AudioClip"
Cohesion: 0.36
Nodes (7): AudioClip, .endTime, Int, String, TimeInterval, URL, UUID

### Community 82 - "SectionPlaybackMode"
Cohesion: 0.15
Nodes (11): CaseIterable, SectionPlaybackMode, continueTimeline, continueToNext, .displayName, .id, oneShot, repeatSection (+3 more)

## Knowledge Gaps
- **305 isolated node(s):** `id`, `name`, `startTime`, `endTime`, `colorHex` (+300 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **5 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `WorkspaceViewModel` connect `WorkspaceViewModel` to `SectionMarkerChipView`, `CGFloat`, `TrackLaneView`, `ArrangementSection`, `MixerPanelView`, `TimelineWorkspacePanel`, `SimplePlayProjectFileDocument`, `ProjectPersistenceService`, `AudioEngineService`, `.applyImportedStems`, `MIDIMappingBarView`, `PropertiesSidebarView`, `WorkspaceView`, `CodingKeys`, `TrackOrganizationService`, `AudioDropTargetModifier`, `UUID`, `AudioSampleRate`, `MIDILearnTarget`, `LyricPlaySyncClient`, `AudioDeviceService`, `MIDIInputService`, `SectionLyricLinkSheet`, `AudioImportService`, `.applyLoadedProject`, `TimeInterval`, `Foundation`, `FileCommands`, `.presentImportPanel`, `AppKit`, `AudioTrack`, `.workspaceRoot`, `TopToolbarView`, `Sendable`, `TransportBarView`, `SectionPlaybackMode`?**
  _High betweenness centrality (0.420) - this node is a cross-community bridge._
- **Why does `ArrangementSection` connect `ArrangementSection` to `DAWProject`, `SectionMarkerChipView`, `WorkspaceViewModel`, `AudioSampleRate`, `MIDILearnTarget`, `LyricPlaySyncClient`, `Sendable`, `MIDIInputService`, `SectionLyricLinkSheet`, `SectionPlaybackMode`, `TimeInterval`, `MIDIMappingBarView`, `Foundation`, `PropertiesSidebarView`, `CodingKeys`?**
  _High betweenness centrality (0.093) - this node is a cross-community bridge._
- **Why does `Foundation` connect `Foundation` to `DAWProject`, `SectionMarkerChipView`, `AudioSampleRate`, `ScheduledClip`, `MIDILearnTarget`, `LyricPlaySyncTransportError`, `UniformTypeIdentifiers`, `AVFoundation`, `Sendable`, `MIDIInputService`, `AudioClip`, `SectionPlaybackMode`, `TrackGroup`, `AudioImportService`, `ProjectPersistenceService`, `AppKit`, `CodingKeys`, `Testing`?**
  _High betweenness centrality (0.082) - this node is a cross-community bridge._
- **Are the 13 inferred relationships involving `WorkspaceViewModel` (e.g. with `ArrangementPlaybackEngine` and `AudioEngineService`) actually correct?**
  _`WorkspaceViewModel` has 13 INFERRED edges - model-reasoned connections that need verification._
- **Are the 2 inferred relationships involving `AudioEngineService` (e.g. with `WorkspaceViewModel` and `.configureAudioEngine()`) actually correct?**
  _`AudioEngineService` has 2 INFERRED edges - model-reasoned connections that need verification._
- **Are the 4 inferred relationships involving `ArrangementSection` (e.g. with `.body` and `.body`) actually correct?**
  _`ArrangementSection` has 4 INFERRED edges - model-reasoned connections that need verification._
- **What connects `id`, `name`, `startTime` to the rest of the system?**
  _305 weakly-connected nodes found - possible documentation gaps or missing edges._