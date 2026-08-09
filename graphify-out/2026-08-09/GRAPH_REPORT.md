# Graph Report - SimplePlay  (2026-08-09)

## Corpus Check
- 87 files · ~38,382 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 1301 nodes · 2878 edges · 57 communities (51 shown, 6 thin omitted)
- Extraction: 91% EXTRACTED · 9% INFERRED · 0% AMBIGUOUS · INFERRED: 262 edges (avg confidence: 0.8)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `b0f78528`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- SimplePlayUITests
- SectionMarkerLaneView
- TrackGroup
- What You Must Do When Invoked
- AudioClip
- graphify reference: extra exports and benchmark
- TimeInterval
- graphify reference: query, path, explain
- graphify reference: add a URL and watch a folder
- graphify reference: commit hook and native AGENTS.md integration
- graphify reference: incremental update and cluster-only
- graphify reference: GitHub clone and cross-repo merge
- graphify reference: transcribe video and audio
- extraction-spec.md
- ArrangementPlaybackEngine
- .chooseSaveURL
- TimelineWorkspacePanel
- .peaks
- AudioImportService
- AudioEngineService
- StandardTrackRole
- MIDIMappingBarView
- Sendable
- AudioImportDocumentPicker
- .body
- Foundation
- .seek
- SectionMarkerChipView
- Testing
- CodingKeys
- PropertiesSidebarView
- .nextDistinctHex
- SimplePlayProjectArchive
- .standardize
- MixerPanelView
- UUID
- AudioTrack
- DAWProject
- SwiftUI
- MacWindowTitleBarHidden.swift
- WorkspaceViewModel
- ArrangementSection
- TimelineOverviewBar
- CodingKeys
- WaveformClipView
- TransportBarView
- AppKit
- MIDIInputService
- .applyMIDILearn
- PlaybackState
- WorkspaceKeyboardShortcuts
- CGFloat
- View
- DAWVerticalFaderView
- ContentView
- CoreGraphics
- SectionDragKind

## God Nodes (most connected - your core abstractions)
1. `WorkspaceViewModel` - 185 edges
2. `AudioEngineService` - 48 edges
3. `AudioTrack` - 42 edges
4. `ArrangementSection` - 41 edges
5. `StandardTrackRole` - 31 edges
6. `PropertiesSidebarView` - 31 edges
7. `TimelineWorkspacePanel` - 31 edges
8. `DAWTheme` - 31 edges
9. `CodingKeys` - 29 edges
10. `TrackGroup` - 25 edges

## Surprising Connections (you probably didn't know these)
- `.duration` --references--> `AudioTrack`  [INFERRED]
  SimplePlay/Core/Models/DAWProject.swift → SimplePlay/Core/Models/AudioTrack.swift
- `.selectedDevice` --references--> `WorkspaceViewModel`  [INFERRED]
  SimplePlay/Features/Workspace/Views/PropertiesSidebarView.swift → SimplePlay/Features/Workspace/ViewModels/WorkspaceViewModel.swift
- `.masterSectionLaneScroll` --calls--> `SectionMarkerLaneView`  [INFERRED]
  SimplePlay/Features/Workspace/Views/TimelineWorkspacePanel.swift → SimplePlay/Features/Workspace/Views/SectionMarkerLaneView.swift
- `.body` --calls--> `TimelineOverviewBar`  [INFERRED]
  SimplePlay/Features/Workspace/Views/TransportBarView.swift → SimplePlay/Features/Workspace/Views/TimelineOverviewBar.swift
- `.mainVolumeControl` --calls--> `FaderMeterStripView`  [INFERRED]
  SimplePlay/Features/Workspace/Views/TransportBarView.swift → SimplePlay/UI/Components/FaderMeterStripView.swift

## Import Cycles
- None detected.

## Communities (57 total, 6 thin omitted)

### Community 0 - "SimplePlayUITests"
Cohesion: 0.15
Nodes (6): SimplePlayUITests, SimplePlayUITestsLaunchTests, .runsForEachTargetApplicationUIConfiguration, Bool, XCTest, XCTestCase

### Community 1 - "SectionMarkerLaneView"
Cohesion: 0.24
Nodes (15): SectionCreationPreviewView, .body, SectionDragSession, SectionMarkerGhostChipView, .chipWidth, SectionMarkerLaneView, .body, .creationDragMinimumDistance (+7 more)

