local c = require("conf.common")
local MOD = c.mod

local function bind(keys, dispatcher, description, flags)
	flags = flags or {}
	if description then
		flags.description = description
	end
	hl.bind(keys, dispatcher, flags)
end

-- Apps
bind(MOD .. " + Q", hl.dsp.exec_cmd(c.apps.terminal), "Terminal")
bind(MOD .. " + E", hl.dsp.exec_cmd(c.apps.file_manager), "File manager")
bind(MOD .. " + Space", hl.dsp.exec_cmd(c.apps.launcher), "Albert")

-- Session / window basics
bind(MOD .. " + C", hl.dsp.window.close(), "Close window")
bind(
	MOD .. " + M",
	hl.dsp.exec_cmd(
		'command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || uwsm stop || loginctl terminate-user "$USER"'
	),
	"Exit session"
)
bind(MOD .. " + F", hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }), "Fullscreen")
bind(MOD .. " + SHIFT + F", hl.dsp.window.fullscreen({ mode = "maximized", action = "toggle" }), "Maximize")
bind(
	MOD .. " + CTRL + F",
	hl.dsp.window.fullscreen_state({ internal = 2, client = 0, action = "toggle" }),
	"Fake fullscreen"
)
bind(MOD .. " + V", hl.dsp.window.float({ action = "toggle" }), "Toggle floating")
bind(MOD .. " + P", hl.dsp.window.pseudo({ action = "toggle" }), "Pseudo tile")
bind(MOD .. " + J", hl.dsp.layout("togglesplit"), "Toggle dwindle split")
bind(MOD .. " + G", hl.dsp.group.toggle(), "Toggle tabbed group")

-- Show/disable stuff
bind(MOD .. " + SHIFT + slash", hl.dsp.exec_cmd("hyprctl binds | less"), "Show keybinds")
bind(MOD .. " + Escape", hl.dsp.submap("passthrough"), "Temporarily disable Hypr binds")

hl.define_submap("passthrough", function()
	bind(MOD .. " + Escape", hl.dsp.submap("reset"), "Re-enable Hypr binds")
end)

-- Safer monitor sleep. Hyprland docs advise delaying DPMS when bound to a key.
bind(MOD .. " + SHIFT + M", function()
	hl.timer(function()
		hl.dispatch(hl.dsp.dpms({ action = "off" }))
	end, { timeout = 500, type = "oneshot" })
end, "Turn monitors off")

-- Discord mute. Works only if class/title match your Discord build; check with `hyprctl clients`.
bind(
	MOD .. " + Z",
	hl.dsp.send_shortcut({ mods = "CTRL SHIFT", key = "m", window = "class:^(discord|Discord|vesktop|Vesktop)$" }),
	"Discord mute"
)

-- Keyboard layout switching.
bind(MOD .. " + VoidSymbol", hl.dsp.exec_cmd(c.paths.switch_layout .. " next"), "Next keyboard layout")
bind("ALT + Caps_Lock", hl.dsp.exec_cmd(c.paths.switch_layout .. " next"), "Next keyboard layout")
bind(MOD .. " + SHIFT + Caps_Lock", hl.dsp.exec_cmd(c.paths.switch_layout .. " prev"), "Previous keyboard layout")

-- Focus
bind(MOD .. " + left", hl.dsp.focus({ direction = "left" }), "Focus left")
bind(MOD .. " + right", hl.dsp.focus({ direction = "right" }), "Focus right")
bind(MOD .. " + up", hl.dsp.focus({ direction = "up" }), "Focus up")
bind(MOD .. " + down", hl.dsp.focus({ direction = "down" }), "Focus down")

-- Move windows in the layout
bind(MOD .. " + SHIFT + left", hl.dsp.window.move({ direction = "left" }), "Move window left")
bind(MOD .. " + SHIFT + right", hl.dsp.window.move({ direction = "right" }), "Move window right")
bind(MOD .. " + SHIFT + up", hl.dsp.window.move({ direction = "up" }), "Move window up")
bind(MOD .. " + SHIFT + down", hl.dsp.window.move({ direction = "down" }), "Move window down")

-- Monitor focus
bind(MOD .. " + CTRL + left", hl.dsp.focus({ monitor = "l" }), "Focus monitor left")
bind(MOD .. " + CTRL + right", hl.dsp.focus({ monitor = "r" }), "Focus monitor right")
bind(MOD .. " + CTRL + up", hl.dsp.focus({ monitor = "u" }), "Focus monitor up")
bind(MOD .. " + CTRL + down", hl.dsp.focus({ monitor = "d" }), "Focus monitor down")

-- Move window to monitor and follow it
bind(
	MOD .. " + CTRL + SHIFT + left",
	hl.dsp.window.move({ monitor = "l", follow = true }),
	"Move window to monitor left"
)
bind(
	MOD .. " + CTRL + SHIFT + right",
	hl.dsp.window.move({ monitor = "r", follow = true }),
	"Move window to monitor right"
)
bind(MOD .. " + CTRL + SHIFT + up", hl.dsp.window.move({ monitor = "u", follow = true }), "Move window to monitor up")
bind(
	MOD .. " + CTRL + SHIFT + down",
	hl.dsp.window.move({ monitor = "d", follow = true }),
	"Move window to monitor down"
)

