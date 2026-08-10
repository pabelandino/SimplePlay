# Graph Report - SimplePlay  (2026-08-09)

## Corpus Check
- 87 files · ~39,613 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 1352 nodes · 2967 edges · 68 communities (63 shown, 5 thin omitted)
- Extraction: 91% EXTRACTED · 9% INFERRED · 0% AMBIGUOUS · INFERRED: 277 edges (avg confidence: 0.8)
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
- TrackLaneView
- graphify reference: extra exports and benchmark
- FaderMeterStripView
- graphify reference: query, path, explain
- graphify reference: add a URL and watch a folder
- graphify reference: commit hook and native AGENTS.md integration
- graphify reference: incremental update and cluster-only
- graphify reference: GitHub clone and cross-repo merge
- graphify reference: transcribe video and audio
- extraction-spec.md
- ArrangementSection
- ProjectPersistenceError
- TimelineWorkspacePanel
- Testing
- AudioImportService
- AudioEngineService
- StandardTrackRole
- TopToolbarView
- PersistedProject
- AudioImportDocumentPicker
- .applyImportedStems
- Foundation
- .seek
- .saveProject
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
- .refreshMIDIDevices
- SidebarPanel
- DAWProject
- TimeInterval
- CGFloat
- View
- DAWVerticalFaderView
- TrackControlButton
- MIDILearnTarget
- Sendable
- .loadBucket
- .groupMasterStrip
- .groupVolumeBinding
- .setSelectedTrackPitch
- .format
- .body
- .body
- TrackWaveformProgressBar
- UUID
- .sessionManagement

## God Nodes (most connected - your core abstractions)
1. `WorkspaceViewModel` - 193 edges
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
- `.masterSectionLaneScroll` --calls--> `SectionMarkerLaneView`  [INFERRED]
  SimplePlay/Features/Workspace/Views/TimelineWorkspacePanel.swift → SimplePlay/Features/Workspace/Views/SectionMarkerLaneView.swift
- `.body` --calls--> `WorkspaceView`  [INFERRED]
  SimplePlay/ContentView.swift → SimplePlay/Features/Workspace/Views/WorkspaceView.swift
- `.body` --references--> `ArrangementSection`  [INFERRED]
  SimplePlay/Features/Workspace/Views/SectionMarkerLaneView.swift → SimplePlay/Core/Models/ArrangementSection.swift

## Import Cycles
- None detected.

## Communities (68 total, 5 thin omitted)

### Community 0 - "SimplePlayUITests"
Cohesion: 0.15
Nodes (6): SimplePlayUITests, SimplePlayUITestsLaunchTests, .runsForEachTargetApplicationUIConfiguration, Bool, XCTest, XCTestCase

### Community 1 - "SectionMarkerLaneView"
Cohesion: 0.24
Nodes (15): SectionCreationPreviewView, .body, SectionDragSession, SectionMarkerGhostChipView, .chipWidth, SectionMarkerLaneView, .body, .creationDragMinimumDistance (+7 more)

### Community 2 - "MIDIMappingBarView"
Cohesion: 0.14
Nodes (16): ButtonStyle, MIDIMappingBarView, .collapsedBar, .collapsedBarContent, .devicePickerTitle, .devicePickerTitleColor, .expandedPanel, .isCompact (+8 more)

### Community 3 - "What You Must Do When Invoked"
Cohesion: 0.08
Nodes (24): For /graphify add and --watch, For /graphify query, For the commit hook and native AGENTS.md integration, For --update and --cluster-only, /graphify, Honesty Rules, Interpreter guard for subcommands, Part A - Structural extraction for code files (+16 more)

### Community 4 - "TrackLaneView"
Cohesion: 0.09
Nodes (25): G, GraphicsContext, CGFloat, String, TimeInterval, TimelineRulerScale, ClipDragInteractionModifier, ClipSelectionModifiers (+17 more)

### Community 5 - "graphify reference: extra exports and benchmark"
Cohesion: 0.22
Nodes (8): graphify reference: extra exports and benchmark, Step 6b - Wiki (only if --wiki flag), Step 7 - Neo4j export (only if --neo4j or --neo4j-push flag), Step 7a - FalkorDB export (only if --falkordb or --falkordb-push flag), Step 7b - SVG export (only if --svg flag), Step 7c - GraphML export (only if --graphml flag), Step 7d - MCP server (only if --mcp flag), Step 8 - Token reduction benchmark (only if total_words > 5000)

