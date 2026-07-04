local c = require("conf.common")

-- On start, bias focus to the external monitor/workspace 1 like `focus-at-startup` in niri.
hl.on("hyprland.start", function()
  hl.dispatch(hl.dsp.focus({ monitor = c.monitors.main }))
  hl.dispatch(hl.dsp.focus({ workspace = 1 }))
end)

-- Tiny quality-of-life: when Albert closes, focus falls back naturally.
-- Keep this file around for future weird tricks; it is intentionally small now.
