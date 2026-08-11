# Graph Report - SimplePlay  (2026-08-10)

## Corpus Check
- 95 files · ~48,600 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 1624 nodes · 3821 edges · 83 communities (73 shown, 10 thin omitted)
- Extraction: 90% EXTRACTED · 10% INFERRED · 0% AMBIGUOUS · INFERRED: 364 edges (avg confidence: 0.8)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `874d7382`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- SimplePlayUITests
- SectionMarkerChipView
- Sendable
- What You Must Do When Invoked
- TrackLaneView
- graphify reference: extra exports and benchmark
- .selectedMarkerEditor
- graphify reference: query, path, explain
- graphify reference: add a URL and watch a folder
- graphify reference: commit hook and native AGENTS.md integration
- graphify reference: incremental update and cluster-only
- graphify reference: GitHub clone and cross-repo merge
- graphify reference: transcribe video and audio
- extraction-spec.md
- ArrangementPlaybackEngine
- MixerPanelView
- TimelineWorkspacePanel
- .play
- AudioImportService
- AudioEngineService
- StandardTrackRole
- .applyImportedStems
- .standardize
- MIDIMappingBarView
- SidebarPanel
- SectionPlaybackMode
- .loadBucket
- .frames
- TimelineOverviewBar
- CodingKeys
- Testing
- AudioTrack
- DAWProject
- SupportedAudioFormats
- ArrangementSection
- TransportBarView
- AudioSampleRate
- SwiftUI
- UUID
- AppKit
- DAWSecondaryButtonStyle
- View
- ScheduledClip
- ProjectPersistenceService
- .peaks
- AudioDeviceService
- CGFloat
- MIDIInputService
- Codable
- ProjectPersistenceError
- .log
- .nextDistinctHex
- SimplePlayProjectArchive
- SectionLoopContext
- DAWVerticalFaderView
- .addSection
- Foundation
- .stop
- TrackControlButton
- TimeInterval
- .snap
- PropertiesSidebarView
- .sectionMappingCard
- PitchShiftSettings
- SectionPlaybackStatus
- WorkspaceSettingsView
- TopToolbarView
- WorkspaceViewModel
- TimeInterval
- TrackPitchControlView
- Color
- DAWGlassChrome
- FaderMeterStripView
- UIKitToolbarMenuButtonRepresentable
- .setZoom
- WorkspaceView
- .setMasterVolume
- .groupVolumeBinding
- .sessionManagement
- CGSize
- ClosedRange
- Gesture
- LinearGradient

## God Nodes (most connected - your core abstractions)
1. `WorkspaceViewModel` - 237 edges
2. `AudioEngineService` - 81 edges
3. `ArrangementSection` - 61 edges
4. `DAWTheme` - 50 edges
5. `MIDIMappingBarView` - 44 edges
6. `AudioTrack` - 42 edges
7. `MixerPanelView` - 35 edges
8. `TimelineWorkspacePanel` - 35 edges
9. `ArrangementPlaybackEngine` - 34 edges
10. `StandardTrackRole` - 31 edges

## Surprising Connections (you probably didn't know these)
- `.duration` --references--> `AudioTrack`  [INFERRED]
  SimplePlay/Core/Models/DAWProject.swift → SimplePlay/Core/Models/AudioTrack.swift
- `.selectedDevice` --references--> `WorkspaceViewModel`  [INFERRED]
  SimplePlay/Features/Workspace/Views/PropertiesSidebarView.swift → SimplePlay/Features/Workspace/ViewModels/WorkspaceViewModel.swift
- `.phoneBottomDock` --calls--> `TimelineOverviewBar`  [INFERRED]
  SimplePlay/Features/Workspace/Views/TransportBarView.swift → SimplePlay/Features/Workspace/Views/TimelineOverviewBar.swift
- `.standardTransportBar` --calls--> `TimelineOverviewBar`  [INFERRED]
  SimplePlay/Features/Workspace/Views/TransportBarView.swift → SimplePlay/Features/Workspace/Views/TimelineOverviewBar.swift
- `.groupDivider` --references--> `DAWTheme`  [EXTRACTED]
  SimplePlay/Features/Workspace/Views/MixerPanelView.swift → SimplePlay/UI/Theme/DAWTheme.swift

## Import Cycles
- None detected.

## Communities (83 total, 10 thin omitted)

### Community 0 - "SimplePlayUITests"
Cohesion: 0.15
Nodes (6): SimplePlayUITests, SimplePlayUITestsLaunchTests, .runsForEachTargetApplicationUIConfiguration, Bool, XCTest, XCTestCase

