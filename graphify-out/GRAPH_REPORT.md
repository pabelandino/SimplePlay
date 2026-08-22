# Graph Report - SimplePlay  (2026-08-22)

## Corpus Check
- 143 files · ~85,927 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 2679 nodes · 6764 edges · 126 communities (101 shown, 25 thin omitted)
- Extraction: 89% EXTRACTED · 11% INFERRED · 0% AMBIGUOUS · INFERRED: 752 edges (avg confidence: 0.8)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `b4cfc9de`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- ArrangementPlaybackEngine
- MIDIInputService
- .tick
- IOSPlaybackStrategy
- TrackHeaderRowView
- AudioClip
- iPhoneTimelinePanel
- CodingKeys
- AudioImportService
- AudioEngineService
- DAWProject
- DAWSecondaryButtonStyle
- MIDIMappingBarView
- DAWVerticalFaderView
- TrackOrganizationService
- .log
- WaveformClipView
- MacOSPlaybackStrategy
- .applyRestoredProject
- ProjectPersistenceService
- TimeInterval
- UUID
- WorkspaceViewModel
- What You Must Do When Invoked
- SimplePlayProjectArchive
- StandardTrackRole
- Sendable
- ArrangementSection
- TrackGroup
- TimeInterval
- TimeInterval
- .standardize
- AudioTrack
- MixerPanelView
- WorkspaceLayoutContext
- .commitSectionDragPreview
- .importAudioFiles
- SectionCueClockTests
- TimelineOverviewBar
- TransportBarView
- .frames
- LyricSlideCatalogItem
- .isNodeConnected
- .clipContent
- CodingKeys
- SwiftUI
- TimelineWorkspacePanel
- .play
- AudioEngineServiceMacOS.swift
- TimelineScaleControls
- .resolve
- SimplePlay
- SectionPlaybackCoordinatorTests
- SectionLyricLinkSheet
- LyricPlaySyncMessage
- ProjectEditHistory
- TransportRightToolbar
- LyricPlaySyncClient
- LyricSlidePickerCard
- MIDIOutputService
- View
- AudioSettings
- DAWTheme
- LyricPlaySyncTransportError
- iPhoneMIDIMappingBarView
- SectionPlaybackMode
- TrackPitchControlView
- Audio Engine — Agent Guide
- TimelineScrollCoordinator
- AppKit
- graphify reference: extra exports and benchmark
- .body
- .overviewRecessBackground
- Color
- .boundaryCueTime
- graphify reference: query, path, explain
- SectionStandbyCoordinator
- Section Playback — Agent Guide
- .startMIDILearn
- LyricPlaySyncMessageKind
- CodingKeys
- graphify reference: add a URL and watch a folder
- graphify reference: commit hook and native AGENTS.md integration
- graphify reference: incremental update and cluster-only
- PropertiesSidebarView
- graphify reference: GitHub clone and cross-repo merge
- graphify reference: transcribe video and audio
- .saveProject
- extraction-spec.md
- .stem
- UUID
- UIKitToolbarMenuButtonRepresentable
- SupportedAudioFormats
- MIDINoteAssignment
- MIDIMappingBarView.swift
- .prepareMIDIInput
- SidebarLabeledRow
- WaveformLOD.swift
- .requestNewProject
- SnapGrid.swift
- View
- AVAudioFile
- Double
- SectionPlaybackStatus
- AVAudioFrameCount
- PitchShiftSettings
- AVAudioFramePosition
- SectionMarkerChipView
- AudioEngineError
- View
- AVAudioPCMBuffer
- TimeInterval
- AVAudioPlayerNode
- AVAudioTime
- AVAudioUnitTimePitch
- Int64
- Foundation
- Data
- Decoder
- SectionTriggerResult
- Encoder
- URL
- UInt32
- Gesture
- NSCursor
- SimplePlayTests.swift

## God Nodes (most connected - your core abstractions)
1. `WorkspaceViewModel` - 356 edges
2. `AudioEngineService` - 172 edges
3. `DAWProject` - 104 edges
4. `DAWTheme` - 69 edges
5. `ArrangementPlaybackEngine` - 66 edges
6. `MIDIMappingBarView` - 54 edges
7. `AudioTrack` - 46 edges
8. `ArrangementSection` - 44 edges
9. `StandardTrackRole` - 43 edges
10. `MixerPanelView` - 36 edges

