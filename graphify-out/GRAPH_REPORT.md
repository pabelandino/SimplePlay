# Graph Report - SimplePlay  (2026-08-14)

## Corpus Check
- 115 files · ~61,463 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 2111 nodes · 5103 edges · 115 communities (91 shown, 24 thin omitted)
- Extraction: 90% EXTRACTED · 10% INFERRED · 0% AMBIGUOUS · INFERRED: 524 edges (avg confidence: 0.8)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `54ea24ed`
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
- View
- MIDIMappingBarView
- DAWVerticalFaderView
- TrackOrganizationService
- AudioSettings
- Foundation
- AppKit
- SwiftUI
- ProjectPersistenceService
- TopToolbarView
- .body
- CGFloat
- What You Must Do When Invoked
- PitchShiftSettings
- StandardTrackRole
- Equatable
- TransportBarView
- WorkspaceViewModel
- FaderMeterStripView
- TimeInterval
- MacOSPlaybackStrategy
- IOSPlaybackStrategy
- MixerPanelView
- WaveformCache
- UIKitToolbarMenuButtonRepresentable
- .applyImportedStems
- .sectionMappingCard
- TimelineOverviewBar
- Float
- DAWTheme
- .stop
- .standardize
- TrackHeaderRowView
- .applyRestoredProject
- .log
- PropertiesSidebarView
- .play
- .sampleClip
- AudioDeviceID
- LyricPlaySyncClient
- SimplePlay
- .attachClip
- TrackPitchControlView
- .body
- ProjectEditHistory
- .saveProject
- .recordEditSnapshot
- TransportRightToolbar
- WaveformLoadMonitor
- .presentImportPanel
- TimelineView.swift
- AVAudioPlayerNode
- TrackGroup
- .body
- SectionPlaybackMode
- AudioTrack
- Audio Engine — Agent Guide
- Color
- WorkspaceView
- graphify reference: extra exports and benchmark
- ArrangementSection
- WorkspaceSettingsView
- .clipContent
- TimelineHorizontalMirror
- graphify reference: query, path, explain
- AudioClip
- .workspaceRoot
- LyricPlaySyncMessageKind
- .mixerChannelStrip
- MIDINoteAssignment
- graphify reference: add a URL and watch a folder
- graphify reference: commit hook and native AGENTS.md integration
- graphify reference: incremental update and cluster-only
- .importInitial
- graphify reference: GitHub clone and cross-repo merge
- graphify reference: transcribe video and audio
- .lyricSlideLabel
- extraction-spec.md
- .lyricSlideLinkSection
- .updateSectionMIDI
- Sendable
- SectionLyricLinkSheet
- DAWSecondaryButtonStyle
- .sessionManagement
- TrackWaveformProgressBar
- SectionPlaybackStatus
- .setApplicationSceneActive
- Density
- Kind
- TrimEdge
- AudioEngineService
- AVAudioFile
- AVAudioFrameCount
- AVAudioFramePosition
- AVAudioPlayerNode
- Date
- Float
- Set
- Timer
- UInt8
- URL
- Configuration
- NSCursor
- Binding

## God Nodes (most connected - your core abstractions)
1. `WorkspaceViewModel` - 316 edges
2. `DAWProject` - 107 edges
3. `AudioEngineService` - 107 edges
4. `DAWTheme` - 57 edges
5. `MIDIMappingBarView` - 51 edges
6. `ArrangementSection` - 49 edges
7. `AudioTrack` - 44 edges
8. `StandardTrackRole` - 43 edges
9. `ArrangementPlaybackEngine` - 36 edges
10. `MixerPanelView` - 35 edges

## Surprising Connections (you probably didn't know these)
- `TrackOrganizationServiceTests` --calls--> `TrackOrganizationService`  [EXTRACTED]
  SimplePlayTests/TrackOrganizationServiceTests.swift → SimplePlay/Core/Services/TrackOrganizationService.swift
- `WorkspaceViewModel` --calls--> `AudioEngineService`  [INFERRED]
  SimplePlay/Features/Workspace/ViewModels/WorkspaceViewModel.swift → SimplePlay/Core/Services/AudioEngineServiceMacOS.swift
