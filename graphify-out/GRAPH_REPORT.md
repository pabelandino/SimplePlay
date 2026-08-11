# Graph Report - SimplePlay  (2026-08-10)

## Corpus Check
- 94 files · ~48,336 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 1609 nodes · 3810 edges · 65 communities (62 shown, 3 thin omitted)
- Extraction: 90% EXTRACTED · 10% INFERRED · 0% AMBIGUOUS · INFERRED: 372 edges (avg confidence: 0.8)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `290e7be1`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- SimplePlayUITests
- SectionMarkerChipView
- Equatable
- What You Must Do When Invoked
- TrackLaneView
- graphify reference: extra exports and benchmark
- SectionLoopContext
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
- .play
- AudioImportService
- AudioEngineService
- StandardTrackRole
- .applyImportedStems
- TrackControlButton
- MIDIMappingBarView
- SidebarPanel
- View
- CGFloat
- .frames
- SectionPlaybackMode
- CodingKeys
- .hex
- Sendable
- DAWProject
- SupportedAudioFormats
- .stop
- TransportBarView
- AudioSampleRate
- .format
- UUID
- WorkspaceView
- TopToolbarView.swift
- AudioTrack
- .snap
- .majorTickInterval
- .peaks
- AudioOutputDevice
- .importInitial
- MIDIInputService
- .standardize
- ClipDragInteractionModifier
- .body
- SimplePlayProjectArchive
- .log
- DAWVerticalFaderView
- Foundation
- TrackGroup
- TimeInterval
- PropertiesSidebarView
- WorkspaceSettingsView
- TopToolbarView
- WorkspaceViewModel
- TimeInterval
- AudioClip
- TimelineOverviewBar
- MIDINoteAssignment

## God Nodes (most connected - your core abstractions)
1. `WorkspaceViewModel` - 238 edges
2. `AudioEngineService` - 81 edges
3. `ArrangementSection` - 61 edges
4. `DAWTheme` - 49 edges
5. `MIDIMappingBarView` - 44 edges
6. `AudioTrack` - 42 edges
7. `MixerPanelView` - 35 edges
8. `TimelineWorkspacePanel` - 35 edges
9. `ArrangementPlaybackEngine` - 34 edges
10. `StandardTrackRole` - 31 edges

## Surprising Connections (you probably didn't know these)
- `.duration` --references--> `AudioTrack`  [INFERRED]
  SimplePlay/Core/Models/DAWProject.swift → SimplePlay/Core/Models/AudioTrack.swift
- `TrackOrganizationServiceTests` --calls--> `TrackOrganizationService`  [EXTRACTED]
  SimplePlayTests/TrackOrganizationServiceTests.swift → SimplePlay/Core/Services/TrackOrganizationService.swift
- `.selectedDevice` --references--> `WorkspaceViewModel`  [INFERRED]
  SimplePlay/Features/Workspace/Views/PropertiesSidebarView.swift → SimplePlay/Features/Workspace/ViewModels/WorkspaceViewModel.swift
- `.body` --references--> `ArrangementSection`  [INFERRED]
  SimplePlay/Features/Workspace/Views/SectionMarkerLaneView.swift → SimplePlay/Core/Models/ArrangementSection.swift
- `.body` --references--> `ArrangementSection`  [INFERRED]
  SimplePlay/Features/Workspace/Views/SectionMarkerLaneView.swift → SimplePlay/Core/Models/ArrangementSection.swift

## Import Cycles
- None detected.

## Communities (65 total, 3 thin omitted)

### Community 0 - "SimplePlayUITests"
Cohesion: 0.15
Nodes (6): SimplePlayUITests, SimplePlayUITestsLaunchTests, .runsForEachTargetApplicationUIConfiguration, Bool, XCTest, XCTestCase

### Community 1 - "SectionMarkerChipView"
Cohesion: 0.11
Nodes (29): NSCursor, ResizeEdge, end, start, SectionCreationPreviewView, .body, SectionDragSession, SectionEdgeGuideOverlay (+21 more)

