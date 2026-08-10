# Graph Report - SimplePlay  (2026-08-10)

## Corpus Check
- 92 files · ~46,525 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 1568 nodes · 3612 edges · 90 communities (77 shown, 13 thin omitted)
- Extraction: 90% EXTRACTED · 10% INFERRED · 0% AMBIGUOUS · INFERRED: 352 edges (avg confidence: 0.8)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `2783f10a`
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
- MixerPanelView
- TimelineWorkspacePanel
- TransportBarView
- AudioImportService
- .isNodeConnected
- StandardTrackRole
- .applyImportedStems
- ProjectPersistenceService
- MIDIMappingBarView
- TimeInterval
- TrackGroup
- WorkspaceViewModel
- .frames
- PersistedProject
- CodingKeys
- ContentView
- AudioTrack
- AudioSampleRate
- .attachClip
- UUID
- SupportedAudioFormats
- TimelineOverviewBar
- AudioDeviceService
- Testing
- AppKit
- .log
- SectionLoopContext
- AudioEngineService
- .seek
- .peaks
- TrackWaveformProgressBar
- .standardize
- MIDIInputService
- FaderMeterStripView
- .loadBucket
- .snap
- AudioEngineError
- .addSection
- TrackMeterIndicatorView
- DAWVerticalFaderView
- TrackPitchControlView
- AVFoundation
- ImportDocumentPickerSession
- SectionPlaybackMode
- UIKitToolbarMenuButtonRepresentable
- DAWProject
- DAWTheme
- .loopMappingCard
- WorkspaceSettingsView
- AudioDropTargetModifier
- SimplePlayProjectFileDocument
- View
- AudioClip
- .format
- .setZoom
- Sendable
- AudioDropOverlay
- DropURLLoader
- .groupVolumeBinding
- WorkspaceView
- SidebarPanel
- .sessionManagement
- CGFloat
- .body
- TransportBarStyle
- AVAudioUnitTimePitch
- TrackControlButton
- UInt32
- UInt64
- Set
- UniformTypeIdentifiers
- UInt8
- URL
- Configuration
- CGSize

## God Nodes (most connected - your core abstractions)
1. `WorkspaceViewModel` - 231 edges
2. `AudioEngineService` - 67 edges
3. `ArrangementSection` - 48 edges
4. `DAWTheme` - 43 edges
5. `MIDIMappingBarView` - 41 edges
6. `AudioTrack` - 40 edges
7. `ArrangementPlaybackEngine` - 36 edges
8. `TimelineWorkspacePanel` - 35 edges
9. `MixerPanelView` - 35 edges
10. `StandardTrackRole` - 31 edges

## Surprising Connections (you probably didn't know these)
- `.selectedDevice` --references--> `WorkspaceViewModel`  [INFERRED]
  SimplePlay/Features/Workspace/Views/PropertiesSidebarView.swift → SimplePlay/Features/Workspace/ViewModels/WorkspaceViewModel.swift
- `.duration` --references--> `AudioTrack`  [INFERRED]
  SimplePlay/Core/Models/DAWProject.swift → SimplePlay/Core/Models/AudioTrack.swift
- `WorkspaceViewModel` --calls--> `AudioEngineService`  [INFERRED]
  SimplePlay/Features/Workspace/ViewModels/WorkspaceViewModel.swift → SimplePlay/Core/Services/AudioEngineService.swift
- `WorkspaceViewModel` --calls--> `ArrangementPlaybackEngine`  [INFERRED]
  SimplePlay/Features/Workspace/ViewModels/WorkspaceViewModel.swift → SimplePlay/Core/Services/ArrangementPlaybackEngine.swift
- `WorkspaceViewModel` --calls--> `AudioImportService`  [INFERRED]
  SimplePlay/Features/Workspace/ViewModels/WorkspaceViewModel.swift → SimplePlay/Core/Services/AudioImportService.swift

## Import Cycles
- None detected.

## Communities (90 total, 13 thin omitted)

### Community 0 - "SimplePlayUITests"
Cohesion: 0.15
Nodes (6): SimplePlayUITests, SimplePlayUITestsLaunchTests, .runsForEachTargetApplicationUIConfiguration, Bool, XCTest, XCTestCase

### Community 1 - "SectionMarkerChipView"
Cohesion: 0.11
Nodes (29): NSCursor, ResizeEdge, end, start, SectionCreationPreviewView, .body, SectionDragSession, SectionEdgeGuideOverlay (+21 more)

