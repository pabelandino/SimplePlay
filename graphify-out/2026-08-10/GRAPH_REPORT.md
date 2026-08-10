# Graph Report - SimplePlay  (2026-08-10)

## Corpus Check
- 94 files · ~48,343 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 1610 nodes · 3809 edges · 80 communities (76 shown, 4 thin omitted)
- Extraction: 90% EXTRACTED · 10% INFERRED · 0% AMBIGUOUS · INFERRED: 383 edges (avg confidence: 0.8)
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
- SettingsFormStyle.swift
- TimeInterval
- AudioTrack
- .frames
- TrackGroup
- CodingKeys
- .body
- TrackOrganizationService
- AudioSampleRate
- SupportedAudioFormats
- .snap
- TransportBarView
- TimelineOverviewBar
- AudioOutputDevice
- UUID
- AppKit
- .log
- .play
- TrackPitchControlView
- Testing
- .peaks
- DAWTheme
- FaderMeterStripView
- MIDIInputService
- SectionLoopContext
- TrackHeaderRowView
- WorkspaceView
- .standardize
- SimplePlayProjectArchive
- UIKitToolbarMenuButtonRepresentable
- DAWVerticalFaderView
- ScheduledClip
- Foundation
- SettingsFootnote
- AudioEngineError
- .loopMappingCard
- DAWProject
- PitchShiftSettings
- .scheduleClip
- .groupVolumeBinding
- .sessionManagement
- WorkspaceSettingsView
- View
- WorkspaceViewModel
- AudioClip
- DAWProject
- MIDINoteAssignment
- DAWGlassChrome
- AudioDropOverlay
- ProjectPersistenceError
- SidebarPanel
- MIDILearnTarget
- SectionPlaybackStatus
- .setZoom
- .buildArchivePayload
- TrackWaveformProgressBar

## God Nodes (most connected - your core abstractions)
1. `WorkspaceViewModel` - 238 edges
2. `AudioEngineService` - 78 edges
3. `ArrangementSection` - 59 edges
4. `DAWTheme` - 50 edges
5. `MIDIMappingBarView` - 45 edges
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
- `.body` --calls--> `WorkspaceView`  [INFERRED]
  SimplePlay/ContentView.swift → SimplePlay/Features/Workspace/Views/WorkspaceView.swift
- `.body` --references--> `ArrangementSection`  [INFERRED]
  SimplePlay/Features/Workspace/Views/SectionMarkerLaneView.swift → SimplePlay/Core/Models/ArrangementSection.swift
- `.body` --references--> `ArrangementSection`  [INFERRED]
  SimplePlay/Features/Workspace/Views/SectionMarkerLaneView.swift → SimplePlay/Core/Models/ArrangementSection.swift

## Import Cycles
- None detected.

## Communities (80 total, 4 thin omitted)

### Community 0 - "SimplePlayUITests"
Cohesion: 0.15
Nodes (6): SimplePlayUITests, SimplePlayUITestsLaunchTests, .runsForEachTargetApplicationUIConfiguration, Bool, XCTest, XCTestCase

### Community 1 - "SectionMarkerChipView"
Cohesion: 0.08
Nodes (35): NSCursor, SectionDragKind, move, resizeEnd, resizeStart, ResizeEdge, end, start (+27 more)

### Community 2 - "PropertiesSidebarView"
Cohesion: 0.14
Nodes (16): PropertiesSidebarView, .body, .masterVolumeBinding, .pitchIsOriginal, .pitchLabel, .sectionCreationHint, .selectedDevice, .selectedDeviceID (+8 more)

### Community 3 - "What You Must Do When Invoked"
Cohesion: 0.08
Nodes (24): For /graphify add and --watch, For /graphify query, For the commit hook and native AGENTS.md integration, For --update and --cluster-only, /graphify, Honesty Rules, Interpreter guard for subcommands, Part A - Structural extraction for code files (+16 more)

### Community 4 - "TrackLaneView"
Cohesion: 0.07
Nodes (31): CoreGraphics, G, GraphicsContext, CGFloat, String, TimeInterval, TimelineRulerScale, CGFloat (+23 more)

