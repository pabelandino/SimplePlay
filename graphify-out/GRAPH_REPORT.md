# Graph Report - SimplePlay  (2026-08-14)

## Corpus Check
- 108 files · ~54,745 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 1899 nodes · 4398 edges · 109 communities (87 shown, 22 thin omitted)
- Extraction: 91% EXTRACTED · 9% INFERRED · 0% AMBIGUOUS · INFERRED: 394 edges (avg confidence: 0.8)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `bc14ebc0`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- SimplePlayUITests
- SectionMarkerChipView
- MacOSPlaybackStrategy
- What You Must Do When Invoked
- TimelineRulerTicksView
- graphify reference: extra exports and benchmark
- SimplePlayProjectArchive
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
- TransportBarView
- AudioDeviceService
- AudioEngineService
- StandardTrackRole
- CGFloat
- .applyImportedStems
- MIDIMappingBarView
- AudioEngineError
- .applyLoadedProject
- TrackGroup
- .frames
- Sendable
- CodingKeys
- Testing
- TrackOrganizationService
- .sectionMappingCard
- SupportedAudioFormats
- TopToolbarView.swift
- Float
- UUID
- PitchShiftSettings
- TimeInterval
- AppKit
- LyricPlaySyncClient
- AudioImportService
- SwiftUI
- FaderMeterStripView
- .peaks
- PropertiesSidebarView
- TrackPitchControlView
- MIDIInputService
- AudioEngineServiceIOS
- AudioEngineServiceHost
- AudioTrack
- TrackLaneView
- LyricPlaySyncMessageKind
- WorkspaceView
- DAWVerticalFaderView
- TimeInterval
- Foundation
- DAWProject
- .snap
- .stop
- DAWProject
- .hex
- Audio Engine — Agent Guide
- .play
- Bool
- Color
- TopToolbarView
- WorkspaceViewModel
- WorkspaceSettingsView
- AudioEngineServiceIOS.swift
- UIKitToolbarMenuButtonRepresentable
- DAWTheme
- .log
- .log
- SettingsFieldLabel
- .selectedMarkerEditor
- AudioSettings
- SidebarPanel
- MacAppDelegate
- .applyMIDILearn
- Codable
- AudioClip
- View
- IOSPlaybackStrategy
- TrackControlButton
- .stop
- AudioSampleRate
- .mixerChannelStrip
- ConnectionState
- SimplePlayApp
- ContentView
- WorkspaceKeyboardShortcuts
- .groupMasterStrip
- AVAudioFile
- .loadBucket
- AVAudioFrameCount
- .sessionManagement
- AVAudioFramePosition
- .setMasterVolume
- AVAudioPlayerNode
- AVAudioUnitTimePitch
- Int64
- UInt64
- Void
- CGFloat
- ClosedRange
- Date
- Set
- UInt8

## God Nodes (most connected - your core abstractions)
1. `WorkspaceViewModel` - 262 edges
2. `AudioEngineService` - 106 edges
3. `ArrangementSection` - 60 edges
4. `DAWTheme` - 52 edges
5. `MIDIMappingBarView` - 48 edges
6. `AudioTrack` - 42 edges
7. `ArrangementPlaybackEngine` - 36 edges
8. `MixerPanelView` - 35 edges
9. `PropertiesSidebarView` - 32 edges
10. `CodingKeys` - 31 edges

## Surprising Connections (you probably didn't know these)
- `.duration` --references--> `AudioTrack`  [INFERRED]
  SimplePlay/Core/Models/DAWProject.swift → SimplePlay/Core/Models/AudioTrack.swift
- `.actionButtons` --calls--> `TrackPitchControlView`  [INFERRED]
  SimplePlay/Features/Workspace/Views/TopToolbarView.swift → SimplePlay/Features/Workspace/Views/TrackPitchControlView.swift
- `.body` --calls--> `SettingsSectionHeader`  [INFERRED]
  SimplePlay/UI/Components/SidebarPanel.swift → SimplePlay/UI/Components/SettingsFormStyle.swift
- `WorkspaceViewModel` --calls--> `ArrangementPlaybackEngine`  [INFERRED]
  SimplePlay/Features/Workspace/ViewModels/WorkspaceViewModel.swift → SimplePlay/Core/Services/ArrangementPlaybackEngine.swift
