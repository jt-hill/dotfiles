-- Window rules. Related effects are grouped into one rule per matcher.

hl.window_rule({
    match = { class = "^.*[Yy]ad.*$" },
    float = true,
    center = true,
})

hl.window_rule({
    match = { class = "^.*blueman.*$" },
    float = true,
    center = true,
    size = { "monitor_w*0.4", "monitor_h*0.3" },
})

hl.window_rule({
    match = { class = "^.*pavucontrol.*$" },
    float = true,
    center = true,
    size = { "monitor_w*0.4", "monitor_h*0.3" },
})

hl.window_rule({
    match = { title = "^.*(Open|Save).*$" },
    float = true,
})

hl.window_rule({
    match = { title = "^.*File Operation Progress.*$" },
    float = true,
    center = true,
    size = { "monitor_w*0.4", "monitor_h*0.3" },
    pin = true,
})

hl.window_rule({
    match = { title = "^.*[Pp]icture.in.[Pp]icture.*$" },
    float = true,
    pin = true,
})

hl.window_rule({
    match = { title = "^waybar_htop$" },
    float = true,
    center = true,
    size = { "monitor_w*0.7", "monitor_h*0.7" },
})

hl.window_rule({
    match = { title = "^waybar_nmtui$" },
    float = true,
    center = true,
})

hl.window_rule({
    match = { title = "^.*Firefox.*Sharing Indicator.*$" },
    workspace = "special silent",
})

for _, class in ipairs({
    "^.*zen.*$",
    "^.*[Cc]hromium.*$",
    "^.*[Ff]irefox.*$",
}) do
    hl.window_rule({
        match = { class = class },
        idle_inhibit = "fullscreen",
    })
end

hl.window_rule({
    match = { class = "^.*floating_shell_portrait.*$" },
    float = true,
    center = true,
    size = { "monitor_w*0.3", "monitor_h*0.4" },
    pin = true,
})
