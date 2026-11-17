# Graph Report - SimplePlay  (2026-11-17)

## Corpus Check
- 148 files · ~88,027 words
- Verdict: corpus is large enough that graph structure adds value.
- Unclassified: 14 file(s) not represented in the graph (top: (none) 3, .mdc 3, .xcstrings 2)

## Summary
- 2955 nodes · 7572 edges · 132 communities (123 shown, 9 thin omitted)
- Extraction: 90% EXTRACTED · 10% INFERRED · 0% AMBIGUOUS · INFERRED: 776 edges (avg confidence: 0.82)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `7461770b`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- WorkspaceViewModel
- MIDIInputService
- .text
- WaveformClipView
- String
- AudioClip
- WaveformCache
- SectionMarkerChipView
- SectionStandbyCoordinator
- AudioEngineService
- TimeInterval
- MixerPanelView
- MIDIMappingBarView
- DAWProject
- ArrangementPlaybackEngine
- SidebarPanel
- DAWVerticalFaderView
- TimeInterval
- ArrangementSection
- LvoqPlaybackProjectArchive
- .log
- CGFloat
- .applyRestoredProject
- What You Must Do When Invoked
- SwiftUI
- .tick
- Equatable
- TrackHeaderRowView
- TrackGroup
- AudioImportService
- TransportBarView
- ProjectPersistenceService
- SectionPlaybackCoordinatorTests
- TrackOrganizationService
- Section
- CodingKeys
- .importAudioFiles
- StandardTrackRole
- TimelineOverviewBar
- AudioSettings
- UUID
- Sendable
- .isNodeConnected
- TimelineView.swift
- Bool
- IOSPlaybackStrategy
- TimelineWorkspacePanel
- MacOSPlaybackStrategy
- SectionCueClockTests
- .standardize
- .tracks
- LvoqPlayback
- TransportRightToolbar
- Lyric
- AudioOutputDevice
- ProjectEditHistory
- Color
- LyricPlaySyncClient
- AudioSampleRate
- LyricSlidePickerCard
- TimeInterval
- PropertiesSidebarView
- DAWTheme
- SectionLyricLinkSheet
- TrackRole
- SectionPlaybackMode
- UIKitToolbarMenuButtonRepresentable
- ProjectPersistenceError
- WorkspaceLayoutContext
- .clipContent
- graphify reference: extra exports and benchmark
- iPhoneTimelinePanel
- ViewModifier
- TopToolbarView
- Errors
- graphify reference: query, path, explain
- File
- TickCommand
- Section Playback — Agent Guide
- .body
- TimeInterval
- graphify reference: add a URL and watch a folder
- graphify reference: commit hook and native AGENTS.md integration
- graphify reference: incremental update and cluster-only
- .present
- graphify reference: GitHub clone and cross-repo merge
- graphify reference: transcribe video and audio
- CodingKeys
- extraction-spec.md
- MIDINoteAssignment
- TimelineScaleControls
- PinnedTimelineHeaderStrip
- LvoqPlaybackProjectFileDocument
- TrackPitchControlView
- PitchShiftSettings
- SingleLaneTrackHeaderCell
- Pitch
- Audio Engine — Agent Guide
- .armLinearContinuationAtSectionEnd
- .resolve
- Audio
- .hex
- .stem
- AudioDropTargetModifier
- AVAudioTime
- SupportedAudioFormats
- .presentImportPanel
- TopToolbarView.swift
- WorkspacePresentationModifier
- View
- Mixer
- UniformTypeIdentifiers
- CodingKeys
- .loadURLs
- Selection
- Settings
- Foundation
- WorkspaceLifecycleModifier
- AudioEngineServiceIOS.swift
- ImportToolbarMenuButton.swift
- SectionTriggerResult
- AudioEngineService
- SectionPlaybackStatus
- .sessionManagement
- .updateViewportWidth
- AppBranding
- AppLanguageStore
- MIDILearnTarget
- App
- Snap
- .phoneControlButton
- LvoqPlaybackTests.swift

## God Nodes (most connected - your core abstractions)
1. `WorkspaceViewModel` - 356 edges
2. `AudioEngineService` - 171 edges
3. `DAWProject` - 124 edges
4. `ArrangementSection` - 90 edges
5. `DAWTheme` - 69 edges
6. `ArrangementPlaybackEngine` - 67 edges
7. `MIDIMappingBarView` - 54 edges
8. `L10n` - 53 edges
9. `AudioTrack` - 51 edges
10. `AudioClip` - 43 edges

## Surprising Connections (you probably didn't know these)
- `makeSection()` --calls--> `ArrangementSection`  [EXTRACTED]
  LvoqPlaybackTests/PlaybackTransportControllerTests.swift → LvoqPlayback/Core/Models/ArrangementSection.swift
