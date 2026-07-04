# Tide Island

Based on the incredible work of [Swen](https://github.com/enhaoswen/Tide-island).

> A Quickshell-based dynamic island panel for Hyprland.

---

## Modifications by dott + DeepSeek (opencode)

### Focus / Gaming Mode

Three panel modes: `normal`, `focus`, `gaming`.

- **normal** — original compact capsule behavior.
- **focus** / **gaming** — the capsule stretches to full screen width (no border radius, y=0, height 60px) and shows a wide info bar:
  - Small mode badge (`FOCUS` / `GAMING`) that fades out after 3 seconds
  - Currently playing track (`TITLE - ARTIST` from MPRIS) on the left
  - Battery level with icon on the right (color-coded for charging / low battery)
- Transition between modes is animated (400ms OutQuint).

### IPC Commands

```bash
quickshell ipc -p ~/.config/tide-island call tide setMode normal
quickshell ipc -p ~/.config/tide-island call tide setMode focus
quickshell ipc -p ~/.config/tide-island call tide setMode gaming
quickshell ipc -p ~/.config/tide-island call tide toggleFocus
quickshell ipc -p ~/.config/tide-island call tide toggleGaming
```

### Hyprland Keybinds

Added to `conf/binds.lua`:

| Key | Action |
|---|---|
| `MOD + F9` | Toggle focus mode |
| `MOD + F10` | Toggle gaming mode |
| `MOD + F11` | Set normal mode |

### Changes

| File | Line(s) | What |
|---|---|---|
| `shell.qml` | 14, 71–82, 145–155 | `mode` state, `setMode()`/`toggleFocus()`/`toggleGaming()`, IPC handlers |
| `DynamicIslandWindow.qml` | 44–46, 1339, 1359, 1377, 1394, 1420, 1287, 1988–2100 | Mode-aware capsule sizing, mode overlay with badge/track/battery, disable auto-expand on track change in non-normal modes |
| `conf/binds.lua` | 213–230 | Hyprland keybinds for mode toggling |

---

## Original Author

- **Swen** — [github.com/enhaoswen/Tide-island](https://github.com/enhaoswen/Tide-island)
