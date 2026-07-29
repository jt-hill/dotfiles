-- Session startup.

hl.on("hyprland.start", function()
    local commands = {
        "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP",
        "systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP",
        "/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1",
        "hypridle",
        "mako",
        "sleep 1 && ~/.config/hypr/scripts/dock-mode.sh auto",
        "hyprpaper",
        "waybar",
        "nwg-drawer -r -c 7 -is 90 -mb 10 -ml 50 -mr 50 -mt 10",
        "wl-paste --type text --watch cliphist store",
        "wl-paste --type image --watch cliphist store",
        "udiskie --tray",
        "nm-applet --indicator",
        "blueman-applet",
        "ckb-next -b",
        "gnome-keyring-daemon --start --components=secrets",
        "eval $(gnome-keyring-daemon --start)",
        "sleep 2 && firewall-applet",
    }

    for _, command in ipairs(commands) do
        hl.exec_cmd(command)
    end

    hl.exec_cmd("joplin", { workspace = "1 silent" })
end)
