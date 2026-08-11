# Graph Report - SimplePlay  (2026-08-10)

## Corpus Check
- 94 files · ~49,303 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 1623 nodes · 3862 edges · 80 communities (75 shown, 5 thin omitted)
- Extraction: 90% EXTRACTED · 10% INFERRED · 0% AMBIGUOUS · INFERRED: 390 edges (avg confidence: 0.8)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `290e7be1`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- SimplePlayUITests
- SectionMarkerChipView
- ProjectPersistenceService
- What You Must Do When Invoked
- AudioClip
- graphify reference: extra exports and benchmark
- SectionLoopContext
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
- TrackPitchControlView
- AudioImportService
- AudioEngineService
- StandardTrackRole
- .applyImportedStems
- TrackControlButton
- MIDIMappingBarView
- SettingsFormStyle.swift
- ContentView
- CGFloat
- .frames
- .sectionMappingCard
- CodingKeys
- SidebarPanel
- AudioTrack
- Equatable
- SupportedAudioFormats
- TrackHeaderRowView
- TransportBarView
- Float
- .selectedMarkerEditor
- UUID
- MacWindowTitleBarHidden.swift
- View
- PersistedProject
- UIKitToolbarMenuButtonRepresentable
- .peaks
- AudioSampleRate
- Testing
- MIDIInputService
- .standardize
- .body
- .nextDistinctHex
- Sendable
- SimplePlayProjectArchive
- .log
- DAWVerticalFaderView
- AVFoundation
- Foundation
- ProjectPersistenceError
- TrackGroup
- ScheduledClip
- CodingKeys
- PropertiesSidebarView
- TrackWaveformProgressBar
- .sessionManagement
- MIDILearnTarget
- WorkspaceSettingsView
- TopToolbarView
- WorkspaceViewModel
- TimeInterval
- SectionPlaybackStatus
- DAWProject
- DAWTheme
- CodingKeys
- .applyMIDILearn
- SimplePlayTests.swift
- MIDINoteAssignment
- ArrangementSection
- .saveProject
- PitchShiftSettings
- AppKit

## God Nodes (most connected - your core abstractions)
1. `WorkspaceViewModel` - 244 edges
2. `AudioEngineService` - 81 edges
3. `ArrangementSection` - 61 edges
4. `DAWTheme` - 51 edges
5. `MIDIMappingBarView` - 47 edges
6. `AudioTrack` - 42 edges
7. `ArrangementPlaybackEngine` - 38 edges
8. `MixerPanelView` - 35 edges
9. `TimelineWorkspacePanel` - 35 edges
10. `StandardTrackRole` - 31 edges

## Surprising Connections (you probably didn't know these)
- `.duration` --references--> `AudioTrack`  [INFERRED]
  SimplePlay/Core/Models/DAWProject.swift → SimplePlay/Core/Models/AudioTrack.swift
- `.selectedDevice` --references--> `WorkspaceViewModel`  [INFERRED]
  SimplePlay/Features/Workspace/Views/PropertiesSidebarView.swift → SimplePlay/Features/Workspace/ViewModels/WorkspaceViewModel.swift
- `.body` --calls--> `WorkspaceView`  [INFERRED]
  SimplePlay/ContentView.swift → SimplePlay/Features/Workspace/Views/WorkspaceView.swift
- `.body` --references--> `ArrangementSection`  [INFERRED]
  SimplePlay/Features/Workspace/Views/SectionMarkerLaneView.swift → SimplePlay/Core/Models/ArrangementSection.swift
- `.body` --references--> `ArrangementSection`  [INFERRED]
  SimplePlay/Features/Workspace/Views/SectionMarkerLaneView.swift → SimplePlay/Core/Models/ArrangementSection.swift

## Import Cycles
- None detected.

## Communities (80 total, 5 thin omitted)

### Community 0 - "SimplePlayUITests"
Cohesion: 0.15
Nodes (6): SimplePlayUITests, SimplePlayUITestsLaunchTests, .runsForEachTargetApplicationUIConfiguration, Bool, XCTest, XCTestCase

### Community 1 - "SectionMarkerChipView"
Cohesion: 0.11
Nodes (30): NSCursor, ResizeEdge, end, start, SectionCreationPreviewView, .body, SectionDragSession, SectionEdgeGuideOverlay (+22 more)

### Community 2 - "ProjectPersistenceService"
Cohesion: 0.21
Nodes (8): missingAudioFile, unsupportedVersion, ProjectPersistenceService, Bool, Data, DAWProject, URL, UUID

