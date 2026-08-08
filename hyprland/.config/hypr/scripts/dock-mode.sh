#!/usr/bin/env bash
# Switch between laptop display modes based on lid state and dock connection.
# Usage: dock-mode.sh [docked|meeting|laptop|toggle|auto]
#
# docked  — external only, all workspaces on DP-1 (lid closed + dock)
# meeting — external above laptop, workspaces split (lid open + dock)
# laptop  — laptop display only, all workspaces on eDP-1 (no dock)
# toggle  — cycle: docked → meeting → docked (only when docked)
# auto    — detect lid + dock state and pick the right mode

STATE_FILE="${XDG_RUNTIME_DIR:-/tmp}/hypr-dock-mode"
INHIBIT_PID_FILE="${XDG_RUNTIME_DIR:-/tmp}/hypr-dock-inhibit.pid"

has_external() {
    hyprctl monitors -j | jq -e '.[] | select(.name == "DP-1")' > /dev/null 2>&1
}

lid_closed() {
    grep -q closed /proc/acpi/button/lid/LID0/state 2>/dev/null \
    || grep -q closed /proc/acpi/button/lid/LID/state 2>/dev/null
}

get_current_mode() {
    if [[ -f "$STATE_FILE" ]]; then
        cat "$STATE_FILE"
    else
        echo "unknown"
    fi
}

# Prevent suspend on lid close while docked
start_inhibit() {
    stop_inhibit
    systemd-inhibit --what=handle-lid-switch \
        --who="hypr-dock-mode" \
        --why="Docked with external monitor" \
        --mode=block \
        tail -f /dev/null &
    echo $! > "$INHIBIT_PID_FILE"
}

stop_inhibit() {
    if [[ -f "$INHIBIT_PID_FILE" ]]; then
        kill "$(cat "$INHIBIT_PID_FILE")" 2>/dev/null
        rm -f "$INHIBIT_PID_FILE"
    fi
}

focus_monitor() {
    local mon="$1"
    # Move cursor and focus to the target monitor
    hyprctl dispatch "hl.dsp.focus({ monitor = \"$mon\" })"
    # Ensure workspace 1 is active and focused on primary
    hyprctl dispatch 'hl.dsp.focus({ workspace = "1" })'
}

move_existing_workspaces() {
    local target="$1"
    local first="$2"
    local last="$3"
    local workspace

    while read -r workspace; do
        if ((workspace >= first && workspace <= last)); then
            hyprctl dispatch "hl.dsp.workspace.move({ workspace = \"$workspace\", monitor = \"$target\" })"
        fi
    done < <(hyprctl workspaces -j | jq -r '.[].id')
}

set_workspace_rules() {
    local target="$1"
    local first="$2"
    local last="$3"
    local workspace
    local is_default

    for ((workspace = first; workspace <= last; workspace++)); do
        is_default=false
        if ((workspace == 1)); then
            is_default=true
        fi

        hyprctl eval "hl.workspace_rule({ workspace = \"$workspace\", monitor = \"$target\", default = $is_default })"
    done
}

set_docked() {
    start_inhibit

    # Disable laptop display, all workspaces on external
    set_workspace_rules DP-1 1 10
    hyprctl eval 'hl.monitor({ output = "eDP-1", disabled = true })'

    move_existing_workspaces DP-1 1 10

    focus_monitor DP-1

    echo "docked" > "$STATE_FILE"
    notify-send -t 3000 "Dock Mode" "External monitor only (sleep inhibited)"
}

set_meeting() {
    start_inhibit

    # Enable laptop display below external
    # External at top (0,0), laptop below it
    hyprctl eval 'hl.monitor({ output = "DP-1", mode = "2560x1440@120", position = "0x0", scale = 1.07, disabled = false })'
    hyprctl eval 'hl.monitor({ output = "eDP-1", mode = "preferred", position = "0x1440", scale = 1.666667, disabled = false })'

    # Split workspaces: 1-5 external, 6-10 laptop
    set_workspace_rules DP-1 1 5
    set_workspace_rules eDP-1 6 10
    move_existing_workspaces DP-1 1 5
    move_existing_workspaces eDP-1 6 10

    focus_monitor DP-1

    echo "meeting" > "$STATE_FILE"
    notify-send -t 3000 "Meeting Mode" "Dual display — external primary (sleep inhibited)"
}

set_laptop() {
    stop_inhibit

    # Laptop display only, all workspaces on eDP-1
    hyprctl eval 'hl.monitor({ output = "eDP-1", mode = "preferred", position = "auto", scale = 1.666667, disabled = false })'

    set_workspace_rules eDP-1 1 10
    move_existing_workspaces eDP-1 1 10

    focus_monitor eDP-1

    echo "laptop" > "$STATE_FILE"
    notify-send -t 3000 "Laptop Mode" "Built-in display only"
}

# Auto-detect: check dock connection + lid state, pick the right mode
auto_detect() {
    if has_external; then
        if lid_closed; then
            set_docked
        else
            set_meeting
        fi
    else
        set_laptop
    fi
}

case "${1:-auto}" in
    docked)
        if has_external; then
            set_docked
        else
            set_laptop
        fi
        ;;
    meeting)
        if has_external; then
            set_meeting
        else
            set_laptop
        fi
        ;;
    laptop)
        set_laptop
        ;;
    toggle)
        if ! has_external; then
            set_laptop
        elif [[ "$(get_current_mode)" == "docked" ]]; then
            set_meeting
        else
            set_docked
        fi
        ;;
    auto)
        auto_detect
        ;;
    *)
        echo "Usage: $0 [docked|meeting|laptop|toggle|auto]"
        exit 1
        ;;
esac
