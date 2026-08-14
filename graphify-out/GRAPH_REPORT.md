# Graph Report - SimplePlay  (2026-08-14)

## Corpus Check
- 115 files · ~61,463 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 2067 nodes · 5102 edges · 95 communities (88 shown, 7 thin omitted)
- Extraction: 90% EXTRACTED · 10% INFERRED · 0% AMBIGUOUS · INFERRED: 523 edges (avg confidence: 0.8)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `328b3ffd`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- ArrangementSection
- MIDIInputService
- DAWProject
- SupportedAudioFormats
- WaveformClipView
- .majorTickInterval
- TimelineWorkspacePanel
- CodingKeys
- AudioImportService
- AudioEngineService
- SectionMarkerChipView
- .selectedMarkerEditor
- MIDIMappingBarView
- DAWVerticalFaderView
- TrackOrganizationService
- AudioOutputDevice
- Foundation
- MacWindowTitleBarHidden.swift
- AudioEngineServiceIOS.swift
- ProjectPersistenceService
- TopToolbarView
- .body
- WorkspaceViewModel
- What You Must Do When Invoked
- PitchShiftSettings
- StandardTrackRole
- Equatable
- .frames
- UUID
- FaderMeterStripView
- TimeInterval
- MacOSPlaybackStrategy
- IOSPlaybackStrategy
- MixerPanelView
- WaveformCache
- UIKitToolbarMenuButtonRepresentable
- .importAudioFiles
- Bool
- TransportBarView
- Float
- DAWTheme
- .stop
- .standardize
- TrackHeaderRowView
- .applyRestoredProject
- .log
- PropertiesSidebarView
- .play
- ClipEditService
- AudioEngineServiceHost
- LyricPlaySyncClient
- SimplePlay
- AudioEngineError
- TrackPitchControlView
- SwiftUI
- ProjectEditHistory
- AudioSettings
- .recordEditSnapshot
- TransportRightToolbar
- AudioEngineService
- TrackMeterIndicatorView
- TimelineView.swift
- .attachClip
- TrackGroup
- .body
- Sendable
- AudioTrack
- Audio Engine — Agent Guide
- .hex
- WorkspaceView
- graphify reference: extra exports and benchmark
- Color
- WorkspaceSettingsView
- .clipContent
- AudioSampleRate
- graphify reference: query, path, explain
- AudioClip
- .addEmptyTrack
- LyricPlaySyncMessageKind
- TrackControlButton
- .sectionMappingCard
- graphify reference: add a URL and watch a folder
- graphify reference: commit hook and native AGENTS.md integration
- graphify reference: incremental update and cluster-only
- .stem
- graphify reference: GitHub clone and cross-repo merge
- graphify reference: transcribe video and audio
- .groupMasterStrip
- extraction-spec.md
- .refreshLyricCatalog
- .commitSectionDragPreview
- LyricPlaySyncMessage
- .format
- View
- SectionPlaybackStatus

## God Nodes (most connected - your core abstractions)
1. `WorkspaceViewModel` - 315 edges
2. `DAWProject` - 114 edges
3. `AudioEngineService` - 107 edges
4. `ArrangementSection` - 71 edges
5. `DAWTheme` - 57 edges
6. `MIDIMappingBarView` - 51 edges
7. `AudioTrack` - 47 edges
8. `StandardTrackRole` - 43 edges
9. `ArrangementPlaybackEngine` - 36 edges
10. `AudioClip` - 35 edges

## Surprising Connections (you probably didn't know these)
- `TrackOrganizationServiceTests` --calls--> `TrackOrganizationService`  [EXTRACTED]
  SimplePlayTests/TrackOrganizationServiceTests.swift → SimplePlay/Core/Services/TrackOrganizationService.swift
- `.body` --calls--> `ContentView`  [INFERRED]
  SimplePlay/SimplePlayApp.swift → SimplePlay/ContentView.swift
- `.body` --references--> `ArrangementSection`  [INFERRED]
  SimplePlay/Features/Workspace/Views/SectionMarkerLaneView.swift → SimplePlay/Core/Models/ArrangementSection.swift
