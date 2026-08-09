# Graph Report - SimplePlay  (2026-08-09)

## Corpus Check
- 87 files · ~38,525 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 1306 nodes · 2889 edges · 60 communities (55 shown, 5 thin omitted)
- Extraction: 91% EXTRACTED · 9% INFERRED · 0% AMBIGUOUS · INFERRED: 263 edges (avg confidence: 0.8)
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
- TrackLaneView
- graphify reference: extra exports and benchmark
- TimeInterval
- graphify reference: query, path, explain
- graphify reference: add a URL and watch a folder
- graphify reference: commit hook and native AGENTS.md integration
- graphify reference: incremental update and cluster-only
- graphify reference: GitHub clone and cross-repo merge
- graphify reference: transcribe video and audio
- extraction-spec.md
- ArrangementSection
- SavedProjectDocument
- TimelineWorkspacePanel
- .peaks
- AudioImportService
- AudioEngineService
- StandardTrackRole
- View
- PersistedProject
- AudioImportDocumentPicker
- .body
- SwiftUI
- .seek
- .body
- MIDIMappingBarView
- CodingKeys
- PropertiesSidebarView
- Sendable
- SimplePlayProjectArchive
- .standardize
- MixerPanelView
- UUID
- .hex
- DAWProject
- TrackPitchControlView
- MacWindowTitleBarHidden.swift
- WorkspaceViewModel
- ProjectPersistenceService
- TimelineOverviewBar
- AudioTrack
- WaveformClipView
- TransportBarView
- ProjectPersistenceError
- MIDIInputService
- .refreshMIDIDevices
- FaderMeterStripView
- Color
- AudioClip
- DAWProject
- DAWTheme
- DAWVerticalFaderView
- TrackControlButton
- .stem
- .body
- .setZoom
- SectionDragKind

## God Nodes (most connected - your core abstractions)
1. `WorkspaceViewModel` - 189 edges
2. `AudioEngineService` - 48 edges
3. `AudioTrack` - 42 edges
4. `ArrangementSection` - 41 edges
5. `DAWTheme` - 32 edges
6. `StandardTrackRole` - 31 edges
7. `PropertiesSidebarView` - 31 edges
8. `TimelineWorkspacePanel` - 31 edges
9. `CodingKeys` - 29 edges
10. `TrackGroup` - 25 edges

## Surprising Connections (you probably didn't know these)
- `.duration` --references--> `AudioTrack`  [INFERRED]
  SimplePlay/Core/Models/DAWProject.swift → SimplePlay/Core/Models/AudioTrack.swift
- `.hasSoloTracks` --references--> `AudioTrack`  [INFERRED]
  SimplePlay/Core/Utils/TrackColorPalette.swift → SimplePlay/Core/Models/AudioTrack.swift
- `TrackOrganizationServiceTests` --calls--> `TrackOrganizationService`  [EXTRACTED]
  SimplePlayTests/TrackOrganizationServiceTests.swift → SimplePlay/Core/Services/TrackOrganizationService.swift
- `.selectedDevice` --references--> `WorkspaceViewModel`  [INFERRED]
  SimplePlay/Features/Workspace/Views/PropertiesSidebarView.swift → SimplePlay/Features/Workspace/ViewModels/WorkspaceViewModel.swift
- `.masterSectionLaneScroll` --calls--> `SectionMarkerLaneView`  [INFERRED]
  SimplePlay/Features/Workspace/Views/TimelineWorkspacePanel.swift → SimplePlay/Features/Workspace/Views/SectionMarkerLaneView.swift

## Import Cycles
- None detected.

## Communities (60 total, 5 thin omitted)

### Community 0 - "SimplePlayUITests"
Cohesion: 0.15
Nodes (6): SimplePlayUITests, SimplePlayUITestsLaunchTests, .runsForEachTargetApplicationUIConfiguration, Bool, XCTest, XCTestCase

### Community 1 - "SectionMarkerLaneView"
Cohesion: 0.19
Nodes (19): SectionCreationPreviewView, .body, SectionDragSession, SectionMarkerChipView, .chipWidth, .liveSection, SectionMarkerGhostChipView, .chipWidth (+11 more)

