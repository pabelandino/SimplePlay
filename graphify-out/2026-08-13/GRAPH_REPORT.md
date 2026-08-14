# Graph Report - SimplePlay  (2026-08-13)

## Corpus Check
- 103 files · ~53,564 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 1825 nodes · 4365 edges · 97 communities (91 shown, 6 thin omitted)
- Extraction: 90% EXTRACTED · 10% INFERRED · 0% AMBIGUOUS · INFERRED: 436 edges (avg confidence: 0.8)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `a0b2df27`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- SimplePlayUITests
- SectionMarkerChipView
- MacOSPlaybackStrategy
- What You Must Do When Invoked
- TrackLaneView
- graphify reference: extra exports and benchmark
- CGFloat
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
- PropertiesSidebarView
- AudioEngineService
- StandardTrackRole
- String
- PitchShiftSettings
- MIDIMappingBarView
- LyricPlaySyncTransportError
- Equatable
- .standardize
- .frames
- SimplePlayProjectArchive
- CodingKeys
- Testing
- TrackOrganizationService
- DAWProject
- SupportedAudioFormats
- LyricPlaySyncCodec
- Float
- UUID
- AudioTrack
- WorkspaceView
- ImportDocumentPickerSession
- LyricPlaySyncClient
- AudioImportService
- FaderMeterStripView
- SwiftUI
- .peaks
- AudioOutputDevice
- TrackPitchControlView
- MIDIInputService
- AudioSettings
- AudioDropTargetModifier
- SimplePlayProjectFileDocument
- TrackGroup
- LyricPlaySyncMessageKind
- .applyAudioSettings
- DAWVerticalFaderView
- TimeInterval
- Foundation
- ContentView
- .body
- .stop
- .refreshLyricCatalog
- View
- Task
- .play
- DAWProject
- .workspaceRoot
- TopToolbarView
- WorkspaceViewModel
- AudioSampleRate
- .log
- UIKitToolbarMenuButtonRepresentable
- DAWTheme
- ProjectPersistenceService
- .triggerSection
- AudioEngineError
- .selectedMarkerEditor
- .hex
- TrackHeaderRowView
- PinnedTimelineHeaderStrip
- TrackControlButton
- Sendable
- AudioClip
- DropURLLoader
- IOSPlaybackStrategy
- SavedProjectDocument
- .loadBucket
- SectionPlaybackMode
- SectionPlaybackStatus
- .groupVolumeBinding
- AudioFileStorageService
- ProjectPersistenceError
- MIDINoteAssignment
- AudioImportError
- MIDILearnTarget
- .trackMeterLevel
- Kind

## God Nodes (most connected - your core abstractions)
1. `WorkspaceViewModel` - 263 edges
2. `AudioEngineService` - 128 edges
3. `ArrangementSection` - 70 edges
4. `DAWTheme` - 52 edges
5. `MIDIMappingBarView` - 48 edges
6. `AudioTrack` - 44 edges
7. `ArrangementPlaybackEngine` - 36 edges
8. `MixerPanelView` - 35 edges
9. `PropertiesSidebarView` - 32 edges
10. `CodingKeys` - 31 edges

## Surprising Connections (you probably didn't know these)
- `.duration` --references--> `AudioTrack`  [INFERRED]
  SimplePlay/Core/Models/DAWProject.swift → SimplePlay/Core/Models/AudioTrack.swift
- `.body` --calls--> `WorkspaceView`  [INFERRED]
  SimplePlay/ContentView.swift → SimplePlay/Features/Workspace/Views/WorkspaceView.swift
- `.body` --references--> `ArrangementSection`  [INFERRED]
  SimplePlay/Features/Workspace/Views/SectionMarkerLaneView.swift → SimplePlay/Core/Models/ArrangementSection.swift
- `.body` --references--> `ArrangementSection`  [INFERRED]
  SimplePlay/Features/Workspace/Views/SectionMarkerLaneView.swift → SimplePlay/Core/Models/ArrangementSection.swift
- `.hasSoloTracks` --references--> `AudioTrack`  [INFERRED]
  SimplePlay/Core/Utils/TrackColorPalette.swift → SimplePlay/Core/Models/AudioTrack.swift

## Import Cycles
- None detected.

## Communities (97 total, 6 thin omitted)

### Community 0 - "SimplePlayUITests"
Cohesion: 0.15
Nodes (6): SimplePlayUITests, SimplePlayUITestsLaunchTests, .runsForEachTargetApplicationUIConfiguration, Bool, XCTest, XCTestCase

