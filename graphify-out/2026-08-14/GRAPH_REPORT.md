# Graph Report - SimplePlay  (2026-08-14)

## Corpus Check
- 115 files · ~61,443 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 2065 nodes · 5097 edges · 99 communities (92 shown, 7 thin omitted)
- Extraction: 90% EXTRACTED · 10% INFERRED · 0% AMBIGUOUS · INFERRED: 522 edges (avg confidence: 0.8)
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
- CGFloat
- TimelineWorkspacePanel
- CodingKeys
- AudioImportService
- AudioEngineService
- SectionMarkerChipView
- SettingsFormStyle.swift
- MIDIMappingBarView
- DAWVerticalFaderView
- TrackOrganizationService
- AudioSettings
- Foundation
- ImportDocumentPickerSession
- TimeInterval
- SimplePlayProjectArchive
- TopToolbarView
- .clipContent
- WorkspaceViewModel
- What You Must Do When Invoked
- .pitchSemitones
- StandardTrackRole
- Equatable
- .frames
- .clip
- FaderMeterStripView
- TimeInterval
- .selectedMarkerEditor
- IOSPlaybackStrategy
- MixerPanelView
- WaveformCache
- UIKitToolbarMenuButtonRepresentable
- .applyImportedStems
- Bool
- TransportBarView
- Float
- DAWGlassChrome
- .stop
- .standardize
- TrackHeaderRowView
- .applyRestoredProject
- .log
- PropertiesSidebarView
- .play
- AudioClip
- TrackWaveformProgressBar
- LyricPlaySyncClient
- SimplePlay
- LyricPlaySyncTransportError
- TrackPitchControlView
- DAWTheme
- ProjectEditHistory
- SectionLyricLinkSheet
- .mixerChannelStrip
- TransportRightToolbar
- AudioEngineService
- SavedProjectDocument
- .requestNewProject
- ProjectPersistenceService
- TrackGroup
- SwiftUI
- SectionPlaybackMode
- AudioTrack
- Audio Engine — Agent Guide
- .hex
- WorkspaceView
- graphify reference: extra exports and benchmark
- Color
- WorkspaceSettingsView
- AudioDropTargetModifier
- SimplePlayProjectFileDocument
- graphify reference: query, path, explain
- .presentImportPanel
- WaveformLoadMonitor
- LyricPlaySyncMessageKind
- TrackControlButton
- .sectionMappingCard
- graphify reference: add a URL and watch a folder
- graphify reference: commit hook and native AGENTS.md integration
- graphify reference: incremental update and cluster-only
- MIDILearnTarget
- graphify reference: GitHub clone and cross-repo merge
- graphify reference: transcribe video and audio
- .loadURLs
- extraction-spec.md
- ProjectPersistenceError
- .commitSectionDragPreview
- Sendable
- AudioEngineError
- View
- SimplePlayProjectArchiveError
- LyricPlaySyncCodec
- SectionPlaybackStatus
- Density

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
- `.body` --calls--> `WorkspaceView`  [INFERRED]
  SimplePlay/ContentView.swift → SimplePlay/Features/Workspace/Views/WorkspaceView.swift
- `.body` --references--> `ArrangementSection`  [INFERRED]
  SimplePlay/Features/Workspace/Views/SectionMarkerLaneView.swift → SimplePlay/Core/Models/ArrangementSection.swift
- `.duration` --references--> `AudioTrack`  [INFERRED]
  SimplePlay/Core/Models/DAWProject.swift → SimplePlay/Core/Models/AudioTrack.swift
- `.hasSoloTracks` --references--> `AudioTrack`  [INFERRED]
  SimplePlay/Core/Utils/TrackColorPalette.swift → SimplePlay/Core/Models/AudioTrack.swift
- `.activeClipMoveGuides` --references--> `DAWProject`  [INFERRED]
  SimplePlay/Features/Workspace/ViewModels/WorkspaceViewModel.swift → SimplePlay/Core/Models/DAWProject.swift

## Import Cycles
- None detected.

## Communities (99 total, 7 thin omitted)