### Community 2 - "Equatable"
Cohesion: 0.06
Nodes (46): Codable, Equatable, PersistedClip, PersistedProject, PersistedTrack, SavedProjectDocument, Bool, DAWProject (+38 more)

### Community 3 - "What You Must Do When Invoked"
Cohesion: 0.08
Nodes (24): For /graphify add and --watch, For /graphify query, For the commit hook and native AGENTS.md integration, For --update and --cluster-only, /graphify, Honesty Rules, Interpreter guard for subcommands, Part A - Structural extraction for code files (+16 more)

### Community 4 - "TrackLaneView"
Cohesion: 0.21
Nodes (14): GraphicsContext, CGFloat, CGSize, Gesture, TimeInterval, UUID, Void, TimelineRulerTicksView (+6 more)

### Community 5 - "graphify reference: extra exports and benchmark"
Cohesion: 0.22
Nodes (8): graphify reference: extra exports and benchmark, Step 6b - Wiki (only if --wiki flag), Step 7 - Neo4j export (only if --neo4j or --neo4j-push flag), Step 7a - FalkorDB export (only if --falkordb or --falkordb-push flag), Step 7b - SVG export (only if --svg flag), Step 7c - GraphML export (only if --graphml flag), Step 7d - MCP server (only if --mcp flag), Step 8 - Token reduction benchmark (only if total_words > 5000)

### Community 6 - "SectionLoopContext"
Cohesion: 0.29
Nodes (9): SectionLoopContext, .duration, TimeInterval, UUID, Bool, DAWProject, Int, Int64 (+1 more)

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
Nodes (40): ArrangementSection, .color, .duration, CodingKeys, colorHex, endTime, id, midiChannel (+32 more)

### Community 15 - "MixerPanelView"
Cohesion: 0.06
Nodes (36): MixerPanelView, .body, .channelFaderHeight, .channelFaderWidth, .channelStripWidth, .groupDivider, .isCompact, .masterFaderHeight (+28 more)

### Community 16 - "TimelineWorkspacePanel"
Cohesion: 0.12
Nodes (25): PlayheadView, .body, .playheadDragGesture, CGFloat, Double, Gesture, String, TimeInterval (+17 more)

### Community 17 - ".play"
Cohesion: 0.19
Nodes (6): AVAudioFile, AVAudioNode, AVAudioPlayerNode, .playbackGraphIsHealthy, ScheduledClip, AVAudioUnitTimePitch

### Community 18 - "AudioImportService"
Cohesion: 0.09
Nodes (26): LocalizedError, AudioEngineError, clipLoadFailed, deviceSelectionFailed, engineStartFailed, .errorDescription, noPlayableClips, playbackUnavailable (+18 more)

### Community 19 - "AudioEngineService"
Cohesion: 0.11
Nodes (12): AVAudioMixerNode, AVAudioUnitEQ, AudioEngineService, .isAnyPlayerPlaying, .isPlaybackGraphReady, .isSectionLoopPlaybackActive, .masterVolume, .primaryClipSampleRate (+4 more)

### Community 20 - "StandardTrackRole"
Cohesion: 0.08
Nodes (24): StandardTrackRole, acousticGuitar, backingVocal, bass, brass, click, countIn, cue (+16 more)

### Community 21 - ".applyImportedStems"
Cohesion: 0.13
Nodes (6): Error, Result, DAWProject, String, URL, .body

### Community 22 - "TrackControlButton"
Cohesion: 0.22
Nodes (8): PanKnobView, .body, Bool, Double, String, Void, TrackControlButton, .body

### Community 23 - "MIDIMappingBarView"
Cohesion: 0.10
Nodes (22): Animation, AnyTransition, Color, MIDIMappingBarView, .assignModeToggleTitle, .collapsedBar, .collapsedBarContent, .devicePickerLabel (+14 more)