- `TrackOrganizationServiceTests` --calls--> `TrackOrganizationService`  [EXTRACTED]
  LvoqPlaybackTests/TrackOrganizationServiceTests.swift → LvoqPlayback/Core/Services/TrackOrganizationService.swift
- `.collapsedBar` --references--> `WorkspaceViewModel`  [INFERRED]
  LvoqPlayback/Features/Workspace/Views/iPhoneMIDIMappingBarView.swift → LvoqPlayback/Features/Workspace/ViewModels/WorkspaceViewModel.swift
- `.body` --calls--> `TrackLaneView`  [INFERRED]
  LvoqPlayback/Features/Workspace/Views/iPhoneTimelinePanel.swift → LvoqPlayback/Features/Workspace/Views/TimelineView.swift
- `.phoneRightControls` --calls--> `TransportRightToolbar`  [INFERRED]
  LvoqPlayback/Features/Workspace/Views/TransportBarView.swift → LvoqPlayback/Features/Workspace/Views/TransportRightToolbar.swift

## Import Cycles
- None detected.

## Communities (132 total, 9 thin omitted)

### Community 0 - "WorkspaceViewModel"
Cohesion: 0.05
Nodes (34): Float, Int, Set, UInt8, UUID, WorkspaceViewModel, .activePlaybackSection, .canRedo (+26 more)

### Community 1 - "MIDIInputService"
Cohesion: 0.08
Nodes (24): CoreMIDI, MIDIInputEvent, MIDIInputService, MIDISourceInfo, .id, Bool, Int, Int32 (+16 more)

### Community 2 - ".text"
Cohesion: 0.05
Nodes (70): Common, .cancel, .change, .close, .delete, .done, .error, .fit (+62 more)

### Community 3 - "WaveformClipView"
Cohesion: 0.08
Nodes (33): clips, Float, Int, TimeInterval, URL, WaveformClipPeakStore, Bool, Double (+25 more)

### Community 4 - "String"
Cohesion: 0.07
Nodes (28): CVarArg, Accessibility, .queueAudio, .splitHint, .trackReorder, .trackVolume, MIDI, .allInputs (+20 more)

### Community 5 - "AudioClip"
Cohesion: 0.06
Nodes (39): AVAudioFormat, Hashable, AudioClip, .endTime, Int, String, TimeInterval, URL (+31 more)

### Community 6 - "WaveformCache"
Cohesion: 0.23
Nodes (14): CheckedContinuation, Bool, Double, Float, Int, MainActor, Never, Sendable (+6 more)

### Community 7 - "SectionMarkerChipView"
Cohesion: 0.06
Nodes (47): Bool, String, TimeInterval, TimeFormatting, .formattedCurrentTime, .formattedDuration, .timelineGuideOverlays, ResizeEdge (+39 more)

### Community 8 - "SectionStandbyCoordinator"
Cohesion: 0.08
Nodes (16): .isAnyPlayerPlaying, Lane, SectionNextIntent, continuation, jump, loopBody, none, SectionStandbyCoordinator (+8 more)

### Community 9 - "AudioEngineService"
Cohesion: 0.05
Nodes (29): AVAudioEngine, AVAudioUnitEQ, AudioEnginePlatformServices, AudioEngineService, .activeSectionLoopContext, .armedBoundaryJumpIsPreScheduled, .avEngine, .engineIsRunning (+21 more)

### Community 10 - "TimeInterval"
Cohesion: 0.10
Nodes (9): Bool, TimeInterval, Bool, TimeInterval, Timer, TimelineScrollAlignment, center, leading (+1 more)

### Community 11 - "MixerPanelView"
Cohesion: 0.06
Nodes (37): MixerPanelView, .body, .channelFaderHeight, .channelFaderWidth, .channelStripWidth, .groupDivider, .isCompact, .masterFaderHeight (+29 more)

### Community 12 - "MIDIMappingBarView"
Cohesion: 0.07
Nodes (30): Animation, AnyTransition, ButtonStyle, .assignButton, MIDIMappingBarView, .assignModeHeader, .assignModeToggle, .assignModeToggleTitle (+22 more)

### Community 13 - "DAWProject"
Cohesion: 0.10
Nodes (28): AudioTrack, .color, .displayName, Bool, Double, String, UUID, DAWProject (+20 more)

### Community 14 - "ArrangementPlaybackEngine"
Cohesion: 0.20
Nodes (8): ArrangementPlaybackEngine, UInt8, UUID, ArrangementPlaybackEngineAdvanceTests, ArrangementPlaybackEngineTests, String, TimeInterval, UInt8

### Community 15 - "SidebarPanel"
Cohesion: 0.09
Nodes (38): .mappingRefreshControl, .languageSettings, .playbackSettings, .sectionEditor, .selectedMarkerEditor, .selectionInfo, .trackPitch, .volumeControls (+30 more)

