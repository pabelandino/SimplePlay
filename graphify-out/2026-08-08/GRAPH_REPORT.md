# Graph Report - SimplePlay  (2026-08-08)

## Corpus Check
- 70 files · ~26,479 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 829 nodes · 1722 edges · 48 communities (43 shown, 5 thin omitted)
- Extraction: 90% EXTRACTED · 10% INFERRED · 0% AMBIGUOUS · INFERRED: 171 edges (avg confidence: 0.8)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `b0f78528`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- SimplePlayUITests
- TrackGroup
- TransportBarView
- What You Must Do When Invoked
- AudioTrack
- graphify reference: extra exports and benchmark
- .standardize
- graphify reference: query, path, explain
- graphify reference: add a URL and watch a folder
- graphify reference: commit hook and native AGENTS.md integration
- graphify reference: incremental update and cluster-only
- graphify reference: GitHub clone and cross-repo merge
- graphify reference: transcribe video and audio
- extraction-spec.md
- ArrangementSection
- Foundation
- TimelineWorkspacePanel
- TrackLaneView
- .loadStems
- AudioEngineService
- StandardTrackRole
- View
- Sendable
- SimplePlayProjectFileDocument
- .importMultitrack
- .peaks
- SidebarPanel
- UUID
- .applyLoadedProject
- TrackControlButton
- PropertiesSidebarView
- AudioSampleRate
- SimplePlayProjectArchive
- CodingKeys
- SwiftUI
- DAWSecondaryButtonStyle
- Testing
- .loadBucket
- AudioClip
- WorkspaceViewModel
- .body
- TimelineOverviewBar
- ResizablePropertiesSidebar
- AppKit
- AudioImportError
- SnapGrid.swift
- AudioEngineError
- TransportCommands

## God Nodes (most connected - your core abstractions)
1. `WorkspaceViewModel` - 103 edges
2. `AudioTrack` - 34 edges
3. `StandardTrackRole` - 31 edges
4. `ArrangementSection` - 29 edges
5. `PropertiesSidebarView` - 26 edges
6. `AudioClip` - 23 edges
7. `AudioEngineService` - 21 edges
8. `TrackGroup` - 20 edges
9. `WaveformCache` - 19 edges
10. `TimelineWorkspacePanel` - 17 edges

## Surprising Connections (you probably didn't know these)
- `.selectedDevice` --references--> `WorkspaceViewModel`  [INFERRED]
  SimplePlay/Features/Workspace/Views/PropertiesSidebarView.swift → SimplePlay/Features/Workspace/ViewModels/WorkspaceViewModel.swift
- `.body` --calls--> `PropertiesSidebarView`  [INFERRED]
  SimplePlay/UI/Components/ResizablePropertiesSidebar.swift → SimplePlay/Features/Workspace/Views/PropertiesSidebarView.swift
- `.body` --calls--> `TimelineOverviewBar`  [INFERRED]
  SimplePlay/Features/Workspace/Views/TransportBarView.swift → SimplePlay/Features/Workspace/Views/TimelineOverviewBar.swift
- `.duration` --references--> `AudioTrack`  [INFERRED]
  SimplePlay/Core/Models/DAWProject.swift → SimplePlay/Core/Models/AudioTrack.swift
- `.hasSoloTracks` --references--> `AudioTrack`  [INFERRED]
  SimplePlay/Core/Utils/TrackColorPalette.swift → SimplePlay/Core/Models/AudioTrack.swift

## Import Cycles
- None detected.

## Communities (48 total, 5 thin omitted)

### Community 0 - "SimplePlayUITests"
Cohesion: 0.15
Nodes (6): SimplePlayUITests, SimplePlayUITestsLaunchTests, .runsForEachTargetApplicationUIConfiguration, Bool, XCTest, XCTestCase

### Community 1 - "TrackGroup"
Cohesion: 0.16
Nodes (16): Date, Double, String, TimeInterval, UUID, TrackGroup, ImportedStem, DAWProject (+8 more)

### Community 2 - "TransportBarView"
Cohesion: 0.40
Nodes (4): TransportBarView, .body, .loopButtonColor, .timeDisplay

### Community 3 - "What You Must Do When Invoked"
Cohesion: 0.08
Nodes (24): For /graphify add and --watch, For /graphify query, For the commit hook and native AGENTS.md integration, For --update and --cluster-only, /graphify, Honesty Rules, Interpreter guard for subcommands, Part A - Structural extraction for code files (+16 more)

### Community 4 - "AudioTrack"
Cohesion: 0.08
Nodes (30): AudioTrack, .color, .displayName, Bool, Double, StandardTrackRole, String, UUID (+22 more)