### Community 24 - "SidebarPanel"
Cohesion: 0.09
Nodes (40): Selection, .audioSettings, .playbackSettings, .sectionEditor, .selectedMarkerEditor, .selectionInfo, .sessionManagement, .trackPitch (+32 more)

### Community 25 - "View"
Cohesion: 0.14
Nodes (15): .assignModeToggle, Configuration, .mixerButton, AudioDropOverlay, .body, String, TimelineEmptyDropHint, .body (+7 more)

### Community 26 - "CGFloat"
Cohesion: 0.11
Nodes (11): SectionDragKind, move, resizeEnd, resizeStart, CGFloat, TimelineScrollRequest, .minimumTimelineZoom, .timelineContentWidth (+3 more)

### Community 27 - ".frames"
Cohesion: 0.29
Nodes (6): Bool, Double, Int64, TimeInterval, TimelineSampleGrid, TimelineSampleGridTests

### Community 28 - "SectionPlaybackMode"
Cohesion: 0.14
Nodes (13): CaseIterable, Identifiable, SectionPlaybackMode, continueTimeline, continueToNext, .displayName, .id, oneShot (+5 more)

### Community 29 - "CodingKeys"
Cohesion: 0.07
Nodes (31): CodingKeys, audioSettings, colorHex, id, isLocked, isMuted, isSnapEnabled, isSolo (+23 more)

### Community 30 - ".hex"
Cohesion: 0.23
Nodes (7): .defaultColor, StandardTrackRole, .fallbackColor, Int, StandardTrackRole, String, TrackColorPalette

### Community 31 - "Sendable"
Cohesion: 0.26
Nodes (11): Sendable, ImportedStem, ImportPlacement, appendNewGroup, insertIntoGroup, DAWProject, Int, String (+3 more)

### Community 32 - "DAWProject"
Cohesion: 0.31
Nodes (9): DAWProject, .duration, Bool, Double, Int32, String, TimeInterval, UInt8 (+1 more)

### Community 33 - "SupportedAudioFormats"
Cohesion: 0.05
Nodes (37): FileDocument, FileWrapper, ReadConfiguration, SimplePlayProjectFileDocument, .readableContentTypes, Data, DropURLLoader, NSItemProvider (+29 more)

### Community 34 - ".stop"
Cohesion: 0.22
Nodes (6): Content, View, TransportCommands, .body, View, WorkspaceKeyboardShortcuts

### Community 35 - "TransportBarView"
Cohesion: 0.09
Nodes (23): Binding, Bool, CGFloat, Double, String, Void, TransportBarStyle, phoneBottomDock (+15 more)

### Community 36 - "AudioSampleRate"
Cohesion: 0.22
Nodes (11): Double, AudioSampleRate, .displayName, .id, rate44100, rate48000, AudioSettings, Int (+3 more)

### Community 37 - ".format"
Cohesion: 0.29
Nodes (6): Bool, String, TimeInterval, .formattedCurrentTime, .formattedDuration, .body

### Community 38 - "UUID"
Cohesion: 0.11
Nodes (14): Double, Float, UInt8, UUID, .mixerScrollWithPinnedMasters, .trackHeaderColumnTracksOnly, Binding, Double (+6 more)

### Community 39 - "WorkspaceView"
Cohesion: 0.05
Nodes (33): App, AppKit, Commands, Notification, NSApplicationDelegate, NSEvent, NSObject, NSView (+25 more)

### Community 40 - "TopToolbarView.swift"
Cohesion: 0.13
Nodes (13): ButtonStyle, SectionMappingAssignButtonStyle, SectionMappingCardGlow, SectionMappingPlayButtonStyle, Configuration, Content, DAWIconToolbarButtonStyle, DAWLabeledToolbarButtonStyle (+5 more)