### Community 2 - "PropertiesSidebarView"
Cohesion: 0.13
Nodes (17): PropertiesSidebarView, .body, .masterVolumeBinding, .pitchIsOriginal, .pitchLabel, .sectionCreationHint, .selectedDevice, .selectedDeviceID (+9 more)

### Community 3 - "What You Must Do When Invoked"
Cohesion: 0.08
Nodes (24): For /graphify add and --watch, For /graphify query, For the commit hook and native AGENTS.md integration, For --update and --cluster-only, /graphify, Honesty Rules, Interpreter guard for subcommands, Part A - Structural extraction for code files (+16 more)

### Community 4 - "TrackLaneView"
Cohesion: 0.09
Nodes (25): G, GraphicsContext, CGFloat, String, TimeInterval, TimelineRulerScale, ClipDragInteractionModifier, ClipSelectionModifiers (+17 more)

### Community 5 - "graphify reference: extra exports and benchmark"
Cohesion: 0.22
Nodes (8): graphify reference: extra exports and benchmark, Step 6b - Wiki (only if --wiki flag), Step 7 - Neo4j export (only if --neo4j or --neo4j-push flag), Step 7a - FalkorDB export (only if --falkordb or --falkordb-push flag), Step 7b - SVG export (only if --svg flag), Step 7c - GraphML export (only if --graphml flag), Step 7d - MCP server (only if --mcp flag), Step 8 - Token reduction benchmark (only if total_words > 5000)

### Community 6 - "Foundation"
Cohesion: 0.17
Nodes (4): Foundation, Observation, SnapGrid, SwiftUI

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
Nodes (47): ArrangementSection, .color, .duration, CodingKeys, colorHex, endTime, id, midiChannel (+39 more)

### Community 15 - "MixerPanelView"
Cohesion: 0.10
Nodes (20): MixerPanelView, .body, .channelFaderHeight, .channelFaderWidth, .channelStripWidth, .groupDivider, .isCompact, .masterFaderHeight (+12 more)

### Community 16 - "TimelineWorkspacePanel"
Cohesion: 0.13
Nodes (23): PlayheadView, .body, .playheadDragGesture, CGFloat, Double, Gesture, String, TimeInterval (+15 more)

### Community 17 - "TransportBarView"
Cohesion: 0.12
Nodes (18): Binding, Bool, CGFloat, Double, String, Void, TransportBarView, .body (+10 more)

### Community 18 - "AudioImportService"
Cohesion: 0.11
Nodes (20): AVAudioFile, LocalizedError, AudioFileStorageService, String, URL, UUID, AudioImportError, emptySelection (+12 more)

### Community 20 - "StandardTrackRole"
Cohesion: 0.08
Nodes (24): StandardTrackRole, acousticGuitar, backingVocal, bass, brass, click, countIn, cue (+16 more)

### Community 21 - ".applyImportedStems"
Cohesion: 0.17
Nodes (9): Error, Result, ImportPanelKind, audioFiles, folder, String, .body, TrackOrganizationService (+1 more)

### Community 22 - "ProjectPersistenceService"
Cohesion: 0.06
Nodes (39): SavedProjectDocument, JSONDecoder, .projectDecoder, JSONEncoder, .pretty, ProjectPersistenceError, .errorDescription, invalidPackage (+31 more)

### Community 23 - "MIDIMappingBarView"
Cohesion: 0.12
Nodes (21): Animation, AnyTransition, Color, MIDINoteAssignment, MIDIMappingBarView, .body, .collapsedBar, .collapsedBarContent (+13 more)

### Community 24 - "TimeInterval"
Cohesion: 0.26
Nodes (5): SectionEdgeGuides, Bool, ClosedRange, TimeInterval, .activeSectionEdgeGuides

### Community 25 - "TrackGroup"
Cohesion: 0.14
Nodes (16): CodingKey, Date, Encoder, CodingKeys, horizontalOffset, id, importedAt, name (+8 more)

### Community 26 - "WorkspaceViewModel"
Cohesion: 0.07
Nodes (23): AudioOutputDevice, MIDIInputEvent, MIDILearnTarget, Set, DAWProject, WorkspaceViewModel, .activePitchTrack, .activePlaybackSection (+15 more)

### Community 27 - ".frames"
Cohesion: 0.32
Nodes (6): Bool, Double, Int64, TimeInterval, TimelineSampleGrid, TimelineSampleGridTests

### Community 28 - "PersistedProject"
Cohesion: 0.25
Nodes (18): Codable, PersistedClip, PersistedProject, PersistedTrack, SavedProjectDocument, Bool, DAWProject, Decoder (+10 more)

### Community 29 - "CodingKeys"
Cohesion: 0.06
Nodes (33): CodingKeys, audioSettings, colorHex, groups, id, isLocked, isMuted, isSnapEnabled (+25 more)

