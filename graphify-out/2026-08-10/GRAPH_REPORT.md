# Graph Report - SimplePlay  (2026-08-10)

## Corpus Check
- 92 files · ~46,432 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 1543 nodes · 3613 edges · 89 communities (83 shown, 6 thin omitted)
- Extraction: 90% EXTRACTED · 10% INFERRED · 0% AMBIGUOUS · INFERRED: 352 edges (avg confidence: 0.8)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `eb654725`
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
- AudioTrack
- TimelineWorkspacePanel
- TransportBarView
- AudioImportService
- AudioEngineService
- StandardTrackRole
- String
- SimplePlayProjectArchive
- MIDIMappingBarView
- ProjectPersistenceService
- TrackGroup
- .applyImportedStems
- .frames
- Sendable
- CodingKeys
- ContentView
- TrackOrganizationService
- AudioSampleRate
- .attachClip
- MixerPanelView
- SupportedAudioFormats
- .snap
- AudioOutputDevice
- Testing
- MacWindowTitleBarHidden.swift
- .log
- SectionLoopContext
- Float
- TimeInterval
- .peaks
- TrackWaveformProgressBar
- FaderMeterStripView
- MIDIInputService
- PitchShiftSettings
- .loadBucket
- .presentImportPanel
- AudioEngineError
- WorkspaceViewModel
- .buildArchivePayload
- DAWVerticalFaderView
- TrackPitchControlView
- ProjectPersistenceError
- ImportDocumentPickerSession
- .sectionDragGesture
- UIKitToolbarMenuButtonRepresentable
- DAWProject
- View
- TopToolbarView.swift
- .body
- AudioDropTargetModifier
- SimplePlayProjectFileDocument
- TopToolbarView
- MIDILearnTarget
- .format
- UUID
- MIDINoteAssignment
- WorkspaceView
- DropURLLoader
- SectionPlaybackStatus
- .hex
- SidebarPanel
- DAWSecondaryButtonStyle
- CGFloat
- AppKit
- AudioClip
- .groupVolumeBinding
- TrackControlButton
- .stem
- DAWProject
- TrackHeaderRowView
- UniformTypeIdentifiers
- .groupMasterStrip
- .setSelectedTrackPitch
- SectionMappingCardGlow

## God Nodes (most connected - your core abstractions)
1. `WorkspaceViewModel` - 231 edges
2. `AudioEngineService` - 67 edges
3. `ArrangementSection` - 59 edges
4. `DAWTheme` - 44 edges
5. `AudioTrack` - 42 edges
6. `MIDIMappingBarView` - 42 edges
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
- `.sectionEdgeGuides` --calls--> `SectionEdgeGuideOverlay`  [INFERRED]
  SimplePlay/Features/Workspace/Views/TimelineWorkspacePanel.swift → SimplePlay/Features/Workspace/Views/SectionMarkerLaneView.swift
- `.body` --calls--> `WorkspaceView`  [INFERRED]
  SimplePlay/ContentView.swift → SimplePlay/Features/Workspace/Views/WorkspaceView.swift

## Import Cycles
- None detected.

## Communities (89 total, 6 thin omitted)

### Community 0 - "SimplePlayUITests"
Cohesion: 0.15
Nodes (6): SimplePlayUITests, SimplePlayUITestsLaunchTests, .runsForEachTargetApplicationUIConfiguration, Bool, XCTest, XCTestCase

### Community 1 - "SectionMarkerChipView"
Cohesion: 0.12
Nodes (27): NSCursor, ResizeEdge, end, start, SectionCreationPreviewView, .body, SectionDragSession, SectionEdgeGuideOverlay (+19 more)

### Community 2 - "PropertiesSidebarView"
Cohesion: 0.13
Nodes (16): PropertiesSidebarView, .body, .pitchIsOriginal, .pitchLabel, .sectionCreationHint, .selectedDevice, .selectedDeviceID, .selectedSection (+8 more)

### Community 3 - "What You Must Do When Invoked"
Cohesion: 0.08
Nodes (24): For /graphify add and --watch, For /graphify query, For the commit hook and native AGENTS.md integration, For --update and --cluster-only, /graphify, Honesty Rules, Interpreter guard for subcommands, Part A - Structural extraction for code files (+16 more)

### Community 4 - "TrackLaneView"
Cohesion: 0.09
Nodes (26): G, GraphicsContext, Path, CGFloat, String, TimeInterval, TimelineRulerScale, ClipDragInteractionModifier (+18 more)

