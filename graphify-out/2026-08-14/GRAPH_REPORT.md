# Graph Report - SimplePlay  (2026-08-14)

## Corpus Check
- 123 files · ~64,683 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 2176 nodes · 5361 edges · 105 communities (99 shown, 6 thin omitted)
- Extraction: 89% EXTRACTED · 11% INFERRED · 0% AMBIGUOUS · INFERRED: 586 edges (avg confidence: 0.8)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `c3d252ac`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- ArrangementPlaybackEngine
- MIDIInputService
- DAWProject
- SupportedAudioFormats
- WaveformClipView
- MacOSPlaybackStrategy
- TimelineWorkspacePanel
- CodingKeys
- AudioImportService
- AudioEngineService
- SectionMarkerChipView
- PropertiesSidebarView
- MIDIMappingBarView
- DAWVerticalFaderView
- TrackOrganizationService
- AudioSettings
- Foundation
- .body
- SwiftUI
- SimplePlayProjectArchive
- TopToolbarView
- TimelineScaleControls
- WorkspaceViewModel
- What You Must Do When Invoked
- PitchShiftSettings
- StandardTrackRole
- Equatable
- .track
- .recordEditSnapshot
- FaderMeterStripView
- TimeInterval
- IOSPlaybackStrategy
- TimelineView.swift
- MixerPanelView
- WaveformCache
- UIKitToolbarMenuButtonRepresentable
- .importAudioFiles
- .majorTickInterval
- TimelineOverviewBar
- Float
- DAWGlassChrome
- .stop
- .standardize
- TrackHeaderRowView
- .log
- iPhoneTimelinePanel
- .play
- ClipEditService
- SavedProjectDocument
- LyricPlaySyncClient
- SimplePlay
- LyricPlaySyncTransportError
- TrackPitchControlView
- ProjectPersistenceService
- SimplePlayUITests
- CGFloat
- .clipContent
- TransportRightToolbar
- .frames
- SingleLaneTrackHeaderCell
- .presentImportPanel
- AudioEngineError
- TrackGroup
- TransportBarView
- SectionPlaybackMode
- AudioTrack
- Audio Engine — Agent Guide
- ViewModifier
- WorkspaceLayoutContext
- graphify reference: extra exports and benchmark
- View
- ProjectPersistenceError
- AudioClip
- WaveformLoadMonitor
- graphify reference: query, path, explain
- LyricPlaySyncCodec
- SectionPlaybackStatus
- LyricPlaySyncMessageKind
- WorkspaceSettingsView
- .attachClip
- graphify reference: add a URL and watch a folder
- graphify reference: commit hook and native AGENTS.md integration
- graphify reference: incremental update and cluster-only
- TrackWaveformProgressBar
- graphify reference: GitHub clone and cross-repo merge
- graphify reference: transcribe video and audio
- Density
- extraction-spec.md
- MIDINoteAssignment
- AudioEngineService
- Sendable
- ArrangementSection
- .refreshLyricCatalog
- TransportBarStyle
- Panel
- TrimEdge
- .body
- PinnedTimelineHeaderStrip
- .body
- Double
- .mixerChannelStrip
- TrackControlButton
- WorkspacePresentationModifier
- .setApplicationSceneActive

## God Nodes (most connected - your core abstractions)
1. `WorkspaceViewModel` - 334 edges
2. `DAWProject` - 114 edges
3. `AudioEngineService` - 107 edges
4. `ArrangementSection` - 73 edges
5. `DAWTheme` - 64 edges
6. `MIDIMappingBarView` - 55 edges
7. `AudioTrack` - 49 edges
8. `StandardTrackRole` - 43 edges
9. `ArrangementPlaybackEngine` - 36 edges
10. `MixerPanelView` - 36 edges

## Surprising Connections (you probably didn't know these)
- `.collapsedBar` --references--> `WorkspaceViewModel`  [INFERRED]
  SimplePlay/Features/Workspace/Views/iPhoneMIDIMappingBarView.swift → SimplePlay/Features/Workspace/ViewModels/WorkspaceViewModel.swift
