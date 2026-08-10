# Graph Report - SimplePlay  (2026-08-09)

## Corpus Check
- 87 files · ~39,318 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 1337 nodes · 2936 edges · 71 communities (66 shown, 5 thin omitted)
- Extraction: 91% EXTRACTED · 9% INFERRED · 0% AMBIGUOUS · INFERRED: 267 edges (avg confidence: 0.8)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `ed70f29e`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- SimplePlayUITests
- SectionMarkerLaneView
- MIDIMappingBarView
- What You Must Do When Invoked
- AudioClip
- graphify reference: extra exports and benchmark
- .activeGroupIndex
- graphify reference: query, path, explain
- graphify reference: add a URL and watch a folder
- graphify reference: commit hook and native AGENTS.md integration
- graphify reference: incremental update and cluster-only
- graphify reference: GitHub clone and cross-repo merge
- graphify reference: transcribe video and audio
- extraction-spec.md
- ArrangementPlaybackEngine
- TimelineOverviewBar
- TimelineWorkspacePanel
- Testing
- AudioImportService
- AudioEngineService
- StandardTrackRole
- TopToolbarView
- PersistedProject
- AudioImportDocumentPicker
- TimeInterval
- Foundation
- .seek
- ArrangementSection
- TrackGroup
- CodingKeys
- PropertiesSidebarView
- AudioTrack
- SimplePlayProjectArchive
- .standardize
- MixerPanelView
- SectionMarkerChipView
- AppKit
- AudioOutputDevice
- TrackPitchControlView
- MacWindowTitleBarHidden.swift
- WorkspaceViewModel
- ProjectPersistenceService
- TransportBarView
- PitchShiftSettings
- .peaks
- SwiftUI
- AudioSampleRate
- MIDIInputService
- CodingKeys
- SidebarPanel
- DAWProject
- .configure
- CGFloat
- View
- DAWVerticalFaderView
- TrackControlButton
- Sendable
- WorkspaceView
- .loadBucket
- .nextDistinctHex
- CodingKeys
- .setZoom
- .format
- MIDINoteAssignment
- PlaybackState
- WorkspaceSettingsView
- .body
- TrackWaveformProgressBar
- UUID
- TrackHeaderRowView
- .sessionManagement

## God Nodes (most connected - your core abstractions)
1. `WorkspaceViewModel` - 189 edges
2. `AudioEngineService` - 48 edges
3. `AudioTrack` - 42 edges
4. `ArrangementSection` - 41 edges
5. `MixerPanelView` - 35 edges
6. `DAWTheme` - 35 edges
7. `StandardTrackRole` - 31 edges
8. `PropertiesSidebarView` - 31 edges
9. `TimelineWorkspacePanel` - 31 edges
10. `TransportBarView` - 31 edges

## Surprising Connections (you probably didn't know these)
- `.duration` --references--> `AudioTrack`  [INFERRED]
  SimplePlay/Core/Models/DAWProject.swift → SimplePlay/Core/Models/AudioTrack.swift
- `.selectedDevice` --references--> `WorkspaceViewModel`  [INFERRED]
  SimplePlay/Features/Workspace/Views/PropertiesSidebarView.swift → SimplePlay/Features/Workspace/ViewModels/WorkspaceViewModel.swift
- `.body` --calls--> `PropertiesSidebarView`  [INFERRED]
  SimplePlay/Features/Workspace/Views/WorkspaceSettingsView.swift → SimplePlay/Features/Workspace/Views/PropertiesSidebarView.swift
- `.masterSectionLaneScroll` --calls--> `SectionMarkerLaneView`  [INFERRED]
  SimplePlay/Features/Workspace/Views/TimelineWorkspacePanel.swift → SimplePlay/Features/Workspace/Views/SectionMarkerLaneView.swift
- `.body` --references--> `ArrangementSection`  [INFERRED]
  SimplePlay/Features/Workspace/Views/SectionMarkerLaneView.swift → SimplePlay/Core/Models/ArrangementSection.swift

## Import Cycles
- None detected.

## Communities (71 total, 5 thin omitted)