### Community 5 - "graphify reference: extra exports and benchmark"
Cohesion: 0.22
Nodes (8): graphify reference: extra exports and benchmark, Step 6b - Wiki (only if --wiki flag), Step 7 - Neo4j export (only if --neo4j or --neo4j-push flag), Step 7a - FalkorDB export (only if --falkordb or --falkordb-push flag), Step 7b - SVG export (only if --svg flag), Step 7c - GraphML export (only if --graphml flag), Step 7d - MCP server (only if --mcp flag), Step 8 - Token reduction benchmark (only if total_words > 5000)

### Community 6 - "Sendable"
Cohesion: 0.18
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
Nodes (34): ArrangementSection, .color, .duration, Bool, Decoder, String, TimeInterval, UInt8 (+26 more)

### Community 15 - "MixerPanelView"
Cohesion: 0.10
Nodes (21): MixerPanelView, .body, .channelFaderHeight, .channelFaderWidth, .channelStripWidth, .groupDivider, .isCompact, .masterFaderHeight (+13 more)

### Community 16 - "TimelineWorkspacePanel"
Cohesion: 0.11
Nodes (28): PlayheadView, .body, .playheadDragGesture, Bool, CGFloat, Content, Double, Gesture (+20 more)

### Community 17 - "Float"
Cohesion: 0.23
Nodes (4): AVAudioMixerNode, Float, UUID, Void

### Community 18 - "AudioImportService"
Cohesion: 0.12
Nodes (19): LocalizedError, AudioFileStorageService, String, URL, UUID, AudioImportError, emptySelection, .errorDescription (+11 more)

### Community 19 - "AudioEngineService"
Cohesion: 0.14
Nodes (8): AudioEngineService, .isAnyPlayerPlaying, .isPlaybackGraphReady, .isSectionLoopPlaybackActive, .masterVolume, .primaryClipSampleRate, TimeInterval, UInt64

### Community 20 - "StandardTrackRole"
Cohesion: 0.06
Nodes (36): CaseIterable, SectionPlaybackMode, continueTimeline, continueToNext, .displayName, .id, oneShot, repeatSection (+28 more)

### Community 21 - ".applyImportedStems"
Cohesion: 0.14
Nodes (6): Error, Result, DAWProject, String, URL, .body

### Community 22 - "ProjectPersistenceService"
Cohesion: 0.33
Nodes (5): unsupportedVersion, ProjectPersistenceService, Bool, URL, UUID

### Community 23 - "MIDIMappingBarView"
Cohesion: 0.10
Nodes (22): Animation, AnyTransition, Color, StandardTrackRole, .fallbackColor, MIDIMappingBarView, .body, .collapsedBar (+14 more)

### Community 24 - "SettingsFormStyle.swift"
Cohesion: 0.14
Nodes (20): .playbackSettings, .volumeControls, SettingsControlSurface, .body, SettingsFieldLabel, .body, .body, SettingsNumberInput (+12 more)

### Community 25 - "TimeInterval"
Cohesion: 0.16
Nodes (8): Bool, TimeInterval, TimelineScrollAlignment, center, leading, start, .transportControls, Timer

### Community 26 - "AudioTrack"
Cohesion: 0.22
Nodes (12): AudioTrack, .color, .displayName, Bool, Double, StandardTrackRole, String, UUID (+4 more)

### Community 27 - ".frames"
Cohesion: 0.32
Nodes (6): Bool, Double, Int64, TimeInterval, TimelineSampleGrid, TimelineSampleGridTests

### Community 28 - "TrackGroup"
Cohesion: 0.27
Nodes (8): Encoder, Date, Decoder, Double, String, TimeInterval, UUID, TrackGroup

### Community 29 - "CodingKeys"
Cohesion: 0.05
Nodes (44): CodingKey, CodingKeys, colorHex, endTime, id, midiChannel, midiNote, midiUsesControlChange (+36 more)

### Community 30 - ".body"
Cohesion: 0.14
Nodes (11): Commands, ContentView, .body, FileCommands, Content, View, TransportCommands, .body (+3 more)