-- Workspaces 1..10. Key 0 maps to workspace 10.
for i = 1, 10 do
	local key = tostring(i % 10)
	bind(MOD .. " + " .. key, hl.dsp.focus({ workspace = i }), "Workspace " .. i)
	bind(MOD .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }), "Move window to workspace " .. i)
	bind(
		MOD .. " + CTRL + " .. key,
		hl.dsp.window.move({ workspace = i, follow = true }),
		"Move window to workspace " .. i .. " and follow"
	)
end

-- Scratchpad / special workspace
bind(MOD .. " + S", hl.dsp.workspace.toggle_special("scratch"), "Toggle scratchpad")
bind(MOD .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:scratch" }), "Move window to scratchpad")

-- Workspace scroll. m± keeps it per-monitor; r± includes empty workspaces.
bind(MOD .. " + mouse_down", hl.dsp.focus({ workspace = "m+1" }), "Next workspace")
bind(MOD .. " + mouse_up", hl.dsp.focus({ workspace = "m-1" }), "Previous workspace")
bind(MOD .. " + mouse_right", hl.dsp.focus({ direction = "right" }), "Focus right")
bind(MOD .. " + mouse_left", hl.dsp.focus({ direction = "left" }), "Focus left")

-- Mouse drag/resize
bind(MOD .. " + mouse:272", hl.dsp.window.drag(), "Drag window", { mouse = true })
bind(MOD .. " + mouse:273", hl.dsp.window.resize(), "Resize window", { mouse = true })

-- wl-kbptr
bind(MOD .. " + A", hl.dsp.exec_cmd("wl-kbptr"), "wl-kbptr")
bind(MOD .. " + SHIFT + A", hl.dsp.exec_cmd("pkill wl-kbptr"), "Kill wl-kbptr")

-- Screenshots
bind("Print", hl.dsp.exec_cmd(c.paths.screenshot .. " area"), "Screenshot area")
bind("CTRL + Print", hl.dsp.exec_cmd(c.paths.screenshot .. " screen"), "Screenshot screen")
bind("ALT + Print", hl.dsp.exec_cmd(c.paths.screenshot .. " window"), "Screenshot window")

-- Media keys
bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), "Next track", { locked = true })
bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), "Previous track", { locked = true })
bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), "Play/pause", { locked = true })
bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), "Play/pause", { locked = true })

-- swayosd volume/mic/brightness
bind(
	"XF86AudioRaiseVolume",
	hl.dsp.exec_cmd("swayosd-client --output-volume raise"),
	"Volume up",
	{ locked = true, repeating = true }
)
bind(
	"XF86AudioLowerVolume",
	hl.dsp.exec_cmd("swayosd-client --output-volume lower"),
	"Volume down",
	{ locked = true, repeating = true }
)
bind("XF86AudioMute", hl.dsp.exec_cmd("swayosd-client --output-volume mute-toggle"), "Mute", { locked = true })
bind("XF86AudioMicMute", hl.dsp.exec_cmd("swayosd-client --input-volume mute-toggle"), "Mic mute", { locked = true })
bind(
	"XF86MonBrightnessUp",
	hl.dsp.exec_cmd("swayosd-client --brightness raise"),
	"Brightness up",
	{ locked = true, repeating = true }
)
bind(
	"XF86MonBrightnessDown",
	hl.dsp.exec_cmd("swayosd-client --brightness lower"),
	"Brightness down",
	{ locked = true, repeating = true }
)

-- Tide Island
bind(
	MOD .. " + TAB",
	hl.dsp.exec_cmd("/usr/bin/quickshell ipc -p $HOME/.config/tide-island call overview toggle"),
	"Overview"
)

bind(
	MOD .. " + right",
	hl.dsp.exec_cmd("/usr/bin/quickshell ipc -p $HOME/.config/tide-island call tide showLyrics"),
	"Lyrics"
)

bind(
	MOD .. " + left",
	hl.dsp.exec_cmd("/usr/bin/quickshell ipc -p $HOME/.config/tide-island call tide showCustom"),
	"Custom panel"
)

bind(
	MOD .. " + down",
	hl.dsp.exec_cmd("/usr/bin/quickshell ipc -p $HOME/.config/tide-island call tide showClock"),
	"Clock"
)

bind(
	MOD .. " + SHIFT + M",
	hl.dsp.exec_cmd("/usr/bin/quickshell ipc -p $HOME/.config/tide-island call tide togglePlayer"),
	"Player"
)

bind(
	MOD .. " + SHIFT + C",
	hl.dsp.exec_cmd("/usr/bin/quickshell ipc -p $HOME/.config/tide-island call tide toggleControlCenter"),
	"Control Center"
)

bind(
	MOD .. " + W",
	hl.dsp.exec_cmd("/usr/bin/quickshell ipc -p $HOME/.config/tide-island call tide toggleWallpaperPicker"),
	"Wallpaper Picker"
)

-- Panel modes
bind(
	MOD .. " + F9",
	hl.dsp.exec_cmd("/usr/bin/quickshell ipc -p $HOME/.config/tide-island call tide toggleFocus"),
	"Toggle focus mode"
)

bind(
	MOD .. " + F10",
	hl.dsp.exec_cmd("/usr/bin/quickshell ipc -p $HOME/.config/tide-island call tide toggleGaming"),
	"Toggle gaming mode"
)

bind(
	MOD .. " + F11",
	hl.dsp.exec_cmd("/usr/bin/quickshell ipc -p $HOME/.config/tide-island call tide modeNormal"),
	"Normal panel mode"
)