### Community 41 - "AudioTrack"
Cohesion: 0.24
Nodes (11): AudioTrack, .color, .displayName, Bool, Double, StandardTrackRole, String, UUID (+3 more)

### Community 42 - ".snap"
Cohesion: 0.17
Nodes (5): Bool, TimeInterval, ImportPanelKind, audioFiles, folder

### Community 43 - ".majorTickInterval"
Cohesion: 0.27
Nodes (5): CGFloat, String, TimeInterval, TimelineRulerScale, TimelineRulerScaleTests

### Community 44 - ".peaks"
Cohesion: 0.09
Nodes (31): AVAudioPCMBuffer, CheckedContinuation, Never, Path, clips, Double, Float, Int (+23 more)

### Community 45 - "AudioOutputDevice"
Cohesion: 0.24
Nodes (7): AudioDeviceID, Hashable, AudioOutputDevice, AudioDeviceService, Bool, Int, String

### Community 46 - ".importInitial"
Cohesion: 0.35
Nodes (3): String, TimeInterval, TrackOrganizationServiceTests

### Community 47 - "MIDIInputService"
Cohesion: 0.07
Nodes (26): MIDINotifyProc, MIDIPacket, MIDIPacketList, Kind, controlChange, noteOn, MIDIInputEvent, MIDIInputService (+18 more)

### Community 48 - ".standardize"
Cohesion: 0.23
Nodes (7): StandardizedName, Bool, StandardTrackRole, String, URL, TrackNameStandardizer, TrackNameStandardizerTests

### Community 49 - "ClipDragInteractionModifier"
Cohesion: 0.25
Nodes (7): G, ClipDragInteractionModifier, ClipSelectionModifiers, .isExtending, Bool, Content, ViewModifier

### Community 50 - ".body"
Cohesion: 0.25
Nodes (5): Bool, Content, TimelineAudioDropModifier, .masterSectionLaneScroll, .pinnedTimelineHeaders

### Community 52 - "SimplePlayProjectArchive"
Cohesion: 0.16
Nodes (15): Asset, SimplePlayProjectArchive, SimplePlayProjectArchiveError, corruptAsset, corruptManifest, .errorDescription, invalidArchive, Bool (+7 more)

### Community 53 - ".log"
Cohesion: 0.38
Nodes (6): SectionLoopDiagnostics, AVAudioFrameCount, Double, Int64, String, TimeInterval

### Community 54 - "DAWVerticalFaderView"
Cohesion: 0.09
Nodes (25): ClosedRange, Double, Float, String, TrackVolumeSettings, .trackRange, DAWVerticalFaderView, .body (+17 more)

### Community 56 - "Foundation"
Cohesion: 0.05
Nodes (23): AVFoundation, CoreAudio, CoreGraphics, CoreMIDI, Foundation, Observation, os, SimplePlay (+15 more)

### Community 58 - "TrackGroup"
Cohesion: 0.14
Nodes (16): CodingKey, Encoder, CodingKeys, horizontalOffset, id, importedAt, name, pitchSemitones (+8 more)

### Community 59 - "TimeInterval"
Cohesion: 0.20
Nodes (6): AVAudioFramePosition, AVAudioTime, AVAudioFrameCount, Double, TimeInterval, UInt64

### Community 61 - "PropertiesSidebarView"
Cohesion: 0.12
Nodes (19): .masterVolumeBinding, PropertiesSidebarView, .body, .masterVolumeBinding, .pitchIsOriginal, .pitchLabel, .sectionCreationHint, .selectedDevice (+11 more)

### Community 65 - "WorkspaceSettingsView"
Cohesion: 0.22
Nodes (7): Binding, Bool, String, WorkspaceSettingsView, .body, .deleteSectionDialogTitle, .sectionDeletionDialogBinding

### Community 66 - "TopToolbarView"
Cohesion: 0.06
Nodes (40): Bool, String, Void, ToolbarMenuButtonStyleModifier, TopToolbarView, .actionButtons, .importButton, .importMenuItems (+32 more)