## Surprising Connections (you probably didn't know these)
- `.collapsedBar` --references--> `WorkspaceViewModel`  [INFERRED]
  SimplePlay/Features/Workspace/Views/iPhoneMIDIMappingBarView.swift → SimplePlay/Features/Workspace/ViewModels/WorkspaceViewModel.swift
- `.lyricLinkSheet` --calls--> `SectionLyricLinkSheet`  [INFERRED]
  SimplePlay/Features/Workspace/Views/WorkspacePresentationModifier.swift → SimplePlay/Features/Workspace/Views/SectionLyricLinkSheet.swift
- `TrackOrganizationServiceTests` --calls--> `TrackOrganizationService`  [EXTRACTED]
  SimplePlayTests/TrackOrganizationServiceTests.swift → SimplePlay/Core/Services/TrackOrganizationService.swift
- `.body` --calls--> `TrackLaneView`  [INFERRED]
  SimplePlay/Features/Workspace/Views/iPhoneTimelinePanel.swift → SimplePlay/Features/Workspace/Views/TimelineView.swift
- `makeSection()` --calls--> `ArrangementSection`  [EXTRACTED]
  SimplePlayTests/PlaybackTransportControllerTests.swift → SimplePlay/Core/Models/ArrangementSection.swift

## Import Cycles
- None detected.

## Communities (126 total, 25 thin omitted)

### Community 0 - "ArrangementPlaybackEngine"
Cohesion: 0.17
Nodes (12): ArrangementPlaybackEngine, ArrangementSection, Bool, UInt8, UUID, ArrangementPlaybackEngineAdvanceTests, ArrangementPlaybackEngineTests, ArrangementSection (+4 more)

### Community 1 - "MIDIInputService"
Cohesion: 0.12
Nodes (16): MIDINotifyProc, MIDIPacket, MIDIInputEvent, MIDIInputService, MIDISourceInfo, .id, Bool, Int (+8 more)

### Community 2 - ".tick"
Cohesion: 0.07
Nodes (36): PlaybackTransportController, SectionLoopContext, .duration, TimeInterval, UUID, PlaybackTransportController, Bool, ClosedRange (+28 more)

### Community 3 - "IOSPlaybackStrategy"
Cohesion: 0.16
Nodes (13): IOSPlaybackStrategy, .meterTapBufferSize, AudioEngineService, AVAudioFile, AVAudioFrameCount, AVAudioFramePosition, AVAudioPlayerNode, AVAudioTime (+5 more)

### Community 4 - "TrackHeaderRowView"
Cohesion: 0.06
Nodes (38): clips, Bool, Double, UUID, WaveformLoadMonitor, Density, compact, full (+30 more)

### Community 5 - "AudioClip"
Cohesion: 0.06
Nodes (39): AVAudioFormat, Hashable, AudioClip, .endTime, Int, String, TimeInterval, URL (+31 more)

### Community 6 - "iPhoneTimelinePanel"
Cohesion: 0.12
Nodes (22): iPhoneMultitrackLaneContent, .body, iPhoneSectionsLabelHeaderCell, .body, iPhoneTimelinePanel, .body, .laneAreaHeight, .magnificationGesture (+14 more)

### Community 7 - "CodingKeys"
Cohesion: 0.07
Nodes (32): CodingKeys, audioSettings, colorHex, id, isLocked, isMuted, isPitchEnabled, isSnapEnabled (+24 more)

### Community 8 - "AudioImportService"
Cohesion: 0.12
Nodes (18): AudioFileStorageService, String, URL, UUID, AudioImportError, emptySelection, .errorDescription, storageUnavailable (+10 more)

### Community 9 - "AudioEngineService"
Cohesion: 0.05
Nodes (31): AudioEnginePlatformServices, AudioEngineServiceHost, AudioSettings, AVAudioEngine, AVAudioFile, AVAudioUnitEQ, PlatformPlaybackStrategy, AudioEngineService (+23 more)

