-- Clean, fast, slightly glossy. Not a rice monster, but not default sadness either.

hl.config({
  general = {
    gaps_in = 6,
    gaps_out = 16,
    border_size = 2,
    resize_on_border = true,
    layout = "dwindle",
    col = {
      active_border = "rgba(d4d4d4ee)",
      inactive_border = "rgba(4a4a4aaa)",
    },
  },

  decoration = {
    rounding = 6,
    rounding_power = 2.2,
    active_opacity = 1.0,
    inactive_opacity = 1.0,

    shadow = {
      enabled = true,
      range = 12,
      render_power = 3,
      color = "rgba(0f0f0fcc)",
    },

    blur = {
      enabled = false,
      size = 4,
      passes = 1,
      vibrancy = 0.12,
    },
  },

  animations = {
    enabled = true,
  },

  misc = {
    disable_hyprland_logo = true,
    disable_splash_rendering = true,
    mouse_move_focuses_monitor = true,
    focus_on_activate = false,
    close_special_on_empty = true,
  },

  dwindle = {
    preserve_split = true,
    smart_split = true,
    smart_resizing = true,
  },

  xwayland = {
    enabled = true,
    use_nearest_neighbor = true,
  },
})

-- Soft spring curves — fluid with visible motion, not micro-wobbles.
-- Lower stiffness = slower spring travel, visible bounce.
hl.curve("springSnap",   { type = "spring", mass = 1, stiffness = 120, dampening = 18 })
hl.curve("springSmooth", { type = "spring", mass = 1, stiffness = 70,  dampening = 13 })
hl.curve("springBounce", { type = "spring", mass = 1, stiffness = 50,  dampening = 9 })

hl.animation({ leaf = "global", enabled = true, speed = 8, spring = "springSnap" })
hl.animation({ leaf = "windows", enabled = true, speed = 7, spring = "springSnap" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 6, spring = "springBounce", style = "popin 88%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 7, spring = "springSmooth", style = "popin 88%" })
hl.animation({ leaf = "fade", enabled = true, speed = 7, spring = "springSmooth" })
hl.animation({ leaf = "border", enabled = true, speed = 6, spring = "springSnap" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 9, spring = "springSmooth", style = "slidefade 30%" })
