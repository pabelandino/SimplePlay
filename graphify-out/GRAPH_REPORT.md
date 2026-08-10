# Graph Report - SimplePlay  (2026-08-10)

## Corpus Check
- 94 files · ~48,436 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 1611 nodes · 3812 edges · 73 communities (69 shown, 4 thin omitted)
- Extraction: 90% EXTRACTED · 10% INFERRED · 0% AMBIGUOUS · INFERRED: 384 edges (avg confidence: 0.8)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `006e51f2`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- SimplePlayUITests
- SectionMarkerChipView
- PropertiesSidebarView
- What You Must Do When Invoked
- TrackLaneView
- graphify reference: extra exports and benchmark
- Sendable
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
- Float
- AudioImportService
- AudioEngineService
- StandardTrackRole
- .applyImportedStems
- ProjectPersistenceService
- MIDIMappingBarView
- SidebarPanel
- TimeInterval
- CGFloat
- .frames
- View
- CodingKeys
- .stop
- AudioTrack
- AudioSampleRate
- SupportedAudioFormats
- .snap
- TransportBarView
- TimelineOverviewBar
- AudioDeviceService
- UUID
- AppKit
- .log
- .play
- TrackPitchControlView
- Testing
- .peaks
- .selectedMarkerEditor
- AVFoundation
- MIDIInputService
- SectionLoopContext
- .loadBucket
- SettingsFieldLabel
- TrackControlButton
- SimplePlayProjectArchive
- UIKitToolbarMenuButtonRepresentable
- DAWVerticalFaderView
- ScheduledClip
- Foundation
- SimplePlayTests.swift
- AudioEngineError
- .sectionMappingCard
- PitchShiftSettings
- .scheduleClip
- .sessionManagement
- WorkspaceSettingsView
- TopToolbarView
- WorkspaceViewModel
- AudioClip
- MIDINoteAssignment
- DAWTheme
- ProjectPersistenceError
- SectionPlaybackStatus
- .saveProject
- Color

## God Nodes (most connected - your core abstractions)
1. `WorkspaceViewModel` - 238 edges
2. `AudioEngineService` - 78 edges
3. `ArrangementSection` - 59 edges
4. `DAWTheme` - 51 edges
5. `MIDIMappingBarView` - 46 edges
6. `AudioTrack` - 42 edges
7. `ArrangementPlaybackEngine` - 36 edges
8. `MixerPanelView` - 35 edges
9. `TimelineWorkspacePanel` - 35 edges
10. `StandardTrackRole` - 31 edges

## Surprising Connections (you probably didn't know these)
- `.selectedDevice` --references--> `WorkspaceViewModel`  [INFERRED]
  SimplePlay/Features/Workspace/Views/PropertiesSidebarView.swift → SimplePlay/Features/Workspace/ViewModels/WorkspaceViewModel.swift
- `.settingsHeader` --calls--> `DAWPrimaryButtonStyle`  [INFERRED]
  SimplePlay/Features/Workspace/Views/WorkspaceSettingsView.swift → SimplePlay/Features/Workspace/Views/TopToolbarView.swift
- `.body` --references--> `ArrangementSection`  [INFERRED]
  SimplePlay/Features/Workspace/Views/SectionMarkerLaneView.swift → SimplePlay/Core/Models/ArrangementSection.swift
- `.body` --references--> `ArrangementSection`  [INFERRED]
  SimplePlay/Features/Workspace/Views/SectionMarkerLaneView.swift → SimplePlay/Core/Models/ArrangementSection.swift
- `.duration` --references--> `AudioTrack`  [INFERRED]
  SimplePlay/Core/Models/DAWProject.swift → SimplePlay/Core/Models/AudioTrack.swift

## Import Cycles
- None detected.

## Communities (73 total, 4 thin omitted)

### Community 0 - "SimplePlayUITests"
Cohesion: 0.15
Nodes (6): SimplePlayUITests, SimplePlayUITestsLaunchTests, .runsForEachTargetApplicationUIConfiguration, Bool, XCTest, XCTestCase

