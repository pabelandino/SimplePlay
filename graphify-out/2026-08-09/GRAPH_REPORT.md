# Graph Report - SimplePlay  (2026-08-09)

## Corpus Check
- 87 files · ~41,697 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 1399 nodes · 3152 edges · 63 communities (60 shown, 3 thin omitted)
- Extraction: 89% EXTRACTED · 11% INFERRED · 0% AMBIGUOUS · INFERRED: 332 edges (avg confidence: 0.8)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `18b66459`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- SimplePlayUITests
- SectionMarkerChipView
- TrackGroup
- What You Must Do When Invoked
- .majorTickInterval
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
- Color
- TimelineWorkspacePanel
- .standardize
- AudioImportService
- AudioEngineService
- StandardTrackRole
- .body
- SimplePlayProjectArchive
- Sendable
- TrackPitchControlView
- TopToolbarView
- Bool
- AudioTrack
- .body
- CodingKeys
- Testing
- TrackOrganizationService
- ClipDragInteractionModifier
- PlayheadView
- MixerPanelView
- SupportedAudioFormats
- MIDINoteAssignment
- TimelineRulerTicksView
- PitchShiftSettings
- MacWindowTitleBarHidden.swift
- UUID
- DAWProject
- TransportBarView
- CGFloat
- .peaks
- .loadBucket
- PropertiesSidebarView
- MIDIInputService
- AudioClip
- TimeInterval
- TrackWaveformProgressBar
- DAWProject
- WorkspaceViewModel
- TrackLaneView
- DAWVerticalFaderView
- DAWSecondaryButtonStyle
- AppKit
- MIDIMappingBarView
- View
- WorkspaceView
- SwiftUI
- TrackControlButton
- .applyImportedStems

## God Nodes (most connected - your core abstractions)
1. `WorkspaceViewModel` - 198 edges
2. `AudioEngineService` - 48 edges
3. `ArrangementSection` - 47 edges
4. `AudioTrack` - 42 edges
5. `ArrangementPlaybackEngine` - 36 edges
6. `DAWTheme` - 36 edges
7. `MixerPanelView` - 35 edges
8. `StandardTrackRole` - 31 edges
9. `PropertiesSidebarView` - 31 edges
10. `TimelineWorkspacePanel` - 31 edges

## Surprising Connections (you probably didn't know these)
- `.duration` --references--> `AudioTrack`  [INFERRED]
  SimplePlay/Core/Models/DAWProject.swift → SimplePlay/Core/Models/AudioTrack.swift
- `.selectedDevice` --references--> `WorkspaceViewModel`  [INFERRED]
  SimplePlay/Features/Workspace/Views/PropertiesSidebarView.swift → SimplePlay/Features/Workspace/ViewModels/WorkspaceViewModel.swift
- `.body` --calls--> `WorkspaceView`  [INFERRED]
  SimplePlay/ContentView.swift → SimplePlay/Features/Workspace/Views/WorkspaceView.swift
- `.body` --references--> `ArrangementSection`  [INFERRED]
  SimplePlay/Features/Workspace/Views/SectionMarkerLaneView.swift → SimplePlay/Core/Models/ArrangementSection.swift
- `.body` --references--> `ArrangementSection`  [INFERRED]
  SimplePlay/Features/Workspace/Views/SectionMarkerLaneView.swift → SimplePlay/Core/Models/ArrangementSection.swift

## Import Cycles
- None detected.

## Communities (63 total, 3 thin omitted)

### Community 0 - "SimplePlayUITests"
Cohesion: 0.15
Nodes (6): SimplePlayUITests, SimplePlayUITestsLaunchTests, .runsForEachTargetApplicationUIConfiguration, Bool, XCTest, XCTestCase

### Community 1 - "SectionMarkerChipView"
Cohesion: 0.10
Nodes (31): NSCursor, SectionDragKind, move, resizeEnd, resizeStart, ResizeEdge, end, start (+23 more)

### Community 2 - "TrackGroup"
Cohesion: 0.14
Nodes (16): CodingKey, Date, Encoder, CodingKeys, horizontalOffset, id, importedAt, name (+8 more)

### Community 3 - "What You Must Do When Invoked"
Cohesion: 0.08
Nodes (24): For /graphify add and --watch, For /graphify query, For the commit hook and native AGENTS.md integration, For --update and --cluster-only, /graphify, Honesty Rules, Interpreter guard for subcommands, Part A - Structural extraction for code files (+16 more)

### Community 4 - ".majorTickInterval"
Cohesion: 0.27
Nodes (5): CGFloat, String, TimeInterval, TimelineRulerScale, TimelineRulerScaleTests