- `WorkspaceViewModel` --calls--> `ProjectEditHistory`  [INFERRED]
  SimplePlay/Features/Workspace/ViewModels/WorkspaceViewModel.swift → SimplePlay/Core/Utils/ProjectEditHistory.swift
- `WorkspaceViewModel` --calls--> `ArrangementPlaybackEngine`  [INFERRED]
  SimplePlay/Features/Workspace/ViewModels/WorkspaceViewModel.swift → SimplePlay/Core/Services/ArrangementPlaybackEngine.swift
- `WorkspaceViewModel` --calls--> `AudioImportService`  [INFERRED]
  SimplePlay/Features/Workspace/ViewModels/WorkspaceViewModel.swift → SimplePlay/Core/Services/AudioImportService.swift

## Import Cycles
- None detected.

## Communities (115 total, 24 thin omitted)

### Community 0 - "ArrangementSection"
Cohesion: 0.06
Nodes (52): ArrangementSection, .color, .duration, .hasLyricSlideLink, CodingKeys, colorHex, endTime, id (+44 more)

### Community 1 - "MIDIInputService"
Cohesion: 0.08
Nodes (24): CoreMIDI, MIDINotifyProc, MIDIPacket, MIDIPacketList, MIDISourceInfo, MIDIInputEvent, MIDIInputService, MIDISourceInfo (+16 more)

### Community 2 - "DAWProject"
Cohesion: 0.22
Nodes (11): DAWProject, Bool, Double, Int32, String, TimeInterval, UInt8, UUID (+3 more)

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
Cohesion: 0.12
Nodes (28): ScrollPosition, PinnedTimelineHeaderStrip, .timeHeaderCell, PlayheadView, .body, .playheadDragGesture, Bool, CGFloat (+20 more)

### Community 7 - "CodingKeys"
Cohesion: 0.08
Nodes (25): CodingKeys, audioSettings, colorHex, id, isLocked, isMuted, isPitchEnabled, isSnapEnabled (+17 more)

### Community 8 - "AudioImportService"
Cohesion: 0.12
Nodes (18): AudioFileStorageService, String, URL, UUID, AudioImportError, emptySelection, .errorDescription, storageUnavailable (+10 more)

### Community 9 - "AudioEngineService"
Cohesion: 0.07
Nodes (21): AVAudioEngine, AVAudioUnitEQ, AudioEnginePlatformServices, AudioEngineService, .avEngine, .engineIsRunning, .isAnyPlayerPlaying, .isMeterMonitoringEnabled (+13 more)

### Community 10 - "SectionMarkerChipView"
Cohesion: 0.07
Nodes (46): NSCursor, Bool, String, TimeInterval, .formattedCurrentTime, .formattedDuration, ResizeEdge, end (+38 more)

### Community 11 - "View"
Cohesion: 0.10
Nodes (39): MIDILearnTarget, Selection, .playbackSettings, .sectionEditor, .selectedMarkerEditor, .selectionInfo, .trackPitch, .volumeControls (+31 more)

### Community 12 - "MIDIMappingBarView"
Cohesion: 0.12
Nodes (18): Animation, AnyTransition, MIDIMappingBarView, .assignModeToggleTitle, .body, .collapsedBar, .collapsedBarContent, .devicePickerLabel (+10 more)

### Community 13 - "DAWVerticalFaderView"
Cohesion: 0.09
Nodes (25): ClosedRange, Double, Float, String, TrackVolumeSettings, .trackRange, DAWVerticalFaderView, .body (+17 more)

### Community 14 - "TrackOrganizationService"
Cohesion: 0.25
Nodes (9): ImportedStem, ImportPlacement, appendNewGroup, insertIntoGroup, Int, String, TimeInterval, URL (+1 more)

### Community 15 - "AudioSettings"
Cohesion: 0.05
Nodes (35): AnyObject, AudioDeviceID, AudioEnginePlatformServices, AudioEngineServiceHost, AudioSettings, AVAudioSession, Double, Hashable (+27 more)