### Community 1 - "SectionMarkerChipView"
Cohesion: 0.06
Nodes (41): NSCursor, Bool, String, TimeInterval, SectionDragKind, move, resizeEnd, resizeStart (+33 more)

### Community 2 - "PropertiesSidebarView"
Cohesion: 0.14
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

### Community 6 - "Sendable"
Cohesion: 0.19
Nodes (24): Codable, Equatable, Sendable, PersistedClip, PersistedProject, PersistedTrack, SavedProjectDocument, Bool (+16 more)

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

### Community 15 - "MixerPanelView"
Cohesion: 0.06
Nodes (38): MixerPanelView, .body, .channelFaderHeight, .channelFaderWidth, .channelStripWidth, .groupDivider, .isCompact, .masterFaderHeight (+30 more)

### Community 16 - "TimelineWorkspacePanel"
Cohesion: 0.08
Nodes (35): PlayheadView, .body, .playheadDragGesture, Bool, CGFloat, Content, Double, Gesture (+27 more)

### Community 17 - "Float"
Cohesion: 0.23
Nodes (4): AVAudioMixerNode, Float, UUID, Void

### Community 18 - "AudioImportService"
Cohesion: 0.08
Nodes (26): LocalizedError, AudioFileStorageService, String, URL, UUID, AudioImportError, emptySelection, .errorDescription (+18 more)

### Community 19 - "AudioEngineService"
Cohesion: 0.14
Nodes (8): AudioEngineService, .isAnyPlayerPlaying, .isPlaybackGraphReady, .isSectionLoopPlaybackActive, .masterVolume, .primaryClipSampleRate, TimeInterval, UInt64

### Community 20 - "StandardTrackRole"
Cohesion: 0.06
Nodes (36): CaseIterable, SectionPlaybackMode, continueTimeline, continueToNext, .displayName, .id, oneShot, repeatSection (+28 more)

### Community 21 - ".applyImportedStems"
Cohesion: 0.15
Nodes (6): Error, Result, DAWProject, String, URL, .body

### Community 22 - "ProjectPersistenceService"
Cohesion: 0.21
Nodes (8): missingAudioFile, unsupportedVersion, ProjectPersistenceService, Bool, Data, DAWProject, URL, UUID

### Community 23 - "MIDIMappingBarView"
Cohesion: 0.12
Nodes (17): Animation, AnyTransition, MIDIMappingBarView, .assignModeToggle, .body, .collapsedBar, .collapsedBarContent, .devicePickerLabel (+9 more)

### Community 24 - "SidebarPanel"
Cohesion: 0.12
Nodes (27): Selection, .audioSettings, .playbackSettings, .sectionEditor, .selectionInfo, .trackPitch, SettingsBadge, SettingsFootnote (+19 more)

### Community 25 - "TimeInterval"
Cohesion: 0.18
Nodes (5): SectionEdgeGuides, Bool, TimeInterval, .activeSectionEdgeGuides, Timer

### Community 26 - "CGFloat"
Cohesion: 0.15
Nodes (9): CGFloat, TimelineScrollAlignment, center, leading, start, TimelineScrollRequest, .minimumTimelineZoom, .timelineContentWidth (+1 more)

### Community 27 - ".frames"
Cohesion: 0.32
Nodes (6): Bool, Double, Int64, TimeInterval, TimelineSampleGrid, TimelineSampleGridTests

### Community 28 - "View"
Cohesion: 0.20
Nodes (9): Bool, Configuration, ToolbarMenuButtonStyleModifier, .importButton, .projectSessionButton, ImportToolbarMenuButton, .body, ProjectSessionToolbarMenuButton (+1 more)

### Community 29 - "CodingKeys"
Cohesion: 0.05
Nodes (44): CodingKey, CodingKeys, colorHex, endTime, id, midiChannel, midiNote, midiUsesControlChange (+36 more)

