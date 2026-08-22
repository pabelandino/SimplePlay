# Graph Report - SimplePlay  (2026-08-22)

## Corpus Check
- 141 files · ~84,289 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 2618 nodes · 6583 edges · 131 communities (116 shown, 15 thin omitted)
- Extraction: 90% EXTRACTED · 10% INFERRED · 0% AMBIGUOUS · INFERRED: 671 edges (avg confidence: 0.8)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `d3dc18e1`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- .configure
- MIDIInputService
- .tick
- IOSPlaybackStrategy
- TrackHeaderRowView
- SectionAudioCache
- TransportBarView
- CodingKeys
- AudioImportService
- AudioEngineService
- ProjectEditHistory
- View
- MIDIMappingBarView
- DAWVerticalFaderView
- TrackOrganizationService
- .resolveRepeatBoundaryPhase
- .standardize
- MacOSPlaybackStrategy
- MIDINoteAssignment
- SimplePlayProjectArchive
- TimeInterval
- iPhoneTimelinePanel
- WorkspaceViewModel
- What You Must Do When Invoked
- makeSection
- StandardTrackRole
- Equatable
- TransportCommands
- .log
- TimeInterval
- TimeInterval
- WaveformClipView
- .overviewRecessBackground
- MixerPanelView
- WorkspaceLayoutContext
- CGFloat
- .importAudioFiles
- SectionCueClockTests
- TimelineOverviewBar
- ScheduledClip
- .startMIDILearn
- .applyRestoredProject
- AVAudioTime
- TimelineView.swift
- ProjectPersistenceError
- iPhoneMIDIMappingBarView
- TimelineWorkspacePanel
- DAWProject
- AVFoundation
- TrackGroup
- .resolve
- Foundation
- TickCommand
- DAWProject
- LyricPlaySyncClient
- SimplePlayUITests
- TransportRightToolbar
- ArrangementSection
- .body
- AudioClip
- SingleLaneTrackHeaderCell
- TimelineScrollCoordinator
- DAWGlassChrome
- AudioEngineError
- SectionCueQueueMonitor
- AudioSettings
- TrackPitchControlView
- Audio Engine — Agent Guide
- .clipContent
- .body
- graphify reference: extra exports and benchmark
- FaderMeterStripView
- ToolbarMenuButtonStyleModifier
- .saveProject
- MacAppDelegate
- graphify reference: query, path, explain
- SectionStandbyCoordinator
- Section Playback — Agent Guide
- SectionPlaybackMode
- TrackControlButton
- SwiftUI
- graphify reference: add a URL and watch a folder
- graphify reference: commit hook and native AGENTS.md integration
- graphify reference: incremental update and cluster-only
- AudioFileStorageService
- graphify reference: GitHub clone and cross-repo merge
- graphify reference: transcribe video and audio
- .presentImportPanel
- extraction-spec.md
- ProjectPersistenceService
- UUID
- Sendable
- SupportedAudioFormats
- TimelineScaleControls
- AudioEngineService
- UIKitToolbarMenuButtonRepresentable
- PropertiesSidebarView
- SectionMarkerDensity
- NSCursor
- .sampleClip
- ClipTrimHandle
- DAWTheme
- .assignLyricSlide
- .format
- SimplePlayProjectArchiveError
- PitchShiftSettings
- WorkspaceSettingsView
- View
- .majorTickInterval
- TopToolbarView
- ConnectionState
- ArrangementPlaybackEngine
- .startPlaybackTimer
- PinnedTimelineHeaderStrip
- .trackHeaderColumnTracksOnly
- LyricPlaySyncCodec
- Observation
- SectionLoopContext
- WaveformLoadMonitor
- SectionTriggerResult
- SectionPlaybackStatus
- .sessionManagement
- TrimEdge
- iPhoneTrackHeaderRow
- WorkspacePresentationModifier
- SimplePlayTests.swift
- SnapGrid.swift
- TimeFormatting.swift
- AudioEngineService
- AudioEngineService
- Date

## God Nodes (most connected - your core abstractions)
1. `WorkspaceViewModel` - 352 edges
2. `AudioEngineService` - 195 edges
3. `DAWTheme` - 66 edges
4. `ArrangementPlaybackEngine` - 65 edges
5. `MIDIMappingBarView` - 55 edges
6. `DAWProject` - 46 edges
7. `StandardTrackRole` - 43 edges
8. `AudioTrack` - 43 edges
9. `ArrangementSection` - 41 edges
10. `MixerPanelView` - 36 edges

