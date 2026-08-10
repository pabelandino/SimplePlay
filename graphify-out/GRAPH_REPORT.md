# Graph Report - SimplePlay  (2026-08-10)

## Corpus Check
- 92 files · ~46,525 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 1542 nodes · 3610 edges · 79 communities (71 shown, 8 thin omitted)
- Extraction: 90% EXTRACTED · 10% INFERRED · 0% AMBIGUOUS · INFERRED: 350 edges (avg confidence: 0.8)
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
- .peaks
- TimelineWorkspacePanel
- TransportBarView
- AudioImportService
- AudioEngineService
- StandardTrackRole
- .applyImportedStems
- SimplePlayProjectArchive
- MIDIMappingBarView
- ProjectPersistenceService
- TrackGroup
- .stop
- .frames
- Sendable
- CodingKeys
- FileCommands
- AudioTrack
- Codable
- .attachClip
- MixerPanelView
- SupportedAudioFormats
- TimelineOverviewBar
- AudioOutputDevice
- Testing
- MacWindowTitleBarHidden.swift
- .log
- SectionLoopContext
- Float
- TimeInterval
- WaveformClipView
- SwiftUI
- .standardize
- MIDIInputService
- PitchShiftSettings
- CoreGraphics
- .snap
- AudioEngineError
- TrackHeaderRowView
- .saveProject
- FaderMeterStripView
- TrackPitchControlView
- ProjectPersistenceError
- ImportDocumentPickerSession
- SectionPlaybackMode
- UIKitToolbarMenuButtonRepresentable
- DAWProject
- DAWTheme
- .loopMappingCard
- WorkspaceView
- AudioDropTargetModifier
- SimplePlayProjectFileDocument
- View
- MIDILearnTarget
- .format
- .setZoom
- .sectionMappingCard
- AudioDropOverlay
- DropURLLoader
- WorkspaceKeyboardShortcuts
- SidebarPanel
- DAWSecondaryButtonStyle
- WorkspaceViewModel
- TrackControlButton
- UniformTypeIdentifiers

## God Nodes (most connected - your core abstractions)
1. `WorkspaceViewModel` - 231 edges
2. `AudioEngineService` - 67 edges
3. `ArrangementSection` - 59 edges
4. `DAWTheme` - 43 edges
5. `AudioTrack` - 42 edges
6. `MIDIMappingBarView` - 41 edges
7. `ArrangementPlaybackEngine` - 36 edges
8. `MixerPanelView` - 35 edges
9. `TimelineWorkspacePanel` - 35 edges
10. `StandardTrackRole` - 31 edges

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

## Communities (79 total, 8 thin omitted)

### Community 0 - "SimplePlayUITests"
Cohesion: 0.15
Nodes (6): SimplePlayUITests, SimplePlayUITestsLaunchTests, .runsForEachTargetApplicationUIConfiguration, Bool, XCTest, XCTestCase

### Community 1 - "SectionMarkerChipView"
Cohesion: 0.10
Nodes (30): NSCursor, ResizeEdge, end, start, SectionCreationPreviewView, .body, SectionDragSession, SectionEdgeGuideOverlay (+22 more)

### Community 2 - "PropertiesSidebarView"
Cohesion: 0.15
Nodes (12): PropertiesSidebarView, .body, .pitchIsOriginal, .pitchLabel, .sectionCreationHint, .selectedDevice, .selectedSection, Bool (+4 more)

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
Cohesion: 0.14
Nodes (7): AVFoundation, CoreAudio, Foundation, Observation, os, SnapGrid, TimeFormatting

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

### Community 15 - ".peaks"
Cohesion: 0.25
Nodes (12): CheckedContinuation, Never, Double, Float, Int, MainActor, Sendable, String (+4 more)

### Community 16 - "TimelineWorkspacePanel"
Cohesion: 0.11
Nodes (28): PlayheadView, .body, .playheadDragGesture, Bool, CGFloat, Content, Double, Gesture (+20 more)

### Community 17 - "TransportBarView"
Cohesion: 0.11
Nodes (20): Binding, Bool, CGFloat, Double, String, Void, TransportBarStyle, phoneBottomDock (+12 more)

### Community 18 - "AudioImportService"
Cohesion: 0.12
Nodes (19): LocalizedError, AudioFileStorageService, String, URL, UUID, AudioImportError, emptySelection, .errorDescription (+11 more)