### Community 2 - "TrackGroup"
Cohesion: 0.14
Nodes (16): CodingKey, Date, Encoder, CodingKeys, horizontalOffset, id, importedAt, name (+8 more)

### Community 3 - "What You Must Do When Invoked"
Cohesion: 0.08
Nodes (24): For /graphify add and --watch, For /graphify query, For the commit hook and native AGENTS.md integration, For --update and --cluster-only, /graphify, Honesty Rules, Interpreter guard for subcommands, Part A - Structural extraction for code files (+16 more)

### Community 4 - "TrackLaneView"
Cohesion: 0.10
Nodes (22): GraphicsContext, CGFloat, String, TimeInterval, TimelineRulerScale, ClipSelectionModifiers, .isExtending, Bool (+14 more)

### Community 5 - "graphify reference: extra exports and benchmark"
Cohesion: 0.22
Nodes (8): graphify reference: extra exports and benchmark, Step 6b - Wiki (only if --wiki flag), Step 7 - Neo4j export (only if --neo4j or --neo4j-push flag), Step 7a - FalkorDB export (only if --falkordb or --falkordb-push flag), Step 7b - SVG export (only if --svg flag), Step 7c - GraphML export (only if --graphml flag), Step 7d - MCP server (only if --mcp flag), Step 8 - Token reduction benchmark (only if total_words > 5000)

### Community 6 - "TimeInterval"
Cohesion: 0.16
Nodes (6): Bool, TimeInterval, ImportPanelKind, audioFiles, folder, TimeInterval

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
Nodes (40): ArrangementSection, .color, .duration, CodingKeys, colorHex, endTime, id, midiChannel (+32 more)

### Community 15 - "SavedProjectDocument"
Cohesion: 0.18
Nodes (8): SavedProjectDocument, DAWProject, Int, Data, ProjectFilePanel, String, URL, .body

### Community 16 - "TimelineWorkspacePanel"
Cohesion: 0.06
Nodes (41): PlayheadView, .body, .playheadDragGesture, Bool, CGFloat, Content, Double, Gesture (+33 more)

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

### Community 21 - "View"
Cohesion: 0.16
Nodes (17): ButtonStyle, Configuration, DAWIconToolbarButtonStyle, DAWPrimaryButtonStyle, DAWSecondaryButtonStyle, Bool, String, Void (+9 more)

### Community 22 - "PersistedProject"
Cohesion: 0.26
Nodes (17): Codable, Equatable, PersistedClip, PersistedProject, PersistedTrack, Bool, Decoder, Double (+9 more)

### Community 23 - "AudioImportDocumentPicker"
Cohesion: 0.06
Nodes (34): FileDocument, FileWrapper, ReadConfiguration, SimplePlayProjectFileDocument, .readableContentTypes, Data, DropURLLoader, NSItemProvider (+26 more)

### Community 24 - ".body"
Cohesion: 0.22
Nodes (7): Error, Result, .body, String, URL, WorkspaceView, .body

### Community 25 - "SwiftUI"
Cohesion: 0.06
Nodes (20): AVFoundation, CoreAudio, CoreGraphics, Foundation, Observation, SimplePlay, PitchShiftSettings, AVAudioUnitTimePitch (+12 more)

### Community 26 - ".seek"
Cohesion: 0.17
Nodes (4): .body, Bool, .transportControls, Timer

### Community 27 - ".body"
Cohesion: 0.22
Nodes (7): NSCursor, ResizeEdge, end, start, .body, Gesture, View

### Community 28 - "MIDIMappingBarView"
Cohesion: 0.11
Nodes (16): MIDILearnTarget, loopToggle, section, UUID, MIDIMappingBarView, .body, .collapsedBar, .devicePicker (+8 more)

### Community 29 - "CodingKeys"
Cohesion: 0.09
Nodes (23): CodingKeys, audioSettings, colorHex, id, isLocked, isMuted, isSnapEnabled, isSolo (+15 more)

### Community 30 - "PropertiesSidebarView"
Cohesion: 0.05
Nodes (44): MIDINoteAssignment, .displayName, String, UInt8, Bool, String, TimeInterval, TimeFormatting (+36 more)

### Community 31 - "Sendable"
Cohesion: 0.31
Nodes (11): Sendable, ImportedStem, ImportPlacement, appendNewGroup, insertIntoGroup, DAWProject, Int, String (+3 more)