### Community 3 - "What You Must Do When Invoked"
Cohesion: 0.08
Nodes (24): For /graphify add and --watch, For /graphify query, For the commit hook and native AGENTS.md integration, For --update and --cluster-only, /graphify, Honesty Rules, Interpreter guard for subcommands, Part A - Structural extraction for code files (+16 more)

### Community 4 - "AudioClip"
Cohesion: 0.05
Nodes (40): CoreGraphics, G, GraphicsContext, AudioClip, .endTime, Int, String, TimeInterval (+32 more)

### Community 5 - "graphify reference: extra exports and benchmark"
Cohesion: 0.22
Nodes (8): graphify reference: extra exports and benchmark, Step 6b - Wiki (only if --wiki flag), Step 7 - Neo4j export (only if --neo4j or --neo4j-push flag), Step 7a - FalkorDB export (only if --falkordb or --falkordb-push flag), Step 7b - SVG export (only if --svg flag), Step 7c - GraphML export (only if --graphml flag), Step 7d - MCP server (only if --mcp flag), Step 8 - Token reduction benchmark (only if total_words > 5000)

### Community 6 - "SectionLoopContext"
Cohesion: 0.29
Nodes (9): SectionLoopContext, .duration, TimeInterval, UUID, Bool, DAWProject, Int, String (+1 more)

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
Nodes (19): ArrangementPlaybackEngine, PlaybackState, continuingTimeline, idle, playingSection, repeatingSectionAtEnd, waitingToJump, SectionTriggerResult (+11 more)

### Community 15 - "MixerPanelView"
Cohesion: 0.05
Nodes (40): MixerPanelView, .body, .channelFaderHeight, .channelFaderWidth, .channelStripWidth, .groupDivider, .isCompact, .masterFaderHeight (+32 more)

### Community 16 - "TimelineWorkspacePanel"
Cohesion: 0.08
Nodes (34): PlayheadView, .body, .playheadDragGesture, Bool, CGFloat, Content, Double, Gesture (+26 more)

### Community 17 - "TrackPitchControlView"
Cohesion: 0.16
Nodes (13): .actionButtons, Binding, Bool, Double, String, UUID, TrackPitchControlView, .menuTitle (+5 more)

### Community 18 - "AudioImportService"
Cohesion: 0.09
Nodes (26): LocalizedError, AudioEngineError, clipLoadFailed, deviceSelectionFailed, engineStartFailed, .errorDescription, noPlayableClips, playbackUnavailable (+18 more)

### Community 19 - "AudioEngineService"
Cohesion: 0.10
Nodes (11): AVAudioNode, AVAudioUnitEQ, AudioEngineService, .isAnyPlayerPlaying, .isPlaybackGraphReady, .isSectionLoopPlaybackActive, .masterVolume, .playbackGraphIsHealthy (+3 more)

### Community 20 - "StandardTrackRole"
Cohesion: 0.05
Nodes (37): CaseIterable, SectionPlaybackMode, continueTimeline, continueToNext, .displayName, .id, oneShot, repeatSection (+29 more)

### Community 21 - ".applyImportedStems"
Cohesion: 0.19
Nodes (4): Bool, TimeInterval, String, URL

### Community 22 - "TrackControlButton"
Cohesion: 0.22
Nodes (8): PanKnobView, .body, Bool, Double, String, Void, TrackControlButton, .body

### Community 23 - "MIDIMappingBarView"
Cohesion: 0.11
Nodes (19): Animation, AnyTransition, Color, MIDIMappingBarView, .assignModeToggleTitle, .collapsedBar, .collapsedBarContent, .devicePickerLabel (+11 more)

### Community 24 - "SettingsFormStyle.swift"
Cohesion: 0.11
Nodes (27): Selection, .playbackSettings, .sectionEditor, .selectionInfo, .trackPitch, .volumeControls, .pitchMenu, SettingsBadge (+19 more)

### Community 25 - "ContentView"
Cohesion: 0.29
Nodes (6): Commands, ContentView, .body, FileCommands, TransportCommands, .body

### Community 26 - "CGFloat"
Cohesion: 0.12
Nodes (9): SectionDragKind, move, resizeEnd, resizeStart, CGFloat, TimelineScrollRequest, .minimumTimelineZoom, .timelineContentWidth (+1 more)

### Community 27 - ".frames"
Cohesion: 0.29
Nodes (6): Bool, Double, Int64, TimeInterval, TimelineSampleGrid, TimelineSampleGridTests