### Community 5 - "graphify reference: extra exports and benchmark"
Cohesion: 0.22
Nodes (8): graphify reference: extra exports and benchmark, Step 6b - Wiki (only if --wiki flag), Step 7 - Neo4j export (only if --neo4j or --neo4j-push flag), Step 7a - FalkorDB export (only if --falkordb or --falkordb-push flag), Step 7b - SVG export (only if --svg flag), Step 7c - GraphML export (only if --graphml flag), Step 7d - MCP server (only if --mcp flag), Step 8 - Token reduction benchmark (only if total_words > 5000)

### Community 6 - ".standardize"
Cohesion: 0.23
Nodes (7): StandardizedName, Bool, StandardTrackRole, String, URL, TrackNameStandardizer, TrackNameStandardizerTests

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
Cohesion: 0.09
Nodes (22): CoreMIDI, MIDIEndpointRef, ArrangementSection, .duration, Bool, String, TimeInterval, UInt8 (+14 more)

### Community 15 - "Foundation"
Cohesion: 0.26
Nodes (4): AVFoundation, CoreAudio, Foundation, Observation

### Community 16 - "TimelineWorkspacePanel"
Cohesion: 0.17
Nodes (17): DragGesture, ClosedRange, PlayheadView, .body, Bool, CGFloat, Double, Gesture (+9 more)

### Community 17 - "TrackLaneView"
Cohesion: 0.08
Nodes (28): G, Path, Bool, String, TimeInterval, TimeFormatting, .formattedCurrentTime, .formattedDuration (+20 more)

### Community 18 - ".loadStems"
Cohesion: 0.19
Nodes (10): AudioFileStorageService, String, URL, UUID, AudioImportService, TimeInterval, URL, UUID (+2 more)

### Community 19 - "AudioEngineService"
Cohesion: 0.15
Nodes (13): AVAudioFile, AVAudioMixerNode, AVAudioPlayerNode, AudioEngineService, .masterVolume, ScheduledClip, AVAudioUnitTimePitch, Bool (+5 more)

### Community 20 - "StandardTrackRole"
Cohesion: 0.06
Nodes (36): CaseIterable, SectionPlaybackMode, continueTimeline, continueToNext, .displayName, .id, oneShot, repeatSection (+28 more)

### Community 21 - "View"
Cohesion: 0.20
Nodes (10): Configuration, AudioDropOverlay, .body, String, TimelineEmptyDropHint, .body, DAWTheme, CGFloat (+2 more)

### Community 22 - "Sendable"
Cohesion: 0.07
Nodes (40): Codable, Decoder, Equatable, Sendable, PersistedClip, PersistedProject, PersistedTrack, SavedProjectDocument (+32 more)

### Community 23 - "SimplePlayProjectFileDocument"
Cohesion: 0.07
Nodes (26): FileDocument, FileWrapper, ReadConfiguration, SimplePlayProjectFileDocument, .readableContentTypes, Data, DropURLLoader, NSItemProvider (+18 more)

### Community 24 - ".importMultitrack"
Cohesion: 0.16
Nodes (10): Error, Result, .body, Bool, TimeInterval, String, TimeInterval, URL (+2 more)

### Community 25 - ".peaks"
Cohesion: 0.12
Nodes (24): CheckedContinuation, MainActor, Never, Double, Float, Int, Sendable, String (+16 more)

### Community 26 - "SidebarPanel"
Cohesion: 0.29
Nodes (10): .playbackSettings, .sectionEditor, .trackPitch, .volumeControls, SidebarLabeledRow, .body, SidebarPanel, .body (+2 more)

### Community 27 - "UUID"
Cohesion: 0.16
Nodes (9): UUID, Double, TrackHeaderRowView, .body, .displayColor, .liveTrack, .trackPan, TrackReorderHandle (+1 more)

### Community 28 - ".applyLoadedProject"
Cohesion: 0.16
Nodes (5): Content, View, .body, .transportControls, Timer

### Community 29 - "TrackControlButton"
Cohesion: 0.22
Nodes (8): PanKnobView, .body, Bool, Double, String, Void, TrackControlButton, .body

### Community 30 - "PropertiesSidebarView"
Cohesion: 0.18
Nodes (14): Binding, PropertiesSidebarView, .body, .pitchIsOriginal, .pitchLabel, .selectedDevice, .selectedDeviceID, .selectedTrackIDBinding (+6 more)

### Community 31 - "AudioSampleRate"
Cohesion: 0.13
Nodes (19): AudioDeviceID, Double, Hashable, Identifiable, AudioOutputDevice, AudioSampleRate, .displayName, .id (+11 more)

### Community 32 - "SimplePlayProjectArchive"
Cohesion: 0.16
Nodes (15): Asset, SimplePlayProjectArchive, SimplePlayProjectArchiveError, corruptAsset, corruptManifest, .errorDescription, invalidArchive, Bool (+7 more)

### Community 33 - "CodingKeys"
Cohesion: 0.13
Nodes (17): CodingKey, CodingKeys, clips, colorHex, id, isLocked, isMuted, isSolo (+9 more)

