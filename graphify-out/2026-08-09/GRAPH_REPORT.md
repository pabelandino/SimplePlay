# Graph Report - SimplePlay  (2026-08-09)

## Corpus Check
- 88 files · ~42,829 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 1438 nodes · 3272 edges · 64 communities (61 shown, 3 thin omitted)
- Extraction: 89% EXTRACTED · 11% INFERRED · 0% AMBIGUOUS · INFERRED: 344 edges (avg confidence: 0.8)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `862de09a`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- SimplePlayUITests
- SectionMarkerChipView
- AudioOutputDevice
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
- SectionPlaybackMode
- TimelineWorkspacePanel
- TransportBarView
- AudioImportService
- AudioEngineService
- StandardTrackRole
- TimeInterval
- SimplePlayProjectArchive
- Equatable
- CodingKeys
- TopToolbarView
- Bool
- AudioFileStorageService
- Codable
- CodingKeys
- Testing
- AudioTrack
- AudioImportError
- ProjectPersistenceService
- MixerPanelView
- SupportedAudioFormats
- .chooseSaveURL
- .standardize
- PitchShiftSettings
- MacWindowTitleBarHidden.swift
- DAWProject
- SwiftUI
- CGFloat
- .peaks
- AudioSampleRate
- PropertiesSidebarView
- MIDIInputService
- WorkspaceViewModel
- ProjectPersistenceError
- DAWVerticalFaderView
- TopToolbarView.swift
- AppKit
- MIDIMappingBarView
- TrackHeaderRowView
- UIKitToolbarMenuButtonRepresentable
- ContentView
- View
- TrackPitchControlView
- .snap
- .body
- .loadBucket
- TrackControlButton
- UUID
- Kind

## God Nodes (most connected - your core abstractions)
1. `WorkspaceViewModel` - 203 edges
2. `ArrangementSection` - 48 edges
3. `AudioEngineService` - 48 edges
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
- `.actionButtons` --calls--> `TrackPitchControlView`  [INFERRED]
  SimplePlay/Features/Workspace/Views/TopToolbarView.swift → SimplePlay/Features/Workspace/Views/TrackPitchControlView.swift
- `.body` --calls--> `WorkspaceView`  [INFERRED]
  SimplePlay/ContentView.swift → SimplePlay/Features/Workspace/Views/WorkspaceView.swift
- `.chipBody` --references--> `ArrangementSection`  [INFERRED]
  SimplePlay/Features/Workspace/Views/SectionMarkerLaneView.swift → SimplePlay/Core/Models/ArrangementSection.swift

## Import Cycles
- None detected.

## Communities (64 total, 3 thin omitted)

### Community 0 - "SimplePlayUITests"
Cohesion: 0.15
Nodes (6): SimplePlayUITests, SimplePlayUITestsLaunchTests, .runsForEachTargetApplicationUIConfiguration, Bool, XCTest, XCTestCase

### Community 1 - "SectionMarkerChipView"
Cohesion: 0.10
Nodes (32): NSCursor, ResizeEdge, end, start, SectionCreationPreviewView, .body, SectionDragSession, SectionEdgeGuideOverlay (+24 more)

### Community 2 - "AudioOutputDevice"
Cohesion: 0.24
Nodes (7): AudioDeviceID, Hashable, AudioOutputDevice, AudioDeviceService, Bool, Int, String

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
Nodes (6): AVFoundation, CoreAudio, Foundation, Observation, SnapGrid, TimeFormatting

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

### Community 15 - "SectionPlaybackMode"
Cohesion: 0.14
Nodes (13): CaseIterable, Identifiable, SectionPlaybackMode, continueTimeline, continueToNext, .displayName, .id, oneShot (+5 more)

### Community 16 - "TimelineWorkspacePanel"
Cohesion: 0.10
Nodes (29): PlayheadView, .body, .playheadDragGesture, Bool, CGFloat, Content, Double, Gesture (+21 more)

### Community 17 - "TransportBarView"
Cohesion: 0.07
Nodes (36): Bool, CGFloat, CGSize, Gesture, TimeInterval, TimelineOverviewBar, .barHeight, .body (+28 more)

### Community 18 - "AudioImportService"
Cohesion: 0.27
Nodes (8): AudioImportService, ImportedStemsResult, String, TimeInterval, URL, UUID, Bool, URL

