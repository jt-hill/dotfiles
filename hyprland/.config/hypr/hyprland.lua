-- Hyprland configuration
-- Lua configuration is supported by Hyprland 0.55 and newer.

require("environments")

hl.config({
    xwayland = {
        -- Render XWayland clients at native resolution and let Hyprland scale.
        force_zero_scaling = true,
    },
})

require("monitors")
require("input")
require("theme")
require("windowrules")
require("keybinds")
require("autostart")