- `.body` --calls--> `TrackLaneView`  [INFERRED]
  SimplePlay/Features/Workspace/Views/iPhoneTimelinePanel.swift → SimplePlay/Features/Workspace/Views/TimelineView.swift
- `.phoneRightControls` --calls--> `TransportRightToolbar`  [INFERRED]
  SimplePlay/Features/Workspace/Views/TransportBarView.swift → SimplePlay/Features/Workspace/Views/TransportRightToolbar.swift
- `.body` --calls--> `WorkspaceView`  [INFERRED]
  SimplePlay/ContentView.swift → SimplePlay/Features/Workspace/Views/WorkspaceView.swift
- `.body` --references--> `ArrangementSection`  [INFERRED]
  SimplePlay/Features/Workspace/Views/SectionMarkerLaneView.swift → SimplePlay/Core/Models/ArrangementSection.swift

## Import Cycles
- None detected.

## Communities (105 total, 6 thin omitted)

### Community 0 - "ArrangementPlaybackEngine"
Cohesion: 0.13
Nodes (19): ArrangementPlaybackEngine, PlaybackState, continuingTimeline, idle, playingSection, repeatingSectionAtEnd, waitingToJump, SectionTriggerResult (+11 more)

### Community 1 - "MIDIInputService"
Cohesion: 0.07
Nodes (28): CoreMIDI, MIDINotifyProc, MIDIPacket, MIDIPacketList, Kind, controlChange, noteOn, MIDIInputEvent (+20 more)

### Community 2 - "DAWProject"
Cohesion: 0.14
Nodes (16): DAWProject, Bool, Double, Int32, String, TimeInterval, UInt8, UUID (+8 more)

### Community 3 - "SupportedAudioFormats"
Cohesion: 0.06
Nodes (37): FileDocument, FileWrapper, ReadConfiguration, SimplePlayProjectFileDocument, .readableContentTypes, Data, DropURLLoader, NSItemProvider (+29 more)

### Community 4 - "WaveformClipView"
Cohesion: 0.09
Nodes (28): Float, Int, TimeInterval, URL, WaveformClipPeakStore, CGFloat, Float, Int (+20 more)

### Community 5 - "MacOSPlaybackStrategy"
Cohesion: 0.19
Nodes (11): MacOSPlaybackStrategy, .meterTapBufferSize, AudioEngineService, AVAudioFile, AVAudioFrameCount, AVAudioFramePosition, AVAudioPlayerNode, AVAudioTime (+3 more)

### Community 6 - "TimelineWorkspacePanel"
Cohesion: 0.19
Nodes (19): ScrollPosition, PlayheadView, .body, .playheadDragGesture, CGFloat, Double, Gesture, String (+11 more)

### Community 7 - "CodingKeys"
Cohesion: 0.08
Nodes (25): CodingKeys, audioSettings, colorHex, id, isLocked, isMuted, isPitchEnabled, isSnapEnabled (+17 more)

### Community 8 - "AudioImportService"
Cohesion: 0.12
Nodes (18): AudioFileStorageService, String, URL, UUID, AudioImportError, emptySelection, .errorDescription, storageUnavailable (+10 more)

### Community 9 - "AudioEngineService"
Cohesion: 0.06
Nodes (22): AVAudioEngine, AudioEngineService, .avEngine, .engineIsRunning, .isAnyPlayerPlaying, .isMeterMonitoringEnabled, .isPlaybackGraphReady, .isSamplePlaybackClockEstablished (+14 more)

### Community 10 - "SectionMarkerChipView"
Cohesion: 0.05
Nodes (54): sections, SectionMarkerPalette, .palette, Int, Set, String, Bool, String (+46 more)