### Community 10 - "DAWProject"
Cohesion: 0.13
Nodes (17): DAWProject, Bool, Double, Int32, String, TimeInterval, UInt8, UUID (+9 more)

### Community 11 - "DAWSecondaryButtonStyle"
Cohesion: 0.11
Nodes (36): Selection, .audioSettings, .playbackSettings, .sectionEditor, .selectedMarkerEditor, .selectionInfo, .sessionManagement, .trackPitch (+28 more)

### Community 12 - "MIDIMappingBarView"
Cohesion: 0.10
Nodes (25): Animation, AnyTransition, MIDINoteAssignment, MIDIMappingBarView, .assignModeToggleTitle, .body, .collapsedBar, .devicePickerLabel (+17 more)

### Community 13 - "DAWVerticalFaderView"
Cohesion: 0.09
Nodes (25): ClosedRange, Double, Float, String, TrackVolumeSettings, .trackRange, DAWVerticalFaderView, .body (+17 more)

### Community 14 - "TrackOrganizationService"
Cohesion: 0.20
Nodes (11): ImportedStem, ImportPlacement, appendNewGroup, insertIntoGroup, Int, String, TimeInterval, URL (+3 more)

### Community 15 - ".log"
Cohesion: 0.12
Nodes (17): SectionLoopDiagnostics, SectionTriggerDiagnostics, AVAudioFrameCount, AVAudioFramePosition, Bool, Double, Int, Int64 (+9 more)

### Community 16 - "WaveformClipView"
Cohesion: 0.07
Nodes (42): CheckedContinuation, Bool, Double, Float, Int, MainActor, Never, Sendable (+34 more)

### Community 17 - "MacOSPlaybackStrategy"
Cohesion: 0.16
Nodes (13): MacOSPlaybackStrategy, .meterTapBufferSize, AudioEngineService, AVAudioFile, AVAudioFrameCount, AVAudioFramePosition, AVAudioPlayerNode, AVAudioTime (+5 more)

### Community 18 - ".applyRestoredProject"
Cohesion: 0.15
Nodes (4): TransportCommands, .body, DAWProject, Content

### Community 19 - "ProjectPersistenceService"
Cohesion: 0.11
Nodes (20): SavedProjectDocument, Int, JSONDecoder, .projectDecoder, JSONEncoder, .pretty, ManifestFile, ProjectPersistenceError (+12 more)

### Community 20 - "TimeInterval"
Cohesion: 0.28
Nodes (5): Bool, Double, TimeInterval, TransportClock, TransportDisplayClock

### Community 21 - "UUID"
Cohesion: 0.15
Nodes (9): AVAudioMixerNode, AVAudioPCMBuffer, AVAudioUnitTimePitch, MeterPeakBuffer, AudioClip, Double, Float, UUID (+1 more)

### Community 22 - "WorkspaceViewModel"
Cohesion: 0.04
Nodes (38): AudioOutputDevice, CGFloat, ClosedRange, Int, SectionPlaybackMode, Set, TimelineEditTool, Timer (+30 more)

### Community 23 - "What You Must Do When Invoked"
Cohesion: 0.08
Nodes (24): For /graphify add and --watch, For /graphify query, For the commit hook and native AGENTS.md integration, For --update and --cluster-only, /graphify, Honesty Rules, Interpreter guard for subcommands, Part A - Structural extraction for code files (+16 more)

### Community 24 - "SimplePlayProjectArchive"
Cohesion: 0.16
Nodes (15): Asset, SimplePlayProjectArchive, SimplePlayProjectArchiveError, corruptAsset, corruptManifest, .errorDescription, invalidArchive, Bool (+7 more)

### Community 25 - "StandardTrackRole"
Cohesion: 0.08
Nodes (25): StandardTrackRole, acousticGuitar, backingVocal, bass, brass, click, countIn, cue (+17 more)

### Community 26 - "Sendable"
Cohesion: 0.19
Nodes (22): Codable, Equatable, Sendable, PersistedClip, PersistedProject, PersistedTrack, Bool, Decoder (+14 more)

### Community 27 - "ArrangementSection"
Cohesion: 0.16
Nodes (15): ArrangementSection, .color, .duration, .hasLyricSlideLink, Bool, Decoder, Int, String (+7 more)