### Community 6 - "FaderMeterStripView"
Cohesion: 0.15
Nodes (12): .projectMasterStrip, .mainVolumeControl, FaderMeterStripView, .reservesThumbClearance, .showsUnityMark, .usesUnityCenterDecibelScale, Bool, CGFloat (+4 more)

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

### Community 15 - "ProjectPersistenceError"
Cohesion: 0.18
Nodes (10): JSONDecoder, .projectDecoder, JSONEncoder, .pretty, ProjectPersistenceError, .errorDescription, invalidPackage, missingManifest (+2 more)

### Community 16 - "TimelineWorkspacePanel"
Cohesion: 0.06
Nodes (39): DropURLLoader, NSItemProvider, String, URL, PlayheadView, .body, .playheadDragGesture, Bool (+31 more)

### Community 17 - "Testing"
Cohesion: 0.18
Nodes (5): CoreGraphics, SimplePlay, ProjectArchiveTests, SimplePlayTests, Testing

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
Cohesion: 0.23
Nodes (11): DAWIconToolbarButtonStyle, Bool, String, Void, TopToolbarView, .actionButtons, .isCompact, .projectTitle (+3 more)

### Community 22 - "PersistedProject"
Cohesion: 0.34
Nodes (13): Equatable, PersistedClip, PersistedProject, PersistedTrack, Bool, Decoder, Double, Int32 (+5 more)

### Community 23 - "AudioImportDocumentPicker"
Cohesion: 0.07
Nodes (28): FileDocument, FileWrapper, ReadConfiguration, SimplePlayProjectFileDocument, .readableContentTypes, Data, SimplePlayProjectType, UTType (+20 more)

### Community 24 - ".applyImportedStems"
Cohesion: 0.26
Nodes (4): Error, Result, String, URL

### Community 25 - "Foundation"
Cohesion: 0.22
Nodes (5): AVFoundation, CoreAudio, Foundation, Observation, SnapGrid

### Community 26 - ".seek"
Cohesion: 0.18
Nodes (4): .body, Bool, .transportControls, Timer

### Community 27 - ".saveProject"
Cohesion: 0.29
Nodes (4): ProjectFilePanel, String, URL, .body

### Community 28 - "TrackGroup"
Cohesion: 0.27
Nodes (8): Date, Encoder, Decoder, Double, String, TimeInterval, UUID, TrackGroup

### Community 29 - "CodingKeys"
Cohesion: 0.06
Nodes (31): CodingKey, CodingKeys, audioSettings, colorHex, id, isLocked, isMuted, isSnapEnabled (+23 more)

### Community 30 - "PropertiesSidebarView"
Cohesion: 0.14
Nodes (17): PropertiesSidebarView, .body, .masterVolumeBinding, .pitchIsOriginal, .pitchLabel, .sectionCreationHint, .selectedDevice, .selectedDeviceID (+9 more)

### Community 31 - "AudioTrack"
Cohesion: 0.05
Nodes (51): AudioClip, .endTime, Int, String, TimeInterval, URL, UUID, AudioTrack (+43 more)

### Community 32 - "SimplePlayProjectArchive"
Cohesion: 0.16
Nodes (15): Asset, SimplePlayProjectArchive, SimplePlayProjectArchiveError, corruptAsset, corruptManifest, .errorDescription, invalidArchive, Bool (+7 more)

### Community 33 - ".standardize"
Cohesion: 0.23
Nodes (7): StandardizedName, Bool, StandardTrackRole, String, URL, TrackNameStandardizer, TrackNameStandardizerTests

### Community 34 - "MixerPanelView"
Cohesion: 0.12
Nodes (17): MixerPanelView, .body, .channelFaderHeight, .channelFaderWidth, .channelStripWidth, .isCompact, .masterFaderHeight, .mixerHandle (+9 more)

### Community 35 - "SectionMarkerChipView"
Cohesion: 0.17
Nodes (12): NSCursor, ResizeEdge, end, start, SectionMarkerChipView, .body, .chipMoveOrTapGesture, .chipWidth (+4 more)

### Community 36 - "AppKit"
Cohesion: 0.22
Nodes (6): App, AppKit, Scene, SimplePlayApp, ResizablePropertiesSidebar, .body

### Community 37 - "AudioOutputDevice"
Cohesion: 0.22
Nodes (8): AudioDeviceID, Hashable, AudioOutputDevice, AudioDeviceService, Bool, Int, String, .audioSettings

