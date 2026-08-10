# Graph Report - SimplePlay  (2026-08-10)

## Corpus Check
- 92 files · ~44,520 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 1490 nodes · 3429 edges · 61 communities (58 shown, 3 thin omitted)
- Extraction: 90% EXTRACTED · 10% INFERRED · 0% AMBIGUOUS · INFERRED: 350 edges (avg confidence: 0.8)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `862de09a`
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
- ProjectPersistenceError
- TimelineWorkspacePanel
- TransportBarView
- AudioImportService
- AudioEngineService
- StandardTrackRole
- .applyImportedStems
- SimplePlayProjectArchive
- ProjectPersistenceService
- Sendable
- TopToolbarView
- TimeInterval
- Testing
- TrackGroup
- CodingKeys
- PitchShiftSettings
- AudioTrack
- DAWProject
- WorkspaceSettingsView
- MixerPanelView
- SupportedAudioFormats
- .sessionManagement
- .standardize
- SwiftUI
- MacWindowTitleBarHidden.swift
- .previewRangeForSectionDrag
- WorkspaceView
- SavedProjectDocument
- .loadBucket
- .peaks
- AudioSampleRate
- AudioClip
- MIDIInputService
- TrackWaveformProgressBar
- FileCommands
- WorkspaceViewModel
- DAWVerticalFaderView
- MIDIMappingBarView
- UIKitToolbarMenuButtonRepresentable
- View
- TrackPitchControlView
- .snap
- TrackControlButton
- UUID
- TopToolbarView.swift
- CGFloat

## God Nodes (most connected - your core abstractions)
1. `WorkspaceViewModel` - 215 edges
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
- `.selectedDevice` --references--> `WorkspaceViewModel`  [INFERRED]
  SimplePlay/Features/Workspace/Views/PropertiesSidebarView.swift → SimplePlay/Features/Workspace/ViewModels/WorkspaceViewModel.swift
- `.sectionEdgeGuides` --calls--> `SectionEdgeGuideOverlay`  [INFERRED]
  SimplePlay/Features/Workspace/Views/TimelineWorkspacePanel.swift → SimplePlay/Features/Workspace/Views/SectionMarkerLaneView.swift
- `.body` --calls--> `ContentView`  [INFERRED]
  SimplePlay/SimplePlayApp.swift → SimplePlay/ContentView.swift
- `.body` --references--> `ArrangementSection`  [INFERRED]
  SimplePlay/Features/Workspace/Views/SectionMarkerLaneView.swift → SimplePlay/Core/Models/ArrangementSection.swift

## Import Cycles
- None detected.

## Communities (61 total, 3 thin omitted)

### Community 0 - "SimplePlayUITests"
Cohesion: 0.15
Nodes (6): SimplePlayUITests, SimplePlayUITestsLaunchTests, .runsForEachTargetApplicationUIConfiguration, Bool, XCTest, XCTestCase

### Community 1 - "SectionMarkerChipView"
Cohesion: 0.11
Nodes (29): NSCursor, ResizeEdge, end, start, SectionCreationPreviewView, .body, SectionDragSession, SectionEdgeGuideOverlay (+21 more)

### Community 2 - "PropertiesSidebarView"
Cohesion: 0.06
Nodes (42): AudioDeviceID, Hashable, AudioOutputDevice, AudioDeviceService, Bool, Int, String, Bool (+34 more)

### Community 3 - "What You Must Do When Invoked"
Cohesion: 0.08
Nodes (24): For /graphify add and --watch, For /graphify query, For the commit hook and native AGENTS.md integration, For --update and --cluster-only, /graphify, Honesty Rules, Interpreter guard for subcommands, Part A - Structural extraction for code files (+16 more)

### Community 4 - "TrackLaneView"
Cohesion: 0.09
Nodes (27): G, GraphicsContext, Path, CGFloat, String, TimeInterval, TimelineRulerScale, ClipDragInteractionModifier (+19 more)

### Community 5 - "graphify reference: extra exports and benchmark"
Cohesion: 0.22
Nodes (8): graphify reference: extra exports and benchmark, Step 6b - Wiki (only if --wiki flag), Step 7 - Neo4j export (only if --neo4j or --neo4j-push flag), Step 7a - FalkorDB export (only if --falkordb or --falkordb-push flag), Step 7b - SVG export (only if --svg flag), Step 7c - GraphML export (only if --graphml flag), Step 7d - MCP server (only if --mcp flag), Step 8 - Token reduction benchmark (only if total_words > 5000)