### Community 1 - "SectionMarkerChipView"
Cohesion: 0.11
Nodes (29): NSCursor, ResizeEdge, end, start, SectionCreationPreviewView, .body, SectionDragSession, SectionEdgeGuideOverlay (+21 more)

### Community 2 - "Sendable"
Cohesion: 0.19
Nodes (21): Equatable, Sendable, MIDILearnTarget, section, UUID, PersistedClip, PersistedProject, PersistedTrack (+13 more)

### Community 3 - "What You Must Do When Invoked"
Cohesion: 0.08
Nodes (24): For /graphify add and --watch, For /graphify query, For the commit hook and native AGENTS.md integration, For --update and --cluster-only, /graphify, Honesty Rules, Interpreter guard for subcommands, Part A - Structural extraction for code files (+16 more)

### Community 4 - "TrackLaneView"
Cohesion: 0.09
Nodes (25): G, GraphicsContext, CGFloat, String, TimeInterval, TimelineRulerScale, ClipDragInteractionModifier, ClipSelectionModifiers (+17 more)

### Community 5 - "graphify reference: extra exports and benchmark"
Cohesion: 0.22
Nodes (8): graphify reference: extra exports and benchmark, Step 6b - Wiki (only if --wiki flag), Step 7 - Neo4j export (only if --neo4j or --neo4j-push flag), Step 7a - FalkorDB export (only if --falkordb or --falkordb-push flag), Step 7b - SVG export (only if --svg flag), Step 7c - GraphML export (only if --graphml flag), Step 7d - MCP server (only if --mcp flag), Step 8 - Token reduction benchmark (only if total_words > 5000)

### Community 6 - ".selectedMarkerEditor"
Cohesion: 0.18
Nodes (10): Bool, String, TimeInterval, .formattedCurrentTime, .formattedDuration, .selectedMarkerEditor, .body, .body (+2 more)

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
Nodes (19): ArrangementPlaybackEngine, PlaybackState, continuingTimeline, idle, playingSection, repeatingSectionAtEnd, waitingToJump, SectionTriggerResult (+11 more)

### Community 15 - "MixerPanelView"
Cohesion: 0.11
Nodes (19): MixerPanelView, .body, .channelFaderHeight, .channelFaderWidth, .channelStripWidth, .groupDivider, .isCompact, .masterFaderHeight (+11 more)

### Community 16 - "TimelineWorkspacePanel"
Cohesion: 0.10
Nodes (29): PlayheadView, .body, .playheadDragGesture, Bool, CGFloat, Content, Double, Gesture (+21 more)

### Community 18 - "AudioImportService"
Cohesion: 0.12
Nodes (19): LocalizedError, AudioFileStorageService, String, URL, UUID, AudioImportError, emptySelection, .errorDescription (+11 more)

### Community 19 - "AudioEngineService"
Cohesion: 0.11
Nodes (13): AVAudioMixerNode, AVAudioUnitEQ, AudioEngineService, .isAnyPlayerPlaying, .isPlaybackGraphReady, .isSectionLoopPlaybackActive, .masterVolume, .playbackGraphIsHealthy (+5 more)

### Community 20 - "StandardTrackRole"
Cohesion: 0.08
Nodes (24): StandardTrackRole, acousticGuitar, backingVocal, bass, brass, click, countIn, cue (+16 more)

### Community 21 - ".applyImportedStems"
Cohesion: 0.16
Nodes (6): Error, Result, DAWProject, String, URL, .body

### Community 22 - ".standardize"
Cohesion: 0.23
Nodes (7): StandardizedName, Bool, StandardTrackRole, String, URL, TrackNameStandardizer, TrackNameStandardizerTests

### Community 23 - "MIDIMappingBarView"
Cohesion: 0.12
Nodes (16): Animation, AnyTransition, MIDIMappingBarView, .assignModeToggleTitle, .body, .collapsedBar, .devicePickerLabel, .devicePickerTitle (+8 more)

### Community 24 - "SidebarPanel"
Cohesion: 0.09
Nodes (35): Selection, .playbackSettings, .sectionEditor, .selectionInfo, .trackPitch, .volumeControls, .pitchMenu, SettingsBadge (+27 more)

### Community 25 - "SectionPlaybackMode"
Cohesion: 0.15
Nodes (12): CaseIterable, SectionPlaybackMode, continueTimeline, continueToNext, .displayName, .id, oneShot, repeatSection (+4 more)

### Community 26 - ".loadBucket"
Cohesion: 0.53
Nodes (4): CGFloat, Int, WaveformLOD, .requiredLOD

### Community 27 - ".frames"
Cohesion: 0.30
Nodes (6): Bool, Double, Int64, TimeInterval, TimelineSampleGrid, TimelineSampleGridTests