### Community 5 - "graphify reference: extra exports and benchmark"
Cohesion: 0.22
Nodes (8): graphify reference: extra exports and benchmark, Step 6b - Wiki (only if --wiki flag), Step 7 - Neo4j export (only if --neo4j or --neo4j-push flag), Step 7a - FalkorDB export (only if --falkordb or --falkordb-push flag), Step 7b - SVG export (only if --svg flag), Step 7c - GraphML export (only if --graphml flag), Step 7d - MCP server (only if --mcp flag), Step 8 - Token reduction benchmark (only if total_words > 5000)

### Community 6 - "Foundation"
Cohesion: 0.13
Nodes (7): AVFoundation, CoreAudio, Foundation, Observation, os, SnapGrid, SwiftUI

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

### Community 15 - "AudioTrack"
Cohesion: 0.16
Nodes (15): AudioTrack, .color, .displayName, Bool, Double, StandardTrackRole, String, UUID (+7 more)

### Community 16 - "TimelineWorkspacePanel"
Cohesion: 0.10
Nodes (28): PlayheadView, .body, .playheadDragGesture, Bool, CGFloat, Content, Double, Gesture (+20 more)

### Community 17 - "TransportBarView"
Cohesion: 0.06
Nodes (39): Bool, CGFloat, CGSize, ClosedRange, Gesture, TimeInterval, TimelineOverviewBar, .barHeight (+31 more)

### Community 18 - "AudioImportService"
Cohesion: 0.08
Nodes (26): LocalizedError, AudioFileStorageService, String, URL, UUID, AudioImportError, emptySelection, .errorDescription (+18 more)

### Community 19 - "AudioEngineService"
Cohesion: 0.12
Nodes (11): AVAudioNode, AVAudioPlayerNode, AVAudioUnitEQ, AudioEngineService, .isPlaybackGraphReady, .isSectionLoopPlaybackActive, .masterVolume, .playbackGraphIsHealthy (+3 more)

### Community 20 - "StandardTrackRole"
Cohesion: 0.06
Nodes (36): CaseIterable, SectionPlaybackMode, continueTimeline, continueToNext, .displayName, .id, oneShot, repeatSection (+28 more)

### Community 21 - "String"
Cohesion: 0.30
Nodes (4): Error, Result, String, URL

### Community 22 - "SimplePlayProjectArchive"
Cohesion: 0.16
Nodes (15): Asset, SimplePlayProjectArchive, SimplePlayProjectArchiveError, corruptAsset, corruptManifest, .errorDescription, invalidArchive, Bool (+7 more)

### Community 23 - "MIDIMappingBarView"
Cohesion: 0.14
Nodes (15): Animation, AnyTransition, MIDIMappingBarView, .collapsedBar, .devicePickerLabel, .devicePickerTitle, .devicePickerTitleColor, .expandedPanel (+7 more)

### Community 24 - "ProjectPersistenceService"
Cohesion: 0.28
Nodes (6): unsupportedVersion, ProjectPersistenceService, Bool, DAWProject, URL, UUID

### Community 25 - "TrackGroup"
Cohesion: 0.14
Nodes (16): CodingKey, Date, Encoder, CodingKeys, horizontalOffset, id, importedAt, name (+8 more)

### Community 26 - ".applyImportedStems"
Cohesion: 0.18
Nodes (4): Content, View, .transportControls, Timer

### Community 27 - ".frames"
Cohesion: 0.30
Nodes (6): Bool, Double, Int64, TimeInterval, TimelineSampleGrid, TimelineSampleGridTests

### Community 28 - "Sendable"
Cohesion: 0.20
Nodes (23): Codable, Equatable, Sendable, PersistedClip, PersistedProject, PersistedTrack, SavedProjectDocument, Bool (+15 more)

### Community 29 - "CodingKeys"
Cohesion: 0.07
Nodes (31): CodingKeys, audioSettings, colorHex, id, isLocked, isMuted, isSnapEnabled, isSolo (+23 more)

### Community 30 - "ContentView"
Cohesion: 0.18
Nodes (9): Commands, ContentView, .body, FileCommands, TransportCommands, .body, View, WorkspaceKeyboardShortcuts (+1 more)

### Community 31 - "TrackOrganizationService"
Cohesion: 0.28
Nodes (10): ImportedStem, ImportPlacement, appendNewGroup, insertIntoGroup, DAWProject, Int, String, TimeInterval (+2 more)

### Community 32 - "AudioSampleRate"
Cohesion: 0.23
Nodes (11): Double, Identifiable, AudioSampleRate, .displayName, .id, rate44100, rate48000, AudioSettings (+3 more)