### Community 28 - "TrackGroup"
Cohesion: 0.15
Nodes (15): CodingKeys, horizontalOffset, id, importedAt, name, pitchSemitones, volume, Date (+7 more)

### Community 29 - "TimeInterval"
Cohesion: 0.16
Nodes (6): ArmedBoundaryJump, .hasArmedBoundaryJump, Bool, Int, SectionLoopContext, TimeInterval

### Community 30 - "TimeInterval"
Cohesion: 0.10
Nodes (11): Bool, TimeInterval, ArrangementSection, Bool, SectionLoopContext, TimeInterval, TimelineScrollAlignment, center (+3 more)

### Community 31 - ".standardize"
Cohesion: 0.20
Nodes (7): StandardizedName, Bool, Int, String, URL, TrackNameStandardizer, TrackNameStandardizerTests

### Community 32 - "AudioTrack"
Cohesion: 0.22
Nodes (10): AudioTrack, .color, .displayName, Bool, Double, String, UUID, .duration (+2 more)

### Community 33 - "MixerPanelView"
Cohesion: 0.06
Nodes (36): MixerPanelView, .body, .channelFaderHeight, .channelFaderWidth, .channelStripWidth, .groupDivider, .isCompact, .masterFaderHeight (+28 more)

### Community 34 - "WorkspaceLayoutContext"
Cohesion: 0.06
Nodes (33): EnvironmentKey, ScenePhase, .body, iPhoneWorkspaceView, .body, .phoneLayout, StandardWorkspaceView, .workspaceLayout (+25 more)

### Community 35 - ".commitSectionDragPreview"
Cohesion: 0.27
Nodes (4): SectionDragKind, move, resizeEnd, resizeStart

### Community 36 - ".importAudioFiles"
Cohesion: 0.09
Nodes (12): Error, Result, ImportPanelKind, audioFiles, folder, String, Content, TimelineAudioDropModifier (+4 more)

### Community 37 - "SectionCueClockTests"
Cohesion: 0.17
Nodes (6): SectionCueClock, AVAudioTime, Bool, TimeInterval, UInt64, SectionCueClockTests

### Community 38 - "TimelineOverviewBar"
Cohesion: 0.19
Nodes (13): Bool, CGFloat, CGSize, ClosedRange, Gesture, TimeInterval, TimelineOverviewBar, .barHeight (+5 more)

### Community 39 - "TransportBarView"
Cohesion: 0.13
Nodes (16): Bool, CGFloat, String, Void, TransportBarStyle, phoneBottomDock, standard, TransportBarView (+8 more)

### Community 40 - ".frames"
Cohesion: 0.22
Nodes (9): AVAudioFrameCount, AVAudioFramePosition, AVAudioTime, Int64, LoopBodyBounds, .frameCount, LoopTrackScheduleState, ScheduledClip (+1 more)

### Community 41 - "LyricSlideCatalogItem"
Cohesion: 0.18
Nodes (10): Decoder, Encoder, LyricSlideCatalog, LyricSlideCatalogItem, .displayText, .id, Int, UUID (+2 more)

### Community 42 - ".isNodeConnected"
Cohesion: 0.18
Nodes (4): AVAudioNode, AVAudioPlayerNode, ObjectIdentifier, .playbackGraphIsHealthy

### Community 43 - ".clipContent"
Cohesion: 0.07
Nodes (37): G, GraphicsContext, CGFloat, String, TimeInterval, TimelineRulerScale, ClipDragInteractionModifier, ClipSelectionModifiers (+29 more)

### Community 44 - "CodingKeys"
Cohesion: 0.13
Nodes (15): CodingKeys, colorHex, endTime, id, lyricDocumentID, lyricSlideID, lyricSlideOrder, midiChannel (+7 more)

### Community 45 - "SwiftUI"
Cohesion: 0.10
Nodes (16): Commands, ContentView, EditCommands, FileCommands, Binding, Bool, String, WorkspaceSettingsView (+8 more)