### Community 28 - "TimelineOverviewBar"
Cohesion: 0.11
Nodes (21): CGSize, ClosedRange, Gesture, LinearGradient, Bool, CGFloat, TimeInterval, TimelineOverviewBar (+13 more)

### Community 29 - "CodingKeys"
Cohesion: 0.05
Nodes (44): CodingKey, CodingKeys, colorHex, endTime, id, midiChannel, midiNote, midiUsesControlChange (+36 more)

### Community 30 - "Testing"
Cohesion: 0.18
Nodes (5): CoreGraphics, SimplePlay, ProjectArchiveTests, SimplePlayTests, Testing

### Community 31 - "AudioTrack"
Cohesion: 0.06
Nodes (48): Encoder, AudioClip, .endTime, Int, String, TimeInterval, URL, UUID (+40 more)

### Community 32 - "DAWProject"
Cohesion: 0.31
Nodes (9): DAWProject, .duration, Bool, Double, Int32, String, TimeInterval, UInt8 (+1 more)

### Community 33 - "SupportedAudioFormats"
Cohesion: 0.05
Nodes (37): FileDocument, FileWrapper, ReadConfiguration, SimplePlayProjectFileDocument, .readableContentTypes, Data, DropURLLoader, NSItemProvider (+29 more)

### Community 34 - "ArrangementSection"
Cohesion: 0.23
Nodes (9): ArrangementSection, .color, .duration, Bool, Decoder, String, TimeInterval, UInt8 (+1 more)

### Community 35 - "TransportBarView"
Cohesion: 0.11
Nodes (19): Bool, CGFloat, Double, String, Void, TransportBarStyle, phoneBottomDock, standard (+11 more)

### Community 36 - "AudioSampleRate"
Cohesion: 0.16
Nodes (14): Double, Hashable, Identifiable, AudioOutputDevice, AudioSampleRate, .displayName, .id, rate44100 (+6 more)

### Community 37 - "SwiftUI"
Cohesion: 0.18
Nodes (7): SectionMappingPlayButtonStyle, Bool, Double, TrackWaveformProgressBar, .body, SwiftUI, UIKit

### Community 38 - "UUID"
Cohesion: 0.11
Nodes (14): Double, Float, UInt8, UUID, .mixerScrollWithPinnedMasters, .selectedTrackPitchBinding, Binding, Double (+6 more)

### Community 39 - "AppKit"
Cohesion: 0.09
Nodes (18): AppKit, Notification, NSApplicationDelegate, NSEvent, NSObject, NSView, NSViewRepresentable, NSWindow (+10 more)

### Community 40 - "DAWSecondaryButtonStyle"
Cohesion: 0.24
Nodes (9): ButtonStyle, .collapsedBarContent, DAWIconToolbarButtonStyle, DAWLabeledToolbarButtonStyle, DAWPrimaryButtonStyle, DAWSecondaryButtonStyle, Content, .body (+1 more)

### Community 41 - "View"
Cohesion: 0.10
Nodes (18): .assignModeToggle, .learnBanner, Configuration, Content, .markerHeaderRow, Configuration, AudioDropOverlay, .body (+10 more)

### Community 42 - "ScheduledClip"
Cohesion: 0.21
Nodes (10): AVAudioFile, AudioEngineError, clipLoadFailed, deviceSelectionFailed, engineStartFailed, .errorDescription, noPlayableClips, playbackUnavailable (+2 more)

### Community 43 - "ProjectPersistenceService"
Cohesion: 0.26
Nodes (7): missingAudioFile, unsupportedVersion, ProjectPersistenceService, Bool, DAWProject, URL, UUID

### Community 44 - ".peaks"
Cohesion: 0.09
Nodes (31): AVAudioPCMBuffer, CheckedContinuation, Never, Path, clips, Double, Float, Int (+23 more)

### Community 45 - "AudioDeviceService"
Cohesion: 0.26
Nodes (6): AudioDeviceID, AudioDeviceService, Bool, Int, String, .audioSettings

### Community 46 - "CGFloat"
Cohesion: 0.13
Nodes (10): SectionDragKind, move, resizeEnd, resizeStart, CGFloat, TimelineScrollRequest, .minimumTimelineZoom, .timelineContentWidth (+2 more)

### Community 47 - "MIDIInputService"
Cohesion: 0.08
Nodes (23): CoreMIDI, MIDINotifyProc, MIDIPacket, MIDIPacketList, MIDIInputEvent, MIDIInputService, MIDISourceInfo, .id (+15 more)

