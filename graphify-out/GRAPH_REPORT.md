# Graph Report - SimplePlay  (2026-08-14)

## Corpus Check
- 125 files · ~66,236 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 2289 nodes · 5515 edges · 136 communities (110 shown, 26 thin omitted)
- Extraction: 89% EXTRACTED · 11% INFERRED · 0% AMBIGUOUS · INFERRED: 611 edges (avg confidence: 0.8)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `f3d3621a`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- ArrangementPlaybackEngine
- MIDIInputService
- AudioTrack
- ImportDocumentPickerSession
- FaderMeterStripView
- IOSPlaybackStrategy
- TimelineWorkspacePanel
- CodingKeys
- AudioImportService
- AudioEngineService
- SectionMarkerChipView
- DAWProject
- MIDIMappingBarView
- DAWVerticalFaderView
- TrackOrganizationService
- AudioSettings
- Foundation
- .body
- WaveformCache
- SimplePlayProjectArchive
- TopToolbarView
- .standardize
- WorkspaceViewModel
- What You Must Do When Invoked
- PitchShiftSettings
- StandardTrackRole
- DAWTheme
- .selectedMarkerEditor
- .clipContent
- .commitSectionDragPreview
- TimeInterval
- SwiftUI
- iPhoneTimelinePanel
- MixerPanelView
- WaveformClipView
- .saveProject
- .importAudioFiles
- TransportBarView
- TimelineOverviewBar
- Float
- DAWGlassChrome
- .stop
- SingleLaneTrackHeaderCell
- TrackHeaderRowView
- .applyRestoredProject
- .log
- Equatable
- .play
- TimelineView.swift
- CodingKeys
- LyricPlaySyncClient
- SimplePlay
- ConnectionState
- TrackPitchControlView
- .sectionMappingCard
- SimplePlayUITests
- LyricPlaySyncMessage
- TimelineScaleControls
- TransportRightToolbar
- .frames
- AudioClip
- .setMIDIMappingAssignModeEnabled
- AVAudioPlayerNode
- TrackGroup
- TimeInterval
- UIKitToolbarMenuButtonRepresentable
- Double
- Audio Engine — Agent Guide
- UUID
- WorkspaceLayoutContext
- graphify reference: extra exports and benchmark
- iPhoneMIDIMappingBarView
- PinnedTimelineHeaderStrip
- .attachClip
- .hex
- graphify reference: query, path, explain
- .body
- .nextDistinctHex
- ProjectPersistenceService
- WorkspaceSettingsView
- ContentView
- graphify reference: add a URL and watch a folder
- graphify reference: commit hook and native AGENTS.md integration
- graphify reference: incremental update and cluster-only
- ProjectPersistenceError
- graphify reference: GitHub clone and cross-repo merge
- graphify reference: transcribe video and audio
- View
- extraction-spec.md
- LyricPlaySyncStatusView
- AudioEngineService
- LyricSlideCatalogItem
- ArrangementSection
- .startMIDILearn
- SidebarPanel
- StandardWorkspaceView
- AudioEngineError
- AudioDropTargetModifier
- SimplePlayProjectFileDocument
- .body
- MacAppDelegate
- SupportedAudioFormats
- PropertiesSidebarView
- LyricPlaySyncMessageKind
- .groupVolumeBinding
- Codable
- WorkspacePresentationModifier
- TimelineEditTool
- Panel
- .playbackRenderClockIsLive
- .loadURLs
- PlaybackState
- .format
- SectionLoopContext
- UniformTypeIdentifiers
- CodingKeys
- .ensureSectionPlaybackContext
- SectionTriggerResult
- .encode
- AVAudioUnitTimePitch
- AudioDropOverlay
- Int64
- UInt64
- AudioDeviceID
- Sendable
- Never
- Data
- Decoder
- Encoder
- AudioEngineService
- ClosedRange
- Date
- UInt8
- URL
- Configuration
- Binding

## God Nodes (most connected - your core abstractions)
1. `WorkspaceViewModel` - 346 edges
2. `AudioEngineService` - 107 edges
3. `DAWProject` - 104 edges
4. `DAWTheme` - 72 edges
5. `MIDIMappingBarView` - 54 edges
6. `ArrangementSection` - 52 edges
7. `AudioTrack` - 46 edges
8. `StandardTrackRole` - 43 edges
9. `ArrangementPlaybackEngine` - 36 edges
10. `MixerPanelView` - 36 edges