### Community 1 - "SectionMarkerChipView"
Cohesion: 0.07
Nodes (40): NSCursor, Bool, String, TimeInterval, SectionDragKind, move, resizeEnd, resizeStart (+32 more)

### Community 2 - "MacOSPlaybackStrategy"
Cohesion: 0.15
Nodes (11): MacOSPlaybackStrategy, .meterTapBufferSize, AVAudioFile, AVAudioFrameCount, AVAudioFramePosition, AVAudioPlayerNode, AVAudioTime, Double (+3 more)

### Community 3 - "What You Must Do When Invoked"
Cohesion: 0.08
Nodes (24): For /graphify add and --watch, For /graphify query, For the commit hook and native AGENTS.md integration, For --update and --cluster-only, /graphify, Honesty Rules, Interpreter guard for subcommands, Part A - Structural extraction for code files (+16 more)

### Community 4 - "TrackLaneView"
Cohesion: 0.08
Nodes (29): G, GraphicsContext, CGFloat, String, TimeInterval, TimelineRulerScale, View, WorkspaceKeyboardShortcuts (+21 more)

### Community 5 - "graphify reference: extra exports and benchmark"
Cohesion: 0.22
Nodes (8): graphify reference: extra exports and benchmark, Step 6b - Wiki (only if --wiki flag), Step 7 - Neo4j export (only if --neo4j or --neo4j-push flag), Step 7a - FalkorDB export (only if --falkordb or --falkordb-push flag), Step 7b - SVG export (only if --svg flag), Step 7c - GraphML export (only if --graphml flag), Step 7d - MCP server (only if --mcp flag), Step 8 - Token reduction benchmark (only if total_words > 5000)

### Community 6 - "CGFloat"
Cohesion: 0.13
Nodes (10): CGFloat, TimelineScrollAlignment, center, leading, start, TimelineScrollRequest, .minimumTimelineZoom, .timelineContentWidth (+2 more)

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
Nodes (52): ArrangementSection, .color, .duration, .hasLyricSlideLink, CodingKeys, colorHex, endTime, id (+44 more)

### Community 15 - "MixerPanelView"
Cohesion: 0.09
Nodes (21): MixerPanelView, .body, .channelFaderHeight, .channelFaderWidth, .channelStripWidth, .groupDivider, .isCompact, .masterFaderHeight (+13 more)

### Community 16 - "TimelineWorkspacePanel"
Cohesion: 0.17
Nodes (21): ScrollPosition, PlayheadView, .body, .playheadDragGesture, CGFloat, Double, Gesture, Int (+13 more)

### Community 17 - "TransportBarView"
Cohesion: 0.05
Nodes (44): Path, Bool, CGFloat, CGSize, ClosedRange, Gesture, TimeInterval, TimelineOverviewBar (+36 more)

### Community 18 - "PropertiesSidebarView"
Cohesion: 0.12
Nodes (19): PropertiesSidebarView, .body, .pitchIsOriginal, .pitchLabel, .sectionCreationHint, .selectedDeviceID, .selectedSection, .selectedSectionNameBinding (+11 more)

### Community 19 - "AudioEngineService"
Cohesion: 0.07
Nodes (21): AVAudioEngine, AudioEngineService, .isAnyPlayerPlaying, .isMeterMonitoringEnabled, .isPlaybackGraphReady, .isSamplePlaybackClockEstablished, .isSectionLoopPlaybackActive, .masterVolume (+13 more)

### Community 20 - "StandardTrackRole"
Cohesion: 0.08
Nodes (24): StandardTrackRole, acousticGuitar, backingVocal, bass, brass, click, countIn, cue (+16 more)

### Community 21 - "String"
Cohesion: 0.27
Nodes (4): Error, Result, String, URL

### Community 22 - "PitchShiftSettings"
Cohesion: 0.20
Nodes (6): PitchShiftSettings, AVAudioUnitTimePitch, Bool, Double, Float, PitchShiftSettingsTests

### Community 23 - "MIDIMappingBarView"
Cohesion: 0.09
Nodes (20): Animation, AnyTransition, Color, StandardTrackRole, .fallbackColor, MIDIMappingBarView, .assignModeToggleTitle, .body (+12 more)

