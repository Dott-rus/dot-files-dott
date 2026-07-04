-- Dott's Hyprland Lua config
-- Generated from the uploaded niri KDL config.
-- Target: Hyprland 0.55+ Lua config, split into small readable files.

local modules = {
	"conf.env",
	"conf.monitors",
	"conf.input",
	"conf.appearance",
	"conf.workspaces",
	"conf.autostart",
	"conf.rules",
	"conf.binds",
	"conf.hooks",
}

local function safe_require(name)
	local ok, err = pcall(require, name)
	if not ok then
		print("[dott-hypr] failed to load " .. name .. ": " .. tostring(err))
	end
end

for _, name in ipairs(modules) do
	safe_require(name)
end