- `WorkspaceViewModel` --calls--> `AudioImportService`  [INFERRED]
  SimplePlay/Features/Workspace/ViewModels/WorkspaceViewModel.swift → SimplePlay/Core/Services/AudioImportService.swift

## Import Cycles
- None detected.

## Communities (109 total, 22 thin omitted)

### Community 0 - "SimplePlayUITests"
Cohesion: 0.15
Nodes (6): SimplePlayUITests, SimplePlayUITestsLaunchTests, .runsForEachTargetApplicationUIConfiguration, Bool, XCTest, XCTestCase

### Community 1 - "SectionMarkerChipView"
Cohesion: 0.08
Nodes (36): NSCursor, Bool, String, TimeInterval, TimeFormatting, .formattedCurrentTime, .formattedDuration, ResizeEdge (+28 more)

### Community 2 - "MacOSPlaybackStrategy"
Cohesion: 0.19
Nodes (11): MacOSPlaybackStrategy, .meterTapBufferSize, AudioEngineService, AVAudioFile, AVAudioFrameCount, AVAudioFramePosition, AVAudioPlayerNode, AVAudioTime (+3 more)

### Community 3 - "What You Must Do When Invoked"
Cohesion: 0.08
Nodes (24): For /graphify add and --watch, For /graphify query, For the commit hook and native AGENTS.md integration, For --update and --cluster-only, /graphify, Honesty Rules, Interpreter guard for subcommands, Part A - Structural extraction for code files (+16 more)

### Community 4 - "TimelineRulerTicksView"
Cohesion: 0.11
Nodes (20): G, GraphicsContext, CGFloat, String, TimeInterval, TimelineRulerScale, ClipDragInteractionModifier, ClipSelectionModifiers (+12 more)

### Community 5 - "graphify reference: extra exports and benchmark"
Cohesion: 0.22
Nodes (8): graphify reference: extra exports and benchmark, Step 6b - Wiki (only if --wiki flag), Step 7 - Neo4j export (only if --neo4j or --neo4j-push flag), Step 7a - FalkorDB export (only if --falkordb or --falkordb-push flag), Step 7b - SVG export (only if --svg flag), Step 7c - GraphML export (only if --graphml flag), Step 7d - MCP server (only if --mcp flag), Step 8 - Token reduction benchmark (only if total_words > 5000)

### Community 6 - "SimplePlayProjectArchive"
Cohesion: 0.16
Nodes (15): Asset, SimplePlayProjectArchive, SimplePlayProjectArchiveError, corruptAsset, corruptManifest, .errorDescription, invalidArchive, Bool (+7 more)

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
Nodes (44): ArrangementSection, .color, .duration, .hasLyricSlideLink, Bool, Decoder, Int, String (+36 more)

### Community 15 - "MixerPanelView"
Cohesion: 0.11
Nodes (19): MixerPanelView, .body, .channelFaderHeight, .channelFaderWidth, .channelStripWidth, .groupDivider, .isCompact, .masterFaderHeight (+11 more)

### Community 16 - "TimelineWorkspacePanel"
Cohesion: 0.08
Nodes (41): ScrollPosition, Bool, CGFloat, Content, TimelineHorizontalMirror, .body, TimelineScrollCoordinator, PinnedTimelineHeaderStrip (+33 more)

### Community 17 - "TransportBarView"
Cohesion: 0.05
Nodes (44): Path, Bool, CGFloat, CGSize, ClosedRange, Gesture, TimeInterval, TimelineOverviewBar (+36 more)

### Community 18 - "AudioDeviceService"
Cohesion: 0.25
Nodes (6): AudioDeviceService, AudioDeviceID, Bool, Int, String, UInt32

### Community 19 - "AudioEngineService"
Cohesion: 0.06
Nodes (22): AVAudioEngine, AVAudioFramePosition, AVAudioUnitEQ, PlatformPlaybackStrategy, AudioEngineService, .avEngine, .engineIsRunning, .isAnyPlayerPlaying (+14 more)

### Community 20 - "StandardTrackRole"
Cohesion: 0.08
Nodes (24): StandardTrackRole, acousticGuitar, backingVocal, bass, brass, click, countIn, cue (+16 more)

### Community 21 - "CGFloat"
Cohesion: 0.09
Nodes (14): CGFloat, SectionDragKind, move, resizeEnd, resizeStart, TimelineScrollAlignment, center, leading (+6 more)

### Community 22 - ".applyImportedStems"
Cohesion: 0.13
Nodes (10): Error, Result, ImportPanelKind, audioFiles, folder, String, URL, .body (+2 more)

