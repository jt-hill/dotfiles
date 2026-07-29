-- Keybindings.

local main_mod = "SUPER"
local terminal = "ghostty"
local launcher = "fuzzel"
local menu = "nwg-drawer"
local power_menu = "~/.config/hypr/scripts/power_menu.sh"
local browser = "brave-beta"

local function exec(keys, command, options)
    hl.bind(keys, hl.dsp.exec_cmd(command), options)
end

-- Basic bindings.
exec(main_mod .. " + Return", terminal)
hl.bind(main_mod .. " + Q", hl.dsp.window.close({}))
exec(main_mod .. " + D", launcher)
exec(main_mod .. " + SHIFT + D", menu)
exec(main_mod .. " + SHIFT + E", power_menu)
exec(main_mod .. " + F1", "hyprlock")
exec(main_mod .. " + SHIFT + C", "hyprctl reload")
exec(main_mod .. " + SHIFT + T", "~/.config/hypr/scripts/toggle-theme.sh")
exec(main_mod .. " + SHIFT + M", "~/.config/hypr/scripts/dock-mode.sh toggle")

local directions = {
    Left = "l",
    Right = "r",
    Up = "u",
    Down = "d",
    H = "l",
    L = "r",
    K = "u",
    J = "d",
}

-- Focus and move windows with arrow or Vim keys.
for key, direction in pairs(directions) do
    hl.bind(
        main_mod .. " + " .. key,
        hl.dsp.focus({ direction = direction })
    )
    hl.bind(
        main_mod .. " + SHIFT + " .. key,
        hl.dsp.window.move({ direction = direction })
    )
end

-- Workspace selection and moving windows between workspaces.
for workspace = 1, 10 do
    local key = tostring(workspace % 10)
    local name = tostring(workspace)

    hl.bind(
        main_mod .. " + " .. key,
        hl.dsp.focus({ workspace = name })
    )
    hl.bind(
        main_mod .. " + SHIFT + " .. key,
        hl.dsp.window.move({ workspace = name, follow = true })
    )
end

-- Layout and window state.
hl.bind(main_mod .. " + V", hl.dsp.layout("togglesplit"))
hl.bind(
    main_mod .. " + F",
    hl.dsp.window.fullscreen({ mode = "fullscreen" })
)
hl.bind(main_mod .. " + SHIFT + Space", hl.dsp.window.float({}))
hl.bind(main_mod .. " + Space", hl.dsp.window.cycle_next({}))
hl.bind("ALT + Tab", hl.dsp.window.cycle_next({}))
hl.bind("ALT + SHIFT + Tab", hl.dsp.window.cycle_next({ next = false }))

-- Scratchpad.
hl.bind(
    main_mod .. " + SHIFT + Minus",
    hl.dsp.window.move({ workspace = "special:scratchpad", follow = true })
)
hl.bind(
    main_mod .. " + Minus",
    hl.dsp.workspace.toggle_special("scratchpad")
)

local resize_steps = {
    Right = { x = 10, y = 0 },
    Left = { x = -10, y = 0 },
    Up = { x = 0, y = -10 },
    Down = { x = 0, y = 10 },
    L = { x = 10, y = 0 },
    H = { x = -10, y = 0 },
    K = { x = 0, y = -10 },
    J = { x = 0, y = 10 },
}

for key, delta in pairs(resize_steps) do
    hl.bind(
        main_mod .. " + CTRL + " .. key,
        hl.dsp.window.resize({
            x = delta.x,
            y = delta.y,
            relative = true,
        })
    )
end

-- Mouse movement and resizing.
hl.bind(
    main_mod .. " + mouse:272",
    hl.dsp.window.drag(),
    { mouse = true }
)
hl.bind(
    main_mod .. " + mouse:273",
    hl.dsp.window.resize(),
    { mouse = true }
)

-- Media keys.
exec(
    "XF86AudioRaiseVolume",
    "wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 2%+",
    { repeating = true, locked = true }
)
exec(
    "XF86AudioLowerVolume",
    "wpctl set-volume @DEFAULT_AUDIO_SINK@ 2%-",
    { repeating = true, locked = true }
)
exec(
    "XF86AudioMute",
    "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle",
    { locked = true }
)
exec(
    "XF86AudioMicMute",
    "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle",
    { locked = true }
)
exec("XF86AudioPlay", "playerctl play-pause", { locked = true })
exec("XF86AudioNext", "playerctl next", { locked = true })
exec("XF86AudioPrev", "playerctl previous", { locked = true })
exec(
    "XF86MonBrightnessUp",
    "brightnessctl -c backlight set +5%",
    { repeating = true, locked = true }
)
exec(
    "XF86MonBrightnessDown",
    "brightnessctl -c backlight set 5%-",
    { repeating = true, locked = true }
)

-- Application shortcuts.
exec(main_mod .. " + N", "thunar")
exec(main_mod .. " + O", browser)

-- Clipboard manager.
exec(
    main_mod .. " + CTRL + V",
    [=[cliphist list | fuzzel -d -w 90 -l 30 -p "Select an entry to copy it to your clipboard buffer:" | cliphist decode | wl-copy]=]
)
exec(
    main_mod .. " + CTRL + X",
    [=[cliphist list | fuzzel -d -w 90 -l 30 -t cc9393ff -S cc9393ff -p "Select an entry to delete it from cliphist:" | cliphist delete]=]
)

-- Screenshots.
exec("Print", [=[grim -g "$(slurp)" - | swappy -f -]=])
exec(
    "CTRL + Print",
    [=[grim -g "$(hyprctl activewindow -j | jq -r '"\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"')" - | swappy -f -]=]
)
exec(
    "SHIFT + Print",
    [=[grim -o "$(hyprctl monitors -j | jq -r '.[] | select(.focused) | .name')" - | swappy -f -]=]
)

exec(main_mod .. " + P", "~/.config/hypr/scripts/window_switcher.sh")
