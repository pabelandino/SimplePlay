# Graph Report - SimplePlay  (2026-08-10)

## Corpus Check
- 94 files · ~47,302 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 1588 nodes · 3727 edges · 84 communities (78 shown, 6 thin omitted)
- Extraction: 90% EXTRACTED · 10% INFERRED · 0% AMBIGUOUS · INFERRED: 378 edges (avg confidence: 0.8)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `5bf430bd`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- SimplePlayUITests
- SectionMarkerChipView
- PropertiesSidebarView
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
- ArrangementPlaybackEngine
- MixerPanelView
- TimelineWorkspacePanel
- TransportBarView
- AudioImportService
- .isNodeConnected
- StandardTrackRole
- .applyImportedStems
- ProjectPersistenceService
- MIDIMappingBarView
- SidebarPanel
- TimeInterval
- WorkspaceViewModel
- .frames
- Equatable
- CodingKeys
- .body
- TrackOrganizationService
- AudioSampleRate
- .configure
- UUID
- CodingKeys
- SectionPlaybackMode
- AudioDeviceService
- Testing
- MacWindowTitleBarHidden.swift
- .log
- SectionLoopContext
- AudioEngineService
- CGFloat
- .peaks
- View
- ProjectPersistenceError
- Sendable
- PitchShiftSettings
- SwiftUI
- .presentImportPanel
- AudioEngineError
- Codable
- FaderMeterStripView
- DAWVerticalFaderView
- TrackPitchControlView
- Foundation
- ImportDocumentPickerSession
- .loadBucket
- TrackGroup
- DAWProject
- .selectedMarkerEditor
- .mixerChannelStrip
- .body
- .hex
- AudioTrack
- TopToolbarView
- AudioDropTargetModifier
- AudioClip
- .stem
- DAWProject
- DAWTheme
- SimplePlayProjectFileDocument
- SupportedAudioFormats
- WorkspaceView
- ArrangementSection
- MIDILearnTarget
- MIDINoteAssignment
- SectionPlaybackStatus
- DropURLLoader
- PlaybackState
- TrackControlButton
- UniformTypeIdentifiers
- ProjectFilePanel.swift

## God Nodes (most connected - your core abstractions)
1. `WorkspaceViewModel` - 232 edges
2. `AudioEngineService` - 68 edges
3. `ArrangementSection` - 59 edges
4. `DAWTheme` - 49 edges
5. `AudioTrack` - 42 edges
6. `MIDIMappingBarView` - 41 edges
7. `ArrangementPlaybackEngine` - 36 edges
8. `MixerPanelView` - 35 edges
9. `TimelineWorkspacePanel` - 35 edges
10. `StandardTrackRole` - 31 edges

## Surprising Connections (you probably didn't know these)
- `.duration` --references--> `AudioTrack`  [INFERRED]
  SimplePlay/Core/Models/DAWProject.swift → SimplePlay/Core/Models/AudioTrack.swift
- `TrackOrganizationServiceTests` --calls--> `TrackOrganizationService`  [EXTRACTED]
  SimplePlayTests/TrackOrganizationServiceTests.swift → SimplePlay/Core/Services/TrackOrganizationService.swift
- `.selectedDevice` --references--> `WorkspaceViewModel`  [INFERRED]
  SimplePlay/Features/Workspace/Views/PropertiesSidebarView.swift → SimplePlay/Features/Workspace/ViewModels/WorkspaceViewModel.swift
- `.settingsHeader` --calls--> `DAWPrimaryButtonStyle`  [INFERRED]
  SimplePlay/Features/Workspace/Views/WorkspaceSettingsView.swift → SimplePlay/Features/Workspace/Views/TopToolbarView.swift
- `.body` --calls--> `WorkspaceView`  [INFERRED]
  SimplePlay/ContentView.swift → SimplePlay/Features/Workspace/Views/WorkspaceView.swift

## Import Cycles
- None detected.

## Communities (84 total, 6 thin omitted)

### Community 0 - "SimplePlayUITests"
Cohesion: 0.15
Nodes (6): SimplePlayUITests, SimplePlayUITestsLaunchTests, .runsForEachTargetApplicationUIConfiguration, Bool, XCTest, XCTestCase

### Community 1 - "SectionMarkerChipView"
Cohesion: 0.08
Nodes (36): NSCursor, sections, SectionMarkerPalette, .palette, Int, Set, String, ResizeEdge (+28 more)

