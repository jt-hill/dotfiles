#!/bin/bash
# Open a new terminal window with the same cwd as the focused terminal.
# Falls back to a fresh terminal if the focused window isn't a matching instance.
#
# Usage: new-terminal.sh -t <terminal>

while getopts "t:" opt; do
    case $opt in
        t) terminal=$OPTARG ;;
    esac
done

pid=$(hyprctl activewindow -j | jq -r '.pid')

case $terminal in
    kitty)
        if [ -n "$pid" ] && [ "$pid" != "null" ]; then
            kitty @ --to "unix:@kitty-$pid" launch --type=os-window --cwd=current 2>/dev/null && exit 0
        fi
        exec kitty
        ;;
    *)
        echo "Unsupported terminal: $terminal" >&2
        exit 1
        ;;
esac