### Community 24 - "LyricPlaySyncTransportError"
Cohesion: 0.14
Nodes (13): LocalizedError, Network, ConnectionState, connected, failed, idle, searching, LyricPlaySyncTransportError (+5 more)

### Community 25 - "Equatable"
Cohesion: 0.27
Nodes (15): Equatable, PersistedClip, PersistedProject, PersistedTrack, Bool, Decoder, Double, Encoder (+7 more)

### Community 26 - ".standardize"
Cohesion: 0.25
Nodes (7): StandardizedName, Bool, StandardTrackRole, String, URL, TrackNameStandardizer, TrackNameStandardizerTests

### Community 27 - ".frames"
Cohesion: 0.32
Nodes (6): Bool, Double, Int64, TimeInterval, TimelineSampleGrid, TimelineSampleGridTests

### Community 28 - "SimplePlayProjectArchive"
Cohesion: 0.16
Nodes (15): Asset, SimplePlayProjectArchive, SimplePlayProjectArchiveError, corruptAsset, corruptManifest, .errorDescription, invalidArchive, Bool (+7 more)

### Community 29 - "CodingKeys"
Cohesion: 0.08
Nodes (25): CodingKeys, audioSettings, colorHex, id, isLocked, isMuted, isPitchEnabled, isSnapEnabled (+17 more)

### Community 30 - "Testing"
Cohesion: 0.22
Nodes (4): SimplePlay, ProjectArchiveTests, SimplePlayTests, Testing

### Community 31 - "TrackOrganizationService"
Cohesion: 0.19
Nodes (13): ImportedStem, ImportPlacement, appendNewGroup, insertIntoGroup, DAWProject, Int, String, TimeInterval (+5 more)

### Community 32 - "DAWProject"
Cohesion: 0.31
Nodes (9): DAWProject, .duration, Bool, Double, Int32, String, TimeInterval, UInt8 (+1 more)

### Community 33 - "SupportedAudioFormats"
Cohesion: 0.19
Nodes (11): SimplePlayProjectType, UTType, SupportedAudioFormats, .contentTypes, .dropTypes, .filePickerTypes, .folderPickerTypes, .importPickerTypes (+3 more)

### Community 34 - "LyricPlaySyncCodec"
Cohesion: 0.40
Nodes (4): LyricPlaySyncCodec, Data, JSONEncoder, .pretty

### Community 35 - "Float"
Cohesion: 0.24
Nodes (6): AVAudioMixerNode, AVAudioPCMBuffer, MeterPeakBuffer, Float, UUID, Void

### Community 36 - "UUID"
Cohesion: 0.24
Nodes (4): Double, UUID, .mixerScrollWithPinnedMasters, .body

### Community 37 - "AudioTrack"
Cohesion: 0.24
Nodes (11): AudioTrack, .color, .displayName, Bool, Double, StandardTrackRole, String, UUID (+3 more)

### Community 38 - "WorkspaceView"
Cohesion: 0.16
Nodes (11): ScenePhase, Binding, Bool, Content, String, WorkspaceLifecycleModifier, WorkspaceView, .body (+3 more)

### Community 39 - "ImportDocumentPickerSession"
Cohesion: 0.08
Nodes (23): Notification, NSApplicationDelegate, NSEvent, NSObject, NSView, NSViewRepresentable, NSWindow, .body (+15 more)

### Community 40 - "LyricPlaySyncClient"
Cohesion: 0.19
Nodes (9): NWBrowser, NWEndpoint, LyricPlaySyncClient, serverError, Never, Set, TimeInterval, Void (+1 more)

### Community 41 - "AudioImportService"
Cohesion: 0.27
Nodes (8): AudioImportService, ImportedStemsResult, String, TimeInterval, URL, UUID, Bool, URL

### Community 42 - "FaderMeterStripView"
Cohesion: 0.15
Nodes (12): .projectMasterStrip, .mainVolumeControl, FaderMeterStripView, .reservesThumbClearance, .showsUnityMark, .usesUnityCenterDecibelScale, Bool, CGFloat (+4 more)

### Community 43 - "SwiftUI"
Cohesion: 0.16
Nodes (9): AppKit, ResizablePropertiesSidebar, .body, Bool, Double, TrackWaveformProgressBar, .body, SwiftUI (+1 more)

### Community 44 - ".peaks"
Cohesion: 0.09
Nodes (29): CheckedContinuation, clips, Double, Float, Int, MainActor, Never, Sendable (+21 more)

