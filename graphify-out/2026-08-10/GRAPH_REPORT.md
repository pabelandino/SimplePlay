# Graph Report - SimplePlay  (2026-08-10)

## Corpus Check
- 95 files · ~48,652 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 1619 nodes · 3820 edges · 76 communities (69 shown, 7 thin omitted)
- Extraction: 90% EXTRACTED · 10% INFERRED · 0% AMBIGUOUS · INFERRED: 363 edges (avg confidence: 0.8)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `a0b2df27`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- SimplePlayUITests
- SectionMarkerChipView
- Sendable
- What You Must Do When Invoked
- TrackLaneView
- graphify reference: extra exports and benchmark
- SidebarPanel
- graphify reference: query, path, explain
- graphify reference: add a URL and watch a folder
- graphify reference: commit hook and native AGENTS.md integration
- graphify reference: incremental update and cluster-only
- graphify reference: GitHub clone and cross-repo merge
- graphify reference: transcribe video and audio
- extraction-spec.md
- ArrangementSection
- MixerPanelView
- TimelineWorkspacePanel
- ScheduledClip
- AudioImportService
- AudioEngineService
- StandardTrackRole
- String
- .standardize
- MIDIMappingBarView
- SettingsFormStyle.swift
- SectionPlaybackMode
- .loadBucket
- .frames
- TimelineOverviewBar
- CodingKeys
- Testing
- AudioTrack
- DAWProject
- SupportedAudioFormats
- .applyImportedStems
- TransportBarView
- AudioSampleRate
- TrackWaveformProgressBar
- .addSection
- AppKit
- DAWSecondaryButtonStyle
- AudioDropOverlay
- AVFoundation
- ProjectPersistenceService
- .peaks
- AudioDeviceService
- CGFloat
- MIDIInputService
- Codable
- ProjectPersistenceError
- .log
- TrackGroup
- SimplePlayProjectArchive
- SectionLoopContext
- DAWVerticalFaderView
- .body
- SwiftUI
- .body
- TrackControlButton
- .play
- TimeInterval
- PropertiesSidebarView
- SectionMappingCardGlow
- PitchShiftSettings
- SectionPlaybackStatus
- .body
- View
- WorkspaceViewModel
- TimeInterval
- TrackPitchControlView
- TrackHeaderRowView
- DAWTheme
- FaderMeterStripView
- UIKitToolbarMenuButtonRepresentable
- .mixerChannelStrip
- .sessionManagement

## God Nodes (most connected - your core abstractions)
1. `WorkspaceViewModel` - 238 edges
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
- `.sectionEdgeGuides` --calls--> `SectionEdgeGuideOverlay`  [INFERRED]
  SimplePlay/Features/Workspace/Views/TimelineWorkspacePanel.swift → SimplePlay/Features/Workspace/Views/SectionMarkerLaneView.swift
- `.settingsHeader` --calls--> `DAWPrimaryButtonStyle`  [INFERRED]
  SimplePlay/Features/Workspace/Views/WorkspaceSettingsView.swift → SimplePlay/Features/Workspace/Views/TopToolbarView.swift
- `.body` --calls--> `WorkspaceView`  [INFERRED]
  SimplePlay/ContentView.swift → SimplePlay/Features/Workspace/Views/WorkspaceView.swift

## Import Cycles
- None detected.

## Communities (76 total, 7 thin omitted)

### Community 0 - "SimplePlayUITests"
Cohesion: 0.15
Nodes (6): SimplePlayUITests, SimplePlayUITestsLaunchTests, .runsForEachTargetApplicationUIConfiguration, Bool, XCTest, XCTestCase

### Community 1 - "SectionMarkerChipView"
Cohesion: 0.09
Nodes (35): NSCursor, Bool, String, TimeInterval, .formattedCurrentTime, .formattedDuration, ResizeEdge, end (+27 more)

### Community 2 - "Sendable"
Cohesion: 0.25
Nodes (18): Equatable, Sendable, PersistedClip, PersistedProject, PersistedTrack, Bool, Decoder, Double (+10 more)