### Community 0 - "SimplePlayUITests"
Cohesion: 0.15
Nodes (6): SimplePlayUITests, SimplePlayUITestsLaunchTests, .runsForEachTargetApplicationUIConfiguration, Bool, XCTest, XCTestCase

### Community 1 - "SectionMarkerLaneView"
Cohesion: 0.24
Nodes (15): SectionCreationPreviewView, .body, SectionDragSession, SectionMarkerGhostChipView, .chipWidth, SectionMarkerLaneView, .body, .creationDragMinimumDistance (+7 more)

### Community 2 - "MIDIMappingBarView"
Cohesion: 0.16
Nodes (12): MIDIMappingBarView, .body, .collapsedBar, .devicePicker, .devicePickerTitle, .devicePickerTitleColor, .expandedPanel, .isCompact (+4 more)

### Community 3 - "What You Must Do When Invoked"
Cohesion: 0.08
Nodes (24): For /graphify add and --watch, For /graphify query, For the commit hook and native AGENTS.md integration, For --update and --cluster-only, /graphify, Honesty Rules, Interpreter guard for subcommands, Part A - Structural extraction for code files (+16 more)

### Community 4 - "AudioClip"
Cohesion: 0.07
Nodes (33): G, GraphicsContext, AudioClip, .endTime, Int, String, TimeInterval, URL (+25 more)

### Community 5 - "graphify reference: extra exports and benchmark"
Cohesion: 0.22
Nodes (8): graphify reference: extra exports and benchmark, Step 6b - Wiki (only if --wiki flag), Step 7 - Neo4j export (only if --neo4j or --neo4j-push flag), Step 7a - FalkorDB export (only if --falkordb or --falkordb-push flag), Step 7b - SVG export (only if --svg flag), Step 7c - GraphML export (only if --graphml flag), Step 7d - MCP server (only if --mcp flag), Step 8 - Token reduction benchmark (only if total_words > 5000)

### Community 6 - ".activeGroupIndex"
Cohesion: 0.25
Nodes (3): ImportPanelKind, audioFiles, folder

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

### Community 15 - "TimelineOverviewBar"
Cohesion: 0.21
Nodes (13): Bool, CGFloat, CGSize, Gesture, TimeInterval, TimelineOverviewBar, .barHeight, .body (+5 more)

### Community 16 - "TimelineWorkspacePanel"
Cohesion: 0.09
Nodes (28): PlayheadView, .body, .playheadDragGesture, Bool, CGFloat, Content, Double, Gesture (+20 more)

### Community 17 - "Testing"
Cohesion: 0.23
Nodes (4): SimplePlay, ProjectArchiveTests, SimplePlayTests, Testing

### Community 18 - "AudioImportService"
Cohesion: 0.12
Nodes (19): LocalizedError, AudioFileStorageService, String, URL, UUID, AudioImportError, emptySelection, .errorDescription (+11 more)

### Community 19 - "AudioEngineService"
Cohesion: 0.08
Nodes (28): AVAudioFile, AVAudioMixerNode, AVAudioNode, AVAudioPCMBuffer, AVAudioPlayerNode, AVAudioUnitEQ, AudioEngineError, clipLoadFailed (+20 more)

### Community 20 - "StandardTrackRole"
Cohesion: 0.06
Nodes (36): CaseIterable, SectionPlaybackMode, continueTimeline, continueToNext, .displayName, .id, oneShot, repeatSection (+28 more)

### Community 21 - "TopToolbarView"
Cohesion: 0.18
Nodes (15): ButtonStyle, DAWIconToolbarButtonStyle, DAWPrimaryButtonStyle, DAWSecondaryButtonStyle, Bool, String, Void, TopToolbarView (+7 more)

### Community 22 - "PersistedProject"
Cohesion: 0.32
Nodes (15): Codable, Equatable, PersistedClip, PersistedProject, PersistedTrack, Bool, Decoder, Double (+7 more)

### Community 23 - "AudioImportDocumentPicker"
Cohesion: 0.07
Nodes (32): DropURLLoader, NSItemProvider, String, URL, SimplePlayProjectType, UTType, SupportedAudioFormats, .contentTypes (+24 more)

