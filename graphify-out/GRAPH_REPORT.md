# Graph Report - SimplePlay  (2026-08-09)

## Corpus Check
- 87 files · ~39,602 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 1352 nodes · 2968 edges · 61 communities (56 shown, 5 thin omitted)
- Extraction: 91% EXTRACTED · 9% INFERRED · 0% AMBIGUOUS · INFERRED: 277 edges (avg confidence: 0.8)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `600c55fc`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- SimplePlayUITests
- SectionMarkerLaneView
- MIDIMappingBarView
- What You Must Do When Invoked
- TrackLaneView
- graphify reference: extra exports and benchmark
- .peaks
- graphify reference: query, path, explain
- graphify reference: add a URL and watch a folder
- graphify reference: commit hook and native AGENTS.md integration
- graphify reference: incremental update and cluster-only
- graphify reference: GitHub clone and cross-repo merge
- graphify reference: transcribe video and audio
- extraction-spec.md
- ArrangementPlaybackEngine
- AudioImportDocumentPicker
- TimelineWorkspacePanel
- .standardize
- AudioImportService
- AudioEngineService
- StandardTrackRole
- .snap
- Sendable
- FaderMeterStripView
- .applyImportedStems
- TrackGroup
- TimeInterval
- .mixerChannelStrip
- SwiftUI
- CodingKeys
- PropertiesSidebarView
- TrackOrganizationService
- SimplePlayProjectArchive
- TrackControlButton
- MixerPanelView
- TrackHeaderRowView
- ArrangementSection
- Color
- TrackPitchControlView
- MacWindowTitleBarHidden.swift
- WorkspaceViewModel
- AudioTrack
- TransportBarView
- CodingKeys
- WaveformClipView
- AudioClip
- DAWProject
- MIDIInputService
- .applyLoadedProject
- .nextDistinctHex
- DAWProject
- SectionMarkerChipView
- CGFloat
- .applyMIDILearn
- DAWVerticalFaderView
- PlaybackState
- View
- .body
- .body
- TrackWaveformProgressBar
- UUID

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
- `.body` --calls--> `ContentView`  [INFERRED]
  SimplePlay/SimplePlayApp.swift → SimplePlay/ContentView.swift
- `.body` --references--> `ArrangementSection`  [INFERRED]
  SimplePlay/Features/Workspace/Views/SectionMarkerLaneView.swift → SimplePlay/Core/Models/ArrangementSection.swift
- `.body` --references--> `ArrangementSection`  [INFERRED]
  SimplePlay/Features/Workspace/Views/SectionMarkerLaneView.swift → SimplePlay/Core/Models/ArrangementSection.swift

## Import Cycles
- None detected.

## Communities (61 total, 5 thin omitted)

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

### Community 4 - "TrackLaneView"
Cohesion: 0.09
Nodes (25): G, GraphicsContext, CGFloat, String, TimeInterval, TimelineRulerScale, ClipDragInteractionModifier, ClipSelectionModifiers (+17 more)

### Community 5 - "graphify reference: extra exports and benchmark"
Cohesion: 0.22
Nodes (8): graphify reference: extra exports and benchmark, Step 6b - Wiki (only if --wiki flag), Step 7 - Neo4j export (only if --neo4j or --neo4j-push flag), Step 7a - FalkorDB export (only if --falkordb or --falkordb-push flag), Step 7b - SVG export (only if --svg flag), Step 7c - GraphML export (only if --graphml flag), Step 7d - MCP server (only if --mcp flag), Step 8 - Token reduction benchmark (only if total_words > 5000)

### Community 6 - ".peaks"
Cohesion: 0.25
Nodes (12): CheckedContinuation, Never, Double, Float, Int, MainActor, Sendable, String (+4 more)

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

### Community 15 - "AudioImportDocumentPicker"
Cohesion: 0.07
Nodes (28): FileDocument, FileWrapper, ReadConfiguration, SimplePlayProjectFileDocument, .readableContentTypes, Data, SimplePlayProjectType, UTType (+20 more)