### Community 3 - "What You Must Do When Invoked"
Cohesion: 0.08
Nodes (24): For /graphify add and --watch, For /graphify query, For the commit hook and native AGENTS.md integration, For --update and --cluster-only, /graphify, Honesty Rules, Interpreter guard for subcommands, Part A - Structural extraction for code files (+16 more)

### Community 4 - "TrackLaneView"
Cohesion: 0.09
Nodes (26): G, GraphicsContext, CGFloat, String, TimeInterval, TimelineRulerScale, ClipDragInteractionModifier, ClipSelectionModifiers (+18 more)

### Community 5 - "graphify reference: extra exports and benchmark"
Cohesion: 0.22
Nodes (8): graphify reference: extra exports and benchmark, Step 6b - Wiki (only if --wiki flag), Step 7 - Neo4j export (only if --neo4j or --neo4j-push flag), Step 7a - FalkorDB export (only if --falkordb or --falkordb-push flag), Step 7b - SVG export (only if --svg flag), Step 7c - GraphML export (only if --graphml flag), Step 7d - MCP server (only if --mcp flag), Step 8 - Token reduction benchmark (only if total_words > 5000)

### Community 6 - "SidebarPanel"
Cohesion: 0.16
Nodes (16): .sectionEditor, .selectedMarkerEditor, .selectionInfo, .trackPitch, DAWPrimaryButtonStyle, .pitchMenu, SettingsBadge, SettingsFootnote (+8 more)

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

### Community 15 - "MixerPanelView"
Cohesion: 0.11
Nodes (19): MixerPanelView, .body, .channelFaderHeight, .channelFaderWidth, .channelStripWidth, .groupDivider, .isCompact, .masterFaderHeight (+11 more)

### Community 16 - "TimelineWorkspacePanel"
Cohesion: 0.10
Nodes (30): PlayheadView, .body, .playheadDragGesture, Bool, CGFloat, Content, Double, Gesture (+22 more)

### Community 17 - "ScheduledClip"
Cohesion: 0.24
Nodes (3): AVAudioFile, ScheduledClip, AVAudioUnitTimePitch

### Community 18 - "AudioImportService"
Cohesion: 0.09
Nodes (26): LocalizedError, AudioEngineError, clipLoadFailed, deviceSelectionFailed, engineStartFailed, .errorDescription, noPlayableClips, playbackUnavailable (+18 more)

### Community 19 - "AudioEngineService"
Cohesion: 0.12
Nodes (12): AVAudioMixerNode, AVAudioUnitEQ, AudioEngineService, .isAnyPlayerPlaying, .isPlaybackGraphReady, .isSectionLoopPlaybackActive, .masterVolume, .primaryClipSampleRate (+4 more)

### Community 20 - "StandardTrackRole"
Cohesion: 0.08
Nodes (24): StandardTrackRole, acousticGuitar, backingVocal, bass, brass, click, countIn, cue (+16 more)

### Community 21 - "String"
Cohesion: 0.22
Nodes (4): Error, Result, String, URL

### Community 22 - ".standardize"
Cohesion: 0.23
Nodes (7): StandardizedName, Bool, StandardTrackRole, String, URL, TrackNameStandardizer, TrackNameStandardizerTests

### Community 23 - "MIDIMappingBarView"
Cohesion: 0.10
Nodes (22): Animation, AnyTransition, Color, StandardTrackRole, .fallbackColor, MIDIMappingBarView, .assignModeToggleTitle, .body (+14 more)

### Community 24 - "SettingsFormStyle.swift"
Cohesion: 0.12
Nodes (23): Selection, .playbackSettings, .volumeControls, SettingsControlSurface, .body, SettingsFieldLabel, .body, SettingsMenuRow (+15 more)

### Community 25 - "SectionPlaybackMode"
Cohesion: 0.15
Nodes (12): CaseIterable, SectionPlaybackMode, continueTimeline, continueToNext, .displayName, .id, oneShot, repeatSection (+4 more)

### Community 26 - ".loadBucket"
Cohesion: 0.31
Nodes (5): CoreGraphics, CGFloat, Int, WaveformLOD, .requiredLOD