### Community 2 - "TrackGroup"
Cohesion: 0.10
Nodes (29): CodingKey, Date, Encoder, CodingKeys, horizontalOffset, id, importedAt, name (+21 more)

### Community 3 - "What You Must Do When Invoked"
Cohesion: 0.08
Nodes (24): For /graphify add and --watch, For /graphify query, For the commit hook and native AGENTS.md integration, For --update and --cluster-only, /graphify, Honesty Rules, Interpreter guard for subcommands, Part A - Structural extraction for code files (+16 more)

### Community 4 - "AudioClip"
Cohesion: 0.08
Nodes (28): GraphicsContext, AudioClip, .endTime, Int, String, TimeInterval, URL, UUID (+20 more)

### Community 5 - "graphify reference: extra exports and benchmark"
Cohesion: 0.22
Nodes (8): graphify reference: extra exports and benchmark, Step 6b - Wiki (only if --wiki flag), Step 7 - Neo4j export (only if --neo4j or --neo4j-push flag), Step 7a - FalkorDB export (only if --falkordb or --falkordb-push flag), Step 7b - SVG export (only if --svg flag), Step 7c - GraphML export (only if --graphml flag), Step 7d - MCP server (only if --mcp flag), Step 8 - Token reduction benchmark (only if total_words > 5000)

### Community 6 - "TimeInterval"
Cohesion: 0.13
Nodes (6): Bool, TimeInterval, ClosedRange, String, TimeInterval, URL

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
Cohesion: 0.21
Nodes (8): ArrangementPlaybackEngine, Bool, TimeInterval, UInt8, ArrangementPlaybackEngineTests, String, TimeInterval, UInt8

### Community 15 - ".chooseSaveURL"
Cohesion: 0.50
Nodes (3): ProjectFilePanel, String, URL

### Community 16 - "TimelineWorkspacePanel"
Cohesion: 0.09
Nodes (29): PlayheadView, .body, .playheadDragGesture, Bool, CGFloat, Content, Double, Gesture (+21 more)

### Community 17 - ".peaks"
Cohesion: 0.25
Nodes (12): CheckedContinuation, Never, Double, Float, Int, MainActor, Sendable, String (+4 more)

### Community 18 - "AudioImportService"
Cohesion: 0.12
Nodes (19): LocalizedError, AudioFileStorageService, String, URL, UUID, AudioImportError, emptySelection, .errorDescription (+11 more)

### Community 19 - "AudioEngineService"
Cohesion: 0.08
Nodes (28): AVAudioFile, AVAudioMixerNode, AVAudioNode, AVAudioPCMBuffer, AVAudioPlayerNode, AVAudioUnitEQ, AudioEngineError, clipLoadFailed (+20 more)

### Community 20 - "StandardTrackRole"
Cohesion: 0.06
Nodes (36): CaseIterable, SectionPlaybackMode, continueTimeline, continueToNext, .displayName, .id, oneShot, repeatSection (+28 more)

### Community 21 - "MIDIMappingBarView"
Cohesion: 0.06
Nodes (39): ButtonStyle, MIDIMappingBarView, .body, .collapsedBar, .devicePicker, .devicePickerTitle, .devicePickerTitleColor, .expandedPanel (+31 more)

### Community 22 - "Sendable"
Cohesion: 0.07
Nodes (48): Codable, Equatable, Sendable, MIDILearnTarget, loopToggle, section, MIDINoteAssignment, .displayName (+40 more)

### Community 23 - "AudioImportDocumentPicker"
Cohesion: 0.05
Nodes (41): FileDocument, FileWrapper, ReadConfiguration, SimplePlayProjectFileDocument, .readableContentTypes, Data, DropURLLoader, NSItemProvider (+33 more)

### Community 24 - ".body"
Cohesion: 0.14
Nodes (7): Error, Result, .body, Bool, DAWProject, WorkspaceView, .body

### Community 25 - "Foundation"
Cohesion: 0.19
Nodes (5): AVFoundation, CoreAudio, Foundation, Observation, SnapGrid

### Community 26 - ".seek"
Cohesion: 0.14
Nodes (8): Content, View, TimelineScrollAlignment, center, leading, start, .transportControls, Timer