### Community 38 - "TrackPitchControlView"
Cohesion: 0.18
Nodes (12): Binding, Bool, Double, String, UUID, TrackPitchControlView, .menuTitle, .pitchIsOriginal (+4 more)

### Community 39 - "MacWindowTitleBarHidden.swift"
Cohesion: 0.11
Nodes (15): Notification, NSApplicationDelegate, NSEvent, NSObject, NSView, NSViewRepresentable, NSWindow, .body (+7 more)

### Community 40 - "WorkspaceViewModel"
Cohesion: 0.08
Nodes (20): ImportPanelKind, audioFiles, folder, DAWProject, Int, Set, WorkspaceViewModel, .activePitchTrack (+12 more)

### Community 41 - "ProjectPersistenceService"
Cohesion: 0.21
Nodes (8): missingAudioFile, unsupportedVersion, ProjectPersistenceService, Bool, Data, DAWProject, URL, UUID

### Community 42 - "TransportBarView"
Cohesion: 0.06
Nodes (37): Bool, CGFloat, CGSize, Gesture, TimeInterval, TimelineOverviewBar, .barHeight, .body (+29 more)

### Community 43 - "PitchShiftSettings"
Cohesion: 0.27
Nodes (5): PitchShiftSettings, AVAudioUnitTimePitch, Double, Float, PitchShiftSettingsTests

### Community 44 - ".peaks"
Cohesion: 0.09
Nodes (30): CheckedContinuation, Never, Path, clips, Double, Float, Int, MainActor (+22 more)

### Community 45 - "SwiftUI"
Cohesion: 0.19
Nodes (3): SwiftUI, UIKit, UniformTypeIdentifiers

### Community 46 - "AudioSampleRate"
Cohesion: 0.26
Nodes (10): Double, AudioSampleRate, .displayName, .id, rate44100, rate48000, AudioSettings, Int (+2 more)

### Community 47 - "MIDIInputService"
Cohesion: 0.09
Nodes (21): CoreMIDI, Identifiable, MIDINotifyProc, MIDIPacketList, MIDIReadProc, MIDIInputService, MIDISourceInfo, .id (+13 more)

### Community 49 - "SidebarPanel"
Cohesion: 0.31
Nodes (9): .playbackSettings, .sectionEditor, .volumeControls, SidebarLabeledRow, .body, SidebarPanel, .body, Content (+1 more)

### Community 50 - "DAWProject"
Cohesion: 0.31
Nodes (9): DAWProject, .duration, Bool, Double, Int32, String, TimeInterval, UInt8 (+1 more)

### Community 51 - "TimeInterval"
Cohesion: 0.13
Nodes (8): Bool, TimeInterval, SectionDragKind, move, resizeEnd, resizeStart, ClosedRange, TimeInterval

### Community 52 - "CGFloat"
Cohesion: 0.15
Nodes (10): CGFloat, TimelineScrollAlignment, center, leading, start, TimelineScrollRequest, .minimumTimelineZoom, .timelineContentWidth (+2 more)

### Community 53 - "View"
Cohesion: 0.15
Nodes (15): Configuration, .groupDivider, .pinnedMastersColumn, AudioDropOverlay, .body, String, TimelineEmptyDropHint, .body (+7 more)

### Community 54 - "DAWVerticalFaderView"
Cohesion: 0.09
Nodes (25): ClosedRange, Double, Float, String, TrackVolumeSettings, .trackRange, DAWVerticalFaderView, .body (+17 more)

### Community 55 - "TrackControlButton"
Cohesion: 0.22
Nodes (8): PanKnobView, .body, Bool, Double, String, Void, TrackControlButton, .body

### Community 56 - "MIDILearnTarget"
Cohesion: 0.22
Nodes (8): MIDILearnTarget, loopToggle, section, MIDINoteAssignment, .displayName, String, UInt8, UUID

### Community 57 - "Sendable"
Cohesion: 0.43
Nodes (7): Codable, Sendable, SavedProjectDocument, DAWProject, Int, WorkspaceSnapshot, ManifestFile

### Community 58 - ".loadBucket"
Cohesion: 0.53
Nodes (4): CGFloat, Int, WaveformLOD, .requiredLOD

### Community 59 - ".groupMasterStrip"
Cohesion: 0.29
Nodes (3): Float, .mastersStripRow, String