## Surprising Connections (you probably didn't know these)
- `.collapsedBar` --references--> `WorkspaceViewModel`  [INFERRED]
  SimplePlay/Features/Workspace/Views/iPhoneMIDIMappingBarView.swift → SimplePlay/Features/Workspace/ViewModels/WorkspaceViewModel.swift
- `.timelineGuideOverlays` --calls--> `SectionEdgeGuideOverlay`  [INFERRED]
  SimplePlay/Features/Workspace/Views/iPhoneTimelinePanel.swift → SimplePlay/Features/Workspace/Views/SectionMarkerLaneView.swift
- `.settingsHeader` --calls--> `DAWPrimaryButtonStyle`  [INFERRED]
  SimplePlay/Features/Workspace/Views/WorkspaceSettingsView.swift → SimplePlay/Features/Workspace/Views/TopToolbarView.swift
- `.body` --calls--> `TrackLaneView`  [INFERRED]
  SimplePlay/Features/Workspace/Views/iPhoneTimelinePanel.swift → SimplePlay/Features/Workspace/Views/TimelineView.swift
- `.phoneBottomDock` --calls--> `TimelineOverviewBar`  [INFERRED]
  SimplePlay/Features/Workspace/Views/TransportBarView.swift → SimplePlay/Features/Workspace/Views/TimelineOverviewBar.swift

## Import Cycles
- None detected.

## Communities (131 total, 15 thin omitted)

### Community 0 - ".configure"
Cohesion: 0.23
Nodes (8): UInt8, ArrangementPlaybackEngineAdvanceTests, ArrangementPlaybackEngineTests, ArrangementSection, SectionPlaybackMode, String, TimeInterval, UInt8

### Community 1 - "MIDIInputService"
Cohesion: 0.07
Nodes (28): CoreMIDI, MIDINotifyProc, MIDIPacket, MIDIPacketList, MIDISourceInfo, Kind, controlChange, noteOn (+20 more)

### Community 2 - ".tick"
Cohesion: 0.13
Nodes (17): Date, PlaybackTransportController, ArrangementSection, Bool, ClosedRange, Double, TimeInterval, TickInput (+9 more)

### Community 3 - "IOSPlaybackStrategy"
Cohesion: 0.13
Nodes (12): IOSPlaybackStrategy, .meterTapBufferSize, AVAudioFile, AVAudioFrameCount, AVAudioFramePosition, AVAudioPlayerNode, AVAudioTime, Bool (+4 more)

### Community 4 - "TrackHeaderRowView"
Cohesion: 0.10
Nodes (20): Density, compact, full, minimal, Binding, Bool, CGFloat, Double (+12 more)

### Community 5 - "SectionAudioCache"
Cohesion: 0.13
Nodes (18): AVAudioFormat, Hashable, Key, SectionAudioCache, SectionClipKey, AudioClip, AVAudioFrameCount, AVAudioFramePosition (+10 more)

### Community 6 - "TransportBarView"
Cohesion: 0.13
Nodes (17): Bool, CGFloat, String, Void, TransportBarStyle, phoneBottomDock, standard, TransportBarView (+9 more)

### Community 7 - "CodingKeys"
Cohesion: 0.08
Nodes (25): CodingKeys, audioSettings, colorHex, id, isLocked, isMuted, isPitchEnabled, isSnapEnabled (+17 more)

### Community 8 - "AudioImportService"
Cohesion: 0.27
Nodes (8): AudioImportService, ImportedStemsResult, String, TimeInterval, URL, UUID, Bool, URL

### Community 9 - "AudioEngineService"
Cohesion: 0.05
Nodes (30): AudioEnginePlatformServices, AudioEngineServiceHost, AudioSettings, AVAudioEngine, AVAudioUnitEQ, AudioEngineService, .activeSectionLoopContext, .armedBoundaryJumpIsPreScheduled (+22 more)

### Community 10 - "ProjectEditHistory"
Cohesion: 0.24
Nodes (6): ProjectEditHistory, .canRedo, .canUndo, Bool, Int, ProjectEditHistoryTests

### Community 11 - "View"
Cohesion: 0.08
Nodes (41): Selection, .playbackSettings, .sectionEditor, .selectedMarkerEditor, .selectionInfo, .trackPitch, .volumeControls, Content (+33 more)

### Community 12 - "MIDIMappingBarView"
Cohesion: 0.09
Nodes (29): Animation, AnyTransition, MIDINoteAssignment, MIDIMappingBarView, .assignModeToggleTitle, .body, .collapsedBar, .devicePickerLabel (+21 more)

### Community 13 - "DAWVerticalFaderView"
Cohesion: 0.09
Nodes (25): ClosedRange, Double, Float, String, TrackVolumeSettings, .trackRange, DAWVerticalFaderView, .body (+17 more)

