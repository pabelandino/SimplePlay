# Graph Report - SimplePlay  (2026-08-14)

## Corpus Check
- 107 files · ~56,095 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 1882 nodes · 4547 edges · 85 communities (78 shown, 7 thin omitted)
- Extraction: 90% EXTRACTED · 10% INFERRED · 0% AMBIGUOUS · INFERRED: 463 edges (avg confidence: 0.8)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `e2710ef7`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- ArrangementSection
- MIDIInputService
- WorkspaceViewModel
- SupportedAudioFormats
- .peaks
- TrackLaneView
- TimelineWorkspacePanel
- CodingKeys
- AudioImportService
- AudioEngineService
- SectionMarkerChipView
- SidebarPanel
- MIDIMappingBarView
- DAWVerticalFaderView
- TrackOrganizationService
- AudioEngineServiceHost
- Foundation
- MacWindowTitleBarHidden.swift
- SectionLoopContext
- ProjectPersistenceService
- TopToolbarView
- CGFloat
- TrackPitchControlView
- What You Must Do When Invoked
- PitchShiftSettings
- StandardTrackRole
- Equatable
- DAWSecondaryButtonStyle
- TransportBarView
- DAWProject
- TimeInterval
- IOSPlaybackStrategy
- MacOSPlaybackStrategy
- MixerPanelView
- AudioDeviceService
- WorkspaceSettingsView
- .workspaceRoot
- View
- TimelineOverviewBar
- Float
- DAWGlassChrome
- .stop
- AudioSettings
- .mixerChannelStrip
- .applyLoadedProject
- .frames
- PropertiesSidebarView
- AVAudioPlayerNode
- .selectedMarkerEditor
- ContentView
- LyricPlaySyncClient
- Testing
- FaderMeterStripView
- .attachClip
- SwiftUI
- SimplePlayUITests
- .play
- UIKitToolbarMenuButtonRepresentable
- .setZoom
- .stem
- Sendable
- .sessionManagement
- .setMasterVolume
- TrackGroup
- WorkspaceView
- SectionPlaybackMode
- AudioTrack
- Audio Engine — Agent Guide
- AudioClip
- .log
- graphify reference: extra exports and benchmark
- .body
- graphify reference: query, path, explain
- LyricPlaySyncMessageKind
- UUID
- SectionPlaybackStatus
- TrackWaveformProgressBar
- graphify reference: add a URL and watch a folder
- graphify reference: commit hook and native AGENTS.md integration
- graphify reference: incremental update and cluster-only
- graphify reference: GitHub clone and cross-repo merge
- graphify reference: transcribe video and audio
- CoreGraphics
- extraction-spec.md
- LyricPlaySyncMessage

## God Nodes (most connected - your core abstractions)
1. `WorkspaceViewModel` - 265 edges
2. `AudioEngineService` - 106 edges
3. `DAWProject` - 96 edges
4. `ArrangementSection` - 70 edges
5. `DAWTheme` - 52 edges
6. `MIDIMappingBarView` - 48 edges
7. `AudioTrack` - 44 edges
8. `StandardTrackRole` - 43 edges
9. `ArrangementPlaybackEngine` - 36 edges
10. `MixerPanelView` - 35 edges

## Surprising Connections (you probably didn't know these)
- `.pendingSectionDeletionName` --references--> `DAWProject`  [INFERRED]
  SimplePlay/Features/Workspace/ViewModels/WorkspaceViewModel.swift → SimplePlay/Core/Models/DAWProject.swift
- `TrackOrganizationServiceTests` --calls--> `TrackOrganizationService`  [EXTRACTED]
  SimplePlayTests/TrackOrganizationServiceTests.swift → SimplePlay/Core/Services/TrackOrganizationService.swift
- `.body` --calls--> `WorkspaceView`  [INFERRED]
  SimplePlay/ContentView.swift → SimplePlay/Features/Workspace/Views/WorkspaceView.swift
- `.body` --references--> `ArrangementSection`  [INFERRED]
  SimplePlay/Features/Workspace/Views/SectionMarkerLaneView.swift → SimplePlay/Core/Models/ArrangementSection.swift
- `.duration` --references--> `AudioTrack`  [INFERRED]
  SimplePlay/Core/Models/DAWProject.swift → SimplePlay/Core/Models/AudioTrack.swift

## Import Cycles
- None detected.

