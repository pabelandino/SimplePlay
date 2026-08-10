# Graph Report - SimplePlay  (2026-08-09)

## Corpus Check
- 88 files · ~42,232 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 1425 nodes · 3215 edges · 71 communities (66 shown, 5 thin omitted)
- Extraction: 89% EXTRACTED · 11% INFERRED · 0% AMBIGUOUS · INFERRED: 338 edges (avg confidence: 0.8)
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
- .hex
- TimelineWorkspacePanel
- CodingKeys
- AudioImportService
- AudioEngineService
- StandardTrackRole
- .applyImportedStems
- SimplePlayProjectArchive
- Equatable
- AudioOutputDevice
- TopToolbarView
- .triggerSection
- AudioTrack
- Codable
- CodingKeys
- Testing
- Sendable
- SectionPlaybackMode
- ProjectPersistenceService
- MixerPanelView
- SupportedAudioFormats
- MIDINoteAssignment
- FaderMeterStripView
- PitchShiftSettings
- MacWindowTitleBarHidden.swift
- .body
- DAWProject
- TransportBarView
- CGFloat
- .peaks
- AudioSampleRate
- PropertiesSidebarView
- MIDIInputService
- AudioClip
- TimeInterval
- Color
- DAWProject
- WorkspaceViewModel
- ProjectPersistenceError
- DAWVerticalFaderView
- TopToolbarView.swift
- AppKit
- MIDIMappingBarView
- .presentImportPanel
- UIKitToolbarMenuButtonRepresentable
- ContentView
- View
- ToolbarMenuButtonStyleModifier
- .mixerChannelStrip
- TrackHeaderRowView
- WorkspaceView
- SwiftUI
- .sessionManagement
- TrackControlButton
- .setMasterVolume
- Bool

## God Nodes (most connected - your core abstractions)
1. `WorkspaceViewModel` - 199 edges
2. `AudioEngineService` - 48 edges
3. `ArrangementSection` - 47 edges
4. `AudioTrack` - 42 edges
5. `DAWTheme` - 37 edges
6. `ArrangementPlaybackEngine` - 36 edges
7. `MixerPanelView` - 35 edges
8. `StandardTrackRole` - 31 edges
9. `PropertiesSidebarView` - 31 edges
10. `TimelineWorkspacePanel` - 31 edges

## Surprising Connections (you probably didn't know these)
- `.duration` --references--> `AudioTrack`  [INFERRED]
  SimplePlay/Core/Models/DAWProject.swift → SimplePlay/Core/Models/AudioTrack.swift
- `.hasSoloTracks` --references--> `AudioTrack`  [INFERRED]
  SimplePlay/Core/Utils/TrackColorPalette.swift → SimplePlay/Core/Models/AudioTrack.swift
- `.selectedDevice` --references--> `WorkspaceViewModel`  [INFERRED]
  SimplePlay/Features/Workspace/Views/PropertiesSidebarView.swift → SimplePlay/Features/Workspace/ViewModels/WorkspaceViewModel.swift
- `.body` --calls--> `WorkspaceView`  [INFERRED]
  SimplePlay/ContentView.swift → SimplePlay/Features/Workspace/Views/WorkspaceView.swift
- `.body` --references--> `ArrangementSection`  [INFERRED]
  SimplePlay/Features/Workspace/Views/SectionMarkerLaneView.swift → SimplePlay/Core/Models/ArrangementSection.swift

## Import Cycles
- None detected.

## Communities (71 total, 5 thin omitted)

### Community 0 - "SimplePlayUITests"
Cohesion: 0.15
Nodes (6): SimplePlayUITests, SimplePlayUITestsLaunchTests, .runsForEachTargetApplicationUIConfiguration, Bool, XCTest, XCTestCase

### Community 1 - "SectionMarkerChipView"
Cohesion: 0.08
Nodes (38): NSCursor, Bool, String, TimeInterval, SectionDragKind, move, resizeEnd, resizeStart (+30 more)