### Community 2 - "PropertiesSidebarView"
Cohesion: 0.12
Nodes (19): .masterVolumeBinding, PropertiesSidebarView, .body, .masterVolumeBinding, .pitchIsOriginal, .pitchLabel, .sectionCreationHint, .selectedDevice (+11 more)

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

### Community 14 - "ArrangementPlaybackEngine"
Cohesion: 0.16
Nodes (13): ArrangementPlaybackEngine, SectionTriggerResult, activatedImmediately, enabledRepeatAtEnd, queuedForEnd, Bool, TimeInterval, UInt8 (+5 more)

### Community 15 - "MixerPanelView"
Cohesion: 0.10
Nodes (21): MixerPanelView, .body, .channelFaderHeight, .channelFaderWidth, .channelStripWidth, .groupDivider, .isCompact, .masterFaderHeight (+13 more)

### Community 16 - "TimelineWorkspacePanel"
Cohesion: 0.10
Nodes (29): PlayheadView, .playheadDragGesture, Bool, CGFloat, Content, Double, Gesture, String (+21 more)

### Community 17 - "TransportBarView"
Cohesion: 0.06
Nodes (38): Bool, CGFloat, CGSize, ClosedRange, Gesture, TimeInterval, TimelineOverviewBar, .barHeight (+30 more)

### Community 18 - "AudioImportService"
Cohesion: 0.08
Nodes (26): LocalizedError, AudioFileStorageService, String, URL, UUID, AudioImportError, emptySelection, .errorDescription (+18 more)

### Community 20 - "StandardTrackRole"
Cohesion: 0.08
Nodes (24): StandardTrackRole, acousticGuitar, backingVocal, bass, brass, click, countIn, cue (+16 more)

### Community 21 - ".applyImportedStems"
Cohesion: 0.16
Nodes (4): Error, Result, String, URL

### Community 22 - "ProjectPersistenceService"
Cohesion: 0.26
Nodes (7): missingAudioFile, unsupportedVersion, ProjectPersistenceService, Bool, DAWProject, URL, UUID

### Community 23 - "MIDIMappingBarView"
Cohesion: 0.10
Nodes (23): Animation, AnyTransition, ButtonStyle, Color, MIDIMappingBarView, .body, .collapsedBar, .collapsedBarContent (+15 more)

### Community 24 - "SidebarPanel"
Cohesion: 0.09
Nodes (36): Selection, .playbackSettings, .sectionEditor, .selectionInfo, .trackPitch, .volumeControls, SettingsBadge, SettingsControlSurface (+28 more)

### Community 25 - "TimeInterval"
Cohesion: 0.16
Nodes (9): SectionEdgeGuides, Bool, TimeInterval, TimelineScrollAlignment, center, leading, start, .activeSectionEdgeGuides (+1 more)

### Community 26 - "WorkspaceViewModel"
Cohesion: 0.08
Nodes (21): SectionDragKind, move, resizeEnd, resizeStart, Set, UInt8, WorkspaceViewModel, .activePitchTrack (+13 more)

### Community 27 - ".frames"
Cohesion: 0.29
Nodes (6): Bool, Double, Int64, TimeInterval, TimelineSampleGrid, TimelineSampleGridTests

### Community 28 - "Equatable"
Cohesion: 0.34
Nodes (13): Equatable, PersistedClip, PersistedProject, PersistedTrack, Bool, Decoder, Double, Int32 (+5 more)

### Community 29 - "CodingKeys"
Cohesion: 0.08
Nodes (24): CodingKeys, audioSettings, colorHex, id, isLocked, isMuted, isSnapEnabled, isSolo (+16 more)

### Community 30 - ".body"
Cohesion: 0.17
Nodes (6): Content, View, TransportCommands, .body, View, WorkspaceKeyboardShortcuts

### Community 31 - "TrackOrganizationService"
Cohesion: 0.28
Nodes (10): ImportedStem, ImportPlacement, appendNewGroup, insertIntoGroup, DAWProject, Int, String, TimeInterval (+2 more)

### Community 32 - "AudioSampleRate"
Cohesion: 0.23
Nodes (13): Double, Hashable, Identifiable, AudioOutputDevice, AudioSampleRate, .displayName, .id, rate44100 (+5 more)

### Community 33 - ".configure"
Cohesion: 0.21
Nodes (7): AVAudioFile, AVAudioPlayerNode, AVAudioUnitEQ, ScheduledClip, AVAudioUnitTimePitch, DAWProject, UInt32