### Community 16 - "DAWVerticalFaderView"
Cohesion: 0.09
Nodes (25): ClosedRange, Double, Float, String, TrackVolumeSettings, .trackRange, DAWVerticalFaderView, .body (+17 more)

### Community 17 - "TimeInterval"
Cohesion: 0.20
Nodes (7): SectionLoopContext, .duration, TimeInterval, UUID, ArmedBoundaryJump, TimeInterval, PlatformPlaybackStrategy

### Community 18 - "ArrangementSection"
Cohesion: 0.10
Nodes (23): ArrangementSection, .color, .duration, .hasLyricSlideLink, Bool, Decoder, Int, String (+15 more)

### Community 19 - "LvoqPlaybackProjectArchive"
Cohesion: 0.16
Nodes (16): Asset, LvoqPlaybackProjectArchive, LvoqPlaybackProjectArchiveError, corruptAsset, corruptManifest, .errorDescription, invalidArchive, Bool (+8 more)

### Community 20 - ".log"
Cohesion: 0.11
Nodes (17): SectionLoopDiagnostics, SectionTriggerDiagnostics, AVAudioFrameCount, AVAudioFramePosition, Bool, Double, Int, Int64 (+9 more)

### Community 21 - "CGFloat"
Cohesion: 0.09
Nodes (11): SectionDragKind, move, resizeEnd, resizeStart, CGFloat, ClosedRange, TimelineScrollRequest, .minimumTimelineZoom (+3 more)

### Community 22 - ".applyRestoredProject"
Cohesion: 0.11
Nodes (8): Content, View, TransportCommands, .body, View, WorkspaceKeyboardShortcuts, .transportControls, Content

### Community 23 - "What You Must Do When Invoked"
Cohesion: 0.08
Nodes (24): For /graphify add and --watch, For /graphify query, For the commit hook and native AGENTS.md integration, For --update and --cluster-only, /graphify, Honesty Rules, Interpreter guard for subcommands, Part A - Structural extraction for code files (+16 more)

### Community 24 - "SwiftUI"
Cohesion: 0.08
Nodes (16): AppKit, Commands, ContentView, EditCommands, .body, FileCommands, LvoqPlaybackApp, .body (+8 more)

### Community 25 - ".tick"
Cohesion: 0.16
Nodes (14): PlaybackTransportController, Bool, Date, Double, TimeInterval, TickInput, TickOutput, TickState (+6 more)

### Community 26 - "Equatable"
Cohesion: 0.21
Nodes (19): Codable, Equatable, PersistedClip, PersistedProject, PersistedTrack, Bool, Decoder, Double (+11 more)

### Community 27 - "TrackHeaderRowView"
Cohesion: 0.09
Nodes (28): Density, compact, full, minimal, Binding, Bool, CGFloat, Double (+20 more)

### Community 28 - "TrackGroup"
Cohesion: 0.15
Nodes (16): CodingKey, CodingKeys, horizontalOffset, id, importedAt, name, pitchSemitones, volume (+8 more)

### Community 29 - "AudioImportService"
Cohesion: 0.12
Nodes (18): AudioFileStorageService, String, URL, UUID, AudioImportError, emptySelection, .errorDescription, storageUnavailable (+10 more)

### Community 30 - "TransportBarView"
Cohesion: 0.09
Nodes (23): .historyControls, iPhoneWorkspaceView, .body, .phoneLayout, .historyControls, Void, Bool, CGFloat (+15 more)

### Community 31 - "ProjectPersistenceService"
Cohesion: 0.17
Nodes (9): SavedProjectDocument, Int, ProjectPersistenceService, Bool, Data, URL, UUID, String (+1 more)

### Community 32 - "SectionPlaybackCoordinatorTests"
Cohesion: 0.14
Nodes (10): RepeatBoundaryPhase, followAudioDelta, repeatArmed, repeatBoundary, SectionPlaybackCoordinator, Bool, Double, TimeInterval (+2 more)

### Community 33 - "TrackOrganizationService"
Cohesion: 0.20
Nodes (11): ImportedStem, ImportPlacement, appendNewGroup, insertIntoGroup, Int, String, TimeInterval, URL (+3 more)

### Community 34 - "Section"
Cohesion: 0.08
Nodes (25): Section, .assignMIDI, .assignMIDIPad, .createHintDrag, .createHintTouch, .creationHintIOS, .creationHintMac, .defaultName (+17 more)

### Community 35 - "CodingKeys"
Cohesion: 0.08
Nodes (25): CodingKeys, audioSettings, colorHex, id, isLocked, isMuted, isPitchEnabled, isSnapEnabled (+17 more)

### Community 36 - ".importAudioFiles"
Cohesion: 0.11
Nodes (6): Error, String, URL, Content, .body, Result

