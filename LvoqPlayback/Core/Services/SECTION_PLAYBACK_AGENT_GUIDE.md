# Section Playback — Agent Guide

**Read this before changing pads, section loop, queued jumps, or section-exit audio.**

This is core live-performance behavior. The loop, queued jump, and linear exit are **correct**. Do not “simplify” them. A change that only reanchors the playhead, dumps the rest of the song at a cut, or calls `play()` on a live node will reintroduce silence, a HAL graph death, or an extra unwanted cycle.

Companion: `AUDIO_ENGINE_AGENT_GUIDE.md` (routing, session, transport clock). This file is the **pad / FIFO / cut** contract.

---

## Product contract (pads)

Arrangement state lives in `ArrangementPlaybackEngine.triggerSection`. Tests: `ArrangementPlaybackEngineTests`.

| User action | Result | Audio |
|-------------|--------|--------|
| **Tap 1** on a section | `activatedImmediately` → `playingSection` | Jump there, play **once**. At section end, continue the timeline. |
| **Tap 2** while that section is playing | `enabledRepeatAtEnd` → `repeatingSectionAtEnd` | Arm **one wrap**. |
| Wrap fires (audio reaches section end) | `completeRepeatAtEndBoundary` → `playingSection` at section start | Repeat is **consumed**. The extra cycle plays as a normal section. |
| No tap during the extra cycle | Extra cycle ends | Song continues **linearly** (cached PCM tail + refill). |
| Tap again **during the extra cycle** | `enabledRepeatAtEnd` again | Arm **one more** wrap. |
| Tap while `repeatingSectionAtEnd` **before** the wrap | `disabledRepeatAtEnd` → `playingSection` | Cancel the pending wrap. **Must not** play an extra loop. Playhead stays on the audio clock. |
| Tap a **different** section with wait-for-end | `queuedForEnd` → `waitingToJump` | Current section finishes, then jump. Destination plays once unless its pad is tapped again. |
| **Seek / play later** after a loop, past the section | `continuingTimeline` | Must **not** keep `playingSection` or `scheduleUntil` at the old end. That schedules an empty range and shows `Audio playback is unavailable`. |

Immediate jump (`waitForCurrentToFinish == false`) is `activatedImmediately` and restarts audio at the destination. That path is not the live-FIFO wrap/jump described below.

---

## Layers (do not collapse)

```
Pad / MIDI
    → ArrangementPlaybackEngine.triggerSection        // state machine only
    → WorkspaceViewModel (maps result → engine calls)
Transport @ 60 Hz
    → PlaybackTransportController.tick                // when to arm / wrap / exit
    → ArrangementPlaybackEngine.advance(to:)          // follows audio clock
Audio
    → AudioEngineService live FIFO                    // what actually plays
    → SectionAudioCache                               // PCM bodies + 8 s tails
    → SectionPlaybackCoordinator                      // pure repeat-boundary rules
```

| Layer | Owns | Does **not** own |
|-------|------|------------------|
| `ArrangementPlaybackEngine` | Pad results, `playingSection` / `repeatingSectionAtEnd` / `waitingToJump` | Scheduling, `play()`, FIFO |
| `PlaybackTransportController` | When to arm loop / jump / continuation; audio-led wrap | `AVAudioPlayerNode` |
| `AudioEngineService` | Live FIFO `at: nil`, cache splice, clock reanchor | Pad policy |
| `SectionAudioCache` | Warm section bodies + continuation tails | Transport |
| `WorkspaceViewModel` | Wiring trigger results and tick commands to the engine | New timing policy (keep it in `TransportClock` / coordinator) |

---

## The only scheduling model that works

**Loop, jump, and section exit all splice onto the already-playing live node with `at: nil`.**

```
scheduleBuffer(cachedPCM, at: nil)     // loop body, continuation tail  ← use this at cuts
scheduleSegment(file, …)               // refill far from a cut only
```

Facts that look like bugs but are not:

1. **`AVAudioPlayerNode.sampleTime` does not reset at wrap.** Clock-snap `wrap-after engineTime=n/a` is normal. Wrap is **clock + playhead** (`completeRepeatBoundaryJump` + `reanchorPlaybackTimeline`). The extra body is already in the FIFO.
2. **`play()` / `play(at:)` on a live or un-reset node** → `HALC_ProxyIOContext … got N want: 1` and the graph dies (`audioPlaying=0`). Never promote standbys over a looping live node.
3. **Timed `lastRenderTime + remaining`** (`playerScheduleTime`) starves the node. A few ms of playhead latency and the future buffer never plays (visual wrap, silence).
4. **Dumping 12–24 file segments (or ~180 s × 12 tracks) at a cut** → `HALC … skipping cycle due to overload`, then often `got N want: 1`. That is the audible gap on section exit.

