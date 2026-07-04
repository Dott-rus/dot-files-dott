-- Rules are evaluated top-to-bottom. Keep broad rules first, picky rules later.

-- Apps love asking to maximize themselves. No.
hl.window_rule({
  name = "suppress-maximize-events",
  match = { class = ".*" },
  suppress_event = "maximize",
})

-- Albert: launcher should feel like a launcher, not like a sad tiled window.
hl.window_rule({
  name = "albert-floating",
  match = { class = "^(albert|Albert)$" },
  float = true,
  center = true,
  no_shadow = true,
  decorate = false,
  no_initial_focus = false,
})

-- FlClash on the laptop workspace, quietly.
hl.window_rule({
  name = "flclash-on-laptop",
  match = { class = "^(flclashx|FlClash|flclash)$" },
  workspace = "10 silent",
  no_initial_focus = true,
})

-- Picture-in-Picture: floating, pinned, corner-ish.
hl.window_rule({
  name = "browser-pip",
  match = {
    class = "^(firefox|librewolf|zen)$",
    title = "^Picture-in-Picture$",
  },
  float = true,
  pin = true,
  size = { 520, 292 },
  move = { "monitor_w-window_w-32", "monitor_h-window_h-32" },
})

-- Terminals: keep predictable width when spawned as float via rules/scripts.
hl.window_rule({
  name = "terminal-min-size",
  match = { class = "^(Alacritty|alacritty)$" },
  min_size = { 480, 260 },
})

-- Modal dialogs: center the annoying little gremlins.
hl.window_rule({
  name = "modal-float-center",
  match = { modal = true },
  float = true,
  center = true,
})

-- Some XWayland helper windows spawn as empty ghost rectangles.
hl.window_rule({
  name = "xwayland-empty-float-no-focus",
  match = {
    class = "^$",
    title = "^$",
    xwayland = true,
    float = true,
    fullscreen = false,
    pin = false,
  },
  no_focus = true,
})
