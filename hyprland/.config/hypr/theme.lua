-- Appearance, animations, and layout behavior.

hl.config({
    general = {
        gaps_in = 2,
        gaps_out = 4,
        border_size = 1,
        layout = "dwindle",
    },

    decoration = {
        rounding = 8,
        blur = {
            enabled = true,
            size = 8,
            passes = 2,
            new_optimizations = true,
        },
        shadow = {
            enabled = true,
            range = 15,
            render_power = 2,
        },
    },

    animations = {
        enabled = true,
    },

    dwindle = {
        preserve_split = true,
        force_split = 2,
    },

    master = {
        new_status = "master",
    },

    misc = {
        disable_hyprland_logo = true,
        disable_splash_rendering = true,
    },
})

require("colors")

hl.curve("myBezier", {
    type = "bezier",
    points = { { 0.05, 0.9 }, { 0.1, 1.05 } },
})
hl.curve("linear", {
    type = "bezier",
    points = { { 0, 0 }, { 1, 1 } },
})
hl.curve("easeOut", {
    type = "bezier",
    points = { { 0.16, 1 }, { 0.3, 1 } },
})

hl.animation({
    leaf = "windows",
    enabled = true,
    speed = 3,
    bezier = "myBezier",
})
hl.animation({
    leaf = "windowsOut",
    enabled = true,
    speed = 3,
    bezier = "default",
    style = "popin 80%",
})
hl.animation({
    leaf = "fade",
    enabled = true,
    speed = 3,
    bezier = "default",
})
hl.animation({
    leaf = "workspaces",
    enabled = true,
    speed = 2,
    bezier = "easeOut",
    style = "slide",
})
hl.animation({
    leaf = "border",
    enabled = true,
    speed = 5,
    bezier = "default",
})