## Surprising Connections (you probably didn't know these)
- `.previewText` --references--> `LyricSlideCatalogItem`  [INFERRED]
  SimplePlay/Features/Workspace/Views/LyricSlidePickerViews.swift → SimplePlay/Core/Services/LyricPlaySyncProtocol.swift
- `.collapsedBar` --references--> `WorkspaceViewModel`  [INFERRED]
  SimplePlay/Features/Workspace/Views/iPhoneMIDIMappingBarView.swift → SimplePlay/Features/Workspace/ViewModels/WorkspaceViewModel.swift
- `.body` --calls--> `TrackLaneView`  [INFERRED]
  SimplePlay/Features/Workspace/Views/iPhoneTimelinePanel.swift → SimplePlay/Features/Workspace/Views/TimelineView.swift
- `WorkspaceViewModel` --calls--> `ArrangementPlaybackEngine`  [INFERRED]
  SimplePlay/Features/Workspace/ViewModels/WorkspaceViewModel.swift → SimplePlay/Core/Services/ArrangementPlaybackEngine.swift
- `WorkspaceViewModel` --calls--> `AudioImportService`  [INFERRED]
  SimplePlay/Features/Workspace/ViewModels/WorkspaceViewModel.swift → SimplePlay/Core/Services/AudioImportService.swift

## Import Cycles
- None detected.

## Communities (136 total, 26 thin omitted)

### Community 0 - "ArrangementPlaybackEngine"
Cohesion: 0.26
Nodes (7): ArrangementPlaybackEngine, UInt8, UUID, ArrangementPlaybackEngineTests, String, TimeInterval, UInt8

### Community 1 - "MIDIInputService"
Cohesion: 0.07
Nodes (28): CoreMIDI, MIDINotifyProc, MIDIPacket, MIDIPacketList, MIDISourceInfo, Kind, controlChange, noteOn (+20 more)

### Community 2 - "AudioTrack"
Cohesion: 0.17
Nodes (12): AudioTrack, .color, .displayName, Bool, Double, String, UUID, .duration (+4 more)

### Community 3 - "ImportDocumentPickerSession"
Cohesion: 0.24
Nodes (8): ImportDocumentPickerPresenter, ImportDocumentPickerSession, Bool, URL, Void, UIDocumentPickerDelegate, UIDocumentPickerViewController, UIViewController

### Community 4 - "FaderMeterStripView"
Cohesion: 0.12
Nodes (13): .mastersStripRow, .projectMasterStrip, String, FaderMeterStripView, .reservesThumbClearance, .showsUnityMark, .usesUnityCenterDecibelScale, Bool (+5 more)

### Community 5 - "IOSPlaybackStrategy"
Cohesion: 0.09
Nodes (23): AudioEngineService, PlatformPlaybackStrategy, IOSPlaybackStrategy, .meterTapBufferSize, AudioEngineService, AVAudioFile, AVAudioFrameCount, AVAudioFramePosition (+15 more)

### Community 6 - "TimelineWorkspacePanel"
Cohesion: 0.17
Nodes (20): ScrollPosition, PlayheadView, .body, .playheadDragGesture, CGFloat, Double, Gesture, String (+12 more)

### Community 7 - "CodingKeys"
Cohesion: 0.08
Nodes (25): CodingKeys, audioSettings, colorHex, id, isLocked, isMuted, isPitchEnabled, isSnapEnabled (+17 more)

### Community 8 - "AudioImportService"
Cohesion: 0.12
Nodes (19): LocalizedError, AudioFileStorageService, String, URL, UUID, AudioImportError, emptySelection, .errorDescription (+11 more)

### Community 9 - "AudioEngineService"
Cohesion: 0.07
Nodes (22): AudioEngineServiceHost, AVAudioEngine, AudioEngineService, .avEngine, .engineIsRunning, .isAnyPlayerPlaying, .isMeterMonitoringEnabled, .isPlaybackGraphReady (+14 more)

### Community 10 - "SectionMarkerChipView"
Cohesion: 0.08
Nodes (42): .timelineGuideOverlays, ResizeEdge, end, start, sectionChipSurface(), SectionCreationPreviewView, .body, SectionDragSession (+34 more)

