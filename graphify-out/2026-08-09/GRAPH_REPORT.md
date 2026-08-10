# Graph Report - SimplePlay  (2026-08-09)

## Corpus Check
- 87 files · ~40,174 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 1383 nodes · 3019 edges · 65 communities (58 shown, 7 thin omitted)
- Extraction: 91% EXTRACTED · 9% INFERRED · 0% AMBIGUOUS · INFERRED: 277 edges (avg confidence: 0.8)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `600c55fc`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- SimplePlayUITests
- SectionMarkerChipMetrics
- MIDIMappingBarView
- What You Must Do When Invoked
- AudioClip
- graphify reference: extra exports and benchmark
- SavedProjectDocument
- graphify reference: query, path, explain
- graphify reference: add a URL and watch a folder
- graphify reference: commit hook and native AGENTS.md integration
- graphify reference: incremental update and cluster-only
- graphify reference: GitHub clone and cross-repo merge
- graphify reference: transcribe video and audio
- extraction-spec.md
- ArrangementSection
- AudioImportDocumentPicker
- TimelineWorkspacePanel
- .standardize
- AudioImportService
- AudioEngineService
- StandardTrackRole
- TimeInterval
- PersistedProject
- FaderMeterStripView
- .applyImportedStems
- ProjectPersistenceService
- .seek
- .groupVolumeBinding
- Foundation
- CodingKeys
- PropertiesSidebarView
- AudioTrack
- SimplePlayProjectArchive
- TrackControlButton
- MixerPanelView
- TrackHeaderRowView
- Testing
- AudioDeviceService
- TrackPitchControlView
- MacWindowTitleBarHidden.swift
- WorkspaceViewModel
- ProjectPersistenceError
- TransportBarView
- SwiftUI
- .peaks
- PitchShiftSettings
- Sendable
- MIDIInputService
- .applyLoadedProject
- SidebarPanel
- DAWProject
- UUID
- CGFloat
- DAWTheme
- DAWVerticalFaderView
- WorkspaceKeyboardShortcuts
- MIDILearnTarget
- View
- CoreGraphics
- .format
- .body
- ContentView
- TrackWaveformProgressBar
- .mixerChannelStrip
- .sessionManagement

## God Nodes (most connected - your core abstractions)
1. `WorkspaceViewModel` - 193 edges
2. `AudioEngineService` - 48 edges
3. `ArrangementSection` - 42 edges
4. `AudioTrack` - 42 edges
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
- `.body` --calls--> `WorkspaceView`  [INFERRED]
  SimplePlay/ContentView.swift → SimplePlay/Features/Workspace/Views/WorkspaceView.swift
- `.body` --references--> `ArrangementSection`  [INFERRED]
  SimplePlay/Features/Workspace/Views/SectionMarkerLaneView.swift → SimplePlay/Core/Models/ArrangementSection.swift
- `.body` --references--> `ArrangementSection`  [INFERRED]
  SimplePlay/Features/Workspace/Views/SectionMarkerLaneView.swift → SimplePlay/Core/Models/ArrangementSection.swift

## Import Cycles
- None detected.

## Communities (65 total, 7 thin omitted)

### Community 0 - "SimplePlayUITests"
Cohesion: 0.15
Nodes (6): SimplePlayUITests, SimplePlayUITestsLaunchTests, .runsForEachTargetApplicationUIConfiguration, Bool, XCTest, XCTestCase

### Community 1 - "SectionMarkerChipMetrics"
Cohesion: 0.06
Nodes (56): Font, NSCursor, ResizeEdge, end, start, SectionCreationPreviewView, .body, .metrics (+48 more)

### Community 2 - "MIDIMappingBarView"
Cohesion: 0.16
Nodes (12): MIDIMappingBarView, .body, .collapsedBar, .devicePicker, .devicePickerTitle, .devicePickerTitleColor, .expandedPanel, .isCompact (+4 more)

### Community 3 - "What You Must Do When Invoked"
Cohesion: 0.08
Nodes (24): For /graphify add and --watch, For /graphify query, For the commit hook and native AGENTS.md integration, For --update and --cluster-only, /graphify, Honesty Rules, Interpreter guard for subcommands, Part A - Structural extraction for code files (+16 more)

### Community 4 - "AudioClip"
Cohesion: 0.07
Nodes (33): G, GraphicsContext, Path, AudioClip, .endTime, Int, String, TimeInterval (+25 more)