### Community 45 - "AudioOutputDevice"
Cohesion: 0.16
Nodes (12): Hashable, AudioOutputDevice, Int, String, UInt32, AudioDeviceService, AudioDeviceID, Bool (+4 more)

### Community 46 - "TrackPitchControlView"
Cohesion: 0.15
Nodes (14): .actionButtons, Binding, Bool, Double, String, UUID, TrackPitchControlView, .menuTitle (+6 more)

### Community 47 - "MIDIInputService"
Cohesion: 0.08
Nodes (23): CoreMIDI, MIDINotifyProc, MIDIPacket, MIDIPacketList, MIDIInputEvent, MIDIInputService, MIDISourceInfo, .id (+15 more)

### Community 48 - "AudioSettings"
Cohesion: 0.29
Nodes (4): AVAudioSession, AVAudioUnitEQ, AudioSettings, AudioDeviceID

### Community 49 - "AudioDropTargetModifier"
Cohesion: 0.27
Nodes (7): AudioDropTargetModifier, Content, NSItemProvider, String, TimeInterval, View, View

### Community 50 - "SimplePlayProjectFileDocument"
Cohesion: 0.22
Nodes (7): FileDocument, FileWrapper, ReadConfiguration, SimplePlayProjectFileDocument, .readableContentTypes, Data, WriteConfiguration

### Community 51 - "TrackGroup"
Cohesion: 0.14
Nodes (16): CodingKey, CodingKeys, horizontalOffset, id, importedAt, name, pitchSemitones, volume (+8 more)

### Community 52 - "LyricPlaySyncMessageKind"
Cohesion: 0.22
Nodes (9): LyricPlaySyncMessageKind, catalogRequest, catalogResponse, error, linkSection, linkSectionAck, presence, presenceAck (+1 more)

### Community 54 - "DAWVerticalFaderView"
Cohesion: 0.09
Nodes (25): ClosedRange, Double, Float, String, TrackVolumeSettings, .trackRange, DAWVerticalFaderView, .body (+17 more)

### Community 55 - "TimeInterval"
Cohesion: 0.22
Nodes (3): Bool, TimeInterval, .transportControls

### Community 56 - "Foundation"
Cohesion: 0.11
Nodes (8): AudioUnit, AVFoundation, CoreAudio, Foundation, Observation, os, SnapGrid, TimeFormatting

### Community 57 - "ContentView"
Cohesion: 0.18
Nodes (10): App, Commands, Scene, ContentView, .body, FileCommands, TransportCommands, .body (+2 more)

### Community 58 - ".body"
Cohesion: 0.14
Nodes (6): ImportPanelKind, audioFiles, folder, Int, .body, .trackHeaderColumnTracksOnly

### Community 60 - ".refreshLyricCatalog"
Cohesion: 0.20
Nodes (7): .expandedPanel, .lyricCatalogStatus, SectionLyricLinkSheet, .body, .unavailableState, DAWPrimaryButtonStyle, .settingsHeader

### Community 61 - "View"
Cohesion: 0.13
Nodes (14): ButtonStyle, SectionMappingAssignButtonStyle, SectionMappingCardGlow, SectionMappingPlayButtonStyle, Bool, CGFloat, Configuration, Content (+6 more)

### Community 62 - "Task"
Cohesion: 0.17
Nodes (6): Bool, TimeInterval, Content, TimelineAudioDropModifier, .body, Task

### Community 63 - ".play"
Cohesion: 0.13
Nodes (16): SectionLoopContext, .duration, TimeInterval, UUID, ScheduledClip, AVAudioFile, AVAudioFrameCount, AVAudioPlayerNode (+8 more)

### Community 64 - "DAWProject"
Cohesion: 0.38
Nodes (4): groups, DAWProject, Int, UUID

### Community 65 - ".workspaceRoot"
Cohesion: 0.17
Nodes (9): DAWProject, Binding, Bool, String, WorkspaceSettingsView, .body, .deleteSectionDialogTitle, .sectionDeletionDialogBinding (+1 more)

### Community 66 - "TopToolbarView"
Cohesion: 0.15
Nodes (18): Bool, String, Void, ToolbarMenuButtonStyleModifier, TopToolbarView, .importButton, .importMenuItems, .isCompact (+10 more)

### Community 67 - "WorkspaceViewModel"
Cohesion: 0.06
Nodes (26): Content, View, SectionEdgeGuides, ClosedRange, Date, Set, Timer, WorkspaceViewModel (+18 more)