## Communities (85 total, 7 thin omitted)

### Community 0 - "ArrangementSection"
Cohesion: 0.07
Nodes (37): ArrangementSection, .color, .duration, .hasLyricSlideLink, Bool, Decoder, Int, String (+29 more)

### Community 1 - "MIDIInputService"
Cohesion: 0.07
Nodes (25): CoreMIDI, Identifiable, MIDINotifyProc, MIDIPacket, MIDIPacketList, MIDIInputEvent, MIDIInputService, MIDISourceInfo (+17 more)

### Community 2 - "WorkspaceViewModel"
Cohesion: 0.08
Nodes (20): ClosedRange, Date, Int, Set, WorkspaceViewModel, .activePlaybackSection, .canSaveDirectlyToCurrentURL, .isArrangementSectionControllingPlayback (+12 more)

### Community 3 - "SupportedAudioFormats"
Cohesion: 0.07
Nodes (30): DropURLLoader, NSItemProvider, String, URL, SimplePlayProjectType, UTType, SupportedAudioFormats, .contentTypes (+22 more)

### Community 4 - ".peaks"
Cohesion: 0.08
Nodes (33): CheckedContinuation, clips, Double, Float, Int, MainActor, Never, Sendable (+25 more)

### Community 5 - "TrackLaneView"
Cohesion: 0.08
Nodes (27): G, GraphicsContext, CGFloat, String, TimeInterval, TimelineRulerScale, ClipDragInteractionModifier, ClipSelectionModifiers (+19 more)

### Community 6 - "TimelineWorkspacePanel"
Cohesion: 0.09
Nodes (36): ScrollPosition, Bool, CGFloat, Content, TimelineHorizontalMirror, .body, TimelineScrollCoordinator, PinnedTimelineHeaderStrip (+28 more)

### Community 7 - "CodingKeys"
Cohesion: 0.04
Nodes (48): CodingKey, CodingKeys, colorHex, endTime, id, lyricDocumentID, lyricSlideID, lyricSlideOrder (+40 more)

### Community 8 - "AudioImportService"
Cohesion: 0.06
Nodes (38): LocalizedError, Network, AudioEngineError, clipLoadFailed, deviceSelectionFailed, engineStartFailed, .errorDescription, noPlayableClips (+30 more)

### Community 9 - "AudioEngineService"
Cohesion: 0.07
Nodes (20): AVAudioEngine, AVAudioUnitEQ, AudioEngineService, .avEngine, .engineIsRunning, .isAnyPlayerPlaying, .isMeterMonitoringEnabled, .isPlaybackGraphReady (+12 more)

### Community 10 - "SectionMarkerChipView"
Cohesion: 0.09
Nodes (38): NSCursor, ResizeEdge, end, start, sectionChipSurface(), SectionCreationPreviewView, .body, SectionDragSession (+30 more)

### Community 11 - "SidebarPanel"
Cohesion: 0.09
Nodes (36): Selection, .playbackSettings, .sectionEditor, .selectionInfo, .trackPitch, .volumeControls, SettingsBadge, SettingsControlSurface (+28 more)

### Community 12 - "MIDIMappingBarView"
Cohesion: 0.09
Nodes (21): Animation, AnyTransition, Color, MIDIMappingBarView, .assignModeToggleTitle, .collapsedBar, .devicePickerLabel, .devicePickerTitle (+13 more)

### Community 13 - "DAWVerticalFaderView"
Cohesion: 0.08
Nodes (25): ClosedRange, Double, Float, String, TrackVolumeSettings, .trackRange, DAWVerticalFaderView, .body (+17 more)

### Community 14 - "TrackOrganizationService"
Cohesion: 0.20
Nodes (11): ImportedStem, ImportPlacement, appendNewGroup, insertIntoGroup, Int, String, TimeInterval, URL (+3 more)

### Community 15 - "AudioEngineServiceHost"
Cohesion: 0.12
Nodes (11): AnyObject, AVAudioSession, AudioEnginePlatformServices, AudioEnginePlatformServicesFactory, AudioEngineServiceHost, AudioEngineService, AudioEngineServiceIOS, Bool (+3 more)

### Community 16 - "Foundation"
Cohesion: 0.13
Nodes (8): AudioUnit, AVFoundation, CoreAudio, Foundation, Observation, os, SnapGrid, TimeFormatting