### Community 16 - "Foundation"
Cohesion: 0.09
Nodes (11): AudioUnit, AVFoundation, CoreAudio, CoreGraphics, Foundation, Network, Observation, AudioEnginePlatformServicesFactory (+3 more)

### Community 17 - "AppKit"
Cohesion: 0.09
Nodes (18): AppKit, Notification, NSApplicationDelegate, NSEvent, NSObject, NSView, NSViewRepresentable, NSWindow (+10 more)

### Community 18 - "SwiftUI"
Cohesion: 0.13
Nodes (13): App, Commands, Scene, ContentView, .body, EditCommands, .body, FileCommands (+5 more)

### Community 19 - "ProjectPersistenceService"
Cohesion: 0.06
Nodes (41): LocalizedError, SavedProjectDocument, Int, LyricPlaySyncTransportError, emptyResponse, .errorDescription, noLyrioraHost, unexpectedResponse (+33 more)

### Community 20 - "TopToolbarView"
Cohesion: 0.19
Nodes (13): Bool, String, Void, ToolbarMenuButtonStyleModifier, TopToolbarView, .addTrackMenu, .isCompact, .projectSessionButton (+5 more)

### Community 21 - ".body"
Cohesion: 0.20
Nodes (9): G, ClipDragInteractionModifier, ClipSelectionModifiers, .isExtending, Bool, Content, TrackLaneDropModifier, .body (+1 more)

### Community 22 - "CGFloat"
Cohesion: 0.09
Nodes (11): SectionDragKind, move, resizeEnd, resizeStart, CGFloat, TimelineScrollRequest, .minimumTimelineZoom, .timelineContentWidth (+3 more)

### Community 23 - "What You Must Do When Invoked"
Cohesion: 0.08
Nodes (24): For /graphify add and --watch, For /graphify query, For the commit hook and native AGENTS.md integration, For --update and --cluster-only, /graphify, Honesty Rules, Interpreter guard for subcommands, Part A - Structural extraction for code files (+16 more)

### Community 24 - "PitchShiftSettings"
Cohesion: 0.27
Nodes (5): PitchShiftSettings, AVAudioUnitTimePitch, Double, Float, PitchShiftSettingsTests

### Community 25 - "StandardTrackRole"
Cohesion: 0.08
Nodes (25): StandardTrackRole, acousticGuitar, backingVocal, bass, brass, click, countIn, cue (+17 more)

### Community 26 - "Equatable"
Cohesion: 0.29
Nodes (14): Equatable, PersistedClip, PersistedProject, PersistedTrack, Bool, Decoder, Double, Encoder (+6 more)

### Community 27 - "TransportBarView"
Cohesion: 0.14
Nodes (16): Bool, CGFloat, Color, String, Void, TransportBarStyle, phoneBottomDock, standard (+8 more)

### Community 28 - "WorkspaceViewModel"
Cohesion: 0.05
Nodes (38): AudioClip, AudioOutputDevice, ClipEditService, Date, Float, Set, ClipMovePreview, SectionEdgeGuides (+30 more)

### Community 29 - "FaderMeterStripView"
Cohesion: 0.17
Nodes (11): .projectMasterStrip, FaderMeterStripView, .reservesThumbClearance, .showsUnityMark, .usesUnityCenterDecibelScale, Bool, CGFloat, ClosedRange (+3 more)

### Community 30 - "TimeInterval"
Cohesion: 0.11
Nodes (12): SectionLoopContext, SectionPlaybackMode, ArrangementSection, Bool, ClosedRange, TimeInterval, TimelineScrollAlignment, center (+4 more)

### Community 31 - "MacOSPlaybackStrategy"
Cohesion: 0.13
Nodes (14): AVAudioFile, AVAudioFrameCount, AVAudioFramePosition, AVAudioPlayerNode, PlatformPlaybackStrategy, AudioEngineService, AVAudioTime, TimeInterval (+6 more)