### Community 19 - "AudioEngineService"
Cohesion: 0.08
Nodes (28): AVAudioFile, AVAudioMixerNode, AVAudioNode, AVAudioPCMBuffer, AVAudioPlayerNode, AVAudioUnitEQ, AudioEngineError, clipLoadFailed (+20 more)

### Community 20 - "StandardTrackRole"
Cohesion: 0.08
Nodes (24): StandardTrackRole, acousticGuitar, backingVocal, bass, brass, click, countIn, cue (+16 more)

### Community 21 - "TimeInterval"
Cohesion: 0.18
Nodes (5): SectionEdgeGuides, String, TimeInterval, URL, .activeSectionEdgeGuides

### Community 22 - "SimplePlayProjectArchive"
Cohesion: 0.16
Nodes (15): Asset, SimplePlayProjectArchive, SimplePlayProjectArchiveError, corruptAsset, corruptManifest, .errorDescription, invalidArchive, Bool (+7 more)

### Community 23 - "Equatable"
Cohesion: 0.34
Nodes (13): Equatable, PersistedClip, PersistedProject, PersistedTrack, Bool, Decoder, Double, Int32 (+5 more)

### Community 24 - "CodingKeys"
Cohesion: 0.10
Nodes (20): CodingKey, CodingKeys, colorHex, endTime, id, midiChannel, midiNote, midiUsesControlChange (+12 more)

### Community 25 - "TopToolbarView"
Cohesion: 0.17
Nodes (16): Bool, String, Void, ToolbarMenuButtonStyleModifier, TopToolbarView, .actionButtons, .importButton, .importMenuItems (+8 more)

### Community 26 - "Bool"
Cohesion: 0.13
Nodes (9): .body, Bool, UInt8, TimelineScrollAlignment, center, leading, start, .transportControls (+1 more)

### Community 27 - "AudioFileStorageService"
Cohesion: 0.43
Nodes (4): AudioFileStorageService, String, URL, UUID

### Community 28 - "Codable"
Cohesion: 0.26
Nodes (8): Codable, SavedProjectDocument, DAWProject, Int, WorkspaceSnapshot, ManifestFile, Data, .body

### Community 29 - "CodingKeys"
Cohesion: 0.08
Nodes (24): CodingKeys, audioSettings, colorHex, id, isLocked, isMuted, isSnapEnabled, isSolo (+16 more)

### Community 30 - "Testing"
Cohesion: 0.23
Nodes (4): SimplePlay, ProjectArchiveTests, SimplePlayTests, Testing

### Community 31 - "AudioTrack"
Cohesion: 0.05
Nodes (52): Date, Encoder, Sendable, AudioClip, .endTime, Int, String, TimeInterval (+44 more)

### Community 32 - "AudioImportError"
Cohesion: 0.29
Nodes (7): LocalizedError, AudioImportError, emptySelection, .errorDescription, storageUnavailable, unreadableFile, unsupportedFormat

### Community 33 - "ProjectPersistenceService"
Cohesion: 0.26
Nodes (7): missingAudioFile, unsupportedVersion, ProjectPersistenceService, Bool, DAWProject, URL, UUID

### Community 34 - "MixerPanelView"
Cohesion: 0.05
Nodes (38): MixerPanelView, .body, .channelFaderHeight, .channelFaderWidth, .channelStripWidth, .isCompact, .masterFaderHeight, .mastersStripRow (+30 more)

### Community 35 - "SupportedAudioFormats"
Cohesion: 0.05
Nodes (37): FileDocument, FileWrapper, ReadConfiguration, SimplePlayProjectFileDocument, .readableContentTypes, Data, DropURLLoader, NSItemProvider (+29 more)

### Community 36 - ".chooseSaveURL"
Cohesion: 0.50
Nodes (3): ProjectFilePanel, String, URL

### Community 37 - ".standardize"
Cohesion: 0.25
Nodes (7): StandardizedName, Bool, StandardTrackRole, String, URL, TrackNameStandardizer, TrackNameStandardizerTests

### Community 38 - "PitchShiftSettings"
Cohesion: 0.31
Nodes (5): PitchShiftSettings, AVAudioUnitTimePitch, Double, Float, PitchShiftSettingsTests