### Community 30 - ".stop"
Cohesion: 0.18
Nodes (7): Content, View, TransportCommands, .body, View, WorkspaceKeyboardShortcuts, .transportControls

### Community 31 - "AudioTrack"
Cohesion: 0.05
Nodes (50): Encoder, AudioTrack, .color, .displayName, Bool, Double, StandardTrackRole, String (+42 more)

### Community 32 - "AudioSampleRate"
Cohesion: 0.20
Nodes (13): Double, Hashable, AudioOutputDevice, AudioSampleRate, .displayName, .id, rate44100, rate48000 (+5 more)

### Community 33 - "SupportedAudioFormats"
Cohesion: 0.05
Nodes (37): FileDocument, FileWrapper, ReadConfiguration, SimplePlayProjectFileDocument, .readableContentTypes, Data, DropURLLoader, NSItemProvider (+29 more)

### Community 34 - ".snap"
Cohesion: 0.12
Nodes (7): Bool, TimeInterval, ImportPanelKind, audioFiles, folder, Int, .trackHeaderColumnTracksOnly

### Community 35 - "TransportBarView"
Cohesion: 0.09
Nodes (23): Binding, Bool, CGFloat, Double, String, Void, TransportBarStyle, phoneBottomDock (+15 more)

### Community 36 - "TimelineOverviewBar"
Cohesion: 0.18
Nodes (14): Bool, CGFloat, CGSize, ClosedRange, Gesture, TimeInterval, TimelineOverviewBar, .barHeight (+6 more)

### Community 37 - "AudioDeviceService"
Cohesion: 0.26
Nodes (5): AudioDeviceID, AudioDeviceService, Bool, Int, String

### Community 38 - "UUID"
Cohesion: 0.12
Nodes (14): Double, Float, UUID, .mixerScrollWithPinnedMasters, Binding, Double, TrackHeaderRowView, .body (+6 more)

### Community 39 - "AppKit"
Cohesion: 0.09
Nodes (18): AppKit, Notification, NSApplicationDelegate, NSEvent, NSObject, NSView, NSViewRepresentable, NSWindow (+10 more)

### Community 40 - ".log"
Cohesion: 0.38
Nodes (6): SectionLoopDiagnostics, AVAudioFrameCount, Double, Int64, String, TimeInterval

### Community 41 - ".play"
Cohesion: 0.26
Nodes (3): AVAudioNode, AVAudioPlayerNode, .playbackGraphIsHealthy

### Community 42 - "TrackPitchControlView"
Cohesion: 0.16
Nodes (13): .actionButtons, Binding, Bool, Double, String, UUID, TrackPitchControlView, .menuTitle (+5 more)

### Community 43 - "Testing"
Cohesion: 0.31
Nodes (3): SimplePlay, ProjectArchiveTests, Testing

### Community 44 - ".peaks"
Cohesion: 0.09
Nodes (31): AVAudioPCMBuffer, CheckedContinuation, Never, Path, clips, Double, Float, Int (+23 more)

### Community 45 - ".selectedMarkerEditor"
Cohesion: 0.33
Nodes (8): ButtonStyle, .selectedMarkerEditor, DAWIconToolbarButtonStyle, DAWLabeledToolbarButtonStyle, DAWPrimaryButtonStyle, DAWSecondaryButtonStyle, Content, .body

### Community 46 - "AVFoundation"
Cohesion: 0.20
Nodes (4): AVFoundation, CoreAudio, CoreMIDI, os

### Community 47 - "MIDIInputService"
Cohesion: 0.09
Nodes (21): Identifiable, MIDINotifyProc, MIDIPacket, MIDIPacketList, MIDIInputService, MIDISourceInfo, .id, Bool (+13 more)

### Community 48 - "SectionLoopContext"
Cohesion: 0.32
Nodes (8): SectionLoopContext, .duration, TimeInterval, UUID, Bool, Int, Int64, String