### Community 11 - "PropertiesSidebarView"
Cohesion: 0.07
Nodes (52): Selection, PropertiesSidebarView, .audioSettings, .body, .pitchIsOriginal, .pitchLabel, .playbackSettings, .sectionCreationHint (+44 more)

### Community 12 - "MIDIMappingBarView"
Cohesion: 0.08
Nodes (27): Animation, AnyTransition, Color, MIDIMappingBarView, .assignModeToggleTitle, .body, .collapsedBar, .collapsedBarContent (+19 more)

### Community 13 - "DAWVerticalFaderView"
Cohesion: 0.08
Nodes (25): ClosedRange, Double, Float, String, TrackVolumeSettings, .trackRange, DAWVerticalFaderView, .body (+17 more)

### Community 14 - "TrackOrganizationService"
Cohesion: 0.15
Nodes (14): ImportedStem, ImportPlacement, appendNewGroup, insertIntoGroup, Int, String, TimeInterval, URL (+6 more)

### Community 15 - "AudioSettings"
Cohesion: 0.06
Nodes (32): AnyObject, AVAudioSession, Double, Hashable, AudioOutputDevice, AudioSampleRate, .displayName, .id (+24 more)

### Community 16 - "Foundation"
Cohesion: 0.11
Nodes (9): AudioUnit, AVFoundation, CoreAudio, CoreGraphics, Foundation, Observation, os, SnapGrid (+1 more)

### Community 17 - ".body"
Cohesion: 0.11
Nodes (16): Notification, NSApplicationDelegate, NSEvent, NSObject, NSView, NSViewRepresentable, NSWindow, .body (+8 more)

### Community 18 - "SwiftUI"
Cohesion: 0.17
Nodes (7): App, AppKit, Scene, SimplePlayApp, ResizablePropertiesSidebar, .body, SwiftUI

### Community 19 - "SimplePlayProjectArchive"
Cohesion: 0.16
Nodes (15): Asset, SimplePlayProjectArchive, SimplePlayProjectArchiveError, corruptAsset, corruptManifest, .errorDescription, invalidArchive, Bool (+7 more)

### Community 20 - "TopToolbarView"
Cohesion: 0.08
Nodes (30): ButtonStyle, SectionMappingPlayButtonStyle, DAWIconToolbarButtonStyle, DAWLabeledToolbarButtonStyle, DAWPrimaryButtonStyle, Bool, Content, String (+22 more)

### Community 21 - "TimelineScaleControls"
Cohesion: 0.16
Nodes (11): Bool, CGFloat, Double, String, Void, TimelineScaleControls, .buttonCornerRadius, .buttonSize (+3 more)

### Community 22 - "WorkspaceViewModel"
Cohesion: 0.05
Nodes (39): ClipMovePreview, SectionEdgeGuides, Date, Float, Int, Set, Timer, UInt8 (+31 more)

### Community 23 - "What You Must Do When Invoked"
Cohesion: 0.08
Nodes (24): For /graphify add and --watch, For /graphify query, For the commit hook and native AGENTS.md integration, For --update and --cluster-only, /graphify, Honesty Rules, Interpreter guard for subcommands, Part A - Structural extraction for code files (+16 more)

### Community 24 - "PitchShiftSettings"
Cohesion: 0.24
Nodes (6): PitchShiftSettings, AVAudioUnitTimePitch, Bool, Double, Float, PitchShiftSettingsTests

### Community 25 - "StandardTrackRole"
Cohesion: 0.07
Nodes (29): StandardTrackRole, acousticGuitar, backingVocal, bass, brass, click, countIn, cue (+21 more)

### Community 26 - "Equatable"
Cohesion: 0.28
Nodes (14): Equatable, PersistedClip, PersistedProject, PersistedTrack, Bool, Decoder, Double, Encoder (+6 more)

### Community 27 - ".track"
Cohesion: 0.21
Nodes (4): groups, Int, UUID, .activePitchTrack