### Community 5 - "graphify reference: extra exports and benchmark"
Cohesion: 0.22
Nodes (8): graphify reference: extra exports and benchmark, Step 6b - Wiki (only if --wiki flag), Step 7 - Neo4j export (only if --neo4j or --neo4j-push flag), Step 7a - FalkorDB export (only if --falkordb or --falkordb-push flag), Step 7b - SVG export (only if --svg flag), Step 7c - GraphML export (only if --graphml flag), Step 7d - MCP server (only if --mcp flag), Step 8 - Token reduction benchmark (only if total_words > 5000)

### Community 6 - "Foundation"
Cohesion: 0.16
Nodes (6): AVFoundation, CoreAudio, CoreMIDI, Foundation, Observation, SnapGrid

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

### Community 15 - "Color"
Cohesion: 0.25
Nodes (8): .defaultColor, Color, StandardTrackRole, .fallbackColor, Int, StandardTrackRole, String, TrackColorPalette

### Community 16 - "TimelineWorkspacePanel"
Cohesion: 0.13
Nodes (19): CGFloat, Content, Double, String, TimelineWorkspacePanel, .body, .isCompact, .laneAreaHeight (+11 more)

### Community 17 - ".standardize"
Cohesion: 0.23
Nodes (7): StandardizedName, Bool, StandardTrackRole, String, URL, TrackNameStandardizer, TrackNameStandardizerTests

### Community 18 - "AudioImportService"
Cohesion: 0.12
Nodes (19): LocalizedError, AudioFileStorageService, String, URL, UUID, AudioImportError, emptySelection, .errorDescription (+11 more)

### Community 19 - "AudioEngineService"
Cohesion: 0.08
Nodes (27): AVAudioFile, AVAudioMixerNode, AVAudioNode, AVAudioPlayerNode, AVAudioUnitEQ, AudioEngineError, clipLoadFailed, deviceSelectionFailed (+19 more)

### Community 20 - "StandardTrackRole"
Cohesion: 0.06
Nodes (36): CaseIterable, SectionPlaybackMode, continueTimeline, continueToNext, .displayName, .id, oneShot, repeatSection (+28 more)

### Community 21 - ".body"
Cohesion: 0.20
Nodes (5): Error, Result, String, URL, .body

### Community 22 - "SimplePlayProjectArchive"
Cohesion: 0.16
Nodes (15): Asset, SimplePlayProjectArchive, SimplePlayProjectArchiveError, corruptAsset, corruptManifest, .errorDescription, invalidArchive, Bool (+7 more)

### Community 23 - "Sendable"
Cohesion: 0.05
Nodes (62): Codable, Double, Equatable, FileDocument, FileWrapper, Hashable, ReadConfiguration, Sendable (+54 more)

### Community 24 - "TrackPitchControlView"
Cohesion: 0.18
Nodes (12): Binding, Bool, Double, String, UUID, TrackPitchControlView, .menuTitle, .pitchIsOriginal (+4 more)

### Community 25 - "TopToolbarView"
Cohesion: 0.20
Nodes (11): Bool, String, Void, TopToolbarView, .actionButtons, .importMenuItems, .isCompact, .projectTitle (+3 more)

### Community 26 - "Bool"
Cohesion: 0.19
Nodes (3): Bool, UInt8, Timer

### Community 27 - "AudioTrack"
Cohesion: 0.24
Nodes (11): AudioTrack, .color, .displayName, Bool, Double, StandardTrackRole, String, UUID (+3 more)

### Community 28 - ".body"
Cohesion: 0.15
Nodes (6): Content, View, TransportCommands, .body, View, WorkspaceKeyboardShortcuts

### Community 29 - "CodingKeys"
Cohesion: 0.07
Nodes (31): CodingKeys, audioSettings, colorHex, id, isLocked, isMuted, isSnapEnabled, isSolo (+23 more)

### Community 30 - "Testing"
Cohesion: 0.18
Nodes (5): CoreGraphics, SimplePlay, ProjectArchiveTests, SimplePlayTests, Testing

### Community 31 - "TrackOrganizationService"
Cohesion: 0.19
Nodes (13): ImportedStem, ImportPlacement, appendNewGroup, insertIntoGroup, DAWProject, Int, String, TimeInterval (+5 more)

### Community 32 - "ClipDragInteractionModifier"
Cohesion: 0.18
Nodes (9): G, ClipDragInteractionModifier, ClipSelectionModifiers, .isExtending, Bool, Content, Bool, TimelineAudioDropModifier (+1 more)

