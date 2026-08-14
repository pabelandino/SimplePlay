# Audio Engine — Agent Guide

**Read this before editing playback, sync, or device routing.**

SimplePlay’s audio stack is split on purpose. Changing the wrong file reintroduces subtle bugs (iPad drift, `SessionCore paramErr`, “Could not start the audio engine”, `play() startAudioPlayback failed`).

## Architecture (do not collapse)

| Layer | Files | Responsibility |
|-------|--------|----------------|
| **Core engine** | `AudioEngineService.swift` | Graph, scheduling, meters, loop, shared playback bridge. **No platform `#if` for routing or timing.** |
| **Platform routing** | `AudioEnginePlatformServices.swift`, `AudioEngineServiceMacOS.swift`, `AudioEngineServiceIOS.swift` | Output device + `AVAudioSession` only. |
| **Platform playback timing** | `Playback/PlatformPlaybackStrategy.swift`, `MacOSPlaybackStrategy.swift`, `IOSPlaybackStrategy.swift` | Host-time vs sample-relative anchors, latency compensation, `play(at:)`. |
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

## Log messages

| Log | Likely cause | Where to look |
|-----|----------------|---------------|
| `SessionCore.mm:546 … 4294967246` | Invalid session property (often `setPreferredInput` or HFP on playback) | `AudioEngineServiceIOS` |
| `play() startAudioPlayback failed — pausing arrangement` | Engine/graph not healthy after failed session or bad device state | `WorkspaceViewModel`, then platform session + `IOSPlaybackStrategy` |
| `Could not start the audio engine` | `configureSessionBeforeEngineGraph` or `engine.start()` failed; on iOS, also check **second** session reconfigure after `engine.start()` (must not happen) | Platform services + saved device validation in UI |

## Testing checklist

- [ ] iPad: open project saved with **disconnected** USB interface → plays on system default, no SessionCore spam.
- [ ] iPad: section triggers + LyricPlay sync still aligned.
- [ ] Mac: output device change while engine running.
- [ ] Mac + iPad: loop boundary restart.