### Community 0 - "ArrangementSection"
Cohesion: 0.06
Nodes (52): ArrangementSection, .color, .duration, .hasLyricSlideLink, CodingKeys, colorHex, endTime, id (+44 more)

### Community 1 - "MIDIInputService"
Cohesion: 0.08
Nodes (23): CoreMIDI, MIDINotifyProc, MIDIPacket, MIDIPacketList, MIDIInputEvent, MIDIInputService, MIDISourceInfo, .id (+15 more)

### Community 2 - "DAWProject"
Cohesion: 0.10
Nodes (14): DAWProject, Bool, Double, Int32, String, TimeInterval, UInt8, UUID (+6 more)

### Community 3 - "SupportedAudioFormats"
Cohesion: 0.17
Nodes (11): SimplePlayProjectType, UTType, SupportedAudioFormats, .contentTypes, .dropTypes, .filePickerTypes, .folderPickerTypes, .importPickerTypes (+3 more)

### Community 4 - "WaveformClipView"
Cohesion: 0.09
Nodes (28): Float, Int, TimeInterval, URL, WaveformClipPeakStore, CGFloat, Float, Int (+20 more)

### Community 5 - "CGFloat"
Cohesion: 0.13
Nodes (18): GraphicsContext, CGFloat, String, TimeInterval, TimelineRulerScale, .clipWidth, .body, CGFloat (+10 more)

### Community 6 - "TimelineWorkspacePanel"
Cohesion: 0.10
Nodes (32): ScrollPosition, Bool, CGFloat, Content, TimelineHorizontalMirror, .body, TimelineScrollCoordinator, PinnedTimelineHeaderStrip (+24 more)

### Community 7 - "CodingKeys"
Cohesion: 0.08
Nodes (25): CodingKeys, audioSettings, colorHex, id, isLocked, isMuted, isPitchEnabled, isSnapEnabled (+17 more)

### Community 8 - "AudioImportService"
Cohesion: 0.12
Nodes (18): AudioFileStorageService, String, URL, UUID, AudioImportError, emptySelection, .errorDescription, storageUnavailable (+10 more)

### Community 9 - "AudioEngineService"
Cohesion: 0.07
Nodes (21): AVAudioEngine, AVAudioUnitEQ, AudioEngineService, .avEngine, .engineIsRunning, .isAnyPlayerPlaying, .isMeterMonitoringEnabled, .isPlaybackGraphReady (+13 more)

### Community 10 - "SectionMarkerChipView"
Cohesion: 0.07
Nodes (45): Bool, String, TimeInterval, TimeFormatting, .formattedCurrentTime, .formattedDuration, ResizeEdge, end (+37 more)

### Community 11 - "SettingsFormStyle.swift"
Cohesion: 0.13
Nodes (23): Selection, .playbackSettings, .volumeControls, SettingsBadge, SettingsControlSurface, .body, SettingsFieldLabel, .body (+15 more)

### Community 12 - "MIDIMappingBarView"
Cohesion: 0.12
Nodes (18): Animation, AnyTransition, MIDIMappingBarView, .assignModeToggleTitle, .body, .collapsedBar, .devicePickerLabel, .devicePickerTitle (+10 more)

### Community 13 - "DAWVerticalFaderView"
Cohesion: 0.09
Nodes (25): ClosedRange, Double, Float, String, TrackVolumeSettings, .trackRange, DAWVerticalFaderView, .body (+17 more)

### Community 14 - "TrackOrganizationService"
Cohesion: 0.16
Nodes (14): ImportedStem, ImportPlacement, appendNewGroup, insertIntoGroup, Int, String, TimeInterval, URL (+6 more)

### Community 15 - "AudioSettings"
Cohesion: 0.06
Nodes (33): AnyObject, AVAudioSession, Double, Hashable, AudioOutputDevice, AudioSampleRate, .displayName, .id (+25 more)

### Community 16 - "Foundation"
Cohesion: 0.13
Nodes (8): AudioUnit, AVFoundation, CoreAudio, CoreGraphics, Foundation, Observation, os, SnapGrid