### Community 32 - "SimplePlayProjectArchive"
Cohesion: 0.16
Nodes (15): Asset, SimplePlayProjectArchive, SimplePlayProjectArchiveError, corruptAsset, corruptManifest, .errorDescription, invalidArchive, Bool (+7 more)

### Community 33 - ".standardize"
Cohesion: 0.23
Nodes (7): StandardizedName, Bool, StandardTrackRole, String, URL, TrackNameStandardizer, TrackNameStandardizerTests

### Community 34 - "MixerPanelView"
Cohesion: 0.15
Nodes (14): MixerPanelView, .groupDivider, .isCompact, .masterVolumeBinding, .mixerHandle, .mixerHeader, .orphanTracks, .stripHeight (+6 more)

### Community 35 - "UUID"
Cohesion: 0.10
Nodes (16): Double, Float, Int, UUID, .body, .trackHeaderColumnTracksOnly, Binding, Double (+8 more)

### Community 36 - ".hex"
Cohesion: 0.40
Nodes (5): .defaultColor, Int, StandardTrackRole, String, TrackColorPalette

### Community 37 - "DAWProject"
Cohesion: 0.09
Nodes (28): AudioDeviceID, Double, Hashable, Identifiable, AudioOutputDevice, AudioSampleRate, .displayName, .id (+20 more)

### Community 38 - "TrackPitchControlView"
Cohesion: 0.15
Nodes (13): Binding, Bool, Double, String, UUID, TrackPitchControlView, .menuTitle, .pitchIsOriginal (+5 more)

### Community 39 - "MacWindowTitleBarHidden.swift"
Cohesion: 0.09
Nodes (18): AppKit, Notification, NSApplicationDelegate, NSEvent, NSObject, NSView, NSViewRepresentable, NSWindow (+10 more)

### Community 40 - "WorkspaceViewModel"
Cohesion: 0.08
Nodes (22): CGFloat, ClosedRange, DAWProject, Set, TimelineScrollAlignment, center, leading, start (+14 more)

### Community 41 - "ProjectPersistenceService"
Cohesion: 0.33
Nodes (5): unsupportedVersion, ProjectPersistenceService, Bool, URL, UUID

### Community 42 - "TimelineOverviewBar"
Cohesion: 0.21
Nodes (12): Bool, CGFloat, CGSize, Gesture, TimeInterval, TimelineOverviewBar, .barHeight, .body (+4 more)

### Community 43 - "AudioTrack"
Cohesion: 0.27
Nodes (8): AudioTrack, .color, .displayName, Bool, Double, StandardTrackRole, String, UUID

### Community 44 - "WaveformClipView"
Cohesion: 0.11
Nodes (22): Path, clips, Bool, Double, UUID, WaveformLoadMonitor, CGFloat, Int (+14 more)

### Community 45 - "TransportBarView"
Cohesion: 0.17
Nodes (12): Binding, Bool, Double, String, Void, TransportBarView, .isCompact, .loopButtonColor (+4 more)

### Community 46 - "ProjectPersistenceError"
Cohesion: 0.17
Nodes (11): JSONDecoder, .projectDecoder, JSONEncoder, .pretty, ProjectPersistenceError, .errorDescription, invalidPackage, missingAudioFile (+3 more)

### Community 47 - "MIDIInputService"
Cohesion: 0.10
Nodes (19): CoreMIDI, MIDINotifyProc, MIDIPacketList, MIDIReadProc, MIDIInputService, MIDISourceInfo, .id, Bool (+11 more)

### Community 49 - "FaderMeterStripView"
Cohesion: 0.18
Nodes (10): .projectMasterStrip, FaderMeterStripView, .showsUnityMark, .usesUnityCenterDecibelScale, Bool, CGFloat, ClosedRange, Double (+2 more)

### Community 50 - "Color"
Cohesion: 0.29
Nodes (6): Color, DAWProject, .hasSoloTracks, StandardTrackRole, .fallbackColor, Bool

### Community 51 - "AudioClip"
Cohesion: 0.36
Nodes (7): AudioClip, .endTime, Int, String, TimeInterval, URL, UUID