### Community 60 - ".groupVolumeBinding"
Cohesion: 0.36
Nodes (4): .masterVolumeBinding, Binding, Double, UUID

### Community 61 - ".setSelectedTrackPitch"
Cohesion: 0.33
Nodes (3): .selectedTrackPitchBinding, .trackPitch, .pitchMenu

### Community 62 - ".format"
Cohesion: 0.20
Nodes (8): Bool, String, TimeInterval, TimeFormatting, .formattedCurrentTime, .formattedDuration, .selectionInfo, .body

### Community 65 - ".body"
Cohesion: 0.13
Nodes (15): Binding, Bool, String, WorkspaceSettingsView, .body, .deleteSectionDialogTitle, .sectionDeletionDialogBinding, Binding (+7 more)

### Community 66 - ".body"
Cohesion: 0.15
Nodes (10): Commands, ContentView, .body, FileCommands, Content, View, TransportCommands, View (+2 more)

### Community 68 - "TrackWaveformProgressBar"
Cohesion: 0.40
Nodes (4): Bool, Double, TrackWaveformProgressBar, .body

### Community 71 - "UUID"
Cohesion: 0.30
Nodes (4): Double, UUID, .mixerScrollWithPinnedMasters, .body

## Knowledge Gaps
- **250 isolated node(s):** `id`, `name`, `startTime`, `endTime`, `colorHex` (+245 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **5 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `WorkspaceViewModel` connect `WorkspaceViewModel` to `SectionMarkerLaneView`, `MIDIMappingBarView`, `TrackLaneView`, `ArrangementSection`, `TimelineWorkspacePanel`, `AudioImportService`, `AudioEngineService`, `StandardTrackRole`, `TopToolbarView`, `AudioImportDocumentPicker`, `.applyImportedStems`, `Foundation`, `.seek`, `.saveProject`, `PropertiesSidebarView`, `AudioTrack`, `MixerPanelView`, `SectionMarkerChipView`, `AppKit`, `AudioOutputDevice`, `TrackPitchControlView`, `ProjectPersistenceService`, `TransportBarView`, `MIDIInputService`, `.refreshMIDIDevices`, `TimeInterval`, `CGFloat`, `MIDILearnTarget`, `.groupMasterStrip`, `.groupVolumeBinding`, `.setSelectedTrackPitch`, `.format`, `.body`, `.body`, `UUID`, `.sessionManagement`?**
  _High betweenness centrality (0.396) - this node is a cross-community bridge._
- **Why does `Foundation` connect `Foundation` to `SimplePlayProjectArchive`, `.standardize`, `AppKit`, `PitchShiftSettings`, `SwiftUI`, `AudioSampleRate`, `MIDIInputService`, `ProjectPersistenceError`, `Testing`, `DAWProject`, `AudioImportService`, `StandardTrackRole`, `PersistedProject`, `MIDILearnTarget`, `TrackGroup`, `.format`, `AudioTrack`?**
  _High betweenness centrality (0.111) - this node is a cross-community bridge._
- **Why does `AudioTrack` connect `AudioTrack` to `MixerPanelView`, `TrackLaneView`, `UUID`, `WorkspaceViewModel`, `ProjectPersistenceService`, `PitchShiftSettings`, `SwiftUI`, `MIDIInputService`, `DAWProject`, `PersistedProject`, `Sendable`?**
  _High betweenness centrality (0.090) - this node is a cross-community bridge._
- **Are the 13 inferred relationships involving `WorkspaceViewModel` (e.g. with `ArrangementPlaybackEngine` and `AudioEngineService`) actually correct?**
  _`WorkspaceViewModel` has 13 INFERRED edges - model-reasoned connections that need verification._
- **Are the 2 inferred relationships involving `AudioEngineService` (e.g. with `WorkspaceViewModel` and `.configureAudioEngine()`) actually correct?**
  _`AudioEngineService` has 2 INFERRED edges - model-reasoned connections that need verification._
- **Are the 3 inferred relationships involving `AudioTrack` (e.g. with `.duration` and `.hasSoloTracks`) actually correct?**
  _`AudioTrack` has 3 INFERRED edges - model-reasoned connections that need verification._
- **Are the 4 inferred relationships involving `ArrangementSection` (e.g. with `.body` and `.body`) actually correct?**
  _`ArrangementSection` has 4 INFERRED edges - model-reasoned connections that need verification._