### Community 24 - "TimeInterval"
Cohesion: 0.17
Nodes (7): Error, Result, ClosedRange, String, TimeInterval, URL, .body

### Community 25 - "Foundation"
Cohesion: 0.22
Nodes (5): AVFoundation, CoreAudio, Foundation, Observation, SnapGrid

### Community 26 - ".seek"
Cohesion: 0.17
Nodes (4): .body, Bool, .transportControls, Timer

### Community 27 - "ArrangementSection"
Cohesion: 0.21
Nodes (11): ArrangementSection, .color, .duration, Bool, Decoder, String, TimeInterval, UInt8 (+3 more)

### Community 28 - "TrackGroup"
Cohesion: 0.27
Nodes (8): Date, Encoder, Decoder, Double, String, TimeInterval, UUID, TrackGroup

### Community 29 - "CodingKeys"
Cohesion: 0.09
Nodes (23): CodingKeys, audioSettings, colorHex, id, isLocked, isMuted, isSnapEnabled, isSolo (+15 more)

### Community 30 - "PropertiesSidebarView"
Cohesion: 0.14
Nodes (18): PropertiesSidebarView, .body, .masterVolumeBinding, .pitchIsOriginal, .pitchLabel, .sectionCreationHint, .selectedDevice, .selectedDeviceID (+10 more)

### Community 31 - "AudioTrack"
Cohesion: 0.07
Nodes (36): AudioTrack, .color, .displayName, Bool, Double, StandardTrackRole, String, UUID (+28 more)

### Community 32 - "SimplePlayProjectArchive"
Cohesion: 0.16
Nodes (15): Asset, SimplePlayProjectArchive, SimplePlayProjectArchiveError, corruptAsset, corruptManifest, .errorDescription, invalidArchive, Bool (+7 more)

### Community 33 - ".standardize"
Cohesion: 0.23
Nodes (7): StandardizedName, Bool, StandardTrackRole, String, URL, TrackNameStandardizer, TrackNameStandardizerTests

### Community 34 - "MixerPanelView"
Cohesion: 0.06
Nodes (35): MixerPanelView, .body, .channelFaderHeight, .channelFaderWidth, .channelStripWidth, .isCompact, .masterFaderHeight, .mastersStripRow (+27 more)

### Community 35 - "SectionMarkerChipView"
Cohesion: 0.19
Nodes (11): NSCursor, ResizeEdge, end, start, SectionMarkerChipView, .body, .chipWidth, .liveSection (+3 more)

### Community 36 - "AppKit"
Cohesion: 0.17
Nodes (8): App, AppKit, Scene, ProjectFilePanel, URL, SimplePlayApp, ResizablePropertiesSidebar, .body

### Community 37 - "AudioOutputDevice"
Cohesion: 0.24
Nodes (8): AudioDeviceID, Hashable, AudioOutputDevice, AudioDeviceService, Bool, Int, String, .audioSettings

### Community 38 - "TrackPitchControlView"
Cohesion: 0.15
Nodes (13): Binding, Bool, Double, String, UUID, TrackPitchControlView, .menuTitle, .pitchIsOriginal (+5 more)

### Community 39 - "MacWindowTitleBarHidden.swift"
Cohesion: 0.11
Nodes (15): Notification, NSApplicationDelegate, NSEvent, NSObject, NSView, NSViewRepresentable, NSWindow, .body (+7 more)

### Community 40 - "WorkspaceViewModel"
Cohesion: 0.10
Nodes (14): DAWProject, Set, UInt8, WorkspaceViewModel, .activePitchTrack, .canSaveDirectlyToCurrentURL, .isArrangementSectionControllingPlayback, .isMIDILearnActive (+6 more)

### Community 41 - "ProjectPersistenceService"
Cohesion: 0.07
Nodes (31): FileDocument, FileWrapper, ReadConfiguration, SavedProjectDocument, DAWProject, Int, SimplePlayProjectFileDocument, .readableContentTypes (+23 more)

### Community 42 - "TransportBarView"
Cohesion: 0.11
Nodes (20): Binding, Bool, CGFloat, Double, String, Void, TransportBarStyle, phoneBottomDock (+12 more)