### Community 28 - ".recordEditSnapshot"
Cohesion: 0.13
Nodes (8): .body, .mixerScrollWithPinnedMasters, .selectedDeviceID, .selectedSectionNameBinding, .selectedTrackIDBinding, .selectedTrackPitchBinding, Binding, .pitchMenu

### Community 29 - "FaderMeterStripView"
Cohesion: 0.12
Nodes (13): .mastersStripRow, .projectMasterStrip, String, FaderMeterStripView, .reservesThumbClearance, .showsUnityMark, .usesUnityCenterDecibelScale, Bool (+5 more)

### Community 30 - "TimeInterval"
Cohesion: 0.17
Nodes (7): Bool, TimeInterval, TimelineScrollAlignment, center, leading, start, .transportControls

### Community 31 - "IOSPlaybackStrategy"
Cohesion: 0.19
Nodes (11): IOSPlaybackStrategy, .meterTapBufferSize, AudioEngineService, AVAudioFile, AVAudioFrameCount, AVAudioFramePosition, AVAudioPlayerNode, AVAudioTime (+3 more)

### Community 32 - "TimelineView.swift"
Cohesion: 0.23
Nodes (10): GraphicsContext, .body, CGSize, NSCursor, TimeInterval, Void, TimelineRulerTicksView, TimelineRulerView (+2 more)

### Community 33 - "MixerPanelView"
Cohesion: 0.11
Nodes (19): MixerPanelView, .body, .channelFaderHeight, .channelFaderWidth, .channelStripWidth, .groupDivider, .isCompact, .masterFaderHeight (+11 more)

### Community 34 - "WaveformCache"
Cohesion: 0.23
Nodes (14): CheckedContinuation, Bool, Double, Float, Int, MainActor, Never, Sendable (+6 more)

### Community 35 - "UIKitToolbarMenuButtonRepresentable"
Cohesion: 0.33
Nodes (7): Coordinator, Context, String, Void, UIKitToolbarMenuButtonRepresentable, UIButton, UIViewRepresentable

### Community 36 - ".importAudioFiles"
Cohesion: 0.11
Nodes (9): Error, Result, Bool, TimeInterval, String, URL, .trackHeaderActions, Content (+1 more)

### Community 37 - ".majorTickInterval"
Cohesion: 0.27
Nodes (6): CGFloat, String, TimeInterval, TimelineRulerScale, .body, TimelineRulerScaleTests

### Community 38 - "TimelineOverviewBar"
Cohesion: 0.11
Nodes (20): Path, Bool, CGFloat, CGSize, ClosedRange, Gesture, TimeInterval, TimelineOverviewBar (+12 more)

### Community 39 - "Float"
Cohesion: 0.35
Nodes (3): MeterPeakBuffer, Float, UUID

### Community 40 - "DAWGlassChrome"
Cohesion: 0.17
Nodes (10): Glass, DAWGlassChrome, .controlGlass, .panelGlass, CGFloat, Double, LinearGradient, View (+2 more)

### Community 42 - ".standardize"
Cohesion: 0.22
Nodes (7): StandardizedName, Bool, Int, String, URL, TrackNameStandardizer, TrackNameStandardizerTests

### Community 43 - "TrackHeaderRowView"
Cohesion: 0.13
Nodes (18): Bool, Binding, Bool, CGFloat, Double, TrackHeaderRowView, .body, .compactLayout (+10 more)

### Community 45 - ".log"
Cohesion: 0.25
Nodes (9): SectionLoopDiagnostics, SectionTriggerDiagnostics, AVAudioFrameCount, Bool, Double, Int64, String, TimeInterval (+1 more)

### Community 46 - "iPhoneTimelinePanel"
Cohesion: 0.11
Nodes (20): iPhoneSectionsLabelHeaderCell, .body, iPhoneTimelinePanel, .body, .laneAreaHeight, .magnificationGesture, .phonePinnedHeader, .phoneTrackHeaderColumn (+12 more)