### Community 16 - "TimelineWorkspacePanel"
Cohesion: 0.06
Nodes (44): DropURLLoader, NSItemProvider, String, URL, PlayheadView, .body, .playheadDragGesture, Bool (+36 more)

### Community 17 - ".standardize"
Cohesion: 0.23
Nodes (7): StandardizedName, Bool, StandardTrackRole, String, URL, TrackNameStandardizer, TrackNameStandardizerTests

### Community 18 - "AudioImportService"
Cohesion: 0.12
Nodes (19): LocalizedError, AudioFileStorageService, String, URL, UUID, AudioImportError, emptySelection, .errorDescription (+11 more)

### Community 19 - "AudioEngineService"
Cohesion: 0.08
Nodes (28): AVAudioFile, AVAudioMixerNode, AVAudioNode, AVAudioPCMBuffer, AVAudioPlayerNode, AVAudioUnitEQ, AudioEngineError, clipLoadFailed (+20 more)

### Community 20 - "StandardTrackRole"
Cohesion: 0.06
Nodes (36): CaseIterable, SectionPlaybackMode, continueTimeline, continueToNext, .displayName, .id, oneShot, repeatSection (+28 more)

### Community 21 - ".snap"
Cohesion: 0.20
Nodes (3): Bool, TimeInterval, ClosedRange

### Community 22 - "Sendable"
Cohesion: 0.05
Nodes (59): Codable, Double, Equatable, Sendable, AudioSampleRate, .displayName, .id, rate44100 (+51 more)

### Community 23 - "FaderMeterStripView"
Cohesion: 0.17
Nodes (11): .mainVolumeControl, FaderMeterStripView, .reservesThumbClearance, .showsUnityMark, .usesUnityCenterDecibelScale, Bool, CGFloat, ClosedRange (+3 more)

### Community 24 - ".applyImportedStems"
Cohesion: 0.24
Nodes (4): Error, Result, String, URL

### Community 25 - "TrackGroup"
Cohesion: 0.14
Nodes (16): CodingKey, Date, Encoder, CodingKeys, horizontalOffset, id, importedAt, name (+8 more)

### Community 26 - "TimeInterval"
Cohesion: 0.22
Nodes (4): Bool, TimeInterval, .transportControls, Timer

### Community 27 - ".mixerChannelStrip"
Cohesion: 0.36
Nodes (4): .masterVolumeBinding, Binding, Double, UUID

### Community 28 - "SwiftUI"
Cohesion: 0.05
Nodes (22): AppKit, AVFoundation, CoreAudio, CoreGraphics, Foundation, Observation, SimplePlay, PitchShiftSettings (+14 more)

### Community 29 - "CodingKeys"
Cohesion: 0.09
Nodes (23): CodingKeys, audioSettings, colorHex, id, isLocked, isMuted, isSnapEnabled, isSolo (+15 more)

### Community 30 - "PropertiesSidebarView"
Cohesion: 0.05
Nodes (46): AudioDeviceID, Hashable, AudioOutputDevice, AudioDeviceService, Bool, Int, String, Bool (+38 more)

### Community 31 - "TrackOrganizationService"
Cohesion: 0.18
Nodes (13): ImportedStem, ImportPlacement, appendNewGroup, insertIntoGroup, DAWProject, Int, String, TimeInterval (+5 more)

### Community 32 - "SimplePlayProjectArchive"
Cohesion: 0.16
Nodes (15): Asset, SimplePlayProjectArchive, SimplePlayProjectArchiveError, corruptAsset, corruptManifest, .errorDescription, invalidArchive, Bool (+7 more)

### Community 33 - "TrackControlButton"
Cohesion: 0.22
Nodes (8): PanKnobView, .body, Bool, Double, String, Void, TrackControlButton, .body

### Community 34 - "MixerPanelView"
Cohesion: 0.08
Nodes (28): MixerPanelView, .body, .channelFaderHeight, .channelFaderWidth, .channelStripWidth, .groupDivider, .isCompact, .masterFaderHeight (+20 more)