### Community 39 - "MacWindowTitleBarHidden.swift"
Cohesion: 0.11
Nodes (15): Notification, NSApplicationDelegate, NSEvent, NSObject, NSView, NSViewRepresentable, NSWindow, .body (+7 more)

### Community 41 - "DAWProject"
Cohesion: 0.31
Nodes (9): DAWProject, .duration, Bool, Double, Int32, String, TimeInterval, UInt8 (+1 more)

### Community 42 - "SwiftUI"
Cohesion: 0.16
Nodes (8): .projectSessionButton, ProjectSessionToolbarMenuButton, Bool, Double, TrackWaveformProgressBar, .body, SwiftUI, UIKit

### Community 43 - "CGFloat"
Cohesion: 0.14
Nodes (10): SectionDragKind, move, resizeEnd, resizeStart, CGFloat, TimelineScrollRequest, .minimumTimelineZoom, .timelineContentWidth (+2 more)

### Community 44 - ".peaks"
Cohesion: 0.10
Nodes (29): CheckedContinuation, Never, clips, Double, Float, Int, MainActor, Sendable (+21 more)

### Community 45 - "AudioSampleRate"
Cohesion: 0.26
Nodes (10): Double, AudioSampleRate, .displayName, .id, rate44100, rate48000, AudioSettings, Int (+2 more)

### Community 46 - "PropertiesSidebarView"
Cohesion: 0.07
Nodes (38): Bool, String, TimeInterval, .formattedCurrentTime, .formattedDuration, PropertiesSidebarView, .audioSettings, .body (+30 more)

### Community 47 - "MIDIInputService"
Cohesion: 0.07
Nodes (23): CoreMIDI, MIDINotifyProc, MIDIPacket, MIDIPacketList, MIDIInputEvent, MIDIInputService, MIDISourceInfo, .id (+15 more)

### Community 52 - "WorkspaceViewModel"
Cohesion: 0.08
Nodes (16): Content, View, ClosedRange, Set, WorkspaceViewModel, .activePitchTrack, .canSaveDirectlyToCurrentURL, .isArrangementSectionControllingPlayback (+8 more)

### Community 53 - "ProjectPersistenceError"
Cohesion: 0.18
Nodes (10): JSONDecoder, .projectDecoder, JSONEncoder, .pretty, ProjectPersistenceError, .errorDescription, invalidPackage, missingManifest (+2 more)

### Community 54 - "DAWVerticalFaderView"
Cohesion: 0.09
Nodes (25): ClosedRange, Double, Float, String, TrackVolumeSettings, .trackRange, DAWVerticalFaderView, .body (+17 more)

### Community 55 - "TopToolbarView.swift"
Cohesion: 0.36
Nodes (6): ButtonStyle, DAWIconToolbarButtonStyle, DAWLabeledToolbarButtonStyle, DAWPrimaryButtonStyle, Content, .body

### Community 56 - "AppKit"
Cohesion: 0.22
Nodes (6): App, AppKit, Scene, SimplePlayApp, ResizablePropertiesSidebar, .body

### Community 57 - "MIDIMappingBarView"
Cohesion: 0.10
Nodes (25): MIDILearnTarget, loopToggle, section, MIDINoteAssignment, .displayName, Bool, String, UInt8 (+17 more)

### Community 58 - "TrackHeaderRowView"
Cohesion: 0.13
Nodes (11): Int, .trackHeaderColumnTracksOnly, Binding, Double, TrackHeaderRowView, .displayColor, .liveTrack, .trackPan (+3 more)

### Community 59 - "UIKitToolbarMenuButtonRepresentable"
Cohesion: 0.29
Nodes (8): Coordinator, .body, Context, String, Void, UIKitToolbarMenuButtonRepresentable, UIButton, UIViewRepresentable

### Community 60 - "ContentView"
Cohesion: 0.20
Nodes (8): Commands, ContentView, .body, FileCommands, TransportCommands, View, WorkspaceKeyboardShortcuts, .body

### Community 61 - "View"
Cohesion: 0.13
Nodes (17): Configuration, .loopQuickButton, .groupDivider, .pinnedMastersColumn, .markerHeaderRow, AudioDropOverlay, .body, String (+9 more)