### Community 17 - "MacWindowTitleBarHidden.swift"
Cohesion: 0.11
Nodes (15): Notification, NSApplicationDelegate, NSEvent, NSObject, NSView, NSViewRepresentable, NSWindow, .body (+7 more)

### Community 18 - "SectionLoopContext"
Cohesion: 0.18
Nodes (10): SectionLoopContext, .duration, TimeInterval, UUID, AVAudioFrameCount, Int, Int64, String (+2 more)

### Community 19 - "ProjectPersistenceService"
Cohesion: 0.05
Nodes (41): FileDocument, FileWrapper, ReadConfiguration, SimplePlayProjectFileDocument, .readableContentTypes, Data, JSONDecoder, .projectDecoder (+33 more)

### Community 20 - "TopToolbarView"
Cohesion: 0.11
Nodes (22): ImportPanelKind, audioFiles, folder, Bool, String, Void, ToolbarMenuButtonStyleModifier, TopToolbarView (+14 more)

### Community 21 - "CGFloat"
Cohesion: 0.10
Nodes (11): SectionDragKind, move, resizeEnd, resizeStart, CGFloat, TimelineScrollRequest, .minimumTimelineZoom, .timelineContentWidth (+3 more)

### Community 22 - "TrackPitchControlView"
Cohesion: 0.18
Nodes (10): .actionButtons, Bool, Double, String, UUID, TrackPitchControlView, .menuTitle, .pitchIsOriginal (+2 more)

### Community 23 - "What You Must Do When Invoked"
Cohesion: 0.08
Nodes (24): For /graphify add and --watch, For /graphify query, For the commit hook and native AGENTS.md integration, For --update and --cluster-only, /graphify, Honesty Rules, Interpreter guard for subcommands, Part A - Structural extraction for code files (+16 more)

### Community 24 - "PitchShiftSettings"
Cohesion: 0.24
Nodes (6): PitchShiftSettings, AVAudioUnitTimePitch, Bool, Double, Float, PitchShiftSettingsTests

### Community 25 - "StandardTrackRole"
Cohesion: 0.06
Nodes (36): StandardTrackRole, acousticGuitar, backingVocal, bass, brass, click, countIn, cue (+28 more)

### Community 26 - "Equatable"
Cohesion: 0.23
Nodes (18): Codable, Equatable, PersistedClip, PersistedProject, PersistedTrack, SavedProjectDocument, Bool, Decoder (+10 more)

### Community 27 - "DAWSecondaryButtonStyle"
Cohesion: 0.11
Nodes (16): ButtonStyle, .assignModeToggle, .collapsedBarContent, .expandedPanel, .learnBanner, .lyricCatalogStatus, SectionLyricLinkSheet, .body (+8 more)

### Community 28 - "TransportBarView"
Cohesion: 0.10
Nodes (20): Bool, CGFloat, Double, String, Void, TransportBarStyle, phoneBottomDock, standard (+12 more)

### Community 29 - "DAWProject"
Cohesion: 0.21
Nodes (11): DAWProject, Bool, Double, Int32, String, TimeInterval, UInt8, UUID (+3 more)

### Community 30 - "TimeInterval"
Cohesion: 0.14
Nodes (9): SectionEdgeGuides, Bool, TimeInterval, Timer, TimelineScrollAlignment, center, leading, start (+1 more)

### Community 31 - "IOSPlaybackStrategy"
Cohesion: 0.19
Nodes (11): IOSPlaybackStrategy, .meterTapBufferSize, AudioEngineService, AVAudioFile, AVAudioFrameCount, AVAudioFramePosition, AVAudioPlayerNode, AVAudioTime (+3 more)

### Community 32 - "MacOSPlaybackStrategy"
Cohesion: 0.19
Nodes (11): MacOSPlaybackStrategy, .meterTapBufferSize, AudioEngineService, AVAudioFile, AVAudioFrameCount, AVAudioFramePosition, AVAudioPlayerNode, AVAudioTime (+3 more)

### Community 33 - "MixerPanelView"
Cohesion: 0.09
Nodes (21): MixerPanelView, .body, .channelFaderHeight, .channelFaderWidth, .channelStripWidth, .groupDivider, .isCompact, .masterFaderHeight (+13 more)

### Community 34 - "AudioDeviceService"
Cohesion: 0.25
Nodes (6): AudioDeviceService, AudioDeviceID, Bool, Int, String, UInt32

