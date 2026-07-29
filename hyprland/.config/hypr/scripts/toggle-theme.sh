#!/bin/bash
# Toggle between light and dark themes.

CURRENT=$(gsettings get org.gnome.desktop.interface color-scheme)

if [[ "$CURRENT" == *"prefer-dark"* ]]; then
    gsettings set org.gnome.desktop.interface color-scheme 'prefer-light'
    ACTIVE_BORDER="rgba(5c6a72ff)"
    INACTIVE_BORDER="rgba(a6b0a0ff)"
    SHADOW_COLOR="rgba(9da9a066)"
else
    gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
    ACTIVE_BORDER="rgba(6272A4ff)"
    INACTIVE_BORDER="rgba(44475Aff)"
    SHADOW_COLOR="rgba(1a1a1aee)"
fi

hyprctl eval "
hl.config({
    general = {
        col = {
            active_border = \"$ACTIVE_BORDER\",
            inactive_border = \"$INACTIVE_BORDER\",
        },
    },
    decoration = {
        shadow = {
            color = \"$SHADOW_COLOR\",
        },
    },
})
"