### Community 14 - "TrackOrganizationService"
Cohesion: 0.16
Nodes (14): ImportedStem, ImportPlacement, appendNewGroup, insertIntoGroup, Int, String, TimeInterval, URL (+6 more)

### Community 15 - ".resolveRepeatBoundaryPhase"
Cohesion: 0.14
Nodes (13): RepeatBoundaryPhase, followAudioDelta, repeatArmed, repeatBoundary, SectionPlaybackCoordinator, ArrangementSection, Bool, Double (+5 more)

### Community 16 - ".standardize"
Cohesion: 0.20
Nodes (7): StandardizedName, Bool, Int, String, URL, TrackNameStandardizer, TrackNameStandardizerTests

### Community 17 - "MacOSPlaybackStrategy"
Cohesion: 0.13
Nodes (12): MacOSPlaybackStrategy, .meterTapBufferSize, AVAudioFile, AVAudioFrameCount, AVAudioFramePosition, AVAudioPlayerNode, AVAudioTime, Bool (+4 more)

### Community 18 - "MIDINoteAssignment"
Cohesion: 0.22
Nodes (9): MIDILearnTarget, section, MIDINoteAssignment, .displayName, Bool, String, UInt8, UUID (+1 more)

### Community 19 - "SimplePlayProjectArchive"
Cohesion: 0.23
Nodes (10): Asset, SimplePlayProjectArchive, Bool, Data, Int, UInt32, UInt64, URL (+2 more)

### Community 20 - "TimeInterval"
Cohesion: 0.17
Nodes (7): ArrangementSection, Bool, Double, SectionLoopContext, TimeInterval, TransportClock, TransportDisplayClock

### Community 21 - "iPhoneTimelinePanel"
Cohesion: 0.16
Nodes (15): iPhoneMultitrackLaneContent, .body, iPhoneSectionsLabelHeaderCell, .body, iPhoneTimelinePanel, .body, .laneAreaHeight, .magnificationGesture (+7 more)

### Community 22 - "WorkspaceViewModel"
Cohesion: 0.05
Nodes (39): AudioOutputDevice, MIDIInputEvent, MIDILearnTarget, ClipMovePreview, SectionEdgeGuides, ClosedRange, Double, Float (+31 more)

### Community 23 - "What You Must Do When Invoked"
Cohesion: 0.08
Nodes (24): For /graphify add and --watch, For /graphify query, For the commit hook and native AGENTS.md integration, For --update and --cluster-only, /graphify, Honesty Rules, Interpreter guard for subcommands, Part A - Structural extraction for code files (+16 more)

### Community 24 - "makeSection"
Cohesion: 0.40
Nodes (5): makeSection(), ArrangementSection, String, TimeInterval, UInt8

### Community 25 - "StandardTrackRole"
Cohesion: 0.07
Nodes (30): StandardTrackRole, acousticGuitar, backingVocal, bass, brass, click, countIn, cue (+22 more)

### Community 26 - "Equatable"
Cohesion: 0.25
Nodes (15): Equatable, PersistedClip, PersistedProject, PersistedTrack, Bool, Decoder, Double, Encoder (+7 more)

### Community 27 - "TransportCommands"
Cohesion: 0.50
Nodes (3): TransportCommands, View, WorkspaceKeyboardShortcuts

### Community 28 - ".log"
Cohesion: 0.11
Nodes (18): SectionLoopDiagnostics, SectionTriggerDiagnostics, AVAudioFrameCount, AVAudioFramePosition, Bool, Double, Int, Int64 (+10 more)

### Community 29 - "TimeInterval"
Cohesion: 0.13
Nodes (11): ArmedBoundaryJump, .hasArmedBoundaryJump, LoopBodyBounds, .frameCount, LoopTrackScheduleState, Bool, Int, Int64 (+3 more)

### Community 30 - "TimeInterval"
Cohesion: 0.11
Nodes (10): Bool, TimeInterval, ArrangementSection, Bool, SectionLoopContext, TimeInterval, TimelineScrollAlignment, center (+2 more)

### Community 31 - "WaveformClipView"
Cohesion: 0.07
Nodes (42): CheckedContinuation, Bool, Double, Float, Int, MainActor, Never, Sendable (+34 more)

### Community 32 - ".overviewRecessBackground"
Cohesion: 0.24
Nodes (7): Path, .overviewBackground, DAWTransportChrome, CGFloat, Double, LinearGradient, View