### Community 23 - "MIDIMappingBarView"
Cohesion: 0.13
Nodes (15): Animation, AnyTransition, MIDIMappingBarView, .assignModeToggleTitle, .body, .collapsedBar, .devicePickerLabel, .devicePickerTitle (+7 more)

### Community 24 - "AudioEngineError"
Cohesion: 0.13
Nodes (14): LocalizedError, Network, AudioEngineError, clipLoadFailed, deviceSelectionFailed, engineStartFailed, .errorDescription, noPlayableClips (+6 more)

### Community 26 - "TrackGroup"
Cohesion: 0.27
Nodes (8): Date, Decoder, Double, Encoder, String, TimeInterval, UUID, TrackGroup

### Community 27 - ".frames"
Cohesion: 0.29
Nodes (6): Bool, Double, Int64, TimeInterval, TimelineSampleGrid, TimelineSampleGridTests

### Community 28 - "Sendable"
Cohesion: 0.05
Nodes (54): Equatable, SavedProjectDocument, Sendable, MIDILearnTarget, section, UUID, PersistedClip, PersistedProject (+46 more)

### Community 29 - "CodingKeys"
Cohesion: 0.04
Nodes (48): CodingKey, CodingKeys, colorHex, endTime, id, lyricDocumentID, lyricSlideID, lyricSlideOrder (+40 more)

### Community 30 - "Testing"
Cohesion: 0.17
Nodes (5): CoreGraphics, SimplePlay, ProjectArchiveTests, SimplePlayTests, Testing

### Community 31 - "TrackOrganizationService"
Cohesion: 0.19
Nodes (13): ImportedStem, ImportPlacement, appendNewGroup, insertIntoGroup, DAWProject, Int, String, TimeInterval (+5 more)

### Community 32 - ".sectionMappingCard"
Cohesion: 0.23
Nodes (7): MIDINoteAssignment, .displayName, Bool, String, UInt8, .expandedPanel, .lyricCatalogStatus

### Community 33 - "SupportedAudioFormats"
Cohesion: 0.06
Nodes (37): FileDocument, FileWrapper, ReadConfiguration, SimplePlayProjectFileDocument, .readableContentTypes, Data, DropURLLoader, NSItemProvider (+29 more)

### Community 34 - "TopToolbarView.swift"
Cohesion: 0.24
Nodes (8): ButtonStyle, DAWIconToolbarButtonStyle, DAWLabeledToolbarButtonStyle, DAWPrimaryButtonStyle, Content, .body, .settingsHeader, UIKit

### Community 35 - "Float"
Cohesion: 0.24
Nodes (5): AVAudioMixerNode, MeterPeakBuffer, Float, UUID, Void

### Community 36 - "UUID"
Cohesion: 0.08
Nodes (16): AudioTrack, Double, Float, Int, UUID, .trackHeaderColumnTracksOnly, Binding, Double (+8 more)

### Community 37 - "PitchShiftSettings"
Cohesion: 0.22
Nodes (6): PitchShiftSettings, AVAudioUnitTimePitch, Bool, Double, Float, PitchShiftSettingsTests

### Community 39 - "AppKit"
Cohesion: 0.16
Nodes (10): AppKit, NSEvent, NSView, NSViewRepresentable, .body, MacWindowDragRegion, MacWindowTitleBarHidden, Context (+2 more)

### Community 40 - "LyricPlaySyncClient"
Cohesion: 0.19
Nodes (9): NWBrowser, NWEndpoint, LyricPlaySyncClient, serverError, Never, Set, TimeInterval, Void (+1 more)

### Community 41 - "AudioImportService"
Cohesion: 0.08
Nodes (25): AudioFileStorageService, String, URL, UUID, AudioImportError, emptySelection, .errorDescription, storageUnavailable (+17 more)

### Community 42 - "SwiftUI"
Cohesion: 0.15
Nodes (7): ResizablePropertiesSidebar, .body, Bool, Double, TrackWaveformProgressBar, .body, SwiftUI

### Community 43 - "FaderMeterStripView"
Cohesion: 0.15
Nodes (12): .projectMasterStrip, .mainVolumeControl, FaderMeterStripView, .reservesThumbClearance, .showsUnityMark, .usesUnityCenterDecibelScale, Bool, CGFloat (+4 more)

