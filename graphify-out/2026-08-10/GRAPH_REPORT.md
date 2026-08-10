# Graph Report - SimplePlay  (2026-08-10)

## Corpus Check
- 92 files · ~44,582 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 1520 nodes · 3441 edges · 74 communities (64 shown, 10 thin omitted)
- Extraction: 90% EXTRACTED · 10% INFERRED · 0% AMBIGUOUS · INFERRED: 353 edges (avg confidence: 0.8)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `8ca18b61`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- SimplePlayUITests
- TimelineWorkspacePanel
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
- ArrangementPlaybackEngine
- SectionLoopContext
- Content
- TransportBarView
- AudioImportService
- AudioEngineService
- StandardTrackRole
- .applyImportedStems
- SimplePlayProjectArchive
- MIDIMappingBarView
- Sendable
- TopToolbarView
- TimeInterval
- SectionPlaybackMode
- Testing
- CodingKeys
- .body
- AudioTrack
- DAWProject
- .body
- MixerPanelView
- SupportedAudioFormats
- .sessionManagement
- .standardize
- AudioDeviceService
- MacWindowTitleBarHidden.swift
- .previewRangeForSectionDrag
- .frames
- .handleIncomingMIDI
- CodingKeys
- .peaks
- AudioSampleRate
- ArrangementSection
- MIDIInputService
- TrackWaveformProgressBar
- SwiftUI
- PitchShiftSettings
- .configure
- WorkspaceViewModel
- .activeGroupIndex
- DAWVerticalFaderView
- .installMetersSafely
- .loadBucket
- MIDINoteAssignment
- .log
- UIKitToolbarMenuButtonRepresentable
- .nextDistinctHex
- View
- TrackPitchControlView
- CodingKeys
- WorkspaceView
- AudioEngineError
- .ensureDistinctColors
- AVAudioUnitTimePitch
- UInt32
- UUID
- Set
- URL
- DAWSecondaryButtonStyle
- CGFloat

## God Nodes (most connected - your core abstractions)
1. `WorkspaceViewModel` - 214 edges
2. `AudioEngineService` - 55 edges
3. `AudioTrack` - 40 edges
4. `DAWTheme` - 37 edges
5. `ArrangementPlaybackEngine` - 36 edges
6. `TimelineWorkspacePanel` - 35 edges
7. `MixerPanelView` - 35 edges
8. `ArrangementSection` - 34 edges
9. `StandardTrackRole` - 31 edges
10. `PropertiesSidebarView` - 31 edges

## Surprising Connections (you probably didn't know these)
- `.selectedDevice` --references--> `WorkspaceViewModel`  [INFERRED]
  SimplePlay/Features/Workspace/Views/PropertiesSidebarView.swift → SimplePlay/Features/Workspace/ViewModels/WorkspaceViewModel.swift
- `.duration` --references--> `AudioTrack`  [INFERRED]
  SimplePlay/Core/Models/DAWProject.swift → SimplePlay/Core/Models/AudioTrack.swift
- `WorkspaceViewModel` --calls--> `ArrangementPlaybackEngine`  [INFERRED]
  SimplePlay/Features/Workspace/ViewModels/WorkspaceViewModel.swift → SimplePlay/Core/Services/ArrangementPlaybackEngine.swift
- `WorkspaceViewModel` --calls--> `AudioEngineService`  [INFERRED]
  SimplePlay/Features/Workspace/ViewModels/WorkspaceViewModel.swift → SimplePlay/Core/Services/AudioEngineService.swift
- `WorkspaceViewModel` --calls--> `AudioImportService`  [INFERRED]
  SimplePlay/Features/Workspace/ViewModels/WorkspaceViewModel.swift → SimplePlay/Core/Services/AudioImportService.swift

## Import Cycles
- None detected.

## Communities (74 total, 10 thin omitted)

### Community 0 - "SimplePlayUITests"
Cohesion: 0.15
Nodes (6): SimplePlayUITests, SimplePlayUITestsLaunchTests, .runsForEachTargetApplicationUIConfiguration, Bool, XCTest, XCTestCase