### Community 46 - "TimelineWorkspacePanel"
Cohesion: 0.14
Nodes (28): ScrollPosition, PinnedTimelineHeaderStrip, .standardMarkerHeaderRow, .timeHeaderCell, PlayheadView, .body, .playheadDragGesture, Bool (+20 more)

### Community 48 - "AudioEngineServiceMacOS.swift"
Cohesion: 0.25
Nodes (5): AudioUnit, CoreAudio, AudioEngineService, AVAudioTime, TimeInterval

### Community 49 - "TimelineScaleControls"
Cohesion: 0.16
Nodes (11): Bool, CGFloat, Double, String, Void, TimelineScaleControls, .buttonCornerRadius, .buttonSize (+3 more)

### Community 50 - ".resolve"
Cohesion: 0.24
Nodes (5): PlaybackDeltaPolicy, Resolution, Bool, TimeInterval, PlaybackDeltaPolicyTests

### Community 51 - "SimplePlay"
Cohesion: 0.23
Nodes (3): SimplePlay, ProjectArchiveTests, Testing

### Community 52 - "SectionPlaybackCoordinatorTests"
Cohesion: 0.14
Nodes (13): RepeatBoundaryPhase, followAudioDelta, repeatArmed, repeatBoundary, SectionPlaybackCoordinator, ArrangementSection, Bool, Double (+5 more)

### Community 53 - "SectionLyricLinkSheet"
Cohesion: 0.09
Nodes (20): .expandedPanel, .lyricCatalogStatus, SectionAssignCardView, .midiLabel, .slideLabel, SectionAssignSheetView, .body, .lyricStatusBanner (+12 more)

### Community 54 - "LyricPlaySyncMessage"
Cohesion: 0.24
Nodes (8): Data, JSONEncoder, serverError, LinkSectionCommand, LyricPlaySync, LyricPlaySyncCodec, LyricPlaySyncMessage, ShowSlideCommand

### Community 55 - "ProjectEditHistory"
Cohesion: 0.10
Nodes (12): ProjectEditHistory, .canRedo, .canUndo, Bool, Int, ProjectEditHistoryTests, SimplePlayUITests, SimplePlayUITestsLaunchTests (+4 more)

### Community 56 - "TransportRightToolbar"
Cohesion: 0.11
Nodes (22): .body, .phoneRightControls, Panel, mainVolume, none, timelineScale, Binding, Bool (+14 more)

### Community 57 - "LyricPlaySyncClient"
Cohesion: 0.22
Nodes (8): NWBrowser, NWEndpoint, LyricPlaySyncClient, Never, Set, TimeInterval, Void, Task

### Community 58 - "LyricSlidePickerCard"
Cohesion: 0.12
Nodes (20): Identifiable, LyricSlideAssignment, LyricSlideAssignmentState, .isAvailable, LyricSlidePickerCard, .accessibilityLabel, .body, .cardBackground (+12 more)

### Community 59 - "MIDIOutputService"
Cohesion: 0.23
Nodes (6): CoreMIDI, MIDIPacketList, MIDIOutputService, Bool, MIDIEndpointRef, UInt8

### Community 60 - "View"
Cohesion: 0.24
Nodes (12): SingleLaneMarkerHeaderCell, .body, SingleLaneStackedClipsLane, .body, SingleLaneTimelineViews, SingleLaneTrackHeaderCell, .body, Bool (+4 more)

### Community 61 - "AudioSettings"
Cohesion: 0.06
Nodes (33): AnyObject, AVAudioSession, Double, AudioOutputDevice, AudioSampleRate, .displayName, .id, rate44100 (+25 more)

### Community 62 - "DAWTheme"
Cohesion: 0.08
Nodes (26): Glass, .assignButton, .assignModeHeader, .assignModeToggle, .collapsedBarContent, .learnBanner, AudioDropOverlay, .body (+18 more)

### Community 63 - "LyricPlaySyncTransportError"
Cohesion: 0.14
Nodes (13): LocalizedError, Network, ConnectionState, connected, failed, idle, searching, LyricPlaySyncTransportError (+5 more)

### Community 64 - "iPhoneMIDIMappingBarView"
Cohesion: 0.23
Nodes (8): iPhoneMIDIMappingBarView, .collapsedBar, .sectionQuickPads, ArrangementSection, Bool, Color, String, Void

