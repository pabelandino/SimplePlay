# Graph Report - SimplePlay  (2026-08-08)

## Corpus Check
- 67 files · ~24,737 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 747 nodes · 1544 edges · 43 communities (40 shown, 3 thin omitted)
- Extraction: 90% EXTRACTED · 10% INFERRED · 0% AMBIGUOUS · INFERRED: 153 edges (avg confidence: 0.8)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `174a1d8a`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- SimplePlayUITests
- TrackGroup
- TransportBarView
- What You Must Do When Invoked
- StandardTrackRole
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
- AudioClip
- .loadStems
- AudioEngineService
- TrackWaveformProgressBar
- View
- Sendable
- SimplePlayProjectFileDocument
- .loadProject
- .peaks
- PropertiesSidebarView
- .body
- WorkspaceViewModel
- Color
- Testing
- SectionPlaybackMode
- SimplePlayProjectArchive
- FileCommands
- SwiftUI
- .importMultitrack
- .chooseSaveURL
- WaveformClipView
- AudioTrack
- DAWProject
- .body
- AudioImportError
- AudioEngineError

## God Nodes (most connected - your core abstractions)
1. `WorkspaceViewModel` - 93 edges
2. `StandardTrackRole` - 38 edges
3. `ArrangementSection` - 29 edges
4. `AudioTrack` - 27 edges
5. `AudioClip` - 21 edges
6. `AudioEngineService` - 20 edges
7. `WaveformCache` - 19 edges
8. `TrackGroup` - 17 edges
9. `PropertiesSidebarView` - 17 edges
10. `DAWProject` - 16 edges

## Surprising Connections (you probably didn't know these)
- `.duration` --references--> `AudioTrack`  [INFERRED]
  SimplePlay/Core/Models/DAWProject.swift → SimplePlay/Core/Models/AudioTrack.swift
- `.selectedDevice` --references--> `WorkspaceViewModel`  [INFERRED]
  SimplePlay/Features/Workspace/Views/PropertiesSidebarView.swift → SimplePlay/Features/Workspace/ViewModels/WorkspaceViewModel.swift
- `.body` --calls--> `PropertiesSidebarView`  [INFERRED]
  SimplePlay/UI/Components/ResizablePropertiesSidebar.swift → SimplePlay/Features/Workspace/Views/PropertiesSidebarView.swift
- `.body` --calls--> `TimelineOverviewBar`  [INFERRED]
  SimplePlay/Features/Workspace/Views/TransportBarView.swift → SimplePlay/Features/Workspace/Views/TimelineOverviewBar.swift
- `.body` --calls--> `ContentView`  [INFERRED]
  SimplePlay/SimplePlayApp.swift → SimplePlay/ContentView.swift

## Import Cycles
- None detected.

## Communities (43 total, 3 thin omitted)

### Community 0 - "SimplePlayUITests"
Cohesion: 0.15
Nodes (6): SimplePlayUITests, SimplePlayUITestsLaunchTests, .runsForEachTargetApplicationUIConfiguration, Bool, XCTest, XCTestCase

### Community 1 - "TrackGroup"
Cohesion: 0.17
Nodes (15): Date, String, TimeInterval, UUID, TrackGroup, ImportedStem, DAWProject, Int (+7 more)

### Community 2 - "TransportBarView"
Cohesion: 0.18
Nodes (9): CGFloat, Double, .timelineContentWidth, .body, .magnificationGesture, TransportBarView, .body, .timeDisplay (+1 more)

### Community 3 - "What You Must Do When Invoked"
Cohesion: 0.08
Nodes (24): For /graphify add and --watch, For /graphify query, For the commit hook and native AGENTS.md integration, For --update and --cluster-only, /graphify, Honesty Rules, Interpreter guard for subcommands, Part A - Structural extraction for code files (+16 more)

### Community 4 - "StandardTrackRole"
Cohesion: 0.08
Nodes (24): StandardTrackRole, acousticGuitar, backingVocal, bass, brass, click, countIn, cue (+16 more)