### Community 6 - "Foundation"
Cohesion: 0.16
Nodes (6): AVFoundation, CoreAudio, Foundation, Observation, os, SnapGrid

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
Nodes (42): ArrangementSection, .color, .duration, Bool, Decoder, String, TimeInterval, UInt8 (+34 more)

### Community 15 - "ProjectPersistenceError"
Cohesion: 0.18
Nodes (11): JSONDecoder, .projectDecoder, JSONEncoder, .pretty, ManifestFile, ProjectPersistenceError, .errorDescription, invalidPackage (+3 more)

### Community 16 - "TimelineWorkspacePanel"
Cohesion: 0.10
Nodes (29): PlayheadView, .body, .playheadDragGesture, Bool, CGFloat, Content, Double, Gesture (+21 more)

### Community 17 - "TransportBarView"
Cohesion: 0.06
Nodes (36): Bool, CGFloat, CGSize, Gesture, TimeInterval, TimelineOverviewBar, .barHeight, .body (+28 more)

### Community 18 - "AudioImportService"
Cohesion: 0.12
Nodes (19): LocalizedError, AudioFileStorageService, String, URL, UUID, AudioImportError, emptySelection, .errorDescription (+11 more)

### Community 19 - "AudioEngineService"
Cohesion: 0.05
Nodes (47): AVAudioFile, AVAudioFrameCount, AVAudioMixerNode, AVAudioNode, AVAudioPlayerNode, AVAudioTime, AVAudioUnitEQ, SectionLoopContext (+39 more)

### Community 20 - "StandardTrackRole"
Cohesion: 0.07
Nodes (29): CaseIterable, StandardTrackRole, acousticGuitar, backingVocal, bass, brass, click, countIn (+21 more)

### Community 21 - ".applyImportedStems"
Cohesion: 0.14
Nodes (7): Error, Result, .body, DAWProject, String, URL, .body

### Community 22 - "SimplePlayProjectArchive"
Cohesion: 0.16
Nodes (15): Asset, SimplePlayProjectArchive, SimplePlayProjectArchiveError, corruptAsset, corruptManifest, .errorDescription, invalidArchive, Bool (+7 more)

### Community 23 - "ProjectPersistenceService"
Cohesion: 0.26
Nodes (7): missingAudioFile, unsupportedVersion, ProjectPersistenceService, Bool, DAWProject, URL, UUID

### Community 24 - "Sendable"
Cohesion: 0.25
Nodes (19): Codable, Equatable, Sendable, PersistedClip, PersistedProject, PersistedTrack, Bool, Decoder (+11 more)

### Community 25 - "TopToolbarView"
Cohesion: 0.16
Nodes (17): Bool, String, Void, ToolbarMenuButtonStyleModifier, TopToolbarView, .importButton, .isCompact, .openButton (+9 more)

### Community 26 - "TimeInterval"
Cohesion: 0.20
Nodes (6): SectionEdgeGuides, Bool, TimeInterval, .activeSectionEdgeGuides, .transportControls, Timer

### Community 27 - "Testing"
Cohesion: 0.22
Nodes (4): SimplePlay, ProjectArchiveTests, SimplePlayTests, Testing

### Community 28 - "TrackGroup"
Cohesion: 0.27
Nodes (8): Date, Encoder, Decoder, Double, String, TimeInterval, UUID, TrackGroup

### Community 29 - "CodingKeys"
Cohesion: 0.05
Nodes (44): CodingKey, CodingKeys, colorHex, endTime, id, midiChannel, midiNote, midiUsesControlChange (+36 more)

### Community 30 - "PitchShiftSettings"
Cohesion: 0.31
Nodes (5): PitchShiftSettings, AVAudioUnitTimePitch, Double, Float, PitchShiftSettingsTests

### Community 31 - "AudioTrack"
Cohesion: 0.06
Nodes (44): AudioTrack, .color, .displayName, Bool, Double, StandardTrackRole, String, UUID (+36 more)

### Community 32 - "DAWProject"
Cohesion: 0.31
Nodes (9): DAWProject, .duration, Bool, Double, Int32, String, TimeInterval, UInt8 (+1 more)

### Community 33 - "WorkspaceSettingsView"
Cohesion: 0.22
Nodes (7): Binding, Bool, String, WorkspaceSettingsView, .body, .deleteSectionDialogTitle, .sectionDeletionDialogBinding

