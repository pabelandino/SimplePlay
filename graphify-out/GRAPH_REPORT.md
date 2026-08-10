# Graph Report - SimplePlay  (2026-08-10)

## Corpus Check
- 92 files · ~44,585 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 1495 nodes · 3439 edges · 76 communities (72 shown, 4 thin omitted)
- Extraction: 90% EXTRACTED · 10% INFERRED · 0% AMBIGUOUS · INFERRED: 349 edges (avg confidence: 0.8)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `8ca18b61`
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
- AudioTrack
- Testing
- CodingKeys
- .triggerSection
- Sendable
- TimelineOverviewBar
- WorkspaceView
- MixerPanelView
- SupportedAudioFormats
- .sessionManagement
- .standardize
- DAWProject
- MacWindowTitleBarHidden.swift
- View
- .frames
- MIDIInputEvent
- FaderMeterStripView
- .peaks
- MIDISourceInfo
- SidebarPanel
- MIDIInputService
- TrackWaveformProgressBar
- SwiftUI
- PitchShiftSettings
- .attachClip
- WorkspaceViewModel
- .snap
- DAWVerticalFaderView
- .hex
- .loadBucket
- MIDINoteAssignment
- .log
- UIKitToolbarMenuButtonRepresentable
- MIDIOutputService
- DAWTheme
- TrackPitchControlView
- TrackGroup
- .format
- AudioEngineError
- .isNodeConnected
- AudioClip
- DAWProject
- UUID
- TrackControlButton
- .stem
- .setZoom
- TrackHeaderRowView
- .selectedMarkerEditor
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
- `.actionButtons` --calls--> `TrackPitchControlView`  [INFERRED]
  SimplePlay/Features/Workspace/Views/TopToolbarView.swift → SimplePlay/Features/Workspace/Views/TrackPitchControlView.swift
- `.body` --calls--> `ContentView`  [INFERRED]
  SimplePlay/SimplePlayApp.swift → SimplePlay/ContentView.swift

## Import Cycles
- None detected.

## Communities (76 total, 4 thin omitted)

### Community 0 - "SimplePlayUITests"
Cohesion: 0.15
Nodes (6): SimplePlayUITests, SimplePlayUITestsLaunchTests, .runsForEachTargetApplicationUIConfiguration, Bool, XCTest, XCTestCase

### Community 1 - "SectionMarkerChipView"
Cohesion: 0.08
Nodes (34): NSCursor, SectionDragKind, move, resizeEnd, resizeStart, ResizeEdge, end, start (+26 more)

### Community 2 - "PropertiesSidebarView"
Cohesion: 0.11
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

### Community 6 - "Foundation"
Cohesion: 0.14
Nodes (7): AVFoundation, CoreAudio, CoreMIDI, Foundation, Observation, os, SnapGrid

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

### Community 15 - "SectionLoopContext"
Cohesion: 0.24
Nodes (10): AVAudioFrameCount, AVAudioTime, SectionLoopContext, .duration, TimeInterval, UUID, Bool, Int (+2 more)

### Community 16 - "TimelineWorkspacePanel"
Cohesion: 0.09
Nodes (33): PlayheadView, .body, .playheadDragGesture, Bool, CGFloat, Content, Double, Gesture (+25 more)

### Community 17 - "TransportBarView"
Cohesion: 0.10
Nodes (21): Binding, Bool, CGFloat, Double, String, Void, TransportBarStyle, phoneBottomDock (+13 more)

### Community 18 - "AudioImportService"
Cohesion: 0.13
Nodes (17): LocalizedError, AudioFileStorageService, String, URL, UUID, AudioImportError, emptySelection, .errorDescription (+9 more)

### Community 19 - "AudioEngineService"
Cohesion: 0.13
Nodes (11): AVAudioMixerNode, AVAudioPCMBuffer, AVAudioUnitEQ, AudioEngineService, .isPlaybackGraphReady, .masterVolume, .primaryClipSampleRate, Double (+3 more)

### Community 20 - "StandardTrackRole"
Cohesion: 0.06
Nodes (36): CaseIterable, SectionPlaybackMode, continueTimeline, continueToNext, .displayName, .id, oneShot, repeatSection (+28 more)

### Community 21 - ".applyImportedStems"
Cohesion: 0.14
Nodes (8): Error, Result, Bool, URL, DAWProject, String, URL, .body

### Community 22 - "SimplePlayProjectArchive"
Cohesion: 0.16
Nodes (15): Asset, SimplePlayProjectArchive, SimplePlayProjectArchiveError, corruptAsset, corruptManifest, .errorDescription, invalidArchive, Bool (+7 more)