### Community 33 - "PlayheadView"
Cohesion: 0.33
Nodes (7): PlayheadView, .body, .playheadDragGesture, Gesture, TimeInterval, Void, .playhead

### Community 34 - "MixerPanelView"
Cohesion: 0.06
Nodes (36): MixerPanelView, .body, .channelFaderHeight, .channelFaderWidth, .channelStripWidth, .isCompact, .masterFaderHeight, .mastersStripRow (+28 more)

### Community 35 - "SupportedAudioFormats"
Cohesion: 0.07
Nodes (30): DropURLLoader, NSItemProvider, String, URL, SimplePlayProjectType, UTType, SupportedAudioFormats, .contentTypes (+22 more)

### Community 36 - "MIDINoteAssignment"
Cohesion: 0.20
Nodes (10): MIDILearnTarget, loopToggle, section, MIDINoteAssignment, .displayName, Bool, String, UInt8 (+2 more)

### Community 37 - "TimelineRulerTicksView"
Cohesion: 0.35
Nodes (9): GraphicsContext, CGFloat, CGSize, TimeInterval, Void, TimelineRulerTicksView, .body, TimelineRulerView (+1 more)

### Community 38 - "PitchShiftSettings"
Cohesion: 0.27
Nodes (5): PitchShiftSettings, AVAudioUnitTimePitch, Double, Float, PitchShiftSettingsTests

### Community 39 - "MacWindowTitleBarHidden.swift"
Cohesion: 0.11
Nodes (15): Context, Notification, NSApplicationDelegate, NSEvent, NSObject, NSView, NSViewRepresentable, NSWindow (+7 more)

### Community 40 - "UUID"
Cohesion: 0.10
Nodes (15): Double, Float, UUID, .mixerScrollWithPinnedMasters, Binding, Double, TrackHeaderRowView, .body (+7 more)

### Community 41 - "DAWProject"
Cohesion: 0.31
Nodes (9): DAWProject, .duration, Bool, Double, Int32, String, TimeInterval, UInt8 (+1 more)

### Community 42 - "TransportBarView"
Cohesion: 0.06
Nodes (37): Bool, CGFloat, CGSize, Gesture, TimeInterval, TimelineOverviewBar, .barHeight, .body (+29 more)

### Community 43 - "CGFloat"
Cohesion: 0.25
Nodes (5): CGFloat, TimelineScrollRequest, .minimumTimelineZoom, .timelineContentWidth, .sectionCreationGesture

### Community 44 - ".peaks"
Cohesion: 0.09
Nodes (31): AVAudioPCMBuffer, CheckedContinuation, Never, Path, clips, Double, Float, Int (+23 more)

### Community 45 - ".loadBucket"
Cohesion: 0.53
Nodes (4): CGFloat, Int, WaveformLOD, .requiredLOD

### Community 46 - "PropertiesSidebarView"
Cohesion: 0.05
Nodes (43): AudioDeviceID, AudioDeviceService, Bool, Int, String, Bool, String, TimeInterval (+35 more)

### Community 47 - "MIDIInputService"
Cohesion: 0.07
Nodes (24): Identifiable, MIDINotifyProc, MIDIPacket, MIDIPacketList, MIDIInputEvent, MIDIInputService, MIDISourceInfo, .id (+16 more)

### Community 48 - "AudioClip"
Cohesion: 0.36
Nodes (7): AudioClip, .endTime, Int, String, TimeInterval, URL, UUID

### Community 49 - "TimeInterval"
Cohesion: 0.18
Nodes (4): Bool, TimeInterval, ClosedRange, TimeInterval

### Community 50 - "TrackWaveformProgressBar"
Cohesion: 0.40
Nodes (4): Bool, Double, TrackWaveformProgressBar, .body

### Community 51 - "DAWProject"
Cohesion: 0.39
Nodes (4): groups, DAWProject, Int, UUID

### Community 52 - "WorkspaceViewModel"
Cohesion: 0.09
Nodes (19): ImportPanelKind, audioFiles, folder, DAWProject, Int, Set, WorkspaceViewModel, .activePitchTrack (+11 more)

### Community 53 - "TrackLaneView"
Cohesion: 0.39
Nodes (5): Gesture, UUID, TrackLaneView, .body, .liveTrack

### Community 54 - "DAWVerticalFaderView"
Cohesion: 0.09
Nodes (25): ClosedRange, Double, Float, String, TrackVolumeSettings, .trackRange, DAWVerticalFaderView, .body (+17 more)

### Community 55 - "DAWSecondaryButtonStyle"
Cohesion: 0.48
Nodes (6): ButtonStyle, .selectedMarkerEditor, DAWIconToolbarButtonStyle, DAWPrimaryButtonStyle, DAWSecondaryButtonStyle, .body