Warm cache (`queuing 24 gapless slices` = 12 section bodies + 12 tails) exists so the cut uses RAM, not disk.

---

## Loop (same section, tap 2)

### Arm (tap 2)

`WorkspaceViewModel` on `enabledRepeatAtEnd`:

- If remaining **> `repeatPrearmLeadTime` (2.5 s)** → `armLoopBoundaryMetadataOnly`. **No body in the FIFO.** Disable can clear metadata with no restart.
- If remaining **≤ 2.5 s** → `adoptSectionLoopDuringPlayback` / `appendSectionLoopCycles`: **one** cached section body, `scheduleBuffer(…, at: nil)`.

`loopPrebufferTriggered` is **only** true when a body was actually queued. Metadata-only must leave it `false` so transport still prearms near the boundary (`shouldPrearmRepeatAudio` uses `alreadyArmed: loopPrebufferTriggered`).

Do **not** splice the body in the wrap quantum. Arm near the boundary; wrap is clock-only.

### Wrap (audio reaches section end)

`SectionPlaybackCoordinator.resolveRepeatBoundaryPhase` → `.repeatBoundary` → `completeRepeatAtBoundary`:

1. `completeRepeatAtEndBoundary` → state `playingSection`, time = section start.
2. If `hasQueuedLoopBody` (`scheduledLoopCycleCount > 0`): `completeRepeatBoundaryJump` (reanchor only). Then `releaseRepeatBoundaryLoopMetadata`.
3. Extra cycle is linear `playingSection`. No further wrap unless the pad is tapped again.

Do not `stop()` / `play()` / `seamlessJumpPlayback` when the extra body is already on the FIFO.

### Extra cycle → song (no third tap)

Near section end (`continuationPrearmLeadTime` = **1.0 s**), transport emits `armLinearContinuation`.

`appendLivePlayback(from: sectionEnd, cacheSectionID:, label: "live-cont")`:

- Prefer **cached tail** (`SectionAudioCache.continuationTailRange` + `cachedIfPresent`) → `scheduleBuffer`.
- File slices only on **cache miss** or **refill**, max **1 × 8 s** per clip (`maxImmediateContinuationSlices`).
- `refillLinearContinuation` keeps a short window on the FIFO while playing. Never dump the rest of the song at the cut.

Keep 1.0 s — long enough for 12 PCM buffers to land, short enough that a tap during the extra cycle can still adopt a loop body **before** continuation sits on the FIFO. Do not splice continuation in the wrap quantum (that would put linear audio ahead of a later adopt).

---

## Queued jump (other section, wait-for-end)

`armTimelineJumpAtBoundary` → `appendLivePlayback(…, label: "live-jump", isLinearContinuation: false)` from dest start **until dest end**.

**Never set `isLinearContinuationQueued` on a jump.** That flag means “tails after this section are already on the FIFO.” Jump only queued the destination **body**. If the flag is set, Verse 2 (or whatever was queued) reaches its end, transport skips `armLinearContinuation`, the FIFO is empty, and the next section is silence.

After the jump completes, the destination is `playingSection` and prearms **its own** cached tail ~1 s before *its* end.

---

## Disable (tap while repeat is armed, before wrap)

| FIFO | Action |
|------|--------|
| Metadata only (`!hasQueuedLoopBody`) | Clear loop metadata. **Do not** restart. Playhead stays on the live clock. |
| Body already queued | `exitSectionLoopToLinearPlayback(at: playhead)` — rebuild linear from the **real** playhead. |

**Never** `appendLivePlayback(from: section.endTime)` on disable. That plays the extra body and reanchors the UI to section end (playhead ahead of audio).

You cannot unschedule `AVAudioPlayerNode` buffers without `stop()`. That is why tap 2 is metadata-only until 2.5 s remaining.

---

## Constants (keep in sync)

| Name | Value | Role |
|------|-------|------|
| `TransportClock.repeatPrearmLeadTime` / `SectionPlaybackCoordinator.repeatPrearmLeadTime` | 2.5 s | When to splice the loop body; tap 2 before this is metadata-only |
| `TransportClock.continuationPrearmLeadTime` | 1.0 s | When to splice cached tails for linear exit |
| `SectionAudioCache.continuationCacheSeconds` | 8 s | Tail window in RAM |
| `AudioEngineService.maxImmediateContinuationSlices` | 1 | File fallback / refill at a cut |
| `TransportClock.sectionExitSuppression` / `boundaryRestartSuppression` | 0.75 s | Ignore stale end-clock right after wrap/jump |

---

## Flags (do not overload)

