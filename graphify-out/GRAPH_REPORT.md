# Graph Report - SimplePlay  (2026-08-10)

## Corpus Check
- 94 files · ~48,336 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 1642 nodes · 3812 edges · 91 communities (76 shown, 15 thin omitted)
- Extraction: 90% EXTRACTED · 10% INFERRED · 0% AMBIGUOUS · INFERRED: 374 edges (avg confidence: 0.8)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `d8f5fcea`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- SimplePlayUITests
- SectionMarkerLaneView
- Equatable
- What You Must Do When Invoked
- TrackLaneView
- graphify reference: extra exports and benchmark
- .play
- graphify reference: query, path, explain
- graphify reference: add a URL and watch a folder
- graphify reference: commit hook and native AGENTS.md integration
- graphify reference: incremental update and cluster-only
- graphify reference: GitHub clone and cross-repo merge
- graphify reference: transcribe video and audio
- extraction-spec.md
- ArrangementPlaybackEngine
- MixerPanelView
- TimelineWorkspacePanel
- ScheduledClip
- AudioImportService
- AudioEngineService
- StandardTrackRole
- .applyImportedStems
- TrackControlButton
- MIDIMappingBarView
- SettingsFormStyle.swift
- SavedProjectDocument
- .previewRangeForSectionDrag
- .frames
- Sendable
- CodingKeys
- Testing
- AudioTrack
- DAWProject
- SupportedAudioFormats
- .applyLoadedProject
- TransportBarView
- AudioSampleRate
- .format
- UUID
- ImportDocumentPickerSession
- View
- ArrangementSection
- .snap
- ProjectPersistenceService
- .peaks
- AudioDeviceService
- CGFloat
- MIDIInputService
- SidebarPanel
- TrackPitchControlView
- .sectionMappingCard
- SectionMarkerChipView
- SimplePlayProjectArchive
- .log
- DAWVerticalFaderView
- ProjectPersistenceError
- Foundation
- ContentView
- TrackGroup
- AVAudioTime
- CodingKeys
- PropertiesSidebarView
- UIKitToolbarMenuButtonRepresentable
- PitchShiftSettings
- AudioDropTargetModifier
- WorkspaceSettingsView
- TopToolbarView
- WorkspaceViewModel
- TimeInterval
- SimplePlayProjectFileDocument
- .sessionManagement
- DAWTheme
- .sectionQuickPad
- .nextDistinctHex
- .apply
- MIDINoteAssignment
- .applyMIDILearn
- AudioEngineError
- DropURLLoader
- WorkspaceView
- SectionPlaybackStatus
- AVAudioFrameCount
- AVAudioUnitTimePitch
- Int64
- UInt64
- Date
- Set
- URL
- Configuration
- Binding
- CGSize

## God Nodes (most connected - your core abstractions)
1. `WorkspaceViewModel` - 238 edges
2. `AudioEngineService` - 81 edges
3. `DAWTheme` - 49 edges
4. `MIDIMappingBarView` - 44 edges
5. `AudioTrack` - 40 edges
6. `ArrangementSection` - 37 edges
7. `TimelineWorkspacePanel` - 35 edges
8. `MixerPanelView` - 35 edges
9. `ArrangementPlaybackEngine` - 34 edges
10. `PropertiesSidebarView` - 31 edges

## Surprising Connections (you probably didn't know these)
- `.selectedDevice` --references--> `WorkspaceViewModel`  [INFERRED]
  SimplePlay/Features/Workspace/Views/PropertiesSidebarView.swift → SimplePlay/Features/Workspace/ViewModels/WorkspaceViewModel.swift
- `.duration` --references--> `AudioTrack`  [INFERRED]
  SimplePlay/Core/Models/DAWProject.swift → SimplePlay/Core/Models/AudioTrack.swift
- `.settingsHeader` --calls--> `DAWPrimaryButtonStyle`  [INFERRED]
  SimplePlay/Features/Workspace/Views/WorkspaceSettingsView.swift → SimplePlay/Features/Workspace/Views/TopToolbarView.swift