### Community 31 - "TrackOrganizationService"
Cohesion: 0.13
Nodes (18): .defaultColor, ImportedStem, ImportPlacement, appendNewGroup, insertIntoGroup, DAWProject, Int, String (+10 more)

### Community 32 - "AudioSampleRate"
Cohesion: 0.17
Nodes (12): Double, Identifiable, AudioSampleRate, .displayName, .id, rate44100, rate48000, AudioSettings (+4 more)

### Community 33 - "SupportedAudioFormats"
Cohesion: 0.05
Nodes (37): FileDocument, FileWrapper, ReadConfiguration, SimplePlayProjectFileDocument, .readableContentTypes, Data, DropURLLoader, NSItemProvider (+29 more)

### Community 34 - ".snap"
Cohesion: 0.14
Nodes (7): Bool, TimeInterval, ImportPanelKind, audioFiles, folder, .importMenuItems, .body

### Community 35 - "TransportBarView"
Cohesion: 0.10
Nodes (21): Binding, Bool, CGFloat, Double, String, Void, TransportBarStyle, phoneBottomDock (+13 more)

### Community 36 - "TimelineOverviewBar"
Cohesion: 0.15
Nodes (16): LinearGradient, Bool, CGFloat, CGSize, ClosedRange, Gesture, TimeInterval, TimelineOverviewBar (+8 more)

### Community 37 - "AudioOutputDevice"
Cohesion: 0.24
Nodes (8): AudioDeviceID, Hashable, AudioOutputDevice, AudioDeviceService, Bool, Int, String, .audioSettings

### Community 38 - "UUID"
Cohesion: 0.11
Nodes (15): Double, Float, UInt8, UUID, .mixerScrollWithPinnedMasters, .selectedSectionNameBinding, .body, PanKnobView (+7 more)

### Community 39 - "AppKit"
Cohesion: 0.08
Nodes (21): App, AppKit, Notification, NSApplicationDelegate, NSEvent, NSObject, NSView, NSViewRepresentable (+13 more)

### Community 40 - ".log"
Cohesion: 0.38
Nodes (6): SectionLoopDiagnostics, AVAudioFrameCount, Double, Int64, String, TimeInterval

### Community 41 - ".play"
Cohesion: 0.26
Nodes (3): AVAudioNode, AVAudioPlayerNode, .playbackGraphIsHealthy

### Community 42 - "TrackPitchControlView"
Cohesion: 0.12
Nodes (15): .selectedTrackPitchBinding, .actionButtons, Binding, Bool, Double, String, UUID, TrackPitchControlView (+7 more)

### Community 43 - "Testing"
Cohesion: 0.20
Nodes (5): SimplePlay, ProjectArchiveTests, SectionMarkerPaletteTests, SimplePlayTests, Testing

### Community 44 - ".peaks"
Cohesion: 0.09
Nodes (31): AVAudioPCMBuffer, CheckedContinuation, Never, Path, clips, Double, Float, Int (+23 more)

### Community 45 - "DAWTheme"
Cohesion: 0.13
Nodes (16): ButtonStyle, .assignModeToggle, .learnBanner, DAWIconToolbarButtonStyle, DAWLabeledToolbarButtonStyle, DAWPrimaryButtonStyle, DAWSecondaryButtonStyle, Configuration (+8 more)

### Community 46 - "FaderMeterStripView"
Cohesion: 0.15
Nodes (12): .projectMasterStrip, .mainVolumeControl, FaderMeterStripView, .reservesThumbClearance, .showsUnityMark, .usesUnityCenterDecibelScale, Bool, CGFloat (+4 more)

### Community 47 - "MIDIInputService"
Cohesion: 0.07
Nodes (23): CoreMIDI, MIDINotifyProc, MIDIPacket, MIDIPacketList, MIDIInputEvent, MIDIInputService, MIDISourceInfo, .id (+15 more)

### Community 48 - "SectionLoopContext"
Cohesion: 0.32
Nodes (8): SectionLoopContext, .duration, TimeInterval, UUID, Bool, Int, Int64, String