### Community 43 - "PitchShiftSettings"
Cohesion: 0.31
Nodes (5): PitchShiftSettings, AVAudioUnitTimePitch, Double, Float, PitchShiftSettingsTests

### Community 44 - ".peaks"
Cohesion: 0.09
Nodes (30): CheckedContinuation, Never, Path, clips, Double, Float, Int, MainActor (+22 more)

### Community 45 - "SwiftUI"
Cohesion: 0.18
Nodes (3): SwiftUI, UIKit, UniformTypeIdentifiers

### Community 46 - "AudioSampleRate"
Cohesion: 0.26
Nodes (10): Double, AudioSampleRate, .displayName, .id, rate44100, rate48000, AudioSettings, Int (+2 more)

### Community 47 - "MIDIInputService"
Cohesion: 0.10
Nodes (20): CoreMIDI, Identifiable, MIDINotifyProc, MIDIPacketList, MIDIReadProc, MIDIInputService, MIDISourceInfo, .id (+12 more)

### Community 48 - "CodingKeys"
Cohesion: 0.18
Nodes (11): CodingKeys, colorHex, endTime, id, midiChannel, midiNote, name, nextSectionID (+3 more)

### Community 49 - "SidebarPanel"
Cohesion: 0.29
Nodes (10): .playbackSettings, .sectionEditor, .trackPitch, .volumeControls, SidebarLabeledRow, .body, SidebarPanel, .body (+2 more)

### Community 50 - "DAWProject"
Cohesion: 0.31
Nodes (9): DAWProject, .duration, Bool, Double, Int32, String, TimeInterval, UInt8 (+1 more)

### Community 51 - ".configure"
Cohesion: 0.20
Nodes (4): SectionDragKind, move, resizeEnd, resizeStart

### Community 52 - "CGFloat"
Cohesion: 0.17
Nodes (9): CGFloat, TimelineScrollAlignment, center, leading, start, TimelineScrollRequest, .minimumTimelineZoom, .timelineContentWidth (+1 more)

### Community 53 - "View"
Cohesion: 0.13
Nodes (17): Configuration, .groupDivider, .pinnedMastersColumn, .markerHeaderRow, .mixerButton, AudioDropOverlay, .body, String (+9 more)

### Community 54 - "DAWVerticalFaderView"
Cohesion: 0.09
Nodes (25): ClosedRange, Double, Float, String, TrackVolumeSettings, .trackRange, DAWVerticalFaderView, .body (+17 more)

### Community 55 - "TrackControlButton"
Cohesion: 0.22
Nodes (8): PanKnobView, .body, Bool, Double, String, Void, TrackControlButton, .body

### Community 56 - "Sendable"
Cohesion: 0.33
Nodes (5): Sendable, MIDILearnTarget, loopToggle, section, UUID

### Community 57 - "WorkspaceView"
Cohesion: 0.20
Nodes (7): Commands, ContentView, .body, FileCommands, WorkspaceView, .phoneBottomChrome, .body

### Community 58 - ".loadBucket"
Cohesion: 0.31
Nodes (5): CoreGraphics, CGFloat, Int, WaveformLOD, .requiredLOD

### Community 59 - ".nextDistinctHex"
Cohesion: 0.47
Nodes (5): SectionMarkerPalette, .palette, Int, Set, String

### Community 60 - "CodingKeys"
Cohesion: 0.25
Nodes (8): CodingKey, CodingKeys, horizontalOffset, id, importedAt, name, pitchSemitones, volume

### Community 61 - ".setZoom"
Cohesion: 0.43
Nodes (3): .magnificationGesture, .phoneZoomControls, .zoomControls

### Community 62 - ".format"
Cohesion: 0.20
Nodes (8): Bool, String, TimeInterval, TimeFormatting, .formattedCurrentTime, .formattedDuration, .selectionInfo, .body

### Community 63 - "MIDINoteAssignment"
Cohesion: 0.40
Nodes (5): MIDINoteAssignment, .displayName, String, UInt8, .selectedMarkerEditor

