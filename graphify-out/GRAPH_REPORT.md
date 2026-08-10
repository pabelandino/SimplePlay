# Graph Report - SimplePlay  (2026-08-10)

## Corpus Check
- 94 files · ~47,302 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 1617 nodes · 3727 edges · 89 communities (72 shown, 17 thin omitted)
- Extraction: 90% EXTRACTED · 10% INFERRED · 0% AMBIGUOUS · INFERRED: 378 edges (avg confidence: 0.8)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `27f7e098`
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
- ArrangementSection
- MixerPanelView
- TimelineWorkspacePanel
- TransportBarView
- AudioImportService
- .play
- StandardTrackRole
- .applyImportedStems
- ProjectPersistenceService
- MIDIMappingBarView
- SettingsFormStyle.swift
- TimeInterval
- WorkspaceViewModel
- .frames
- Sendable
- CodingKeys
- .stop
- AudioTrack
- AudioSampleRate
- .configure
- UUID
- TimelineOverviewBar
- SectionPlaybackMode
- AudioDeviceService
- Testing
- MacWindowTitleBarHidden.swift
- .log
- .scheduleTimelineSegment
- AudioEngineService
- ClosedRange
- .peaks
- .loopMappingCard
- ProjectPersistenceError
- MIDIInputService
- PitchShiftSettings
- SwiftUI
- .activeGroupIndex
- AudioEngineError
- .saveProject
- FaderMeterStripView
- DAWVerticalFaderView
- TrackPitchControlView
- Foundation
- SupportedAudioFormats
- .loadBucket
- TrackGroup
- DAWProject
- .standardize
- .mixerChannelStrip
- WorkspaceSettingsView
- View
- UIKitToolbarMenuButtonRepresentable
- View
- .body
- SettingsFieldLabel
- TimeInterval
- .sessionManagement
- DAWTheme
- .groupMasterStrip
- SettingsNumberInput
- WorkspaceView
- .selectedMarkerEditor
- .setMasterVolume
- MIDINoteAssignment
- SectionPlaybackStatus
- AVAudioFrameCount
- AVAudioUnitTimePitch
- TrackControlButton
- Int64
- UInt64
- Void
- Set
- UInt8
- URL
- View

## God Nodes (most connected - your core abstractions)
1. `WorkspaceViewModel` - 232 edges
2. `AudioEngineService` - 68 edges
3. `ArrangementSection` - 53 edges
4. `DAWTheme` - 49 edges
5. `MIDIMappingBarView` - 41 edges
6. `AudioTrack` - 40 edges
7. `ArrangementPlaybackEngine` - 36 edges
8. `MixerPanelView` - 35 edges
9. `TimelineWorkspacePanel` - 35 edges
10. `PropertiesSidebarView` - 31 edges

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

## Communities (89 total, 17 thin omitted)

### Community 0 - "SimplePlayUITests"
Cohesion: 0.15
Nodes (6): SimplePlayUITests, SimplePlayUITestsLaunchTests, .runsForEachTargetApplicationUIConfiguration, Bool, XCTest, XCTestCase

### Community 1 - "SectionMarkerChipView"
Cohesion: 0.11
Nodes (29): NSCursor, ResizeEdge, end, start, SectionCreationPreviewView, .body, SectionDragSession, SectionEdgeGuideOverlay (+21 more)

### Community 2 - "PropertiesSidebarView"
Cohesion: 0.12
Nodes (18): PropertiesSidebarView, .body, .pitchIsOriginal, .pitchLabel, .sectionCreationHint, .selectedDevice, .selectedDeviceID, .selectedSection (+10 more)

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
Cohesion: 0.08
Nodes (35): ArrangementSection, .color, .duration, Bool, Decoder, String, TimeInterval, UInt8 (+27 more)

### Community 15 - "MixerPanelView"
Cohesion: 0.11
Nodes (19): MixerPanelView, .body, .channelFaderHeight, .channelFaderWidth, .channelStripWidth, .groupDivider, .isCompact, .masterFaderHeight (+11 more)