### Community 27 - ".frames"
Cohesion: 0.32
Nodes (6): Bool, Double, Int64, TimeInterval, TimelineSampleGrid, TimelineSampleGridTests

### Community 28 - "TimelineOverviewBar"
Cohesion: 0.11
Nodes (21): Path, Bool, CGFloat, CGSize, ClosedRange, Gesture, TimeInterval, TimelineOverviewBar (+13 more)

### Community 29 - "CodingKeys"
Cohesion: 0.05
Nodes (44): CodingKey, CodingKeys, colorHex, endTime, id, midiChannel, midiNote, midiUsesControlChange (+36 more)

### Community 30 - "Testing"
Cohesion: 0.23
Nodes (4): SimplePlay, ProjectArchiveTests, SimplePlayTests, Testing

### Community 31 - "AudioTrack"
Cohesion: 0.07
Nodes (40): AudioClip, .endTime, Int, String, TimeInterval, URL, UUID, AudioTrack (+32 more)

### Community 32 - "DAWProject"
Cohesion: 0.31
Nodes (9): DAWProject, .duration, Bool, Double, Int32, String, TimeInterval, UInt8 (+1 more)

### Community 33 - "SupportedAudioFormats"
Cohesion: 0.05
Nodes (37): FileDocument, FileWrapper, ReadConfiguration, SimplePlayProjectFileDocument, .readableContentTypes, Data, DropURLLoader, NSItemProvider (+29 more)

### Community 35 - "TransportBarView"
Cohesion: 0.09
Nodes (25): .masterVolumeBinding, .masterVolumeBinding, Binding, Bool, CGFloat, Double, String, Void (+17 more)

### Community 36 - "AudioSampleRate"
Cohesion: 0.19
Nodes (14): Double, Hashable, Identifiable, AudioOutputDevice, AudioSampleRate, .displayName, .id, rate44100 (+6 more)

### Community 37 - "TrackWaveformProgressBar"
Cohesion: 0.40
Nodes (4): Bool, Double, TrackWaveformProgressBar, .body

### Community 39 - "AppKit"
Cohesion: 0.07
Nodes (24): App, AppKit, Notification, NSApplicationDelegate, NSEvent, NSObject, NSView, NSViewRepresentable (+16 more)

### Community 40 - "DAWSecondaryButtonStyle"
Cohesion: 0.15
Nodes (12): ButtonStyle, .collapsedBarContent, .learnBanner, SectionMappingAssignButtonStyle, SectionMappingPlayButtonStyle, Configuration, DAWIconToolbarButtonStyle, DAWLabeledToolbarButtonStyle (+4 more)

### Community 41 - "AudioDropOverlay"
Cohesion: 0.33
Nodes (5): AudioDropOverlay, .body, String, TimelineEmptyDropHint, .body

### Community 42 - "AVFoundation"
Cohesion: 0.20
Nodes (4): AVFoundation, CoreAudio, CoreMIDI, os

### Community 43 - "ProjectPersistenceService"
Cohesion: 0.26
Nodes (7): missingAudioFile, unsupportedVersion, ProjectPersistenceService, Bool, DAWProject, URL, UUID

### Community 44 - ".peaks"
Cohesion: 0.09
Nodes (30): AVAudioPCMBuffer, CheckedContinuation, Never, clips, Double, Float, Int, MainActor (+22 more)

### Community 45 - "AudioDeviceService"
Cohesion: 0.26
Nodes (6): AudioDeviceID, AudioDeviceService, Bool, Int, String, .audioSettings

### Community 46 - "CGFloat"
Cohesion: 0.12
Nodes (10): SectionDragKind, move, resizeEnd, resizeStart, CGFloat, TimelineScrollRequest, .minimumTimelineZoom, .timelineContentWidth (+2 more)

### Community 47 - "MIDIInputService"
Cohesion: 0.06
Nodes (30): MIDINotifyProc, MIDIPacket, MIDIPacketList, MIDILearnTarget, section, MIDINoteAssignment, .displayName, Bool (+22 more)

### Community 48 - "Codable"
Cohesion: 0.26
Nodes (7): Codable, SavedProjectDocument, DAWProject, Int, ManifestFile, Data, .body