### Community 47 - ".play"
Cohesion: 0.15
Nodes (13): SectionLoopContext, .duration, TimeInterval, UUID, AVAudioFrameCount, AVAudioTime, Bool, Int (+5 more)

### Community 48 - "ClipEditService"
Cohesion: 0.26
Nodes (4): ClipEditService, TimeInterval, ClipEditServiceTests, TimeInterval

### Community 49 - "SavedProjectDocument"
Cohesion: 0.36
Nodes (3): SavedProjectDocument, Int, Data

### Community 50 - "LyricPlaySyncClient"
Cohesion: 0.18
Nodes (9): NWBrowser, NWEndpoint, LyricPlaySyncClient, serverError, Never, Set, TimeInterval, Void (+1 more)

### Community 51 - "SimplePlay"
Cohesion: 0.21
Nodes (4): SimplePlay, ProjectArchiveTests, SimplePlayTests, Testing

### Community 52 - "LyricPlaySyncTransportError"
Cohesion: 0.14
Nodes (13): LocalizedError, Network, ConnectionState, connected, failed, idle, searching, LyricPlaySyncTransportError (+5 more)

### Community 53 - "TrackPitchControlView"
Cohesion: 0.16
Nodes (13): .actionButtons, Binding, Bool, Double, String, UUID, TrackPitchControlView, .menuTitle (+5 more)

### Community 54 - "ProjectPersistenceService"
Cohesion: 0.33
Nodes (5): unsupportedVersion, ProjectPersistenceService, Bool, URL, UUID

### Community 55 - "SimplePlayUITests"
Cohesion: 0.14
Nodes (6): SimplePlayUITests, SimplePlayUITestsLaunchTests, .runsForEachTargetApplicationUIConfiguration, Bool, XCTest, XCTestCase

### Community 56 - "CGFloat"
Cohesion: 0.08
Nodes (12): SectionDragKind, move, resizeEnd, resizeStart, CGFloat, ClosedRange, TimelineScrollRequest, .minimumTimelineZoom (+4 more)

### Community 57 - ".clipContent"
Cohesion: 0.27
Nodes (11): ClipSplitOverlay, .body, .clipWidth, ClipTrimHandle, .handleHitWidth, CGFloat, Gesture, UUID (+3 more)

### Community 58 - "TransportRightToolbar"
Cohesion: 0.15
Nodes (17): .body, Binding, Bool, CGFloat, Double, String, Void, TransportRightToolbar (+9 more)

### Community 59 - ".frames"
Cohesion: 0.27
Nodes (6): Bool, Double, Int64, TimeInterval, TimelineSampleGrid, TimelineSampleGridTests

### Community 60 - "SingleLaneTrackHeaderCell"
Cohesion: 0.23
Nodes (11): SingleLaneMarkerHeaderCell, .body, SingleLaneStackedClipsLane, .body, SingleLaneTimelineViews, SingleLaneTrackHeaderCell, .body, Bool (+3 more)

### Community 61 - ".presentImportPanel"
Cohesion: 0.19
Nodes (8): ProjectFilePanel, String, URL, .body, ImportPanelKind, audioFiles, folder, .importMenuItems

### Community 62 - "AudioEngineError"
Cohesion: 0.29
Nodes (7): AudioEngineError, clipLoadFailed, deviceSelectionFailed, engineStartFailed, .errorDescription, noPlayableClips, playbackUnavailable

### Community 63 - "TrackGroup"
Cohesion: 0.14
Nodes (16): CodingKey, CodingKeys, horizontalOffset, id, importedAt, name, pitchSemitones, volume (+8 more)

### Community 64 - "TransportBarView"
Cohesion: 0.15
Nodes (15): Bool, CGFloat, String, Void, TransportBarView, .body, .isCompact, .loopButtonColor (+7 more)

### Community 65 - "SectionPlaybackMode"
Cohesion: 0.13
Nodes (13): CaseIterable, SectionPlaybackMode, continueTimeline, continueToNext, .displayName, .id, oneShot, repeatSection (+5 more)