### Community 1 - "TimelineWorkspacePanel"
Cohesion: 0.05
Nodes (63): AppKit, Content, NSCursor, ResizeEdge, end, start, SectionCreationPreviewView, .body (+55 more)

### Community 2 - "PropertiesSidebarView"
Cohesion: 0.07
Nodes (36): Bool, String, TimeInterval, TimeFormatting, .formattedCurrentTime, .formattedDuration, PropertiesSidebarView, .audioSettings (+28 more)

### Community 3 - "What You Must Do When Invoked"
Cohesion: 0.08
Nodes (24): For /graphify add and --watch, For /graphify query, For the commit hook and native AGENTS.md integration, For --update and --cluster-only, /graphify, Honesty Rules, Interpreter guard for subcommands, Part A - Structural extraction for code files (+16 more)

### Community 4 - "TrackLaneView"
Cohesion: 0.08
Nodes (29): G, GraphicsContext, Path, CGFloat, String, TimeInterval, TimelineRulerScale, View (+21 more)

### Community 5 - "graphify reference: extra exports and benchmark"
Cohesion: 0.22
Nodes (8): graphify reference: extra exports and benchmark, Step 6b - Wiki (only if --wiki flag), Step 7 - Neo4j export (only if --neo4j or --neo4j-push flag), Step 7a - FalkorDB export (only if --falkordb or --falkordb-push flag), Step 7b - SVG export (only if --svg flag), Step 7c - GraphML export (only if --graphml flag), Step 7d - MCP server (only if --mcp flag), Step 8 - Token reduction benchmark (only if total_words > 5000)

### Community 6 - "Foundation"
Cohesion: 0.18
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

### Community 14 - "ArrangementPlaybackEngine"
Cohesion: 0.13
Nodes (20): ArrangementPlaybackEngine, PlaybackState, continuingTimeline, idle, playingSection, repeatingSectionAtEnd, waitingToJump, SectionTriggerResult (+12 more)

### Community 15 - "SectionLoopContext"
Cohesion: 0.24
Nodes (11): AVAudioFrameCount, AVAudioTime, SectionLoopContext, .duration, TimeInterval, UUID, Bool, Int (+3 more)

### Community 17 - "TransportBarView"
Cohesion: 0.06
Nodes (38): .masterVolumeBinding, .masterVolumeBinding, Bool, CGFloat, CGSize, Gesture, TimeInterval, TimelineOverviewBar (+30 more)

### Community 18 - "AudioImportService"
Cohesion: 0.12
Nodes (19): LocalizedError, AudioFileStorageService, String, URL, UUID, AudioImportError, emptySelection, .errorDescription (+11 more)

### Community 19 - "AudioEngineService"
Cohesion: 0.16
Nodes (8): AVAudioNode, AVAudioPlayerNode, AudioEngineService, .isPlaybackGraphReady, .masterVolume, .playbackGraphIsHealthy, .primaryClipSampleRate, Double

### Community 20 - "StandardTrackRole"
Cohesion: 0.08
Nodes (24): StandardTrackRole, acousticGuitar, backingVocal, bass, brass, click, countIn, cue (+16 more)

### Community 21 - ".applyImportedStems"
Cohesion: 0.13
Nodes (9): Error, Result, .body, ImportPanelKind, audioFiles, folder, String, TrackOrganizationService (+1 more)

### Community 22 - "SimplePlayProjectArchive"
Cohesion: 0.16
Nodes (15): Asset, SimplePlayProjectArchive, SimplePlayProjectArchiveError, corruptAsset, corruptManifest, .errorDescription, invalidArchive, Bool (+7 more)

### Community 23 - "MIDIMappingBarView"
Cohesion: 0.11
Nodes (20): Animation, AnyTransition, MIDIMappingBarView, .body, .collapsedBar, .collapsedBarContent, .devicePickerLabel, .devicePickerTitle (+12 more)

