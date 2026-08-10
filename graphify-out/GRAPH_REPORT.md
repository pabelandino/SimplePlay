# Graph Report - SimplePlay  (2026-08-10)

## Corpus Check
- 92 files · ~44,582 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 1495 nodes · 3437 edges · 73 communities (67 shown, 6 thin omitted)
- Extraction: 90% EXTRACTED · 10% INFERRED · 0% AMBIGUOUS · INFERRED: 349 edges (avg confidence: 0.8)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `862de09a`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- SimplePlayUITests
- SectionMarkerChipView
- PropertiesSidebarView
- What You Must Do When Invoked
- TrackLaneView
- graphify reference: extra exports and benchmark
- Foundation
- graphify reference: query, path, explain
- graphify reference: add a URL and watch a folder
- graphify reference: commit hook and native AGENTS.md integration
- graphify reference: incremental update and cluster-only
- graphify reference: GitHub clone and cross-repo merge
- graphify reference: transcribe video and audio
- extraction-spec.md
- ArrangementSection
- SectionLoopContext
- TimelineWorkspacePanel
- TransportBarView
- AudioImportService
- AudioEngineService
- StandardTrackRole
- .applyImportedStems
- SimplePlayProjectArchive
- MIDIMappingBarView
- Equatable
- TopToolbarView
- TimeInterval
- Color
- TrackGroup
- CodingKeys
- .applyLoadedProject
- Sendable
- DAWProject
- .body
- MixerPanelView
- SupportedAudioFormats
- .sessionManagement
- .standardize
- AudioDeviceService
- MacWindowTitleBarHidden.swift
- AudioTrack
- .frames
- FaderMeterStripView
- .body
- .peaks
- AudioSampleRate
- AudioClip
- MIDIInputService
- TrackWaveformProgressBar
- FileCommands
- SidebarPanel
- .attachClip
- WorkspaceViewModel
- .isNodeConnected
- DAWVerticalFaderView
- .format
- ToolbarMenuButtonStyleModifier
- MIDINoteAssignment
- .log
- UIKitToolbarMenuButtonRepresentable
- .stem
- View
- TrackPitchControlView
- .presentImportPanel
- DAWProject
- AudioEngineError
- .addSection
- .groupMasterStrip
- TrackControlButton
- UUID
- .setMasterVolume
- TopToolbarView.swift
- CGFloat

## God Nodes (most connected - your core abstractions)
1. `WorkspaceViewModel` - 214 edges
2. `AudioEngineService` - 55 edges
3. `ArrangementSection` - 48 edges
4. `AudioTrack` - 42 edges
5. `DAWTheme` - 37 edges
6. `ArrangementPlaybackEngine` - 36 edges
7. `MixerPanelView` - 35 edges
8. `TimelineWorkspacePanel` - 35 edges
9. `StandardTrackRole` - 31 edges
10. `PropertiesSidebarView` - 31 edges

## Surprising Connections (you probably didn't know these)
- `.duration` --references--> `AudioTrack`  [INFERRED]
  SimplePlay/Core/Models/DAWProject.swift → SimplePlay/Core/Models/AudioTrack.swift
- `TrackOrganizationServiceTests` --calls--> `TrackOrganizationService`  [EXTRACTED]
  SimplePlayTests/TrackOrganizationServiceTests.swift → SimplePlay/Core/Services/TrackOrganizationService.swift
- `.selectedDevice` --references--> `WorkspaceViewModel`  [INFERRED]
  SimplePlay/Features/Workspace/Views/PropertiesSidebarView.swift → SimplePlay/Features/Workspace/ViewModels/WorkspaceViewModel.swift
- `.body` --calls--> `ContentView`  [INFERRED]
  SimplePlay/SimplePlayApp.swift → SimplePlay/ContentView.swift
- `.body` --references--> `ArrangementSection`  [INFERRED]
  SimplePlay/Features/Workspace/Views/SectionMarkerLaneView.swift → SimplePlay/Core/Models/ArrangementSection.swift

## Import Cycles
- None detected.

## Communities (73 total, 6 thin omitted)

### Community 0 - "SimplePlayUITests"
Cohesion: 0.15
Nodes (6): SimplePlayUITests, SimplePlayUITestsLaunchTests, .runsForEachTargetApplicationUIConfiguration, Bool, XCTest, XCTestCase