### Community 68 - "AudioSampleRate"
Cohesion: 0.24
Nodes (8): Double, Identifiable, AudioSampleRate, .displayName, .id, rate44100, rate48000, URL

### Community 69 - ".log"
Cohesion: 0.38
Nodes (6): SectionLoopDiagnostics, AVAudioFrameCount, Double, Int64, String, TimeInterval

### Community 70 - "UIKitToolbarMenuButtonRepresentable"
Cohesion: 0.33
Nodes (7): Coordinator, Context, String, Void, UIKitToolbarMenuButtonRepresentable, UIButton, UIViewRepresentable

### Community 71 - "DAWTheme"
Cohesion: 0.09
Nodes (23): Glass, .assignModeToggle, .learnBanner, AudioDropOverlay, .body, String, TimelineEmptyDropHint, .body (+15 more)

### Community 72 - "ProjectPersistenceService"
Cohesion: 0.26
Nodes (7): missingAudioFile, unsupportedVersion, ProjectPersistenceService, Bool, DAWProject, URL, UUID

### Community 73 - ".triggerSection"
Cohesion: 0.31
Nodes (5): SectionTriggerDiagnostics, Bool, String, TimeInterval, UUID

### Community 74 - "AudioEngineError"
Cohesion: 0.29
Nodes (7): AudioEngineError, clipLoadFailed, deviceSelectionFailed, engineStartFailed, .errorDescription, noPlayableClips, playbackUnavailable

### Community 75 - ".selectedMarkerEditor"
Cohesion: 0.09
Nodes (39): Selection, .audioSettings, .playbackSettings, .sectionEditor, .selectedMarkerEditor, .selectionInfo, .trackPitch, .volumeControls (+31 more)

### Community 76 - ".hex"
Cohesion: 0.40
Nodes (5): .defaultColor, Int, StandardTrackRole, String, TrackColorPalette

### Community 77 - "TrackHeaderRowView"
Cohesion: 0.25
Nodes (7): Binding, Double, TrackHeaderRowView, .displayColor, .liveTrack, .trackPan, .trackVolumeBinding

### Community 78 - "PinnedTimelineHeaderStrip"
Cohesion: 0.16
Nodes (12): Bool, CGFloat, Content, TimelineHorizontalMirror, .body, TimelineScrollCoordinator, PinnedTimelineHeaderStrip, .body (+4 more)

### Community 79 - "TrackControlButton"
Cohesion: 0.22
Nodes (8): PanKnobView, .body, Bool, Double, String, Void, TrackControlButton, .body

### Community 80 - "Sendable"
Cohesion: 0.33
Nodes (11): Codable, Sendable, LinkSectionCommand, LyricPlaySync, LyricSlideCatalog, LyricSlideCatalogItem, .id, ShowSlideCommand (+3 more)

### Community 81 - "AudioClip"
Cohesion: 0.36
Nodes (7): AudioClip, .endTime, Int, String, TimeInterval, URL, UUID

### Community 82 - "DropURLLoader"
Cohesion: 0.62
Nodes (4): DropURLLoader, NSItemProvider, String, URL

### Community 83 - "IOSPlaybackStrategy"
Cohesion: 0.14
Nodes (9): IOSPlaybackStrategy, .meterTapBufferSize, AVAudioFile, AVAudioFrameCount, AVAudioFramePosition, AVAudioPlayerNode, AVAudioTime, Double (+1 more)

### Community 84 - "SavedProjectDocument"
Cohesion: 0.18
Nodes (8): SavedProjectDocument, DAWProject, Int, Data, ProjectFilePanel, String, URL, .body

### Community 85 - ".loadBucket"
Cohesion: 0.31
Nodes (5): CoreGraphics, CGFloat, Int, WaveformLOD, .requiredLOD

### Community 86 - "SectionPlaybackMode"
Cohesion: 0.15
Nodes (11): CaseIterable, SectionPlaybackMode, continueTimeline, continueToNext, .displayName, .id, oneShot, repeatSection (+3 more)

### Community 87 - "SectionPlaybackStatus"
Cohesion: 0.33
Nodes (5): SectionPlaybackStatus, idle, playing, queued, repeatingAtEnd

### Community 88 - ".groupVolumeBinding"
Cohesion: 0.31
Nodes (5): .masterVolumeBinding, Binding, Double, UUID, .masterVolumeBinding