### Community 66 - "AudioTrack"
Cohesion: 0.21
Nodes (12): Identifiable, AudioTrack, .color, .displayName, Bool, Double, String, UUID (+4 more)

### Community 67 - "Audio Engine — Agent Guide"
Cohesion: 0.20
Nodes (9): Architecture (do not collapse), Audio Engine — Agent Guide, Before you edit, iOS session rules (critical), Log messages, macOS device rules, Red flags (stop and reconsider), Safe change map (+1 more)

### Community 68 - "ViewModifier"
Cohesion: 0.20
Nodes (9): G, ClipDragInteractionModifier, ClipSelectionModifiers, .isExtending, Bool, Content, TrackLaneDropModifier, .body (+1 more)

### Community 69 - "WorkspaceLayoutContext"
Cohesion: 0.10
Nodes (20): EnvironmentKey, iPhoneWorkspaceView, .body, .phoneLayout, StandardWorkspaceView, .workspaceLayout, EnvironmentValues, .workspaceLayout (+12 more)

### Community 70 - "graphify reference: extra exports and benchmark"
Cohesion: 0.22
Nodes (8): graphify reference: extra exports and benchmark, Step 6b - Wiki (only if --wiki flag), Step 7 - Neo4j export (only if --neo4j or --neo4j-push flag), Step 7a - FalkorDB export (only if --falkordb or --falkordb-push flag), Step 7b - SVG export (only if --svg flag), Step 7c - GraphML export (only if --graphml flag), Step 7d - MCP server (only if --mcp flag), Step 8 - Token reduction benchmark (only if total_words > 5000)

### Community 71 - "View"
Cohesion: 0.09
Nodes (22): iPhoneMIDIMappingBarView, .assignButton, .collapsedBar, .phoneDevicePickerSheet, .sectionQuickPads, Bool, String, Void (+14 more)

### Community 72 - "ProjectPersistenceError"
Cohesion: 0.20
Nodes (10): JSONDecoder, .projectDecoder, ManifestFile, ProjectPersistenceError, .errorDescription, invalidPackage, missingAudioFile, missingManifest (+2 more)

### Community 73 - "AudioClip"
Cohesion: 0.31
Nodes (7): AudioClip, .endTime, Int, String, TimeInterval, URL, UUID

### Community 74 - "WaveformLoadMonitor"
Cohesion: 0.53
Nodes (4): clips, Double, UUID, WaveformLoadMonitor

### Community 75 - "graphify reference: query, path, explain"
Cohesion: 0.33
Nodes (5): For /graphify explain, For /graphify path, graphify reference: query, path, explain, Step 0 — Constrained query expansion (REQUIRED before traversal), Step 1 — Traversal

### Community 76 - "LyricPlaySyncCodec"
Cohesion: 0.40
Nodes (4): LyricPlaySyncCodec, Data, JSONEncoder, .pretty

### Community 77 - "SectionPlaybackStatus"
Cohesion: 0.40
Nodes (5): SectionPlaybackStatus, idle, playing, queued, repeatingAtEnd

### Community 78 - "LyricPlaySyncMessageKind"
Cohesion: 0.22
Nodes (9): LyricPlaySyncMessageKind, catalogRequest, catalogResponse, error, linkSection, linkSectionAck, presence, presenceAck (+1 more)

### Community 79 - "WorkspaceSettingsView"
Cohesion: 0.28
Nodes (7): Binding, Bool, String, WorkspaceSettingsView, .body, .deleteSectionDialogTitle, .sectionDeletionDialogBinding

### Community 80 - ".attachClip"
Cohesion: 0.21
Nodes (8): AVAudioMixerNode, AVAudioPCMBuffer, AVAudioUnitEQ, ScheduledClip, AVAudioFile, AVAudioPlayerNode, AVAudioUnitTimePitch, Void