### Community 1 - "SectionMarkerChipView"
Cohesion: 0.07
Nodes (35): NSCursor, SectionDragKind, move, resizeEnd, resizeStart, ResizeEdge, end, start (+27 more)

### Community 2 - "PropertiesSidebarView"
Cohesion: 0.13
Nodes (17): PropertiesSidebarView, .body, .pitchIsOriginal, .pitchLabel, .sectionCreationHint, .selectedDevice, .selectedDeviceID, .selectedSection (+9 more)

### Community 3 - "What You Must Do When Invoked"
Cohesion: 0.08
Nodes (24): For /graphify add and --watch, For /graphify query, For the commit hook and native AGENTS.md integration, For --update and --cluster-only, /graphify, Honesty Rules, Interpreter guard for subcommands, Part A - Structural extraction for code files (+16 more)

### Community 4 - "TrackLaneView"
Cohesion: 0.09
Nodes (26): G, GraphicsContext, CGFloat, String, TimeInterval, TimelineRulerScale, ClipDragInteractionModifier, ClipSelectionModifiers (+18 more)

### Community 5 - "graphify reference: extra exports and benchmark"
Cohesion: 0.22
Nodes (8): graphify reference: extra exports and benchmark, Step 6b - Wiki (only if --wiki flag), Step 7 - Neo4j export (only if --neo4j or --neo4j-push flag), Step 7a - FalkorDB export (only if --falkordb or --falkordb-push flag), Step 7b - SVG export (only if --svg flag), Step 7c - GraphML export (only if --graphml flag), Step 7d - MCP server (only if --mcp flag), Step 8 - Token reduction benchmark (only if total_words > 5000)

### Community 6 - "Foundation"
Cohesion: 0.05
Nodes (23): AVFoundation, CoreAudio, CoreGraphics, CoreMIDI, Foundation, Observation, os, SimplePlay (+15 more)

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
Cohesion: 0.08
Nodes (35): ArrangementSection, .color, .duration, Bool, Decoder, String, TimeInterval, UInt8 (+27 more)

### Community 15 - "SectionLoopContext"
Cohesion: 0.23
Nodes (10): AVAudioFrameCount, AVAudioTime, SectionLoopContext, .duration, TimeInterval, UUID, Bool, Int (+2 more)

### Community 16 - "TimelineWorkspacePanel"
Cohesion: 0.11
Nodes (28): PlayheadView, .body, .playheadDragGesture, Bool, CGFloat, Content, Double, Gesture (+20 more)

### Community 17 - "TransportBarView"
Cohesion: 0.06
Nodes (36): Bool, CGFloat, CGSize, Gesture, TimeInterval, TimelineOverviewBar, .barHeight, .body (+28 more)

### Community 18 - "AudioImportService"
Cohesion: 0.13
Nodes (17): LocalizedError, AudioFileStorageService, String, URL, UUID, AudioImportError, emptySelection, .errorDescription (+9 more)

### Community 19 - "AudioEngineService"
Cohesion: 0.14
Nodes (11): AVAudioMixerNode, AVAudioPCMBuffer, AVAudioUnitEQ, AudioEngineService, .isPlaybackGraphReady, .masterVolume, .primaryClipSampleRate, Double (+3 more)

### Community 20 - "StandardTrackRole"
Cohesion: 0.06
Nodes (36): CaseIterable, SectionPlaybackMode, continueTimeline, continueToNext, .displayName, .id, oneShot, repeatSection (+28 more)

### Community 21 - ".applyImportedStems"
Cohesion: 0.16
Nodes (8): Error, Result, Bool, TimeInterval, Bool, URL, String, URL

### Community 22 - "SimplePlayProjectArchive"
Cohesion: 0.16
Nodes (15): Asset, SimplePlayProjectArchive, SimplePlayProjectArchiveError, corruptAsset, corruptManifest, .errorDescription, invalidArchive, Bool (+7 more)

### Community 23 - "MIDIMappingBarView"
Cohesion: 0.16
Nodes (15): Animation, AnyTransition, MIDIMappingBarView, .body, .collapsedBar, .collapsedBarContent, .devicePickerLabel, .devicePickerTitle (+7 more)