### Community 49 - "TrackHeaderRowView"
Cohesion: 0.12
Nodes (12): Int, .trackHeaderColumnTracksOnly, .trackLanes, Binding, Double, TrackHeaderRowView, .displayColor, .liveTrack (+4 more)

### Community 50 - "WorkspaceView"
Cohesion: 0.33
Nodes (7): Binding, Bool, String, WorkspaceView, .deleteSectionDialogTitle, .phoneBottomChrome, .sectionDeletionDialogBinding

### Community 51 - ".standardize"
Cohesion: 0.25
Nodes (7): StandardizedName, Bool, StandardTrackRole, String, URL, TrackNameStandardizer, TrackNameStandardizerTests

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
Cohesion: 0.11
Nodes (8): AVFoundation, CoreAudio, Foundation, Observation, os, SnapGrid, TimeFormatting, SwiftUI

### Community 57 - "SettingsFootnote"
Cohesion: 0.22
Nodes (11): Selection, .sectionEditor, .selectionInfo, .trackPitch, SettingsBadge, SettingsFootnote, .body, SettingsMenuRow (+3 more)

### Community 58 - "AudioEngineError"
Cohesion: 0.29
Nodes (7): AudioEngineError, clipLoadFailed, deviceSelectionFailed, engineStartFailed, .errorDescription, noPlayableClips, playbackUnavailable

### Community 59 - ".loopMappingCard"
Cohesion: 0.24
Nodes (6): .loopMappingCard, SectionMappingAssignButtonStyle, SectionMappingCardGlow, SectionMappingPlayButtonStyle, Configuration, Content

### Community 60 - "DAWProject"
Cohesion: 0.36
Nodes (8): DAWProject, Bool, Double, Int32, String, TimeInterval, UInt8, UUID

### Community 61 - "PitchShiftSettings"
Cohesion: 0.27
Nodes (5): PitchShiftSettings, AVAudioUnitTimePitch, Double, Float, PitchShiftSettingsTests

### Community 62 - ".scheduleClip"
Cohesion: 0.39
Nodes (4): AVAudioFramePosition, AVAudioTime, AVAudioFrameCount, Double

### Community 63 - ".groupVolumeBinding"
Cohesion: 0.36
Nodes (4): .masterVolumeBinding, Binding, Double, UUID

### Community 64 - ".sessionManagement"
Cohesion: 0.60
Nodes (3): .sessionManagement, .projectSessionMenuItems, .body

### Community 65 - "WorkspaceSettingsView"
Cohesion: 0.24
Nodes (8): Binding, Bool, String, WorkspaceSettingsView, .body, .deleteSectionDialogTitle, .sectionDeletionDialogBinding, .settingsHeader

### Community 66 - "View"
Cohesion: 0.17
Nodes (18): Bool, Content, String, Void, ToolbarMenuButtonStyleModifier, TopToolbarView, .importButton, .isCompact (+10 more)

### Community 67 - "WorkspaceViewModel"
Cohesion: 0.07
Nodes (26): SectionEdgeGuides, CGFloat, ClosedRange, Date, Set, TimelineScrollRequest, WorkspaceViewModel, .activePitchTrack (+18 more)

### Community 68 - "AudioClip"
Cohesion: 0.36
Nodes (7): AudioClip, .endTime, Int, String, TimeInterval, URL, UUID

### Community 69 - "DAWProject"
Cohesion: 0.39
Nodes (4): groups, DAWProject, Int, UUID

### Community 70 - "MIDINoteAssignment"
Cohesion: 0.14
Nodes (13): MIDINoteAssignment, .displayName, Bool, String, UInt8, Bool, String, TimeInterval (+5 more)

### Community 71 - "DAWGlassChrome"
Cohesion: 0.17
Nodes (9): Glass, DAWGlassChrome, .controlGlass, .panelGlass, CGFloat, Double, View, View (+1 more)

### Community 72 - "AudioDropOverlay"
Cohesion: 0.33
Nodes (5): AudioDropOverlay, .body, String, TimelineEmptyDropHint, .body