- `.duration` --references--> `AudioTrack`  [INFERRED]
  SimplePlay/Core/Models/DAWProject.swift → SimplePlay/Core/Models/AudioTrack.swift
- `.hasSoloTracks` --references--> `AudioTrack`  [INFERRED]
  SimplePlay/Core/Utils/TrackColorPalette.swift → SimplePlay/Core/Models/AudioTrack.swift

## Import Cycles
- None detected.

## Communities (95 total, 7 thin omitted)

### Community 0 - "ArrangementSection"
Cohesion: 0.05
Nodes (52): ArrangementSection, .color, .duration, .hasLyricSlideLink, CodingKeys, colorHex, endTime, id (+44 more)

### Community 1 - "MIDIInputService"
Cohesion: 0.08
Nodes (23): CoreMIDI, MIDINotifyProc, MIDIPacket, MIDIPacketList, MIDIInputEvent, MIDIInputService, MIDISourceInfo, .id (+15 more)

### Community 2 - "DAWProject"
Cohesion: 0.11
Nodes (17): DAWProject, Bool, Double, Int32, String, TimeInterval, UInt8, UUID (+9 more)

### Community 3 - "SupportedAudioFormats"
Cohesion: 0.06
Nodes (37): FileDocument, FileWrapper, ReadConfiguration, SimplePlayProjectFileDocument, .readableContentTypes, Data, DropURLLoader, NSItemProvider (+29 more)

### Community 4 - "WaveformClipView"
Cohesion: 0.09
Nodes (28): Float, Int, TimeInterval, URL, WaveformClipPeakStore, CGFloat, Float, Int (+20 more)

### Community 5 - ".majorTickInterval"
Cohesion: 0.27
Nodes (6): CGFloat, String, TimeInterval, TimelineRulerScale, .body, TimelineRulerScaleTests

### Community 6 - "TimelineWorkspacePanel"
Cohesion: 0.09
Nodes (36): ScrollPosition, Bool, CGFloat, Content, TimelineHorizontalMirror, .body, TimelineScrollCoordinator, PinnedTimelineHeaderStrip (+28 more)

### Community 7 - "CodingKeys"
Cohesion: 0.08
Nodes (25): CodingKeys, audioSettings, colorHex, id, isLocked, isMuted, isPitchEnabled, isSnapEnabled (+17 more)

### Community 8 - "AudioImportService"
Cohesion: 0.12
Nodes (18): AudioFileStorageService, String, URL, UUID, AudioImportError, emptySelection, .errorDescription, storageUnavailable (+10 more)

### Community 9 - "AudioEngineService"
Cohesion: 0.06
Nodes (21): AVAudioEngine, AVAudioUnitEQ, AudioEngineService, .avEngine, .engineIsRunning, .isAnyPlayerPlaying, .isMeterMonitoringEnabled, .isPlaybackGraphReady (+13 more)

### Community 10 - "SectionMarkerChipView"
Cohesion: 0.09
Nodes (38): ResizeEdge, end, start, sectionChipSurface(), SectionCreationPreviewView, .body, SectionDragSession, SectionEdgeGuideOverlay (+30 more)

### Community 11 - ".selectedMarkerEditor"
Cohesion: 0.09
Nodes (38): Selection, .audioSettings, .playbackSettings, .sectionEditor, .selectedMarkerEditor, .selectionInfo, .trackPitch, .volumeControls (+30 more)

### Community 12 - "MIDIMappingBarView"
Cohesion: 0.12
Nodes (16): Animation, AnyTransition, MIDIMappingBarView, .assignModeToggleTitle, .body, .collapsedBar, .devicePickerLabel, .devicePickerTitle (+8 more)

### Community 13 - "DAWVerticalFaderView"
Cohesion: 0.13
Nodes (16): ClosedRange, Double, Float, String, TrackVolumeSettings, .trackRange, DAWVerticalFaderView, .body (+8 more)