### Community 81 - "graphify reference: add a URL and watch a folder"
Cohesion: 0.50
Nodes (3): For /graphify add, For --watch, graphify reference: add a URL and watch a folder

### Community 82 - "graphify reference: commit hook and native AGENTS.md integration"
Cohesion: 0.50
Nodes (3): For git commit hook, For native AGENTS.md integration, graphify reference: commit hook and native AGENTS.md integration

### Community 83 - "graphify reference: incremental update and cluster-only"
Cohesion: 0.50
Nodes (3): For --cluster-only, For --update (incremental re-extraction), graphify reference: incremental update and cluster-only

### Community 84 - "TrackWaveformProgressBar"
Cohesion: 0.40
Nodes (4): Bool, Double, TrackWaveformProgressBar, .body

### Community 87 - "Density"
Cohesion: 0.50
Nodes (4): Density, compact, full, minimal

### Community 89 - "MIDINoteAssignment"
Cohesion: 0.10
Nodes (19): MIDILearnTarget, section, MIDINoteAssignment, .displayName, Bool, String, UInt8, UUID (+11 more)

### Community 90 - "AudioEngineService"
Cohesion: 0.40
Nodes (3): AudioEngineService, AVAudioTime, TimeInterval

### Community 91 - "Sendable"
Cohesion: 0.36
Nodes (12): Codable, Sendable, LinkSectionCommand, LyricPlaySync, LyricPlaySyncMessage, LyricSlideCatalog, LyricSlideCatalogItem, .id (+4 more)

### Community 92 - "ArrangementSection"
Cohesion: 0.09
Nodes (26): ArrangementSection, .color, .duration, .hasLyricSlideLink, CodingKeys, colorHex, endTime, id (+18 more)

### Community 93 - ".refreshLyricCatalog"
Cohesion: 0.28
Nodes (5): .expandedPanel, .lyricCatalogStatus, SectionLyricLinkSheet, .body, .unavailableState

### Community 94 - "TransportBarStyle"
Cohesion: 0.50
Nodes (3): TransportBarStyle, phoneBottomDock, standard

### Community 95 - "Panel"
Cohesion: 0.50
Nodes (4): Panel, mainVolume, none, timelineScale

### Community 96 - "TrimEdge"
Cohesion: 0.67
Nodes (3): TrimEdge, end, start

### Community 97 - ".body"
Cohesion: 0.11
Nodes (15): Commands, ContentView, .body, EditCommands, .body, FileCommands, Content, View (+7 more)

### Community 98 - "PinnedTimelineHeaderStrip"
Cohesion: 0.21
Nodes (10): PinnedTimelineHeaderStrip, .standardMarkerHeaderRow, .timeHeaderCell, Bool, Content, Int, Void, TimelineAudioDropModifier (+2 more)

### Community 99 - ".body"
Cohesion: 0.18
Nodes (11): iPhoneMultitrackLaneContent, .body, .phoneTimelineScroll, Bool, CGFloat, Content, TimelineHorizontalMirror, .body (+3 more)

### Community 102 - ".mixerChannelStrip"
Cohesion: 0.31
Nodes (5): .masterVolumeBinding, Binding, Double, UUID, .masterVolumeBinding

### Community 103 - "TrackControlButton"
Cohesion: 0.22
Nodes (8): PanKnobView, .body, Bool, Double, String, Void, TrackControlButton, .body

### Community 104 - "WorkspacePresentationModifier"
Cohesion: 0.20
Nodes (10): ScenePhase, Binding, Bool, String, WorkspacePresentationModifier, .deleteSectionDialogTitle, .sectionDeletionDialogBinding, WorkspaceLifecycleModifier (+2 more)

