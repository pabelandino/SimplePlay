# Audio Engine — Agent Guide

**Read this before editing playback, sync, or device routing.**

**Section pads / loop / jump / exit:** `SECTION_PLAYBACK_AGENT_GUIDE.md` is the source of truth. Do not change that FIFO contract from this file alone.

SimplePlay’s audio stack is split on purpose. Changing the wrong file reintroduces subtle bugs (iPad drift, `SessionCore paramErr`, “Could not start the audio engine”, `play() startAudioPlayback failed`).

## Architecture (do not collapse)

| Layer | Files | Responsibility |
|-------|--------|----------------|
| **Transport loop (Logic-style)** | `TransportClock.swift`, `PlaybackTransportController.swift`, `WorkspaceViewModel.applyTransportCommands` | Single authority: audio render clock. UI polls at 60 Hz; arrangement advances via `advance(to:)` — never wall-clock delta alone. |
| **Section sync contract** | `SectionPlaybackCoordinator.swift`, `ArrangementPlaybackEngine.completeRepeatAtEndBoundary` | Audio-led repeat boundaries, `scheduleUntil` caps, testable pure rules. |
| **Core engine** | `AudioEngineService.swift` | Graph, scheduling, meters, loop, shared playback bridge. **No platform `#if` for routing or timing.** |
| **Platform routing** | `AudioEnginePlatformServices.swift`, `AudioEngineServiceMacOS.swift`, `AudioEngineServiceIOS.swift` | Output device + `AVAudioSession` only. |
| **Platform playback timing** | `Playback/PlatformPlaybackStrategy.swift`, `MacOSPlaybackStrategy.swift`, `IOSPlaybackStrategy.swift` | Host-time vs sample-relative anchors, latency compensation, `play(at:)`, `boundaryCueTime`. |
| **Gapless section cut** | `SectionCueClock.swift`, `SectionStandbyCoordinator.swift`, `SectionAudioCache.swift`, `SectionCueQueueMonitor.swift` | **Loop = live FIFO `at: nil`.** See `SECTION_PLAYBACK_AGENT_GUIDE.md`. Do not `play()` standbys over a looping live node. |
| **UI / project** | `WorkspaceViewModel`, `PropertiesSidebarView`, `AudioSettings` | User-facing settings; validate saved devices **before** calling the engine. |

Reference commit when iPad sync was stable: **`584a4ad`** (Lyriora WiFi sync). Playback timing changes belong in `Playback/*`, not in a monolithic `#if os(macOS)` block inside `AudioEngineService`.

## Safe change map

| Goal | Edit here | Do **not** edit |
|------|-----------|------------------|
| iPad/Mac sync drift | `IOSPlaybackStrategy.swift` / `MacOSPlaybackStrategy.swift` | `AudioEngineService` scheduling core |
| Output interface picker | `AudioEngineServiceIOS` / `AudioEngineServiceMacOS`, UI validation in ViewModel | `configureAudioSession` inside `AudioEngineService` |
| Engine won’t start on reopen | `AudioEngineServiceIOS` (session category/options), ViewModel fallback for missing USB device | `engine.prepare()` loops, aggressive session property calls |
| Meters / TimePitch bypass | `AudioEngineService` meter + node graph sections | Playback strategies |

## iOS session rules (critical)

These caused **`SessionCore.mm:546 Failed to set properties, error: 4294967246`** (`paramErr` / -50):

1. **Never** call `setPreferredInput` on a `.playback` session (invalid; breaks startup when a saved USB interface is gone).
2. **Avoid** `.allowBluetoothHFP` on playback-only sessions — prefer `.allowBluetoothA2DP` only.
3. Treat `setPreferredSampleRate` / `setPreferredIOBufferDuration` as **best-effort** (`try?`); failure must not block `engine.start()`.
4. Speaker override: `overrideOutputAudioPort(.speaker)` only for built-in speaker; otherwise `.none`. Do not “route USB” via preferred input.

## macOS device rules

- Device selection uses `kAudioOutputUnitProperty_CurrentDevice` on the output unit (`AudioEngineServiceMacOS`).
- Restart engine after device change when already running — logic stays in `AudioEngineServiceMacOS`, not in the core service.

## Before you edit

1. Run `graphify query "<your question>"` (project rule).
2. Identify layer: routing vs timing vs core graph.
3. Prefer **new code in platform files** over new `#if os(...)` in `AudioEngineService.swift`.
4. After Swift changes: `graphify update .`

## Red flags (stop and reconsider)

- Adding `#if os(macOS)` / `#if !os(macOS)` inside `AudioEngineService.swift` for session or anchor logic.
- Copying Mac host-time scheduling to iOS (or vice versa) in the core file.
- Calling `setPreferredInput` to “select” an output on iOS.
- Changing `playbackLeadInSeconds`, anchor creation, or `safelyPlayPlayer` without testing **both** iPad and Mac.
- “Fixing” startup by wrapping everything in `engine.prepare()` or retry loops in the core service.
- Adding a long post-cut “quiet window” that delays playhead, reprime, or `stop()`/`play()` (350 ms caused visual lag and did not fix the first-wrap HAL skip).
- Scheduling loop bodies with `lastRenderTime + remaining` (`playerScheduleTime`). A few ms of playhead latency empties the FIFO; a starved `AVAudioPlayerNode` never plays the future-timed buffer (visual wrap, silence).
- Appending 12–24 segments **at the wrap**. That is the HAL `skipping cycle due to overload` spike. Arm metadata on tap 2; splice one `at: nil` body near the boundary; wrap is clock-only. Do not set `loopPrebufferTriggered` unless a body was actually queued.
- On **disable**, appending `live-cont` after an already-queued loop body. That plays one extra loop and reanchors the playhead to section end (visual ahead of audio). Clear metadata if no body is queued; otherwise rebuild linear from the current playhead.
- Scheduling the rest of the song, or **12 file `scheduleSegment`s**, at the section cut. That HAL-skips (`got N want: 1`) and leaves a silence on the join. Splice **cached PCM tails** (`scheduleBuffer`, same as loop bodies) about 1 s before the end; refill 8 s slices while playing. Never mark a **queued jump** (`live-jump`) as `isLinearContinuationQueued` — that caps the FIFO at the destination section end and the next section exits into silence.
- Calling `stop()` then `play(at:)` on standby (`HALC … got N want: 1`).
- Scheduling remaining-length silence or muting live at the wrap — that enlarged the restart gap.