- `.selectedMarkerEditor` --calls--> `MIDINoteAssignment`  [INFERRED]
  SimplePlay/Features/Workspace/Views/PropertiesSidebarView.swift → SimplePlay/Core/Models/MIDILearnTarget.swift
- `WorkspaceViewModel` --calls--> `ArrangementPlaybackEngine`  [INFERRED]
  SimplePlay/Features/Workspace/ViewModels/WorkspaceViewModel.swift → SimplePlay/Core/Services/ArrangementPlaybackEngine.swift

## Import Cycles
- None detected.

## Communities (91 total, 15 thin omitted)

### Community 0 - "SimplePlayUITests"
Cohesion: 0.15
Nodes (6): SimplePlayUITests, SimplePlayUITestsLaunchTests, .runsForEachTargetApplicationUIConfiguration, Bool, XCTest, XCTestCase

### Community 1 - "SectionMarkerLaneView"
Cohesion: 0.17
Nodes (20): SectionCreationPreviewView, .body, SectionDragSession, SectionEdgeGuideOverlay, .body, SectionMarkerGhostChipView, .chipWidth, SectionMarkerLaneView (+12 more)

### Community 2 - "Equatable"
Cohesion: 0.32
Nodes (15): Codable, Equatable, PersistedClip, PersistedProject, PersistedTrack, Bool, Decoder, Double (+7 more)

### Community 3 - "What You Must Do When Invoked"
Cohesion: 0.08
Nodes (24): For /graphify add and --watch, For /graphify query, For the commit hook and native AGENTS.md integration, For --update and --cluster-only, /graphify, Honesty Rules, Interpreter guard for subcommands, Part A - Structural extraction for code files (+16 more)

### Community 4 - "TrackLaneView"
Cohesion: 0.09
Nodes (26): G, GraphicsContext, CGFloat, String, TimeInterval, TimelineRulerScale, ClipDragInteractionModifier, ClipSelectionModifiers (+18 more)

### Community 5 - "graphify reference: extra exports and benchmark"
Cohesion: 0.22
Nodes (8): graphify reference: extra exports and benchmark, Step 6b - Wiki (only if --wiki flag), Step 7 - Neo4j export (only if --neo4j or --neo4j-push flag), Step 7a - FalkorDB export (only if --falkordb or --falkordb-push flag), Step 7b - SVG export (only if --svg flag), Step 7c - GraphML export (only if --graphml flag), Step 7d - MCP server (only if --mcp flag), Step 8 - Token reduction benchmark (only if total_words > 5000)

### Community 6 - ".play"
Cohesion: 0.37
Nodes (7): Int64, Bool, DAWProject, Int, SectionLoopContext, String, TimeInterval

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

### Community 14 - "ArrangementPlaybackEngine"
Cohesion: 0.12
Nodes (22): ArrangementPlaybackEngine, PlaybackState, continuingTimeline, idle, playingSection, repeatingSectionAtEnd, waitingToJump, SectionTriggerResult (+14 more)

### Community 15 - "MixerPanelView"
Cohesion: 0.06
Nodes (36): MixerPanelView, .body, .channelFaderHeight, .channelFaderWidth, .channelStripWidth, .groupDivider, .isCompact, .masterFaderHeight (+28 more)

### Community 16 - "TimelineWorkspacePanel"
Cohesion: 0.09
Nodes (32): PlayheadView, .body, .playheadDragGesture, Bool, CGFloat, Content, Double, Gesture (+24 more)

### Community 17 - "ScheduledClip"
Cohesion: 0.17
Nodes (7): AVAudioFile, AVAudioNode, AVAudioPlayerNode, AVAudioUnitTimePitch, .playbackGraphIsHealthy, ScheduledClip, AudioClip

### Community 18 - "AudioImportService"
Cohesion: 0.08
Nodes (26): LocalizedError, AudioFileStorageService, String, URL, UUID, AudioImportError, emptySelection, .errorDescription (+18 more)