### Community 35 - "TrackHeaderRowView"
Cohesion: 0.29
Nodes (6): Double, TrackHeaderRowView, .displayColor, .liveTrack, .trackPan, TrackReorderHandle

### Community 36 - "ArrangementSection"
Cohesion: 0.21
Nodes (11): ArrangementSection, .color, .duration, Bool, Decoder, String, TimeInterval, UInt8 (+3 more)

### Community 37 - "Color"
Cohesion: 0.25
Nodes (8): .defaultColor, Color, StandardTrackRole, .fallbackColor, Int, StandardTrackRole, String, TrackColorPalette

### Community 38 - "TrackPitchControlView"
Cohesion: 0.15
Nodes (13): Binding, Bool, Double, String, UUID, TrackPitchControlView, .menuTitle, .pitchIsOriginal (+5 more)

### Community 39 - "MacWindowTitleBarHidden.swift"
Cohesion: 0.11
Nodes (15): Notification, NSApplicationDelegate, NSEvent, NSObject, NSView, NSViewRepresentable, NSWindow, .body (+7 more)

### Community 40 - "WorkspaceViewModel"
Cohesion: 0.09
Nodes (19): ImportPanelKind, audioFiles, folder, Int, Set, WorkspaceViewModel, .activePitchTrack, .canSaveDirectlyToCurrentURL (+11 more)

### Community 41 - "AudioTrack"
Cohesion: 0.24
Nodes (11): AudioTrack, .color, .displayName, Bool, Double, StandardTrackRole, String, UUID (+3 more)

### Community 42 - "TransportBarView"
Cohesion: 0.06
Nodes (37): Bool, CGFloat, CGSize, Gesture, TimeInterval, TimelineOverviewBar, .barHeight, .body (+29 more)

### Community 43 - "CodingKeys"
Cohesion: 0.18
Nodes (11): CodingKeys, colorHex, endTime, id, midiChannel, midiNote, name, nextSectionID (+3 more)

### Community 44 - "WaveformClipView"
Cohesion: 0.11
Nodes (22): Path, clips, Bool, Double, UUID, WaveformLoadMonitor, CGFloat, Int (+14 more)

### Community 45 - "AudioClip"
Cohesion: 0.36
Nodes (7): AudioClip, .endTime, Int, String, TimeInterval, URL, UUID

### Community 46 - "DAWProject"
Cohesion: 0.39
Nodes (4): groups, DAWProject, Int, UUID

### Community 47 - "MIDIInputService"
Cohesion: 0.10
Nodes (20): CoreMIDI, Identifiable, MIDINotifyProc, MIDIPacketList, MIDIReadProc, MIDIInputService, MIDISourceInfo, .id (+12 more)

### Community 49 - ".nextDistinctHex"
Cohesion: 0.47
Nodes (5): SectionMarkerPalette, .palette, Int, Set, String

### Community 50 - "DAWProject"
Cohesion: 0.31
Nodes (9): DAWProject, .duration, Bool, Double, Int32, String, TimeInterval, UInt8 (+1 more)

### Community 51 - "SectionMarkerChipView"
Cohesion: 0.12
Nodes (16): NSCursor, SectionDragKind, move, resizeEnd, resizeStart, ResizeEdge, end, start (+8 more)

### Community 52 - "CGFloat"
Cohesion: 0.17
Nodes (10): CGFloat, TimelineScrollAlignment, center, leading, start, TimelineScrollRequest, .minimumTimelineZoom, .timelineContentWidth (+2 more)

### Community 54 - "DAWVerticalFaderView"
Cohesion: 0.09
Nodes (25): ClosedRange, Double, Float, String, TrackVolumeSettings, .trackRange, DAWVerticalFaderView, .body (+17 more)

### Community 55 - "PlaybackState"
Cohesion: 0.40
Nodes (5): PlaybackState, continuingTimeline, idle, playingSection, waitingToJump