## Log messages

| Log | Likely cause | Where to look |
|-----|----------------|---------------|
| `SessionCore.mm:546 … 4294967246` | Invalid session property (often `setPreferredInput` or HFP on playback) | `AudioEngineServiceIOS` |
| `play() startAudioPlayback failed — pausing arrangement` | Engine/graph not healthy after failed session or bad device state | `WorkspaceViewModel`, then platform session + `IOSPlaybackStrategy` |
| `clock-snap wrap-before/after` | Live player `lastRenderTime` vs playhead at repeat wrap. `timeline` near section end after dest=start means audio did not wrap. | `AudioEngineService.logLivePlayerClock` |

## Testing checklist

- [ ] iPad: open project saved with **disconnected** USB interface → plays on system default, no SessionCore spam.
- [ ] iPad: section triggers + LyricPlay sync still aligned.
- [ ] Mac: output device change while engine running.
- [ ] Mac + iPad: loop boundary restart.
- [ ] Run `PlaybackDeltaPolicyTests` after any change to `computePlaybackDelta` or restart/jump paths.
- [ ] Run `SectionCueClockTests` and `SectionStandbyCoordinatorTests` after loop/jump/continuation cue changes.

## Playback sync invariants (never break)

The arrangement playhead must stay locked to the **audio engine render clock**, not wall-clock timers alone.

```
Audio render clock (samples)  →  PlaybackTransportController.tick  →  ArrangementPlaybackEngine.advance(to:)
                                              ↓
                                    UI playhead @ 60 Hz (display only)
```

| Invariant | Why |
|-----------|-----|
| **`PlaybackTransportController` owns the transport loop** — do not reintroduce `computePlaybackDelta` / `arrangementEngine.tick(delta:)` in `WorkspaceViewModel`. | Dual clocks caused blink, mute gaps, and repeat desync. |
| **Never restart audio on forward timeline catch-up** — only `TransportClock.requiresAudioResyncAfterTimelineMove` (backward seek or section transition). UI scroll jank can delay 60 Hz ticks; forward drift must not call `resolveTimelineAudioJump`. | Caused audible blink when the playhead auto-scrolled at the viewport edge. |
| After **every** `restartAudioPlayback`, `seamlessJumpPlayback`, or `play()` that changes timeline position, call `syncArrangementAndPlaybackClock` (or equivalent): seek arrangement, set `transportState.lastAudioTimelineTime`, update `playheadTime`. Only trust `currentTimelineTime()` once `isSamplePlaybackClockEstablished`. | Without this, the next transport tick sees stale time vs audio clock → drift or frozen playhead. |
| While playing inside a section, pass `scheduleUntil: section.endTime`. Repeat **appends one body onto the live FIFO with `at: nil`** near the boundary. Tap 2 first arms **metadata only** so disable can clear without a leftover cycle. If the body is already queued, disable rebuilds linear audio from the real playhead (`exitSectionLoopToLinearPlayback`) — never append `live-cont` after the extra body (that loops once more and jumps the playhead to section end). Pad: tap 1 plays once; tap 2 arms one wrap; wrap consumes repeat. | Appending continuation after an adopted body played one extra loop. Reanchoring to section end left the playhead ahead of audio. |
| During `repeatingSectionAtEnd`, audio drives the playhead (`SectionPlaybackCoordinator` + transport early return). Arrangement must not wrap on delta alone — call `completeRepeatAtEndBoundary` when audio reaches `section.endTime`. | Arrangement-only wrap caused “visual repeat, audio continues linear”. |
| Section/loop **boundary** handlers for **repeat** must only wrap the playhead when the next cycle is already on the live FIFO. Do not promote standbys for loop. | Promoting silent standbys at wrap left the live cap finished and the next body never started. |
| Off-screen section jumps must call `scrollTimelineToTimeIfOffScreen` before/alongside audio restart. | Prevents UI lag when jumping to a section outside the viewport. |
| Run `PlaybackTransportControllerTests`, `ArrangementPlaybackEngineTests`, `PlaybackDeltaPolicyTests`, and `SectionCueClockTests` after transport or cue changes. | Prevents silent regressions. |
| Prefer gapless pre-schedule (`adoptSectionLoopDuringPlayback`, `armTimelineJumpAtBoundary`) for **boundary** audio; use forced `startAudioPlayback` for **immediate** section jumps. | iOS `seamlessJumpPlayback` without full reset can report success without switching buffers. |

### When editing section loop / jump code

Follow **`SECTION_PLAYBACK_AGENT_GUIDE.md`** (contract, FIFO rules, forbidden fixes, tests). This file stays routing/session/transport.