### Community 32 - "IOSPlaybackStrategy"
Cohesion: 0.19
Nodes (11): IOSPlaybackStrategy, .meterTapBufferSize, AudioEngineService, AVAudioFile, AVAudioFrameCount, AVAudioFramePosition, AVAudioPlayerNode, AVAudioTime (+3 more)

### Community 33 - "MixerPanelView"
Cohesion: 0.09
Nodes (24): MixerPanelView, .body, .channelFaderHeight, .channelFaderWidth, .channelStripWidth, .groupDivider, .isCompact, .masterFaderHeight (+16 more)

### Community 34 - "WaveformCache"
Cohesion: 0.22
Nodes (15): AVAudioPCMBuffer, CheckedContinuation, Bool, Double, Float, Int, MainActor, Never (+7 more)

### Community 35 - "UIKitToolbarMenuButtonRepresentable"
Cohesion: 0.33
Nodes (7): Coordinator, Context, String, Void, UIKitToolbarMenuButtonRepresentable, UIButton, UIViewRepresentable

### Community 36 - ".applyImportedStems"
Cohesion: 0.18
Nodes (5): Bool, TimeInterval, String, TrackOrganizationService, URL

### Community 37 - ".sectionMappingCard"
Cohesion: 0.22
Nodes (6): Configuration, MIDINoteAssignment, SectionMappingAssignButtonStyle, SectionMappingCardGlow, SectionMappingPlayButtonStyle, Content

### Community 38 - "TimelineOverviewBar"
Cohesion: 0.11
Nodes (21): Path, Bool, CGFloat, CGSize, ClosedRange, Gesture, TimeInterval, TimelineOverviewBar (+13 more)

### Community 39 - "Float"
Cohesion: 0.24
Nodes (5): AVAudioMixerNode, MeterPeakBuffer, Float, UUID, Void

### Community 40 - "DAWTheme"
Cohesion: 0.12
Nodes (17): Glass, .markerHeaderRow, DAWGlassChrome, .controlGlass, .panelGlass, CGFloat, Double, LinearGradient (+9 more)

### Community 42 - ".standardize"
Cohesion: 0.20
Nodes (7): StandardizedName, Bool, Int, String, URL, TrackNameStandardizer, TrackNameStandardizerTests

### Community 43 - "TrackHeaderRowView"
Cohesion: 0.14
Nodes (17): Binding, Bool, CGFloat, Double, TrackHeaderRowView, .body, .compactLayout, .density (+9 more)

### Community 45 - ".log"
Cohesion: 0.12
Nodes (16): os, SectionLoopDiagnostics, SectionTriggerDiagnostics, AVAudioFrameCount, Bool, Double, Int64, String (+8 more)

### Community 46 - "PropertiesSidebarView"
Cohesion: 0.11
Nodes (18): .masterVolumeBinding, PropertiesSidebarView, .body, .masterVolumeBinding, .pitchIsOriginal, .pitchLabel, .sectionCreationHint, .selectedDevice (+10 more)

### Community 47 - ".play"
Cohesion: 0.12
Nodes (12): SectionLoopContext, .duration, TimeInterval, UUID, AVAudioFrameCount, Bool, Int, Int64 (+4 more)

### Community 48 - ".sampleClip"
Cohesion: 0.26
Nodes (4): ClipEditService, TimeInterval, ClipEditServiceTests, TimeInterval

### Community 50 - "LyricPlaySyncClient"
Cohesion: 0.14
Nodes (14): NWBrowser, NWEndpoint, ConnectionState, connected, failed, idle, searching, LyricPlaySyncClient (+6 more)

### Community 51 - "SimplePlay"
Cohesion: 0.21
Nodes (4): SimplePlay, ProjectArchiveTests, SimplePlayTests, Testing

### Community 52 - ".attachClip"
Cohesion: 0.13
Nodes (13): groups, AudioEngineError, clipLoadFailed, deviceSelectionFailed, engineStartFailed, .errorDescription, noPlayableClips, playbackUnavailable (+5 more)

### Community 53 - "TrackPitchControlView"
Cohesion: 0.14
Nodes (14): .selectedTrackPitchBinding, .actionButtons, Binding, Bool, Double, String, UUID, TrackPitchControlView (+6 more)