### Community 34 - "MixerPanelView"
Cohesion: 0.06
Nodes (36): MixerPanelView, .body, .channelFaderHeight, .channelFaderWidth, .channelStripWidth, .isCompact, .masterFaderHeight, .mastersStripRow (+28 more)

### Community 35 - "SupportedAudioFormats"
Cohesion: 0.05
Nodes (37): FileDocument, FileWrapper, ReadConfiguration, SimplePlayProjectFileDocument, .readableContentTypes, Data, DropURLLoader, NSItemProvider (+29 more)

### Community 36 - ".sessionManagement"
Cohesion: 0.60
Nodes (3): .sessionManagement, .projectSessionMenuItems, .body

### Community 37 - ".standardize"
Cohesion: 0.23
Nodes (7): StandardizedName, Bool, StandardTrackRole, String, URL, TrackNameStandardizer, TrackNameStandardizerTests

### Community 38 - "SwiftUI"
Cohesion: 0.22
Nodes (4): AppKit, ResizablePropertiesSidebar, .body, SwiftUI

### Community 39 - "MacWindowTitleBarHidden.swift"
Cohesion: 0.11
Nodes (15): Notification, NSApplicationDelegate, NSEvent, NSObject, NSView, NSViewRepresentable, NSWindow, .body (+7 more)

### Community 40 - ".previewRangeForSectionDrag"
Cohesion: 0.17
Nodes (5): SectionDragKind, move, resizeEnd, resizeStart, .chipMoveOrTapGesture

### Community 41 - "WorkspaceView"
Cohesion: 0.22
Nodes (9): ContentView, .body, Binding, Bool, String, WorkspaceView, .deleteSectionDialogTitle, .phoneBottomChrome (+1 more)

### Community 42 - "SavedProjectDocument"
Cohesion: 0.18
Nodes (8): SavedProjectDocument, DAWProject, Int, Data, ProjectFilePanel, String, URL, .body

### Community 43 - ".loadBucket"
Cohesion: 0.31
Nodes (5): CoreGraphics, CGFloat, Int, WaveformLOD, .requiredLOD

### Community 44 - ".peaks"
Cohesion: 0.09
Nodes (30): AVAudioPCMBuffer, CheckedContinuation, Never, clips, Double, Float, Int, MainActor (+22 more)

### Community 45 - "AudioSampleRate"
Cohesion: 0.23
Nodes (11): Double, Identifiable, AudioSampleRate, .displayName, .id, rate44100, rate48000, AudioSettings (+3 more)

### Community 46 - "AudioClip"
Cohesion: 0.36
Nodes (7): AudioClip, .endTime, Int, String, TimeInterval, URL, UUID

### Community 47 - "MIDIInputService"
Cohesion: 0.07
Nodes (23): CoreMIDI, MIDINotifyProc, MIDIPacket, MIDIPacketList, MIDIInputEvent, MIDIInputService, MIDISourceInfo, .id (+15 more)

### Community 48 - "TrackWaveformProgressBar"
Cohesion: 0.40
Nodes (4): Bool, Double, TrackWaveformProgressBar, .body

### Community 49 - "FileCommands"
Cohesion: 0.20
Nodes (9): App, Commands, Scene, FileCommands, TransportCommands, View, WorkspaceKeyboardShortcuts, SimplePlayApp (+1 more)

### Community 52 - "WorkspaceViewModel"
Cohesion: 0.07
Nodes (19): Content, View, ClosedRange, Set, WorkspaceViewModel, .activePitchTrack, .canSaveDirectlyToCurrentURL, .isArrangementSectionControllingPlayback (+11 more)

### Community 54 - "DAWVerticalFaderView"
Cohesion: 0.09
Nodes (25): ClosedRange, Double, Float, String, TrackVolumeSettings, .trackRange, DAWVerticalFaderView, .body (+17 more)

### Community 57 - "MIDIMappingBarView"
Cohesion: 0.10
Nodes (25): MIDILearnTarget, loopToggle, section, MIDINoteAssignment, .displayName, Bool, String, UInt8 (+17 more)

### Community 59 - "UIKitToolbarMenuButtonRepresentable"
Cohesion: 0.33
Nodes (7): Coordinator, Context, String, Void, UIKitToolbarMenuButtonRepresentable, UIButton, UIViewRepresentable