### Community 28 - ".sectionMappingCard"
Cohesion: 0.29
Nodes (6): .expandedPanel, .loopMappingCard, SectionMappingAssignButtonStyle, SectionMappingCardGlow, SectionMappingPlayButtonStyle, Configuration

### Community 29 - "CodingKeys"
Cohesion: 0.08
Nodes (24): CodingKeys, audioSettings, colorHex, id, isLocked, isMuted, isSnapEnabled, isSolo (+16 more)

### Community 30 - "SidebarPanel"
Cohesion: 0.28
Nodes (8): SettingsSectionHeader, .body, SidebarLabeledRow, .body, SidebarPanel, .body, Content, String

### Community 31 - "AudioTrack"
Cohesion: 0.09
Nodes (30): AudioTrack, .color, .displayName, Bool, Double, StandardTrackRole, String, UUID (+22 more)

### Community 32 - "Equatable"
Cohesion: 0.27
Nodes (11): Equatable, AudioSettings, DAWProject, .duration, Bool, Double, Int32, String (+3 more)

### Community 33 - "SupportedAudioFormats"
Cohesion: 0.05
Nodes (37): FileDocument, FileWrapper, ReadConfiguration, SimplePlayProjectFileDocument, .readableContentTypes, Data, DropURLLoader, NSItemProvider (+29 more)

### Community 34 - "TrackHeaderRowView"
Cohesion: 0.10
Nodes (11): Content, View, Binding, Double, TrackHeaderRowView, .displayColor, .liveTrack, .trackPan (+3 more)

### Community 35 - "TransportBarView"
Cohesion: 0.06
Nodes (37): Bool, CGFloat, CGSize, ClosedRange, Gesture, TimeInterval, TimelineOverviewBar, .barHeight (+29 more)

### Community 36 - "Float"
Cohesion: 0.23
Nodes (4): AVAudioMixerNode, Float, UUID, Void

### Community 37 - ".selectedMarkerEditor"
Cohesion: 0.18
Nodes (9): Bool, String, TimeInterval, .formattedCurrentTime, .formattedDuration, .selectedMarkerEditor, .body, SettingsValueRow (+1 more)

### Community 38 - "UUID"
Cohesion: 0.16
Nodes (8): Double, Float, UUID, .mixerScrollWithPinnedMasters, Binding, Double, UUID, .body

### Community 39 - "MacWindowTitleBarHidden.swift"
Cohesion: 0.11
Nodes (15): Notification, NSApplicationDelegate, NSEvent, NSObject, NSView, NSViewRepresentable, NSWindow, .body (+7 more)

### Community 40 - "View"
Cohesion: 0.15
Nodes (13): ButtonStyle, .learnBanner, Content, DAWIconToolbarButtonStyle, DAWLabeledToolbarButtonStyle, DAWPrimaryButtonStyle, DAWSecondaryButtonStyle, Configuration (+5 more)

### Community 42 - "PersistedProject"
Cohesion: 0.36
Nodes (12): PersistedClip, PersistedProject, PersistedTrack, Bool, Decoder, Double, Int32, StandardTrackRole (+4 more)

### Community 43 - "UIKitToolbarMenuButtonRepresentable"
Cohesion: 0.33
Nodes (7): Coordinator, Context, String, Void, UIKitToolbarMenuButtonRepresentable, UIButton, UIViewRepresentable

### Community 44 - ".peaks"
Cohesion: 0.09
Nodes (31): AVAudioPCMBuffer, CheckedContinuation, Never, Path, clips, Double, Float, Int (+23 more)

### Community 45 - "AudioSampleRate"
Cohesion: 0.11
Nodes (18): AudioDeviceID, Double, Hashable, AudioOutputDevice, AudioSampleRate, .displayName, .id, rate44100 (+10 more)

### Community 46 - "Testing"
Cohesion: 0.31
Nodes (3): SimplePlay, ProjectArchiveTests, Testing

### Community 47 - "MIDIInputService"
Cohesion: 0.08
Nodes (24): Identifiable, MIDINotifyProc, MIDIPacket, MIDIPacketList, MIDIInputEvent, MIDIInputService, MIDISourceInfo, .id (+16 more)

### Community 48 - ".standardize"
Cohesion: 0.23
Nodes (7): StandardizedName, Bool, StandardTrackRole, String, URL, TrackNameStandardizer, TrackNameStandardizerTests