### Community 62 - "TrackPitchControlView"
Cohesion: 0.18
Nodes (13): Binding, Bool, Double, String, UUID, TrackPitchControlView, .menuTitle, .pitchIsOriginal (+5 more)

### Community 63 - ".snap"
Cohesion: 0.22
Nodes (5): Bool, TimeInterval, ImportPanelKind, audioFiles, folder

### Community 65 - ".body"
Cohesion: 0.13
Nodes (11): Error, Result, DAWProject, Binding, Bool, String, WorkspaceSettingsView, .body (+3 more)

### Community 66 - ".loadBucket"
Cohesion: 0.31
Nodes (5): CoreGraphics, CGFloat, Int, WaveformLOD, .requiredLOD

### Community 68 - "TrackControlButton"
Cohesion: 0.22
Nodes (8): PanKnobView, .body, Bool, Double, String, Void, TrackControlButton, .body

### Community 69 - "UUID"
Cohesion: 0.14
Nodes (10): Double, Float, UUID, .masterVolumeBinding, .mixerScrollWithPinnedMasters, Binding, Double, UUID (+2 more)

### Community 70 - "Kind"
Cohesion: 0.67
Nodes (3): Kind, controlChange, noteOn

## Knowledge Gaps
- **260 isolated node(s):** `id`, `name`, `startTime`, `endTime`, `colorHex` (+255 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **3 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `WorkspaceViewModel` connect `WorkspaceViewModel` to `SectionMarkerChipView`, `AudioOutputDevice`, `TrackLaneView`, `Foundation`, `ArrangementSection`, `SectionPlaybackMode`, `TimelineWorkspacePanel`, `TransportBarView`, `AudioImportService`, `AudioEngineService`, `TimeInterval`, `TopToolbarView`, `Bool`, `Codable`, `AudioTrack`, `ProjectPersistenceService`, `MixerPanelView`, `SupportedAudioFormats`, `SwiftUI`, `CGFloat`, `PropertiesSidebarView`, `MIDIInputService`, `AppKit`, `MIDIMappingBarView`, `TrackHeaderRowView`, `ContentView`, `TrackPitchControlView`, `.snap`, `.body`, `UUID`?**
  _High betweenness centrality (0.391) - this node is a cross-community bridge._
- **Why does `AudioTrack` connect `AudioTrack` to `ProjectPersistenceService`, `MixerPanelView`, `TrackLaneView`, `UUID`, `Foundation`, `PitchShiftSettings`, `DAWProject`, `SectionPlaybackMode`, `WorkspaceViewModel`, `Equatable`, `TrackHeaderRowView`, `Codable`?**
  _High betweenness centrality (0.092) - this node is a cross-community bridge._
- **Why does `Foundation` connect `Foundation` to `.loadBucket`, `SupportedAudioFormats`, `DAWProject`, `SwiftUI`, `AudioSampleRate`, `SectionPlaybackMode`, `MIDIInputService`, `AudioImportService`, `StandardTrackRole`, `ProjectPersistenceError`, `SimplePlayProjectArchive`, `Equatable`, `AppKit`, `MIDIMappingBarView`, `DAWVerticalFaderView`, `AudioFileStorageService`, `Testing`, `AudioTrack`?**
  _High betweenness centrality (0.087) - this node is a cross-community bridge._
- **Are the 13 inferred relationships involving `WorkspaceViewModel` (e.g. with `ArrangementPlaybackEngine` and `AudioEngineService`) actually correct?**
  _`WorkspaceViewModel` has 13 INFERRED edges - model-reasoned connections that need verification._
- **Are the 5 inferred relationships involving `ArrangementSection` (e.g. with `.chipBody` and `.resizeHandle()`) actually correct?**
  _`ArrangementSection` has 5 INFERRED edges - model-reasoned connections that need verification._
- **Are the 2 inferred relationships involving `AudioEngineService` (e.g. with `WorkspaceViewModel` and `.configureAudioEngine()`) actually correct?**
  _`AudioEngineService` has 2 INFERRED edges - model-reasoned connections that need verification._
- **Are the 3 inferred relationships involving `AudioTrack` (e.g. with `.duration` and `.hasSoloTracks`) actually correct?**
  _`AudioTrack` has 3 INFERRED edges - model-reasoned connections that need verification._