### Community 57 - "View"
Cohesion: 0.16
Nodes (18): ButtonStyle, Configuration, .selectedMarkerEditor, DAWIconToolbarButtonStyle, DAWPrimaryButtonStyle, DAWSecondaryButtonStyle, Bool, String (+10 more)

### Community 65 - ".body"
Cohesion: 0.11
Nodes (17): ContentView, .body, Binding, Bool, String, WorkspaceSettingsView, .body, .deleteSectionDialogTitle (+9 more)

### Community 66 - ".body"
Cohesion: 0.14
Nodes (12): App, Commands, Scene, FileCommands, Content, View, TransportCommands, .body (+4 more)

### Community 68 - "TrackWaveformProgressBar"
Cohesion: 0.40
Nodes (4): Bool, Double, TrackWaveformProgressBar, .body

### Community 71 - "UUID"
Cohesion: 0.17
Nodes (7): Double, Float, UUID, .mixerScrollWithPinnedMasters, Binding, .body, .trackVolumeBinding

## Knowledge Gaps
- **250 isolated node(s):** `id`, `name`, `startTime`, `endTime`, `colorHex` (+245 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **5 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `WorkspaceViewModel` connect `WorkspaceViewModel` to `SectionMarkerLaneView`, `MIDIMappingBarView`, `TrackLaneView`, `ArrangementPlaybackEngine`, `AudioImportDocumentPicker`, `TimelineWorkspacePanel`, `AudioImportService`, `AudioEngineService`, `StandardTrackRole`, `.snap`, `Sendable`, `.applyImportedStems`, `TimeInterval`, `.mixerChannelStrip`, `SwiftUI`, `PropertiesSidebarView`, `TrackOrganizationService`, `MixerPanelView`, `TrackHeaderRowView`, `TrackPitchControlView`, `AudioTrack`, `TransportBarView`, `MIDIInputService`, `.applyLoadedProject`, `SectionMarkerChipView`, `CGFloat`, `.applyMIDILearn`, `View`, `.body`, `.body`, `UUID`?**
  _High betweenness centrality (0.396) - this node is a cross-community bridge._
- **Why does `Foundation` connect `SwiftUI` to `SimplePlayProjectArchive`, `AudioClip`, `MIDIInputService`, `.standardize`, `DAWProject`, `AudioImportService`, `StandardTrackRole`, `Sendable`, `TrackGroup`, `PropertiesSidebarView`, `TrackOrganizationService`?**
  _High betweenness centrality (0.111) - this node is a cross-community bridge._
- **Why does `AudioTrack` connect `AudioTrack` to `MixerPanelView`, `TrackHeaderRowView`, `TrackLaneView`, `Color`, `UUID`, `WorkspaceViewModel`, `AudioClip`, `DAWProject`, `MIDIInputService`, `DAWProject`, `Sendable`, `.mixerChannelStrip`, `SwiftUI`, `TrackOrganizationService`?**
  _High betweenness centrality (0.090) - this node is a cross-community bridge._
- **Are the 13 inferred relationships involving `WorkspaceViewModel` (e.g. with `ArrangementPlaybackEngine` and `AudioEngineService`) actually correct?**
  _`WorkspaceViewModel` has 13 INFERRED edges - model-reasoned connections that need verification._
- **Are the 2 inferred relationships involving `AudioEngineService` (e.g. with `WorkspaceViewModel` and `.configureAudioEngine()`) actually correct?**
  _`AudioEngineService` has 2 INFERRED edges - model-reasoned connections that need verification._
- **Are the 3 inferred relationships involving `AudioTrack` (e.g. with `.duration` and `.hasSoloTracks`) actually correct?**
  _`AudioTrack` has 3 INFERRED edges - model-reasoned connections that need verification._
- **Are the 4 inferred relationships involving `ArrangementSection` (e.g. with `.body` and `.body`) actually correct?**
  _`ArrangementSection` has 4 INFERRED edges - model-reasoned connections that need verification._