### Community 14 - "TrackOrganizationService"
Cohesion: 0.20
Nodes (11): ImportedStem, ImportPlacement, appendNewGroup, insertIntoGroup, Int, String, TimeInterval, URL (+3 more)

### Community 15 - "AudioOutputDevice"
Cohesion: 0.16
Nodes (12): Hashable, AudioOutputDevice, Int, String, UInt32, AudioDeviceService, AudioDeviceID, Bool (+4 more)

### Community 16 - "Foundation"
Cohesion: 0.10
Nodes (10): AudioUnit, AVFoundation, CoreAudio, CoreGraphics, Foundation, Observation, os, PlatformPlaybackStrategyFactory (+2 more)

### Community 17 - "MacWindowTitleBarHidden.swift"
Cohesion: 0.11
Nodes (15): Notification, NSApplicationDelegate, NSEvent, NSObject, NSView, NSViewRepresentable, NSWindow, .body (+7 more)

### Community 18 - "AudioEngineServiceIOS.swift"
Cohesion: 0.25
Nodes (3): AudioEngineService, AVAudioTime, TimeInterval

### Community 19 - "ProjectPersistenceService"
Cohesion: 0.05
Nodes (42): SavedProjectDocument, JSONDecoder, .projectDecoder, JSONEncoder, .pretty, ManifestFile, ProjectPersistenceError, .errorDescription (+34 more)

### Community 20 - "TopToolbarView"
Cohesion: 0.15
Nodes (18): Bool, String, Void, ToolbarMenuButtonStyleModifier, TopToolbarView, .addTrackMenu, .importButton, .isCompact (+10 more)

### Community 21 - ".body"
Cohesion: 0.20
Nodes (9): G, ClipDragInteractionModifier, ClipSelectionModifiers, .isExtending, Bool, Content, UUID, TrackLaneDropModifier (+1 more)

### Community 22 - "WorkspaceViewModel"
Cohesion: 0.06
Nodes (28): CGFloat, ClosedRange, Date, Set, TimelineScrollRequest, WorkspaceViewModel, .activePlaybackSection, .canRedo (+20 more)

### Community 23 - "What You Must Do When Invoked"
Cohesion: 0.08
Nodes (24): For /graphify add and --watch, For /graphify query, For the commit hook and native AGENTS.md integration, For --update and --cluster-only, /graphify, Honesty Rules, Interpreter guard for subcommands, Part A - Structural extraction for code files (+16 more)

### Community 24 - "PitchShiftSettings"
Cohesion: 0.24
Nodes (6): PitchShiftSettings, AVAudioUnitTimePitch, Bool, Double, Float, PitchShiftSettingsTests

### Community 25 - "StandardTrackRole"
Cohesion: 0.08
Nodes (25): StandardTrackRole, acousticGuitar, backingVocal, bass, brass, click, countIn, cue (+17 more)

### Community 26 - "Equatable"
Cohesion: 0.24
Nodes (16): Codable, Equatable, PersistedClip, PersistedProject, PersistedTrack, Bool, Decoder, Double (+8 more)

### Community 27 - ".frames"
Cohesion: 0.27
Nodes (6): Bool, Double, Int64, TimeInterval, TimelineSampleGrid, TimelineSampleGridTests

### Community 28 - "UUID"
Cohesion: 0.08
Nodes (11): ClipMovePreview, Item, .id, Float, UUID, .canSplitSelectedClipAtPlayhead, .splitGesture, .trimGesture (+3 more)

### Community 29 - "FaderMeterStripView"
Cohesion: 0.17
Nodes (11): .projectMasterStrip, FaderMeterStripView, .reservesThumbClearance, .showsUnityMark, .usesUnityCenterDecibelScale, Bool, CGFloat, ClosedRange (+3 more)

### Community 30 - "TimeInterval"
Cohesion: 0.16
Nodes (8): Bool, TimeInterval, Timer, TimelineScrollAlignment, center, leading, start, .transportControls

### Community 31 - "MacOSPlaybackStrategy"
Cohesion: 0.19
Nodes (11): MacOSPlaybackStrategy, .meterTapBufferSize, AudioEngineService, AVAudioFile, AVAudioFrameCount, AVAudioFramePosition, AVAudioPlayerNode, AVAudioTime (+3 more)