### Community 49 - "ProjectPersistenceError"
Cohesion: 0.18
Nodes (10): JSONDecoder, .projectDecoder, JSONEncoder, .pretty, ProjectPersistenceError, .errorDescription, invalidPackage, missingManifest (+2 more)

### Community 50 - ".log"
Cohesion: 0.38
Nodes (6): SectionLoopDiagnostics, AVAudioFrameCount, Double, Int64, String, TimeInterval

### Community 51 - "TrackGroup"
Cohesion: 0.27
Nodes (8): Encoder, Date, Decoder, Double, String, TimeInterval, UUID, TrackGroup

### Community 52 - "SimplePlayProjectArchive"
Cohesion: 0.16
Nodes (15): Asset, SimplePlayProjectArchive, SimplePlayProjectArchiveError, corruptAsset, corruptManifest, .errorDescription, invalidArchive, Bool (+7 more)

### Community 53 - "SectionLoopContext"
Cohesion: 0.29
Nodes (9): SectionLoopContext, .duration, TimeInterval, UUID, Bool, DAWProject, Int, Int64 (+1 more)

### Community 54 - "DAWVerticalFaderView"
Cohesion: 0.09
Nodes (25): ClosedRange, Double, Float, String, TrackVolumeSettings, .trackRange, DAWVerticalFaderView, .body (+17 more)

### Community 56 - "SwiftUI"
Cohesion: 0.15
Nodes (5): Foundation, Observation, SnapGrid, TimeFormatting, SwiftUI

### Community 57 - ".body"
Cohesion: 0.14
Nodes (11): Commands, ContentView, .body, FileCommands, Content, View, TransportCommands, .body (+3 more)

### Community 58 - "TrackControlButton"
Cohesion: 0.22
Nodes (8): PanKnobView, .body, Bool, Double, String, Void, TrackControlButton, .body

### Community 59 - ".play"
Cohesion: 0.21
Nodes (7): AVAudioFramePosition, AVAudioNode, AVAudioPlayerNode, AVAudioTime, .playbackGraphIsHealthy, AVAudioFrameCount, Double

### Community 61 - "PropertiesSidebarView"
Cohesion: 0.14
Nodes (17): PropertiesSidebarView, .body, .pitchIsOriginal, .pitchLabel, .sectionCreationHint, .selectedDevice, .selectedDeviceID, .selectedSection (+9 more)

### Community 62 - "SectionMappingCardGlow"
Cohesion: 0.50
Nodes (3): SectionMappingCardGlow, Content, ViewModifier

### Community 63 - "PitchShiftSettings"
Cohesion: 0.31
Nodes (5): PitchShiftSettings, AVAudioUnitTimePitch, Double, Float, PitchShiftSettingsTests

### Community 64 - "SectionPlaybackStatus"
Cohesion: 0.33
Nodes (5): SectionPlaybackStatus, idle, playing, queued, repeatingAtEnd

### Community 65 - ".body"
Cohesion: 0.12
Nodes (16): Binding, Bool, String, WorkspaceSettingsView, .body, .deleteSectionDialogTitle, .sectionDeletionDialogBinding, .settingsHeader (+8 more)

### Community 66 - "View"
Cohesion: 0.14
Nodes (19): Bool, Configuration, String, Void, ToolbarMenuButtonStyleModifier, TopToolbarView, .importButton, .importMenuItems (+11 more)

### Community 67 - "WorkspaceViewModel"
Cohesion: 0.05
Nodes (28): Bool, TimeInterval, ImportPanelKind, audioFiles, folder, Date, DAWProject, Float (+20 more)

### Community 68 - "TimeInterval"
Cohesion: 0.15
Nodes (9): SectionEdgeGuides, Bool, TimeInterval, TimelineScrollAlignment, center, leading, start, .activeSectionEdgeGuides (+1 more)

### Community 69 - "TrackPitchControlView"
Cohesion: 0.16
Nodes (13): .actionButtons, Binding, Bool, Double, String, UUID, TrackPitchControlView, .menuTitle (+5 more)

### Community 70 - "TrackHeaderRowView"
Cohesion: 0.25
Nodes (8): Binding, Double, TrackHeaderRowView, .displayColor, .liveTrack, .trackPan, .trackVolumeBinding, TrackReorderHandle