### Community 5 - "graphify reference: extra exports and benchmark"
Cohesion: 0.22
Nodes (8): graphify reference: extra exports and benchmark, Step 6b - Wiki (only if --wiki flag), Step 7 - Neo4j export (only if --neo4j or --neo4j-push flag), Step 7a - FalkorDB export (only if --falkordb or --falkordb-push flag), Step 7b - SVG export (only if --svg flag), Step 7c - GraphML export (only if --graphml flag), Step 7d - MCP server (only if --mcp flag), Step 8 - Token reduction benchmark (only if total_words > 5000)

### Community 6 - "SavedProjectDocument"
Cohesion: 0.20
Nodes (8): SavedProjectDocument, DAWProject, Int, Data, ProjectFilePanel, String, URL, .body

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

### Community 15 - "AudioImportDocumentPicker"
Cohesion: 0.05
Nodes (41): FileDocument, FileWrapper, ReadConfiguration, SimplePlayProjectFileDocument, .readableContentTypes, Data, DropURLLoader, NSItemProvider (+33 more)

### Community 16 - "TimelineWorkspacePanel"
Cohesion: 0.06
Nodes (40): PlayheadView, .body, .playheadDragGesture, Bool, CGFloat, Content, Double, Gesture (+32 more)

### Community 17 - ".standardize"
Cohesion: 0.23
Nodes (7): StandardizedName, Bool, StandardTrackRole, String, URL, TrackNameStandardizer, TrackNameStandardizerTests

### Community 18 - "AudioImportService"
Cohesion: 0.12
Nodes (19): LocalizedError, AudioFileStorageService, String, URL, UUID, AudioImportError, emptySelection, .errorDescription (+11 more)

### Community 19 - "AudioEngineService"
Cohesion: 0.08
Nodes (27): AVAudioFile, AVAudioMixerNode, AVAudioNode, AVAudioPlayerNode, AVAudioUnitEQ, AudioEngineError, clipLoadFailed, deviceSelectionFailed (+19 more)

### Community 20 - "StandardTrackRole"
Cohesion: 0.06
Nodes (36): CaseIterable, SectionPlaybackMode, continueTimeline, continueToNext, .displayName, .id, oneShot, repeatSection (+28 more)

### Community 21 - "TimeInterval"
Cohesion: 0.21
Nodes (4): Bool, TimeInterval, ClosedRange, TimeInterval

### Community 22 - "PersistedProject"
Cohesion: 0.32
Nodes (15): Codable, Equatable, PersistedClip, PersistedProject, PersistedTrack, Bool, Decoder, Double (+7 more)

### Community 23 - "FaderMeterStripView"
Cohesion: 0.17
Nodes (11): .mainVolumeControl, FaderMeterStripView, .reservesThumbClearance, .showsUnityMark, .usesUnityCenterDecibelScale, Bool, CGFloat, ClosedRange (+3 more)

### Community 24 - ".applyImportedStems"
Cohesion: 0.24
Nodes (4): Error, Result, String, URL

### Community 25 - "ProjectPersistenceService"
Cohesion: 0.28
Nodes (6): unsupportedVersion, ProjectPersistenceService, Bool, DAWProject, URL, UUID

### Community 26 - ".seek"
Cohesion: 0.15
Nodes (6): Content, View, .body, Bool, .transportControls, Timer

### Community 27 - ".groupVolumeBinding"
Cohesion: 0.31
Nodes (5): .masterVolumeBinding, Binding, Double, UUID, .masterVolumeBinding

### Community 28 - "Foundation"
Cohesion: 0.22
Nodes (5): AVFoundation, CoreAudio, Foundation, Observation, SnapGrid

### Community 29 - "CodingKeys"
Cohesion: 0.06
Nodes (31): CodingKey, CodingKeys, audioSettings, colorHex, id, isLocked, isMuted, isSnapEnabled (+23 more)

### Community 30 - "PropertiesSidebarView"
Cohesion: 0.14
Nodes (17): PropertiesSidebarView, .body, .pitchIsOriginal, .pitchLabel, .sectionCreationHint, .selectedDevice, .selectedDeviceID, .selectedSection (+9 more)

### Community 31 - "AudioTrack"
Cohesion: 0.06
Nodes (44): Date, Encoder, AudioTrack, .color, .displayName, Bool, Double, StandardTrackRole (+36 more)

### Community 32 - "SimplePlayProjectArchive"
Cohesion: 0.16
Nodes (15): Asset, SimplePlayProjectArchive, SimplePlayProjectArchiveError, corruptAsset, corruptManifest, .errorDescription, invalidArchive, Bool (+7 more)

### Community 33 - "TrackControlButton"
Cohesion: 0.22
Nodes (8): PanKnobView, .body, Bool, Double, String, Void, TrackControlButton, .body