### Community 17 - "ImportDocumentPickerSession"
Cohesion: 0.08
Nodes (23): Notification, NSApplicationDelegate, NSEvent, NSObject, NSView, NSViewRepresentable, NSWindow, .body (+15 more)

### Community 18 - "TimeInterval"
Cohesion: 0.18
Nodes (3): TimeInterval, UInt64, AVAudioTime

### Community 19 - "SimplePlayProjectArchive"
Cohesion: 0.25
Nodes (9): Asset, SimplePlayProjectArchive, Bool, Data, Int, UInt32, UInt64, URL (+1 more)

### Community 20 - "TopToolbarView"
Cohesion: 0.18
Nodes (15): Bool, String, Void, ToolbarMenuButtonStyleModifier, TopToolbarView, .addTrackMenu, .importButton, .isCompact (+7 more)

### Community 21 - ".clipContent"
Cohesion: 0.09
Nodes (20): G, ClipMovePreview, ClipDragInteractionModifier, ClipSelectionModifiers, .isExtending, ClipSplitOverlay, .body, ClipTrimHandle (+12 more)

### Community 22 - "WorkspaceViewModel"
Cohesion: 0.05
Nodes (34): SectionEdgeGuides, CGFloat, Date, Set, TimelineScrollRequest, WorkspaceViewModel, .activeClipMoveGuides, .activeClipSplitGuide (+26 more)

### Community 23 - "What You Must Do When Invoked"
Cohesion: 0.08
Nodes (24): For /graphify add and --watch, For /graphify query, For the commit hook and native AGENTS.md integration, For --update and --cluster-only, /graphify, Honesty Rules, Interpreter guard for subcommands, Part A - Structural extraction for code files (+16 more)

### Community 24 - ".pitchSemitones"
Cohesion: 0.13
Nodes (9): groups, PitchShiftSettings, AVAudioUnitTimePitch, Bool, Double, Float, Int, UUID (+1 more)

### Community 25 - "StandardTrackRole"
Cohesion: 0.08
Nodes (25): StandardTrackRole, acousticGuitar, backingVocal, bass, brass, click, countIn, cue (+17 more)

### Community 26 - "Equatable"
Cohesion: 0.25
Nodes (15): Equatable, PersistedClip, PersistedProject, PersistedTrack, Bool, Decoder, Double, Encoder (+7 more)

### Community 27 - ".frames"
Cohesion: 0.29
Nodes (6): Bool, Double, Int64, TimeInterval, TimelineSampleGrid, TimelineSampleGridTests

### Community 28 - ".clip"
Cohesion: 0.17
Nodes (3): .canSplitSelectedClipAtPlayhead, .splitGesture, .trimGesture

### Community 29 - "FaderMeterStripView"
Cohesion: 0.11
Nodes (15): Float, .mastersStripRow, .projectMasterStrip, String, .faderStrip, FaderMeterStripView, .reservesThumbClearance, .showsUnityMark (+7 more)

### Community 30 - "TimeInterval"
Cohesion: 0.10
Nodes (10): Bool, ClosedRange, TimeInterval, Timer, TimelineScrollAlignment, center, leading, start (+2 more)

### Community 31 - ".selectedMarkerEditor"
Cohesion: 0.21
Nodes (16): .audioSettings, .sectionEditor, .selectedMarkerEditor, .selectionInfo, .sessionManagement, .trackPitch, DAWSecondaryButtonStyle, SettingsFootnote (+8 more)

### Community 32 - "IOSPlaybackStrategy"
Cohesion: 0.08
Nodes (24): IOSPlaybackStrategy, .meterTapBufferSize, AudioEngineService, AVAudioFile, AVAudioFrameCount, AVAudioFramePosition, AVAudioPlayerNode, AVAudioTime (+16 more)

### Community 33 - "MixerPanelView"
Cohesion: 0.11
Nodes (19): MixerPanelView, .body, .channelFaderHeight, .channelFaderWidth, .channelStripWidth, .groupDivider, .isCompact, .masterFaderHeight (+11 more)

### Community 34 - "WaveformCache"
Cohesion: 0.23
Nodes (14): CheckedContinuation, Bool, Double, Float, Int, MainActor, Never, Sendable (+6 more)