### Community 33 - "MixerPanelView"
Cohesion: 0.09
Nodes (24): MixerPanelView, .body, .channelFaderHeight, .channelFaderWidth, .channelStripWidth, .groupDivider, .isCompact, .masterFaderHeight (+16 more)

### Community 34 - "WorkspaceLayoutContext"
Cohesion: 0.10
Nodes (20): EnvironmentKey, iPhoneWorkspaceView, .body, .phoneLayout, StandardWorkspaceView, .workspaceLayout, EnvironmentValues, .workspaceLayout (+12 more)

### Community 35 - "CGFloat"
Cohesion: 0.11
Nodes (9): SectionDragKind, move, resizeEnd, resizeStart, CGFloat, TimelineScrollRequest, .minimumTimelineZoom, .timelineContentWidth (+1 more)

### Community 36 - ".importAudioFiles"
Cohesion: 0.22
Nodes (5): Error, Result, String, URL, TrackOrganizationService

### Community 37 - "SectionCueClockTests"
Cohesion: 0.16
Nodes (6): SectionCueClock, AVAudioTime, Bool, TimeInterval, UInt64, SectionCueClockTests

### Community 38 - "TimelineOverviewBar"
Cohesion: 0.19
Nodes (13): Bool, CGFloat, CGSize, ClosedRange, Gesture, TimeInterval, TimelineOverviewBar, .barHeight (+5 more)

### Community 39 - "ScheduledClip"
Cohesion: 0.13
Nodes (12): AVAudioMixerNode, MeterPeakBuffer, ScheduledClip, AudioClip, AVAudioFile, AVAudioFrameCount, AVAudioPCMBuffer, AVAudioUnitTimePitch (+4 more)

### Community 41 - ".applyRestoredProject"
Cohesion: 0.12
Nodes (7): Content, View, .body, .historyControls, .historyControls, .audioSettings, .transportControls

### Community 42 - "AVAudioTime"
Cohesion: 0.17
Nodes (5): AVAudioNode, ObjectIdentifier, .playbackGraphIsHealthy, AVAudioPlayerNode, AVAudioTime

### Community 43 - "TimelineView.swift"
Cohesion: 0.22
Nodes (14): GraphicsContext, ClipSplitOverlay, .body, .clipWidth, CGFloat, CGSize, TimeInterval, Void (+6 more)

### Community 44 - "ProjectPersistenceError"
Cohesion: 0.20
Nodes (10): JSONDecoder, .projectDecoder, ManifestFile, ProjectPersistenceError, .errorDescription, invalidPackage, missingAudioFile, missingManifest (+2 more)

### Community 45 - "iPhoneMIDIMappingBarView"
Cohesion: 0.13
Nodes (14): iPhoneMIDIMappingBarView, .collapsedBar, .devicePickerButton, .sectionQuickPads, ArrangementSection, Bool, Color, String (+6 more)

### Community 46 - "TimelineWorkspacePanel"
Cohesion: 0.23
Nodes (15): ScrollPosition, Bool, CGFloat, Double, String, TimelineTrackScrollArea, TimelineWorkspacePanel, .isCompact (+7 more)

### Community 48 - "AVFoundation"
Cohesion: 0.12
Nodes (7): AudioUnit, AVFoundation, CoreAudio, AudioEngineService, AVAudioTime, TimeInterval, PlatformPlaybackStrategyFactory

### Community 49 - "TrackGroup"
Cohesion: 0.14
Nodes (16): CodingKey, CodingKeys, horizontalOffset, id, importedAt, name, pitchSemitones, volume (+8 more)

### Community 50 - ".resolve"
Cohesion: 0.27
Nodes (5): PlaybackDeltaPolicy, Resolution, Bool, TimeInterval, PlaybackDeltaPolicyTests

### Community 51 - "Foundation"
Cohesion: 0.17
Nodes (4): CoreGraphics, Foundation, SimplePlay, Testing

### Community 52 - "TickCommand"
Cohesion: 0.12
Nodes (17): SectionLoopContext, TickCommand, armContinueToNextJump, armLinearContinuation, armQueuedSectionJump, armRepeatAudio, completeRepeatBoundary, none (+9 more)

### Community 53 - "DAWProject"
Cohesion: 0.14
Nodes (21): Identifiable, AudioTrack, .color, .displayName, Bool, Double, String, UUID (+13 more)

### Community 54 - "LyricPlaySyncClient"
Cohesion: 0.19
Nodes (9): NWBrowser, NWEndpoint, LyricPlaySyncClient, serverError, Never, Set, TimeInterval, Void (+1 more)