### Community 30 - "ContentView"
Cohesion: 0.18
Nodes (9): Commands, ContentView, .body, FileCommands, TransportCommands, .body, View, WorkspaceKeyboardShortcuts (+1 more)

### Community 31 - "AudioTrack"
Cohesion: 0.07
Nodes (40): AudioTrack, .color, .displayName, Bool, Double, StandardTrackRole, String, UUID (+32 more)

### Community 32 - "AudioSampleRate"
Cohesion: 0.19
Nodes (15): Double, Hashable, Identifiable, AudioOutputDevice, AudioSampleRate, .displayName, .id, rate44100 (+7 more)

### Community 33 - ".attachClip"
Cohesion: 0.21
Nodes (8): AudioSampleRate, AudioSettings, AVAudioPlayerNode, AVAudioUnitTimePitch, ScheduledClip, AudioClip, DAWProject, UInt32

### Community 34 - "UUID"
Cohesion: 0.16
Nodes (8): AudioTrack, Double, Float, UUID, .mixerScrollWithPinnedMasters, .selectedTrackPitchBinding, .body, .body

### Community 35 - "SupportedAudioFormats"
Cohesion: 0.31
Nodes (9): UTType, SupportedAudioFormats, .contentTypes, .dropTypes, .filePickerTypes, .folderPickerTypes, .importPickerTypes, Set (+1 more)

### Community 36 - "TimelineOverviewBar"
Cohesion: 0.16
Nodes (15): CGSize, Bool, CGFloat, ClosedRange, Gesture, TimeInterval, TimelineOverviewBar, .barHeight (+7 more)

### Community 37 - "AudioDeviceService"
Cohesion: 0.26
Nodes (6): AudioDeviceID, AudioDeviceService, Bool, Int, String, .audioSettings

### Community 38 - "Testing"
Cohesion: 0.23
Nodes (4): SimplePlay, ProjectArchiveTests, SimplePlayTests, Testing

### Community 39 - "AppKit"
Cohesion: 0.08
Nodes (21): App, AppKit, Notification, NSApplicationDelegate, NSEvent, NSObject, NSView, NSViewRepresentable (+13 more)

### Community 40 - ".log"
Cohesion: 0.38
Nodes (6): SectionLoopDiagnostics, AVAudioFrameCount, Double, Int64, String, TimeInterval

### Community 41 - "SectionLoopContext"
Cohesion: 0.18
Nodes (12): AVAudioTime, SectionLoopContext, .duration, TimeInterval, UUID, AVAudioFrameCount, Bool, Int (+4 more)

### Community 42 - "AudioEngineService"
Cohesion: 0.14
Nodes (11): AVAudioMixerNode, AVAudioUnitEQ, AudioEngineService, .isPlaybackGraphReady, .isSectionLoopPlaybackActive, .masterVolume, .primaryClipSampleRate, Double (+3 more)

### Community 43 - ".seek"
Cohesion: 0.12
Nodes (8): Content, View, TimelineScrollAlignment, center, leading, start, .transportControls, Timer

### Community 44 - ".peaks"
Cohesion: 0.09
Nodes (31): AVAudioPCMBuffer, CheckedContinuation, Never, Path, clips, Double, Float, Int (+23 more)

### Community 45 - "TrackWaveformProgressBar"
Cohesion: 0.40
Nodes (4): Bool, Double, TrackWaveformProgressBar, .body

### Community 46 - ".standardize"
Cohesion: 0.23
Nodes (7): StandardizedName, Bool, StandardTrackRole, String, URL, TrackNameStandardizer, TrackNameStandardizerTests

### Community 47 - "MIDIInputService"
Cohesion: 0.08
Nodes (20): MIDINotifyProc, MIDIPacket, MIDIPacketList, MIDISourceInfo, MIDIInputService, Bool, Int, Int32 (+12 more)

### Community 48 - "FaderMeterStripView"
Cohesion: 0.14
Nodes (13): .projectMasterStrip, .mainVolumeControl, FaderMeterStripView, .body, .reservesThumbClearance, .showsUnityMark, .usesUnityCenterDecibelScale, Bool (+5 more)

### Community 49 - ".loadBucket"
Cohesion: 0.27
Nodes (5): CoreGraphics, CGFloat, Int, WaveformLOD, .requiredLOD

### Community 50 - ".snap"
Cohesion: 0.15
Nodes (6): Bool, TimeInterval, AudioClip, Int, .trackHeaderColumnTracksOnly, .trackLanes