### Community 54 - ".body"
Cohesion: 0.22
Nodes (7): .body, .trackHeaderColumnTracksOnly, AudioDropOverlay, .body, String, TimelineEmptyDropHint, .body

### Community 55 - "ProjectEditHistory"
Cohesion: 0.10
Nodes (13): ProjectEditHistory, .canRedo, .canUndo, Bool, DAWProject, Int, ProjectEditHistoryTests, SimplePlayUITests (+5 more)

### Community 56 - ".saveProject"
Cohesion: 0.18
Nodes (8): SavedProjectDocument, ProjectFilePanel, String, URL, .body, .openButton, .saveButton, SimplePlayProjectFileDocument

### Community 57 - ".recordEditSnapshot"
Cohesion: 0.19
Nodes (3): AudioTrack, .mixerScrollWithPinnedMasters, .pitchMenu

### Community 58 - "TransportRightToolbar"
Cohesion: 0.06
Nodes (35): Binding, Double, Bool, CGFloat, Double, String, Void, TimelineScaleControls (+27 more)

### Community 59 - "WaveformLoadMonitor"
Cohesion: 0.40
Nodes (5): clips, Bool, Double, UUID, WaveformLoadMonitor

### Community 60 - ".presentImportPanel"
Cohesion: 0.18
Nodes (8): ImportPanelKind, audioFiles, folder, .importButton, .importMenuItems, ImportToolbarMenuButton, .body, UIKit

### Community 61 - "TimelineView.swift"
Cohesion: 0.23
Nodes (10): GraphicsContext, .body, CGSize, NSCursor, TimeInterval, Void, TimelineRulerTicksView, TimelineRulerView (+2 more)

### Community 62 - "AVAudioPlayerNode"
Cohesion: 0.36
Nodes (3): AVAudioFramePosition, AVAudioPlayerNode, AVAudioTime

### Community 63 - "TrackGroup"
Cohesion: 0.14
Nodes (16): CodingKey, CodingKeys, horizontalOffset, id, importedAt, name, pitchSemitones, volume (+8 more)

### Community 64 - ".body"
Cohesion: 0.21
Nodes (6): Content, View, View, WorkspaceKeyboardShortcuts, .historyControls, .timeDisplay

### Community 65 - "SectionPlaybackMode"
Cohesion: 0.13
Nodes (13): CaseIterable, SectionPlaybackMode, continueTimeline, continueToNext, .displayName, .id, oneShot, repeatSection (+5 more)

### Community 66 - "AudioTrack"
Cohesion: 0.21
Nodes (12): Identifiable, AudioTrack, .color, .displayName, Bool, Double, String, UUID (+4 more)

### Community 67 - "Audio Engine — Agent Guide"
Cohesion: 0.20
Nodes (9): Architecture (do not collapse), Audio Engine — Agent Guide, Before you edit, iOS session rules (critical), Log messages, macOS device rules, Red flags (stop and reconsider), Safe change map (+1 more)

### Community 68 - "Color"
Cohesion: 0.28
Nodes (5): .defaultColor, Color, Int, String, TrackColorPalette

### Community 69 - "WorkspaceView"
Cohesion: 0.22
Nodes (10): ScenePhase, Binding, Bool, String, WorkspaceLifecycleModifier, WorkspaceView, .body, .deleteSectionDialogTitle (+2 more)

### Community 70 - "graphify reference: extra exports and benchmark"
Cohesion: 0.22
Nodes (8): graphify reference: extra exports and benchmark, Step 6b - Wiki (only if --wiki flag), Step 7 - Neo4j export (only if --neo4j or --neo4j-push flag), Step 7a - FalkorDB export (only if --falkordb or --falkordb-push flag), Step 7b - SVG export (only if --svg flag), Step 7c - GraphML export (only if --graphml flag), Step 7d - MCP server (only if --mcp flag), Step 8 - Token reduction benchmark (only if total_words > 5000)