### Community 49 - ".body"
Cohesion: 0.21
Nodes (4): Error, Result, DAWProject, .body

### Community 50 - ".nextDistinctHex"
Cohesion: 0.27
Nodes (7): sections, SectionMarkerPalette, .palette, Int, Set, String, SectionMarkerPaletteTests

### Community 51 - "Sendable"
Cohesion: 0.27
Nodes (10): Codable, Sendable, SavedProjectDocument, DAWProject, Int, WorkspaceSnapshot, Kind, controlChange (+2 more)

### Community 52 - "SimplePlayProjectArchive"
Cohesion: 0.16
Nodes (15): Asset, SimplePlayProjectArchive, SimplePlayProjectArchiveError, corruptAsset, corruptManifest, .errorDescription, invalidArchive, Bool (+7 more)

### Community 53 - ".log"
Cohesion: 0.38
Nodes (6): SectionLoopDiagnostics, AVAudioFrameCount, Double, Int64, String, TimeInterval

### Community 54 - "DAWVerticalFaderView"
Cohesion: 0.09
Nodes (25): ClosedRange, Double, Float, String, TrackVolumeSettings, .trackRange, DAWVerticalFaderView, .body (+17 more)

### Community 55 - "AVFoundation"
Cohesion: 0.20
Nodes (4): AVFoundation, CoreAudio, CoreMIDI, os

### Community 56 - "Foundation"
Cohesion: 0.17
Nodes (5): Foundation, Observation, SnapGrid, TimeFormatting, SwiftUI

### Community 57 - "ProjectPersistenceError"
Cohesion: 0.18
Nodes (10): JSONDecoder, .projectDecoder, JSONEncoder, .pretty, ProjectPersistenceError, .errorDescription, invalidPackage, missingManifest (+2 more)

### Community 58 - "TrackGroup"
Cohesion: 0.27
Nodes (8): Encoder, Date, Decoder, Double, String, TimeInterval, UUID, TrackGroup

### Community 59 - "ScheduledClip"
Cohesion: 0.22
Nodes (9): AVAudioFile, AVAudioFramePosition, AVAudioPlayerNode, AVAudioTime, ScheduledClip, AVAudioFrameCount, AVAudioUnitTimePitch, Double (+1 more)

### Community 60 - "CodingKeys"
Cohesion: 0.25
Nodes (8): CodingKey, CodingKeys, horizontalOffset, id, importedAt, name, pitchSemitones, volume

### Community 61 - "PropertiesSidebarView"
Cohesion: 0.12
Nodes (19): .masterVolumeBinding, PropertiesSidebarView, .body, .masterVolumeBinding, .pitchIsOriginal, .pitchLabel, .sectionCreationHint, .selectedDevice (+11 more)

### Community 62 - "TrackWaveformProgressBar"
Cohesion: 0.40
Nodes (4): Bool, Double, TrackWaveformProgressBar, .body

### Community 63 - ".sessionManagement"
Cohesion: 0.60
Nodes (3): .sessionManagement, .projectSessionMenuItems, .body

### Community 64 - "MIDILearnTarget"
Cohesion: 0.40
Nodes (4): MIDILearnTarget, loopToggle, section, UUID

### Community 65 - "WorkspaceSettingsView"
Cohesion: 0.28
Nodes (7): Binding, Bool, String, WorkspaceSettingsView, .body, .deleteSectionDialogTitle, .sectionDeletionDialogBinding

### Community 66 - "TopToolbarView"
Cohesion: 0.15
Nodes (18): Bool, String, Void, ToolbarMenuButtonStyleModifier, TopToolbarView, .importButton, .importMenuItems, .isCompact (+10 more)

### Community 67 - "WorkspaceViewModel"
Cohesion: 0.08
Nodes (25): ImportPanelKind, audioFiles, folder, SectionEdgeGuides, Date, Int, Set, WorkspaceViewModel (+17 more)

### Community 68 - "TimeInterval"
Cohesion: 0.11
Nodes (10): .body, Bool, ClosedRange, TimeInterval, TimelineScrollAlignment, center, leading, start (+2 more)

### Community 69 - "SectionPlaybackStatus"
Cohesion: 0.40
Nodes (5): SectionPlaybackStatus, idle, playing, queued, repeatingAtEnd

### Community 70 - "DAWProject"
Cohesion: 0.36
Nodes (4): groups, DAWProject, Int, UUID