### Community 34 - "MixerPanelView"
Cohesion: 0.11
Nodes (19): MixerPanelView, .body, .channelFaderHeight, .channelFaderWidth, .channelStripWidth, .isCompact, .masterFaderHeight, .mastersStripRow (+11 more)

### Community 35 - "TrackHeaderRowView"
Cohesion: 0.25
Nodes (8): Binding, Double, TrackHeaderRowView, .displayColor, .liveTrack, .trackPan, .trackVolumeBinding, TrackReorderHandle

### Community 36 - "Testing"
Cohesion: 0.23
Nodes (4): SimplePlay, ProjectArchiveTests, SimplePlayTests, Testing

### Community 37 - "AudioDeviceService"
Cohesion: 0.26
Nodes (5): AudioDeviceID, AudioDeviceService, Bool, Int, String

### Community 38 - "TrackPitchControlView"
Cohesion: 0.15
Nodes (13): Binding, Bool, Double, String, UUID, TrackPitchControlView, .menuTitle, .pitchIsOriginal (+5 more)

### Community 39 - "MacWindowTitleBarHidden.swift"
Cohesion: 0.11
Nodes (15): Notification, NSApplicationDelegate, NSEvent, NSObject, NSView, NSViewRepresentable, NSWindow, .body (+7 more)

### Community 40 - "WorkspaceViewModel"
Cohesion: 0.09
Nodes (18): ImportPanelKind, audioFiles, folder, Int, Set, WorkspaceViewModel, .activePitchTrack, .canSaveDirectlyToCurrentURL (+10 more)

### Community 41 - "ProjectPersistenceError"
Cohesion: 0.17
Nodes (12): JSONDecoder, .projectDecoder, JSONEncoder, .pretty, ManifestFile, ProjectPersistenceError, .errorDescription, invalidPackage (+4 more)

### Community 42 - "TransportBarView"
Cohesion: 0.06
Nodes (37): Bool, CGFloat, CGSize, Gesture, TimeInterval, TimelineOverviewBar, .barHeight, .body (+29 more)

### Community 43 - "SwiftUI"
Cohesion: 0.20
Nodes (4): AppKit, ResizablePropertiesSidebar, .body, SwiftUI

### Community 44 - ".peaks"
Cohesion: 0.08
Nodes (34): AVAudioPCMBuffer, CheckedContinuation, Never, clips, Double, Float, Int, MainActor (+26 more)

### Community 45 - "PitchShiftSettings"
Cohesion: 0.31
Nodes (5): PitchShiftSettings, AVAudioUnitTimePitch, Double, Float, PitchShiftSettingsTests

### Community 46 - "Sendable"
Cohesion: 0.24
Nodes (13): Double, Hashable, Sendable, AudioOutputDevice, AudioSampleRate, .displayName, .id, rate44100 (+5 more)

### Community 47 - "MIDIInputService"
Cohesion: 0.10
Nodes (20): CoreMIDI, Identifiable, MIDINotifyProc, MIDIPacketList, MIDIReadProc, MIDIInputService, MIDISourceInfo, .id (+12 more)

### Community 49 - "SidebarPanel"
Cohesion: 0.27
Nodes (11): .audioSettings, .playbackSettings, .sectionEditor, .trackPitch, .volumeControls, SidebarLabeledRow, .body, SidebarPanel (+3 more)

### Community 50 - "DAWProject"
Cohesion: 0.31
Nodes (9): DAWProject, .duration, Bool, Double, Int32, String, TimeInterval, UInt8 (+1 more)

### Community 51 - "UUID"
Cohesion: 0.15
Nodes (8): SectionDragKind, move, resizeEnd, resizeStart, Float, UUID, .body, .chipMoveOrTapGesture

### Community 52 - "CGFloat"
Cohesion: 0.17
Nodes (9): CGFloat, TimelineScrollAlignment, center, leading, start, TimelineScrollRequest, .minimumTimelineZoom, .timelineContentWidth (+1 more)

### Community 53 - "DAWTheme"
Cohesion: 0.20
Nodes (10): .groupDivider, .pinnedMastersColumn, .projectMasterStrip, .markerHeaderRow, DAWTheme, .isPhone, Bool, CGFloat (+2 more)

### Community 54 - "DAWVerticalFaderView"
Cohesion: 0.09
Nodes (25): ClosedRange, Double, Float, String, TrackVolumeSettings, .trackRange, DAWVerticalFaderView, .body (+17 more)