### Community 55 - "SimplePlayUITests"
Cohesion: 0.14
Nodes (6): SimplePlayUITests, SimplePlayUITestsLaunchTests, .runsForEachTargetApplicationUIConfiguration, Bool, XCTest, XCTestCase

### Community 56 - "TransportRightToolbar"
Cohesion: 0.11
Nodes (22): .body, .phoneRightControls, Panel, mainVolume, none, timelineScale, Binding, Bool (+14 more)

### Community 57 - "ArrangementSection"
Cohesion: 0.08
Nodes (33): ArrangementSection, .color, .duration, .hasLyricSlideLink, CodingKeys, colorHex, endTime, id (+25 more)

### Community 58 - ".body"
Cohesion: 0.24
Nodes (7): .phoneTimelineScroll, .body, AudioDropOverlay, .body, String, TimelineEmptyDropHint, .body

### Community 59 - "AudioClip"
Cohesion: 0.36
Nodes (7): AudioClip, .endTime, Int, String, TimeInterval, URL, UUID

### Community 60 - "SingleLaneTrackHeaderCell"
Cohesion: 0.18
Nodes (13): .singleLaneHeight, SingleLaneMarkerHeaderCell, .body, SingleLaneStackedClipsLane, .body, SingleLaneTimelineViews, SingleLaneTrackHeaderCell, .body (+5 more)

### Community 61 - "TimelineScrollCoordinator"
Cohesion: 0.27
Nodes (7): Bool, CGFloat, Content, TimelineHorizontalMirror, .body, TimelineScrollCoordinator, .isInteracting

### Community 62 - "DAWGlassChrome"
Cohesion: 0.18
Nodes (9): Glass, DAWGlassChrome, .controlGlass, .panelGlass, CGFloat, Double, LinearGradient, View (+1 more)

### Community 63 - "AudioEngineError"
Cohesion: 0.10
Nodes (20): LocalizedError, Network, AudioEngineError, clipLoadFailed, deviceSelectionFailed, engineStartFailed, .errorDescription, noPlayableClips (+12 more)

### Community 64 - "SectionCueQueueMonitor"
Cohesion: 0.24
Nodes (11): JobState, SectionCueQueueMonitor, .isAnySectionQueuing, .overallProgress, Bool, Double, Int, UInt64 (+3 more)

### Community 65 - "AudioSettings"
Cohesion: 0.06
Nodes (33): AnyObject, AVAudioSession, Double, AudioOutputDevice, AudioSampleRate, .displayName, .id, rate44100 (+25 more)

### Community 66 - "TrackPitchControlView"
Cohesion: 0.16
Nodes (13): .actionButtons, Binding, Bool, Double, String, UUID, TrackPitchControlView, .menuTitle (+5 more)

### Community 67 - "Audio Engine — Agent Guide"
Cohesion: 0.17
Nodes (11): Architecture (do not collapse), Audio Engine — Agent Guide, Before you edit, iOS session rules (critical), Log messages, macOS device rules, Playback sync invariants (never break), Red flags (stop and reconsider) (+3 more)

### Community 68 - ".clipContent"
Cohesion: 0.20
Nodes (9): G, ClipDragInteractionModifier, ClipSelectionModifiers, .isExtending, Bool, TrackLaneView, .clipHeight, .liveTrack (+1 more)

### Community 69 - ".body"
Cohesion: 0.18
Nodes (10): NSEvent, NSView, NSViewRepresentable, .body, .body, MacWindowDragRegion, MacWindowTitleBarHidden, Context (+2 more)

### Community 70 - "graphify reference: extra exports and benchmark"
Cohesion: 0.22
Nodes (8): graphify reference: extra exports and benchmark, Step 6b - Wiki (only if --wiki flag), Step 7 - Neo4j export (only if --neo4j or --neo4j-push flag), Step 7a - FalkorDB export (only if --falkordb or --falkordb-push flag), Step 7b - SVG export (only if --svg flag), Step 7c - GraphML export (only if --graphml flag), Step 7d - MCP server (only if --mcp flag), Step 8 - Token reduction benchmark (only if total_words > 5000)

### Community 71 - "FaderMeterStripView"
Cohesion: 0.17
Nodes (11): .projectMasterStrip, FaderMeterStripView, .reservesThumbClearance, .showsUnityMark, .usesUnityCenterDecibelScale, Bool, CGFloat, ClosedRange (+3 more)

### Community 72 - "ToolbarMenuButtonStyleModifier"
Cohesion: 0.27
Nodes (7): Bool, ToolbarMenuButtonStyleModifier, .importButton, .projectSessionButton, ImportToolbarMenuButton, .body, ProjectSessionToolbarMenuButton