### Community 37 - "StandardTrackRole"
Cohesion: 0.08
Nodes (25): StandardTrackRole, acousticGuitar, backingVocal, bass, brass, click, countIn, cue (+17 more)

### Community 38 - "TimelineOverviewBar"
Cohesion: 0.11
Nodes (21): Bool, CGFloat, CGSize, ClosedRange, Gesture, TimeInterval, TimelineOverviewBar, .barHeight (+13 more)

### Community 39 - "AudioSettings"
Cohesion: 0.16
Nodes (10): AnyObject, AVAudioSession, AudioSettings, .usesCustomOutputDevice, Bool, AudioEngineServiceHost, AudioEngineServiceIOS, Bool (+2 more)

### Community 40 - "UUID"
Cohesion: 0.11
Nodes (15): AVAudioMixerNode, AudioEngineError, clipLoadFailed, deviceSelectionFailed, engineStartFailed, .errorDescription, noPlayableClips, playbackUnavailable (+7 more)

### Community 41 - "Sendable"
Cohesion: 0.10
Nodes (26): LinkSectionCommand, LyricPlaySync, LyricPlaySyncMessage, LyricPlaySyncMessageKind, catalogRequest, catalogResponse, error, linkSection (+18 more)

### Community 43 - "TimelineView.swift"
Cohesion: 0.08
Nodes (31): G, GraphicsContext, CGFloat, String, TimeInterval, TimelineRulerScale, ClipDragInteractionModifier, ClipSelectionModifiers (+23 more)

### Community 44 - "Bool"
Cohesion: 0.24
Nodes (10): LoopBodyBounds, .frameCount, LoopTrackScheduleState, ScheduledClip, AVAudioFrameCount, AVAudioFramePosition, Bool, Int (+2 more)

### Community 45 - "IOSPlaybackStrategy"
Cohesion: 0.16
Nodes (13): IOSPlaybackStrategy, .meterTapBufferSize, AudioEngineService, AVAudioFile, AVAudioFrameCount, AVAudioFramePosition, AVAudioPlayerNode, AVAudioTime (+5 more)

### Community 46 - "TimelineWorkspacePanel"
Cohesion: 0.22
Nodes (16): Bool, CGFloat, Double, String, TimelineTrackScrollArea, TimelineWorkspacePanel, .isCompact, .laneAreaHeight (+8 more)

### Community 47 - "MacOSPlaybackStrategy"
Cohesion: 0.16
Nodes (13): MacOSPlaybackStrategy, .meterTapBufferSize, AudioEngineService, AVAudioFile, AVAudioFrameCount, AVAudioFramePosition, AVAudioPlayerNode, AVAudioTime (+5 more)

### Community 48 - "SectionCueClockTests"
Cohesion: 0.17
Nodes (6): SectionCueClock, AVAudioTime, Bool, TimeInterval, UInt64, SectionCueClockTests

### Community 49 - ".standardize"
Cohesion: 0.20
Nodes (7): StandardizedName, Bool, Int, String, URL, TrackNameStandardizer, TrackNameStandardizerTests

### Community 50 - ".tracks"
Cohesion: 0.14
Nodes (7): Double, iPhoneTrackHeaderRow, .body, .displayColor, .liveTrack, .mixerScrollWithPinnedMasters, .zoomSection

### Community 52 - "TransportRightToolbar"
Cohesion: 0.12
Nodes (21): .body, Panel, mainVolume, none, timelineScale, Binding, Bool, CGFloat (+13 more)

### Community 53 - "Lyric"
Cohesion: 0.09
Nodes (22): Lyric, .assign, .assignEachCard, .assignEachSection, .assignPadsHelp, .assignSections, .assignSectionsShort, .assignSlide (+14 more)

### Community 54 - "AudioOutputDevice"
Cohesion: 0.18
Nodes (11): AudioOutputDevice, .builtInSpeaker, .systemDefault, AudioDeviceService, AudioDeviceID, Bool, Int, String (+3 more)

### Community 55 - "ProjectEditHistory"
Cohesion: 0.10
Nodes (12): ProjectEditHistory, .canRedo, .canUndo, Bool, Int, ProjectEditHistoryTests, LvoqPlaybackUITests, LvoqPlaybackUITestsLaunchTests (+4 more)

### Community 56 - "Color"
Cohesion: 0.14
Nodes (14): Color, iPhoneMIDIMappingBarView, .collapsedBar, .devicePickerButton, .phoneDevicePickerSheet, .sectionQuickPads, Bool, String (+6 more)

### Community 57 - "LyricPlaySyncClient"
Cohesion: 0.10
Nodes (22): LocalizedError, ConnectionState, connected, failed, idle, searching, LyricPlaySyncClient, LyricPlaySyncTransportError (+14 more)