### Community 71 - "DAWTheme"
Cohesion: 0.12
Nodes (17): Glass, .assignModeToggle, DAWGlassChrome, .controlGlass, .panelGlass, CGFloat, Double, LinearGradient (+9 more)

### Community 72 - "FaderMeterStripView"
Cohesion: 0.12
Nodes (14): .mastersStripRow, .projectMasterStrip, String, .mainVolumeControl, FaderMeterStripView, .reservesThumbClearance, .showsUnityMark, .usesUnityCenterDecibelScale (+6 more)

### Community 73 - "UIKitToolbarMenuButtonRepresentable"
Cohesion: 0.29
Nodes (8): Coordinator, .body, Context, String, Void, UIKitToolbarMenuButtonRepresentable, UIButton, UIViewRepresentable

### Community 77 - ".mixerChannelStrip"
Cohesion: 0.43
Nodes (4): .mixerScrollWithPinnedMasters, Binding, Double, UUID

### Community 78 - ".sessionManagement"
Cohesion: 0.60
Nodes (3): .sessionManagement, .projectSessionMenuItems, .body

## Knowledge Gaps
- **279 isolated node(s):** `id`, `name`, `startTime`, `endTime`, `colorHex` (+274 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **7 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `WorkspaceViewModel` connect `WorkspaceViewModel` to `SectionMarkerChipView`, `TrackLaneView`, `SidebarPanel`, `ArrangementSection`, `MixerPanelView`, `TimelineWorkspacePanel`, `AudioImportService`, `AudioEngineService`, `String`, `MIDIMappingBarView`, `SectionPlaybackMode`, `TimelineOverviewBar`, `AudioTrack`, `SupportedAudioFormats`, `.applyImportedStems`, `TransportBarView`, `AudioSampleRate`, `.addSection`, `AppKit`, `ProjectPersistenceService`, `AudioDeviceService`, `CGFloat`, `MIDIInputService`, `Codable`, `.body`, `SwiftUI`, `.body`, `PropertiesSidebarView`, `SectionPlaybackStatus`, `.body`, `View`, `TimeInterval`, `TrackPitchControlView`, `TrackHeaderRowView`, `.mixerChannelStrip`, `.sessionManagement`?**
  _High betweenness centrality (0.450) - this node is a cross-community bridge._
- **Why does `AudioEngineService` connect `AudioEngineService` to `.applyImportedStems`, `WorkspaceViewModel`, `AVFoundation`, `ScheduledClip`, `SectionLoopContext`, `.body`, `.play`, `TimeInterval`?**
  _High betweenness centrality (0.102) - this node is a cross-community bridge._
- **Why does `ArrangementSection` connect `ArrangementSection` to `DAWProject`, `SectionPlaybackStatus`, `Sendable`, `WorkspaceViewModel`, `AudioSampleRate`, `TimeInterval`, `.addSection`, `SectionMarkerChipView`, `MIDIInputService`, `Codable`, `PropertiesSidebarView`, `MIDIMappingBarView`, `SwiftUI`, `SectionPlaybackMode`, `CodingKeys`?**
  _High betweenness centrality (0.078) - this node is a cross-community bridge._
- **Are the 12 inferred relationships involving `WorkspaceViewModel` (e.g. with `ArrangementPlaybackEngine` and `AudioEngineService`) actually correct?**
  _`WorkspaceViewModel` has 12 INFERRED edges - model-reasoned connections that need verification._
- **Are the 2 inferred relationships involving `AudioEngineService` (e.g. with `WorkspaceViewModel` and `.configureAudioEngine()`) actually correct?**
  _`AudioEngineService` has 2 INFERRED edges - model-reasoned connections that need verification._
- **Are the 4 inferred relationships involving `ArrangementSection` (e.g. with `.body` and `.body`) actually correct?**
  _`ArrangementSection` has 4 INFERRED edges - model-reasoned connections that need verification._
- **What connects `id`, `name`, `startTime` to the rest of the system?**
  _279 weakly-connected nodes found - possible documentation gaps or missing edges._