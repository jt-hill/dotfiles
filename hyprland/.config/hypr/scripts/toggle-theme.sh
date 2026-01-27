#!/bin/bash
# Toggle between light and dark themes

CONFIG_DIR="$HOME/.config/hypr"
CURRENT=$(readlink "$CONFIG_DIR/colors.conf")

if [[ "$CURRENT" == "colors-dark.conf" ]]; then
    ln -sf colors-light.conf "$CONFIG_DIR/colors.conf"
    gsettings set org.gnome.desktop.interface color-scheme 'prefer-light'
else
    ln -sf colors-dark.conf "$CONFIG_DIR/colors.conf"
    gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
fi

hyprctl reload