### Community 35 - "WorkspaceSettingsView"
Cohesion: 0.28
Nodes (7): Binding, Bool, String, WorkspaceSettingsView, .body, .deleteSectionDialogTitle, .sectionDeletionDialogBinding

### Community 36 - ".workspaceRoot"
Cohesion: 0.23
Nodes (5): Error, Result, String, URL, .workspaceRoot

### Community 37 - "View"
Cohesion: 0.14
Nodes (15): SectionMappingPlayButtonStyle, Configuration, Configuration, AudioDropOverlay, .body, String, TimelineEmptyDropHint, .body (+7 more)

### Community 38 - "TimelineOverviewBar"
Cohesion: 0.11
Nodes (21): Path, Bool, CGFloat, CGSize, ClosedRange, Gesture, TimeInterval, TimelineOverviewBar (+13 more)

### Community 39 - "Float"
Cohesion: 0.22
Nodes (6): AVAudioMixerNode, AVAudioPCMBuffer, MeterPeakBuffer, Float, UUID, Void

### Community 40 - "DAWGlassChrome"
Cohesion: 0.17
Nodes (10): Glass, DAWGlassChrome, .controlGlass, .panelGlass, CGFloat, Double, LinearGradient, View (+2 more)

### Community 42 - "AudioSettings"
Cohesion: 0.14
Nodes (15): Double, AudioOutputDevice, AudioSampleRate, .displayName, .id, rate44100, rate48000, AudioSettings (+7 more)

### Community 43 - ".mixerChannelStrip"
Cohesion: 0.17
Nodes (11): Binding, Double, UUID, PanKnobView, .body, Bool, Double, String (+3 more)

### Community 45 - ".frames"
Cohesion: 0.27
Nodes (6): Bool, Double, Int64, TimeInterval, TimelineSampleGrid, TimelineSampleGridTests

### Community 46 - "PropertiesSidebarView"
Cohesion: 0.14
Nodes (17): PropertiesSidebarView, .body, .masterVolumeBinding, .pitchIsOriginal, .pitchLabel, .sectionCreationHint, .selectedDeviceID, .selectedSection (+9 more)

### Community 47 - "AVAudioPlayerNode"
Cohesion: 0.36
Nodes (3): AVAudioFramePosition, AVAudioPlayerNode, AVAudioTime

### Community 48 - ".selectedMarkerEditor"
Cohesion: 0.22
Nodes (7): Bool, String, TimeInterval, .formattedCurrentTime, .formattedDuration, .selectedMarkerEditor, .body

### Community 49 - "ContentView"
Cohesion: 0.18
Nodes (10): App, Commands, Scene, ContentView, .body, FileCommands, TransportCommands, .body (+2 more)

### Community 50 - "LyricPlaySyncClient"
Cohesion: 0.23
Nodes (8): NWBrowser, NWEndpoint, LyricPlaySyncClient, Never, Set, TimeInterval, Void, Task

### Community 51 - "Testing"
Cohesion: 0.22
Nodes (4): SimplePlay, ProjectArchiveTests, SimplePlayTests, Testing

### Community 52 - "FaderMeterStripView"
Cohesion: 0.15
Nodes (12): .projectMasterStrip, .mainVolumeControl, FaderMeterStripView, .reservesThumbClearance, .showsUnityMark, .usesUnityCenterDecibelScale, Bool, CGFloat (+4 more)

### Community 53 - ".attachClip"
Cohesion: 0.38
Nodes (3): ScheduledClip, AVAudioFile, AVAudioUnitTimePitch

### Community 54 - "SwiftUI"
Cohesion: 0.22
Nodes (4): AppKit, ResizablePropertiesSidebar, .body, SwiftUI

### Community 55 - "SimplePlayUITests"
Cohesion: 0.15
Nodes (6): SimplePlayUITests, SimplePlayUITestsLaunchTests, .runsForEachTargetApplicationUIConfiguration, Bool, XCTest, XCTestCase

### Community 56 - ".play"
Cohesion: 0.21
Nodes (4): Bool, TimeInterval, UInt64, AVAudioTime

### Community 57 - "UIKitToolbarMenuButtonRepresentable"
Cohesion: 0.33
Nodes (7): Coordinator, Context, String, Void, UIKitToolbarMenuButtonRepresentable, UIButton, UIViewRepresentable