### Community 16 - "TimelineWorkspacePanel"
Cohesion: 0.09
Nodes (29): PlayheadView, .playheadDragGesture, Bool, CGFloat, Content, Double, Gesture, String (+21 more)

### Community 17 - "TransportBarView"
Cohesion: 0.10
Nodes (21): Binding, Bool, CGFloat, Double, String, Void, TransportBarStyle, phoneBottomDock (+13 more)

### Community 18 - "AudioImportService"
Cohesion: 0.12
Nodes (19): LocalizedError, AudioFileStorageService, String, URL, UUID, AudioImportError, emptySelection, .errorDescription (+11 more)

### Community 19 - ".play"
Cohesion: 0.21
Nodes (3): AVAudioNode, AVAudioPlayerNode, .playbackGraphIsHealthy

### Community 20 - "StandardTrackRole"
Cohesion: 0.08
Nodes (24): StandardTrackRole, acousticGuitar, backingVocal, bass, brass, click, countIn, cue (+16 more)

### Community 21 - ".applyImportedStems"
Cohesion: 0.12
Nodes (11): Error, Result, SavedProjectDocument, ImportPanelKind, audioFiles, folder, DAWProject, String (+3 more)

### Community 22 - "ProjectPersistenceService"
Cohesion: 0.23
Nodes (7): unsupportedVersion, ProjectPersistenceService, Bool, Data, DAWProject, URL, UUID

### Community 23 - "MIDIMappingBarView"
Cohesion: 0.11
Nodes (21): Animation, AnyTransition, Color, StandardTrackRole, .fallbackColor, MIDIMappingBarView, .body, .collapsedBar (+13 more)

### Community 24 - "SettingsFormStyle.swift"
Cohesion: 0.16
Nodes (18): Color, Selection, .sectionEditor, .selectionInfo, .trackPitch, .pitchMenu, SettingsBadge, SettingsFootnote (+10 more)

### Community 25 - "TimeInterval"
Cohesion: 0.15
Nodes (10): SectionEdgeGuides, Bool, SectionLoopContext, TimeInterval, TimelineScrollAlignment, center, leading, start (+2 more)

### Community 26 - "WorkspaceViewModel"
Cohesion: 0.06
Nodes (32): ClosedRange, SectionPlaybackMode, Set, SectionDragKind, move, resizeEnd, resizeStart, ArrangementSection (+24 more)

### Community 27 - ".frames"
Cohesion: 0.30
Nodes (6): Bool, Double, Int64, TimeInterval, TimelineSampleGrid, TimelineSampleGridTests

### Community 28 - "Sendable"
Cohesion: 0.15
Nodes (27): Codable, Equatable, Sendable, MIDILearnTarget, loopToggle, section, UUID, PersistedClip (+19 more)

### Community 29 - "CodingKeys"
Cohesion: 0.05
Nodes (44): CodingKey, CodingKeys, colorHex, endTime, id, midiChannel, midiNote, midiUsesControlChange (+36 more)

### Community 30 - ".stop"
Cohesion: 0.12
Nodes (12): Commands, ContentView, .body, FileCommands, Content, View, TransportCommands, .body (+4 more)

### Community 31 - "AudioTrack"
Cohesion: 0.07
Nodes (40): AudioClip, .endTime, Int, String, TimeInterval, URL, UUID, AudioTrack (+32 more)

### Community 32 - "AudioSampleRate"
Cohesion: 0.23
Nodes (13): Double, Hashable, Identifiable, AudioOutputDevice, AudioSampleRate, .displayName, .id, rate44100 (+5 more)

### Community 33 - ".configure"
Cohesion: 0.17
Nodes (9): AudioSampleRate, AudioSettings, AVAudioFile, AVAudioUnitEQ, AVAudioUnitTimePitch, ScheduledClip, AudioClip, DAWProject (+1 more)