### Community 73 - ".saveProject"
Cohesion: 0.36
Nodes (4): SavedProjectDocument, String, .body, SimplePlayProjectFileDocument

### Community 74 - "MacAppDelegate"
Cohesion: 0.27
Nodes (6): Notification, NSApplicationDelegate, NSObject, NSWindow, MacAppDelegate, MacWindowConfigurator

### Community 75 - "graphify reference: query, path, explain"
Cohesion: 0.33
Nodes (5): For /graphify explain, For /graphify path, graphify reference: query, path, explain, Step 0 — Constrained query expansion (REQUIRED before traversal), Step 1 — Traversal

### Community 76 - "SectionStandbyCoordinator"
Cohesion: 0.08
Nodes (19): os, .isAnyPlayerPlaying, AVAudioTime, TimeInterval, Lane, SectionNextIntent, continuation, jump (+11 more)

### Community 77 - "Section Playback — Agent Guide"
Cohesion: 0.12
Nodes (16): Arm (tap 2), Constants (keep in sync), Disable (tap while repeat is armed, before wrap), Extra cycle → song (no third tap), Flags (do not overload), Forbidden “fixes”, If you must change this, Layers (do not collapse) (+8 more)

### Community 78 - "SectionPlaybackMode"
Cohesion: 0.13
Nodes (13): CaseIterable, SectionPlaybackMode, continueTimeline, continueToNext, .displayName, .id, oneShot, repeatSection (+5 more)

### Community 79 - "TrackControlButton"
Cohesion: 0.22
Nodes (8): PanKnobView, .body, Bool, Double, String, Void, TrackControlButton, .body

### Community 80 - "SwiftUI"
Cohesion: 0.11
Nodes (13): App, AppKit, Commands, Scene, ContentView, EditCommands, .body, FileCommands (+5 more)

### Community 81 - "graphify reference: add a URL and watch a folder"
Cohesion: 0.50
Nodes (3): For /graphify add, For --watch, graphify reference: add a URL and watch a folder

### Community 82 - "graphify reference: commit hook and native AGENTS.md integration"
Cohesion: 0.50
Nodes (3): For git commit hook, For native AGENTS.md integration, graphify reference: commit hook and native AGENTS.md integration

### Community 83 - "graphify reference: incremental update and cluster-only"
Cohesion: 0.50
Nodes (3): For --cluster-only, For --update (incremental re-extraction), graphify reference: incremental update and cluster-only

### Community 84 - "AudioFileStorageService"
Cohesion: 0.43
Nodes (4): AudioFileStorageService, String, URL, UUID

### Community 87 - ".presentImportPanel"
Cohesion: 0.24
Nodes (6): ProjectFilePanel, URL, ImportPanelKind, audioFiles, folder, .importMenuItems

### Community 89 - "ProjectPersistenceService"
Cohesion: 0.25
Nodes (7): SavedProjectDocument, unsupportedVersion, ProjectPersistenceService, Bool, Data, URL, UUID

### Community 90 - "UUID"
Cohesion: 0.07
Nodes (13): ClipEditService, AudioClip, AudioTrack, UInt8, UUID, .canSplitSelectedClipAtPlayhead, .body, .mixerScrollWithPinnedMasters (+5 more)

### Community 91 - "Sendable"
Cohesion: 0.18
Nodes (21): Codable, Sendable, LinkSectionCommand, LyricPlaySync, LyricPlaySyncMessage, LyricPlaySyncMessageKind, catalogRequest, catalogResponse (+13 more)

### Community 92 - "SupportedAudioFormats"
Cohesion: 0.06
Nodes (37): FileDocument, FileWrapper, ReadConfiguration, SimplePlayProjectFileDocument, .readableContentTypes, Data, DropURLLoader, NSItemProvider (+29 more)

### Community 93 - "TimelineScaleControls"
Cohesion: 0.16
Nodes (11): Bool, CGFloat, Double, String, Void, TimelineScaleControls, .buttonCornerRadius, .buttonSize (+3 more)

### Community 95 - "UIKitToolbarMenuButtonRepresentable"
Cohesion: 0.33
Nodes (7): Coordinator, Context, String, Void, UIKitToolbarMenuButtonRepresentable, UIButton, UIViewRepresentable

### Community 96 - "PropertiesSidebarView"
Cohesion: 0.13
Nodes (17): .masterVolumeBinding, PropertiesSidebarView, .body, .masterVolumeBinding, .pitchIsOriginal, .pitchLabel, .sectionCreationHint, .selectedDeviceID (+9 more)

### Community 97 - "SectionMarkerDensity"
Cohesion: 0.24
Nodes (6): Content, SectionMarkerDensity, compact, dot, full, minimal