### Community 73 - "ProjectPersistenceError"
Cohesion: 0.17
Nodes (11): JSONDecoder, .projectDecoder, JSONEncoder, .pretty, ProjectPersistenceError, .errorDescription, invalidPackage, missingAudioFile (+3 more)

### Community 74 - "SidebarPanel"
Cohesion: 0.47
Nodes (5): SidebarLabeledRow, .body, SidebarPanel, Content, String

### Community 75 - "MIDILearnTarget"
Cohesion: 0.40
Nodes (4): MIDILearnTarget, loopToggle, section, UUID

### Community 77 - "SectionPlaybackStatus"
Cohesion: 0.33
Nodes (5): SectionPlaybackStatus, idle, playing, queued, repeatingAtEnd

### Community 79 - ".buildArchivePayload"
Cohesion: 0.21
Nodes (5): Data, ProjectFilePanel, String, URL, .body

### Community 81 - "TrackWaveformProgressBar"
Cohesion: 0.40
Nodes (4): Bool, Double, TrackWaveformProgressBar, .body

## Knowledge Gaps
- **280 isolated node(s):** `id`, `name`, `startTime`, `endTime`, `colorHex` (+275 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **4 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `WorkspaceViewModel` connect `WorkspaceViewModel` to `SectionMarkerChipView`, `PropertiesSidebarView`, `TrackLaneView`, `ArrangementSection`, `MixerPanelView`, `TimelineWorkspacePanel`, `AudioImportService`, `AudioEngineService`, `StandardTrackRole`, `.applyImportedStems`, `ProjectPersistenceService`, `MIDIMappingBarView`, `TimeInterval`, `AudioTrack`, `.body`, `TrackOrganizationService`, `AudioSampleRate`, `SupportedAudioFormats`, `.snap`, `TransportBarView`, `TimelineOverviewBar`, `AudioOutputDevice`, `UUID`, `AppKit`, `TrackPitchControlView`, `DAWTheme`, `MIDIInputService`, `TrackHeaderRowView`, `WorkspaceView`, `Foundation`, `.loopMappingCard`, `.groupVolumeBinding`, `.sessionManagement`, `WorkspaceSettingsView`, `View`, `MIDINoteAssignment`, `MIDILearnTarget`, `SectionPlaybackStatus`, `.setZoom`, `.buildArchivePayload`?**
  _High betweenness centrality (0.451) - this node is a cross-community bridge._
- **Why does `AudioEngineService` connect `AudioEngineService` to `WorkspaceViewModel`, `UUID`, `.play`, `SectionLoopContext`, `Float`, `.applyImportedStems`, `ScheduledClip`, `Foundation`, `.scheduleClip`?**
  _High betweenness centrality (0.099) - this node is a cross-community bridge._
- **Why does `ArrangementSection` connect `ArrangementSection` to `AudioSampleRate`, `SectionMarkerChipView`, `PropertiesSidebarView`, `WorkspaceViewModel`, `TimelineOverviewBar`, `Sendable`, `MIDINoteAssignment`, `Testing`, `SectionPlaybackStatus`, `MIDIInputService`, `StandardTrackRole`, `MIDIMappingBarView`, `Foundation`, `TimeInterval`, `DAWProject`, `CodingKeys`?**
  _High betweenness centrality (0.088) - this node is a cross-community bridge._
- **Are the 12 inferred relationships involving `WorkspaceViewModel` (e.g. with `ArrangementPlaybackEngine` and `AudioEngineService`) actually correct?**
  _`WorkspaceViewModel` has 12 INFERRED edges - model-reasoned connections that need verification._
- **Are the 2 inferred relationships involving `AudioEngineService` (e.g. with `WorkspaceViewModel` and `.configureAudioEngine()`) actually correct?**
  _`AudioEngineService` has 2 INFERRED edges - model-reasoned connections that need verification._
- **Are the 4 inferred relationships involving `ArrangementSection` (e.g. with `.body` and `.body`) actually correct?**
  _`ArrangementSection` has 4 INFERRED edges - model-reasoned connections that need verification._
- **What connects `id`, `name`, `startTime` to the rest of the system?**
  _280 weakly-connected nodes found - possible documentation gaps or missing edges._