### Community 23 - "MIDIMappingBarView"
Cohesion: 0.13
Nodes (18): Animation, AnyTransition, MIDIMappingBarView, .body, .collapsedBar, .collapsedBarContent, .devicePickerLabel, .devicePickerTitle (+10 more)

### Community 24 - "Equatable"
Cohesion: 0.07
Nodes (41): Codable, Equatable, PersistedClip, PersistedProject, PersistedTrack, SavedProjectDocument, Bool, DAWProject (+33 more)

### Community 25 - "TopToolbarView"
Cohesion: 0.25
Nodes (11): String, Void, TopToolbarView, .actionButtons, .isCompact, .openButton, .projectTitle, .saveButton (+3 more)

### Community 26 - "TimeInterval"
Cohesion: 0.27
Nodes (5): SectionEdgeGuides, Bool, TimeInterval, UInt8, .activeSectionEdgeGuides

### Community 27 - "AudioTrack"
Cohesion: 0.16
Nodes (15): AudioTrack, .color, .displayName, Bool, Double, StandardTrackRole, String, UUID (+7 more)

### Community 28 - "Testing"
Cohesion: 0.22
Nodes (4): SimplePlay, ProjectArchiveTests, SimplePlayTests, Testing

### Community 29 - "CodingKeys"
Cohesion: 0.07
Nodes (31): CodingKeys, audioSettings, colorHex, id, isLocked, isMuted, isSnapEnabled, isSolo (+23 more)

### Community 30 - ".triggerSection"
Cohesion: 0.13
Nodes (10): Commands, FileCommands, Content, View, TransportCommands, .body, View, WorkspaceKeyboardShortcuts (+2 more)

### Community 31 - "Sendable"
Cohesion: 0.26
Nodes (11): Sendable, ImportedStem, ImportPlacement, appendNewGroup, insertIntoGroup, DAWProject, Int, String (+3 more)

### Community 32 - "TimelineOverviewBar"
Cohesion: 0.19
Nodes (13): Bool, CGFloat, CGSize, Gesture, TimeInterval, TimelineOverviewBar, .barHeight, .body (+5 more)

### Community 33 - "WorkspaceView"
Cohesion: 0.11
Nodes (16): ContentView, .body, Binding, Bool, String, WorkspaceSettingsView, .body, .deleteSectionDialogTitle (+8 more)

### Community 34 - "MixerPanelView"
Cohesion: 0.11
Nodes (19): MixerPanelView, .body, .channelFaderHeight, .channelFaderWidth, .channelStripWidth, .isCompact, .masterFaderHeight, .mastersStripRow (+11 more)

### Community 35 - "SupportedAudioFormats"
Cohesion: 0.05
Nodes (37): FileDocument, FileWrapper, ReadConfiguration, SimplePlayProjectFileDocument, .readableContentTypes, Data, DropURLLoader, NSItemProvider (+29 more)

### Community 36 - ".sessionManagement"
Cohesion: 0.60
Nodes (3): .sessionManagement, .projectSessionMenuItems, .body

### Community 37 - ".standardize"
Cohesion: 0.23
Nodes (7): StandardizedName, Bool, StandardTrackRole, String, URL, TrackNameStandardizer, TrackNameStandardizerTests

### Community 38 - "DAWProject"
Cohesion: 0.09
Nodes (26): AudioDeviceID, Double, Hashable, AudioOutputDevice, AudioSampleRate, .displayName, .id, rate44100 (+18 more)

### Community 39 - "MacWindowTitleBarHidden.swift"
Cohesion: 0.11
Nodes (15): Notification, NSApplicationDelegate, NSEvent, NSObject, NSView, NSViewRepresentable, NSWindow, .body (+7 more)

### Community 40 - "View"
Cohesion: 0.20
Nodes (9): Configuration, Bool, ToolbarMenuButtonStyleModifier, .importButton, .projectSessionButton, ImportToolbarMenuButton, .body, ProjectSessionToolbarMenuButton (+1 more)

### Community 41 - ".frames"
Cohesion: 0.32
Nodes (6): Bool, Double, Int64, TimeInterval, TimelineSampleGrid, TimelineSampleGridTests

### Community 42 - "MIDIInputEvent"
Cohesion: 0.18
Nodes (7): MIDIPacket, Kind, controlChange, noteOn, MIDIInputEvent, Int, UInt8

### Community 43 - "FaderMeterStripView"
Cohesion: 0.15
Nodes (12): .projectMasterStrip, .mainVolumeControl, FaderMeterStripView, .reservesThumbClearance, .showsUnityMark, .usesUnityCenterDecibelScale, Bool, CGFloat (+4 more)

### Community 44 - ".peaks"
Cohesion: 0.09
Nodes (30): CheckedContinuation, Never, Path, clips, Double, Float, Int, MainActor (+22 more)