### Community 59 - ".stem"
Cohesion: 0.26
Nodes (4): Int, String, TimeInterval, TrackOrganizationServiceTests

### Community 60 - "Sendable"
Cohesion: 0.18
Nodes (12): Sendable, MIDILearnTarget, section, MIDINoteAssignment, .displayName, Bool, String, UInt8 (+4 more)

### Community 61 - ".sessionManagement"
Cohesion: 0.60
Nodes (3): .sessionManagement, .projectSessionMenuItems, .body

### Community 62 - ".setMasterVolume"
Cohesion: 0.50
Nodes (3): .masterVolumeBinding, Binding, .masterVolumeBinding

### Community 63 - "TrackGroup"
Cohesion: 0.27
Nodes (8): Date, Decoder, Double, Encoder, String, TimeInterval, UUID, TrackGroup

### Community 64 - "WorkspaceView"
Cohesion: 0.22
Nodes (10): ScenePhase, Binding, Bool, String, WorkspaceLifecycleModifier, WorkspaceView, .body, .deleteSectionDialogTitle (+2 more)

### Community 65 - "SectionPlaybackMode"
Cohesion: 0.15
Nodes (11): CaseIterable, SectionPlaybackMode, continueTimeline, continueToNext, .displayName, .id, oneShot, repeatSection (+3 more)

### Community 66 - "AudioTrack"
Cohesion: 0.22
Nodes (10): AudioTrack, .color, .displayName, Bool, Double, String, UUID, .duration (+2 more)

### Community 67 - "Audio Engine — Agent Guide"
Cohesion: 0.20
Nodes (9): Architecture (do not collapse), Audio Engine — Agent Guide, Before you edit, iOS session rules (critical), Log messages, macOS device rules, Red flags (stop and reconsider), Safe change map (+1 more)

### Community 68 - "AudioClip"
Cohesion: 0.21
Nodes (7): AudioClip, .endTime, Int, String, TimeInterval, URL, UUID

### Community 69 - ".log"
Cohesion: 0.24
Nodes (9): SectionLoopDiagnostics, SectionTriggerDiagnostics, AVAudioFrameCount, Bool, Double, Int64, String, TimeInterval (+1 more)

### Community 70 - "graphify reference: extra exports and benchmark"
Cohesion: 0.22
Nodes (8): graphify reference: extra exports and benchmark, Step 6b - Wiki (only if --wiki flag), Step 7 - Neo4j export (only if --neo4j or --neo4j-push flag), Step 7a - FalkorDB export (only if --falkordb or --falkordb-push flag), Step 7b - SVG export (only if --svg flag), Step 7c - GraphML export (only if --graphml flag), Step 7d - MCP server (only if --mcp flag), Step 8 - Token reduction benchmark (only if total_words > 5000)

### Community 73 - ".body"
Cohesion: 0.33
Nodes (4): Content, View, View, WorkspaceKeyboardShortcuts

### Community 75 - "graphify reference: query, path, explain"
Cohesion: 0.33
Nodes (5): For /graphify explain, For /graphify path, graphify reference: query, path, explain, Step 0 — Constrained query expansion (REQUIRED before traversal), Step 1 — Traversal

### Community 77 - "LyricPlaySyncMessageKind"
Cohesion: 0.22
Nodes (9): LyricPlaySyncMessageKind, catalogRequest, catalogResponse, error, linkSection, linkSectionAck, presence, presenceAck (+1 more)

### Community 78 - "UUID"
Cohesion: 0.07
Nodes (22): Bool, TimeInterval, Double, Float, UInt8, UUID, .mixerScrollWithPinnedMasters, .trackHeaderColumnTracksOnly (+14 more)

### Community 79 - "SectionPlaybackStatus"
Cohesion: 0.33
Nodes (5): SectionPlaybackStatus, idle, playing, queued, repeatingAtEnd

### Community 80 - "TrackWaveformProgressBar"
Cohesion: 0.40
Nodes (4): Bool, Double, TrackWaveformProgressBar, .body

### Community 81 - "graphify reference: add a URL and watch a folder"
Cohesion: 0.50
Nodes (3): For /graphify add, For --watch, graphify reference: add a URL and watch a folder

### Community 82 - "graphify reference: commit hook and native AGENTS.md integration"
Cohesion: 0.50
Nodes (3): For git commit hook, For native AGENTS.md integration, graphify reference: commit hook and native AGENTS.md integration