### Community 48 - "Codable"
Cohesion: 0.19
Nodes (9): Codable, SavedProjectDocument, DAWProject, Int, ManifestFile, Data, ProjectFilePanel, String (+1 more)

### Community 49 - "ProjectPersistenceError"
Cohesion: 0.18
Nodes (10): JSONDecoder, .projectDecoder, JSONEncoder, .pretty, ProjectPersistenceError, .errorDescription, invalidPackage, missingManifest (+2 more)

### Community 50 - ".log"
Cohesion: 0.38
Nodes (6): SectionLoopDiagnostics, AVAudioFrameCount, Double, Int64, String, TimeInterval

### Community 51 - ".nextDistinctHex"
Cohesion: 0.27
Nodes (7): sections, SectionMarkerPalette, .palette, Int, Set, String, SectionMarkerPaletteTests

### Community 52 - "SimplePlayProjectArchive"
Cohesion: 0.16
Nodes (15): Asset, SimplePlayProjectArchive, SimplePlayProjectArchiveError, corruptAsset, corruptManifest, .errorDescription, invalidArchive, Bool (+7 more)

### Community 53 - "SectionLoopContext"
Cohesion: 0.29
Nodes (9): SectionLoopContext, .duration, TimeInterval, UUID, Bool, DAWProject, Int, Int64 (+1 more)

### Community 54 - "DAWVerticalFaderView"
Cohesion: 0.09
Nodes (25): ClosedRange, Double, Float, String, TrackVolumeSettings, .trackRange, DAWVerticalFaderView, .body (+17 more)

### Community 56 - "Foundation"
Cohesion: 0.10
Nodes (7): AVFoundation, CoreAudio, Foundation, Observation, os, SnapGrid, TimeFormatting

### Community 57 - ".stop"
Cohesion: 0.10
Nodes (16): App, Commands, Scene, ContentView, .body, FileCommands, .body, Content (+8 more)

### Community 58 - "TrackControlButton"
Cohesion: 0.22
Nodes (8): PanKnobView, .body, Bool, Double, String, Void, TrackControlButton, .body

### Community 59 - "TimeInterval"
Cohesion: 0.20
Nodes (6): AVAudioFramePosition, AVAudioTime, AVAudioFrameCount, Double, TimeInterval, UInt64

### Community 60 - ".snap"
Cohesion: 0.22
Nodes (4): Bool, TimeInterval, Int, .trackHeaderColumnTracksOnly

### Community 61 - "PropertiesSidebarView"
Cohesion: 0.14
Nodes (16): PropertiesSidebarView, .body, .pitchIsOriginal, .pitchLabel, .sectionCreationHint, .selectedDevice, .selectedDeviceID, .selectedSection (+8 more)

### Community 62 - ".sectionMappingCard"
Cohesion: 0.19
Nodes (10): MIDINoteAssignment, .displayName, Bool, String, UInt8, .expandedPanel, SectionMappingAssignButtonStyle, SectionMappingCardGlow (+2 more)

### Community 63 - "PitchShiftSettings"
Cohesion: 0.27
Nodes (5): PitchShiftSettings, AVAudioUnitTimePitch, Double, Float, PitchShiftSettingsTests

### Community 64 - "SectionPlaybackStatus"
Cohesion: 0.40
Nodes (5): SectionPlaybackStatus, idle, playing, queued, repeatingAtEnd

### Community 65 - "WorkspaceSettingsView"
Cohesion: 0.28
Nodes (7): Binding, Bool, String, WorkspaceSettingsView, .body, .deleteSectionDialogTitle, .sectionDeletionDialogBinding

### Community 66 - "TopToolbarView"
Cohesion: 0.12
Nodes (21): ImportPanelKind, audioFiles, folder, Bool, String, Void, ToolbarMenuButtonStyleModifier, TopToolbarView (+13 more)

### Community 67 - "WorkspaceViewModel"
Cohesion: 0.08
Nodes (21): SectionEdgeGuides, Date, Set, WorkspaceViewModel, .activePitchTrack, .activePlaybackSection, .activeSectionEdgeGuides, .canSaveDirectlyToCurrentURL (+13 more)

### Community 68 - "TimeInterval"
Cohesion: 0.21
Nodes (6): Bool, TimeInterval, TimelineScrollAlignment, center, leading, start

### Community 69 - "TrackPitchControlView"
Cohesion: 0.18
Nodes (13): .actionButtons, Binding, Bool, Double, String, UUID, TrackPitchControlView, .menuTitle (+5 more)

### Community 70 - "Color"
Cohesion: 0.38
Nodes (3): Color, StandardTrackRole, .fallbackColor

