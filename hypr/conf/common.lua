local M = {}

M.mod = "SUPER"

M.apps = {
  terminal = "alacritty",
  file_manager = "nemo",
  launcher = "albert toggle",
  browser = "firefox",
}

M.paths = {
  screenshot = "$HOME/.config/hypr/scripts/screenshot.sh",
  switch_layout = "$HOME/.config/hypr/scripts/switch-layout.sh",
}

M.monitors = {
  main = "HDMI-A-1",
  laptop = "eDP-1",
}

return M