### Community 99 - ".sampleClip"
Cohesion: 0.26
Nodes (4): ClipEditService, TimeInterval, ClipEditServiceTests, TimeInterval

### Community 100 - "ClipTrimHandle"
Cohesion: 0.25
Nodes (7): ClipTrimHandle, .body, .handleHitWidth, Gesture, NSCursor, UUID, TrackLaneDropModifier

### Community 101 - "DAWTheme"
Cohesion: 0.07
Nodes (33): ButtonStyle, .assignButton, .body, .assignModeHeader, .assignModeToggle, .collapsedBarContent, .learnBanner, .lyricCatalogStatus (+25 more)

### Community 102 - ".assignLyricSlide"
Cohesion: 0.33
Nodes (4): LyricSlideCatalog, LyricSlideCatalogItem, SectionLyricLinkSheet, .body

### Community 103 - ".format"
Cohesion: 0.33
Nodes (5): Bool, String, TimeInterval, .formattedCurrentTime, .formattedDuration

### Community 104 - "SimplePlayProjectArchiveError"
Cohesion: 0.29
Nodes (6): SimplePlayProjectArchiveError, corruptAsset, corruptManifest, .errorDescription, invalidArchive, String

### Community 105 - "PitchShiftSettings"
Cohesion: 0.13
Nodes (12): groups, PitchShiftSettings, AudioClip, AudioTrack, AVAudioUnitTimePitch, Bool, Double, Float (+4 more)

### Community 106 - "WorkspaceSettingsView"
Cohesion: 0.15
Nodes (10): Content, View, Binding, Bool, String, WorkspaceSettingsView, .body, .deleteSectionDialogTitle (+2 more)

### Community 107 - "View"
Cohesion: 0.09
Nodes (40): NSCursor, .phonePinnedHeader, ResizeEdge, end, start, sectionChipSurface(), SectionCreationPreviewView, .body (+32 more)

### Community 108 - ".majorTickInterval"
Cohesion: 0.27
Nodes (5): CGFloat, String, TimeInterval, TimelineRulerScale, TimelineRulerScaleTests

### Community 109 - "TopToolbarView"
Cohesion: 0.23
Nodes (12): String, TimelineEditTool, Void, TopToolbarView, .addTrackMenu, .isCompact, .openButton, .projectTitle (+4 more)

### Community 110 - "ConnectionState"
Cohesion: 0.33
Nodes (6): ConnectionState, connected, failed, idle, searching, String

### Community 111 - "ArrangementPlaybackEngine"
Cohesion: 0.13
Nodes (17): AdvanceOutcome, arrangementStopped, none, reachedProjectEnd, sectionHandled, AdvanceResult, ArrangementPlaybackEngine, PlaybackState (+9 more)

### Community 113 - "PinnedTimelineHeaderStrip"
Cohesion: 0.19
Nodes (13): PinnedTimelineHeaderStrip, .timeHeaderCell, PlayheadView, .body, .playheadDragGesture, Content, Gesture, Int (+5 more)

### Community 114 - ".trackHeaderColumnTracksOnly"
Cohesion: 0.29
Nodes (3): Int, .trackHeaderColumnTracksOnly, .wrapLayoutButton

### Community 115 - "LyricPlaySyncCodec"
Cohesion: 0.40
Nodes (4): LyricPlaySyncCodec, Data, JSONEncoder, .pretty

### Community 117 - "SectionLoopContext"
Cohesion: 0.40
Nodes (4): SectionLoopContext, .duration, TimeInterval, UUID

### Community 118 - "WaveformLoadMonitor"
Cohesion: 0.21
Nodes (10): clips, Bool, Double, UUID, WaveformLoadMonitor, .fullLayout, Bool, Double (+2 more)

### Community 119 - "SectionTriggerResult"
Cohesion: 0.40
Nodes (5): SectionTriggerResult, activatedImmediately, disabledRepeatAtEnd, enabledRepeatAtEnd, queuedForEnd

### Community 120 - "SectionPlaybackStatus"
Cohesion: 0.40
Nodes (5): SectionPlaybackStatus, idle, playing, queued, repeatingAtEnd

### Community 121 - ".sessionManagement"
Cohesion: 0.60
Nodes (3): .sessionManagement, .projectSessionMenuItems, .body

### Community 122 - "TrimEdge"
Cohesion: 0.67
Nodes (3): TrimEdge, end, start

### Community 123 - "iPhoneTrackHeaderRow"
Cohesion: 0.20
Nodes (9): .phoneTrackHeaderColumn, iPhoneTrackHeaderRow, .displayColor, .liveTrack, AudioTrack, Bool, Color, String (+1 more)