### Community 5 - "graphify reference: extra exports and benchmark"
Cohesion: 0.22
Nodes (8): graphify reference: extra exports and benchmark, Step 6b - Wiki (only if --wiki flag), Step 7 - Neo4j export (only if --neo4j or --neo4j-push flag), Step 7a - FalkorDB export (only if --falkordb or --falkordb-push flag), Step 7b - SVG export (only if --svg flag), Step 7c - GraphML export (only if --graphml flag), Step 7d - MCP server (only if --mcp flag), Step 8 - Token reduction benchmark (only if total_words > 5000)

### Community 6 - ".standardize"
Cohesion: 0.26
Nodes (6): StandardizedName, Bool, String, URL, TrackNameStandardizer, TrackNameStandardizerTests

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
Cohesion: 0.15
Nodes (16): ArrangementSection, .duration, Bool, String, TimeInterval, UInt8, UUID, ArrangementPlaybackEngine (+8 more)

### Community 15 - "Foundation"
Cohesion: 0.16
Nodes (5): AVFoundation, CoreAudio, Foundation, Observation, SnapGrid

### Community 16 - "TimelineWorkspacePanel"
Cohesion: 0.22
Nodes (13): PlayheadView, .body, CGFloat, Double, Gesture, TimeInterval, Void, TimelineWorkspacePanel (+5 more)

### Community 17 - "AudioClip"
Cohesion: 0.11
Nodes (24): Path, AudioClip, .endTime, Int, String, TimeInterval, URL, UUID (+16 more)

### Community 18 - ".loadStems"
Cohesion: 0.19
Nodes (10): AudioFileStorageService, String, URL, UUID, AudioImportService, TimeInterval, URL, UUID (+2 more)

### Community 19 - "AudioEngineService"
Cohesion: 0.16
Nodes (12): AVAudioFile, AVAudioMixerNode, AVAudioPlayerNode, AudioEngineService, .masterVolume, ScheduledClip, Bool, DAWProject (+4 more)

### Community 20 - "TrackWaveformProgressBar"
Cohesion: 0.40
Nodes (4): Bool, Double, TrackWaveformProgressBar, .body

### Community 21 - "View"
Cohesion: 0.06
Nodes (35): ButtonStyle, Configuration, CGFloat, CGSize, TimeInterval, TimelineOverviewBar, .body, DAWPrimaryButtonStyle (+27 more)

### Community 22 - "Sendable"
Cohesion: 0.09
Nodes (35): Codable, Equatable, Sendable, PersistedClip, PersistedProject, PersistedTrack, SavedProjectDocument, Bool (+27 more)

### Community 23 - "SimplePlayProjectFileDocument"
Cohesion: 0.07
Nodes (26): FileDocument, FileWrapper, ReadConfiguration, SimplePlayProjectFileDocument, .readableContentTypes, Data, DropURLLoader, NSItemProvider (+18 more)

### Community 24 - ".loadProject"
Cohesion: 0.24
Nodes (7): Error, Result, ContentView, .body, URL, WorkspaceView, .body

### Community 25 - ".peaks"
Cohesion: 0.25
Nodes (12): CheckedContinuation, MainActor, Never, Double, Float, Int, Sendable, String (+4 more)

### Community 26 - "PropertiesSidebarView"
Cohesion: 0.07
Nodes (29): Binding, CoreMIDI, MIDIEndpointRef, MIDIOutputService, Bool, UInt8, Bool, String (+21 more)

### Community 27 - ".body"
Cohesion: 0.17
Nodes (9): UUID, Double, TrackHeaderRowView, .body, .displayColor, .liveTrack, .trackPan, TrackReorderHandle (+1 more)

### Community 28 - "WorkspaceViewModel"
Cohesion: 0.14
Nodes (10): ClosedRange, Content, View, .body, Int, Set, WorkspaceViewModel, .pixelsPerSecond (+2 more)

### Community 29 - "Color"
Cohesion: 0.22
Nodes (7): .defaultColor, Color, DAWProject, .hasSoloTracks, Bool, String, TrackColorPalette

### Community 30 - "Testing"
Cohesion: 0.27
Nodes (4): SimplePlay, ProjectArchiveTests, SimplePlayTests, Testing

### Community 31 - "SectionPlaybackMode"
Cohesion: 0.09
Nodes (27): AudioDeviceID, CaseIterable, Double, Hashable, Identifiable, AudioOutputDevice, AudioSampleRate, .displayName (+19 more)