### Community 67 - "WorkspaceViewModel"
Cohesion: 0.08
Nodes (19): Date, Int, Set, WorkspaceViewModel, .activePitchTrack, .activePlaybackSection, .canSaveDirectlyToCurrentURL, .isArrangementSectionControllingPlayback (+11 more)

### Community 68 - "TimeInterval"
Cohesion: 0.12
Nodes (10): SectionEdgeGuides, Bool, ClosedRange, TimeInterval, TimelineScrollAlignment, center, leading, start (+2 more)

### Community 70 - "AudioClip"
Cohesion: 0.19
Nodes (11): AudioClip, .endTime, Int, String, TimeInterval, URL, UUID, groups (+3 more)

### Community 71 - "TimelineOverviewBar"
Cohesion: 0.07
Nodes (29): Glass, LinearGradient, Bool, CGFloat, CGSize, ClosedRange, Gesture, TimeInterval (+21 more)

### Community 75 - "MIDINoteAssignment"
Cohesion: 0.22
Nodes (8): MIDILearnTarget, section, MIDINoteAssignment, .displayName, Bool, String, UInt8, UUID

## Knowledge Gaps
- **279 isolated node(s):** `id`, `name`, `startTime`, `endTime`, `colorHex` (+274 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **3 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `WorkspaceViewModel` connect `WorkspaceViewModel` to `SectionMarkerChipView`, `Equatable`, `TrackLaneView`, `ArrangementSection`, `MixerPanelView`, `TimelineWorkspacePanel`, `AudioImportService`, `AudioEngineService`, `.applyImportedStems`, `MIDIMappingBarView`, `View`, `CGFloat`, `SectionPlaybackMode`, `Sendable`, `SupportedAudioFormats`, `.stop`, `TransportBarView`, `.format`, `UUID`, `WorkspaceView`, `AudioTrack`, `.snap`, `AudioOutputDevice`, `MIDIInputService`, `.body`, `Foundation`, `PropertiesSidebarView`, `WorkspaceSettingsView`, `TopToolbarView`, `TimeInterval`, `TimelineOverviewBar`, `MIDINoteAssignment`?**
  _High betweenness centrality (0.451) - this node is a cross-community bridge._
- **Why does `AudioEngineService` connect `AudioEngineService` to `WorkspaceViewModel`, `SectionLoopContext`, `UUID`, `.play`, `.applyImportedStems`, `Foundation`, `TimeInterval`?**
  _High betweenness centrality (0.103) - this node is a cross-community bridge._
- **Why does `ArrangementSection` connect `ArrangementSection` to `DAWProject`, `SectionMarkerChipView`, `Equatable`, `WorkspaceViewModel`, `TimeInterval`, `.format`, `MIDIInputService`, `PropertiesSidebarView`, `MIDIMappingBarView`, `Foundation`, `View`, `CGFloat`, `SectionPlaybackMode`, `CodingKeys`, `Sendable`?**
  _High betweenness centrality (0.078) - this node is a cross-community bridge._
- **Are the 12 inferred relationships involving `WorkspaceViewModel` (e.g. with `ArrangementPlaybackEngine` and `AudioEngineService`) actually correct?**
  _`WorkspaceViewModel` has 12 INFERRED edges - model-reasoned connections that need verification._
- **Are the 2 inferred relationships involving `AudioEngineService` (e.g. with `WorkspaceViewModel` and `.configureAudioEngine()`) actually correct?**
  _`AudioEngineService` has 2 INFERRED edges - model-reasoned connections that need verification._
- **Are the 4 inferred relationships involving `ArrangementSection` (e.g. with `.body` and `.body`) actually correct?**
  _`ArrangementSection` has 4 INFERRED edges - model-reasoned connections that need verification._
- **What connects `id`, `name`, `startTime` to the rest of the system?**
  _279 weakly-connected nodes found - possible documentation gaps or missing edges._