### Community 89 - "AudioFileStorageService"
Cohesion: 0.43
Nodes (4): AudioFileStorageService, String, URL, UUID

### Community 91 - "ProjectPersistenceError"
Cohesion: 0.22
Nodes (9): JSONDecoder, .projectDecoder, ManifestFile, ProjectPersistenceError, .errorDescription, invalidPackage, missingManifest, Int (+1 more)

### Community 92 - "MIDINoteAssignment"
Cohesion: 0.47
Nodes (5): MIDINoteAssignment, .displayName, Bool, String, UInt8

### Community 93 - "AudioImportError"
Cohesion: 0.33
Nodes (6): AudioImportError, emptySelection, .errorDescription, storageUnavailable, unreadableFile, unsupportedFormat

### Community 94 - "MIDILearnTarget"
Cohesion: 0.50
Nodes (3): MIDILearnTarget, section, UUID

### Community 96 - "Kind"
Cohesion: 0.67
Nodes (3): Kind, controlChange, noteOn

## Knowledge Gaps
- **315 isolated node(s):** `id`, `name`, `startTime`, `endTime`, `colorHex` (+310 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **6 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `WorkspaceViewModel` connect `WorkspaceViewModel` to `SectionMarkerChipView`, `TrackLaneView`, `CGFloat`, `ArrangementSection`, `MixerPanelView`, `TimelineWorkspacePanel`, `TransportBarView`, `PropertiesSidebarView`, `AudioEngineService`, `String`, `MIDIMappingBarView`, `TrackOrganizationService`, `UUID`, `AudioTrack`, `WorkspaceView`, `LyricPlaySyncClient`, `AudioImportService`, `SwiftUI`, `AudioOutputDevice`, `TrackPitchControlView`, `MIDIInputService`, `AudioDropTargetModifier`, `SimplePlayProjectFileDocument`, `.applyAudioSettings`, `TimeInterval`, `Foundation`, `ContentView`, `.body`, `.refreshLyricCatalog`, `View`, `Task`, `.workspaceRoot`, `TopToolbarView`, `ProjectPersistenceService`, `.triggerSection`, `TrackHeaderRowView`, `PinnedTimelineHeaderStrip`, `Sendable`, `SavedProjectDocument`, `SectionPlaybackMode`, `SectionPlaybackStatus`, `.groupVolumeBinding`, `.applyImportedStems`, `MIDILearnTarget`, `.trackMeterLevel`?**
  _High betweenness centrality (0.418) - this node is a cross-community bridge._
- **Why does `AudioEngineService` connect `AudioEngineService` to `MacOSPlaybackStrategy`, `Float`, `UUID`, `WorkspaceViewModel`, `AudioSettings`, `IOSPlaybackStrategy`, `PitchShiftSettings`, `Foundation`, `.applyImportedStems`, `.stop`, `.trackMeterLevel`, `.play`?**
  _High betweenness centrality (0.136) - this node is a cross-community bridge._
- **Why does `ArrangementSection` connect `ArrangementSection` to `DAWProject`, `SectionMarkerChipView`, `WorkspaceViewModel`, `AudioSampleRate`, `.triggerSection`, `.selectedMarkerEditor`, `MIDIInputService`, `Sendable`, `PropertiesSidebarView`, `TimeInterval`, `SectionPlaybackMode`, `MIDIMappingBarView`, `Foundation`, `Equatable`, `SectionPlaybackStatus`, `.refreshLyricCatalog`, `View`, `Task`?**
  _High betweenness centrality (0.115) - this node is a cross-community bridge._
- **Are the 12 inferred relationships involving `WorkspaceViewModel` (e.g. with `ArrangementPlaybackEngine` and `AudioEngineService`) actually correct?**
  _`WorkspaceViewModel` has 12 INFERRED edges - model-reasoned connections that need verification._
- **Are the 2 inferred relationships involving `AudioEngineService` (e.g. with `WorkspaceViewModel` and `.configureAudioEngine()`) actually correct?**
  _`AudioEngineService` has 2 INFERRED edges - model-reasoned connections that need verification._
- **Are the 4 inferred relationships involving `ArrangementSection` (e.g. with `.body` and `.body`) actually correct?**
  _`ArrangementSection` has 4 INFERRED edges - model-reasoned connections that need verification._
- **What connects `id`, `name`, `startTime` to the rest of the system?**
  _315 weakly-connected nodes found - possible documentation gaps or missing edges._