### Community 2 - "TrackGroup"
Cohesion: 0.27
Nodes (8): Date, Encoder, Decoder, Double, String, TimeInterval, UUID, TrackGroup

### Community 3 - "What You Must Do When Invoked"
Cohesion: 0.08
Nodes (24): For /graphify add and --watch, For /graphify query, For the commit hook and native AGENTS.md integration, For --update and --cluster-only, /graphify, Honesty Rules, Interpreter guard for subcommands, Part A - Structural extraction for code files (+16 more)

### Community 4 - "TrackLaneView"
Cohesion: 0.07
Nodes (30): CoreGraphics, G, GraphicsContext, CGFloat, String, TimeInterval, TimelineRulerScale, CGFloat (+22 more)

### Community 5 - "graphify reference: extra exports and benchmark"
Cohesion: 0.22
Nodes (8): graphify reference: extra exports and benchmark, Step 6b - Wiki (only if --wiki flag), Step 7 - Neo4j export (only if --neo4j or --neo4j-push flag), Step 7a - FalkorDB export (only if --falkordb or --falkordb-push flag), Step 7b - SVG export (only if --svg flag), Step 7c - GraphML export (only if --graphml flag), Step 7d - MCP server (only if --mcp flag), Step 8 - Token reduction benchmark (only if total_words > 5000)

### Community 6 - "Foundation"
Cohesion: 0.15
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
Nodes (34): ArrangementSection, .color, .duration, Bool, Decoder, String, TimeInterval, UInt8 (+26 more)

### Community 15 - ".hex"
Cohesion: 0.40
Nodes (5): .defaultColor, Int, StandardTrackRole, String, TrackColorPalette

### Community 16 - "TimelineWorkspacePanel"
Cohesion: 0.09
Nodes (29): PlayheadView, .body, .playheadDragGesture, Bool, CGFloat, Content, Double, Gesture (+21 more)

### Community 17 - "CodingKeys"
Cohesion: 0.10
Nodes (20): CodingKey, CodingKeys, colorHex, endTime, id, midiChannel, midiNote, midiUsesControlChange (+12 more)

### Community 18 - "AudioImportService"
Cohesion: 0.08
Nodes (26): LocalizedError, AudioFileStorageService, String, URL, UUID, AudioImportError, emptySelection, .errorDescription (+18 more)

### Community 19 - "AudioEngineService"
Cohesion: 0.08
Nodes (28): AVAudioFile, AVAudioMixerNode, AVAudioNode, AVAudioPCMBuffer, AVAudioPlayerNode, AVAudioUnitEQ, AudioEngineError, clipLoadFailed (+20 more)

### Community 20 - "StandardTrackRole"
Cohesion: 0.08
Nodes (24): StandardTrackRole, acousticGuitar, backingVocal, bass, brass, click, countIn, cue (+16 more)

### Community 21 - ".applyImportedStems"
Cohesion: 0.16
Nodes (5): Error, Result, String, URL, .body

### Community 22 - "SimplePlayProjectArchive"
Cohesion: 0.16
Nodes (15): Asset, SimplePlayProjectArchive, SimplePlayProjectArchiveError, corruptAsset, corruptManifest, .errorDescription, invalidArchive, Bool (+7 more)

### Community 23 - "Equatable"
Cohesion: 0.23
Nodes (17): Equatable, PersistedClip, PersistedProject, PersistedTrack, Bool, Decoder, Double, Int32 (+9 more)

### Community 24 - "AudioOutputDevice"
Cohesion: 0.24
Nodes (8): AudioDeviceID, Hashable, AudioOutputDevice, AudioDeviceService, Bool, Int, String, .audioSettings

### Community 25 - "TopToolbarView"
Cohesion: 0.25
Nodes (11): String, Void, TopToolbarView, .importMenuItems, .isCompact, .openButton, .projectTitle, .saveButton (+3 more)

### Community 26 - ".triggerSection"
Cohesion: 0.14
Nodes (8): Content, View, TransportCommands, .body, View, WorkspaceKeyboardShortcuts, .transportControls, Timer

