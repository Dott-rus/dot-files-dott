local c = require("conf.common")

-- Same geometry as in your niri config:
-- laptop panel on the left, external 170 Hz monitor on the right.
hl.monitor({
  output = c.monitors.laptop,
  mode = "1920x1080@60.01",
  position = "0x0",
  scale = 1,
})

hl.monitor({
  output = c.monitors.main,
  mode = "1920x1080@170",
  position = "1920x0",
  scale = 1,
})

-- Fallback for random monitors/projectors.
hl.monitor({
  output = "",
  mode = "preferred",
  position = "auto",
  scale = 1,
})