### Community 51 - "AudioEngineError"
Cohesion: 0.29
Nodes (7): AudioEngineError, clipLoadFailed, deviceSelectionFailed, engineStartFailed, .errorDescription, noPlayableClips, playbackUnavailable

### Community 52 - ".addSection"
Cohesion: 0.19
Nodes (3): SectionPlaybackMode, ArrangementSection, .sectionCreationGesture

### Community 53 - "TrackMeterIndicatorView"
Cohesion: 0.28
Nodes (8): Bool, CGFloat, Double, Float, Int, TrackMeterIndicatorView, .body, .litSegmentCount

### Community 54 - "DAWVerticalFaderView"
Cohesion: 0.14
Nodes (16): ClosedRange, Double, Float, String, TrackVolumeSettings, .trackRange, DAWVerticalFaderView, .body (+8 more)

### Community 55 - "TrackPitchControlView"
Cohesion: 0.14
Nodes (14): .actionButtons, Binding, Bool, Double, String, UUID, TrackPitchControlView, .menuTitle (+6 more)

### Community 56 - "AVFoundation"
Cohesion: 0.22
Nodes (4): AVFoundation, CoreAudio, CoreMIDI, os

### Community 57 - "ImportDocumentPickerSession"
Cohesion: 0.25
Nodes (8): ImportDocumentPickerPresenter, ImportDocumentPickerSession, Bool, URL, Void, UIDocumentPickerDelegate, UIDocumentPickerViewController, UIViewController

### Community 58 - "SectionPlaybackMode"
Cohesion: 0.15
Nodes (12): CaseIterable, SectionPlaybackMode, continueTimeline, continueToNext, .displayName, .id, oneShot, repeatSection (+4 more)

### Community 59 - "UIKitToolbarMenuButtonRepresentable"
Cohesion: 0.33
Nodes (7): Coordinator, Context, String, Void, UIKitToolbarMenuButtonRepresentable, UIButton, UIViewRepresentable

### Community 60 - "DAWProject"
Cohesion: 0.31
Nodes (9): DAWProject, .duration, Bool, Double, Int32, String, TimeInterval, UInt8 (+1 more)

### Community 61 - "DAWTheme"
Cohesion: 0.14
Nodes (13): .pinnedMastersColumn, DAWIconToolbarButtonStyle, DAWLabeledToolbarButtonStyle, DAWPrimaryButtonStyle, Configuration, .body, DAWTheme, .isPhone (+5 more)

### Community 62 - ".loopMappingCard"
Cohesion: 0.24
Nodes (7): ButtonStyle, .learnBanner, .loopMappingCard, SectionMappingAssignButtonStyle, SectionMappingCardGlow, SectionMappingPlayButtonStyle, Content

### Community 63 - "WorkspaceSettingsView"
Cohesion: 0.28
Nodes (7): Binding, Bool, String, WorkspaceSettingsView, .body, .deleteSectionDialogTitle, .sectionDeletionDialogBinding

### Community 64 - "AudioDropTargetModifier"
Cohesion: 0.27
Nodes (7): AudioDropTargetModifier, Content, NSItemProvider, String, TimeInterval, View, View

### Community 65 - "SimplePlayProjectFileDocument"
Cohesion: 0.22
Nodes (7): FileDocument, FileWrapper, ReadConfiguration, SimplePlayProjectFileDocument, .readableContentTypes, Data, WriteConfiguration

### Community 66 - "View"
Cohesion: 0.13
Nodes (21): Configuration, Bool, Content, String, Void, ToolbarMenuButtonStyleModifier, TopToolbarView, .importButton (+13 more)

### Community 67 - "AudioClip"
Cohesion: 0.36
Nodes (7): AudioClip, .endTime, Int, String, TimeInterval, URL, UUID

### Community 68 - ".format"
Cohesion: 0.20
Nodes (8): Bool, String, TimeInterval, TimeFormatting, .formattedCurrentTime, .formattedDuration, .selectionInfo, .body

### Community 70 - "Sendable"
Cohesion: 0.12
Nodes (20): Equatable, Sendable, MIDILearnTarget, loopToggle, section, MIDINoteAssignment, .displayName, Bool (+12 more)

### Community 71 - "AudioDropOverlay"
Cohesion: 0.33
Nodes (5): AudioDropOverlay, .body, String, TimelineEmptyDropHint, .body

### Community 72 - "DropURLLoader"
Cohesion: 0.62
Nodes (4): DropURLLoader, NSItemProvider, String, URL

### Community 73 - ".groupVolumeBinding"
Cohesion: 0.36
Nodes (4): .masterVolumeBinding, Binding, Double, UUID