### Community 65 - "SectionPlaybackMode"
Cohesion: 0.13
Nodes (13): CaseIterable, SectionPlaybackMode, continueTimeline, continueToNext, .displayName, .id, oneShot, repeatSection (+5 more)

### Community 66 - "TrackPitchControlView"
Cohesion: 0.14
Nodes (15): .actionButtons, Binding, Bool, Double, String, UUID, TrackPitchControlView, .body (+7 more)

### Community 67 - "Audio Engine — Agent Guide"
Cohesion: 0.17
Nodes (11): Architecture (do not collapse), Audio Engine — Agent Guide, Before you edit, iOS session rules (critical), Log messages, macOS device rules, Playback sync invariants (never break), Red flags (stop and reconsider) (+3 more)

### Community 68 - "TimelineScrollCoordinator"
Cohesion: 0.25
Nodes (7): Bool, CGFloat, Content, TimelineHorizontalMirror, .body, TimelineScrollCoordinator, .isInteracting

### Community 69 - "AppKit"
Cohesion: 0.07
Nodes (24): App, AppKit, Notification, NSApplicationDelegate, NSEvent, NSObject, NSView, NSViewRepresentable (+16 more)

### Community 70 - "graphify reference: extra exports and benchmark"
Cohesion: 0.22
Nodes (8): graphify reference: extra exports and benchmark, Step 6b - Wiki (only if --wiki flag), Step 7 - Neo4j export (only if --neo4j or --neo4j-push flag), Step 7a - FalkorDB export (only if --falkordb or --falkordb-push flag), Step 7b - SVG export (only if --svg flag), Step 7c - GraphML export (only if --graphml flag), Step 7d - MCP server (only if --mcp flag), Step 8 - Token reduction benchmark (only if total_words > 5000)

### Community 71 - ".body"
Cohesion: 0.22
Nodes (8): .body, Content, View, View, WorkspaceKeyboardShortcuts, .historyControls, .historyControls, .timeDisplay

### Community 72 - ".overviewRecessBackground"
Cohesion: 0.24
Nodes (7): Path, .overviewBackground, DAWTransportChrome, CGFloat, Double, LinearGradient, View

### Community 73 - "Color"
Cohesion: 0.30
Nodes (5): .defaultColor, Color, Int, String, TrackColorPalette

### Community 74 - ".boundaryCueTime"
Cohesion: 0.50
Nodes (3): AudioEngineService, AVAudioTime, TimeInterval

### Community 75 - "graphify reference: query, path, explain"
Cohesion: 0.33
Nodes (5): For /graphify explain, For /graphify path, graphify reference: query, path, explain, Step 0 — Constrained query expansion (REQUIRED before traversal), Step 1 — Traversal

### Community 76 - "SectionStandbyCoordinator"
Cohesion: 0.08
Nodes (16): .isAnyPlayerPlaying, Lane, SectionNextIntent, continuation, jump, loopBody, none, SectionStandbyCoordinator (+8 more)

### Community 77 - "Section Playback — Agent Guide"
Cohesion: 0.12
Nodes (16): Arm (tap 2), Constants (keep in sync), Disable (tap while repeat is armed, before wrap), Extra cycle → song (no third tap), Flags (do not overload), Forbidden “fixes”, If you must change this, Layers (do not collapse) (+8 more)

### Community 78 - ".startMIDILearn"
Cohesion: 0.28
Nodes (3): MIDIInputEvent, MIDILearnTarget, .sectionMarkerMenuButtons

### Community 79 - "LyricPlaySyncMessageKind"
Cohesion: 0.22
Nodes (9): LyricPlaySyncMessageKind, catalogRequest, catalogResponse, error, linkSection, linkSectionAck, presence, presenceAck (+1 more)

### Community 80 - "CodingKeys"
Cohesion: 0.25
Nodes (8): CodingKey, CodingKeys, linkedSectionID, order, preview, slideID, tag, text

### Community 81 - "graphify reference: add a URL and watch a folder"
Cohesion: 0.50
Nodes (3): For /graphify add, For --watch, graphify reference: add a URL and watch a folder