### Community 44 - ".peaks"
Cohesion: 0.09
Nodes (30): AVAudioPCMBuffer, CheckedContinuation, clips, Double, Float, Int, MainActor, Never (+22 more)

### Community 45 - "PropertiesSidebarView"
Cohesion: 0.15
Nodes (16): PropertiesSidebarView, .body, .pitchIsOriginal, .pitchLabel, .sectionCreationHint, .selectedDeviceID, .selectedSection, .selectedSectionNameBinding (+8 more)

### Community 46 - "TrackPitchControlView"
Cohesion: 0.16
Nodes (13): Binding, Bool, Double, String, UUID, TrackPitchControlView, .menuTitle, .pitchIsOriginal (+5 more)

### Community 47 - "MIDIInputService"
Cohesion: 0.08
Nodes (23): Identifiable, MIDINotifyProc, MIDIPacket, MIDIPacketList, MIDISourceInfo, MIDIInputService, MIDISourceInfo, .id (+15 more)

### Community 48 - "AudioEngineServiceIOS"
Cohesion: 0.38
Nodes (3): AVAudioSession, AudioEngineServiceIOS, Bool

### Community 49 - "AudioEngineServiceHost"
Cohesion: 0.25
Nodes (6): AnyObject, AudioEnginePlatformServices, AudioEnginePlatformServicesFactory, AudioEngineServiceHost, AudioEngineServiceMacOS, AudioDeviceID

### Community 50 - "AudioTrack"
Cohesion: 0.24
Nodes (11): AudioTrack, .color, .displayName, Bool, Double, StandardTrackRole, String, UUID (+3 more)

### Community 51 - "TrackLaneView"
Cohesion: 0.27
Nodes (6): Gesture, UUID, TrackLaneView, .body, .clipHeight, .liveTrack

### Community 52 - "LyricPlaySyncMessageKind"
Cohesion: 0.22
Nodes (9): LyricPlaySyncMessageKind, catalogRequest, catalogResponse, error, linkSection, linkSectionAck, presence, presenceAck (+1 more)

### Community 53 - "WorkspaceView"
Cohesion: 0.22
Nodes (10): ScenePhase, Binding, Bool, String, WorkspaceLifecycleModifier, WorkspaceView, .body, .deleteSectionDialogTitle (+2 more)

### Community 54 - "DAWVerticalFaderView"
Cohesion: 0.09
Nodes (25): ClosedRange, Double, Float, String, TrackVolumeSettings, .trackRange, DAWVerticalFaderView, .body (+17 more)

### Community 55 - "TimeInterval"
Cohesion: 0.16
Nodes (5): ArrangementSection, Bool, SectionLoopContext, TimeInterval, Timer

### Community 56 - "Foundation"
Cohesion: 0.13
Nodes (9): AudioUnit, AVFoundation, CoreAudio, CoreMIDI, Foundation, Observation, os, PlatformPlaybackStrategyFactory (+1 more)

### Community 57 - "DAWProject"
Cohesion: 0.31
Nodes (9): DAWProject, .duration, Bool, Double, Int32, String, TimeInterval, UInt8 (+1 more)

### Community 58 - ".snap"
Cohesion: 0.20
Nodes (3): Bool, TimeInterval, AudioClip

### Community 60 - "DAWProject"
Cohesion: 0.38
Nodes (4): groups, DAWProject, Int, UUID

### Community 61 - ".hex"
Cohesion: 0.40
Nodes (5): .defaultColor, Int, StandardTrackRole, String, TrackColorPalette

### Community 62 - "Audio Engine — Agent Guide"
Cohesion: 0.20
Nodes (9): Architecture (do not collapse), Audio Engine — Agent Guide, Before you edit, iOS session rules (critical), Log messages, macOS device rules, Red flags (stop and reconsider), Safe change map (+1 more)

### Community 63 - ".play"
Cohesion: 0.17
Nodes (14): AVAudioFile, AVAudioFrameCount, AVAudioPlayerNode, AVAudioUnitTimePitch, Int64, ScheduledClip, AudioClip, AVAudioTime (+6 more)

### Community 64 - "Bool"
Cohesion: 0.15
Nodes (9): .collapsedBarContent, SectionMappingAssignButtonStyle, SectionMappingCardGlow, SectionMappingPlayButtonStyle, Bool, CGFloat, Configuration, Content (+1 more)