### Community 35 - "UIKitToolbarMenuButtonRepresentable"
Cohesion: 0.33
Nodes (7): Coordinator, Context, String, Void, UIKitToolbarMenuButtonRepresentable, UIButton, UIViewRepresentable

### Community 36 - ".applyImportedStems"
Cohesion: 0.12
Nodes (8): Error, Result, Bool, TimeInterval, String, URL, Content, .workspaceRoot

### Community 37 - "Bool"
Cohesion: 0.14
Nodes (9): .collapsedBarContent, SectionMappingAssignButtonStyle, SectionMappingCardGlow, SectionMappingPlayButtonStyle, Bool, CGFloat, Configuration, Content (+1 more)

### Community 38 - "TransportBarView"
Cohesion: 0.06
Nodes (36): Path, Bool, CGFloat, CGSize, ClosedRange, Gesture, TimeInterval, TimelineOverviewBar (+28 more)

### Community 39 - "Float"
Cohesion: 0.22
Nodes (6): AVAudioMixerNode, AVAudioPCMBuffer, MeterPeakBuffer, Float, UUID, Void

### Community 40 - "DAWGlassChrome"
Cohesion: 0.17
Nodes (10): Glass, DAWGlassChrome, .controlGlass, .panelGlass, CGFloat, Double, LinearGradient, View (+2 more)

### Community 42 - ".standardize"
Cohesion: 0.22
Nodes (7): StandardizedName, Bool, Int, String, URL, TrackNameStandardizer, TrackNameStandardizerTests

### Community 43 - "TrackHeaderRowView"
Cohesion: 0.14
Nodes (17): Bool, Binding, Bool, CGFloat, Double, TrackHeaderRowView, .body, .compactLayout (+9 more)

### Community 44 - ".applyRestoredProject"
Cohesion: 0.13
Nodes (6): .body, Content, View, View, WorkspaceKeyboardShortcuts, .timeDisplay

### Community 45 - ".log"
Cohesion: 0.24
Nodes (9): SectionLoopDiagnostics, SectionTriggerDiagnostics, AVAudioFrameCount, Bool, Double, Int64, String, TimeInterval (+1 more)

### Community 46 - "PropertiesSidebarView"
Cohesion: 0.15
Nodes (16): PropertiesSidebarView, .body, .pitchIsOriginal, .pitchLabel, .sectionCreationHint, .selectedDeviceID, .selectedSection, .selectedSectionNameBinding (+8 more)

### Community 47 - ".play"
Cohesion: 0.16
Nodes (14): SectionLoopContext, .duration, TimeInterval, UUID, ScheduledClip, AVAudioFile, AVAudioFrameCount, AVAudioPlayerNode (+6 more)

### Community 48 - "AudioClip"
Cohesion: 0.12
Nodes (17): Identifiable, AudioClip, .endTime, Int, String, TimeInterval, URL, UUID (+9 more)

### Community 49 - "TrackWaveformProgressBar"
Cohesion: 0.40
Nodes (4): Bool, Double, TrackWaveformProgressBar, .body

### Community 50 - "LyricPlaySyncClient"
Cohesion: 0.23
Nodes (8): NWBrowser, NWEndpoint, LyricPlaySyncClient, Never, Set, TimeInterval, Void, Task

### Community 51 - "SimplePlay"
Cohesion: 0.21
Nodes (4): SimplePlay, ProjectArchiveTests, SimplePlayTests, Testing

### Community 52 - "LyricPlaySyncTransportError"
Cohesion: 0.14
Nodes (13): LocalizedError, Network, ConnectionState, connected, failed, idle, searching, LyricPlaySyncTransportError (+5 more)

### Community 53 - "TrackPitchControlView"
Cohesion: 0.15
Nodes (14): .actionButtons, Binding, Bool, Double, String, UUID, TrackPitchControlView, .menuTitle (+6 more)

### Community 54 - "DAWTheme"
Cohesion: 0.13
Nodes (15): .assignModeToggle, .learnBanner, .markerHeaderRow, AudioDropOverlay, .body, String, TimelineEmptyDropHint, .body (+7 more)