### Community 56 - "AppKit"
Cohesion: 0.17
Nodes (8): App, AppKit, Scene, ProjectFilePanel, URL, SimplePlayApp, ResizablePropertiesSidebar, .body

### Community 57 - "MIDIMappingBarView"
Cohesion: 0.16
Nodes (13): MIDIMappingBarView, .body, .collapsedBar, .devicePickerLabel, .devicePickerTitle, .devicePickerTitleColor, .expandedPanel, .isCompact (+5 more)

### Community 61 - "View"
Cohesion: 0.14
Nodes (16): Configuration, .groupDivider, .pinnedMastersColumn, .markerHeaderRow, AudioDropOverlay, .body, String, TimelineEmptyDropHint (+8 more)

### Community 65 - "WorkspaceView"
Cohesion: 0.15
Nodes (14): Binding, Bool, String, WorkspaceSettingsView, .body, .deleteSectionDialogTitle, .sectionDeletionDialogBinding, Binding (+6 more)

### Community 66 - "SwiftUI"
Cohesion: 0.15
Nodes (7): Commands, ContentView, .body, FileCommands, .body, SwiftUI, UIKit

### Community 68 - "TrackControlButton"
Cohesion: 0.22
Nodes (8): PanKnobView, .body, Bool, Double, String, Void, TrackControlButton, .body

### Community 71 - ".applyImportedStems"
Cohesion: 0.18
Nodes (5): TimelineScrollAlignment, center, leading, start, .transportControls

## Knowledge Gaps
- **260 isolated node(s):** `id`, `name`, `startTime`, `endTime`, `colorHex` (+255 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **3 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `WorkspaceViewModel` connect `WorkspaceViewModel` to `SectionMarkerChipView`, `Foundation`, `ArrangementSection`, `TimelineWorkspacePanel`, `AudioImportService`, `AudioEngineService`, `StandardTrackRole`, `.body`, `Sendable`, `TrackPitchControlView`, `TopToolbarView`, `Bool`, `AudioTrack`, `.body`, `TrackOrganizationService`, `ClipDragInteractionModifier`, `MixerPanelView`, `SupportedAudioFormats`, `MIDINoteAssignment`, `UUID`, `TransportBarView`, `CGFloat`, `PropertiesSidebarView`, `MIDIInputService`, `TimeInterval`, `TrackLaneView`, `AppKit`, `MIDIMappingBarView`, `WorkspaceView`, `SwiftUI`, `.applyImportedStems`?**
  _High betweenness centrality (0.399) - this node is a cross-community bridge._
- **Why does `AudioTrack` connect `AudioTrack` to `SwiftUI`, `MixerPanelView`, `PitchShiftSettings`, `UUID`, `DAWProject`, `Color`, `AudioClip`, `MIDIInputService`, `DAWProject`, `WorkspaceViewModel`, `TrackLaneView`, `Sendable`, `TrackOrganizationService`?**
  _High betweenness centrality (0.093) - this node is a cross-community bridge._
- **Why does `Foundation` connect `Foundation` to `SwiftUI`, `TrackGroup`, `MIDINoteAssignment`, `SupportedAudioFormats`, `PitchShiftSettings`, `DAWProject`, `PropertiesSidebarView`, `AudioClip`, `.standardize`, `AudioImportService`, `AudioEngineService`, `StandardTrackRole`, `SimplePlayProjectArchive`, `Sendable`, `AppKit`, `Testing`?**
  _High betweenness centrality (0.086) - this node is a cross-community bridge._
- **Are the 13 inferred relationships involving `WorkspaceViewModel` (e.g. with `ArrangementPlaybackEngine` and `AudioEngineService`) actually correct?**
  _`WorkspaceViewModel` has 13 INFERRED edges - model-reasoned connections that need verification._
- **Are the 2 inferred relationships involving `AudioEngineService` (e.g. with `WorkspaceViewModel` and `.configureAudioEngine()`) actually correct?**
  _`AudioEngineService` has 2 INFERRED edges - model-reasoned connections that need verification._
- **Are the 4 inferred relationships involving `ArrangementSection` (e.g. with `.body` and `.body`) actually correct?**
  _`ArrangementSection` has 4 INFERRED edges - model-reasoned connections that need verification._
- **Are the 3 inferred relationships involving `AudioTrack` (e.g. with `.duration` and `.hasSoloTracks`) actually correct?**
  _`AudioTrack` has 3 INFERRED edges - model-reasoned connections that need verification._