### Community 11 - "DAWProject"
Cohesion: 0.10
Nodes (22): DAWProject, Bool, Double, Int32, String, TimeInterval, UInt8, UUID (+14 more)

### Community 12 - "MIDIMappingBarView"
Cohesion: 0.10
Nodes (23): Animation, AnyTransition, MIDIMappingBarView, .assignModeToggleTitle, .body, .collapsedBar, .devicePickerLabel, .devicePickerTitle (+15 more)

### Community 13 - "DAWVerticalFaderView"
Cohesion: 0.09
Nodes (25): ClosedRange, Double, Float, String, TrackVolumeSettings, .trackRange, DAWVerticalFaderView, .body (+17 more)

### Community 14 - "TrackOrganizationService"
Cohesion: 0.16
Nodes (14): ImportedStem, ImportPlacement, appendNewGroup, insertIntoGroup, Int, String, TimeInterval, URL (+6 more)

### Community 15 - "AudioSettings"
Cohesion: 0.05
Nodes (35): AnyObject, AudioDeviceID, AudioEnginePlatformServices, AVAudioSession, Double, AudioOutputDevice, AudioSampleRate, .displayName (+27 more)

### Community 16 - "Foundation"
Cohesion: 0.10
Nodes (9): AudioUnit, AVFoundation, CoreAudio, CoreGraphics, Foundation, Observation, os, SnapGrid (+1 more)

### Community 17 - ".body"
Cohesion: 0.18
Nodes (10): NSEvent, NSView, NSViewRepresentable, .body, .body, MacWindowDragRegion, MacWindowTitleBarHidden, Context (+2 more)

### Community 18 - "WaveformCache"
Cohesion: 0.23
Nodes (14): CheckedContinuation, Bool, Double, Float, Int, MainActor, Never, Sendable (+6 more)

### Community 19 - "SimplePlayProjectArchive"
Cohesion: 0.16
Nodes (15): Asset, SimplePlayProjectArchive, SimplePlayProjectArchiveError, corruptAsset, corruptManifest, .errorDescription, invalidArchive, Bool (+7 more)

### Community 20 - "TopToolbarView"
Cohesion: 0.13
Nodes (22): ButtonStyle, DAWIconToolbarButtonStyle, DAWLabeledToolbarButtonStyle, Bool, Content, String, Void, ToolbarMenuButtonStyleModifier (+14 more)

### Community 21 - ".standardize"
Cohesion: 0.22
Nodes (7): StandardizedName, Bool, Int, String, URL, TrackNameStandardizer, TrackNameStandardizerTests

### Community 22 - "WorkspaceViewModel"
Cohesion: 0.05
Nodes (39): AudioOutputDevice, ClipEditService, ClosedRange, Date, SectionPlaybackMode, CGFloat, Int, Set (+31 more)

### Community 23 - "What You Must Do When Invoked"
Cohesion: 0.08
Nodes (24): For /graphify add and --watch, For /graphify query, For the commit hook and native AGENTS.md integration, For --update and --cluster-only, /graphify, Honesty Rules, Interpreter guard for subcommands, Part A - Structural extraction for code files (+16 more)

### Community 24 - "PitchShiftSettings"
Cohesion: 0.29
Nodes (5): PitchShiftSettings, Bool, Double, Float, PitchShiftSettingsTests

### Community 25 - "StandardTrackRole"
Cohesion: 0.08
Nodes (25): StandardTrackRole, acousticGuitar, backingVocal, bass, brass, click, countIn, cue (+17 more)

### Community 26 - "DAWTheme"
Cohesion: 0.10
Nodes (24): LyricSlideAssignmentState, available, selectedHere, usedByOtherSection, LyricSlidePickerList, LyricSlidePickerRow, .assignmentBadge, .body (+16 more)

### Community 27 - ".selectedMarkerEditor"
Cohesion: 0.11
Nodes (31): Selection, .mappingRefreshControl, .playbackSettings, .sectionEditor, .selectedMarkerEditor, .selectionInfo, .trackPitch, .volumeControls (+23 more)

### Community 28 - ".clipContent"
Cohesion: 0.16
Nodes (8): ClipMovePreview, Item, .id, AudioClip, TrackLaneView, .body, .clipHeight, .liveTrack