### Community 55 - "ProjectEditHistory"
Cohesion: 0.10
Nodes (12): ProjectEditHistory, .canRedo, .canUndo, Bool, Int, ProjectEditHistoryTests, SimplePlayUITests, SimplePlayUITestsLaunchTests (+4 more)

### Community 57 - ".mixerChannelStrip"
Cohesion: 0.20
Nodes (7): .masterVolumeBinding, .mixerScrollWithPinnedMasters, Binding, Double, UUID, .masterVolumeBinding, .trackVolumeBinding

### Community 58 - "TransportRightToolbar"
Cohesion: 0.06
Nodes (34): Double, Bool, CGFloat, String, Void, TimelineScaleControls, .body, .buttonCornerRadius (+26 more)

### Community 59 - "AudioEngineService"
Cohesion: 0.40
Nodes (3): AudioEngineService, AVAudioTime, TimeInterval

### Community 60 - "SavedProjectDocument"
Cohesion: 0.32
Nodes (5): SavedProjectDocument, ManifestFile, Data, String, .body

### Community 62 - "ProjectPersistenceService"
Cohesion: 0.30
Nodes (5): unsupportedVersion, ProjectPersistenceService, Bool, URL, UUID

### Community 63 - "TrackGroup"
Cohesion: 0.14
Nodes (16): CodingKey, CodingKeys, horizontalOffset, id, importedAt, name, pitchSemitones, volume (+8 more)

### Community 64 - "SwiftUI"
Cohesion: 0.11
Nodes (15): App, AppKit, Commands, Scene, ContentView, .body, EditCommands, FileCommands (+7 more)

### Community 65 - "SectionPlaybackMode"
Cohesion: 0.13
Nodes (13): CaseIterable, SectionPlaybackMode, continueTimeline, continueToNext, .displayName, .id, oneShot, repeatSection (+5 more)

### Community 66 - "AudioTrack"
Cohesion: 0.22
Nodes (10): AudioTrack, .color, .displayName, Bool, Double, String, UUID, .duration (+2 more)

### Community 67 - "Audio Engine — Agent Guide"
Cohesion: 0.20
Nodes (9): Architecture (do not collapse), Audio Engine — Agent Guide, Before you edit, iOS session rules (critical), Log messages, macOS device rules, Red flags (stop and reconsider), Safe change map (+1 more)

### Community 68 - ".hex"
Cohesion: 0.35
Nodes (4): .defaultColor, Int, String, TrackColorPalette

### Community 69 - "WorkspaceView"
Cohesion: 0.22
Nodes (10): ScenePhase, Binding, Bool, String, WorkspaceLifecycleModifier, WorkspaceView, .body, .deleteSectionDialogTitle (+2 more)

### Community 70 - "graphify reference: extra exports and benchmark"
Cohesion: 0.22
Nodes (8): graphify reference: extra exports and benchmark, Step 6b - Wiki (only if --wiki flag), Step 7 - Neo4j export (only if --neo4j or --neo4j-push flag), Step 7a - FalkorDB export (only if --falkordb or --falkordb-push flag), Step 7b - SVG export (only if --svg flag), Step 7c - GraphML export (only if --graphml flag), Step 7d - MCP server (only if --mcp flag), Step 8 - Token reduction benchmark (only if total_words > 5000)

### Community 72 - "WorkspaceSettingsView"
Cohesion: 0.29
Nodes (6): Binding, Bool, String, WorkspaceSettingsView, .deleteSectionDialogTitle, .sectionDeletionDialogBinding

### Community 73 - "AudioDropTargetModifier"
Cohesion: 0.27
Nodes (7): AudioDropTargetModifier, Content, NSItemProvider, String, TimeInterval, View, View

### Community 74 - "SimplePlayProjectFileDocument"
Cohesion: 0.25
Nodes (7): FileDocument, FileWrapper, ReadConfiguration, SimplePlayProjectFileDocument, .readableContentTypes, Data, WriteConfiguration