### Community 58 - "AudioSampleRate"
Cohesion: 0.15
Nodes (11): Double, Identifiable, AudioSampleRate, .displayName, .id, rate44100, rate48000, Int (+3 more)

### Community 59 - "LyricSlidePickerCard"
Cohesion: 0.17
Nodes (17): LyricSlideAssignment, LyricSlideAssignmentState, .isAvailable, LyricSlidePickerCard, .accessibilityLabel, .body, .cardBackground, .cardBorderColor (+9 more)

### Community 60 - "TimeInterval"
Cohesion: 0.22
Nodes (5): Bool, Double, TimeInterval, TransportClock, TransportDisplayClock

### Community 61 - "PropertiesSidebarView"
Cohesion: 0.13
Nodes (19): PropertiesSidebarView, .body, .languageOptions, .languageSelection, .pitchIsOriginal, .pitchLabel, .sectionCreationHint, .sectionPresets (+11 more)

### Community 62 - "DAWTheme"
Cohesion: 0.09
Nodes (23): Glass, .slideText, .learnBanner, .sectionPlayTriggerButton, .body, .standardMarkerHeaderRow, .mainVolumePanel, L10n (+15 more)

### Community 63 - "SectionLyricLinkSheet"
Cohesion: 0.12
Nodes (16): SectionLyricLinkSheet, .body, .header, .headerSubtitle, .liveSection, .unavailableState, String, DAWPrimaryButtonStyle (+8 more)

### Community 64 - "TrackRole"
Cohesion: 0.10
Nodes (20): TrackRole, .acousticGuitar, .backingVocal, .bass, .brass, .click, .countIn, .cue (+12 more)

### Community 65 - "SectionPlaybackMode"
Cohesion: 0.09
Nodes (21): CaseIterable, SectionPlaybackMode, continueTimeline, continueToNext, .displayName, .id, oneShot, repeatSection (+13 more)

### Community 66 - "UIKitToolbarMenuButtonRepresentable"
Cohesion: 0.33
Nodes (7): Coordinator, Context, String, Void, UIKitToolbarMenuButtonRepresentable, UIButton, UIViewRepresentable

### Community 67 - "ProjectPersistenceError"
Cohesion: 0.13
Nodes (15): LyricPlaySyncCodec, Data, Encoder, JSONDecoder, .projectDecoder, JSONEncoder, .pretty, ProjectPersistenceError (+7 more)

### Community 68 - "WorkspaceLayoutContext"
Cohesion: 0.06
Nodes (33): EnvironmentKey, StandardWorkspaceView, .body, .workspaceLayout, .body, EnvironmentValues, .workspaceLayout, Bool (+25 more)

### Community 69 - ".clipContent"
Cohesion: 0.13
Nodes (8): ClipMovePreview, Item, .id, TrackLaneDropModifier, TrackLaneView, .body, .clipHeight, .liveTrack

### Community 70 - "graphify reference: extra exports and benchmark"
Cohesion: 0.22
Nodes (8): graphify reference: extra exports and benchmark, Step 6b - Wiki (only if --wiki flag), Step 7 - Neo4j export (only if --neo4j or --neo4j-push flag), Step 7a - FalkorDB export (only if --falkordb or --falkordb-push flag), Step 7b - SVG export (only if --svg flag), Step 7c - GraphML export (only if --graphml flag), Step 7d - MCP server (only if --mcp flag), Step 8 - Token reduction benchmark (only if total_words > 5000)

### Community 71 - "iPhoneTimelinePanel"
Cohesion: 0.20
Nodes (14): iPhoneSectionsLabelHeaderCell, .body, iPhoneTimelinePanel, .laneAreaHeight, .magnificationGesture, .phonePinnedHeader, .phoneTrackHeaderColumn, .showsSingleLane (+6 more)

### Community 72 - "ViewModifier"
Cohesion: 0.20
Nodes (11): Locale, AppLanguageRootModifier, AppLocaleEnvironmentModifier, AppLocalization, .environmentLocale, .resolvedLocale, Content, String (+3 more)

### Community 73 - "TopToolbarView"
Cohesion: 0.20
Nodes (13): Bool, String, Void, ToolbarMenuButtonStyleModifier, TopToolbarView, .addTrackMenu, .isCompact, .openButton (+5 more)

### Community 74 - "Errors"
Cohesion: 0.11
Nodes (16): Errors, .corruptManifest, .deviceSelection, .emptyResponse, .emptySelection, .engineStart, .invalidArchive, .invalidPackage (+8 more)

### Community 75 - "graphify reference: query, path, explain"
Cohesion: 0.33
Nodes (5): For /graphify explain, For /graphify path, graphify reference: query, path, explain, Step 0 — Constrained query expansion (REQUIRED before traversal), Step 1 — Traversal