### Community 29 - ".commitSectionDragPreview"
Cohesion: 0.22
Nodes (5): SectionDragKind, move, resizeEnd, resizeStart, .chipMoveOrTapGesture

### Community 30 - "TimeInterval"
Cohesion: 0.13
Nodes (10): ArrangementSection, Bool, SectionLoopContext, TimeInterval, Timer, TimelineScrollAlignment, center, leading (+2 more)

### Community 31 - "SwiftUI"
Cohesion: 0.14
Nodes (8): AppKit, ResizablePropertiesSidebar, .body, Bool, Double, TrackWaveformProgressBar, .body, SwiftUI

### Community 32 - "iPhoneTimelinePanel"
Cohesion: 0.12
Nodes (20): iPhoneSectionsLabelHeaderCell, .body, iPhoneTimelinePanel, .body, .laneAreaHeight, .magnificationGesture, .phonePinnedHeader, .phoneTrackHeaderColumn (+12 more)

### Community 33 - "MixerPanelView"
Cohesion: 0.11
Nodes (19): MixerPanelView, .body, .channelFaderHeight, .channelFaderWidth, .channelStripWidth, .groupDivider, .isCompact, .masterFaderHeight (+11 more)

### Community 34 - "WaveformClipView"
Cohesion: 0.09
Nodes (28): Float, Int, TimeInterval, URL, WaveformClipPeakStore, CGFloat, Float, Int (+20 more)

### Community 35 - ".saveProject"
Cohesion: 0.24
Nodes (5): ProjectFilePanel, String, URL, .body, SimplePlayProjectFileDocument

### Community 36 - ".importAudioFiles"
Cohesion: 0.09
Nodes (12): Error, Result, Bool, TimeInterval, ImportPanelKind, audioFiles, folder, String (+4 more)

### Community 37 - "TransportBarView"
Cohesion: 0.14
Nodes (15): Bool, CGFloat, String, Void, TransportBarStyle, phoneBottomDock, standard, TransportBarView (+7 more)

### Community 38 - "TimelineOverviewBar"
Cohesion: 0.11
Nodes (20): Path, Bool, CGFloat, CGSize, ClosedRange, Gesture, TimeInterval, TimelineOverviewBar (+12 more)

### Community 39 - "Float"
Cohesion: 0.22
Nodes (6): AVAudioMixerNode, AVAudioPCMBuffer, MeterPeakBuffer, Float, UUID, Void

### Community 40 - "DAWGlassChrome"
Cohesion: 0.17
Nodes (10): Glass, DAWGlassChrome, .controlGlass, .panelGlass, CGFloat, Double, LinearGradient, View (+2 more)

### Community 42 - "SingleLaneTrackHeaderCell"
Cohesion: 0.23
Nodes (11): SingleLaneMarkerHeaderCell, .body, SingleLaneStackedClipsLane, .body, SingleLaneTimelineViews, SingleLaneTrackHeaderCell, .body, Bool (+3 more)

### Community 43 - "TrackHeaderRowView"
Cohesion: 0.07
Nodes (33): clips, Bool, Double, UUID, WaveformLoadMonitor, Density, compact, full (+25 more)

### Community 44 - ".applyRestoredProject"
Cohesion: 0.17
Nodes (3): SavedProjectDocument, DAWProject, Content

### Community 45 - ".log"
Cohesion: 0.24
Nodes (9): SectionLoopDiagnostics, SectionTriggerDiagnostics, AVAudioFrameCount, Bool, Double, Int64, String, TimeInterval (+1 more)

### Community 46 - "Equatable"
Cohesion: 0.33
Nodes (13): Equatable, PersistedClip, PersistedProject, PersistedTrack, Bool, Decoder, Double, Int32 (+5 more)

### Community 47 - ".play"
Cohesion: 0.22
Nodes (9): Int64, AVAudioFrameCount, Bool, DAWProject, Int, SectionLoopContext, String, PlatformPlaybackStrategy (+1 more)

### Community 48 - "TimelineView.swift"
Cohesion: 0.08
Nodes (32): G, GraphicsContext, CGFloat, String, TimeInterval, TimelineRulerScale, ClipDragInteractionModifier, ClipSelectionModifiers (+24 more)

### Community 49 - "CodingKeys"
Cohesion: 0.13
Nodes (15): CodingKeys, colorHex, endTime, id, lyricDocumentID, lyricSlideID, lyricSlideOrder, midiChannel (+7 more)