### Community 33 - ".attachClip"
Cohesion: 0.24
Nodes (5): AVAudioFile, ScheduledClip, AVAudioUnitTimePitch, DAWProject, UInt32

### Community 34 - "MixerPanelView"
Cohesion: 0.12
Nodes (18): MixerPanelView, .body, .channelFaderHeight, .channelFaderWidth, .channelStripWidth, .isCompact, .masterFaderHeight, .mixerHandle (+10 more)

### Community 35 - "SupportedAudioFormats"
Cohesion: 0.31
Nodes (9): UTType, SupportedAudioFormats, .contentTypes, .dropTypes, .filePickerTypes, .folderPickerTypes, .importPickerTypes, Set (+1 more)

### Community 37 - "AudioOutputDevice"
Cohesion: 0.24
Nodes (8): AudioDeviceID, Hashable, AudioOutputDevice, AudioDeviceService, Bool, Int, String, .audioSettings

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
Cohesion: 0.20
Nodes (11): AVAudioTime, SectionLoopContext, .duration, TimeInterval, UUID, AVAudioFrameCount, Bool, Int (+3 more)

### Community 42 - "Float"
Cohesion: 0.21
Nodes (5): AVAudioMixerNode, AVAudioPCMBuffer, Float, UUID, Void

### Community 43 - "TimeInterval"
Cohesion: 0.16
Nodes (6): SectionEdgeGuides, Bool, ClosedRange, TimeInterval, UInt8, .activeSectionEdgeGuides

### Community 44 - ".peaks"
Cohesion: 0.10
Nodes (29): CheckedContinuation, Never, clips, Double, Float, Int, MainActor, Sendable (+21 more)

### Community 45 - "TrackWaveformProgressBar"
Cohesion: 0.40
Nodes (4): Bool, Double, TrackWaveformProgressBar, .body

### Community 46 - "FaderMeterStripView"
Cohesion: 0.15
Nodes (12): .projectMasterStrip, .mainVolumeControl, FaderMeterStripView, .reservesThumbClearance, .showsUnityMark, .usesUnityCenterDecibelScale, Bool, CGFloat (+4 more)

### Community 47 - "MIDIInputService"
Cohesion: 0.08
Nodes (23): CoreMIDI, MIDINotifyProc, MIDIPacket, MIDIPacketList, MIDIInputEvent, MIDIInputService, MIDISourceInfo, .id (+15 more)

### Community 48 - "PitchShiftSettings"
Cohesion: 0.31
Nodes (5): PitchShiftSettings, AVAudioUnitTimePitch, Double, Float, PitchShiftSettingsTests

### Community 49 - ".loadBucket"
Cohesion: 0.31
Nodes (5): CoreGraphics, CGFloat, Int, WaveformLOD, .requiredLOD

### Community 50 - ".presentImportPanel"
Cohesion: 0.33
Nodes (5): ImportPanelKind, audioFiles, folder, .importMenuItems, .body

### Community 51 - "AudioEngineError"
Cohesion: 0.29
Nodes (7): AudioEngineError, clipLoadFailed, deviceSelectionFailed, engineStartFailed, .errorDescription, noPlayableClips, playbackUnavailable

### Community 52 - "WorkspaceViewModel"
Cohesion: 0.07
Nodes (20): Int, Set, WorkspaceViewModel, .activePitchTrack, .activePlaybackSection, .canSaveDirectlyToCurrentURL, .isArrangementSectionControllingPlayback, .isMIDILearnActive (+12 more)

### Community 53 - ".buildArchivePayload"
Cohesion: 0.23
Nodes (5): Data, ProjectFilePanel, String, URL, .body

### Community 54 - "DAWVerticalFaderView"
Cohesion: 0.09
Nodes (25): ClosedRange, Double, Float, String, TrackVolumeSettings, .trackRange, DAWVerticalFaderView, .body (+17 more)

### Community 55 - "TrackPitchControlView"
Cohesion: 0.16
Nodes (13): .actionButtons, Binding, Bool, Double, String, UUID, TrackPitchControlView, .menuTitle (+5 more)

### Community 56 - "ProjectPersistenceError"
Cohesion: 0.17
Nodes (11): JSONDecoder, .projectDecoder, JSONEncoder, .pretty, ProjectPersistenceError, .errorDescription, invalidPackage, missingAudioFile (+3 more)

### Community 57 - "ImportDocumentPickerSession"
Cohesion: 0.25
Nodes (8): ImportDocumentPickerPresenter, ImportDocumentPickerSession, Bool, URL, Void, UIDocumentPickerDelegate, UIDocumentPickerViewController, UIViewController