### Community 52 - "DAWProject"
Cohesion: 0.39
Nodes (4): groups, DAWProject, Int, UUID

### Community 53 - "DAWTheme"
Cohesion: 0.22
Nodes (7): .pinnedMastersColumn, String, .markerHeaderRow, DAWTheme, CGFloat, Double, TimeInterval

### Community 54 - "DAWVerticalFaderView"
Cohesion: 0.09
Nodes (25): ClosedRange, Double, Float, String, TrackVolumeSettings, .trackRange, DAWVerticalFaderView, .body (+17 more)

### Community 55 - "TrackControlButton"
Cohesion: 0.22
Nodes (8): PanKnobView, .body, Bool, Double, String, Void, TrackControlButton, .body

### Community 56 - ".stem"
Cohesion: 0.36
Nodes (3): String, TimeInterval, TrackOrganizationServiceTests

### Community 57 - ".body"
Cohesion: 0.13
Nodes (12): App, Commands, Scene, ContentView, FileCommands, Content, View, TransportCommands (+4 more)

### Community 62 - "SectionDragKind"
Cohesion: 0.40
Nodes (4): SectionDragKind, move, resizeEnd, resizeStart

## Knowledge Gaps
- **229 isolated node(s):** `id`, `name`, `startTime`, `endTime`, `colorHex` (+224 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **5 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `WorkspaceViewModel` connect `WorkspaceViewModel` to `SectionMarkerLaneView`, `TrackLaneView`, `TimeInterval`, `ArrangementSection`, `SavedProjectDocument`, `TimelineWorkspacePanel`, `AudioImportService`, `AudioEngineService`, `StandardTrackRole`, `View`, `AudioImportDocumentPicker`, `.body`, `SwiftUI`, `.seek`, `.body`, `MIDIMappingBarView`, `PropertiesSidebarView`, `Sendable`, `MixerPanelView`, `UUID`, `DAWProject`, `TrackPitchControlView`, `MacWindowTitleBarHidden.swift`, `ProjectPersistenceService`, `TimelineOverviewBar`, `AudioTrack`, `TransportBarView`, `MIDIInputService`, `.refreshMIDIDevices`, `.body`, `.setZoom`, `SectionDragKind`?**
  _High betweenness centrality (0.385) - this node is a cross-community bridge._
- **Why does `Foundation` connect `SwiftUI` to `SimplePlayProjectArchive`, `.standardize`, `TrackGroup`, `DAWProject`, `ProjectPersistenceError`, `MIDIInputService`, `SavedProjectDocument`, `AudioImportService`, `AudioClip`, `StandardTrackRole`, `PersistedProject`, `AudioImportDocumentPicker`, `DAWVerticalFaderView`, `MIDIMappingBarView`, `PropertiesSidebarView`?**
  _High betweenness centrality (0.117) - this node is a cross-community bridge._
- **Why does `AudioTrack` connect `AudioTrack` to `MixerPanelView`, `UUID`, `.hex`, `DAWProject`, `TrackLaneView`, `WorkspaceViewModel`, `ProjectPersistenceService`, `Color`, `AudioClip`, `DAWProject`, `PersistedProject`, `SwiftUI`, `Sendable`?**
  _High betweenness centrality (0.086) - this node is a cross-community bridge._
- **Are the 13 inferred relationships involving `WorkspaceViewModel` (e.g. with `ArrangementPlaybackEngine` and `AudioEngineService`) actually correct?**
  _`WorkspaceViewModel` has 13 INFERRED edges - model-reasoned connections that need verification._
- **Are the 2 inferred relationships involving `AudioEngineService` (e.g. with `WorkspaceViewModel` and `.configureAudioEngine()`) actually correct?**
  _`AudioEngineService` has 2 INFERRED edges - model-reasoned connections that need verification._
- **Are the 3 inferred relationships involving `AudioTrack` (e.g. with `.duration` and `.hasSoloTracks`) actually correct?**
  _`AudioTrack` has 3 INFERRED edges - model-reasoned connections that need verification._
- **Are the 4 inferred relationships involving `ArrangementSection` (e.g. with `.body` and `.body`) actually correct?**
  _`ArrangementSection` has 4 INFERRED edges - model-reasoned connections that need verification._