### Community 34 - "UUID"
Cohesion: 0.07
Nodes (22): AudioTrack, Bool, Bool, TimeInterval, Double, Float, Int, UUID (+14 more)

### Community 35 - "TimelineOverviewBar"
Cohesion: 0.18
Nodes (14): Bool, CGFloat, CGSize, ClosedRange, Gesture, TimeInterval, TimelineOverviewBar, .barHeight (+6 more)

### Community 36 - "SectionPlaybackMode"
Cohesion: 0.15
Nodes (12): CaseIterable, SectionPlaybackMode, continueTimeline, continueToNext, .displayName, .id, oneShot, repeatSection (+4 more)

### Community 37 - "AudioDeviceService"
Cohesion: 0.29
Nodes (5): AudioDeviceID, AudioDeviceService, Bool, Int, String

### Community 38 - "Testing"
Cohesion: 0.22
Nodes (4): SimplePlay, ProjectArchiveTests, SimplePlayTests, Testing

### Community 39 - "MacWindowTitleBarHidden.swift"
Cohesion: 0.11
Nodes (15): Notification, NSApplicationDelegate, NSEvent, NSObject, NSView, NSViewRepresentable, NSWindow, .body (+7 more)

### Community 40 - ".log"
Cohesion: 0.22
Nodes (10): SectionLoopContext, .duration, TimeInterval, UUID, SectionLoopDiagnostics, AVAudioFrameCount, Double, Int64 (+2 more)

### Community 41 - ".scheduleTimelineSegment"
Cohesion: 0.31
Nodes (7): AVAudioFrameCount, AVAudioTime, Int64, Bool, Int, SectionLoopContext, String

### Community 42 - "AudioEngineService"
Cohesion: 0.16
Nodes (10): AVAudioMixerNode, AudioEngineService, .isPlaybackGraphReady, .isSectionLoopPlaybackActive, .masterVolume, .primaryClipSampleRate, Double, Float (+2 more)

### Community 44 - ".peaks"
Cohesion: 0.09
Nodes (30): AVAudioPCMBuffer, CheckedContinuation, Never, Path, clips, Double, Float, Int (+22 more)

### Community 45 - ".loopMappingCard"
Cohesion: 0.22
Nodes (6): .learnBanner, .loopMappingCard, SectionMappingAssignButtonStyle, SectionMappingPlayButtonStyle, Configuration, UIKit

### Community 46 - "ProjectPersistenceError"
Cohesion: 0.17
Nodes (11): JSONDecoder, .projectDecoder, JSONEncoder, .pretty, ProjectPersistenceError, .errorDescription, invalidPackage, missingAudioFile (+3 more)

### Community 47 - "MIDIInputService"
Cohesion: 0.07
Nodes (24): CoreMIDI, MIDINotifyProc, MIDIPacket, MIDIPacketList, MIDISourceInfo, MIDIInputEvent, MIDIInputService, MIDISourceInfo (+16 more)

### Community 48 - "PitchShiftSettings"
Cohesion: 0.31
Nodes (5): PitchShiftSettings, AVAudioUnitTimePitch, Double, Float, PitchShiftSettingsTests

### Community 49 - "SwiftUI"
Cohesion: 0.14
Nodes (7): App, AppKit, Scene, SimplePlayApp, ResizablePropertiesSidebar, .body, SwiftUI

### Community 51 - "AudioEngineError"
Cohesion: 0.29
Nodes (7): AudioEngineError, clipLoadFailed, deviceSelectionFailed, engineStartFailed, .errorDescription, noPlayableClips, playbackUnavailable

### Community 52 - ".saveProject"
Cohesion: 0.27
Nodes (5): ProjectFilePanel, String, URL, .body, SimplePlayProjectFileDocument