### Community 71 - "ArrangementSection"
Cohesion: 0.23
Nodes (4): .sectionQuickPads, ArrangementSection, Color, String

### Community 72 - "WorkspaceSettingsView"
Cohesion: 0.28
Nodes (7): Binding, Bool, String, WorkspaceSettingsView, .body, .deleteSectionDialogTitle, .sectionDeletionDialogBinding

### Community 73 - ".clipContent"
Cohesion: 0.27
Nodes (11): ClipSplitOverlay, .body, .clipWidth, ClipTrimHandle, .handleHitWidth, CGFloat, Gesture, UUID (+3 more)

### Community 74 - "TimelineHorizontalMirror"
Cohesion: 0.24
Nodes (7): Bool, CGFloat, Content, TimelineHorizontalMirror, .body, TimelineScrollCoordinator, .body

### Community 75 - "graphify reference: query, path, explain"
Cohesion: 0.33
Nodes (5): For /graphify explain, For /graphify path, graphify reference: query, path, explain, Step 0 — Constrained query expansion (REQUIRED before traversal), Step 1 — Traversal

### Community 76 - "AudioClip"
Cohesion: 0.36
Nodes (7): AudioClip, .endTime, Int, String, TimeInterval, URL, UUID

### Community 77 - ".workspaceRoot"
Cohesion: 0.28
Nodes (3): Error, Result, .workspaceRoot

### Community 78 - "LyricPlaySyncMessageKind"
Cohesion: 0.22
Nodes (9): LyricPlaySyncMessageKind, catalogRequest, catalogResponse, error, linkSection, linkSectionAck, presence, presenceAck (+1 more)

### Community 79 - ".mixerChannelStrip"
Cohesion: 0.18
Nodes (8): PanKnobView, .body, Bool, Double, String, Void, TrackControlButton, .body

### Community 80 - "MIDINoteAssignment"
Cohesion: 0.24
Nodes (8): MIDILearnTarget, section, MIDINoteAssignment, .displayName, Bool, String, UInt8, UUID

### Community 81 - "graphify reference: add a URL and watch a folder"
Cohesion: 0.50
Nodes (3): For /graphify add, For --watch, graphify reference: add a URL and watch a folder

### Community 82 - "graphify reference: commit hook and native AGENTS.md integration"
Cohesion: 0.50
Nodes (3): For git commit hook, For native AGENTS.md integration, graphify reference: commit hook and native AGENTS.md integration

### Community 83 - "graphify reference: incremental update and cluster-only"
Cohesion: 0.50
Nodes (3): For --cluster-only, For --update (incremental re-extraction), graphify reference: incremental update and cluster-only

### Community 84 - ".importInitial"
Cohesion: 0.21
Nodes (6): Int, String, TimeInterval, String, TimeInterval, TrackOrganizationServiceTests

### Community 89 - ".lyricSlideLinkSection"
Cohesion: 0.25
Nodes (4): .assignModeToggle, .expandedPanel, .learnBanner, .lyricCatalogStatus

### Community 91 - "Sendable"
Cohesion: 0.18
Nodes (16): Codable, Sendable, serverError, LinkSectionCommand, LyricPlaySync, LyricPlaySyncCodec, LyricPlaySyncMessage, LyricSlideCatalog (+8 more)

### Community 93 - "DAWSecondaryButtonStyle"
Cohesion: 0.18
Nodes (11): ButtonStyle, .mappingRefreshControl, .unavailableState, DAWIconToolbarButtonStyle, DAWLabeledToolbarButtonStyle, DAWPrimaryButtonStyle, DAWSecondaryButtonStyle, Configuration (+3 more)

### Community 94 - ".sessionManagement"
Cohesion: 0.60
Nodes (3): .sessionManagement, .projectSessionMenuItems, .body

### Community 95 - "TrackWaveformProgressBar"
Cohesion: 0.40
Nodes (4): Bool, Double, TrackWaveformProgressBar, .body

### Community 96 - "SectionPlaybackStatus"
Cohesion: 0.40
Nodes (5): SectionPlaybackStatus, idle, playing, queued, repeatingAtEnd