### Community 27 - "AudioTrack"
Cohesion: 0.29
Nodes (8): AudioTrack, .color, .displayName, Bool, Double, StandardTrackRole, String, UUID

### Community 28 - "Codable"
Cohesion: 0.22
Nodes (9): Codable, SavedProjectDocument, DAWProject, Int, WorkspaceSnapshot, ManifestFile, Data, String (+1 more)

### Community 29 - "CodingKeys"
Cohesion: 0.08
Nodes (24): CodingKeys, audioSettings, colorHex, id, isLocked, isMuted, isSnapEnabled, isSolo (+16 more)

### Community 30 - "Testing"
Cohesion: 0.20
Nodes (5): SimplePlay, ProjectArchiveTests, SectionMarkerPaletteTests, SimplePlayTests, Testing

### Community 31 - "Sendable"
Cohesion: 0.19
Nodes (14): Sendable, ImportedStem, ImportPlacement, appendNewGroup, insertIntoGroup, DAWProject, Int, String (+6 more)

### Community 32 - "SectionPlaybackMode"
Cohesion: 0.14
Nodes (13): CaseIterable, Identifiable, SectionPlaybackMode, continueTimeline, continueToNext, .displayName, .id, oneShot (+5 more)

### Community 33 - "ProjectPersistenceService"
Cohesion: 0.33
Nodes (5): unsupportedVersion, ProjectPersistenceService, Bool, URL, UUID

### Community 34 - "MixerPanelView"
Cohesion: 0.11
Nodes (19): MixerPanelView, .body, .channelFaderHeight, .channelFaderWidth, .channelStripWidth, .isCompact, .masterFaderHeight, .mastersStripRow (+11 more)

### Community 35 - "SupportedAudioFormats"
Cohesion: 0.05
Nodes (37): FileDocument, FileWrapper, ReadConfiguration, SimplePlayProjectFileDocument, .readableContentTypes, Data, DropURLLoader, NSItemProvider (+29 more)

### Community 36 - "MIDINoteAssignment"
Cohesion: 0.20
Nodes (10): MIDILearnTarget, loopToggle, section, MIDINoteAssignment, .displayName, Bool, String, UInt8 (+2 more)

### Community 37 - "FaderMeterStripView"
Cohesion: 0.15
Nodes (12): .projectMasterStrip, .mainVolumeControl, FaderMeterStripView, .reservesThumbClearance, .showsUnityMark, .usesUnityCenterDecibelScale, Bool, CGFloat (+4 more)

### Community 38 - "PitchShiftSettings"
Cohesion: 0.31
Nodes (5): PitchShiftSettings, AVAudioUnitTimePitch, Double, Float, PitchShiftSettingsTests

### Community 39 - "MacWindowTitleBarHidden.swift"
Cohesion: 0.11
Nodes (15): Notification, NSApplicationDelegate, NSEvent, NSObject, NSView, NSViewRepresentable, NSWindow, .body (+7 more)

### Community 40 - ".body"
Cohesion: 0.27
Nodes (5): Double, .mixerScrollWithPinnedMasters, Binding, .body, .trackVolumeBinding

### Community 41 - "DAWProject"
Cohesion: 0.36
Nodes (9): DAWProject, .duration, Bool, Double, Int32, String, TimeInterval, UInt8 (+1 more)

### Community 42 - "TransportBarView"
Cohesion: 0.06
Nodes (37): Bool, CGFloat, CGSize, Gesture, TimeInterval, TimelineOverviewBar, .barHeight, .body (+29 more)

### Community 43 - "CGFloat"
Cohesion: 0.25
Nodes (5): CGFloat, TimelineScrollRequest, .minimumTimelineZoom, .timelineContentWidth, .sectionCreationGesture

### Community 44 - ".peaks"
Cohesion: 0.09
Nodes (30): CheckedContinuation, Never, Path, clips, Double, Float, Int, MainActor (+22 more)

### Community 45 - "AudioSampleRate"
Cohesion: 0.26
Nodes (10): Double, AudioSampleRate, .displayName, .id, rate44100, rate48000, AudioSettings, Int (+2 more)