### Community 19 - "AudioEngineService"
Cohesion: 0.12
Nodes (11): AVAudioNode, AVAudioPlayerNode, AVAudioUnitEQ, AudioEngineService, .isPlaybackGraphReady, .isSectionLoopPlaybackActive, .masterVolume, .playbackGraphIsHealthy (+3 more)

### Community 20 - "StandardTrackRole"
Cohesion: 0.08
Nodes (24): StandardTrackRole, acousticGuitar, backingVocal, bass, brass, click, countIn, cue (+16 more)

### Community 21 - ".applyImportedStems"
Cohesion: 0.16
Nodes (6): Error, Result, DAWProject, String, URL, .body

### Community 22 - "SimplePlayProjectArchive"
Cohesion: 0.16
Nodes (15): Asset, SimplePlayProjectArchive, SimplePlayProjectArchiveError, corruptAsset, corruptManifest, .errorDescription, invalidArchive, Bool (+7 more)

### Community 23 - "MIDIMappingBarView"
Cohesion: 0.11
Nodes (19): Animation, AnyTransition, Color, StandardTrackRole, .fallbackColor, MIDIMappingBarView, .body, .collapsedBar (+11 more)

### Community 24 - "ProjectPersistenceService"
Cohesion: 0.19
Nodes (10): SavedProjectDocument, DAWProject, Int, unsupportedVersion, ProjectPersistenceService, Bool, Data, DAWProject (+2 more)

### Community 25 - "TrackGroup"
Cohesion: 0.27
Nodes (8): Date, Encoder, Decoder, Double, String, TimeInterval, UUID, TrackGroup

### Community 27 - ".frames"
Cohesion: 0.30
Nodes (6): Bool, Double, Int64, TimeInterval, TimelineSampleGrid, TimelineSampleGridTests

### Community 28 - "Sendable"
Cohesion: 0.25
Nodes (18): Equatable, Sendable, PersistedClip, PersistedProject, PersistedTrack, Bool, Decoder, Double (+10 more)

### Community 29 - "CodingKeys"
Cohesion: 0.05
Nodes (44): CodingKey, CodingKeys, colorHex, endTime, id, midiChannel, midiNote, midiUsesControlChange (+36 more)

### Community 30 - "FileCommands"
Cohesion: 0.22
Nodes (8): App, Commands, Scene, FileCommands, TransportCommands, .body, SimplePlayApp, .body

### Community 31 - "AudioTrack"
Cohesion: 0.07
Nodes (40): AudioClip, .endTime, Int, String, TimeInterval, URL, UUID, AudioTrack (+32 more)

### Community 32 - "Codable"
Cohesion: 0.24
Nodes (11): Codable, Double, AudioSampleRate, .displayName, .id, rate44100, rate48000, AudioSettings (+3 more)

### Community 33 - ".attachClip"
Cohesion: 0.24
Nodes (5): AVAudioFile, ScheduledClip, AVAudioUnitTimePitch, DAWProject, UInt32

### Community 34 - "MixerPanelView"
Cohesion: 0.06
Nodes (35): Double, Float, UUID, MixerPanelView, .body, .channelFaderHeight, .channelFaderWidth, .channelStripWidth (+27 more)

### Community 35 - "SupportedAudioFormats"
Cohesion: 0.31
Nodes (9): UTType, SupportedAudioFormats, .contentTypes, .dropTypes, .filePickerTypes, .folderPickerTypes, .importPickerTypes, Set (+1 more)

### Community 36 - "TimelineOverviewBar"
Cohesion: 0.16
Nodes (15): Bool, CGFloat, CGSize, ClosedRange, Gesture, TimeInterval, TimelineOverviewBar, .barHeight (+7 more)

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
Cohesion: 0.14
Nodes (11): SectionEdgeGuides, Bool, TimeInterval, UInt8, TimelineScrollAlignment, center, leading, start (+3 more)

### Community 44 - "WaveformClipView"
Cohesion: 0.12
Nodes (21): clips, Bool, Double, UUID, WaveformLoadMonitor, CGFloat, Int, WaveformLOD (+13 more)

### Community 45 - "SwiftUI"
Cohesion: 0.15
Nodes (7): ResizablePropertiesSidebar, .body, Bool, Double, TrackWaveformProgressBar, .body, SwiftUI

### Community 46 - ".standardize"
Cohesion: 0.23
Nodes (7): StandardizedName, Bool, StandardTrackRole, String, URL, TrackNameStandardizer, TrackNameStandardizerTests

### Community 47 - "MIDIInputService"
Cohesion: 0.07
Nodes (23): CoreMIDI, MIDINotifyProc, MIDIPacket, MIDIPacketList, MIDIInputEvent, MIDIInputService, MIDISourceInfo, .id (+15 more)

