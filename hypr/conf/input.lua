hl.config({
  input = {
    kb_layout = "us,ru",
    kb_options = "caps:none",
    resolve_binds_by_sym = true,

    follow_mouse = 1,
    sensitivity = 0.6,
    accel_profile = "flat",

    touchpad = {
      natural_scroll = true,
      tap_to_click = true,
      disable_while_typing = true,
    },
  },

  binds = {
    scroll_event_delay = 150,
    workspace_back_and_forth = true,
  },

  cursor = {
    sync_gsettings_theme = true,
    no_hardware_cursors = 2,
  },
})

-- Close to your old hot-corner-off vibe: explicit gestures only.
hl.gesture({
  fingers = 3,
  direction = "horizontal",
  action = "workspace",
})