### Community 24 - "Equatable"
Cohesion: 0.07
Nodes (40): Codable, Equatable, PersistedClip, PersistedProject, PersistedTrack, SavedProjectDocument, Bool, DAWProject (+32 more)

### Community 25 - "TopToolbarView"
Cohesion: 0.27
Nodes (10): String, Void, TopToolbarView, .isCompact, .openButton, .projectTitle, .saveButton, .settingsButton (+2 more)

### Community 26 - "TimeInterval"
Cohesion: 0.23
Nodes (4): SectionEdgeGuides, Bool, TimeInterval, UInt8

### Community 27 - "Color"
Cohesion: 0.23
Nodes (8): .defaultColor, Color, StandardTrackRole, .fallbackColor, Int, StandardTrackRole, String, TrackColorPalette

### Community 28 - "TrackGroup"
Cohesion: 0.27
Nodes (8): Date, Encoder, Decoder, Double, String, TimeInterval, UUID, TrackGroup

### Community 29 - "CodingKeys"
Cohesion: 0.05
Nodes (44): CodingKey, CodingKeys, colorHex, endTime, id, midiChannel, midiNote, midiUsesControlChange (+36 more)

### Community 30 - ".applyLoadedProject"
Cohesion: 0.15
Nodes (5): Content, View, .body, DAWProject, .transportControls

### Community 31 - "Sendable"
Cohesion: 0.26
Nodes (11): Sendable, ImportedStem, ImportPlacement, appendNewGroup, insertIntoGroup, DAWProject, Int, String (+3 more)

### Community 32 - "DAWProject"
Cohesion: 0.31
Nodes (9): DAWProject, .duration, Bool, Double, Int32, String, TimeInterval, UInt8 (+1 more)

### Community 33 - ".body"
Cohesion: 0.11
Nodes (17): ContentView, .body, Binding, Bool, String, WorkspaceSettingsView, .body, .deleteSectionDialogTitle (+9 more)

### Community 34 - "MixerPanelView"
Cohesion: 0.12
Nodes (21): MixerPanelView, .body, .channelFaderHeight, .channelFaderWidth, .channelStripWidth, .isCompact, .masterFaderHeight, .mixerHandle (+13 more)

### Community 35 - "SupportedAudioFormats"
Cohesion: 0.05
Nodes (37): FileDocument, FileWrapper, ReadConfiguration, SimplePlayProjectFileDocument, .readableContentTypes, Data, DropURLLoader, NSItemProvider (+29 more)

### Community 36 - ".sessionManagement"
Cohesion: 0.60
Nodes (3): .sessionManagement, .projectSessionMenuItems, .body

### Community 37 - ".standardize"
Cohesion: 0.23
Nodes (7): StandardizedName, Bool, StandardTrackRole, String, URL, TrackNameStandardizer, TrackNameStandardizerTests

### Community 38 - "AudioDeviceService"
Cohesion: 0.26
Nodes (6): AudioDeviceID, AudioDeviceService, Bool, Int, String, .audioSettings

### Community 39 - "MacWindowTitleBarHidden.swift"
Cohesion: 0.09
Nodes (18): AppKit, Notification, NSApplicationDelegate, NSEvent, NSObject, NSView, NSViewRepresentable, NSWindow (+10 more)

### Community 40 - "AudioTrack"
Cohesion: 0.24
Nodes (11): AudioTrack, .color, .displayName, Bool, Double, StandardTrackRole, String, UUID (+3 more)

### Community 41 - ".frames"
Cohesion: 0.32
Nodes (6): Bool, Double, Int64, TimeInterval, TimelineSampleGrid, TimelineSampleGridTests

### Community 42 - "FaderMeterStripView"
Cohesion: 0.15
Nodes (12): .projectMasterStrip, .mainVolumeControl, FaderMeterStripView, .reservesThumbClearance, .showsUnityMark, .usesUnityCenterDecibelScale, Bool, CGFloat (+4 more)

### Community 43 - ".body"
Cohesion: 0.24
Nodes (9): Binding, Double, TrackHeaderRowView, .body, .displayColor, .liveTrack, .trackPan, .trackVolumeBinding (+1 more)