### Community 32 - "IOSPlaybackStrategy"
Cohesion: 0.18
Nodes (11): IOSPlaybackStrategy, .meterTapBufferSize, AudioEngineService, AVAudioFile, AVAudioFrameCount, AVAudioFramePosition, AVAudioPlayerNode, AVAudioTime (+3 more)

### Community 33 - "MixerPanelView"
Cohesion: 0.11
Nodes (19): MixerPanelView, .body, .channelFaderHeight, .channelFaderWidth, .channelStripWidth, .groupDivider, .isCompact, .masterFaderHeight (+11 more)

### Community 34 - "WaveformCache"
Cohesion: 0.22
Nodes (15): AVAudioPCMBuffer, CheckedContinuation, Bool, Double, Float, Int, MainActor, Never (+7 more)

### Community 35 - "UIKitToolbarMenuButtonRepresentable"
Cohesion: 0.33
Nodes (7): Coordinator, Context, String, Void, UIKitToolbarMenuButtonRepresentable, UIButton, UIViewRepresentable

### Community 36 - ".importAudioFiles"
Cohesion: 0.22
Nodes (5): Error, Result, String, URL, .workspaceRoot

### Community 37 - "Bool"
Cohesion: 0.20
Nodes (6): .collapsedBarContent, SectionMappingCardGlow, Bool, CGFloat, Content, Void

### Community 38 - "TransportBarView"
Cohesion: 0.06
Nodes (36): Path, Bool, CGFloat, CGSize, ClosedRange, Gesture, TimeInterval, TimelineOverviewBar (+28 more)

### Community 39 - "Float"
Cohesion: 0.24
Nodes (5): AVAudioMixerNode, MeterPeakBuffer, Float, UUID, Void

### Community 40 - "DAWTheme"
Cohesion: 0.12
Nodes (17): Glass, DAWGlassChrome, .controlGlass, .panelGlass, CGFloat, Double, LinearGradient, View (+9 more)

### Community 42 - ".standardize"
Cohesion: 0.22
Nodes (7): StandardizedName, Bool, Int, String, URL, TrackNameStandardizer, TrackNameStandardizerTests

### Community 43 - "TrackHeaderRowView"
Cohesion: 0.10
Nodes (26): clips, Bool, Double, UUID, WaveformLoadMonitor, Density, compact, full (+18 more)

### Community 45 - ".log"
Cohesion: 0.25
Nodes (9): SectionLoopDiagnostics, SectionTriggerDiagnostics, AVAudioFrameCount, Bool, Double, Int64, String, TimeInterval (+1 more)

### Community 46 - "PropertiesSidebarView"
Cohesion: 0.11
Nodes (21): .masterVolumeBinding, PropertiesSidebarView, .body, .masterVolumeBinding, .pitchIsOriginal, .pitchLabel, .sectionCreationHint, .selectedDeviceID (+13 more)

### Community 47 - ".play"
Cohesion: 0.19
Nodes (11): SectionLoopContext, .duration, TimeInterval, UUID, AVAudioFrameCount, Bool, Int, Int64 (+3 more)

### Community 48 - "ClipEditService"
Cohesion: 0.21
Nodes (7): ClipEditService, TimeInterval, TrimEdge, end, start, ClipEditServiceTests, TimeInterval

### Community 49 - "AudioEngineServiceHost"
Cohesion: 0.25
Nodes (6): AnyObject, AudioEnginePlatformServices, AudioEnginePlatformServicesFactory, AudioEngineServiceHost, AudioEngineServiceMacOS, AudioDeviceID

### Community 50 - "LyricPlaySyncClient"
Cohesion: 0.23
Nodes (8): NWBrowser, NWEndpoint, LyricPlaySyncClient, Never, Set, TimeInterval, Void, Task

### Community 51 - "SimplePlay"
Cohesion: 0.21
Nodes (4): SimplePlay, ProjectArchiveTests, SimplePlayTests, Testing