### Community 45 - "MIDISourceInfo"
Cohesion: 0.28
Nodes (6): Identifiable, MIDISourceInfo, .id, Bool, String, .devicePicker

### Community 46 - "SidebarPanel"
Cohesion: 0.26
Nodes (12): .audioSettings, .playbackSettings, .sectionEditor, .trackPitch, .volumeControls, DAWSecondaryButtonStyle, SidebarLabeledRow, .body (+4 more)

### Community 47 - "MIDIInputService"
Cohesion: 0.16
Nodes (9): MIDINotifyProc, MIDIPacketList, MIDIInputService, Int32, MainActor, MIDIEndpointRef, Void, UnsafeMutablePointer (+1 more)

### Community 48 - "TrackWaveformProgressBar"
Cohesion: 0.40
Nodes (4): Bool, Double, TrackWaveformProgressBar, .body

### Community 49 - "SwiftUI"
Cohesion: 0.16
Nodes (7): App, AppKit, Scene, SimplePlayApp, ResizablePropertiesSidebar, .body, SwiftUI

### Community 50 - "PitchShiftSettings"
Cohesion: 0.31
Nodes (5): PitchShiftSettings, AVAudioUnitTimePitch, Double, Float, PitchShiftSettingsTests

### Community 51 - ".attachClip"
Cohesion: 0.27
Nodes (5): AVAudioFile, ScheduledClip, AVAudioUnitTimePitch, DAWProject, UInt32

### Community 52 - "WorkspaceViewModel"
Cohesion: 0.08
Nodes (17): ClosedRange, Set, WorkspaceViewModel, .activePitchTrack, .canSaveDirectlyToCurrentURL, .isArrangementSectionControllingPlayback, .isMIDILearnActive, .isSectionInteractionActive (+9 more)

### Community 53 - ".snap"
Cohesion: 0.12
Nodes (9): Bool, TimeInterval, ImportPanelKind, audioFiles, folder, Int, .trackHeaderColumnTracksOnly, .trackLanes (+1 more)

### Community 54 - "DAWVerticalFaderView"
Cohesion: 0.09
Nodes (25): ClosedRange, Double, Float, String, TrackVolumeSettings, .trackRange, DAWVerticalFaderView, .body (+17 more)

### Community 55 - ".hex"
Cohesion: 0.40
Nodes (5): .defaultColor, Int, StandardTrackRole, String, TrackColorPalette

### Community 56 - ".loadBucket"
Cohesion: 0.31
Nodes (5): CoreGraphics, CGFloat, Int, WaveformLOD, .requiredLOD

### Community 57 - "MIDINoteAssignment"
Cohesion: 0.20
Nodes (10): MIDILearnTarget, loopToggle, section, MIDINoteAssignment, .displayName, Bool, String, UInt8 (+2 more)

### Community 58 - ".log"
Cohesion: 0.44
Nodes (5): SectionLoopDiagnostics, Double, Int64, String, TimeInterval

### Community 59 - "UIKitToolbarMenuButtonRepresentable"
Cohesion: 0.33
Nodes (7): Coordinator, Context, String, Void, UIKitToolbarMenuButtonRepresentable, UIButton, UIViewRepresentable

### Community 60 - "MIDIOutputService"
Cohesion: 0.33
Nodes (4): MIDIOutputService, Bool, MIDIEndpointRef, UInt8

### Community 61 - "DAWTheme"
Cohesion: 0.22
Nodes (9): .groupDivider, .pinnedMastersColumn, .mixerButton, DAWTheme, .isPhone, Bool, CGFloat, Double (+1 more)

### Community 62 - "TrackPitchControlView"
Cohesion: 0.18
Nodes (12): Binding, Bool, Double, String, UUID, TrackPitchControlView, .menuTitle, .pitchIsOriginal (+4 more)

### Community 63 - "TrackGroup"
Cohesion: 0.14
Nodes (16): CodingKey, Date, Encoder, CodingKeys, horizontalOffset, id, importedAt, name (+8 more)

### Community 64 - ".format"
Cohesion: 0.20
Nodes (8): Bool, String, TimeInterval, TimeFormatting, .formattedCurrentTime, .formattedDuration, .selectionInfo, .body

### Community 65 - "AudioEngineError"
Cohesion: 0.25
Nodes (8): AudioEngineError, clipLoadFailed, deviceSelectionFailed, engineStartFailed, .errorDescription, noPlayableClips, playbackUnavailable, String

### Community 66 - ".isNodeConnected"
Cohesion: 0.33
Nodes (3): AVAudioNode, AVAudioPlayerNode, .playbackGraphIsHealthy