### Community 50 - "LyricPlaySyncClient"
Cohesion: 0.15
Nodes (11): Never, NWBrowser, NWEndpoint, LyricPlaySyncClient, .isHeartbeatSuspended, Bool, Set, TimeInterval (+3 more)

### Community 51 - "SimplePlay"
Cohesion: 0.21
Nodes (4): SimplePlay, ProjectArchiveTests, SimplePlayTests, Testing

### Community 52 - "ConnectionState"
Cohesion: 0.15
Nodes (12): Network, ConnectionState, connected, failed, idle, searching, LyricPlaySyncTransportError, emptyResponse (+4 more)

### Community 53 - "TrackPitchControlView"
Cohesion: 0.15
Nodes (14): .actionButtons, Binding, Bool, Double, String, UUID, TrackPitchControlView, .menuTitle (+6 more)

### Community 54 - ".sectionMappingCard"
Cohesion: 0.15
Nodes (10): Configuration, MIDINoteAssignment, SectionMappingAssignButtonStyle, SectionMappingCardGlow, SectionMappingPlayButtonStyle, Bool, CGFloat, Content (+2 more)

### Community 55 - "SimplePlayUITests"
Cohesion: 0.14
Nodes (6): SimplePlayUITests, SimplePlayUITestsLaunchTests, .runsForEachTargetApplicationUIConfiguration, Bool, XCTest, XCTestCase

### Community 56 - "LyricPlaySyncMessage"
Cohesion: 0.30
Nodes (8): serverError, LinkSectionCommand, LyricPlaySync, LyricPlaySyncMessage, LyricSlideCatalog, ShowSlideCommand, UUID, String

### Community 57 - "TimelineScaleControls"
Cohesion: 0.16
Nodes (11): Bool, CGFloat, Double, String, Void, TimelineScaleControls, .buttonCornerRadius, .buttonSize (+3 more)

### Community 58 - "TransportRightToolbar"
Cohesion: 0.13
Nodes (19): .body, .phoneRightControls, .standardTransportBar, Binding, Bool, CGFloat, Double, String (+11 more)

### Community 59 - ".frames"
Cohesion: 0.32
Nodes (6): Bool, Double, Int64, TimeInterval, TimelineSampleGrid, TimelineSampleGridTests

### Community 60 - "AudioClip"
Cohesion: 0.14
Nodes (14): AudioClip, .endTime, Int, String, TimeInterval, URL, UUID, ClipEditService (+6 more)

### Community 61 - ".setMIDIMappingAssignModeEnabled"
Cohesion: 0.15
Nodes (11): .assignButton, .assignModeHeader, .assignModeToggle, .collapsedBarContent, .expandedPanel, SectionAssignCardView, .midiLabel, .slideLabel (+3 more)

### Community 62 - "AVAudioPlayerNode"
Cohesion: 0.36
Nodes (3): AVAudioFramePosition, AVAudioPlayerNode, AVAudioTime

### Community 63 - "TrackGroup"
Cohesion: 0.15
Nodes (15): CodingKeys, horizontalOffset, id, importedAt, name, pitchSemitones, volume, Date (+7 more)

### Community 65 - "UIKitToolbarMenuButtonRepresentable"
Cohesion: 0.33
Nodes (7): Coordinator, Context, String, Void, UIKitToolbarMenuButtonRepresentable, UIButton, UIViewRepresentable

### Community 67 - "Audio Engine — Agent Guide"
Cohesion: 0.20
Nodes (9): Architecture (do not collapse), Audio Engine — Agent Guide, Before you edit, iOS session rules (critical), Log messages, macOS device rules, Red flags (stop and reconsider), Safe change map (+1 more)

### Community 68 - "UUID"
Cohesion: 0.08
Nodes (9): AudioTrack, Float, UUID, .body, .body, .mixerScrollWithPinnedMasters, .trackHeaderActions, .faderStrip (+1 more)

### Community 69 - "WorkspaceLayoutContext"
Cohesion: 0.11
Nodes (18): EnvironmentKey, iPhoneWorkspaceView, .body, .phoneLayout, EnvironmentValues, .workspaceLayout, Bool, CGFloat (+10 more)

