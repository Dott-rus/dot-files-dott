-- Autostart. Every command is guarded against duplicate starts where it makes sense.

local function once(name, cmd)
  hl.exec_cmd("pgrep -x " .. name .. " >/dev/null 2>&1 || " .. cmd)
end

local function once_fuzzy(pattern, cmd)
  hl.exec_cmd("pgrep -f '" .. pattern .. "' >/dev/null 2>&1 || " .. cmd)
end

hl.on("hyprland.start", function()
  -- once("waybar", "waybar")         -- disabled: replaced by Tide Island
  once("quickshell", "quickshell -p $HOME/.config/tide-island")
  once("swayosd-server", "swayosd-server")
  once("swaync", "swaync")
  once("albert", "albert")

  -- Your config said awww-daemon. If that was a typo and you use swww, swap it here.
  once("awww-daemon", "awww-daemon")

  hl.exec_cmd("/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1")

  once_fuzzy("wlsunset -S 07:00", "wlsunset -S 07:00 -s 20:00 -t 4000 -T 6500 -d 1800")

  once("aw-qt", "aw-qt")
  once_fuzzy("aw-watcher-media-player", "/usr/bin/aw-watcher-media-player")
  hl.exec_cmd("if [ -x \"$HOME/.cargo/bin/aw-watcher-window-wayland\" ]; then exec \"$HOME/.cargo/bin/aw-watcher-window-wayland\"; elif command -v aw-watcher-window-wayland >/dev/null 2>&1; then exec aw-watcher-window-wayland; fi")

  once("flclashx", "/usr/bin/flclashx")
end)