### Community 48 - "PitchShiftSettings"
Cohesion: 0.31
Nodes (5): PitchShiftSettings, AVAudioUnitTimePitch, Double, Float, PitchShiftSettingsTests

### Community 50 - ".snap"
Cohesion: 0.15
Nodes (6): Bool, TimeInterval, ImportPanelKind, audioFiles, folder, .importMenuItems

### Community 51 - "AudioEngineError"
Cohesion: 0.29
Nodes (7): AudioEngineError, clipLoadFailed, deviceSelectionFailed, engineStartFailed, .errorDescription, noPlayableClips, playbackUnavailable

### Community 52 - "TrackHeaderRowView"
Cohesion: 0.12
Nodes (12): Int, .trackHeaderColumnTracksOnly, .trackLanes, Binding, Double, TrackHeaderRowView, .displayColor, .liveTrack (+4 more)

### Community 53 - ".saveProject"
Cohesion: 0.25
Nodes (4): ProjectFilePanel, String, URL, .body

### Community 54 - "FaderMeterStripView"
Cohesion: 0.06
Nodes (37): ClosedRange, Double, Float, String, TrackVolumeSettings, .trackRange, .projectMasterStrip, .mainVolumeControl (+29 more)

### Community 55 - "TrackPitchControlView"
Cohesion: 0.14
Nodes (14): .actionButtons, Binding, Bool, Double, String, UUID, TrackPitchControlView, .menuTitle (+6 more)

### Community 56 - "ProjectPersistenceError"
Cohesion: 0.17
Nodes (12): JSONDecoder, .projectDecoder, JSONEncoder, .pretty, ManifestFile, ProjectPersistenceError, .errorDescription, invalidPackage (+4 more)

### Community 57 - "ImportDocumentPickerSession"
Cohesion: 0.25
Nodes (8): ImportDocumentPickerPresenter, ImportDocumentPickerSession, Bool, URL, Void, UIDocumentPickerDelegate, UIDocumentPickerViewController, UIViewController

### Community 58 - "SectionPlaybackMode"
Cohesion: 0.14
Nodes (13): CaseIterable, Identifiable, SectionPlaybackMode, continueTimeline, continueToNext, .displayName, .id, oneShot (+5 more)

### Community 59 - "UIKitToolbarMenuButtonRepresentable"
Cohesion: 0.33
Nodes (7): Coordinator, Context, String, Void, UIKitToolbarMenuButtonRepresentable, UIButton, UIViewRepresentable

### Community 60 - "DAWProject"
Cohesion: 0.36
Nodes (9): DAWProject, .duration, Bool, Double, Int32, String, TimeInterval, UInt8 (+1 more)

### Community 61 - "DAWTheme"
Cohesion: 0.12
Nodes (15): .groupDivider, DAWIconToolbarButtonStyle, DAWLabeledToolbarButtonStyle, DAWPrimaryButtonStyle, Configuration, Content, .body, .mixerButton (+7 more)

### Community 62 - ".loopMappingCard"
Cohesion: 0.16
Nodes (10): AppKit, ButtonStyle, .learnBanner, .loopMappingCard, SectionMappingAssignButtonStyle, SectionMappingCardGlow, SectionMappingPlayButtonStyle, Configuration (+2 more)

### Community 63 - "WorkspaceView"
Cohesion: 0.11
Nodes (16): ContentView, .body, Binding, Bool, String, WorkspaceSettingsView, .body, .deleteSectionDialogTitle (+8 more)

### Community 64 - "AudioDropTargetModifier"
Cohesion: 0.27
Nodes (7): AudioDropTargetModifier, Content, NSItemProvider, String, TimeInterval, View, View

### Community 65 - "SimplePlayProjectFileDocument"
Cohesion: 0.22
Nodes (7): FileDocument, FileWrapper, ReadConfiguration, SimplePlayProjectFileDocument, .readableContentTypes, Data, WriteConfiguration

### Community 66 - "View"
Cohesion: 0.15
Nodes (18): Bool, String, Void, ToolbarMenuButtonStyleModifier, TopToolbarView, .importButton, .isCompact, .openButton (+10 more)

### Community 67 - "MIDILearnTarget"
Cohesion: 0.40
Nodes (4): MIDILearnTarget, loopToggle, section, UUID

### Community 68 - ".format"
Cohesion: 0.22
Nodes (7): Bool, String, TimeInterval, .formattedCurrentTime, .formattedDuration, .selectionInfo, .body