### Community 76 - "File"
Cohesion: 0.11
Nodes (18): File, .continueWithoutSaving, .deleteSection, .deleteSectionMessage, .newProject, .newProjectEllipsis, .newProjectMessage, .openProject (+10 more)

### Community 77 - "TickCommand"
Cohesion: 0.12
Nodes (17): ClosedRange, TickCommand, armContinueToNextJump, armLinearContinuation, armQueuedSectionJump, armRepeatAudio, completeRepeatBoundary, none (+9 more)

### Community 78 - "Section Playback — Agent Guide"
Cohesion: 0.12
Nodes (16): Arm (tap 2), Constants (keep in sync), Disable (tap while repeat is armed, before wrap), Extra cycle → song (no third tap), Flags (do not overload), Forbidden “fixes”, If you must change this, Layers (do not collapse) (+8 more)

### Community 79 - ".body"
Cohesion: 0.18
Nodes (11): iPhoneMultitrackLaneContent, .body, .phoneTimelineScroll, Bool, CGFloat, Content, TimelineHorizontalMirror, .body (+3 more)

### Community 80 - "TimeInterval"
Cohesion: 0.16
Nodes (13): AdvanceOutcome, arrangementStopped, none, reachedProjectEnd, sectionHandled, AdvanceResult, PlaybackState, continuingTimeline (+5 more)

### Community 81 - "graphify reference: add a URL and watch a folder"
Cohesion: 0.50
Nodes (3): For /graphify add, For --watch, graphify reference: add a URL and watch a folder

### Community 82 - "graphify reference: commit hook and native AGENTS.md integration"
Cohesion: 0.50
Nodes (3): For git commit hook, For native AGENTS.md integration, graphify reference: commit hook and native AGENTS.md integration

### Community 83 - "graphify reference: incremental update and cluster-only"
Cohesion: 0.50
Nodes (3): For --cluster-only, For --update (incremental re-extraction), graphify reference: incremental update and cluster-only

### Community 84 - ".present"
Cohesion: 0.26
Nodes (8): ImportDocumentPickerPresenter, ImportDocumentPickerSession, Bool, URL, Void, UIDocumentPickerDelegate, UIDocumentPickerViewController, UIViewController

### Community 87 - "CodingKeys"
Cohesion: 0.13
Nodes (15): CodingKeys, colorHex, endTime, id, lyricDocumentID, lyricSlideID, lyricSlideOrder, midiChannel (+7 more)

### Community 89 - "MIDINoteAssignment"
Cohesion: 0.16
Nodes (13): MIDINoteAssignment, .displayName, Bool, String, UInt8, .body, SectionAssignCardView, .midiLabel (+5 more)

### Community 90 - "TimelineScaleControls"
Cohesion: 0.16
Nodes (11): Bool, CGFloat, Double, String, Void, TimelineScaleControls, .buttonCornerRadius, .buttonSize (+3 more)

### Community 91 - "PinnedTimelineHeaderStrip"
Cohesion: 0.19
Nodes (13): PinnedTimelineHeaderStrip, .timeHeaderCell, PlayheadView, .body, .playheadDragGesture, Content, Gesture, Int (+5 more)

### Community 92 - "LvoqPlaybackProjectFileDocument"
Cohesion: 0.25
Nodes (7): FileDocument, FileWrapper, LvoqPlaybackProjectFileDocument, .readableContentTypes, Data, ReadConfiguration, WriteConfiguration

### Community 93 - "TrackPitchControlView"
Cohesion: 0.15
Nodes (14): .actionButtons, Binding, Bool, Double, String, UUID, TrackPitchControlView, .menuTitle (+6 more)

### Community 94 - "PitchShiftSettings"
Cohesion: 0.24
Nodes (6): PitchShiftSettings, AVAudioUnitTimePitch, Bool, Double, Float, PitchShiftSettingsTests

### Community 95 - "SingleLaneTrackHeaderCell"
Cohesion: 0.26
Nodes (10): SingleLaneMarkerHeaderCell, .body, SingleLaneStackedClipsLane, .body, SingleLaneTimelineViews, SingleLaneTrackHeaderCell, Bool, CGFloat (+2 more)

### Community 96 - "Pitch"
Cohesion: 0.15
Nodes (13): Pitch, .empty, .footnote, .help, .importHint, .label, .minusFive, .originalOff (+5 more)

### Community 97 - "Audio Engine — Agent Guide"
Cohesion: 0.17
Nodes (11): Architecture (do not collapse), Audio Engine — Agent Guide, Before you edit, iOS session rules (critical), Log messages, macOS device rules, Playback sync invariants (never break), Red flags (stop and reconsider) (+3 more)

### Community 98 - ".armLinearContinuationAtSectionEnd"
Cohesion: 0.29
Nodes (3): AudioEngineService, AVAudioTime, TimeInterval