### Community 75 - "graphify reference: query, path, explain"
Cohesion: 0.33
Nodes (5): For /graphify explain, For /graphify path, graphify reference: query, path, explain, Step 0 — Constrained query expansion (REQUIRED before traversal), Step 1 — Traversal

### Community 76 - ".presentImportPanel"
Cohesion: 0.21
Nodes (7): ProjectFilePanel, URL, ImportPanelKind, audioFiles, folder, .importMenuItems, .body

### Community 77 - "WaveformLoadMonitor"
Cohesion: 0.53
Nodes (4): clips, Double, UUID, WaveformLoadMonitor

### Community 78 - "LyricPlaySyncMessageKind"
Cohesion: 0.22
Nodes (9): LyricPlaySyncMessageKind, catalogRequest, catalogResponse, error, linkSection, linkSectionAck, presence, presenceAck (+1 more)

### Community 79 - "TrackControlButton"
Cohesion: 0.22
Nodes (8): PanKnobView, .body, Bool, Double, String, Void, TrackControlButton, .body

### Community 80 - ".sectionMappingCard"
Cohesion: 0.23
Nodes (7): MIDINoteAssignment, .displayName, Bool, String, UInt8, .expandedPanel, .lyricCatalogStatus

### Community 81 - "graphify reference: add a URL and watch a folder"
Cohesion: 0.50
Nodes (3): For /graphify add, For --watch, graphify reference: add a URL and watch a folder

### Community 82 - "graphify reference: commit hook and native AGENTS.md integration"
Cohesion: 0.50
Nodes (3): For git commit hook, For native AGENTS.md integration, graphify reference: commit hook and native AGENTS.md integration

### Community 83 - "graphify reference: incremental update and cluster-only"
Cohesion: 0.50
Nodes (3): For --cluster-only, For --update (incremental re-extraction), graphify reference: incremental update and cluster-only

### Community 84 - "MIDILearnTarget"
Cohesion: 0.24
Nodes (6): MIDILearnTarget, section, UUID, Kind, controlChange, noteOn

### Community 87 - ".loadURLs"
Cohesion: 0.62
Nodes (4): DropURLLoader, NSItemProvider, String, URL

### Community 89 - "ProjectPersistenceError"
Cohesion: 0.20
Nodes (9): JSONDecoder, .projectDecoder, ProjectPersistenceError, .errorDescription, invalidPackage, missingAudioFile, missingManifest, Int (+1 more)

### Community 90 - ".commitSectionDragPreview"
Cohesion: 0.22
Nodes (5): SectionDragKind, move, resizeEnd, resizeStart, .chipMoveOrTapGesture

### Community 91 - "Sendable"
Cohesion: 0.26
Nodes (13): Codable, Sendable, serverError, LinkSectionCommand, LyricPlaySync, LyricPlaySyncMessage, LyricSlideCatalog, LyricSlideCatalogItem (+5 more)

### Community 92 - "AudioEngineError"
Cohesion: 0.29
Nodes (7): AudioEngineError, clipLoadFailed, deviceSelectionFailed, engineStartFailed, .errorDescription, noPlayableClips, playbackUnavailable

### Community 93 - "View"
Cohesion: 0.16
Nodes (12): ButtonStyle, .unavailableState, DAWIconToolbarButtonStyle, DAWLabeledToolbarButtonStyle, DAWPrimaryButtonStyle, Configuration, Content, .body (+4 more)

### Community 94 - "SimplePlayProjectArchiveError"
Cohesion: 0.29
Nodes (6): SimplePlayProjectArchiveError, corruptAsset, corruptManifest, .errorDescription, invalidArchive, String

### Community 95 - "LyricPlaySyncCodec"
Cohesion: 0.40
Nodes (4): LyricPlaySyncCodec, Data, JSONEncoder, .pretty

### Community 96 - "SectionPlaybackStatus"
Cohesion: 0.33
Nodes (5): SectionPlaybackStatus, idle, playing, queued, repeatingAtEnd

### Community 98 - "Density"
Cohesion: 0.50
Nodes (4): Density, compact, full, minimal

