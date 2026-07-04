# Dott Hyprland Lua config

Собрано из твоего niri KDL, но под новый Hyprland Lua config (`hyprland.lua`).

## Что внутри

```text
~/.config/hypr/
├── hyprland.lua          # entrypoint, грузит модули
├── conf/
│   ├── common.lua        # mod/apps/monitor names
│   ├── env.lua           # env + AQ_DRM_DEVICES
│   ├── monitors.lua      # eDP-1 + HDMI-A-1
│   ├── input.lua         # us/ru, touchpad, mouse, binds timing
│   ├── appearance.lua    # gaps, border, shadows, animations, dwindle
│   ├── workspaces.lua    # 1..9 -> HDMI, 10 -> eDP, scratchpad
│   ├── autostart.lua     # waybar/swaync/swayosd/albert/activitywatch/etc
│   ├── rules.lua         # Albert, FlClash, PiP, modals, XWayland ghost fix
│   ├── binds.lua         # all binds
│   └── hooks.lua         # startup focus
└── scripts/
    ├── screenshot.sh
    └── switch-layout.sh
```

## Установка

```bash
mkdir -p ~/.config/hypr
cp -r ./hyprland.lua ./conf ./scripts ~/.config/hypr/
chmod +x ~/.config/hypr/scripts/*.sh
hyprctl reload
```

Если ты уже внутри Hyprland 0.55+, он берёт `~/.config/hypr/hyprland.lua`. Если рядом лежит старый `hyprland.conf`, Lua всё равно будет главным, пока существует `hyprland.lua`.

## Важные места, которые стоит проверить

1. `conf/env.lua` — я перенёс `WLR_DRM_DEVICES` в `AQ_DRM_DEVICES`, потому Hyprland сейчас на Aquamarine. Но `/dev/dri/cardN` может меняться между загрузками. Лучше потом заменить на стабильные `/dev/dri/by-path` или udev symlinks.
2. `conf/autostart.lua` — у тебя было `awww-daemon`. Я оставил как есть. Если это был `swww-daemon`, поправь одну строку.
3. `conf/rules.lua` — для Discord/FlClash/Albert class может отличаться. Проверяется через:

```bash
hyprctl clients
```

4. `scripts/switch-layout.sh` требует `jq` для fallback-режима. Основной путь пробует `hyprctl switchxkblayout all next`.

## Пакеты, которые конфиг ожидает

```bash
sudo pacman -S --needed waybar swaync swayosd playerctl jq grim slurp wl-clipboard
```

Опционально: `grimblast`, `hyprshot`, `albert`, `wlsunset`, `activitywatch`, `flclashx`, `wl-kbptr`.