### Community 70 - ".sectionMappingCard"
Cohesion: 0.15
Nodes (12): MIDINoteAssignment, .displayName, Bool, String, UInt8, SectionPlaybackStatus, idle, playing (+4 more)

### Community 71 - "AudioDropOverlay"
Cohesion: 0.33
Nodes (5): AudioDropOverlay, .body, String, TimelineEmptyDropHint, .body

### Community 72 - "DropURLLoader"
Cohesion: 0.62
Nodes (4): DropURLLoader, NSItemProvider, String, URL

### Community 75 - "SidebarPanel"
Cohesion: 0.29
Nodes (10): .playbackSettings, .sectionEditor, .trackPitch, .volumeControls, SidebarLabeledRow, .body, SidebarPanel, .body (+2 more)

### Community 76 - "DAWSecondaryButtonStyle"
Cohesion: 0.38
Nodes (5): .selectedMarkerEditor, .sessionManagement, DAWSecondaryButtonStyle, .projectSessionMenuItems, .body

### Community 77 - "WorkspaceViewModel"
Cohesion: 0.07
Nodes (28): SectionDragKind, move, resizeEnd, resizeStart, CGFloat, ClosedRange, Set, TimelineScrollRequest (+20 more)

### Community 81 - "TrackControlButton"
Cohesion: 0.22
Nodes (8): PanKnobView, .body, Bool, Double, String, Void, TrackControlButton, .body

## Knowledge Gaps
- **273 isolated node(s):** `id`, `name`, `startTime`, `endTime`, `colorHex` (+268 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **8 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `WorkspaceViewModel` connect `WorkspaceViewModel` to `SectionMarkerChipView`, `PropertiesSidebarView`, `TrackLaneView`, `Foundation`, `ArrangementSection`, `TimelineWorkspacePanel`, `TransportBarView`, `AudioImportService`, `AudioEngineService`, `.applyImportedStems`, `MIDIMappingBarView`, `ProjectPersistenceService`, `.stop`, `.frames`, `FileCommands`, `AudioTrack`, `.attachClip`, `MixerPanelView`, `TimelineOverviewBar`, `AudioOutputDevice`, `TimeInterval`, `SwiftUI`, `MIDIInputService`, `.snap`, `TrackHeaderRowView`, `.saveProject`, `TrackPitchControlView`, `SectionPlaybackMode`, `DAWTheme`, `.loopMappingCard`, `WorkspaceView`, `AudioDropTargetModifier`, `SimplePlayProjectFileDocument`, `View`, `MIDILearnTarget`, `.format`, `.setZoom`, `.sectionMappingCard`, `WorkspaceKeyboardShortcuts`, `DAWSecondaryButtonStyle`?**
  _High betweenness centrality (0.443) - this node is a cross-community bridge._
- **Why does `ArrangementSection` connect `ArrangementSection` to `Codable`, `SectionMarkerChipView`, `View`, `PropertiesSidebarView`, `.format`, `.sectionMappingCard`, `TimeInterval`, `SwiftUI`, `DAWProject`, `MIDIInputService`, `WorkspaceViewModel`, `MIDIMappingBarView`, `SectionPlaybackMode`, `.frames`, `Sendable`, `CodingKeys`?**
  _High betweenness centrality (0.106) - this node is a cross-community bridge._
- **Why does `AudioEngineService` connect `AudioEngineService` to `.attachClip`, `MixerPanelView`, `Foundation`, `SectionLoopContext`, `Float`, `WorkspaceViewModel`, `.applyImportedStems`?**
  _High betweenness centrality (0.088) - this node is a cross-community bridge._
- **Are the 12 inferred relationships involving `WorkspaceViewModel` (e.g. with `ArrangementPlaybackEngine` and `AudioEngineService`) actually correct?**
  _`WorkspaceViewModel` has 12 INFERRED edges - model-reasoned connections that need verification._
- **Are the 2 inferred relationships involving `AudioEngineService` (e.g. with `WorkspaceViewModel` and `.configureAudioEngine()`) actually correct?**
  _`AudioEngineService` has 2 INFERRED edges - model-reasoned connections that need verification._
- **Are the 4 inferred relationships involving `ArrangementSection` (e.g. with `.body` and `.body`) actually correct?**
  _`ArrangementSection` has 4 INFERRED edges - model-reasoned connections that need verification._
- **What connects `id`, `name`, `startTime` to the rest of the system?**
  _273 weakly-connected nodes found - possible documentation gaps or missing edges._