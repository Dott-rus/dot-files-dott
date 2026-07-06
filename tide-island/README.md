# Tide Island

Based on the incredible work of [Swen](https://github.com/enhaoswen/Tide-island).

> A Quickshell-based dynamic island panel for Hyprland.

---

## Modifications by dott + DeepSeek (opencode)

### Gaming Mode

Two panel modes: `normal`, `gaming`.

- **normal** — original compact capsule behavior.
- **gaming** — the capsule stretches to full screen width (no border radius, y=0, height 60px) and shows a wide info bar:
  - Small `GAMING` badge that fades out after 3 seconds
  - Currently playing track (`TITLE - ARTIST` from MPRIS) on the left
  - Countdown timer (right of track)
  - Battery level with icon on the right (color-coded for charging / low battery)
- Performance toggles on enter: gaps_in=0, gaps_out=0, border_size=0, rounding=0, shadow=off, blur=off, animations=off. Restored on exit via config reload.
- Transition is animated (400ms OutQuint).

### Timer

Built-in countdown timer (no external backend) controlled via IPC.

```bash
# via IPC directly
quickshell ipc -p ~/.config/tide-island call tide timerStop
quickshell ipc -p ~/.config/tide-island call tide timerToggle     # 5 min default
quickshell ipc -p ~/.config/tide-island call tide timerCustom     # reads /tmp/tide-timer-duration

# via helper script (recommended)
tide-timer 25           # 25 minutes
tide-timer 1:30         # 1 hour 30 minutes
tide-timer stop
tide-timer toggle       # 5 minutes
```

The `tide-timer` script is in `~/.local/bin/`. It writes the duration to `/tmp/tide-timer-duration` and calls `timerCustom` IPC, which reads the file via a `Process` + `SplitParser`.

Timer displays as a small popcorn bubble to the right of the capsule in normal mode, and in the mode overlay info bar in gaming mode. Completion triggers a pulsing glow animation.

### System Tray

Native StatusNotifier system tray (`Quickshell.Services.SystemTray`):

- Positioned at the right edge of the screen, next to the capsule.
- **Hover-to-show**: hidden by default; appears when hovering to the right of the capsule (300ms delay before hiding).
- **Left-click** activates the tray item.
- **Right-click** opens the context menu (requires `//@ pragma UseQApplication` in `shell.qml` for platform menu support).
- `//@ pragma UseQApplication` enables Qt platform menus for tray right-click.

### Keyboard Layout Indicator

A pill on the **left edge** of the screen that slides in when the keyboard layout changes:

- Connects to Hyprland's `rawEvent` signal (`Quickshell.Hyprland._Ipc`).
- Filters for `activelayout` events, deduplicates rapid changes.
- Slides in from the left (400ms OutQuint), stays for 2 seconds, slides out.
- Only **bottom-right** and **top-right** corners are rounded (8px); left corners are square against the screen edge.
- Shows the full layout name (e.g., "English (US)", "Russian").
- Hot-updates text if layout changes while visible, extending the display timer.

### IPC Commands

All IPC handlers are under the `tide` target. No arguments supported (Quickshell 0.3.0 limitation):

```bash
# Modes
quickshell ipc -p ~/.config/tide-island call tide modeNormal
quickshell ipc -p ~/.config/tide-island call tide modeGaming
quickshell ipc -p ~/.config/tide-island call tide toggleGaming

# Timer
quickshell ipc -p ~/.config/tide-island call tide timerStop
quickshell ipc -p ~/.config/tide-island call tide timerToggle
quickshell ipc -p ~/.config/tide-island call tide timerCustom

# Existing
quickshell ipc -p ~/.config/tide-island call tide showClock
quickshell ipc -p ~/.config/tide-island call tide showCustom
quickshell ipc -p ~/.config/tide-island call tide showLyrics
quickshell ipc -p ~/.config/tide-island call tide togglePlayer
quickshell ipc -p ~/.config/tide-island call tide toggleControlCenter
quickshell ipc -p ~/.config/tide-island call tide toggleWallpaperPicker
```

### Hyprland Keybinds

Added to `conf/binds.lua`:

| Key | Action |
|---|---|
| `MOD + F9` | Toggle gaming mode |

Keybinds are layout-independent (`resolve_binds_by_sym = false` in `conf/input.lua`).

### Dependencies

- `quickshell >= 0.3.0` (uses `IpcHandler`, `UntypedObjectModel`, `FileView`, `Process`, `Socket`)
- `Quickshell.Services.SystemTray` — system tray support
- `Quickshell.Hyprland._Ipc` — Hyprland event socket (`rawEvent` for layout detection)

### Changes

| File | What |
|---|---|
| `shell.qml` | `//@ pragma UseQApplication`, mode state, IPC handlers (mode/gaming/timer/layout), `Process` for timer reader, `hyprGamingProcess` for gaps/rounding, `Connections` for Hyprland rawEvent |
| `DynamicIslandWindow.qml` | Mode-aware capsule sizing, mode overlay (badge/track/timer/battery), system tray, timer bubble, layout indicator pill, `resetTimer()` |
| `conf/binds.lua` | Hyprland keybinds for mode toggling |
| `conf/input.lua` | `resolve_binds_by_sym = false` for layout-independent binds |
| `~/.local/bin/tide-timer` | Shell script for timer control |
| `~/.local/bin/tide-hypr-gaming` | Shell script to save/restore gaps & rounding for gaming mode |

---

## Original Author

- **Swen** — [github.com/enhaoswen/Tide-island](https://github.com/enhaoswen/Tide-island)