### Community 71 - "DAWTheme"
Cohesion: 0.10
Nodes (21): Glass, LinearGradient, .assignModeToggle, .sectionLoopToggle, .body, .overviewBackground, .markerHeaderRow, DAWGlassChrome (+13 more)

### Community 72 - "CodingKeys"
Cohesion: 0.17
Nodes (12): CodingKeys, colorHex, endTime, id, midiChannel, midiNote, midiUsesControlChange, name (+4 more)

### Community 75 - "MIDINoteAssignment"
Cohesion: 0.38
Nodes (6): MIDINoteAssignment, .displayName, Bool, String, UInt8, .loopAssignmentLabel

### Community 76 - "ArrangementSection"
Cohesion: 0.23
Nodes (9): ArrangementSection, .color, .duration, Bool, Decoder, String, TimeInterval, UInt8 (+1 more)

### Community 77 - ".saveProject"
Cohesion: 0.29
Nodes (4): ProjectFilePanel, String, URL, .body

### Community 78 - "PitchShiftSettings"
Cohesion: 0.31
Nodes (5): PitchShiftSettings, AVAudioUnitTimePitch, Double, Float, PitchShiftSettingsTests

### Community 79 - "AppKit"
Cohesion: 0.22
Nodes (6): App, AppKit, Scene, SimplePlayApp, ResizablePropertiesSidebar, .body

## Knowledge Gaps
- **282 isolated node(s):** `id`, `name`, `startTime`, `endTime`, `colorHex` (+277 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **5 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `WorkspaceViewModel` connect `WorkspaceViewModel` to `SectionMarkerChipView`, `ProjectPersistenceService`, `AudioClip`, `SectionLoopContext`, `ArrangementPlaybackEngine`, `MixerPanelView`, `TimelineWorkspacePanel`, `TrackPitchControlView`, `AudioImportService`, `AudioEngineService`, `StandardTrackRole`, `.applyImportedStems`, `MIDIMappingBarView`, `SettingsFormStyle.swift`, `ContentView`, `CGFloat`, `.sectionMappingCard`, `AudioTrack`, `SupportedAudioFormats`, `TrackHeaderRowView`, `TransportBarView`, `.selectedMarkerEditor`, `UUID`, `.addSection`, `AudioSampleRate`, `MIDIInputService`, `.body`, `Foundation`, `PropertiesSidebarView`, `.sessionManagement`, `MIDILearnTarget`, `WorkspaceSettingsView`, `TopToolbarView`, `TimeInterval`, `SectionPlaybackStatus`, `DAWTheme`, `.applyMIDILearn`, `ArrangementSection`, `.saveProject`, `AppKit`?**
  _High betweenness centrality (0.471) - this node is a cross-community bridge._
- **Why does `AudioEngineService` connect `AudioEngineService` to `WorkspaceViewModel`, `Float`, `TimeInterval`, `UUID`, `SectionLoopContext`, `AVFoundation`, `ScheduledClip`?**
  _High betweenness centrality (0.101) - this node is a cross-community bridge._
- **Why does `ArrangementSection` connect `ArrangementSection` to `Equatable`, `SectionMarkerChipView`, `WorkspaceViewModel`, `TimeInterval`, `.selectedMarkerEditor`, `DAWTheme`, `CodingKeys`, `.addSection`, `PersistedProject`, `ArrangementPlaybackEngine`, `MIDIInputService`, `.nextDistinctHex`, `Sendable`, `StandardTrackRole`, `MIDIMappingBarView`, `Foundation`, `.sectionMappingCard`, `PropertiesSidebarView`?**
  _High betweenness centrality (0.098) - this node is a cross-community bridge._
- **Are the 12 inferred relationships involving `WorkspaceViewModel` (e.g. with `ArrangementPlaybackEngine` and `AudioEngineService`) actually correct?**
  _`WorkspaceViewModel` has 12 INFERRED edges - model-reasoned connections that need verification._
- **Are the 2 inferred relationships involving `AudioEngineService` (e.g. with `WorkspaceViewModel` and `.configureAudioEngine()`) actually correct?**
  _`AudioEngineService` has 2 INFERRED edges - model-reasoned connections that need verification._
- **Are the 4 inferred relationships involving `ArrangementSection` (e.g. with `.body` and `.body`) actually correct?**
  _`ArrangementSection` has 4 INFERRED edges - model-reasoned connections that need verification._
- **What connects `id`, `name`, `startTime` to the rest of the system?**
  _282 weakly-connected nodes found - possible documentation gaps or missing edges._