### Community 64 - "PlaybackState"
Cohesion: 0.40
Nodes (5): PlaybackState, continuingTimeline, idle, playingSection, waitingToJump

### Community 66 - ".body"
Cohesion: 0.29
Nodes (5): Content, View, TransportCommands, View, WorkspaceKeyboardShortcuts

### Community 68 - "TrackWaveformProgressBar"
Cohesion: 0.40
Nodes (4): Bool, Double, TrackWaveformProgressBar, .body

### Community 71 - "UUID"
Cohesion: 0.16
Nodes (7): Bool, TimeInterval, Double, Float, UUID, .mixerScrollWithPinnedMasters, .body

### Community 73 - "TrackHeaderRowView"
Cohesion: 0.13
Nodes (11): Int, .trackHeaderColumnTracksOnly, Binding, Double, TrackHeaderRowView, .displayColor, .liveTrack, .trackPan (+3 more)

## Knowledge Gaps
- **247 isolated node(s):** `id`, `name`, `startTime`, `endTime`, `colorHex` (+242 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **5 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `WorkspaceViewModel` connect `WorkspaceViewModel` to `SectionMarkerLaneView`, `MIDIMappingBarView`, `AudioClip`, `.activeGroupIndex`, `ArrangementPlaybackEngine`, `TimelineOverviewBar`, `TimelineWorkspacePanel`, `AudioImportService`, `AudioEngineService`, `StandardTrackRole`, `TopToolbarView`, `AudioImportDocumentPicker`, `TimeInterval`, `Foundation`, `.seek`, `PropertiesSidebarView`, `AudioTrack`, `MixerPanelView`, `SectionMarkerChipView`, `AppKit`, `AudioOutputDevice`, `TrackPitchControlView`, `ProjectPersistenceService`, `TransportBarView`, `MIDIInputService`, `.configure`, `CGFloat`, `View`, `Sendable`, `WorkspaceView`, `.setZoom`, `.format`, `WorkspaceSettingsView`, `.body`, `UUID`, `TrackHeaderRowView`, `.sessionManagement`?**
  _High betweenness centrality (0.385) - this node is a cross-community bridge._
- **Why does `Foundation` connect `Foundation` to `SimplePlayProjectArchive`, `.standardize`, `AudioClip`, `AppKit`, `ProjectPersistenceService`, `SwiftUI`, `AudioSampleRate`, `MIDIInputService`, `Testing`, `DAWProject`, `AudioImportService`, `StandardTrackRole`, `PersistedProject`, `DAWVerticalFaderView`, `Sendable`, `.loadBucket`, `TrackGroup`, `.format`?**
  _High betweenness centrality (0.111) - this node is a cross-community bridge._
- **Why does `AudioTrack` connect `AudioTrack` to `MixerPanelView`, `AudioClip`, `UUID`, `WorkspaceViewModel`, `ProjectPersistenceService`, `TrackHeaderRowView`, `PitchShiftSettings`, `SwiftUI`, `MIDIInputService`, `DAWProject`, `PersistedProject`, `Sendable`?**
  _High betweenness centrality (0.087) - this node is a cross-community bridge._
- **Are the 13 inferred relationships involving `WorkspaceViewModel` (e.g. with `ArrangementPlaybackEngine` and `AudioEngineService`) actually correct?**
  _`WorkspaceViewModel` has 13 INFERRED edges - model-reasoned connections that need verification._
- **Are the 2 inferred relationships involving `AudioEngineService` (e.g. with `WorkspaceViewModel` and `.configureAudioEngine()`) actually correct?**
  _`AudioEngineService` has 2 INFERRED edges - model-reasoned connections that need verification._
- **Are the 3 inferred relationships involving `AudioTrack` (e.g. with `.duration` and `.hasSoloTracks`) actually correct?**
  _`AudioTrack` has 3 INFERRED edges - model-reasoned connections that need verification._
- **Are the 4 inferred relationships involving `ArrangementSection` (e.g. with `.body` and `.body`) actually correct?**
  _`ArrangementSection` has 4 INFERRED edges - model-reasoned connections that need verification._