### Community 82 - "graphify reference: commit hook and native AGENTS.md integration"
Cohesion: 0.50
Nodes (3): For git commit hook, For native AGENTS.md integration, graphify reference: commit hook and native AGENTS.md integration

### Community 83 - "graphify reference: incremental update and cluster-only"
Cohesion: 0.50
Nodes (3): For --cluster-only, For --update (incremental re-extraction), graphify reference: incremental update and cluster-only

### Community 84 - "PropertiesSidebarView"
Cohesion: 0.13
Nodes (19): PropertiesSidebarView, .body, .masterVolumeBinding, .pitchIsOriginal, .pitchLabel, .sectionCreationHint, .selectedDeviceID, .selectedSection (+11 more)

### Community 87 - ".saveProject"
Cohesion: 0.36
Nodes (4): SavedProjectDocument, String, .body, SimplePlayProjectFileDocument

### Community 89 - ".stem"
Cohesion: 0.29
Nodes (4): Int, String, TimeInterval, TrackOrganizationServiceTests

### Community 90 - "UUID"
Cohesion: 0.06
Nodes (19): AudioTrack, ClipEditService, ClipMovePreview, Item, .id, AudioClip, Float, UInt8 (+11 more)

### Community 91 - "UIKitToolbarMenuButtonRepresentable"
Cohesion: 0.33
Nodes (7): Coordinator, Context, String, Void, UIKitToolbarMenuButtonRepresentable, UIButton, UIViewRepresentable

### Community 92 - "SupportedAudioFormats"
Cohesion: 0.05
Nodes (37): FileDocument, FileWrapper, ReadConfiguration, SimplePlayProjectFileDocument, .readableContentTypes, Data, DropURLLoader, NSItemProvider (+29 more)

### Community 93 - "MIDINoteAssignment"
Cohesion: 0.24
Nodes (8): MIDILearnTarget, section, MIDINoteAssignment, .displayName, Bool, String, UInt8, UUID

### Community 94 - "MIDIMappingBarView.swift"
Cohesion: 0.33
Nodes (5): ButtonStyle, SectionMappingAssignButtonStyle, SectionMappingCardGlow, SectionMappingPlayButtonStyle, Content

### Community 95 - ".prepareMIDIInput"
Cohesion: 0.29
Nodes (5): MIDISourceInfo, .devicePickerButton, .phoneDevicePickerSheet, .devicePicker, .mappingRefreshControl

### Community 96 - "SidebarLabeledRow"
Cohesion: 0.40
Nodes (4): SidebarLabeledRow, .body, Content, String

### Community 103 - "SectionPlaybackStatus"
Cohesion: 0.40
Nodes (5): SectionPlaybackStatus, idle, playing, queued, repeatingAtEnd

### Community 105 - "PitchShiftSettings"
Cohesion: 0.22
Nodes (6): PitchShiftSettings, AVAudioUnitTimePitch, Bool, Double, Float, PitchShiftSettingsTests

### Community 107 - "SectionMarkerChipView"
Cohesion: 0.06
Nodes (50): Gesture, NSCursor, Bool, String, TimeInterval, TimeFormatting, .formattedCurrentTime, .formattedDuration (+42 more)

### Community 108 - "AudioEngineError"
Cohesion: 0.29
Nodes (7): AudioEngineError, clipLoadFailed, deviceSelectionFailed, engineStartFailed, .errorDescription, noPlayableClips, playbackUnavailable

### Community 109 - "View"
Cohesion: 0.09
Nodes (28): Configuration, View, DAWIconToolbarButtonStyle, DAWLabeledToolbarButtonStyle, Bool, Configuration, Content, String (+20 more)

### Community 111 - "TimeInterval"
Cohesion: 0.16
Nodes (13): AdvanceOutcome, arrangementStopped, none, reachedProjectEnd, sectionHandled, AdvanceResult, PlaybackState, continuingTimeline (+5 more)

### Community 116 - "Foundation"
Cohesion: 0.14
Nodes (5): AVFoundation, Foundation, Observation, os, PlatformPlaybackStrategyFactory