### Community 24 - "Sendable"
Cohesion: 0.05
Nodes (58): Codable, Equatable, SavedProjectDocument, Sendable, AudioClip, .endTime, Int, String (+50 more)

### Community 25 - "TopToolbarView"
Cohesion: 0.17
Nodes (16): Bool, String, Void, ToolbarMenuButtonStyleModifier, TopToolbarView, .importButton, .importMenuItems, .isCompact (+8 more)

### Community 26 - "TimeInterval"
Cohesion: 0.18
Nodes (7): SectionEdgeGuides, ArrangementSection, Bool, TimeInterval, .activeSectionEdgeGuides, .transportControls, Timer

### Community 27 - "SectionPlaybackMode"
Cohesion: 0.15
Nodes (12): CaseIterable, SectionPlaybackMode, continueTimeline, continueToNext, .displayName, .id, oneShot, repeatSection (+4 more)

### Community 28 - "Testing"
Cohesion: 0.22
Nodes (4): SimplePlay, ProjectArchiveTests, SimplePlayTests, Testing

### Community 29 - "CodingKeys"
Cohesion: 0.08
Nodes (24): CodingKeys, audioSettings, colorHex, id, isLocked, isMuted, isSnapEnabled, isSolo (+16 more)

### Community 31 - "AudioTrack"
Cohesion: 0.05
Nodes (52): Date, Encoder, AudioTrack, .color, .displayName, Bool, Double, StandardTrackRole (+44 more)

### Community 32 - "DAWProject"
Cohesion: 0.31
Nodes (9): DAWProject, .duration, Bool, Double, Int32, String, TimeInterval, UInt8 (+1 more)

### Community 33 - ".body"
Cohesion: 0.20
Nodes (8): Binding, Bool, String, WorkspaceSettingsView, .body, .deleteSectionDialogTitle, .sectionDeletionDialogBinding, .body

### Community 34 - "MixerPanelView"
Cohesion: 0.05
Nodes (43): MixerPanelView, .body, .channelFaderHeight, .channelFaderWidth, .channelStripWidth, .isCompact, .masterFaderHeight, .mastersStripRow (+35 more)

### Community 35 - "SupportedAudioFormats"
Cohesion: 0.05
Nodes (37): FileDocument, FileWrapper, ReadConfiguration, SimplePlayProjectFileDocument, .readableContentTypes, Data, DropURLLoader, NSItemProvider (+29 more)

### Community 36 - ".sessionManagement"
Cohesion: 0.22
Nodes (6): .sessionManagement, .projectSessionButton, .projectSessionMenuItems, ProjectSessionToolbarMenuButton, .body, UIKit

### Community 37 - ".standardize"
Cohesion: 0.23
Nodes (7): StandardizedName, Bool, StandardTrackRole, String, URL, TrackNameStandardizer, TrackNameStandardizerTests

### Community 38 - "AudioDeviceService"
Cohesion: 0.26
Nodes (5): AudioDeviceID, AudioDeviceService, Bool, Int, String

### Community 39 - "MacWindowTitleBarHidden.swift"
Cohesion: 0.11
Nodes (15): Notification, NSApplicationDelegate, NSEvent, NSObject, NSView, NSViewRepresentable, NSWindow, .body (+7 more)

### Community 40 - ".previewRangeForSectionDrag"
Cohesion: 0.22
Nodes (5): SectionDragKind, move, resizeEnd, resizeStart, .chipMoveOrTapGesture

### Community 41 - ".frames"
Cohesion: 0.29
Nodes (6): Bool, Double, Int64, TimeInterval, TimelineSampleGrid, TimelineSampleGridTests

### Community 42 - ".handleIncomingMIDI"
Cohesion: 0.20
Nodes (4): MIDIInputEvent, MIDILearnTarget, UInt8, .body

### Community 43 - "CodingKeys"
Cohesion: 0.17
Nodes (12): CodingKeys, colorHex, endTime, id, midiChannel, midiNote, midiUsesControlChange, name (+4 more)

### Community 44 - ".peaks"
Cohesion: 0.09
Nodes (30): AVAudioPCMBuffer, CheckedContinuation, Never, clips, Double, Float, Int, MainActor (+22 more)

