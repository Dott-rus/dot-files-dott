local c = require("conf.common")

-- Hyprland-native fixed-ish workspaces.
-- 1..9 live on HDMI-A-1, 10 lives on eDP-1.
for i = 1, 9 do
  hl.workspace_rule({
    workspace = tostring(i),
    monitor = c.monitors.main,
    persistent = true,
    default = (i == 1),
  })
end

hl.workspace_rule({
  workspace = "10",
  monitor = c.monitors.laptop,
  persistent = true,
  default = true,
})

-- Scratchpad / special workspace. Hyprland finally gives us the thing niri lacked.
hl.workspace_rule({
  workspace = "special:scratch",
  gaps_in = 10,
  gaps_out = 24,
})