### Community 119 - "SectionTriggerResult"
Cohesion: 0.40
Nodes (5): SectionTriggerResult, activatedImmediately, disabledRepeatAtEnd, enabledRepeatAtEnd, queuedForEnd

## Knowledge Gaps
- **444 isolated node(s):** `idle`, `playingSection`, `repeatingSectionAtEnd`, `waitingToJump`, `continuingTimeline` (+439 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **25 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `WorkspaceViewModel` connect `WorkspaceViewModel` to `ArrangementPlaybackEngine`, `MIDIInputService`, `.tick`, `TrackHeaderRowView`, `iPhoneTimelinePanel`, `AudioImportService`, `AudioEngineService`, `DAWProject`, `MIDIMappingBarView`, `.applyRestoredProject`, `ProjectPersistenceService`, `TimeInterval`, `TimeInterval`, `MixerPanelView`, `WorkspaceLayoutContext`, `.commitSectionDragPreview`, `.importAudioFiles`, `TimelineOverviewBar`, `TransportBarView`, `LyricSlideCatalogItem`, `.clipContent`, `SwiftUI`, `TimelineWorkspacePanel`, `TimelineScaleControls`, `SectionLyricLinkSheet`, `ProjectEditHistory`, `TransportRightToolbar`, `LyricPlaySyncClient`, `LyricSlidePickerCard`, `View`, `AudioSettings`, `DAWTheme`, `iPhoneMIDIMappingBarView`, `TrackPitchControlView`, `AppKit`, `.body`, `.startMIDILearn`, `PropertiesSidebarView`, `.saveProject`, `UUID`, `SupportedAudioFormats`, `.prepareMIDIInput`, `.requestNewProject`, `Double`, `SectionPlaybackStatus`, `SectionMarkerChipView`, `View`, `Foundation`?**
  _High betweenness centrality (0.430) - this node is a cross-community bridge._
- **Why does `AudioEngineService` connect `AudioEngineService` to `AudioClip`, `.frames`, `.isNodeConnected`, `SectionStandbyCoordinator`, `.play`, `TimeInterval`, `Foundation`, `UUID`, `WorkspaceViewModel`, `AudioSettings`?**
  _High betweenness centrality (0.163) - this node is a cross-community bridge._
- **Why does `Foundation` connect `Foundation` to `MIDIInputService`, `.tick`, `AudioClip`, `AudioImportService`, `DAWVerticalFaderView`, `TrackOrganizationService`, `.log`, `WaveformClipView`, `ProjectPersistenceService`, `TimeInterval`, `SimplePlayProjectArchive`, `StandardTrackRole`, `Sendable`, `ArrangementSection`, `TrackGroup`, `.standardize`, `SwiftUI`, `AudioEngineServiceMacOS.swift`, `.resolve`, `SimplePlay`, `SectionPlaybackCoordinatorTests`, `LyricPlaySyncMessage`, `ProjectEditHistory`, `MIDIOutputService`, `AudioSettings`, `LyricPlaySyncTransportError`, `SectionPlaybackMode`, `AppKit`, `SupportedAudioFormats`, `MIDINoteAssignment`, `WaveformLOD.swift`, `SnapGrid.swift`, `PitchShiftSettings`, `SectionMarkerChipView`?**
  _High betweenness centrality (0.121) - this node is a cross-community bridge._
- **Are the 15 inferred relationships involving `WorkspaceViewModel` (e.g. with `ArrangementPlaybackEngine` and `AudioEngineService`) actually correct?**
  _`WorkspaceViewModel` has 15 INFERRED edges - model-reasoned connections that need verification._
- **Are the 3 inferred relationships involving `AudioEngineService` (e.g. with `SectionAudioCache` and `SectionStandbyCoordinator`) actually correct?**
  _`AudioEngineService` has 3 INFERRED edges - model-reasoned connections that need verification._
- **Are the 61 inferred relationships involving `DAWProject` (e.g. with `.configure()` and `.trackOrderLookup()`) actually correct?**
  _`DAWProject` has 61 INFERRED edges - model-reasoned connections that need verification._
- **What connects `idle`, `playingSection`, `repeatingSectionAtEnd` to the rest of the system?**
  _444 weakly-connected nodes found - possible documentation gaps or missing edges._