### Community 70 - "graphify reference: extra exports and benchmark"
Cohesion: 0.22
Nodes (8): graphify reference: extra exports and benchmark, Step 6b - Wiki (only if --wiki flag), Step 7 - Neo4j export (only if --neo4j or --neo4j-push flag), Step 7a - FalkorDB export (only if --falkordb or --falkordb-push flag), Step 7b - SVG export (only if --svg flag), Step 7c - GraphML export (only if --graphml flag), Step 7d - MCP server (only if --mcp flag), Step 8 - Token reduction benchmark (only if total_words > 5000)

### Community 71 - "iPhoneMIDIMappingBarView"
Cohesion: 0.12
Nodes (15): SectionPlaybackStatus, idle, playing, queued, repeatingAtEnd, iPhoneMIDIMappingBarView, .collapsedBar, .devicePickerButton (+7 more)

### Community 72 - "PinnedTimelineHeaderStrip"
Cohesion: 0.21
Nodes (10): PinnedTimelineHeaderStrip, .standardMarkerHeaderRow, .timeHeaderCell, Bool, Content, Int, Void, TimelineAudioDropModifier (+2 more)

### Community 73 - ".attachClip"
Cohesion: 0.20
Nodes (7): AVAudioUnitEQ, AVAudioUnitTimePitch, ScheduledClip, AudioClip, AudioSettings, AVAudioFile, AVAudioUnitTimePitch

### Community 74 - ".hex"
Cohesion: 0.33
Nodes (5): .defaultColor, Int, Int, String, TrackColorPalette

### Community 75 - "graphify reference: query, path, explain"
Cohesion: 0.33
Nodes (5): For /graphify explain, For /graphify path, graphify reference: query, path, explain, Step 0 — Constrained query expansion (REQUIRED before traversal), Step 1 — Traversal

### Community 76 - ".body"
Cohesion: 0.23
Nodes (7): .body, Content, View, View, WorkspaceKeyboardShortcuts, .historyControls, .timeDisplay

### Community 77 - ".nextDistinctHex"
Cohesion: 0.27
Nodes (7): sections, SectionMarkerPalette, .palette, Int, Set, String, SectionMarkerPaletteTests

### Community 78 - "ProjectPersistenceService"
Cohesion: 0.33
Nodes (5): unsupportedVersion, ProjectPersistenceService, Bool, URL, UUID

### Community 79 - "WorkspaceSettingsView"
Cohesion: 0.28
Nodes (7): Binding, Bool, String, WorkspaceSettingsView, .body, .deleteSectionDialogTitle, .sectionDeletionDialogBinding

### Community 80 - "ContentView"
Cohesion: 0.18
Nodes (10): App, Commands, Scene, ContentView, EditCommands, FileCommands, TransportCommands, .body (+2 more)

### Community 81 - "graphify reference: add a URL and watch a folder"
Cohesion: 0.50
Nodes (3): For /graphify add, For --watch, graphify reference: add a URL and watch a folder

### Community 82 - "graphify reference: commit hook and native AGENTS.md integration"
Cohesion: 0.50
Nodes (3): For git commit hook, For native AGENTS.md integration, graphify reference: commit hook and native AGENTS.md integration

### Community 83 - "graphify reference: incremental update and cluster-only"
Cohesion: 0.50
Nodes (3): For --cluster-only, For --update (incremental re-extraction), graphify reference: incremental update and cluster-only

### Community 84 - "ProjectPersistenceError"
Cohesion: 0.17
Nodes (11): JSONDecoder, .projectDecoder, JSONEncoder, .pretty, ProjectPersistenceError, .errorDescription, invalidPackage, missingAudioFile (+3 more)

### Community 87 - "View"
Cohesion: 0.14
Nodes (13): SectionLyricLinkSheet, .body, .isCompact, .unavailableState, ArrangementSection, Bool, DAWPrimaryButtonStyle, Configuration (+5 more)

### Community 89 - "LyricPlaySyncStatusView"
Cohesion: 0.14
Nodes (12): .body, LyricPlaySyncStatusView, .statusColor, .statusSubtitle, .statusTitle, Bool, Color, String (+4 more)

### Community 91 - "LyricSlideCatalogItem"
Cohesion: 0.16
Nodes (10): Data, Decoder, Encoder, Hashable, JSONEncoder, LyricPlaySyncCodec, LyricSlideCatalogItem, .displayText (+2 more)

