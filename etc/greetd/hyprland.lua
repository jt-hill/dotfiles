-- Minimal Hyprland configuration for the greetd/regreet session.
-- This runs as the greeter user, so keep it self-contained.

hl.monitor({
    output = "DP-1",
    mode = "2560x1440@120",
    position = "0x0",
    scale = 1,
})

hl.monitor({
    output = "eDP-1",
    mode = "preferred",
    position = "auto",
    scale = 1.666667,
})

hl.monitor({
    output = "",
    mode = "preferred",
    position = "auto",
    scale = 1,
})

hl.workspace_rule({
    workspace = "1",
    monitor = "DP-1",
    default = true,
})

hl.config({
    misc = {
        disable_hyprland_logo = true,
        disable_splash_rendering = true,
        force_default_wallpaper = 0,
    },
    input = {
        kb_layout = "us",
    },
})

hl.on("hyprland.start", function()
    hl.exec_cmd([[regreet; hyprctl dispatch 'hl.dsp.exit()']])
end)