### Community 19 - "AudioEngineService"
Cohesion: 0.11
Nodes (12): AVAudioMixerNode, AVAudioUnitEQ, AudioEngineService, .isAnyPlayerPlaying, .isPlaybackGraphReady, .isSectionLoopPlaybackActive, .masterVolume, .primaryClipSampleRate (+4 more)

### Community 20 - "StandardTrackRole"
Cohesion: 0.08
Nodes (24): StandardTrackRole, acousticGuitar, backingVocal, bass, brass, click, countIn, cue (+16 more)

### Community 21 - ".applyImportedStems"
Cohesion: 0.17
Nodes (10): Error, Result, ImportPanelKind, audioFiles, folder, String, .importMenuItems, .body (+2 more)

### Community 22 - "TrackControlButton"
Cohesion: 0.22
Nodes (8): PanKnobView, .body, Bool, Double, String, Void, TrackControlButton, .body

### Community 23 - "MIDIMappingBarView"
Cohesion: 0.13
Nodes (16): Animation, AnyTransition, MIDIMappingBarView, .assignModeToggleTitle, .collapsedBar, .collapsedBarContent, .devicePickerLabel, .devicePickerTitle (+8 more)

### Community 24 - "SettingsFormStyle.swift"
Cohesion: 0.11
Nodes (25): Selection, .playbackSettings, .volumeControls, SettingsBadge, .body, SettingsControlSurface, .body, SettingsFieldLabel (+17 more)

### Community 25 - "SavedProjectDocument"
Cohesion: 0.15
Nodes (10): SavedProjectDocument, SavedProjectDocument, DAWProject, Int, Data, ProjectFilePanel, String, URL (+2 more)

### Community 26 - ".previewRangeForSectionDrag"
Cohesion: 0.20
Nodes (5): SectionDragKind, move, resizeEnd, resizeStart, .chipMoveOrTapGesture

### Community 27 - ".frames"
Cohesion: 0.30
Nodes (6): Bool, Double, Int64, TimeInterval, TimelineSampleGrid, TimelineSampleGridTests

### Community 28 - "Sendable"
Cohesion: 0.10
Nodes (19): CaseIterable, Sendable, MIDILearnTarget, section, UUID, SectionPlaybackMode, continueTimeline, continueToNext (+11 more)

### Community 29 - "CodingKeys"
Cohesion: 0.06
Nodes (32): CodingKey, CodingKeys, audioSettings, colorHex, id, isLocked, isMuted, isSnapEnabled (+24 more)

### Community 30 - "Testing"
Cohesion: 0.17
Nodes (5): CoreGraphics, SimplePlay, ProjectArchiveTests, SimplePlayTests, Testing

### Community 31 - "AudioTrack"
Cohesion: 0.05
Nodes (51): AudioClip, .endTime, Int, String, TimeInterval, URL, UUID, AudioTrack (+43 more)

### Community 32 - "DAWProject"
Cohesion: 0.31
Nodes (9): DAWProject, .duration, Bool, Double, Int32, String, TimeInterval, UInt8 (+1 more)

### Community 33 - "SupportedAudioFormats"
Cohesion: 0.17
Nodes (11): SimplePlayProjectType, UTType, SupportedAudioFormats, .contentTypes, .dropTypes, .filePickerTypes, .folderPickerTypes, .importPickerTypes (+3 more)

### Community 34 - ".applyLoadedProject"
Cohesion: 0.16
Nodes (4): Content, View, .body, DAWProject

### Community 35 - "TransportBarView"
Cohesion: 0.06
Nodes (39): CGSize, Bool, CGFloat, ClosedRange, Gesture, TimeInterval, TimelineOverviewBar, .barHeight (+31 more)

### Community 36 - "AudioSampleRate"
Cohesion: 0.18
Nodes (14): Double, Hashable, Identifiable, AudioOutputDevice, AudioSampleRate, .displayName, .id, rate44100 (+6 more)

