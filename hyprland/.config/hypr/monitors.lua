-- Monitor configuration.

-- ASUS PG278Q ROG Swift via Thunderbolt dock.
-- The EDID override provides 120 Hz and 1.07 is the nearest valid scale to 1.1.
hl.monitor({
    output = "DP-1",
    mode = "2560x1440@120",
    position = "0x0",
    scale = 1.07,
})

-- ThinkPad panel. dock-mode.sh manages its enabled state and placement.
hl.monitor({
    output = "eDP-1",
    mode = "preferred",
    position = "auto",
    scale = 1.666667,
})

-- Fallback for any other monitor.
hl.monitor({
    output = "",
    mode = "preferred",
    position = "auto",
    scale = 1,
})

-- Keep the normal desktop on the external monitor when it is available.
for workspace = 1, 10 do
    hl.workspace_rule({
        workspace = tostring(workspace),
        monitor = "DP-1",
        default = workspace == 1,
    })
end

local dock_mode = os.getenv("HOME") .. "/.config/hypr/scripts/dock-mode.sh auto"

hl.bind(
    "switch:on:Lid Switch",
    hl.dsp.exec_cmd(dock_mode),
    { locked = true }
)
hl.bind(
    "switch:off:Lid Switch",
    hl.dsp.exec_cmd(dock_mode),
    { locked = true }
)