### Community 45 - "AudioSampleRate"
Cohesion: 0.23
Nodes (13): Double, Hashable, Identifiable, AudioOutputDevice, AudioSampleRate, .displayName, .id, rate44100 (+5 more)

### Community 46 - "ArrangementSection"
Cohesion: 0.31
Nodes (9): ArrangementSection, .color, .duration, Bool, Decoder, String, TimeInterval, UInt8 (+1 more)

### Community 47 - "MIDIInputService"
Cohesion: 0.08
Nodes (24): CoreMIDI, MIDINotifyProc, MIDIPacket, MIDIPacketList, MIDISourceInfo, MIDIInputEvent, MIDIInputService, MIDISourceInfo (+16 more)

### Community 48 - "TrackWaveformProgressBar"
Cohesion: 0.40
Nodes (4): Bool, Double, TrackWaveformProgressBar, .body

### Community 49 - "SwiftUI"
Cohesion: 0.14
Nodes (10): App, Commands, Scene, ContentView, .body, FileCommands, TransportCommands, SimplePlayApp (+2 more)

### Community 50 - "PitchShiftSettings"
Cohesion: 0.31
Nodes (5): PitchShiftSettings, AVAudioUnitTimePitch, Double, Float, PitchShiftSettingsTests

### Community 51 - ".configure"
Cohesion: 0.17
Nodes (10): AudioSampleRate, AudioSettings, AVAudioFile, AVAudioMixerNode, AVAudioUnitEQ, AVAudioUnitTimePitch, ScheduledClip, AudioClip (+2 more)

### Community 52 - "WorkspaceViewModel"
Cohesion: 0.07
Nodes (21): AudioOutputDevice, SectionPlaybackMode, Set, ClosedRange, DAWProject, WorkspaceViewModel, .activePitchTrack, .canSaveDirectlyToCurrentURL (+13 more)

### Community 53 - ".activeGroupIndex"
Cohesion: 0.22
Nodes (3): AudioClip, Int, .trackHeaderColumnTracksOnly

### Community 54 - "DAWVerticalFaderView"
Cohesion: 0.09
Nodes (25): ClosedRange, Double, Float, String, TrackVolumeSettings, .trackRange, DAWVerticalFaderView, .body (+17 more)

### Community 55 - ".installMetersSafely"
Cohesion: 0.33
Nodes (3): Float, UUID, Void

### Community 56 - ".loadBucket"
Cohesion: 0.31
Nodes (5): CoreGraphics, CGFloat, Int, WaveformLOD, .requiredLOD

### Community 57 - "MIDINoteAssignment"
Cohesion: 0.38
Nodes (6): MIDINoteAssignment, .displayName, Bool, String, UInt8, .loopAssignmentLabel

### Community 58 - ".log"
Cohesion: 0.44
Nodes (5): SectionLoopDiagnostics, Double, Int64, String, TimeInterval

### Community 59 - "UIKitToolbarMenuButtonRepresentable"
Cohesion: 0.33
Nodes (7): Coordinator, Context, String, Void, UIKitToolbarMenuButtonRepresentable, UIButton, UIViewRepresentable

### Community 60 - ".nextDistinctHex"
Cohesion: 0.47
Nodes (5): SectionMarkerPalette, .palette, Int, Set, String

### Community 61 - "View"
Cohesion: 0.14
Nodes (16): Configuration, .groupDivider, .pinnedMastersColumn, .markerHeaderRow, AudioDropOverlay, .body, String, TimelineEmptyDropHint (+8 more)

### Community 62 - "TrackPitchControlView"
Cohesion: 0.15
Nodes (14): .actionButtons, Binding, Bool, Double, String, UUID, TrackPitchControlView, .menuTitle (+6 more)

### Community 63 - "CodingKeys"
Cohesion: 0.25
Nodes (8): CodingKey, CodingKeys, horizontalOffset, id, importedAt, name, pitchSemitones, volume