### Community 34 - "UUID"
Cohesion: 0.09
Nodes (15): Bool, TimeInterval, Double, Float, UUID, Binding, Double, TrackHeaderRowView (+7 more)

### Community 35 - "CodingKeys"
Cohesion: 0.17
Nodes (12): CodingKeys, colorHex, endTime, id, midiChannel, midiNote, midiUsesControlChange, name (+4 more)

### Community 36 - "SectionPlaybackMode"
Cohesion: 0.15
Nodes (12): CaseIterable, SectionPlaybackMode, continueTimeline, continueToNext, .displayName, .id, oneShot, repeatSection (+4 more)

### Community 37 - "AudioDeviceService"
Cohesion: 0.26
Nodes (6): AudioDeviceID, AudioDeviceService, Bool, Int, String, .audioSettings

### Community 38 - "Testing"
Cohesion: 0.22
Nodes (4): SimplePlay, ProjectArchiveTests, SimplePlayTests, Testing

### Community 39 - "MacWindowTitleBarHidden.swift"
Cohesion: 0.11
Nodes (15): Notification, NSApplicationDelegate, NSEvent, NSObject, NSView, NSViewRepresentable, NSWindow, .body (+7 more)

### Community 40 - ".log"
Cohesion: 0.38
Nodes (6): SectionLoopDiagnostics, AVAudioFrameCount, Double, Int64, String, TimeInterval

### Community 41 - "SectionLoopContext"
Cohesion: 0.17
Nodes (12): AVAudioTime, SectionLoopContext, .duration, TimeInterval, UUID, AVAudioFrameCount, Bool, Int (+4 more)

### Community 42 - "AudioEngineService"
Cohesion: 0.15
Nodes (10): AVAudioMixerNode, AudioEngineService, .isPlaybackGraphReady, .isSectionLoopPlaybackActive, .masterVolume, .primaryClipSampleRate, Double, Float (+2 more)

### Community 43 - "CGFloat"
Cohesion: 0.12
Nodes (7): CGFloat, ClosedRange, TimelineScrollRequest, .minimumTimelineZoom, .timelineContentWidth, .chipMoveOrTapGesture, .sectionCreationGesture

### Community 44 - ".peaks"
Cohesion: 0.09
Nodes (31): AVAudioPCMBuffer, CheckedContinuation, Never, Path, clips, Double, Float, Int (+23 more)

### Community 45 - "View"
Cohesion: 0.12
Nodes (12): Configuration, Content, AudioDropOverlay, .body, String, TimelineEmptyDropHint, .body, Bool (+4 more)

### Community 46 - "ProjectPersistenceError"
Cohesion: 0.18
Nodes (10): JSONDecoder, .projectDecoder, JSONEncoder, .pretty, ProjectPersistenceError, .errorDescription, invalidPackage, missingManifest (+2 more)

### Community 47 - "Sendable"
Cohesion: 0.07
Nodes (27): CoreMIDI, MIDINotifyProc, MIDIPacket, MIDIPacketList, Sendable, Kind, controlChange, noteOn (+19 more)

### Community 48 - "PitchShiftSettings"
Cohesion: 0.31
Nodes (5): PitchShiftSettings, AVAudioUnitTimePitch, Double, Float, PitchShiftSettingsTests

### Community 49 - "SwiftUI"
Cohesion: 0.12
Nodes (12): App, AppKit, Commands, Scene, ContentView, .body, FileCommands, SimplePlayApp (+4 more)

### Community 50 - ".presentImportPanel"
Cohesion: 0.14
Nodes (5): ImportPanelKind, audioFiles, folder, Int, .trackHeaderColumnTracksOnly

### Community 51 - "AudioEngineError"
Cohesion: 0.29
Nodes (7): AudioEngineError, clipLoadFailed, deviceSelectionFailed, engineStartFailed, .errorDescription, noPlayableClips, playbackUnavailable

### Community 52 - "Codable"
Cohesion: 0.22
Nodes (9): Codable, SavedProjectDocument, DAWProject, Int, WorkspaceSnapshot, ManifestFile, Data, String (+1 more)

### Community 53 - "FaderMeterStripView"
Cohesion: 0.15
Nodes (12): .projectMasterStrip, .mainVolumeControl, FaderMeterStripView, .reservesThumbClearance, .showsUnityMark, .usesUnityCenterDecibelScale, Bool, CGFloat (+4 more)