## Knowledge Gaps
- **376 isolated node(s):** `id`, `name`, `startTime`, `endTime`, `colorHex` (+371 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **6 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `WorkspaceViewModel` connect `WorkspaceViewModel` to `ArrangementPlaybackEngine`, `MIDIInputService`, `DAWProject`, `SupportedAudioFormats`, `TimelineWorkspacePanel`, `AudioImportService`, `SectionMarkerChipView`, `PropertiesSidebarView`, `MIDIMappingBarView`, `DAWVerticalFaderView`, `TrackOrganizationService`, `AudioSettings`, `Foundation`, `SwiftUI`, `TopToolbarView`, `TimelineScaleControls`, `StandardTrackRole`, `.track`, `.recordEditSnapshot`, `TimeInterval`, `MixerPanelView`, `.importAudioFiles`, `TimelineOverviewBar`, `TrackHeaderRowView`, `.applyRestoredProject`, `iPhoneTimelinePanel`, `ClipEditService`, `SavedProjectDocument`, `LyricPlaySyncClient`, `TrackPitchControlView`, `ProjectPersistenceService`, `CGFloat`, `.clipContent`, `TransportRightToolbar`, `.frames`, `SingleLaneTrackHeaderCell`, `.presentImportPanel`, `TransportBarView`, `SectionPlaybackMode`, `AudioTrack`, `ViewModifier`, `WorkspaceLayoutContext`, `View`, `AudioClip`, `SectionPlaybackStatus`, `WorkspaceSettingsView`, `MIDINoteAssignment`, `Sendable`, `ArrangementSection`, `.refreshLyricCatalog`, `.body`, `PinnedTimelineHeaderStrip`, `.body`, `Double`, `.mixerChannelStrip`, `WorkspacePresentationModifier`, `.setApplicationSceneActive`?**
  _High betweenness centrality (0.400) - this node is a cross-community bridge._
- **Why does `DAWProject` connect `DAWProject` to `MIDIInputService`, `AudioEngineService`, `SectionMarkerChipView`, `DAWVerticalFaderView`, `TrackOrganizationService`, `AudioSettings`, `Foundation`, `WorkspaceViewModel`, `StandardTrackRole`, `Equatable`, `.track`, `.recordEditSnapshot`, `TimeInterval`, `.importAudioFiles`, `TrackHeaderRowView`, `.applyRestoredProject`, `.play`, `SavedProjectDocument`, `ProjectPersistenceService`, `CGFloat`, `TrackGroup`, `AudioTrack`, `.attachClip`, `MIDINoteAssignment`, `Sendable`, `ArrangementSection`, `.refreshLyricCatalog`, `.body`, `Double`?**
  _High betweenness centrality (0.136) - this node is a cross-community bridge._
- **Why does `ArrangementSection` connect `ArrangementSection` to `ArrangementPlaybackEngine`, `SectionPlaybackMode`, `AudioTrack`, `DAWProject`, `View`, `.frames`, `SectionMarkerChipView`, `PropertiesSidebarView`, `MIDIMappingBarView`, `SwiftUI`, `LyricPlaySyncClient`, `WorkspaceViewModel`, `CGFloat`, `MIDINoteAssignment`, `Equatable`, `Sendable`, `.refreshLyricCatalog`, `TimeInterval`?**
  _High betweenness centrality (0.093) - this node is a cross-community bridge._
- **Are the 13 inferred relationships involving `WorkspaceViewModel` (e.g. with `ArrangementPlaybackEngine` and `AudioImportService`) actually correct?**
  _`WorkspaceViewModel` has 13 INFERRED edges - model-reasoned connections that need verification._
- **Are the 57 inferred relationships involving `DAWProject` (e.g. with `.clear()` and `.activeClipMoveGuides`) actually correct?**
  _`DAWProject` has 57 INFERRED edges - model-reasoned connections that need verification._
- **Are the 3 inferred relationships involving `ArrangementSection` (e.g. with `.body` and `.assignsDistinctColorsForDuplicateNames()`) actually correct?**
  _`ArrangementSection` has 3 INFERRED edges - model-reasoned connections that need verification._
- **What connects `id`, `name`, `startTime` to the rest of the system?**
  _376 weakly-connected nodes found - possible documentation gaps or missing edges._