### Community 65 - "Color"
Cohesion: 0.22
Nodes (4): Color, StandardTrackRole, .fallbackColor, .sectionQuickPads

### Community 66 - "TopToolbarView"
Cohesion: 0.19
Nodes (14): Bool, String, Void, ToolbarMenuButtonStyleModifier, TopToolbarView, .actionButtons, .importMenuItems, .isCompact (+6 more)

### Community 67 - "WorkspaceViewModel"
Cohesion: 0.07
Nodes (24): ClosedRange, Date, SectionPlaybackMode, Set, SectionEdgeGuides, DAWProject, WorkspaceViewModel, .activePitchTrack (+16 more)

### Community 68 - "WorkspaceSettingsView"
Cohesion: 0.33
Nodes (6): Binding, Bool, String, WorkspaceSettingsView, .deleteSectionDialogTitle, .sectionDeletionDialogBinding

### Community 69 - "AudioEngineServiceIOS.swift"
Cohesion: 0.25
Nodes (3): AudioEngineService, AVAudioTime, TimeInterval

### Community 70 - "UIKitToolbarMenuButtonRepresentable"
Cohesion: 0.33
Nodes (7): Coordinator, Context, String, Void, UIKitToolbarMenuButtonRepresentable, UIButton, UIViewRepresentable

### Community 71 - "DAWTheme"
Cohesion: 0.11
Nodes (20): Glass, .assignModeToggle, .learnBanner, .markerHeaderRow, DAWGlassChrome, .controlGlass, .panelGlass, CGFloat (+12 more)

### Community 72 - ".log"
Cohesion: 0.22
Nodes (10): SectionLoopContext, .duration, TimeInterval, UUID, SectionLoopDiagnostics, AVAudioFrameCount, Double, Int64 (+2 more)

### Community 73 - ".log"
Cohesion: 0.42
Nodes (5): SectionTriggerDiagnostics, Bool, String, TimeInterval, UUID

### Community 74 - "SettingsFieldLabel"
Cohesion: 0.29
Nodes (8): .volumeControls, SettingsControlSurface, .body, SettingsFieldLabel, .body, .body, .body, Content

### Community 75 - ".selectedMarkerEditor"
Cohesion: 0.17
Nodes (20): Selection, .audioSettings, .sectionEditor, .selectedMarkerEditor, .selectionInfo, .trackPitch, DAWSecondaryButtonStyle, SettingsBadge (+12 more)

### Community 76 - "AudioSettings"
Cohesion: 0.25
Nodes (9): Hashable, AudioOutputDevice, AudioSettings, .usesCustomOutputDevice, Bool, Int, String, UInt32 (+1 more)

### Community 77 - "SidebarPanel"
Cohesion: 0.22
Nodes (10): .playbackSettings, SettingsNumberInput, .body, Double, SidebarLabeledRow, .body, SidebarPanel, .body (+2 more)

### Community 78 - "MacAppDelegate"
Cohesion: 0.27
Nodes (6): Notification, NSApplicationDelegate, NSObject, NSWindow, MacAppDelegate, MacWindowConfigurator

### Community 79 - ".applyMIDILearn"
Cohesion: 0.28
Nodes (4): MIDIInputEvent, MIDILearnTarget, .body, UInt8

### Community 80 - "Codable"
Cohesion: 0.17
Nodes (17): Codable, LyricSlideCatalog, LyricSlideCatalogItem, LinkSectionCommand, LyricPlaySync, LyricPlaySyncCodec, LyricPlaySyncMessage, LyricSlideCatalog (+9 more)

### Community 81 - "AudioClip"
Cohesion: 0.36
Nodes (7): AudioClip, .endTime, Int, String, TimeInterval, URL, UUID

### Community 82 - "View"
Cohesion: 0.27
Nodes (5): SectionLyricLinkSheet, .body, .unavailableState, Configuration, View

### Community 83 - "IOSPlaybackStrategy"
Cohesion: 0.19
Nodes (11): IOSPlaybackStrategy, .meterTapBufferSize, AudioEngineService, AVAudioFile, AVAudioFrameCount, AVAudioFramePosition, AVAudioPlayerNode, AVAudioTime (+3 more)

### Community 84 - "TrackControlButton"
Cohesion: 0.22
Nodes (8): PanKnobView, .body, Bool, Double, String, Void, TrackControlButton, .body

### Community 85 - ".stop"
Cohesion: 0.28
Nodes (4): Content, View, .body, .transportControls