### Community 92 - "ArrangementSection"
Cohesion: 0.11
Nodes (20): Identifiable, ArrangementSection, .color, .duration, .hasLyricSlideLink, Bool, Decoder, Int (+12 more)

### Community 93 - ".startMIDILearn"
Cohesion: 0.22
Nodes (5): MIDIInputEvent, MIDILearnTarget, .body, .body, UInt8

### Community 94 - "SidebarPanel"
Cohesion: 0.19
Nodes (11): .sessionManagement, .projectSessionMenuItems, .body, SettingsSectionHeader, .body, SidebarLabeledRow, .body, SidebarPanel (+3 more)

### Community 95 - "StandardWorkspaceView"
Cohesion: 0.25
Nodes (7): ScenePhase, .body, StandardWorkspaceView, .workspaceLayout, WorkspaceLifecycleModifier, WorkspaceView, .body

### Community 96 - "AudioEngineError"
Cohesion: 0.29
Nodes (7): AudioEngineError, clipLoadFailed, deviceSelectionFailed, engineStartFailed, .errorDescription, noPlayableClips, playbackUnavailable

### Community 97 - "AudioDropTargetModifier"
Cohesion: 0.27
Nodes (7): AudioDropTargetModifier, Content, NSItemProvider, String, TimeInterval, View, View

### Community 98 - "SimplePlayProjectFileDocument"
Cohesion: 0.22
Nodes (7): FileDocument, FileWrapper, ReadConfiguration, SimplePlayProjectFileDocument, .readableContentTypes, Data, WriteConfiguration

### Community 99 - ".body"
Cohesion: 0.20
Nodes (10): iPhoneMultitrackLaneContent, .body, .phoneTimelineScroll, Bool, CGFloat, Content, TimelineHorizontalMirror, .body (+2 more)

### Community 100 - "MacAppDelegate"
Cohesion: 0.27
Nodes (6): Notification, NSApplicationDelegate, NSObject, NSWindow, MacAppDelegate, MacWindowConfigurator

### Community 101 - "SupportedAudioFormats"
Cohesion: 0.31
Nodes (9): UTType, SupportedAudioFormats, .contentTypes, .dropTypes, .filePickerTypes, .folderPickerTypes, .importPickerTypes, Set (+1 more)

### Community 102 - "PropertiesSidebarView"
Cohesion: 0.14
Nodes (17): PropertiesSidebarView, .body, .pitchIsOriginal, .pitchLabel, .sectionCreationHint, .selectedDevice, .selectedDeviceID, .selectedSection (+9 more)

### Community 103 - "LyricPlaySyncMessageKind"
Cohesion: 0.22
Nodes (9): LyricPlaySyncMessageKind, catalogRequest, catalogResponse, error, linkSection, linkSectionAck, presence, presenceAck (+1 more)

### Community 104 - ".groupVolumeBinding"
Cohesion: 0.31
Nodes (5): .masterVolumeBinding, Binding, Double, UUID, .masterVolumeBinding

### Community 105 - "Codable"
Cohesion: 0.39
Nodes (5): Codable, SavedProjectDocument, Int, ManifestFile, Data

### Community 106 - "WorkspacePresentationModifier"
Cohesion: 0.33
Nodes (6): Binding, Bool, String, WorkspacePresentationModifier, .deleteSectionDialogTitle, .sectionDeletionDialogBinding

### Community 107 - "TimelineEditTool"
Cohesion: 0.29
Nodes (6): CaseIterable, TimelineEditTool, arrow, hand, split, trim

### Community 108 - "Panel"
Cohesion: 0.50
Nodes (4): Panel, mainVolume, none, timelineScale

### Community 110 - ".loadURLs"
Cohesion: 0.62
Nodes (4): DropURLLoader, NSItemProvider, String, URL

### Community 111 - "PlaybackState"
Cohesion: 0.33
Nodes (6): PlaybackState, continuingTimeline, idle, playingSection, repeatingSectionAtEnd, waitingToJump

### Community 112 - ".format"
Cohesion: 0.33
Nodes (5): Bool, String, TimeInterval, .formattedCurrentTime, .formattedDuration

### Community 113 - "SectionLoopContext"
Cohesion: 0.40
Nodes (4): SectionLoopContext, .duration, TimeInterval, UUID