### Community 49 - ".loadBucket"
Cohesion: 0.31
Nodes (5): CoreGraphics, CGFloat, Int, WaveformLOD, .requiredLOD

### Community 50 - "SettingsFieldLabel"
Cohesion: 0.25
Nodes (9): .volumeControls, SettingsControlSurface, .body, SettingsFieldLabel, .body, .body, SettingsTextInput, .body (+1 more)

### Community 51 - "TrackControlButton"
Cohesion: 0.22
Nodes (8): PanKnobView, .body, Bool, Double, String, Void, TrackControlButton, .body

### Community 52 - "SimplePlayProjectArchive"
Cohesion: 0.16
Nodes (15): Asset, SimplePlayProjectArchive, SimplePlayProjectArchiveError, corruptAsset, corruptManifest, .errorDescription, invalidArchive, Bool (+7 more)

### Community 53 - "UIKitToolbarMenuButtonRepresentable"
Cohesion: 0.33
Nodes (7): Coordinator, Context, String, Void, UIKitToolbarMenuButtonRepresentable, UIButton, UIViewRepresentable

### Community 54 - "DAWVerticalFaderView"
Cohesion: 0.09
Nodes (25): ClosedRange, Double, Float, String, TrackVolumeSettings, .trackRange, DAWVerticalFaderView, .body (+17 more)

### Community 55 - "ScheduledClip"
Cohesion: 0.22
Nodes (6): AVAudioFile, AVAudioUnitEQ, ScheduledClip, AVAudioUnitTimePitch, DAWProject, UInt32

### Community 56 - "Foundation"
Cohesion: 0.14
Nodes (5): Foundation, Observation, SnapGrid, TimeFormatting, SwiftUI

### Community 58 - "AudioEngineError"
Cohesion: 0.29
Nodes (7): AudioEngineError, clipLoadFailed, deviceSelectionFailed, engineStartFailed, .errorDescription, noPlayableClips, playbackUnavailable

### Community 59 - ".sectionMappingCard"
Cohesion: 0.15
Nodes (11): .expandedPanel, .learnBanner, .loopMappingCard, SectionMappingAssignButtonStyle, SectionMappingCardGlow, SectionMappingPlayButtonStyle, Bool, CGFloat (+3 more)

### Community 61 - "PitchShiftSettings"
Cohesion: 0.31
Nodes (5): PitchShiftSettings, AVAudioUnitTimePitch, Double, Float, PitchShiftSettingsTests

### Community 62 - ".scheduleClip"
Cohesion: 0.39
Nodes (4): AVAudioFramePosition, AVAudioTime, AVAudioFrameCount, Double

### Community 64 - ".sessionManagement"
Cohesion: 0.60
Nodes (3): .sessionManagement, .projectSessionMenuItems, .body

### Community 65 - "WorkspaceSettingsView"
Cohesion: 0.08
Nodes (23): App, Commands, Scene, ContentView, .body, FileCommands, Binding, Bool (+15 more)

### Community 66 - "TopToolbarView"
Cohesion: 0.25
Nodes (11): String, Void, TopToolbarView, .importMenuItems, .isCompact, .openButton, .projectTitle, .saveButton (+3 more)

### Community 67 - "WorkspaceViewModel"
Cohesion: 0.07
Nodes (21): ClosedRange, Date, Set, UInt8, WorkspaceViewModel, .activePitchTrack, .activePlaybackSection, .canSaveDirectlyToCurrentURL (+13 more)

### Community 68 - "AudioClip"
Cohesion: 0.36
Nodes (7): AudioClip, .endTime, Int, String, TimeInterval, URL, UUID

### Community 70 - "MIDINoteAssignment"
Cohesion: 0.18
Nodes (10): MIDILearnTarget, loopToggle, section, MIDINoteAssignment, .displayName, Bool, String, UInt8 (+2 more)