### Community 58 - ".sectionDragGesture"
Cohesion: 0.24
Nodes (5): SectionDragKind, move, resizeEnd, resizeStart, Gesture

### Community 59 - "UIKitToolbarMenuButtonRepresentable"
Cohesion: 0.33
Nodes (7): Coordinator, Context, String, Void, UIKitToolbarMenuButtonRepresentable, UIButton, UIViewRepresentable

### Community 60 - "DAWProject"
Cohesion: 0.31
Nodes (9): DAWProject, .duration, Bool, Double, Int32, String, TimeInterval, UInt8 (+1 more)

### Community 61 - "View"
Cohesion: 0.15
Nodes (14): .groupDivider, Configuration, AudioDropOverlay, .body, String, TimelineEmptyDropHint, .body, DAWTheme (+6 more)

### Community 62 - "TopToolbarView.swift"
Cohesion: 0.17
Nodes (10): ButtonStyle, SectionMappingAssignButtonStyle, SectionMappingPlayButtonStyle, Configuration, DAWIconToolbarButtonStyle, DAWLabeledToolbarButtonStyle, DAWPrimaryButtonStyle, Content (+2 more)

### Community 63 - ".body"
Cohesion: 0.17
Nodes (9): DAWProject, Binding, Bool, String, WorkspaceSettingsView, .body, .deleteSectionDialogTitle, .sectionDeletionDialogBinding (+1 more)

### Community 64 - "AudioDropTargetModifier"
Cohesion: 0.27
Nodes (7): AudioDropTargetModifier, Content, NSItemProvider, String, TimeInterval, View, View

### Community 65 - "SimplePlayProjectFileDocument"
Cohesion: 0.22
Nodes (7): FileDocument, FileWrapper, ReadConfiguration, SimplePlayProjectFileDocument, .readableContentTypes, Data, WriteConfiguration

### Community 66 - "TopToolbarView"
Cohesion: 0.17
Nodes (16): Bool, String, Void, ToolbarMenuButtonStyleModifier, TopToolbarView, .importButton, .isCompact, .openButton (+8 more)

### Community 67 - "MIDILearnTarget"
Cohesion: 0.40
Nodes (4): MIDILearnTarget, loopToggle, section, UUID

### Community 68 - ".format"
Cohesion: 0.20
Nodes (8): Bool, String, TimeInterval, TimeFormatting, .formattedCurrentTime, .formattedDuration, .selectionInfo, .body

### Community 69 - "UUID"
Cohesion: 0.29
Nodes (4): Double, UUID, .mixerScrollWithPinnedMasters, .body

### Community 70 - "MIDINoteAssignment"
Cohesion: 0.38
Nodes (6): MIDINoteAssignment, .displayName, Bool, String, UInt8, .loopAssignmentLabel

### Community 71 - "WorkspaceView"
Cohesion: 0.29
Nodes (7): Binding, Bool, String, WorkspaceView, .deleteSectionDialogTitle, .phoneBottomChrome, .sectionDeletionDialogBinding

### Community 72 - "DropURLLoader"
Cohesion: 0.62
Nodes (4): DropURLLoader, NSItemProvider, String, URL

### Community 73 - "SectionPlaybackStatus"
Cohesion: 0.33
Nodes (5): SectionPlaybackStatus, idle, playing, queued, repeatingAtEnd

### Community 74 - ".hex"
Cohesion: 0.36
Nodes (5): .defaultColor, Int, StandardTrackRole, String, TrackColorPalette

### Community 75 - "SidebarPanel"
Cohesion: 0.29
Nodes (10): .playbackSettings, .sectionEditor, .trackPitch, .volumeControls, SidebarLabeledRow, .body, SidebarPanel, .body (+2 more)

### Community 76 - "DAWSecondaryButtonStyle"
Cohesion: 0.18
Nodes (10): .body, .collapsedBarContent, .learnBanner, .loopMappingCard, .loopQuickButton, .selectedMarkerEditor, .sessionManagement, DAWSecondaryButtonStyle (+2 more)

### Community 77 - "CGFloat"
Cohesion: 0.11
Nodes (12): CGFloat, TimelineScrollAlignment, center, leading, start, TimelineScrollRequest, .minimumTimelineZoom, .timelineContentWidth (+4 more)

### Community 78 - "AppKit"
Cohesion: 0.22
Nodes (6): App, AppKit, Scene, SimplePlayApp, ResizablePropertiesSidebar, .body