### Community 46 - "PropertiesSidebarView"
Cohesion: 0.06
Nodes (41): PropertiesSidebarView, .body, .pitchIsOriginal, .pitchLabel, .playbackSettings, .sectionCreationHint, .sectionEditor, .selectedDevice (+33 more)

### Community 47 - "MIDIInputService"
Cohesion: 0.07
Nodes (23): CoreMIDI, MIDINotifyProc, MIDIPacket, MIDIPacketList, MIDIInputEvent, MIDIInputService, MIDISourceInfo, .id (+15 more)

### Community 48 - "AudioClip"
Cohesion: 0.36
Nodes (7): AudioClip, .endTime, Int, String, TimeInterval, URL, UUID

### Community 49 - "TimeInterval"
Cohesion: 0.17
Nodes (4): Bool, TimeInterval, ClosedRange, TimeInterval

### Community 50 - "Color"
Cohesion: 0.17
Nodes (10): Color, DAWProject, .hasSoloTracks, StandardTrackRole, .fallbackColor, Bool, Bool, Double (+2 more)

### Community 51 - "DAWProject"
Cohesion: 0.39
Nodes (4): groups, DAWProject, Int, UUID

### Community 52 - "WorkspaceViewModel"
Cohesion: 0.09
Nodes (18): DAWProject, Float, Set, UUID, WorkspaceViewModel, .activePitchTrack, .canSaveDirectlyToCurrentURL, .isArrangementSectionControllingPlayback (+10 more)

### Community 53 - "ProjectPersistenceError"
Cohesion: 0.17
Nodes (11): JSONDecoder, .projectDecoder, JSONEncoder, .pretty, ProjectPersistenceError, .errorDescription, invalidPackage, missingAudioFile (+3 more)

### Community 54 - "DAWVerticalFaderView"
Cohesion: 0.09
Nodes (25): ClosedRange, Double, Float, String, TrackVolumeSettings, .trackRange, DAWVerticalFaderView, .body (+17 more)

### Community 55 - "TopToolbarView.swift"
Cohesion: 0.36
Nodes (6): ButtonStyle, DAWIconToolbarButtonStyle, DAWLabeledToolbarButtonStyle, DAWPrimaryButtonStyle, Content, .body

### Community 56 - "AppKit"
Cohesion: 0.22
Nodes (5): AppKit, ProjectFilePanel, URL, ResizablePropertiesSidebar, .body

### Community 57 - "MIDIMappingBarView"
Cohesion: 0.16
Nodes (15): MIDIMappingBarView, .body, .collapsedBar, .devicePickerLabel, .devicePickerTitle, .devicePickerTitleColor, .expandedPanel, .isCompact (+7 more)

### Community 58 - ".presentImportPanel"
Cohesion: 0.20
Nodes (5): ImportPanelKind, audioFiles, folder, Int, .trackHeaderColumnTracksOnly

### Community 59 - "UIKitToolbarMenuButtonRepresentable"
Cohesion: 0.33
Nodes (7): Coordinator, Context, String, Void, UIKitToolbarMenuButtonRepresentable, UIButton, UIViewRepresentable

### Community 60 - "ContentView"
Cohesion: 0.20
Nodes (8): App, Commands, Scene, ContentView, .body, FileCommands, SimplePlayApp, .body

### Community 61 - "View"
Cohesion: 0.13
Nodes (17): Configuration, .collapsedBarContent, .groupDivider, .pinnedMastersColumn, .markerHeaderRow, AudioDropOverlay, .body, String (+9 more)

### Community 62 - "ToolbarMenuButtonStyleModifier"
Cohesion: 0.27
Nodes (7): Bool, ToolbarMenuButtonStyleModifier, .importButton, .projectSessionButton, ImportToolbarMenuButton, .body, ProjectSessionToolbarMenuButton

### Community 63 - ".mixerChannelStrip"
Cohesion: 0.52
Nodes (3): Binding, Double, UUID

### Community 64 - "TrackHeaderRowView"
Cohesion: 0.33
Nodes (5): Double, TrackHeaderRowView, .displayColor, .liveTrack, .trackPan