### Community 54 - "DAWVerticalFaderView"
Cohesion: 0.09
Nodes (25): ClosedRange, Double, Float, String, TrackVolumeSettings, .trackRange, DAWVerticalFaderView, .body (+17 more)

### Community 55 - "TrackPitchControlView"
Cohesion: 0.15
Nodes (14): .actionButtons, Binding, Bool, Double, String, UUID, TrackPitchControlView, .menuTitle (+6 more)

### Community 56 - "Foundation"
Cohesion: 0.15
Nodes (7): AVFoundation, CoreAudio, Foundation, Observation, os, SnapGrid, TimeFormatting

### Community 57 - "ImportDocumentPickerSession"
Cohesion: 0.25
Nodes (8): ImportDocumentPickerPresenter, ImportDocumentPickerSession, Bool, URL, Void, UIDocumentPickerDelegate, UIDocumentPickerViewController, UIViewController

### Community 58 - ".loadBucket"
Cohesion: 0.31
Nodes (5): CoreGraphics, CGFloat, Int, WaveformLOD, .requiredLOD

### Community 59 - "TrackGroup"
Cohesion: 0.14
Nodes (16): CodingKey, Date, Encoder, CodingKeys, horizontalOffset, id, importedAt, name (+8 more)

### Community 60 - "DAWProject"
Cohesion: 0.31
Nodes (9): DAWProject, .duration, Bool, Double, Int32, String, TimeInterval, UInt8 (+1 more)

### Community 61 - ".selectedMarkerEditor"
Cohesion: 0.16
Nodes (10): .learnBanner, .selectedMarkerEditor, DAWIconToolbarButtonStyle, DAWLabeledToolbarButtonStyle, DAWPrimaryButtonStyle, DAWSecondaryButtonStyle, Configuration, Content (+2 more)

### Community 62 - ".mixerChannelStrip"
Cohesion: 0.43
Nodes (4): .mixerScrollWithPinnedMasters, Binding, Double, UUID

### Community 63 - ".body"
Cohesion: 0.15
Nodes (10): DAWProject, Binding, Bool, String, WorkspaceSettingsView, .body, .deleteSectionDialogTitle, .sectionDeletionDialogBinding (+2 more)

### Community 64 - ".hex"
Cohesion: 0.23
Nodes (7): .defaultColor, StandardTrackRole, .fallbackColor, Int, StandardTrackRole, String, TrackColorPalette

### Community 65 - "AudioTrack"
Cohesion: 0.24
Nodes (11): AudioTrack, .color, .displayName, Bool, Double, StandardTrackRole, String, UUID (+3 more)

### Community 66 - "TopToolbarView"
Cohesion: 0.09
Nodes (28): .sessionManagement, Bool, String, Void, ToolbarMenuButtonStyleModifier, TopToolbarView, .importButton, .importMenuItems (+20 more)

### Community 67 - "AudioDropTargetModifier"
Cohesion: 0.27
Nodes (7): AudioDropTargetModifier, Content, NSItemProvider, String, TimeInterval, View, View

### Community 68 - "AudioClip"
Cohesion: 0.36
Nodes (7): AudioClip, .endTime, Int, String, TimeInterval, URL, UUID

### Community 69 - ".stem"
Cohesion: 0.36
Nodes (3): String, TimeInterval, TrackOrganizationServiceTests

### Community 70 - "DAWProject"
Cohesion: 0.43
Nodes (4): groups, DAWProject, Int, UUID

### Community 71 - "DAWTheme"
Cohesion: 0.12
Nodes (19): Glass, LinearGradient, .body, .overviewBackground, .body, DAWGlassChrome, .controlGlass, .panelGlass (+11 more)

### Community 72 - "SimplePlayProjectFileDocument"
Cohesion: 0.22
Nodes (7): FileDocument, FileWrapper, ReadConfiguration, SimplePlayProjectFileDocument, .readableContentTypes, Data, WriteConfiguration

### Community 73 - "SupportedAudioFormats"
Cohesion: 0.31
Nodes (9): UTType, SupportedAudioFormats, .contentTypes, .dropTypes, .filePickerTypes, .folderPickerTypes, .importPickerTypes, Set (+1 more)