### Community 115 - "CodingKeys"
Cohesion: 0.25
Nodes (8): CodingKey, CodingKeys, linkedSectionID, order, preview, slideID, tag, text

### Community 117 - "SectionTriggerResult"
Cohesion: 0.50
Nodes (4): SectionTriggerResult, activatedImmediately, enabledRepeatAtEnd, queuedForEnd

### Community 120 - "AudioDropOverlay"
Cohesion: 0.33
Nodes (5): AudioDropOverlay, .body, String, TimelineEmptyDropHint, .body

### Community 124 - "Sendable"
Cohesion: 0.21
Nodes (9): Sendable, MIDILearnTarget, section, MIDINoteAssignment, .displayName, Bool, String, UInt8 (+1 more)

## Knowledge Gaps
- **393 isolated node(s):** `deviceSelectionFailed`, `engineStartFailed`, `noPlayableClips`, `playbackUnavailable`, `.errorDescription` (+388 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **26 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `WorkspaceViewModel` connect `WorkspaceViewModel` to `ArrangementPlaybackEngine`, `MIDIInputService`, `AudioTrack`, `TimelineWorkspacePanel`, `AudioImportService`, `SectionMarkerChipView`, `DAWProject`, `MIDIMappingBarView`, `AudioSettings`, `Foundation`, `TopToolbarView`, `DAWTheme`, `.clipContent`, `.commitSectionDragPreview`, `TimeInterval`, `SwiftUI`, `iPhoneTimelinePanel`, `MixerPanelView`, `.saveProject`, `.importAudioFiles`, `TransportBarView`, `TimelineOverviewBar`, `SingleLaneTrackHeaderCell`, `TrackHeaderRowView`, `.applyRestoredProject`, `TimelineView.swift`, `LyricPlaySyncClient`, `TrackPitchControlView`, `.sectionMappingCard`, `LyricPlaySyncMessage`, `TimelineScaleControls`, `TransportRightToolbar`, `.setMIDIMappingAssignModeEnabled`, `Double`, `UUID`, `WorkspaceLayoutContext`, `iPhoneMIDIMappingBarView`, `PinnedTimelineHeaderStrip`, `.body`, `ProjectPersistenceService`, `WorkspaceSettingsView`, `ContentView`, `View`, `LyricPlaySyncStatusView`, `LyricSlideCatalogItem`, `.startMIDILearn`, `SidebarPanel`, `StandardWorkspaceView`, `AudioDropTargetModifier`, `.body`, `PropertiesSidebarView`, `.groupVolumeBinding`, `WorkspacePresentationModifier`, `.format`?**
  _High betweenness centrality (0.403) - this node is a cross-community bridge._
- **Why does `DAWProject` connect `DAWProject` to `AudioTrack`, `TrackOrganizationService`, `AudioSettings`, `Foundation`, `WorkspaceViewModel`, `.commitSectionDragPreview`, `TimeInterval`, `.importAudioFiles`, `.applyRestoredProject`, `Equatable`, `.play`, `TrackGroup`, `Double`, `UUID`, `.attachClip`, `.hex`, `ProjectPersistenceService`, `ArrangementSection`, `.startMIDILearn`, `Codable`, `Sendable`?**
  _High betweenness centrality (0.096) - this node is a cross-community bridge._
- **Why does `AudioEngineService` connect `AudioEngineService` to `TimeInterval`, `Float`, `.attachClip`, `.stop`, `.playbackRenderClockIsLive`, `AudioSettings`, `Foundation`, `.play`, `AVAudioPlayerNode`?**
  _High betweenness centrality (0.078) - this node is a cross-community bridge._
- **Are the 12 inferred relationships involving `WorkspaceViewModel` (e.g. with `ArrangementPlaybackEngine` and `AudioImportService`) actually correct?**
  _`WorkspaceViewModel` has 12 INFERRED edges - model-reasoned connections that need verification._
- **Are the 61 inferred relationships involving `DAWProject` (e.g. with `.configure()` and `.trackOrderLookup()`) actually correct?**
  _`DAWProject` has 61 INFERRED edges - model-reasoned connections that need verification._
- **What connects `deviceSelectionFailed`, `engineStartFailed`, `noPlayableClips` to the rest of the system?**
  _393 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `MIDIInputService` be split into smaller, more focused modules?**
  _Cohesion score 0.06896551724137931 - nodes in this community are weakly interconnected._