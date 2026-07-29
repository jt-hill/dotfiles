-- Follow the desktop color-scheme setting changed by toggle-theme.sh.
local scheme = ""
local command = io.popen(
    "gsettings get org.gnome.desktop.interface color-scheme 2>/dev/null"
)

if command ~= nil then
    scheme = command:read("*a")
    command:close()
end

local light = scheme:find("prefer-light", 1, true) ~= nil

hl.config({
    general = {
        col = {
            active_border = light and "rgba(5c6a72ff)" or "rgba(6272A4ff)",
            inactive_border = light and "rgba(a6b0a0ff)" or "rgba(44475Aff)",
        },
    },
    decoration = {
        shadow = {
            color = light and "rgba(9da9a066)" or "rgba(1a1a1aee)",
        },
    },
})