### Community 52 - "AudioEngineError"
Cohesion: 0.10
Nodes (20): LocalizedError, Network, AudioEngineError, clipLoadFailed, deviceSelectionFailed, engineStartFailed, .errorDescription, noPlayableClips (+12 more)

### Community 53 - "TrackPitchControlView"
Cohesion: 0.16
Nodes (14): .actionButtons, Binding, Bool, Double, String, UUID, TrackPitchControlView, .menuTitle (+6 more)

### Community 54 - "SwiftUI"
Cohesion: 0.10
Nodes (11): AudioDropOverlay, .body, String, TimelineEmptyDropHint, .body, Bool, Double, TrackWaveformProgressBar (+3 more)

### Community 55 - "ProjectEditHistory"
Cohesion: 0.10
Nodes (12): ProjectEditHistory, .canRedo, .canUndo, Bool, Int, ProjectEditHistoryTests, SimplePlayUITests, SimplePlayUITestsLaunchTests (+4 more)

### Community 56 - "AudioSettings"
Cohesion: 0.27
Nodes (6): AVAudioSession, AudioSettings, .usesCustomOutputDevice, Bool, AudioEngineServiceIOS, Bool

### Community 57 - ".recordEditSnapshot"
Cohesion: 0.10
Nodes (6): Bool, TimeInterval, Double, .mixerScrollWithPinnedMasters, Binding, .zoomSection

### Community 58 - "TransportRightToolbar"
Cohesion: 0.07
Nodes (33): Bool, CGFloat, Double, String, Void, TimelineScaleControls, .body, .buttonCornerRadius (+25 more)

### Community 59 - "AudioEngineService"
Cohesion: 0.40
Nodes (3): AudioEngineService, AVAudioTime, TimeInterval

### Community 60 - "TrackMeterIndicatorView"
Cohesion: 0.25
Nodes (9): .body, Bool, CGFloat, Double, Float, Int, TrackMeterIndicatorView, .body (+1 more)

### Community 61 - "TimelineView.swift"
Cohesion: 0.23
Nodes (10): GraphicsContext, .body, CGSize, NSCursor, TimeInterval, Void, TimelineRulerTicksView, TimelineRulerView (+2 more)

### Community 62 - ".attachClip"
Cohesion: 0.26
Nodes (6): ScheduledClip, AVAudioFile, AVAudioFramePosition, AVAudioPlayerNode, AVAudioTime, AVAudioUnitTimePitch

### Community 63 - "TrackGroup"
Cohesion: 0.14
Nodes (16): CodingKey, CodingKeys, horizontalOffset, id, importedAt, name, pitchSemitones, volume (+8 more)

### Community 64 - ".body"
Cohesion: 0.11
Nodes (16): App, Commands, Scene, EditCommands, .body, FileCommands, Content, View (+8 more)

### Community 65 - "Sendable"
Cohesion: 0.09
Nodes (20): CaseIterable, Sendable, MIDILearnTarget, section, UUID, SectionPlaybackMode, continueTimeline, continueToNext (+12 more)

### Community 66 - "AudioTrack"
Cohesion: 0.22
Nodes (10): AudioTrack, .color, .displayName, Bool, Double, String, UUID, .duration (+2 more)

### Community 67 - "Audio Engine — Agent Guide"
Cohesion: 0.20
Nodes (9): Architecture (do not collapse), Audio Engine — Agent Guide, Before you edit, iOS session rules (critical), Log messages, macOS device rules, Red flags (stop and reconsider), Safe change map (+1 more)

### Community 68 - ".hex"
Cohesion: 0.33
Nodes (5): .defaultColor, Int, Int, String, TrackColorPalette

### Community 69 - "WorkspaceView"
Cohesion: 0.16
Nodes (12): ScenePhase, ContentView, .body, Binding, Bool, String, WorkspaceLifecycleModifier, WorkspaceView (+4 more)