### Community 37 - ".format"
Cohesion: 0.13
Nodes (12): LinearGradient, Bool, String, TimeInterval, TimeFormatting, .formattedCurrentTime, .formattedDuration, .body (+4 more)

### Community 38 - "UUID"
Cohesion: 0.18
Nodes (6): AudioTrack, Double, Float, UUID, .mixerScrollWithPinnedMasters, .body

### Community 39 - "ImportDocumentPickerSession"
Cohesion: 0.06
Nodes (29): App, AppKit, Notification, NSApplicationDelegate, NSEvent, NSObject, NSView, NSViewRepresentable (+21 more)

### Community 40 - "View"
Cohesion: 0.20
Nodes (11): ButtonStyle, Content, .selectedMarkerEditor, DAWIconToolbarButtonStyle, DAWLabeledToolbarButtonStyle, DAWPrimaryButtonStyle, DAWSecondaryButtonStyle, Configuration (+3 more)

### Community 41 - "ArrangementSection"
Cohesion: 0.21
Nodes (11): ArrangementSection, .color, .duration, Bool, Decoder, String, TimeInterval, UInt8 (+3 more)

### Community 42 - ".snap"
Cohesion: 0.15
Nodes (6): Bool, TimeInterval, AudioClip, Int, .trackHeaderColumnTracksOnly, .trackLanes

### Community 43 - "ProjectPersistenceService"
Cohesion: 0.28
Nodes (6): unsupportedVersion, ProjectPersistenceService, Bool, DAWProject, URL, UUID

### Community 44 - ".peaks"
Cohesion: 0.08
Nodes (35): AVAudioPCMBuffer, CheckedContinuation, Never, Path, clips, Double, Float, Int (+27 more)

### Community 45 - "AudioDeviceService"
Cohesion: 0.26
Nodes (6): AudioDeviceID, AudioDeviceService, Bool, Int, String, .audioSettings

### Community 46 - "CGFloat"
Cohesion: 0.17
Nodes (10): CGFloat, TimelineScrollAlignment, center, leading, start, TimelineScrollRequest, .minimumTimelineZoom, .timelineContentWidth (+2 more)

### Community 47 - "MIDIInputService"
Cohesion: 0.07
Nodes (25): CoreMIDI, MIDINotifyProc, MIDIPacket, MIDIPacketList, MIDISourceInfo, MIDIInputEvent, MIDIInputService, MIDISourceInfo (+17 more)

### Community 48 - "SidebarPanel"
Cohesion: 0.18
Nodes (13): .sectionEditor, .selectionInfo, .trackPitch, .pitchMenu, SettingsFootnote, .body, SettingsValueRow, .body (+5 more)

### Community 49 - "TrackPitchControlView"
Cohesion: 0.16
Nodes (13): .actionButtons, Binding, Bool, Double, String, UUID, TrackPitchControlView, .menuTitle (+5 more)

### Community 50 - ".sectionMappingCard"
Cohesion: 0.23
Nodes (7): Configuration, .expandedPanel, SectionMappingAssignButtonStyle, SectionMappingCardGlow, SectionMappingPlayButtonStyle, Bool, CGFloat

### Community 51 - "SectionMarkerChipView"
Cohesion: 0.18
Nodes (10): NSCursor, ResizeEdge, end, start, SectionMarkerChipView, .body, .chipWidth, .liveSection (+2 more)

### Community 52 - "SimplePlayProjectArchive"
Cohesion: 0.16
Nodes (15): Asset, SimplePlayProjectArchive, SimplePlayProjectArchiveError, corruptAsset, corruptManifest, .errorDescription, invalidArchive, Bool (+7 more)

### Community 53 - ".log"
Cohesion: 0.22
Nodes (10): SectionLoopContext, .duration, TimeInterval, UUID, SectionLoopDiagnostics, AVAudioFrameCount, Double, Int64 (+2 more)

### Community 54 - "DAWVerticalFaderView"
Cohesion: 0.09
Nodes (25): ClosedRange, Double, Float, String, TrackVolumeSettings, .trackRange, DAWVerticalFaderView, .body (+17 more)