### Community 61 - "View"
Cohesion: 0.13
Nodes (17): Configuration, .loopQuickButton, .groupDivider, .pinnedMastersColumn, .markerHeaderRow, AudioDropOverlay, .body, String (+9 more)

### Community 62 - "TrackPitchControlView"
Cohesion: 0.16
Nodes (13): .actionButtons, Binding, Bool, Double, String, UUID, TrackPitchControlView, .menuTitle (+5 more)

### Community 63 - ".snap"
Cohesion: 0.13
Nodes (8): Bool, TimeInterval, ImportPanelKind, audioFiles, folder, Int, .trackHeaderColumnTracksOnly, .importMenuItems

### Community 68 - "TrackControlButton"
Cohesion: 0.22
Nodes (8): PanKnobView, .body, Bool, Double, String, Void, TrackControlButton, .body

### Community 69 - "UUID"
Cohesion: 0.15
Nodes (8): Double, Float, UInt8, UUID, .mixerScrollWithPinnedMasters, .selectedTrackPitchBinding, .body, .pitchMenu

### Community 76 - "TopToolbarView.swift"
Cohesion: 0.24
Nodes (7): ButtonStyle, DAWIconToolbarButtonStyle, DAWLabeledToolbarButtonStyle, DAWPrimaryButtonStyle, Content, .body, UIKit

### Community 77 - "CGFloat"
Cohesion: 0.15
Nodes (10): CGFloat, TimelineScrollAlignment, center, leading, start, TimelineScrollRequest, .minimumTimelineZoom, .timelineContentWidth (+2 more)

## Knowledge Gaps
- **265 isolated node(s):** `id`, `name`, `startTime`, `endTime`, `colorHex` (+260 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **3 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `WorkspaceViewModel` connect `WorkspaceViewModel` to `SectionMarkerChipView`, `PropertiesSidebarView`, `TrackLaneView`, `Foundation`, `ArrangementSection`, `TimelineWorkspacePanel`, `TransportBarView`, `AudioImportService`, `AudioEngineService`, `StandardTrackRole`, `.applyImportedStems`, `ProjectPersistenceService`, `TopToolbarView`, `TimeInterval`, `AudioTrack`, `WorkspaceSettingsView`, `MixerPanelView`, `SupportedAudioFormats`, `.sessionManagement`, `SwiftUI`, `.previewRangeForSectionDrag`, `WorkspaceView`, `SavedProjectDocument`, `MIDIInputService`, `FileCommands`, `MIDIMappingBarView`, `TrackPitchControlView`, `.snap`, `UUID`, `CGFloat`?**
  _High betweenness centrality (0.427) - this node is a cross-community bridge._
- **Why does `ArrangementSection` connect `ArrangementSection` to `DAWProject`, `SectionMarkerChipView`, `PropertiesSidebarView`, `SwiftUI`, `AudioSampleRate`, `MIDIInputService`, `AudioEngineService`, `Sendable`, `MIDIMappingBarView`, `TimeInterval`, `CodingKeys`, `AudioTrack`?**
  _High betweenness centrality (0.088) - this node is a cross-community bridge._
- **Why does `AudioTrack` connect `AudioTrack` to `DAWProject`, `MixerPanelView`, `TrackLaneView`, `UUID`, `SwiftUI`, `AudioSampleRate`, `AudioClip`, `WorkspaceViewModel`, `ProjectPersistenceService`, `Sendable`, `PitchShiftSettings`?**
  _High betweenness centrality (0.078) - this node is a cross-community bridge._
- **Are the 13 inferred relationships involving `WorkspaceViewModel` (e.g. with `ArrangementPlaybackEngine` and `AudioEngineService`) actually correct?**
  _`WorkspaceViewModel` has 13 INFERRED edges - model-reasoned connections that need verification._
- **Are the 2 inferred relationships involving `AudioEngineService` (e.g. with `WorkspaceViewModel` and `.configureAudioEngine()`) actually correct?**
  _`AudioEngineService` has 2 INFERRED edges - model-reasoned connections that need verification._
- **Are the 4 inferred relationships involving `ArrangementSection` (e.g. with `.body` and `.body`) actually correct?**
  _`ArrangementSection` has 4 INFERRED edges - model-reasoned connections that need verification._
- **Are the 3 inferred relationships involving `AudioTrack` (e.g. with `.duration` and `.hasSoloTracks`) actually correct?**
  _`AudioTrack` has 3 INFERRED edges - model-reasoned connections that need verification._