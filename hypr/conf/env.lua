-- Environment. Keep this early: some variables matter before clients spawn.

hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("XCURSOR_THEME", "elementary")

-- Hyprland/Aquamarine uses AQ_DRM_DEVICES, not the old wlroots WLR_DRM_DEVICES.
-- Your niri file had: /dev/dri/card2:/dev/dri/card1
-- Better long-term: replace cardN with stable /dev/dri/by-path or custom udev symlinks.
hl.env("AQ_DRM_DEVICES", "/dev/dri/card2:/dev/dri/card1")

-- Useful for Electron/Qt/SDL stuff. Comment anything that starts fighting back.
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("GDK_BACKEND", "wayland,x11")
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("SDL_VIDEODRIVER", "wayland")
hl.env("CLUTTER_BACKEND", "wayland")