### Community 44 - ".peaks"
Cohesion: 0.09
Nodes (30): CheckedContinuation, Never, Path, clips, Double, Float, Int, MainActor (+22 more)

### Community 45 - "AudioSampleRate"
Cohesion: 0.24
Nodes (12): Double, Hashable, AudioOutputDevice, AudioSampleRate, .displayName, .id, rate44100, rate48000 (+4 more)

### Community 46 - "AudioClip"
Cohesion: 0.36
Nodes (7): AudioClip, .endTime, Int, String, TimeInterval, URL, UUID

### Community 47 - "MIDIInputService"
Cohesion: 0.07
Nodes (26): Identifiable, MIDINotifyProc, MIDIPacket, MIDIPacketList, Kind, controlChange, noteOn, MIDIInputEvent (+18 more)

### Community 48 - "TrackWaveformProgressBar"
Cohesion: 0.40
Nodes (4): Bool, Double, TrackWaveformProgressBar, .body

### Community 49 - "FileCommands"
Cohesion: 0.16
Nodes (10): App, Commands, Scene, FileCommands, .body, TransportCommands, View, WorkspaceKeyboardShortcuts (+2 more)

### Community 50 - "SidebarPanel"
Cohesion: 0.29
Nodes (10): .playbackSettings, .sectionEditor, .trackPitch, .volumeControls, SidebarLabeledRow, .body, SidebarPanel, .body (+2 more)

### Community 51 - ".attachClip"
Cohesion: 0.27
Nodes (5): AVAudioFile, ScheduledClip, AVAudioUnitTimePitch, DAWProject, UInt32

### Community 52 - "WorkspaceViewModel"
Cohesion: 0.07
Nodes (21): Int, Set, WorkspaceViewModel, .activePitchTrack, .activeSectionEdgeGuides, .canSaveDirectlyToCurrentURL, .isArrangementSectionControllingPlayback, .isMIDILearnActive (+13 more)

### Community 53 - ".isNodeConnected"
Cohesion: 0.29
Nodes (3): AVAudioNode, AVAudioPlayerNode, .playbackGraphIsHealthy

### Community 54 - "DAWVerticalFaderView"
Cohesion: 0.09
Nodes (25): ClosedRange, Double, Float, String, TrackVolumeSettings, .trackRange, DAWVerticalFaderView, .body (+17 more)

### Community 55 - ".format"
Cohesion: 0.20
Nodes (8): Bool, String, TimeInterval, TimeFormatting, .formattedCurrentTime, .formattedDuration, .selectionInfo, .body

### Community 56 - "ToolbarMenuButtonStyleModifier"
Cohesion: 0.27
Nodes (7): Bool, ToolbarMenuButtonStyleModifier, .importButton, .projectSessionButton, ImportToolbarMenuButton, .body, ProjectSessionToolbarMenuButton

### Community 57 - "MIDINoteAssignment"
Cohesion: 0.15
Nodes (15): MIDILearnTarget, loopToggle, section, MIDINoteAssignment, .displayName, Bool, String, UInt8 (+7 more)

### Community 58 - ".log"
Cohesion: 0.44
Nodes (5): SectionLoopDiagnostics, Double, Int64, String, TimeInterval

### Community 59 - "UIKitToolbarMenuButtonRepresentable"
Cohesion: 0.33
Nodes (7): Coordinator, Context, String, Void, UIKitToolbarMenuButtonRepresentable, UIButton, UIViewRepresentable

### Community 60 - ".stem"
Cohesion: 0.36
Nodes (3): String, TimeInterval, TrackOrganizationServiceTests

### Community 61 - "View"
Cohesion: 0.15
Nodes (15): Configuration, .groupDivider, .pinnedMastersColumn, AudioDropOverlay, .body, String, TimelineEmptyDropHint, .body (+7 more)

### Community 62 - "TrackPitchControlView"
Cohesion: 0.14
Nodes (14): .actionButtons, Binding, Bool, Double, String, UUID, TrackPitchControlView, .menuTitle (+6 more)

### Community 63 - ".presentImportPanel"
Cohesion: 0.40
Nodes (4): ImportPanelKind, audioFiles, folder, .importMenuItems

### Community 64 - "DAWProject"
Cohesion: 0.43
Nodes (4): groups, DAWProject, Int, UUID