### Community 79 - "AudioClip"
Cohesion: 0.36
Nodes (7): AudioClip, .endTime, Int, String, TimeInterval, URL, UUID

### Community 80 - ".groupVolumeBinding"
Cohesion: 0.31
Nodes (5): .masterVolumeBinding, Binding, Double, UUID, .masterVolumeBinding

### Community 81 - "TrackControlButton"
Cohesion: 0.22
Nodes (8): PanKnobView, .body, Bool, Double, String, Void, TrackControlButton, .body

### Community 82 - ".stem"
Cohesion: 0.36
Nodes (3): String, TimeInterval, TrackOrganizationServiceTests

### Community 83 - "DAWProject"
Cohesion: 0.43
Nodes (4): groups, DAWProject, Int, UUID

### Community 84 - "TrackHeaderRowView"
Cohesion: 0.33
Nodes (7): Binding, Double, TrackHeaderRowView, .displayColor, .liveTrack, .trackPan, .trackVolumeBinding

### Community 86 - ".groupMasterStrip"
Cohesion: 0.33
Nodes (3): Float, .mastersStripRow, String

### Community 88 - "SectionMappingCardGlow"
Cohesion: 0.50
Nodes (3): SectionMappingCardGlow, Content, ViewModifier

## Knowledge Gaps
- **273 isolated node(s):** `id`, `name`, `startTime`, `endTime`, `colorHex` (+268 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **6 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `WorkspaceViewModel` connect `WorkspaceViewModel` to `SectionMarkerChipView`, `PropertiesSidebarView`, `TrackLaneView`, `Foundation`, `ArrangementSection`, `AudioTrack`, `TimelineWorkspacePanel`, `TransportBarView`, `AudioImportService`, `AudioEngineService`, `StandardTrackRole`, `String`, `MIDIMappingBarView`, `ProjectPersistenceService`, `.applyImportedStems`, `.frames`, `ContentView`, `TrackOrganizationService`, `.attachClip`, `MixerPanelView`, `.snap`, `AudioOutputDevice`, `TimeInterval`, `MIDIInputService`, `.presentImportPanel`, `.buildArchivePayload`, `TrackPitchControlView`, `.sectionDragGesture`, `View`, `.body`, `AudioDropTargetModifier`, `SimplePlayProjectFileDocument`, `TopToolbarView`, `MIDILearnTarget`, `.format`, `UUID`, `WorkspaceView`, `SectionPlaybackStatus`, `DAWSecondaryButtonStyle`, `CGFloat`, `AppKit`, `.groupVolumeBinding`, `TrackHeaderRowView`, `.groupMasterStrip`, `.setSelectedTrackPitch`?**
  _High betweenness centrality (0.452) - this node is a cross-community bridge._
- **Why does `ArrangementSection` connect `ArrangementSection` to `SectionMarkerChipView`, `PropertiesSidebarView`, `Foundation`, `AudioTrack`, `StandardTrackRole`, `MIDIMappingBarView`, `.applyImportedStems`, `.frames`, `Sendable`, `CodingKeys`, `AudioSampleRate`, `TimeInterval`, `MIDIInputService`, `WorkspaceViewModel`, `DAWProject`, `View`, `.format`, `SectionPlaybackStatus`, `CGFloat`?**
  _High betweenness centrality (0.104) - this node is a cross-community bridge._
- **Why does `AudioEngineService` connect `AudioEngineService` to `.attachClip`, `UUID`, `Foundation`, `SectionLoopContext`, `Float`, `WorkspaceViewModel`, `.applyImportedStems`?**
  _High betweenness centrality (0.089) - this node is a cross-community bridge._
- **Are the 12 inferred relationships involving `WorkspaceViewModel` (e.g. with `ArrangementPlaybackEngine` and `AudioEngineService`) actually correct?**
  _`WorkspaceViewModel` has 12 INFERRED edges - model-reasoned connections that need verification._
- **Are the 2 inferred relationships involving `AudioEngineService` (e.g. with `WorkspaceViewModel` and `.configureAudioEngine()`) actually correct?**
  _`AudioEngineService` has 2 INFERRED edges - model-reasoned connections that need verification._
- **Are the 4 inferred relationships involving `ArrangementSection` (e.g. with `.body` and `.body`) actually correct?**
  _`ArrangementSection` has 4 INFERRED edges - model-reasoned connections that need verification._
- **What connects `id`, `name`, `startTime` to the rest of the system?**
  _273 weakly-connected nodes found - possible documentation gaps or missing edges._