### Community 55 - "ProjectPersistenceError"
Cohesion: 0.17
Nodes (12): JSONDecoder, .projectDecoder, JSONEncoder, .pretty, ManifestFile, ProjectPersistenceError, .errorDescription, invalidPackage (+4 more)

### Community 56 - "Foundation"
Cohesion: 0.15
Nodes (7): AVFoundation, CoreAudio, Foundation, Observation, os, SnapGrid, SwiftUI

### Community 57 - "ContentView"
Cohesion: 0.20
Nodes (8): Commands, ContentView, .body, FileCommands, TransportCommands, View, WorkspaceKeyboardShortcuts, .body

### Community 58 - "TrackGroup"
Cohesion: 0.27
Nodes (8): Encoder, Date, Decoder, Double, String, TimeInterval, UUID, TrackGroup

### Community 59 - "AVAudioTime"
Cohesion: 0.38
Nodes (4): AVAudioFrameCount, AVAudioFramePosition, AVAudioTime, Double

### Community 60 - "CodingKeys"
Cohesion: 0.17
Nodes (12): CodingKeys, colorHex, endTime, id, midiChannel, midiNote, midiUsesControlChange, name (+4 more)

### Community 61 - "PropertiesSidebarView"
Cohesion: 0.10
Nodes (21): Binding, .masterVolumeBinding, PropertiesSidebarView, .body, .masterVolumeBinding, .pitchIsOriginal, .pitchLabel, .sectionCreationHint (+13 more)

### Community 62 - "UIKitToolbarMenuButtonRepresentable"
Cohesion: 0.33
Nodes (7): Coordinator, Context, String, Void, UIKitToolbarMenuButtonRepresentable, UIButton, UIViewRepresentable

### Community 63 - "PitchShiftSettings"
Cohesion: 0.31
Nodes (5): PitchShiftSettings, AVAudioUnitTimePitch, Double, Float, PitchShiftSettingsTests

### Community 64 - "AudioDropTargetModifier"
Cohesion: 0.27
Nodes (7): AudioDropTargetModifier, Content, NSItemProvider, String, TimeInterval, View, View

### Community 65 - "WorkspaceSettingsView"
Cohesion: 0.20
Nodes (8): Binding, Bool, String, WorkspaceSettingsView, .body, .deleteSectionDialogTitle, .sectionDeletionDialogBinding, .settingsHeader

### Community 66 - "TopToolbarView"
Cohesion: 0.18
Nodes (15): Bool, String, Void, ToolbarMenuButtonStyleModifier, TopToolbarView, .importButton, .isCompact, .openButton (+7 more)

### Community 67 - "WorkspaceViewModel"
Cohesion: 0.07
Nodes (24): Date, Set, SectionEdgeGuides, ArrangementSection, AudioOutputDevice, ClosedRange, SectionPlaybackMode, WorkspaceViewModel (+16 more)

### Community 68 - "TimeInterval"
Cohesion: 0.19
Nodes (5): Bool, SectionLoopContext, TimeInterval, .transportControls, Timer

### Community 69 - "SimplePlayProjectFileDocument"
Cohesion: 0.22
Nodes (7): FileDocument, FileWrapper, ReadConfiguration, SimplePlayProjectFileDocument, .readableContentTypes, Data, WriteConfiguration

### Community 70 - ".sessionManagement"
Cohesion: 0.24
Nodes (6): .sessionManagement, .projectSessionButton, .projectSessionMenuItems, ProjectSessionToolbarMenuButton, .body, UIKit

### Community 71 - "DAWTheme"
Cohesion: 0.11
Nodes (16): Glass, .assignModeToggle, .learnBanner, DAWGlassChrome, .controlGlass, .panelGlass, CGFloat, Double (+8 more)

### Community 73 - ".nextDistinctHex"
Cohesion: 0.47
Nodes (5): SectionMarkerPalette, .palette, Int, Set, String

### Community 74 - ".apply"
Cohesion: 0.29
Nodes (3): AudioSampleRate, AudioSettings, UInt32