### Community 27 - "SectionMarkerChipView"
Cohesion: 0.19
Nodes (11): NSCursor, ResizeEdge, end, start, SectionMarkerChipView, .body, .chipWidth, .liveSection (+3 more)

### Community 28 - "Testing"
Cohesion: 0.23
Nodes (4): SimplePlay, ProjectArchiveTests, SimplePlayTests, Testing

### Community 29 - "CodingKeys"
Cohesion: 0.09
Nodes (23): CodingKeys, audioSettings, colorHex, id, isLocked, isMuted, isSnapEnabled, isSolo (+15 more)

### Community 30 - "PropertiesSidebarView"
Cohesion: 0.05
Nodes (41): Bool, String, TimeInterval, TimeFormatting, .formattedCurrentTime, .formattedDuration, .masterVolumeBinding, PropertiesSidebarView (+33 more)

### Community 31 - ".nextDistinctHex"
Cohesion: 0.31
Nodes (7): sections, SectionMarkerPalette, .palette, Int, Set, String, SectionMarkerPaletteTests

### Community 32 - "SimplePlayProjectArchive"
Cohesion: 0.16
Nodes (15): Asset, SimplePlayProjectArchive, SimplePlayProjectArchiveError, corruptAsset, corruptManifest, .errorDescription, invalidArchive, Bool (+7 more)

### Community 33 - ".standardize"
Cohesion: 0.23
Nodes (7): StandardizedName, Bool, StandardTrackRole, String, URL, TrackNameStandardizer, TrackNameStandardizerTests

### Community 34 - "MixerPanelView"
Cohesion: 0.07
Nodes (33): MixerPanelView, .body, .groupDivider, .isCompact, .mixerHandle, .mixerHeader, .orphanTracks, .pinnedMastersColumn (+25 more)

### Community 35 - "UUID"
Cohesion: 0.12
Nodes (8): Double, Float, UUID, .selectedTrackPitchBinding, .magnificationGesture, .body, .body, .zoomControls

### Community 36 - "AudioTrack"
Cohesion: 0.06
Nodes (36): AudioTrack, .color, .displayName, Bool, Double, StandardTrackRole, String, UUID (+28 more)

### Community 37 - "DAWProject"
Cohesion: 0.09
Nodes (28): AudioDeviceID, Double, Hashable, Identifiable, AudioOutputDevice, AudioSampleRate, .displayName, .id (+20 more)

### Community 38 - "SwiftUI"
Cohesion: 0.18
Nodes (5): Bool, Double, TrackWaveformProgressBar, .body, SwiftUI

### Community 39 - "MacWindowTitleBarHidden.swift"
Cohesion: 0.11
Nodes (15): Notification, NSApplicationDelegate, NSEvent, NSObject, NSView, NSViewRepresentable, NSWindow, .body (+7 more)

### Community 40 - "WorkspaceViewModel"
Cohesion: 0.09
Nodes (18): ImportPanelKind, audioFiles, folder, Int, Set, WorkspaceViewModel, .activePitchTrack, .canSaveDirectlyToCurrentURL (+10 more)

### Community 41 - "ArrangementSection"
Cohesion: 0.31
Nodes (9): ArrangementSection, .color, .duration, Bool, Decoder, String, TimeInterval, UInt8 (+1 more)

### Community 42 - "TimelineOverviewBar"
Cohesion: 0.23
Nodes (11): Bool, CGFloat, CGSize, Gesture, TimeInterval, TimelineOverviewBar, .barHeight, .body (+3 more)

### Community 43 - "CodingKeys"
Cohesion: 0.18
Nodes (11): CodingKeys, colorHex, endTime, id, midiChannel, midiNote, name, nextSectionID (+3 more)

### Community 44 - "WaveformClipView"
Cohesion: 0.11
Nodes (22): Path, clips, Bool, Double, UUID, WaveformLoadMonitor, CGFloat, Int (+14 more)

### Community 45 - "TransportBarView"
Cohesion: 0.17
Nodes (12): Binding, Bool, Double, String, Void, TransportBarView, .body, .isCompact (+4 more)

### Community 46 - "AppKit"
Cohesion: 0.22
Nodes (6): App, AppKit, Scene, SimplePlayApp, ResizablePropertiesSidebar, .body