### Community 65 - "AudioEngineError"
Cohesion: 0.25
Nodes (8): AudioEngineError, clipLoadFailed, deviceSelectionFailed, engineStartFailed, .errorDescription, noPlayableClips, playbackUnavailable, String

### Community 67 - ".groupMasterStrip"
Cohesion: 0.29
Nodes (3): Float, .mastersStripRow, String

### Community 68 - "TrackControlButton"
Cohesion: 0.22
Nodes (8): PanKnobView, .body, Bool, Double, String, Void, TrackControlButton, .body

### Community 76 - "TopToolbarView.swift"
Cohesion: 0.36
Nodes (6): ButtonStyle, DAWIconToolbarButtonStyle, DAWLabeledToolbarButtonStyle, DAWPrimaryButtonStyle, Content, .body

### Community 77 - "CGFloat"
Cohesion: 0.17
Nodes (10): CGFloat, TimelineScrollAlignment, center, leading, start, TimelineScrollRequest, .minimumTimelineZoom, .timelineContentWidth (+2 more)

## Knowledge Gaps
- **267 isolated node(s):** `id`, `name`, `startTime`, `endTime`, `colorHex` (+262 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **6 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `WorkspaceViewModel` connect `WorkspaceViewModel` to `SectionMarkerChipView`, `PropertiesSidebarView`, `TrackLaneView`, `Foundation`, `ArrangementSection`, `TimelineWorkspacePanel`, `TransportBarView`, `AudioImportService`, `AudioEngineService`, `StandardTrackRole`, `.applyImportedStems`, `MIDIMappingBarView`, `Equatable`, `TopToolbarView`, `TimeInterval`, `.applyLoadedProject`, `Sendable`, `.body`, `MixerPanelView`, `SupportedAudioFormats`, `.sessionManagement`, `AudioDeviceService`, `MacWindowTitleBarHidden.swift`, `AudioTrack`, `.body`, `AudioSampleRate`, `MIDIInputService`, `FileCommands`, `.format`, `ToolbarMenuButtonStyleModifier`, `MIDINoteAssignment`, `TrackPitchControlView`, `.presentImportPanel`, `.addSection`, `.groupMasterStrip`, `UUID`, `.setMasterVolume`, `CGFloat`?**
  _High betweenness centrality (0.423) - this node is a cross-community bridge._
- **Why does `AudioTrack` connect `AudioTrack` to `DAWProject`, `DAWProject`, `MixerPanelView`, `TrackLaneView`, `UUID`, `Foundation`, `.body`, `AudioClip`, `MIDIInputService`, `WorkspaceViewModel`, `Equatable`, `Color`, `Sendable`?**
  _High betweenness centrality (0.077) - this node is a cross-community bridge._
- **Why does `Foundation` connect `Foundation` to `DAWProject`, `SupportedAudioFormats`, `.standardize`, `MacWindowTitleBarHidden.swift`, `AudioSampleRate`, `AudioClip`, `AudioImportService`, `StandardTrackRole`, `SimplePlayProjectArchive`, `.format`, `Equatable`, `MIDINoteAssignment`, `DAWVerticalFaderView`, `TrackGroup`?**
  _High betweenness centrality (0.071) - this node is a cross-community bridge._
- **Are the 12 inferred relationships involving `WorkspaceViewModel` (e.g. with `ArrangementPlaybackEngine` and `AudioEngineService`) actually correct?**
  _`WorkspaceViewModel` has 12 INFERRED edges - model-reasoned connections that need verification._
- **Are the 2 inferred relationships involving `AudioEngineService` (e.g. with `WorkspaceViewModel` and `.configureAudioEngine()`) actually correct?**
  _`AudioEngineService` has 2 INFERRED edges - model-reasoned connections that need verification._
- **Are the 4 inferred relationships involving `ArrangementSection` (e.g. with `.body` and `.body`) actually correct?**
  _`ArrangementSection` has 4 INFERRED edges - model-reasoned connections that need verification._
- **Are the 3 inferred relationships involving `AudioTrack` (e.g. with `.duration` and `.hasSoloTracks`) actually correct?**
  _`AudioTrack` has 3 INFERRED edges - model-reasoned connections that need verification._