### Community 99 - ".resolve"
Cohesion: 0.27
Nodes (5): PlaybackDeltaPolicy, Resolution, Bool, TimeInterval, PlaybackDeltaPolicyTests

### Community 100 - "Audio"
Cohesion: 0.17
Nodes (11): Audio, .builtInSpeaker, .interface, .masterVolume, .output, .outputPair, .refreshDevices, .sampleRate (+3 more)

### Community 101 - ".hex"
Cohesion: 0.33
Nodes (4): .defaultColor, Int, String, TrackColorPalette

### Community 102 - ".stem"
Cohesion: 0.29
Nodes (4): Int, String, TimeInterval, TrackOrganizationServiceTests

### Community 103 - "AudioDropTargetModifier"
Cohesion: 0.27
Nodes (7): AudioDropTargetModifier, Content, NSItemProvider, String, TimeInterval, View, View

### Community 104 - "AVAudioTime"
Cohesion: 0.33
Nodes (3): AVAudioPlayerNode, AVAudioTime, ObjectIdentifier

### Community 105 - "SupportedAudioFormats"
Cohesion: 0.33
Nodes (9): UTType, SupportedAudioFormats, .contentTypes, .dropTypes, .filePickerTypes, .folderPickerTypes, .importPickerTypes, Set (+1 more)

### Community 106 - ".presentImportPanel"
Cohesion: 0.27
Nodes (6): ProjectFilePanel, URL, ImportPanelKind, audioFiles, folder, .importMenuItems

### Community 107 - "TopToolbarView.swift"
Cohesion: 0.25
Nodes (6): DAWIconToolbarButtonStyle, DAWLabeledToolbarButtonStyle, Content, .wrapLayoutButton, .body, UIKit

### Community 108 - "WorkspacePresentationModifier"
Cohesion: 0.28
Nodes (8): Binding, Bool, String, View, WorkspacePresentationModifier, .deleteSectionDialogTitle, .sectionDeletionDialogBinding, .workspaceLyricLinkSheetBinding

### Community 109 - "View"
Cohesion: 0.15
Nodes (9): Configuration, Content, Configuration, AudioDropOverlay, .body, String, TimelineEmptyDropHint, .body (+1 more)

### Community 110 - "Mixer"
Cohesion: 0.22
Nodes (9): Mixer, .close, .empty, .group, .hideVolume, .main, .output, .showVolume (+1 more)

### Community 112 - "CodingKeys"
Cohesion: 0.29
Nodes (7): CodingKeys, linkedSectionID, order, preview, slideID, tag, text

### Community 113 - ".loadURLs"
Cohesion: 0.62
Nodes (4): DropURLLoader, NSItemProvider, String, URL

### Community 114 - "Selection"
Cohesion: 0.29
Nodes (7): Selection, .duration, .empty, .end, .loop, .start, .selectedTitle

### Community 115 - "Settings"
Cohesion: 0.29
Nodes (6): Settings, .languageFooter, .languageSection, .languageSystem, .subtitle, .title

### Community 116 - "Foundation"
Cohesion: 0.10
Nodes (9): AudioUnit, AVFoundation, CoreAudio, CoreGraphics, Foundation, AudioEnginePlatformServicesFactory, PlatformPlaybackStrategyFactory, SnapGrid (+1 more)

### Community 117 - "WorkspaceLifecycleModifier"
Cohesion: 0.40
Nodes (5): .body, WorkspaceLifecycleModifier, WorkspaceView, .body, ScenePhase

### Community 118 - "AudioEngineServiceIOS.swift"
Cohesion: 0.33
Nodes (3): AudioEngineService, AVAudioTime, TimeInterval

### Community 119 - "ImportToolbarMenuButton.swift"
Cohesion: 0.33
Nodes (5): .importButton, .projectSessionButton, ImportToolbarMenuButton, .body, ProjectSessionToolbarMenuButton

### Community 120 - "SectionTriggerResult"
Cohesion: 0.40
Nodes (5): SectionTriggerResult, activatedImmediately, disabledRepeatAtEnd, enabledRepeatAtEnd, queuedForEnd

### Community 121 - "AudioEngineService"
Cohesion: 0.40
Nodes (3): AudioEngineService, AVAudioTime, TimeInterval

### Community 122 - "SectionPlaybackStatus"
Cohesion: 0.40
Nodes (5): SectionPlaybackStatus, idle, playing, queued, repeatingAtEnd

### Community 123 - ".sessionManagement"
Cohesion: 0.60
Nodes (3): .sessionManagement, .projectSessionMenuItems, .body

### Community 125 - "AppBranding"
Cohesion: 0.40
Nodes (4): AppBranding, .companionName, .displayName, String

### Community 126 - "AppLanguageStore"
Cohesion: 0.70
Nodes (3): AppLanguageStore, .languageCode, String