### Community 71 - "DAWGlassChrome"
Cohesion: 0.17
Nodes (10): Glass, DAWGlassChrome, .controlGlass, .panelGlass, CGFloat, Double, LinearGradient, View (+2 more)

### Community 72 - "FaderMeterStripView"
Cohesion: 0.12
Nodes (14): .mastersStripRow, .projectMasterStrip, String, .mainVolumeControl, FaderMeterStripView, .reservesThumbClearance, .showsUnityMark, .usesUnityCenterDecibelScale (+6 more)

### Community 73 - "UIKitToolbarMenuButtonRepresentable"
Cohesion: 0.33
Nodes (7): Coordinator, Context, String, Void, UIKitToolbarMenuButtonRepresentable, UIButton, UIViewRepresentable

### Community 75 - "WorkspaceView"
Cohesion: 0.33
Nodes (7): Binding, Bool, String, WorkspaceView, .deleteSectionDialogTitle, .phoneBottomChrome, .sectionDeletionDialogBinding

### Community 76 - ".setMasterVolume"
Cohesion: 0.40
Nodes (4): .masterVolumeBinding, .masterVolumeBinding, Binding, .masterVolumeBinding

### Community 77 - ".groupVolumeBinding"
Cohesion: 0.53
Nodes (3): Binding, Double, UUID

### Community 78 - ".sessionManagement"
Cohesion: 0.60
Nodes (3): .sessionManagement, .projectSessionMenuItems, .body

## Knowledge Gaps
- **280 isolated node(s):** `.isCompact`, `.barHeight`, `.thumbSize`, `.touchTarget`, `.isPhone` (+275 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **10 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `WorkspaceViewModel` connect `WorkspaceViewModel` to `SectionMarkerChipView`, `Sendable`, `TrackLaneView`, `.selectedMarkerEditor`, `ArrangementPlaybackEngine`, `MixerPanelView`, `TimelineWorkspacePanel`, `AudioImportService`, `AudioEngineService`, `.applyImportedStems`, `MIDIMappingBarView`, `SidebarPanel`, `SectionPlaybackMode`, `.frames`, `AudioTrack`, `SupportedAudioFormats`, `ArrangementSection`, `TransportBarView`, `AudioSampleRate`, `UUID`, `AppKit`, `View`, `ProjectPersistenceService`, `AudioDeviceService`, `CGFloat`, `MIDIInputService`, `Codable`, `.addSection`, `Foundation`, `.stop`, `.snap`, `PropertiesSidebarView`, `.sectionMappingCard`, `SectionPlaybackStatus`, `WorkspaceSettingsView`, `TopToolbarView`, `TimeInterval`, `TrackPitchControlView`, `Color`, `.setZoom`, `WorkspaceView`, `.setMasterVolume`, `.sessionManagement`?**
  _High betweenness centrality (0.441) - this node is a cross-community bridge._
- **Why does `ArrangementSection` connect `ArrangementSection` to `DAWProject`, `SectionMarkerChipView`, `Sendable`, `WorkspaceViewModel`, `AudioSampleRate`, `Color`, `.selectedMarkerEditor`, `ArrangementPlaybackEngine`, `Codable`, `.nextDistinctHex`, `MIDIMappingBarView`, `PropertiesSidebarView`, `.addSection`, `Foundation`, `SectionPlaybackMode`, `.frames`, `CodingKeys`, `.sectionMappingCard`?**
  _High betweenness centrality (0.151) - this node is a cross-community bridge._
- **Why does `AudioEngineService` connect `AudioEngineService` to `WorkspaceViewModel`, `UUID`, `ScheduledClip`, `.play`, `SectionLoopContext`, `.applyImportedStems`, `TimeInterval`?**
  _High betweenness centrality (0.102) - this node is a cross-community bridge._
- **Are the 12 inferred relationships involving `WorkspaceViewModel` (e.g. with `ArrangementPlaybackEngine` and `AudioEngineService`) actually correct?**
  _`WorkspaceViewModel` has 12 INFERRED edges - model-reasoned connections that need verification._
- **Are the 2 inferred relationships involving `AudioEngineService` (e.g. with `WorkspaceViewModel` and `.configureAudioEngine()`) actually correct?**
  _`AudioEngineService` has 2 INFERRED edges - model-reasoned connections that need verification._
- **Are the 4 inferred relationships involving `ArrangementSection` (e.g. with `.body` and `.body`) actually correct?**
  _`ArrangementSection` has 4 INFERRED edges - model-reasoned connections that need verification._
- **What connects `.isCompact`, `.barHeight`, `.thumbSize` to the rest of the system?**
  _280 weakly-connected nodes found - possible documentation gaps or missing edges._