### Community 65 - "WorkspaceView"
Cohesion: 0.15
Nodes (14): Binding, Bool, String, WorkspaceSettingsView, .body, .deleteSectionDialogTitle, .sectionDeletionDialogBinding, Binding (+6 more)

### Community 67 - ".sessionManagement"
Cohesion: 0.60
Nodes (3): .sessionManagement, .projectSessionMenuItems, .body

### Community 68 - "TrackControlButton"
Cohesion: 0.22
Nodes (8): PanKnobView, .body, Bool, Double, String, Void, TrackControlButton, .body

### Community 71 - "Bool"
Cohesion: 0.18
Nodes (6): Bool, UInt8, TimelineScrollAlignment, center, leading, start

## Knowledge Gaps
- **259 isolated node(s):** `id`, `name`, `startTime`, `endTime`, `colorHex` (+254 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **5 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `WorkspaceViewModel` connect `WorkspaceViewModel` to `SectionMarkerChipView`, `TrackLaneView`, `Foundation`, `ArrangementSection`, `TimelineWorkspacePanel`, `AudioImportService`, `AudioEngineService`, `.applyImportedStems`, `AudioOutputDevice`, `TopToolbarView`, `.triggerSection`, `AudioTrack`, `Codable`, `Sendable`, `SectionPlaybackMode`, `ProjectPersistenceService`, `MixerPanelView`, `SupportedAudioFormats`, `MIDINoteAssignment`, `.body`, `TransportBarView`, `CGFloat`, `PropertiesSidebarView`, `MIDIInputService`, `TimeInterval`, `AppKit`, `MIDIMappingBarView`, `.presentImportPanel`, `ContentView`, `View`, `ToolbarMenuButtonStyleModifier`, `.mixerChannelStrip`, `TrackHeaderRowView`, `WorkspaceView`, `.sessionManagement`, `.setMasterVolume`, `Bool`?**
  _High betweenness centrality (0.399) - this node is a cross-community bridge._
- **Why does `AudioTrack` connect `AudioTrack` to `SectionPlaybackMode`, `ProjectPersistenceService`, `SwiftUI`, `MixerPanelView`, `TrackLaneView`, `TrackHeaderRowView`, `PitchShiftSettings`, `.body`, `DAWProject`, `.hex`, `AudioClip`, `Color`, `DAWProject`, `WorkspaceViewModel`, `Equatable`, `Codable`, `.mixerChannelStrip`, `Sendable`?**
  _High betweenness centrality (0.087) - this node is a cross-community bridge._
- **Why does `ArrangementSection` connect `ArrangementSection` to `SectionPlaybackMode`, `SectionMarkerChipView`, `SwiftUI`, `DAWProject`, `PropertiesSidebarView`, `MIDIInputService`, `CodingKeys`, `Color`, `TimeInterval`, `Equatable`, `MIDIMappingBarView`, `.triggerSection`, `Codable`, `Testing`, `Sendable`?**
  _High betweenness centrality (0.083) - this node is a cross-community bridge._
- **Are the 13 inferred relationships involving `WorkspaceViewModel` (e.g. with `ArrangementPlaybackEngine` and `AudioEngineService`) actually correct?**
  _`WorkspaceViewModel` has 13 INFERRED edges - model-reasoned connections that need verification._
- **Are the 2 inferred relationships involving `AudioEngineService` (e.g. with `WorkspaceViewModel` and `.configureAudioEngine()`) actually correct?**
  _`AudioEngineService` has 2 INFERRED edges - model-reasoned connections that need verification._
- **Are the 4 inferred relationships involving `ArrangementSection` (e.g. with `.body` and `.body`) actually correct?**
  _`ArrangementSection` has 4 INFERRED edges - model-reasoned connections that need verification._
- **Are the 3 inferred relationships involving `AudioTrack` (e.g. with `.duration` and `.hasSoloTracks`) actually correct?**
  _`AudioTrack` has 3 INFERRED edges - model-reasoned connections that need verification._