### Community 34 - "SwiftUI"
Cohesion: 0.16
Nodes (8): App, Commands, Scene, ContentView, FileCommands, SimplePlayApp, .body, SwiftUI

### Community 35 - "DAWSecondaryButtonStyle"
Cohesion: 0.33
Nodes (7): ButtonStyle, DAWPrimaryButtonStyle, DAWSecondaryButtonStyle, Bool, String, TopToolbarView, .body

### Community 36 - "Testing"
Cohesion: 0.25
Nodes (4): SimplePlay, ProjectArchiveTests, SimplePlayTests, Testing

### Community 37 - ".loadBucket"
Cohesion: 0.36
Nodes (5): CoreGraphics, CGFloat, Int, WaveformLOD, .requiredLOD

### Community 38 - "AudioClip"
Cohesion: 0.12
Nodes (15): AudioClip, .endTime, Int, String, TimeInterval, URL, UUID, DAWProject (+7 more)

### Community 39 - "WorkspaceViewModel"
Cohesion: 0.16
Nodes (10): CGFloat, Double, Set, WorkspaceViewModel, .activePitchTrack, .pixelsPerSecond, .timelineContentWidth, .body (+2 more)

### Community 40 - ".body"
Cohesion: 0.22
Nodes (5): Bool, Int, .body, .trackHeaderColumn, .trackLanes

### Community 41 - "TimelineOverviewBar"
Cohesion: 0.39
Nodes (5): CGFloat, CGSize, TimeInterval, TimelineOverviewBar, .body

### Community 42 - "ResizablePropertiesSidebar"
Cohesion: 0.40
Nodes (5): ResizablePropertiesSidebar, .body, .collapsedSidebarToggle, .sidebarResizeHandle, CGFloat

### Community 44 - "AudioImportError"
Cohesion: 0.29
Nodes (7): AudioImportError, emptySelection, .errorDescription, storageUnavailable, unreadableFile, unsupportedFormat, String

### Community 46 - "AudioEngineError"
Cohesion: 0.33
Nodes (6): LocalizedError, AudioEngineError, deviceSelectionFailed, engineStartFailed, .errorDescription, String

### Community 48 - "TransportCommands"
Cohesion: 0.50
Nodes (3): TransportCommands, View, WorkspaceKeyboardShortcuts

## Knowledge Gaps
- **137 isolated node(s):** `.duration`, `.endTime`, `rate44100`, `rate48000`, `.id` (+132 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **5 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `WorkspaceViewModel` connect `WorkspaceViewModel` to `TrackGroup`, `TransportBarView`, `AudioTrack`, `ArrangementSection`, `Foundation`, `TimelineWorkspacePanel`, `TrackLaneView`, `.loadStems`, `AudioEngineService`, `StandardTrackRole`, `Sendable`, `SimplePlayProjectFileDocument`, `.importMultitrack`, `UUID`, `.applyLoadedProject`, `PropertiesSidebarView`, `AudioSampleRate`, `SwiftUI`, `DAWSecondaryButtonStyle`, `.body`, `TimelineOverviewBar`, `ResizablePropertiesSidebar`, `TransportCommands`?**
  _High betweenness centrality (0.344) - this node is a cross-community bridge._
- **Why does `Foundation` connect `Foundation` to `SimplePlayProjectArchive`, `TrackGroup`, `SwiftUI`, `AudioTrack`, `Testing`, `AudioClip`, `.standardize`, `AppKit`, `SnapGrid.swift`, `ArrangementSection`, `TrackLaneView`, `.loadStems`, `StandardTrackRole`, `Sendable`, `SimplePlayProjectFileDocument`, `AudioSampleRate`?**
  _High betweenness centrality (0.110) - this node is a cross-community bridge._
- **Why does `AudioTrack` connect `AudioTrack` to `TrackGroup`, `SwiftUI`, `AudioClip`, `WorkspaceViewModel`, `TrackLaneView`, `Sendable`, `UUID`, `AudioSampleRate`?**
  _High betweenness centrality (0.093) - this node is a cross-community bridge._
- **Are the 12 inferred relationships involving `WorkspaceViewModel` (e.g. with `ArrangementPlaybackEngine` and `AudioEngineService`) actually correct?**
  _`WorkspaceViewModel` has 12 INFERRED edges - model-reasoned connections that need verification._
- **Are the 3 inferred relationships involving `AudioTrack` (e.g. with `.duration` and `.hasSoloTracks`) actually correct?**
  _`AudioTrack` has 3 INFERRED edges - model-reasoned connections that need verification._
- **What connects `.duration`, `.endTime`, `rate44100` to the rest of the system?**
  _137 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `What You Must Do When Invoked` be split into smaller, more focused modules?**
  _Cohesion score 0.08 - nodes in this community are weakly interconnected._