### Community 53 - "FaderMeterStripView"
Cohesion: 0.15
Nodes (12): .projectMasterStrip, .mainVolumeControl, FaderMeterStripView, .reservesThumbClearance, .showsUnityMark, .usesUnityCenterDecibelScale, Bool, CGFloat (+4 more)

### Community 54 - "DAWVerticalFaderView"
Cohesion: 0.09
Nodes (25): ClosedRange, Double, Float, String, TrackVolumeSettings, .trackRange, DAWVerticalFaderView, .body (+17 more)

### Community 55 - "TrackPitchControlView"
Cohesion: 0.18
Nodes (13): .actionButtons, Binding, Bool, Double, String, UUID, TrackPitchControlView, .menuTitle (+5 more)

### Community 56 - "Foundation"
Cohesion: 0.14
Nodes (7): AVFoundation, CoreAudio, Foundation, Observation, os, SnapGrid, TimeFormatting

### Community 57 - "SupportedAudioFormats"
Cohesion: 0.05
Nodes (37): FileDocument, FileWrapper, ReadConfiguration, SimplePlayProjectFileDocument, .readableContentTypes, Data, DropURLLoader, NSItemProvider (+29 more)

### Community 58 - ".loadBucket"
Cohesion: 0.31
Nodes (5): CoreGraphics, CGFloat, Int, WaveformLOD, .requiredLOD

### Community 59 - "TrackGroup"
Cohesion: 0.27
Nodes (8): Date, Encoder, Decoder, Double, String, TimeInterval, UUID, TrackGroup

### Community 60 - "DAWProject"
Cohesion: 0.31
Nodes (9): DAWProject, .duration, Bool, Double, Int32, String, TimeInterval, UInt8 (+1 more)

### Community 61 - ".standardize"
Cohesion: 0.23
Nodes (7): StandardizedName, Bool, StandardTrackRole, String, URL, TrackNameStandardizer, TrackNameStandardizerTests

### Community 62 - ".mixerChannelStrip"
Cohesion: 0.52
Nodes (3): Binding, Double, UUID

### Community 63 - "WorkspaceSettingsView"
Cohesion: 0.22
Nodes (7): Binding, Bool, String, WorkspaceSettingsView, .body, .deleteSectionDialogTitle, .sectionDeletionDialogBinding

### Community 64 - "View"
Cohesion: 0.23
Nodes (9): View, SettingsSectionHeader, .body, SidebarLabeledRow, .body, SidebarPanel, .body, Content (+1 more)

### Community 65 - "UIKitToolbarMenuButtonRepresentable"
Cohesion: 0.33
Nodes (7): Coordinator, Context, String, Void, UIKitToolbarMenuButtonRepresentable, UIButton, UIViewRepresentable

### Community 66 - "View"
Cohesion: 0.10
Nodes (27): ButtonStyle, Content, DAWIconToolbarButtonStyle, DAWLabeledToolbarButtonStyle, DAWSecondaryButtonStyle, Bool, Configuration, Content (+19 more)

### Community 67 - ".body"
Cohesion: 0.24
Nodes (4): MIDIInputEvent, MIDILearnTarget, .body, UInt8

### Community 68 - "SettingsFieldLabel"
Cohesion: 0.29
Nodes (8): .volumeControls, SettingsControlSurface, .body, SettingsFieldLabel, .body, .body, .body, Content

### Community 70 - ".sessionManagement"
Cohesion: 0.60
Nodes (3): .sessionManagement, .projectSessionMenuItems, .body

### Community 71 - "DAWTheme"
Cohesion: 0.08
Nodes (25): Glass, LinearGradient, .overviewBackground, .body, AudioDropOverlay, .body, String, TimelineEmptyDropHint (+17 more)

### Community 73 - "SettingsNumberInput"
Cohesion: 0.50
Nodes (4): .playbackSettings, SettingsNumberInput, .body, Double

### Community 74 - "WorkspaceView"
Cohesion: 0.33
Nodes (7): Binding, Bool, String, WorkspaceView, .deleteSectionDialogTitle, .phoneBottomChrome, .sectionDeletionDialogBinding