### Community 124 - "WorkspacePresentationModifier"
Cohesion: 0.18
Nodes (11): ScenePhase, .body, Binding, Bool, String, WorkspacePresentationModifier, .deleteSectionDialogTitle, .sectionDeletionDialogBinding (+3 more)

## Knowledge Gaps
- **432 isolated node(s):** `Architecture (do not collapse)`, `Safe change map`, `iOS session rules (critical)`, `macOS device rules`, `Before you edit` (+427 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **15 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `WorkspaceViewModel` connect `WorkspaceViewModel` to `MIDIInputService`, `.tick`, `TrackHeaderRowView`, `TransportBarView`, `AudioImportService`, `AudioEngineService`, `ProjectEditHistory`, `View`, `MIDIMappingBarView`, `TimeInterval`, `iPhoneTimelinePanel`, `TransportCommands`, `.log`, `TimeInterval`, `MixerPanelView`, `WorkspaceLayoutContext`, `CGFloat`, `.importAudioFiles`, `TimelineOverviewBar`, `.startMIDILearn`, `.applyRestoredProject`, `TimelineView.swift`, `iPhoneMIDIMappingBarView`, `TimelineWorkspacePanel`, `DAWProject`, `LyricPlaySyncClient`, `TransportRightToolbar`, `.body`, `SingleLaneTrackHeaderCell`, `AudioSettings`, `TrackPitchControlView`, `.clipContent`, `ToolbarMenuButtonStyleModifier`, `.saveProject`, `SwiftUI`, `.presentImportPanel`, `ProjectPersistenceService`, `UUID`, `SupportedAudioFormats`, `TimelineScaleControls`, `PropertiesSidebarView`, `.sampleClip`, `ClipTrimHandle`, `DAWTheme`, `.assignLyricSlide`, `.format`, `WorkspaceSettingsView`, `View`, `TopToolbarView`, `ArrangementPlaybackEngine`, `.startPlaybackTimer`, `PinnedTimelineHeaderStrip`, `.trackHeaderColumnTracksOnly`, `Observation`, `SectionPlaybackStatus`, `.sessionManagement`, `iPhoneTrackHeaderRow`, `WorkspacePresentationModifier`?**
  _High betweenness centrality (0.495) - this node is a cross-community bridge._
- **Why does `AudioEngineService` connect `AudioEngineService` to `AudioSettings`, `IOSPlaybackStrategy`, `SectionAudioCache`, `ScheduledClip`, `AVAudioTime`, `SectionStandbyCoordinator`, `DAWProject`, `MacOSPlaybackStrategy`, `WorkspaceViewModel`, `TimeInterval`?**
  _High betweenness centrality (0.205) - this node is a cross-community bridge._
- **Why does `Foundation` connect `Foundation` to `MIDIInputService`, `IOSPlaybackStrategy`, `AudioImportService`, `ProjectEditHistory`, `DAWVerticalFaderView`, `.resolveRepeatBoundaryPhase`, `.standardize`, `MIDINoteAssignment`, `TimeInterval`, `Equatable`, `.log`, `WaveformClipView`, `SectionCueClockTests`, `ProjectPersistenceError`, `AVFoundation`, `TrackGroup`, `.resolve`, `AudioClip`, `AudioEngineError`, `AudioSettings`, `SectionStandbyCoordinator`, `SectionPlaybackMode`, `SwiftUI`, `AudioFileStorageService`, `Sendable`, `SupportedAudioFormats`, `SimplePlayProjectArchiveError`, `Observation`, `SectionLoopContext`, `SnapGrid.swift`, `TimeFormatting.swift`?**
  _High betweenness centrality (0.095) - this node is a cross-community bridge._
- **Are the 15 inferred relationships involving `WorkspaceViewModel` (e.g. with `ArrangementPlaybackEngine` and `AudioEngineService`) actually correct?**
  _`WorkspaceViewModel` has 15 INFERRED edges - model-reasoned connections that need verification._
- **Are the 3 inferred relationships involving `AudioEngineService` (e.g. with `SectionAudioCache` and `SectionStandbyCoordinator`) actually correct?**
  _`AudioEngineService` has 3 INFERRED edges - model-reasoned connections that need verification._
- **What connects `Architecture (do not collapse)`, `Safe change map`, `iOS session rules (critical)` to the rest of the system?**
  _432 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `MIDIInputService` be split into smaller, more focused modules?**
  _Cohesion score 0.06896551724137931 - nodes in this community are weakly interconnected._