### Community 64 - "WorkspaceView"
Cohesion: 0.33
Nodes (7): Binding, Bool, String, WorkspaceView, .deleteSectionDialogTitle, .phoneBottomChrome, .sectionDeletionDialogBinding

### Community 65 - "AudioEngineError"
Cohesion: 0.29
Nodes (7): AudioEngineError, clipLoadFailed, deviceSelectionFailed, engineStartFailed, .errorDescription, noPlayableClips, playbackUnavailable

### Community 69 - "UUID"
Cohesion: 0.15
Nodes (7): AudioTrack, Bool, TimeInterval, Double, Float, UUID, .body

### Community 76 - "DAWSecondaryButtonStyle"
Cohesion: 0.33
Nodes (8): ButtonStyle, .selectedMarkerEditor, DAWIconToolbarButtonStyle, DAWLabeledToolbarButtonStyle, DAWPrimaryButtonStyle, DAWSecondaryButtonStyle, Content, .body

### Community 77 - "CGFloat"
Cohesion: 0.15
Nodes (9): CGFloat, TimelineScrollAlignment, center, leading, start, TimelineScrollRequest, .minimumTimelineZoom, .timelineContentWidth (+1 more)

## Knowledge Gaps
- **267 isolated node(s):** `.duration`, `idle`, `playingSection`, `repeatingSectionAtEnd`, `waitingToJump` (+262 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **10 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `WorkspaceViewModel` connect `WorkspaceViewModel` to `TimelineWorkspacePanel`, `PropertiesSidebarView`, `TrackLaneView`, `Foundation`, `ArrangementPlaybackEngine`, `TransportBarView`, `AudioImportService`, `AudioEngineService`, `.applyImportedStems`, `MIDIMappingBarView`, `Sendable`, `TopToolbarView`, `TimeInterval`, `.body`, `AudioTrack`, `.body`, `MixerPanelView`, `SupportedAudioFormats`, `.sessionManagement`, `AudioDeviceService`, `.previewRangeForSectionDrag`, `.handleIncomingMIDI`, `MIDIInputService`, `SwiftUI`, `.activeGroupIndex`, `TrackPitchControlView`, `WorkspaceView`, `UUID`, `CGFloat`?**
  _High betweenness centrality (0.445) - this node is a cross-community bridge._
- **Why does `Foundation` connect `Foundation` to `DAWProject`, `PropertiesSidebarView`, `SupportedAudioFormats`, `.standardize`, `.frames`, `AudioSampleRate`, `MIDIInputService`, `SwiftUI`, `AudioImportService`, `SimplePlayProjectArchive`, `DAWVerticalFaderView`, `Sendable`, `.loadBucket`, `SectionPlaybackMode`, `Testing`, `AudioTrack`?**
  _High betweenness centrality (0.083) - this node is a cross-community bridge._
- **Why does `AudioEngineService` connect `AudioEngineService` to `UUID`, `Foundation`, `SectionLoopContext`, `.configure`, `WorkspaceViewModel`, `.applyImportedStems`, `.installMetersSafely`?**
  _High betweenness centrality (0.081) - this node is a cross-community bridge._
- **Are the 12 inferred relationships involving `WorkspaceViewModel` (e.g. with `ArrangementPlaybackEngine` and `AudioEngineService`) actually correct?**
  _`WorkspaceViewModel` has 12 INFERRED edges - model-reasoned connections that need verification._
- **Are the 2 inferred relationships involving `AudioEngineService` (e.g. with `WorkspaceViewModel` and `.configureAudioEngine()`) actually correct?**
  _`AudioEngineService` has 2 INFERRED edges - model-reasoned connections that need verification._
- **Are the 3 inferred relationships involving `AudioTrack` (e.g. with `.duration` and `.hasSoloTracks`) actually correct?**
  _`AudioTrack` has 3 INFERRED edges - model-reasoned connections that need verification._
- **What connects `.duration`, `idle`, `playingSection` to the rest of the system?**
  _267 weakly-connected nodes found - possible documentation gaps or missing edges._