### Community 98 - "Density"
Cohesion: 0.50
Nodes (4): Density, compact, full, minimal

### Community 99 - "Kind"
Cohesion: 0.67
Nodes (3): Kind, controlChange, noteOn

### Community 100 - "TrimEdge"
Cohesion: 0.67
Nodes (3): TrimEdge, end, start

## Knowledge Gaps
- **358 isolated node(s):** `AudioUnit`, `.meterTapBufferSize`, `.canUndo`, `.canRedo`, `audioFiles` (+353 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **24 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `WorkspaceViewModel` connect `WorkspaceViewModel` to `ArrangementSection`, `MIDIInputService`, `DAWProject`, `SupportedAudioFormats`, `TimelineWorkspacePanel`, `AudioImportService`, `SectionMarkerChipView`, `View`, `MIDIMappingBarView`, `AudioSettings`, `Foundation`, `AppKit`, `SwiftUI`, `ProjectPersistenceService`, `TopToolbarView`, `.body`, `CGFloat`, `TransportBarView`, `TimeInterval`, `MacOSPlaybackStrategy`, `MixerPanelView`, `.applyImportedStems`, `.sectionMappingCard`, `TimelineOverviewBar`, `TrackHeaderRowView`, `.applyRestoredProject`, `.log`, `PropertiesSidebarView`, `.sampleClip`, `LyricPlaySyncClient`, `TrackPitchControlView`, `.body`, `ProjectEditHistory`, `.saveProject`, `.recordEditSnapshot`, `TransportRightToolbar`, `.presentImportPanel`, `.body`, `Color`, `WorkspaceView`, `ArrangementSection`, `WorkspaceSettingsView`, `.clipContent`, `.workspaceRoot`, `.mixerChannelStrip`, `.lyricSlideLabel`, `.lyricSlideLinkSection`, `.updateSectionMIDI`, `Sendable`, `SectionLyricLinkSheet`, `.sessionManagement`, `SectionPlaybackStatus`, `.setApplicationSceneActive`?**
  _High betweenness centrality (0.375) - this node is a cross-community bridge._
- **Why does `DAWProject` connect `DAWProject` to `ArrangementSection`, `AudioEngineService`, `View`, `TrackOrganizationService`, `AudioSettings`, `Foundation`, `ProjectPersistenceService`, `CGFloat`, `Equatable`, `WorkspaceViewModel`, `TimeInterval`, `.applyImportedStems`, `TrackHeaderRowView`, `.applyRestoredProject`, `PropertiesSidebarView`, `.play`, `.attachClip`, `TrackPitchControlView`, `ProjectEditHistory`, `.recordEditSnapshot`, `TransportRightToolbar`, `TrackGroup`, `.body`, `AudioTrack`, `Color`, `.workspaceRoot`, `.mixerChannelStrip`, `.importInitial`, `.updateSectionMIDI`, `Sendable`, `SectionLyricLinkSheet`?**
  _High betweenness centrality (0.099) - this node is a cross-community bridge._
- **Why does `AudioEngineService` connect `AudioEngineService` to `Float`, `.stop`, `AudioSettings`, `.play`, `.attachClip`, `AVAudioPlayerNode`?**
  _High betweenness centrality (0.084) - this node is a cross-community bridge._
- **Are the 12 inferred relationships involving `WorkspaceViewModel` (e.g. with `ArrangementPlaybackEngine` and `AudioEngineService`) actually correct?**
  _`WorkspaceViewModel` has 12 INFERRED edges - model-reasoned connections that need verification._
- **Are the 58 inferred relationships involving `DAWProject` (e.g. with `.clear()` and `.recordSnapshot()`) actually correct?**
  _`DAWProject` has 58 INFERRED edges - model-reasoned connections that need verification._
- **What connects `AudioUnit`, `.meterTapBufferSize`, `.canUndo` to the rest of the system?**
  _358 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `ArrangementSection` be split into smaller, more focused modules?**
  _Cohesion score 0.05541368743615935 - nodes in this community are weakly interconnected._