## Knowledge Gaps
- **358 isolated node(s):** `id`, `name`, `startTime`, `endTime`, `colorHex` (+353 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **7 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `WorkspaceViewModel` connect `WorkspaceViewModel` to `ArrangementSection`, `MIDIInputService`, `DAWProject`, `TimelineWorkspacePanel`, `AudioImportService`, `SectionMarkerChipView`, `MIDIMappingBarView`, `TrackOrganizationService`, `AudioSettings`, `Foundation`, `TopToolbarView`, `.clipContent`, `.pitchSemitones`, `.clip`, `FaderMeterStripView`, `TimeInterval`, `MixerPanelView`, `.applyImportedStems`, `Bool`, `TransportBarView`, `TrackHeaderRowView`, `.applyRestoredProject`, `PropertiesSidebarView`, `AudioClip`, `LyricPlaySyncClient`, `TrackPitchControlView`, `ProjectEditHistory`, `SectionLyricLinkSheet`, `.mixerChannelStrip`, `TransportRightToolbar`, `SavedProjectDocument`, `.requestNewProject`, `ProjectPersistenceService`, `SwiftUI`, `SectionPlaybackMode`, `AudioTrack`, `.hex`, `WorkspaceView`, `Color`, `WorkspaceSettingsView`, `AudioDropTargetModifier`, `SimplePlayProjectFileDocument`, `.presentImportPanel`, `.sectionMappingCard`, `MIDILearnTarget`, `.commitSectionDragPreview`, `Sendable`, `View`, `SectionPlaybackStatus`, `.sectionLyricAssignRow`?**
  _High betweenness centrality (0.388) - this node is a cross-community bridge._
- **Why does `DAWProject` connect `DAWProject` to `ArrangementSection`, `AudioEngineService`, `SectionMarkerChipView`, `TrackOrganizationService`, `AudioSettings`, `Foundation`, `WorkspaceViewModel`, `.pitchSemitones`, `Equatable`, `.clip`, `TimeInterval`, `.applyImportedStems`, `.applyRestoredProject`, `.play`, `AudioClip`, `ProjectEditHistory`, `.mixerChannelStrip`, `TransportRightToolbar`, `SavedProjectDocument`, `ProjectPersistenceService`, `TrackGroup`, `AudioTrack`, `.hex`, `Color`, `.commitSectionDragPreview`, `Sendable`, `.sectionLyricAssignRow`?**
  _High betweenness centrality (0.128) - this node is a cross-community bridge._
- **Why does `Foundation` connect `Foundation` to `MIDIInputService`, `SupportedAudioFormats`, `WaveformClipView`, `AudioImportService`, `SectionMarkerChipView`, `DAWVerticalFaderView`, `AudioSettings`, `Equatable`, `.frames`, `IOSPlaybackStrategy`, `.play`, `AudioClip`, `SimplePlay`, `LyricPlaySyncTransportError`, `ProjectEditHistory`, `TrackGroup`, `SwiftUI`, `SectionPlaybackMode`, `MIDILearnTarget`, `ProjectPersistenceError`, `Sendable`, `SimplePlayProjectArchiveError`?**
  _High betweenness centrality (0.092) - this node is a cross-community bridge._
- **Are the 11 inferred relationships involving `WorkspaceViewModel` (e.g. with `ArrangementPlaybackEngine` and `AudioImportService`) actually correct?**
  _`WorkspaceViewModel` has 11 INFERRED edges - model-reasoned connections that need verification._
- **Are the 57 inferred relationships involving `DAWProject` (e.g. with `.clear()` and `.activeClipMoveGuides`) actually correct?**
  _`DAWProject` has 57 INFERRED edges - model-reasoned connections that need verification._
- **Are the 3 inferred relationships involving `ArrangementSection` (e.g. with `.body` and `.assignsDistinctColorsForDuplicateNames()`) actually correct?**
  _`ArrangementSection` has 3 INFERRED edges - model-reasoned connections that need verification._
- **What connects `id`, `name`, `startTime` to the rest of the system?**
  _358 weakly-connected nodes found - possible documentation gaps or missing edges._