### Community 86 - "AudioSampleRate"
Cohesion: 0.16
Nodes (11): CaseIterable, Double, AudioSampleRate, .displayName, .id, rate44100, rate48000, URL (+3 more)

### Community 87 - ".mixerChannelStrip"
Cohesion: 0.43
Nodes (4): .mixerScrollWithPinnedMasters, Binding, Double, UUID

### Community 88 - "ConnectionState"
Cohesion: 0.33
Nodes (6): ConnectionState, connected, failed, idle, searching, String

### Community 89 - "SimplePlayApp"
Cohesion: 0.50
Nodes (3): App, Scene, SimplePlayApp

### Community 90 - "ContentView"
Cohesion: 0.29
Nodes (6): Commands, ContentView, .body, FileCommands, TransportCommands, .body

### Community 94 - ".loadBucket"
Cohesion: 0.53
Nodes (4): CGFloat, Int, WaveformLOD, .requiredLOD

### Community 96 - ".sessionManagement"
Cohesion: 0.22
Nodes (8): .sessionManagement, .importButton, .projectSessionButton, .projectSessionMenuItems, ImportToolbarMenuButton, .body, ProjectSessionToolbarMenuButton, .body

## Knowledge Gaps
- **326 isolated node(s):** `rate44100`, `rate48000`, `.id`, `.displayName`, `.usesCustomOutputDevice` (+321 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **22 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `WorkspaceViewModel` connect `WorkspaceViewModel` to `SectionMarkerChipView`, `ArrangementSection`, `MixerPanelView`, `TimelineWorkspacePanel`, `TransportBarView`, `AudioDeviceService`, `CGFloat`, `.applyImportedStems`, `MIDIMappingBarView`, `.applyLoadedProject`, `Sendable`, `.sectionMappingCard`, `SupportedAudioFormats`, `UUID`, `LyricPlaySyncClient`, `AudioImportService`, `SwiftUI`, `PropertiesSidebarView`, `TrackPitchControlView`, `MIDIInputService`, `TrackLaneView`, `WorkspaceView`, `TimeInterval`, `Foundation`, `.snap`, `Bool`, `Color`, `TopToolbarView`, `WorkspaceSettingsView`, `AudioSettings`, `.applyMIDILearn`, `Codable`, `View`, `.stop`, `.mixerChannelStrip`, `SimplePlayApp`, `ContentView`, `WorkspaceKeyboardShortcuts`, `.sessionManagement`, `.setMasterVolume`?**
  _High betweenness centrality (0.361) - this node is a cross-community bridge._
- **Why does `Foundation` connect `Foundation` to `SectionMarkerChipView`, `SimplePlayProjectArchive`, `ArrangementSection`, `AudioEngineError`, `TrackGroup`, `.frames`, `Sendable`, `Testing`, `SupportedAudioFormats`, `AppKit`, `AudioImportService`, `SwiftUI`, `AudioEngineServiceHost`, `DAWVerticalFaderView`, `DAWProject`, `AudioEngineServiceIOS.swift`, `.log`, `AudioSettings`, `Codable`, `AudioClip`, `AudioSampleRate`?**
  _High betweenness centrality (0.129) - this node is a cross-community bridge._
- **Why does `ArrangementSection` connect `ArrangementSection` to `.sectionMappingCard`, `Color`, `SectionMarkerChipView`, `SwiftUI`, `.selectedMarkerEditor`, `PropertiesSidebarView`, `MIDIInputService`, `Codable`, `.applyMIDILearn`, `View`, `MIDIMappingBarView`, `DAWProject`, `Sendable`, `CodingKeys`?**
  _High betweenness centrality (0.107) - this node is a cross-community bridge._
- **Are the 11 inferred relationships involving `WorkspaceViewModel` (e.g. with `ArrangementPlaybackEngine` and `AudioImportService`) actually correct?**
  _`WorkspaceViewModel` has 11 INFERRED edges - model-reasoned connections that need verification._
- **Are the 4 inferred relationships involving `ArrangementSection` (e.g. with `.body` and `.body`) actually correct?**
  _`ArrangementSection` has 4 INFERRED edges - model-reasoned connections that need verification._
- **What connects `rate44100`, `rate48000`, `.id` to the rest of the system?**
  _326 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `SectionMarkerChipView` be split into smaller, more focused modules?**
  _Cohesion score 0.07928118393234672 - nodes in this community are weakly interconnected._