### Community 56 - "MIDILearnTarget"
Cohesion: 0.22
Nodes (8): MIDILearnTarget, loopToggle, section, MIDINoteAssignment, .displayName, String, UInt8, UUID

### Community 57 - "View"
Cohesion: 0.16
Nodes (18): ButtonStyle, Configuration, .selectedMarkerEditor, DAWIconToolbarButtonStyle, DAWPrimaryButtonStyle, DAWSecondaryButtonStyle, Bool, String (+10 more)

### Community 62 - ".format"
Cohesion: 0.22
Nodes (7): Bool, String, TimeInterval, TimeFormatting, .formattedCurrentTime, .formattedDuration, .selectionInfo

### Community 65 - ".body"
Cohesion: 0.14
Nodes (9): DAWProject, Binding, Bool, String, WorkspaceSettingsView, .body, .deleteSectionDialogTitle, .sectionDeletionDialogBinding (+1 more)

### Community 66 - "ContentView"
Cohesion: 0.20
Nodes (9): App, Commands, Scene, ContentView, .body, FileCommands, TransportCommands, SimplePlayApp (+1 more)

### Community 68 - "TrackWaveformProgressBar"
Cohesion: 0.40
Nodes (4): Bool, Double, TrackWaveformProgressBar, .body

### Community 71 - ".mixerChannelStrip"
Cohesion: 0.33
Nodes (3): Double, .mixerScrollWithPinnedMasters, .body

## Knowledge Gaps
- **269 isolated node(s):** `id`, `name`, `startTime`, `endTime`, `colorHex` (+264 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **7 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `WorkspaceViewModel` connect `WorkspaceViewModel` to `SectionMarkerChipMetrics`, `MIDIMappingBarView`, `AudioClip`, `SavedProjectDocument`, `ArrangementSection`, `AudioImportDocumentPicker`, `TimelineWorkspacePanel`, `AudioImportService`, `AudioEngineService`, `StandardTrackRole`, `TimeInterval`, `.applyImportedStems`, `ProjectPersistenceService`, `.seek`, `.groupVolumeBinding`, `Foundation`, `PropertiesSidebarView`, `AudioTrack`, `MixerPanelView`, `TrackHeaderRowView`, `AudioDeviceService`, `TrackPitchControlView`, `TransportBarView`, `SwiftUI`, `Sendable`, `MIDIInputService`, `.applyLoadedProject`, `UUID`, `CGFloat`, `WorkspaceKeyboardShortcuts`, `MIDILearnTarget`, `View`, `.format`, `.body`, `ContentView`, `.mixerChannelStrip`, `.sessionManagement`?**
  _High betweenness centrality (0.381) - this node is a cross-community bridge._
- **Why does `Foundation` connect `Foundation` to `SimplePlayProjectArchive`, `AudioClip`, `Testing`, `ProjectPersistenceError`, `SwiftUI`, `Sendable`, `MIDIInputService`, `AudioImportDocumentPicker`, `.standardize`, `DAWProject`, `AudioImportService`, `StandardTrackRole`, `PersistedProject`, `DAWVerticalFaderView`, `MIDILearnTarget`, `CoreGraphics`, `.format`, `AudioTrack`?**
  _High betweenness centrality (0.105) - this node is a cross-community bridge._
- **Why does `AudioTrack` connect `AudioTrack` to `MixerPanelView`, `TrackHeaderRowView`, `AudioClip`, `.mixerChannelStrip`, `WorkspaceViewModel`, `SwiftUI`, `PitchShiftSettings`, `Sendable`, `MIDIInputService`, `DAWProject`, `PersistedProject`, `ProjectPersistenceService`?**
  _High betweenness centrality (0.086) - this node is a cross-community bridge._
- **Are the 13 inferred relationships involving `WorkspaceViewModel` (e.g. with `ArrangementPlaybackEngine` and `AudioEngineService`) actually correct?**
  _`WorkspaceViewModel` has 13 INFERRED edges - model-reasoned connections that need verification._
- **Are the 2 inferred relationships involving `AudioEngineService` (e.g. with `WorkspaceViewModel` and `.configureAudioEngine()`) actually correct?**
  _`AudioEngineService` has 2 INFERRED edges - model-reasoned connections that need verification._
- **Are the 4 inferred relationships involving `ArrangementSection` (e.g. with `.body` and `.body`) actually correct?**
  _`ArrangementSection` has 4 INFERRED edges - model-reasoned connections that need verification._
- **Are the 3 inferred relationships involving `AudioTrack` (e.g. with `.duration` and `.hasSoloTracks`) actually correct?**
  _`AudioTrack` has 3 INFERRED edges - model-reasoned connections that need verification._