| Flag | Means | Must not mean |
|------|--------|----------------|
| `loopPrebufferTriggered` | A loop **body** is on the FIFO (or jump arm succeeded) | Metadata-only repeat |
| `isLinearContinuationQueued` | Cached/file **tails after the current section** are on the FIFO | A queued **jump** to another section |
| `hasQueuedLoopBody` | `scheduledLoopCycleCount > 0` | Metadata-only `armedBoundaryJump` |
| `hasArmedBoundaryJump` | A wrap or jump boundary is armed | “Continuation is ready” |

`shouldPrearmRepeatAudio(alreadyArmed:)` must use **`loopPrebufferTriggered`**, not `hasArmedBoundaryJump`. Metadata-only sets the latter and must still prearm the body.

---

## Forbidden “fixes”

| Tempting change | What it actually does |
|-----------------|------------------------|
| `stop()` + `play(at:)` / `play()` on live or standby at wrap/exit | `got N want: 1`, graph death |
| `scheduleBuffer` / `scheduleSegment` timed with `lastRenderTime + remaining` | Starved node, silent wrap |
| Append 12 file 8 s segments at the cut (`live-cont` without cache) | HAL skip, audible hole, often graph death |
| `appendLivePlayback` the rest of the song (`sliced into 23 × 8s`) | Same, worse |
| Splice 12 extra PCM buffers **in the wrap quantum** | HAL skip on the wrap that was already gapless |
| Set `isLinearContinuationQueued` from `live-jump` | Next section exits into silence |
| Keep `playingSection` after seeking past the section | `play()` caps at the old end, schedules nothing, `Audio playback is unavailable` |
| Set `loopPrebufferTriggered` on metadata-only arm | Next wrap finds an empty FIFO (second wrap silent) |
| `append live-cont` on disable after a queued body | Extra loop + playhead jumps to section end |
| Reanchor playhead to section end when continuation is already playing | Visual gap; audio still in the extra cycle |
| Treat `sampleTime` not resetting as a wrap failure | Unnecessary restart |

---

## Log decoder

Healthy loop wrap:

```
enabledRepeatAtEnd — metadata only
append-cycle-1 | clip "…" cached body frames … at:nil
audio-led repeat boundary … -> …
completed repeat boundary jump … without restart
one-shot wrap consumed — extra cycle is playingSection
```

Healthy exit into the song:

```
… cached tail frames … at:nil
appended live FIFO live-cont … cached-tail
section exit — live FIFO continue at …
```

Healthy queued jump, then dest continues the song:

```
appended live FIFO live-jump … more until <destEnd>
completed section boundary jump …
… later, near dest end …
appended live FIFO live-cont … cached-tail
```

Broken (do not ship):

| Log | Meaning |
|-----|---------|
| `live-cont \| clip "…" timeline […, …) … frames 352800` **without** `cached tail` | File dump at the cut |
| `HALC … skipping cycle due to overload` then `got N want: 1` | Graph death from that dump or from `play()` |
| `live-jump … more until <destEnd>` then `section exit` with **no** later `live-cont` | Jump marked as continuation; dest FIFO empty |
| `enabledRepeatAtEnd` then wrap with no `append-cycle` / `adopt-cycle` | `loopPrebufferTriggered` set without a body |
| `vmPlaying=0 … audioPlaying=0` after a cut | Engine died; next pad restarts from silence |

---

## Tests (run after any edit in this area)

```bash
xcodebuild test -scheme LvoqPlayback -destination 'platform=macOS' \
  -only-testing:LvoqPlaybackTests/ArrangementPlaybackEngineTests \
  -only-testing:LvoqPlaybackTests/ArrangementPlaybackEngineAdvanceTests \
  -only-testing:LvoqPlaybackTests/PlaybackTransportControllerTests \
  -only-testing:LvoqPlaybackTests/SectionPlaybackCoordinatorTests \
  -only-testing:LvoqPlaybackTests/SectionCueClockTests \
  -only-testing:LvoqPlaybackTests/SectionStandbyCoordinatorTests \
  -only-testing:LvoqPlaybackTests/PlaybackDeltaPolicyTests \
  -only-testing:LvoqPlaybackTests/SectionAudioCacheTests
```

Manual (required, unit tests cannot hear HAL):

1. Tap A twice → extra cycle → song continues, **no hole** at the join. Repeat a second time.
2. Tap A, then tap A again to disable before the end → **no** extra loop; playhead stays with audio.
3. Tap A, tap A (arm), let wrap, tap A during extra cycle → one more wrap, then song.
4. Tap A, queue B, let B end into the song → **not** silence after B.
5. Console: `cached tail` / `cached-tail` at exits; never `sliced into 23 × 8s`; never `got N want: 1`.

---

## If you must change this

1. Read this file and `PlaybackDeltaPolicy.swift`.
2. Name which **layer** you are editing (state vs transport vs FIFO).
3. Prefer a new helper over collapsing FIFO + restart into one function.
4. After Swift changes: `graphify update .`
5. Run the test command above **and** the manual checklist. A green unit test suite is not enough.