### Community 127 - "MIDILearnTarget"
Cohesion: 0.50
Nodes (3): MIDILearnTarget, section, UUID

### Community 128 - "App"
Cohesion: 0.50
Nodes (4): App, .companionName, .displayName, .untitledProject

### Community 129 - "Snap"
Cohesion: 0.50
Nodes (4): Snap, .enable, .interval, .title

## Knowledge Gaps
- **442 isolated node(s):** `id`, `name`, `startTime`, `endTime`, `colorHex` (+437 more)
  These have ≤1 connection - possible missing edges or undocumented components. (Counts symbols only; 696 node(s) total have ≤1 connection when file, concept and rationale nodes are included.)
- **9 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `WorkspaceViewModel` connect `WorkspaceViewModel` to `MIDIInputService`, `AudioClip`, `SectionMarkerChipView`, `TimeInterval`, `MixerPanelView`, `MIDIMappingBarView`, `DAWProject`, `ArrangementPlaybackEngine`, `ArrangementSection`, `CGFloat`, `.applyRestoredProject`, `SwiftUI`, `.tick`, `TrackHeaderRowView`, `AudioImportService`, `TransportBarView`, `ProjectPersistenceService`, `TrackOrganizationService`, `.importAudioFiles`, `TimelineOverviewBar`, `Sendable`, `TimelineView.swift`, `TimelineWorkspacePanel`, `.tracks`, `TransportRightToolbar`, `AudioOutputDevice`, `ProjectEditHistory`, `Color`, `LyricPlaySyncClient`, `AudioSampleRate`, `LyricSlidePickerCard`, `TimeInterval`, `PropertiesSidebarView`, `DAWTheme`, `SectionLyricLinkSheet`, `SectionPlaybackMode`, `WorkspaceLayoutContext`, `.clipContent`, `iPhoneTimelinePanel`, `TopToolbarView`, `.body`, `MIDINoteAssignment`, `TimelineScaleControls`, `PinnedTimelineHeaderStrip`, `LvoqPlaybackProjectFileDocument`, `TrackPitchControlView`, `SingleLaneTrackHeaderCell`, `AudioDropTargetModifier`, `.presentImportPanel`, `WorkspacePresentationModifier`, `Foundation`, `WorkspaceLifecycleModifier`, `ImportToolbarMenuButton.swift`, `SectionPlaybackStatus`, `.sessionManagement`, `.updateViewportWidth`, `MIDILearnTarget`?**
  _High betweenness centrality (0.304) - this node is a cross-community bridge._
- **Why does `L10n` connect `DAWTheme` to `WorkspaceViewModel`, `MIDIInputService`, `App`, `.text`, `String`, `Snap`, `AudioEngineService`, `MIDIMappingBarView`, `AudioImportService`, `TransportBarView`, `Section`, `.importAudioFiles`, `UUID`, `Lyric`, `Color`, `LyricSlidePickerCard`, `PropertiesSidebarView`, `SectionLyricLinkSheet`, `TrackRole`, `ProjectPersistenceError`, `Errors`, `File`, `MIDINoteAssignment`, `TimelineScaleControls`, `Pitch`, `Audio`, `WorkspacePresentationModifier`, `Mixer`, `Selection`, `Settings`, `Foundation`?**
  _High betweenness centrality (0.170) - this node is a cross-community bridge._
- **Why does `AudioEngineService` connect `AudioEngineService` to `.armLinearContinuationAtSectionEnd`, `AudioClip`, `AudioSettings`, `UUID`, `SectionStandbyCoordinator`, `.isNodeConnected`, `AVAudioTime`, `Bool`, `DAWProject`, `TimeInterval`?**
  _High betweenness centrality (0.108) - this node is a cross-community bridge._
- **Are the 15 inferred relationships involving `WorkspaceViewModel` (e.g. with `ArrangementPlaybackEngine` and `AudioImportService`) actually correct?**
  _`WorkspaceViewModel` has 15 INFERRED edges - model-reasoned connections that need verification._
- **Are the 2 inferred relationships involving `AudioEngineService` (e.g. with `SectionAudioCache` and `SectionStandbyCoordinator`) actually correct?**
  _`AudioEngineService` has 2 INFERRED edges - model-reasoned connections that need verification._
- **Are the 58 inferred relationships involving `DAWProject` (e.g. with `.clear()` and `.activeClipMoveGuides`) actually correct?**
  _`DAWProject` has 58 INFERRED edges - model-reasoned connections that need verification._
- **Are the 4 inferred relationships involving `ArrangementSection` (e.g. with `.body` and `.sameSlideCanBeUsedByMultipleSections()`) actually correct?**
  _`ArrangementSection` has 4 INFERRED edges - model-reasoned connections that need verification._