### Community 71 - "DAWTheme"
Cohesion: 0.11
Nodes (19): Glass, LinearGradient, .sectionLoopToggle, .overviewBackground, DAWGlassChrome, .controlGlass, .panelGlass, CGFloat (+11 more)

### Community 73 - "ProjectPersistenceError"
Cohesion: 0.18
Nodes (10): JSONDecoder, .projectDecoder, JSONEncoder, .pretty, ProjectPersistenceError, .errorDescription, invalidPackage, missingManifest (+2 more)

### Community 77 - "SectionPlaybackStatus"
Cohesion: 0.33
Nodes (5): SectionPlaybackStatus, idle, playing, queued, repeatingAtEnd

### Community 79 - ".saveProject"
Cohesion: 0.25
Nodes (4): ProjectFilePanel, String, URL, .body

### Community 81 - "Color"
Cohesion: 0.18
Nodes (7): Color, StandardTrackRole, .fallbackColor, Bool, Double, TrackWaveformProgressBar, .body

## Knowledge Gaps
- **280 isolated node(s):** `id`, `name`, `startTime`, `endTime`, `colorHex` (+275 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **4 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `WorkspaceViewModel` connect `WorkspaceViewModel` to `SectionMarkerChipView`, `PropertiesSidebarView`, `TrackLaneView`, `ArrangementSection`, `MixerPanelView`, `TimelineWorkspacePanel`, `AudioImportService`, `AudioEngineService`, `StandardTrackRole`, `.applyImportedStems`, `ProjectPersistenceService`, `MIDIMappingBarView`, `TimeInterval`, `CGFloat`, `View`, `.stop`, `AudioTrack`, `AudioSampleRate`, `SupportedAudioFormats`, `.snap`, `TransportBarView`, `TimelineOverviewBar`, `AudioDeviceService`, `UUID`, `AppKit`, `TrackPitchControlView`, `MIDIInputService`, `Foundation`, `.sectionMappingCard`, `.sessionManagement`, `WorkspaceSettingsView`, `TopToolbarView`, `MIDINoteAssignment`, `DAWTheme`, `SectionPlaybackStatus`, `.saveProject`, `Color`?**
  _High betweenness centrality (0.466) - this node is a cross-community bridge._
- **Why does `AudioEngineService` connect `AudioEngineService` to `WorkspaceViewModel`, `UUID`, `.play`, `AVFoundation`, `SectionLoopContext`, `Float`, `.applyImportedStems`, `ScheduledClip`, `.scheduleClip`?**
  _High betweenness centrality (0.100) - this node is a cross-community bridge._
- **Why does `ArrangementSection` connect `ArrangementSection` to `SectionMarkerChipView`, `PropertiesSidebarView`, `WorkspaceViewModel`, `Sendable`, `DAWTheme`, `SectionPlaybackStatus`, `MIDIInputService`, `Color`, `StandardTrackRole`, `MIDIMappingBarView`, `Foundation`, `TimeInterval`, `.sectionMappingCard`, `CodingKeys`, `AudioTrack`?**
  _High betweenness centrality (0.095) - this node is a cross-community bridge._
- **Are the 12 inferred relationships involving `WorkspaceViewModel` (e.g. with `ArrangementPlaybackEngine` and `AudioEngineService`) actually correct?**
  _`WorkspaceViewModel` has 12 INFERRED edges - model-reasoned connections that need verification._
- **Are the 2 inferred relationships involving `AudioEngineService` (e.g. with `WorkspaceViewModel` and `.configureAudioEngine()`) actually correct?**
  _`AudioEngineService` has 2 INFERRED edges - model-reasoned connections that need verification._
- **Are the 4 inferred relationships involving `ArrangementSection` (e.g. with `.body` and `.body`) actually correct?**
  _`ArrangementSection` has 4 INFERRED edges - model-reasoned connections that need verification._
- **What connects `id`, `name`, `startTime` to the rest of the system?**
  _280 weakly-connected nodes found - possible documentation gaps or missing edges._