### Community 74 - "WorkspaceView"
Cohesion: 0.29
Nodes (7): Binding, Bool, String, WorkspaceView, .deleteSectionDialogTitle, .phoneBottomChrome, .sectionDeletionDialogBinding

### Community 75 - "SidebarPanel"
Cohesion: 0.24
Nodes (12): .playbackSettings, .sectionEditor, .selectedMarkerEditor, .trackPitch, .volumeControls, DAWSecondaryButtonStyle, SidebarLabeledRow, .body (+4 more)

### Community 76 - ".sessionManagement"
Cohesion: 0.60
Nodes (3): .sessionManagement, .projectSessionMenuItems, .body

### Community 77 - "CGFloat"
Cohesion: 0.14
Nodes (10): SectionDragKind, move, resizeEnd, resizeStart, CGFloat, TimelineScrollRequest, .minimumTimelineZoom, .timelineContentWidth (+2 more)

### Community 78 - ".body"
Cohesion: 0.40
Nodes (3): Content, .masterSectionLaneScroll, .pinnedTimelineHeaders

### Community 79 - "TransportBarStyle"
Cohesion: 0.50
Nodes (3): TransportBarStyle, phoneBottomDock, standard

### Community 81 - "TrackControlButton"
Cohesion: 0.22
Nodes (8): PanKnobView, .body, Bool, Double, String, Void, TrackControlButton, .body

### Community 85 - "UniformTypeIdentifiers"
Cohesion: 0.22
Nodes (5): SimplePlayProjectType, Bool, TimelineAudioDropModifier, UniformTypeIdentifiers, ViewModifier

## Knowledge Gaps
- **273 isolated node(s):** `.duration`, `deviceSelectionFailed`, `engineStartFailed`, `noPlayableClips`, `playbackUnavailable` (+268 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **13 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `WorkspaceViewModel` connect `WorkspaceViewModel` to `SectionMarkerChipView`, `PropertiesSidebarView`, `TrackLaneView`, `Foundation`, `ArrangementSection`, `MixerPanelView`, `TimelineWorkspacePanel`, `TransportBarView`, `AudioImportService`, `.applyImportedStems`, `ProjectPersistenceService`, `MIDIMappingBarView`, `TimeInterval`, `ContentView`, `AudioTrack`, `UUID`, `TimelineOverviewBar`, `AudioDeviceService`, `AppKit`, `AudioEngineService`, `.seek`, `MIDIInputService`, `.snap`, `.addSection`, `TrackPitchControlView`, `.loopMappingCard`, `WorkspaceSettingsView`, `AudioDropTargetModifier`, `View`, `.format`, `.setZoom`, `Sendable`, `.groupVolumeBinding`, `WorkspaceView`, `.sessionManagement`, `CGFloat`, `UniformTypeIdentifiers`?**
  _High betweenness centrality (0.428) - this node is a cross-community bridge._
- **Why does `ArrangementSection` connect `ArrangementSection` to `AudioSampleRate`, `SectionMarkerChipView`, `PropertiesSidebarView`, `UUID`, `.format`, `Sendable`, `Foundation`, `DAWProject`, `MIDIInputService`, `MIDIMappingBarView`, `SectionPlaybackMode`, `PersistedProject`, `AudioTrack`?**
  _High betweenness centrality (0.109) - this node is a cross-community bridge._
- **Why does `AudioEngineService` connect `AudioEngineService` to `.attachClip`, `UUID`, `SectionLoopContext`, `.isNodeConnected`, `AVFoundation`, `TimeInterval`, `WorkspaceViewModel`?**
  _High betweenness centrality (0.091) - this node is a cross-community bridge._
- **Are the 12 inferred relationships involving `WorkspaceViewModel` (e.g. with `ArrangementPlaybackEngine` and `AudioEngineService`) actually correct?**
  _`WorkspaceViewModel` has 12 INFERRED edges - model-reasoned connections that need verification._
- **Are the 2 inferred relationships involving `AudioEngineService` (e.g. with `WorkspaceViewModel` and `.configureAudioEngine()`) actually correct?**
  _`AudioEngineService` has 2 INFERRED edges - model-reasoned connections that need verification._
- **Are the 8 inferred relationships involving `ArrangementSection` (e.g. with `.cardBackground()` and `.sectionPlayAreaBackground()`) actually correct?**
  _`ArrangementSection` has 8 INFERRED edges - model-reasoned connections that need verification._
- **What connects `.duration`, `deviceSelectionFailed`, `engineStartFailed` to the rest of the system?**
  _273 weakly-connected nodes found - possible documentation gaps or missing edges._