### Community 32 - "SimplePlayProjectArchive"
Cohesion: 0.16
Nodes (15): Asset, SimplePlayProjectArchive, SimplePlayProjectArchiveError, corruptAsset, corruptManifest, .errorDescription, invalidArchive, Bool (+7 more)

### Community 33 - "FileCommands"
Cohesion: 0.24
Nodes (7): Commands, FileCommands, TransportCommands, View, WorkspaceKeyboardShortcuts, .body, ViewModifier

### Community 34 - "SwiftUI"
Cohesion: 0.25
Nodes (4): App, Scene, SimplePlayApp, SwiftUI

### Community 35 - ".importMultitrack"
Cohesion: 0.30
Nodes (4): Bool, TimeInterval, String, TimeInterval

### Community 36 - ".chooseSaveURL"
Cohesion: 0.29
Nodes (4): AppKit, ProjectFilePanel, String, URL

### Community 37 - "WaveformClipView"
Cohesion: 0.11
Nodes (21): CoreGraphics, Bool, Double, UUID, WaveformLoadMonitor, CGFloat, Int, WaveformLOD (+13 more)

### Community 38 - "AudioTrack"
Cohesion: 0.39
Nodes (7): AudioTrack, .color, .displayName, Bool, Double, String, UUID

### Community 39 - "DAWProject"
Cohesion: 0.43
Nodes (7): DAWProject, .duration, Bool, Double, String, TimeInterval, UUID

### Community 40 - ".body"
Cohesion: 0.32
Nodes (4): Bool, .body, .trackHeaderColumn, .trackLanes

### Community 41 - "AudioImportError"
Cohesion: 0.29
Nodes (7): AudioImportError, emptySelection, .errorDescription, storageUnavailable, unreadableFile, unsupportedFormat, String

### Community 42 - "AudioEngineError"
Cohesion: 0.33
Nodes (6): LocalizedError, AudioEngineError, deviceSelectionFailed, engineStartFailed, .errorDescription, String

## Knowledge Gaps
- **122 isolated node(s):** `.duration`, `.endTime`, `rate44100`, `rate48000`, `.id` (+117 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **3 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `WorkspaceViewModel` connect `WorkspaceViewModel` to `TrackGroup`, `TransportBarView`, `ArrangementSection`, `Foundation`, `TimelineWorkspacePanel`, `AudioClip`, `.loadStems`, `AudioEngineService`, `View`, `Sendable`, `SimplePlayProjectFileDocument`, `.loadProject`, `PropertiesSidebarView`, `.body`, `SectionPlaybackMode`, `FileCommands`, `SwiftUI`, `.importMultitrack`, `.body`?**
  _High betweenness centrality (0.333) - this node is a cross-community bridge._
- **Why does `Foundation` connect `Foundation` to `SimplePlayProjectArchive`, `TrackGroup`, `SwiftUI`, `.chooseSaveURL`, `.loadStems`, `Sendable`, `SimplePlayProjectFileDocument`, `PropertiesSidebarView`, `Testing`, `SectionPlaybackMode`?**
  _High betweenness centrality (0.112) - this node is a cross-community bridge._
- **Why does `StandardTrackRole` connect `StandardTrackRole` to `SwiftUI`, `AudioTrack`, `.standardize`, `Sendable`, `Color`, `SectionPlaybackMode`?**
  _High betweenness centrality (0.072) - this node is a cross-community bridge._
- **Are the 12 inferred relationships involving `WorkspaceViewModel` (e.g. with `ArrangementPlaybackEngine` and `AudioEngineService`) actually correct?**
  _`WorkspaceViewModel` has 12 INFERRED edges - model-reasoned connections that need verification._
- **Are the 3 inferred relationships involving `ArrangementSection` (e.g. with `.triggerSection()` and `.repeatsSectionUntilAnotherTrigger()`) actually correct?**
  _`ArrangementSection` has 3 INFERRED edges - model-reasoned connections that need verification._
- **What connects `.duration`, `.endTime`, `rate44100` to the rest of the system?**
  _122 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `What You Must Do When Invoked` be split into smaller, more focused modules?**
  _Cohesion score 0.08 - nodes in this community are weakly interconnected._