### Community 74 - "WorkspaceView"
Cohesion: 0.33
Nodes (7): Binding, Bool, String, WorkspaceView, .deleteSectionDialogTitle, .phoneBottomChrome, .sectionDeletionDialogBinding

### Community 75 - "ArrangementSection"
Cohesion: 0.14
Nodes (15): ArrangementSection, .color, .duration, Bool, Decoder, String, TimeInterval, UInt8 (+7 more)

### Community 76 - "MIDILearnTarget"
Cohesion: 0.40
Nodes (4): MIDILearnTarget, loopToggle, section, UUID

### Community 77 - "MIDINoteAssignment"
Cohesion: 0.38
Nodes (6): MIDINoteAssignment, .displayName, Bool, String, UInt8, .loopAssignmentLabel

### Community 78 - "SectionPlaybackStatus"
Cohesion: 0.40
Nodes (5): SectionPlaybackStatus, idle, playing, queued, repeatingAtEnd

### Community 79 - "DropURLLoader"
Cohesion: 0.62
Nodes (4): DropURLLoader, NSItemProvider, String, URL

### Community 80 - "PlaybackState"
Cohesion: 0.33
Nodes (6): PlaybackState, continuingTimeline, idle, playingSection, repeatingSectionAtEnd, waitingToJump

### Community 81 - "TrackControlButton"
Cohesion: 0.22
Nodes (8): PanKnobView, .body, Bool, Double, String, Void, TrackControlButton, .body

## Knowledge Gaps
- **277 isolated node(s):** `id`, `name`, `startTime`, `endTime`, `colorHex` (+272 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **6 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `WorkspaceViewModel` connect `WorkspaceViewModel` to `SectionMarkerChipView`, `PropertiesSidebarView`, `TrackLaneView`, `ArrangementPlaybackEngine`, `MixerPanelView`, `TimelineWorkspacePanel`, `TransportBarView`, `AudioImportService`, `.applyImportedStems`, `ProjectPersistenceService`, `MIDIMappingBarView`, `TimeInterval`, `.body`, `TrackOrganizationService`, `AudioSampleRate`, `UUID`, `SectionPlaybackMode`, `AudioDeviceService`, `AudioEngineService`, `CGFloat`, `View`, `Sendable`, `SwiftUI`, `.presentImportPanel`, `Codable`, `TrackPitchControlView`, `Foundation`, `.mixerChannelStrip`, `.body`, `AudioTrack`, `TopToolbarView`, `AudioDropTargetModifier`, `SimplePlayProjectFileDocument`, `WorkspaceView`, `ArrangementSection`, `MIDILearnTarget`, `SectionPlaybackStatus`?**
  _High betweenness centrality (0.440) - this node is a cross-community bridge._
- **Why does `ArrangementSection` connect `ArrangementSection` to `AudioSampleRate`, `SectionMarkerChipView`, `PropertiesSidebarView`, `CodingKeys`, `SectionPlaybackMode`, `DAWTheme`, `CGFloat`, `View`, `DAWProject`, `Sendable`, `ArrangementPlaybackEngine`, `SwiftUI`, `PlaybackState`, `Codable`, `MIDIMappingBarView`, `TimeInterval`, `WorkspaceViewModel`, `Equatable`?**
  _High betweenness centrality (0.090) - this node is a cross-community bridge._
- **Why does `AudioEngineService` connect `AudioEngineService` to `.configure`, `UUID`, `SectionLoopContext`, `.isNodeConnected`, `.applyImportedStems`, `Foundation`, `WorkspaceViewModel`?**
  _High betweenness centrality (0.088) - this node is a cross-community bridge._
- **Are the 12 inferred relationships involving `WorkspaceViewModel` (e.g. with `ArrangementPlaybackEngine` and `AudioEngineService`) actually correct?**
  _`WorkspaceViewModel` has 12 INFERRED edges - model-reasoned connections that need verification._
- **Are the 2 inferred relationships involving `AudioEngineService` (e.g. with `WorkspaceViewModel` and `.configureAudioEngine()`) actually correct?**
  _`AudioEngineService` has 2 INFERRED edges - model-reasoned connections that need verification._
- **Are the 4 inferred relationships involving `ArrangementSection` (e.g. with `.body` and `.body`) actually correct?**
  _`ArrangementSection` has 4 INFERRED edges - model-reasoned connections that need verification._
- **What connects `id`, `name`, `startTime` to the rest of the system?**
  _277 weakly-connected nodes found - possible documentation gaps or missing edges._