### Community 47 - "MIDIInputService"
Cohesion: 0.10
Nodes (19): CoreMIDI, MIDINotifyProc, MIDIPacketList, MIDIReadProc, MIDIInputService, MIDISourceInfo, .id, Bool (+11 more)

### Community 49 - "PlaybackState"
Cohesion: 0.40
Nodes (5): PlaybackState, continuingTimeline, idle, playingSection, waitingToJump

### Community 51 - "CGFloat"
Cohesion: 0.33
Nodes (4): CGFloat, TimelineScrollRequest, .timelineContentWidth, .sectionCreationGesture

### Community 53 - "View"
Cohesion: 0.17
Nodes (12): Configuration, .markerHeaderRow, .mixerButton, AudioDropOverlay, .body, String, TimelineEmptyDropHint, .body (+4 more)

### Community 54 - "DAWVerticalFaderView"
Cohesion: 0.09
Nodes (25): ClosedRange, Double, Float, String, TrackVolumeSettings, .trackRange, DAWVerticalFaderView, .body (+17 more)

### Community 57 - "ContentView"
Cohesion: 0.29
Nodes (6): Commands, ContentView, FileCommands, TransportCommands, .body, .body

### Community 62 - "SectionDragKind"
Cohesion: 0.40
Nodes (4): SectionDragKind, move, resizeEnd, resizeStart

## Knowledge Gaps
- **229 isolated node(s):** `id`, `name`, `startTime`, `endTime`, `colorHex` (+224 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **6 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `WorkspaceViewModel` connect `WorkspaceViewModel` to `SectionMarkerLaneView`, `TrackGroup`, `AudioClip`, `TimeInterval`, `ArrangementPlaybackEngine`, `TimelineWorkspacePanel`, `AudioImportService`, `AudioEngineService`, `StandardTrackRole`, `MIDIMappingBarView`, `Sendable`, `AudioImportDocumentPicker`, `.body`, `Foundation`, `.seek`, `SectionMarkerChipView`, `PropertiesSidebarView`, `MixerPanelView`, `UUID`, `AudioTrack`, `DAWProject`, `TimelineOverviewBar`, `TransportBarView`, `AppKit`, `MIDIInputService`, `.applyMIDILearn`, `WorkspaceKeyboardShortcuts`, `CGFloat`, `View`, `ContentView`, `SectionDragKind`?**
  _High betweenness centrality (0.376) - this node is a cross-community bridge._
- **Why does `Foundation` connect `Foundation` to `SimplePlayProjectArchive`, `.standardize`, `TrackGroup`, `AudioClip`, `DAWProject`, `SwiftUI`, `AppKit`, `MIDIInputService`, `AudioImportService`, `AudioEngineService`, `StandardTrackRole`, `Sendable`, `AudioImportDocumentPicker`, `DAWVerticalFaderView`, `CoreGraphics`, `Testing`, `PropertiesSidebarView`?**
  _High betweenness centrality (0.114) - this node is a cross-community bridge._
- **Why does `AudioTrack` connect `AudioTrack` to `TrackGroup`, `UUID`, `AudioClip`, `DAWProject`, `SwiftUI`, `MixerPanelView`, `WorkspaceViewModel`, `Sendable`?**
  _High betweenness centrality (0.086) - this node is a cross-community bridge._
- **Are the 13 inferred relationships involving `WorkspaceViewModel` (e.g. with `ArrangementPlaybackEngine` and `AudioEngineService`) actually correct?**
  _`WorkspaceViewModel` has 13 INFERRED edges - model-reasoned connections that need verification._
- **Are the 2 inferred relationships involving `AudioEngineService` (e.g. with `WorkspaceViewModel` and `.configureAudioEngine()`) actually correct?**
  _`AudioEngineService` has 2 INFERRED edges - model-reasoned connections that need verification._
- **Are the 3 inferred relationships involving `AudioTrack` (e.g. with `.duration` and `.hasSoloTracks`) actually correct?**
  _`AudioTrack` has 3 INFERRED edges - model-reasoned connections that need verification._
- **Are the 4 inferred relationships involving `ArrangementSection` (e.g. with `.body` and `.body`) actually correct?**
  _`ArrangementSection` has 4 INFERRED edges - model-reasoned connections that need verification._