### Community 70 - "graphify reference: extra exports and benchmark"
Cohesion: 0.22
Nodes (8): graphify reference: extra exports and benchmark, Step 6b - Wiki (only if --wiki flag), Step 7 - Neo4j export (only if --neo4j or --neo4j-push flag), Step 7a - FalkorDB export (only if --falkordb or --falkordb-push flag), Step 7b - SVG export (only if --svg flag), Step 7c - GraphML export (only if --graphml flag), Step 7d - MCP server (only if --mcp flag), Step 8 - Token reduction benchmark (only if total_words > 5000)

### Community 72 - "WorkspaceSettingsView"
Cohesion: 0.28
Nodes (7): Binding, Bool, String, WorkspaceSettingsView, .body, .deleteSectionDialogTitle, .sectionDeletionDialogBinding

### Community 73 - ".clipContent"
Cohesion: 0.29
Nodes (10): ClipSplitOverlay, .body, .clipWidth, ClipTrimHandle, .handleHitWidth, CGFloat, Gesture, TrackLaneView (+2 more)

### Community 74 - "AudioSampleRate"
Cohesion: 0.24
Nodes (7): Double, AudioSampleRate, .displayName, .id, rate44100, rate48000, URL

### Community 75 - "graphify reference: query, path, explain"
Cohesion: 0.33
Nodes (5): For /graphify explain, For /graphify path, graphify reference: query, path, explain, Step 0 — Constrained query expansion (REQUIRED before traversal), Step 1 — Traversal

### Community 76 - "AudioClip"
Cohesion: 0.31
Nodes (7): AudioClip, .endTime, Int, String, TimeInterval, URL, UUID

### Community 78 - "LyricPlaySyncMessageKind"
Cohesion: 0.22
Nodes (9): LyricPlaySyncMessageKind, catalogRequest, catalogResponse, error, linkSection, linkSectionAck, presence, presenceAck (+1 more)

### Community 79 - "TrackControlButton"
Cohesion: 0.22
Nodes (8): PanKnobView, .body, Bool, Double, String, Void, TrackControlButton, .body

### Community 80 - ".sectionMappingCard"
Cohesion: 0.33
Nodes (5): MIDINoteAssignment, .displayName, Bool, String, UInt8

### Community 81 - "graphify reference: add a URL and watch a folder"
Cohesion: 0.50
Nodes (3): For /graphify add, For --watch, graphify reference: add a URL and watch a folder

### Community 82 - "graphify reference: commit hook and native AGENTS.md integration"
Cohesion: 0.50
Nodes (3): For git commit hook, For native AGENTS.md integration, graphify reference: commit hook and native AGENTS.md integration

### Community 83 - "graphify reference: incremental update and cluster-only"
Cohesion: 0.50
Nodes (3): For --cluster-only, For --update (incremental re-extraction), graphify reference: incremental update and cluster-only

### Community 84 - ".stem"
Cohesion: 0.36
Nodes (3): String, TimeInterval, TrackOrganizationServiceTests

### Community 87 - ".groupMasterStrip"
Cohesion: 0.29
Nodes (4): .mastersStripRow, Double, String, UUID

### Community 89 - ".refreshLyricCatalog"
Cohesion: 0.29
Nodes (4): .assignModeToggle, .expandedPanel, .learnBanner, .lyricCatalogStatus

### Community 90 - ".commitSectionDragPreview"
Cohesion: 0.17
Nodes (6): SectionDragKind, move, resizeEnd, resizeStart, .body, .chipMoveOrTapGesture

### Community 91 - "LyricPlaySyncMessage"
Cohesion: 0.17
Nodes (14): Identifiable, serverError, LinkSectionCommand, LyricPlaySync, LyricPlaySyncCodec, LyricPlaySyncMessage, LyricSlideCatalog, LyricSlideCatalogItem (+6 more)

### Community 92 - ".format"
Cohesion: 0.33
Nodes (5): Bool, String, TimeInterval, .formattedCurrentTime, .formattedDuration

### Community 93 - "View"
Cohesion: 0.10
Nodes (18): AppKit, ButtonStyle, SectionMappingAssignButtonStyle, SectionMappingPlayButtonStyle, Configuration, SectionLyricLinkSheet, .body, .unavailableState (+10 more)