### Community 67 - "AudioClip"
Cohesion: 0.36
Nodes (7): AudioClip, .endTime, Int, String, TimeInterval, URL, UUID

### Community 68 - "DAWProject"
Cohesion: 0.39
Nodes (4): groups, DAWProject, Int, UUID

### Community 69 - "UUID"
Cohesion: 0.14
Nodes (10): Double, Float, UUID, .mixerScrollWithPinnedMasters, Binding, Double, UUID, .body (+2 more)

### Community 70 - "TrackControlButton"
Cohesion: 0.22
Nodes (8): PanKnobView, .body, Bool, Double, String, Void, TrackControlButton, .body

### Community 71 - ".stem"
Cohesion: 0.36
Nodes (3): String, TimeInterval, TrackOrganizationServiceTests

### Community 73 - "TrackHeaderRowView"
Cohesion: 0.33
Nodes (7): Binding, Double, TrackHeaderRowView, .displayColor, .liveTrack, .trackPan, .trackVolumeBinding

### Community 76 - ".selectedMarkerEditor"
Cohesion: 0.24
Nodes (8): ButtonStyle, .selectedMarkerEditor, DAWIconToolbarButtonStyle, DAWLabeledToolbarButtonStyle, DAWPrimaryButtonStyle, Content, .body, UIKit

### Community 77 - "CGFloat"
Cohesion: 0.14
Nodes (10): CGFloat, TimelineScrollAlignment, center, leading, start, TimelineScrollRequest, .minimumTimelineZoom, .timelineContentWidth (+2 more)

## Knowledge Gaps
- **267 isolated node(s):** `id`, `name`, `startTime`, `endTime`, `colorHex` (+262 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **4 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `WorkspaceViewModel` connect `WorkspaceViewModel` to `SectionMarkerChipView`, `PropertiesSidebarView`, `TrackLaneView`, `Foundation`, `ArrangementSection`, `TimelineWorkspacePanel`, `TransportBarView`, `AudioImportService`, `AudioEngineService`, `StandardTrackRole`, `.applyImportedStems`, `MIDIMappingBarView`, `Equatable`, `TopToolbarView`, `TimeInterval`, `AudioTrack`, `.triggerSection`, `Sendable`, `TimelineOverviewBar`, `WorkspaceView`, `MixerPanelView`, `SupportedAudioFormats`, `.sessionManagement`, `DAWProject`, `View`, `MIDIInputEvent`, `MIDISourceInfo`, `SwiftUI`, `.snap`, `MIDINoteAssignment`, `DAWTheme`, `TrackPitchControlView`, `.format`, `UUID`, `.setZoom`, `TrackHeaderRowView`, `CGFloat`?**
  _High betweenness centrality (0.423) - this node is a cross-community bridge._
- **Why does `AudioTrack` connect `AudioTrack` to `MixerPanelView`, `AudioClip`, `DAWProject`, `UUID`, `DAWProject`, `TrackLaneView`, `TrackHeaderRowView`, `MIDISourceInfo`, `SwiftUI`, `PitchShiftSettings`, `WorkspaceViewModel`, `.hex`, `Equatable`, `Sendable`?**
  _High betweenness centrality (0.077) - this node is a cross-community bridge._
- **Why does `Foundation` connect `Foundation` to `.format`, `AudioClip`, `SupportedAudioFormats`, `.standardize`, `DAWProject`, `SwiftUI`, `AudioImportService`, `StandardTrackRole`, `SimplePlayProjectArchive`, `DAWVerticalFaderView`, `Equatable`, `MIDINoteAssignment`, `.loadBucket`, `Testing`, `TrackGroup`?**
  _High betweenness centrality (0.071) - this node is a cross-community bridge._
- **Are the 12 inferred relationships involving `WorkspaceViewModel` (e.g. with `ArrangementPlaybackEngine` and `AudioEngineService`) actually correct?**
  _`WorkspaceViewModel` has 12 INFERRED edges - model-reasoned connections that need verification._
- **Are the 2 inferred relationships involving `AudioEngineService` (e.g. with `WorkspaceViewModel` and `.configureAudioEngine()`) actually correct?**
  _`AudioEngineService` has 2 INFERRED edges - model-reasoned connections that need verification._
- **Are the 4 inferred relationships involving `ArrangementSection` (e.g. with `.body` and `.body`) actually correct?**
  _`ArrangementSection` has 4 INFERRED edges - model-reasoned connections that need verification._
- **Are the 3 inferred relationships involving `AudioTrack` (e.g. with `.duration` and `.hasSoloTracks`) actually correct?**
  _`AudioTrack` has 3 INFERRED edges - model-reasoned connections that need verification._