### Community 75 - ".selectedMarkerEditor"
Cohesion: 0.15
Nodes (10): Bool, String, TimeInterval, .formattedCurrentTime, .formattedDuration, .audioSettings, .selectedMarkerEditor, .body (+2 more)

### Community 77 - "MIDINoteAssignment"
Cohesion: 0.38
Nodes (6): MIDINoteAssignment, .displayName, Bool, String, UInt8, .loopAssignmentLabel

### Community 78 - "SectionPlaybackStatus"
Cohesion: 0.40
Nodes (5): SectionPlaybackStatus, idle, playing, queued, repeatingAtEnd

### Community 81 - "TrackControlButton"
Cohesion: 0.22
Nodes (8): PanKnobView, .body, Bool, Double, String, Void, TrackControlButton, .body

## Knowledge Gaps
- **277 isolated node(s):** `deviceSelectionFailed`, `engineStartFailed`, `noPlayableClips`, `playbackUnavailable`, `.errorDescription` (+272 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **17 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `WorkspaceViewModel` connect `WorkspaceViewModel` to `SectionMarkerChipView`, `PropertiesSidebarView`, `TrackLaneView`, `ArrangementSection`, `MixerPanelView`, `TimelineWorkspacePanel`, `TransportBarView`, `AudioImportService`, `.applyImportedStems`, `ProjectPersistenceService`, `MIDIMappingBarView`, `SettingsFormStyle.swift`, `TimeInterval`, `.frames`, `.stop`, `UUID`, `TimelineOverviewBar`, `AudioDeviceService`, `AudioEngineService`, `.loopMappingCard`, `MIDIInputService`, `SwiftUI`, `.activeGroupIndex`, `.saveProject`, `TrackPitchControlView`, `Foundation`, `SupportedAudioFormats`, `.mixerChannelStrip`, `WorkspaceSettingsView`, `View`, `.body`, `.sessionManagement`, `DAWTheme`, `WorkspaceView`, `.selectedMarkerEditor`, `.setMasterVolume`, `SectionPlaybackStatus`?**
  _High betweenness centrality (0.433) - this node is a cross-community bridge._
- **Why does `ArrangementSection` connect `ArrangementSection` to `AudioSampleRate`, `SectionMarkerChipView`, `.body`, `SectionPlaybackMode`, `DAWTheme`, `.selectedMarkerEditor`, `DAWProject`, `MIDIInputService`, `SwiftUI`, `MIDIMappingBarView`, `Sendable`, `CodingKeys`?**
  _High betweenness centrality (0.105) - this node is a cross-community bridge._
- **Why does `AudioEngineService` connect `AudioEngineService` to `.configure`, `TimeInterval`, `.scheduleTimelineSegment`, `.play`, `.applyImportedStems`, `Foundation`, `TimeInterval`, `WorkspaceViewModel`?**
  _High betweenness centrality (0.092) - this node is a cross-community bridge._
- **Are the 12 inferred relationships involving `WorkspaceViewModel` (e.g. with `ArrangementPlaybackEngine` and `AudioEngineService`) actually correct?**
  _`WorkspaceViewModel` has 12 INFERRED edges - model-reasoned connections that need verification._
- **Are the 2 inferred relationships involving `AudioEngineService` (e.g. with `WorkspaceViewModel` and `.configureAudioEngine()`) actually correct?**
  _`AudioEngineService` has 2 INFERRED edges - model-reasoned connections that need verification._
- **Are the 4 inferred relationships involving `ArrangementSection` (e.g. with `.body` and `.body`) actually correct?**
  _`ArrangementSection` has 4 INFERRED edges - model-reasoned connections that need verification._
- **What connects `deviceSelectionFailed`, `engineStartFailed`, `noPlayableClips` to the rest of the system?**
  _277 weakly-connected nodes found - possible documentation gaps or missing edges._