### Community 96 - "SectionPlaybackStatus"
Cohesion: 0.33
Nodes (5): SectionPlaybackStatus, idle, playing, queued, repeatingAtEnd

## Knowledge Gaps
- **358 isolated node(s):** `id`, `name`, `startTime`, `endTime`, `colorHex` (+353 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **7 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `WorkspaceViewModel` connect `WorkspaceViewModel` to `ArrangementSection`, `MIDIInputService`, `DAWProject`, `SupportedAudioFormats`, `TimelineWorkspacePanel`, `AudioImportService`, `SectionMarkerChipView`, `MIDIMappingBarView`, `TrackOrganizationService`, `AudioOutputDevice`, `Foundation`, `ProjectPersistenceService`, `TopToolbarView`, `.body`, `.frames`, `UUID`, `TimeInterval`, `MixerPanelView`, `.importAudioFiles`, `Bool`, `TransportBarView`, `TrackHeaderRowView`, `.applyRestoredProject`, `PropertiesSidebarView`, `ClipEditService`, `LyricPlaySyncClient`, `TrackPitchControlView`, `ProjectEditHistory`, `.recordEditSnapshot`, `TransportRightToolbar`, `.body`, `Sendable`, `AudioTrack`, `WorkspaceView`, `Color`, `WorkspaceSettingsView`, `.clipContent`, `AudioSampleRate`, `AudioClip`, `.addEmptyTrack`, `.sectionMappingCard`, `.refreshLyricCatalog`, `.commitSectionDragPreview`, `LyricPlaySyncMessage`, `.format`, `View`, `SectionPlaybackStatus`?**
  _High betweenness centrality (0.392) - this node is a cross-community bridge._
- **Why does `DAWProject` connect `DAWProject` to `ArrangementSection`, `AudioEngineService`, `TrackOrganizationService`, `Foundation`, `ProjectPersistenceService`, `WorkspaceViewModel`, `Equatable`, `UUID`, `TimeInterval`, `.importAudioFiles`, `.applyRestoredProject`, `.play`, `ProjectEditHistory`, `AudioSettings`, `.recordEditSnapshot`, `.attachClip`, `TrackGroup`, `.body`, `Sendable`, `AudioTrack`, `.hex`, `Color`, `.addEmptyTrack`, `.stem`, `.commitSectionDragPreview`, `LyricPlaySyncMessage`?**
  _High betweenness centrality (0.127) - this node is a cross-community bridge._
- **Why does `ArrangementSection` connect `ArrangementSection` to `SectionPlaybackStatus`, `Sendable`, `DAWProject`, `MIDIInputService`, `.commitSectionDragPreview`, `Color`, `.frames`, `SectionMarkerChipView`, `.selectedMarkerEditor`, `MIDIMappingBarView`, `PropertiesSidebarView`, `.sectionMappingCard`, `SwiftUI`, `WorkspaceViewModel`, `Equatable`, `LyricPlaySyncMessage`, `View`, `TimeInterval`?**
  _High betweenness centrality (0.091) - this node is a cross-community bridge._
- **Are the 11 inferred relationships involving `WorkspaceViewModel` (e.g. with `ArrangementPlaybackEngine` and `AudioImportService`) actually correct?**
  _`WorkspaceViewModel` has 11 INFERRED edges - model-reasoned connections that need verification._
- **Are the 57 inferred relationships involving `DAWProject` (e.g. with `.clear()` and `.activeClipMoveGuides`) actually correct?**
  _`DAWProject` has 57 INFERRED edges - model-reasoned connections that need verification._
- **Are the 3 inferred relationships involving `ArrangementSection` (e.g. with `.body` and `.assignsDistinctColorsForDuplicateNames()`) actually correct?**
  _`ArrangementSection` has 3 INFERRED edges - model-reasoned connections that need verification._
- **What connects `id`, `name`, `startTime` to the rest of the system?**
  _358 weakly-connected nodes found - possible documentation gaps or missing edges._