### Community 75 - "MIDINoteAssignment"
Cohesion: 0.47
Nodes (5): MIDINoteAssignment, .displayName, Bool, String, UInt8

### Community 77 - "AudioEngineError"
Cohesion: 0.29
Nodes (7): AudioEngineError, clipLoadFailed, deviceSelectionFailed, engineStartFailed, .errorDescription, noPlayableClips, playbackUnavailable

### Community 78 - "DropURLLoader"
Cohesion: 0.62
Nodes (4): DropURLLoader, NSItemProvider, String, URL

### Community 79 - "WorkspaceView"
Cohesion: 0.33
Nodes (7): Binding, Bool, String, WorkspaceView, .deleteSectionDialogTitle, .phoneBottomChrome, .sectionDeletionDialogBinding

### Community 80 - "SectionPlaybackStatus"
Cohesion: 0.33
Nodes (5): SectionPlaybackStatus, idle, playing, queued, repeatingAtEnd

## Knowledge Gaps
- **279 isolated node(s):** `section`, `.displayName`, `idle`, `playingSection`, `repeatingSectionAtEnd` (+274 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **15 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `WorkspaceViewModel` connect `WorkspaceViewModel` to `SectionMarkerLaneView`, `TrackLaneView`, `ArrangementPlaybackEngine`, `MixerPanelView`, `TimelineWorkspacePanel`, `AudioImportService`, `AudioEngineService`, `.applyImportedStems`, `MIDIMappingBarView`, `SavedProjectDocument`, `.previewRangeForSectionDrag`, `.frames`, `Sendable`, `AudioTrack`, `.applyLoadedProject`, `TransportBarView`, `AudioSampleRate`, `.format`, `UUID`, `ImportDocumentPickerSession`, `.snap`, `ProjectPersistenceService`, `AudioDeviceService`, `CGFloat`, `MIDIInputService`, `SidebarPanel`, `TrackPitchControlView`, `.sectionMappingCard`, `SectionMarkerChipView`, `Foundation`, `ContentView`, `PropertiesSidebarView`, `AudioDropTargetModifier`, `WorkspaceSettingsView`, `TopToolbarView`, `TimeInterval`, `.sessionManagement`, `DAWTheme`, `.sectionQuickPad`, `.applyMIDILearn`, `WorkspaceView`, `SectionPlaybackStatus`?**
  _High betweenness centrality (0.475) - this node is a cross-community bridge._
- **Why does `AudioEngineService` connect `AudioEngineService` to `WorkspaceViewModel`, `TimeInterval`, `.play`, `UUID`, `.apply`, `ScheduledClip`, `Foundation`, `AVAudioTime`?**
  _High betweenness centrality (0.100) - this node is a cross-community bridge._
- **Why does `ArrangementSection` connect `ArrangementSection` to `DAWProject`, `SectionMarkerLaneView`, `Equatable`, `AudioSampleRate`, `.format`, `DAWTheme`, `.sectionQuickPad`, `.nextDistinctHex`, `CodingKeys`, `ArrangementPlaybackEngine`, `MIDIInputService`, `SectionMarkerChipView`, `Foundation`, `Sendable`, `AudioTrack`?**
  _High betweenness centrality (0.074) - this node is a cross-community bridge._
- **Are the 12 inferred relationships involving `WorkspaceViewModel` (e.g. with `ArrangementPlaybackEngine` and `AudioEngineService`) actually correct?**
  _`WorkspaceViewModel` has 12 INFERRED edges - model-reasoned connections that need verification._
- **Are the 2 inferred relationships involving `AudioEngineService` (e.g. with `WorkspaceViewModel` and `.configureAudioEngine()`) actually correct?**
  _`AudioEngineService` has 2 INFERRED edges - model-reasoned connections that need verification._
- **What connects `section`, `.displayName`, `idle` to the rest of the system?**
  _279 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `What You Must Do When Invoked` be split into smaller, more focused modules?**
  _Cohesion score 0.08 - nodes in this community are weakly interconnected._