### Community 83 - "graphify reference: incremental update and cluster-only"
Cohesion: 0.50
Nodes (3): For --cluster-only, For --update (incremental re-extraction), graphify reference: incremental update and cluster-only

### Community 91 - "LyricPlaySyncMessage"
Cohesion: 0.15
Nodes (16): Hashable, serverError, LinkSectionCommand, LyricPlaySync, LyricPlaySyncCodec, LyricPlaySyncMessage, LyricSlideCatalog, LyricSlideCatalogItem (+8 more)

## Knowledge Gaps
- **331 isolated node(s):** `id`, `name`, `startTime`, `endTime`, `colorHex` (+326 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **7 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `WorkspaceViewModel` connect `WorkspaceViewModel` to `ArrangementSection`, `MIDIInputService`, `SupportedAudioFormats`, `TrackLaneView`, `TimelineWorkspacePanel`, `AudioImportService`, `SectionMarkerChipView`, `MIDIMappingBarView`, `DAWVerticalFaderView`, `TrackOrganizationService`, `Foundation`, `ProjectPersistenceService`, `TopToolbarView`, `CGFloat`, `TrackPitchControlView`, `DAWSecondaryButtonStyle`, `TransportBarView`, `DAWProject`, `TimeInterval`, `MixerPanelView`, `AudioDeviceService`, `WorkspaceSettingsView`, `.workspaceRoot`, `TimelineOverviewBar`, `AudioSettings`, `.mixerChannelStrip`, `.applyLoadedProject`, `.frames`, `PropertiesSidebarView`, `.selectedMarkerEditor`, `ContentView`, `LyricPlaySyncClient`, `SwiftUI`, `.setZoom`, `Sendable`, `.sessionManagement`, `.setMasterVolume`, `WorkspaceView`, `SectionPlaybackMode`, `AudioTrack`, `AudioClip`, `.body`, `UUID`, `SectionPlaybackStatus`, `LyricPlaySyncMessage`?**
  _High betweenness centrality (0.380) - this node is a cross-community bridge._
- **Why does `DAWProject` connect `DAWProject` to `ArrangementSection`, `MIDIInputService`, `WorkspaceViewModel`, `AudioEngineService`, `DAWVerticalFaderView`, `TrackOrganizationService`, `Foundation`, `SectionLoopContext`, `ProjectPersistenceService`, `CGFloat`, `StandardTrackRole`, `Equatable`, `DAWSecondaryButtonStyle`, `TimeInterval`, `.workspaceRoot`, `AudioSettings`, `.applyLoadedProject`, `.selectedMarkerEditor`, `.attachClip`, `.play`, `.stem`, `Sendable`, `TrackGroup`, `AudioTrack`, `AudioClip`, `UUID`, `LyricPlaySyncMessage`?**
  _High betweenness centrality (0.109) - this node is a cross-community bridge._
- **Why does `ArrangementSection` connect `ArrangementSection` to `MIDIInputService`, `SectionPlaybackMode`, `WorkspaceViewModel`, `CodingKeys`, `DAWSecondaryButtonStyle`, `SectionMarkerChipView`, `MIDIMappingBarView`, `.frames`, `PropertiesSidebarView`, `SectionPlaybackStatus`, `.selectedMarkerEditor`, `SwiftUI`, `Equatable`, `LyricPlaySyncMessage`, `Sendable`, `DAWProject`, `TimeInterval`?**
  _High betweenness centrality (0.096) - this node is a cross-community bridge._
- **Are the 11 inferred relationships involving `WorkspaceViewModel` (e.g. with `ArrangementPlaybackEngine` and `AudioImportService`) actually correct?**
  _`WorkspaceViewModel` has 11 INFERRED edges - model-reasoned connections that need verification._
- **Are the 45 inferred relationships involving `DAWProject` (e.g. with `.activeGroupIndex()` and `.activeGroupName()`) actually correct?**
  _`DAWProject` has 45 INFERRED edges - model-reasoned connections that need verification._
- **Are the 3 inferred relationships involving `ArrangementSection` (e.g. with `.body` and `.assignsDistinctColorsForDuplicateNames()`) actually correct?**
  _`ArrangementSection` has 3 INFERRED edges - model-reasoned connections that need verification._
- **What connects `id`, `name`, `startTime` to the rest of the system?**
  _331 weakly-connected nodes found - possible documentation gaps or missing edges._