#!/bin/bash

SELECTION="$(printf "󰌾 Lock\n󰤄 Suspend\n󰒲 Hibernate\n󰍃 Log out\n Reboot\n󰐥 Shutdown" | fuzzel --dmenu -a top-right -l 6 -w 18 -p "Select an option: ")"

confirm_action() {
  local action="$1"
  CONFIRMATION="$(printf "No\nYes" | fuzzel --dmenu -a top-right -l 2 -w 18 -p "$action?")"
  [[ "$CONFIRMATION" == *"Yes"* ]]
}

case $SELECTION in
*"󰌾 Lock"*)
  hyprlock
  ;;
*"󰤄 Suspend"*)
  systemctl suspend
  ;;
*"󰒲 Hibernate"*)
  if confirm_action "Hibernate"; then
    systemctl hibernate
  fi
  ;;
*"󰍃 Log out"*)
  if confirm_action "Log out"; then
    hyprctl dispatch exit
  fi
  ;;
*" Reboot"*)
  if confirm_action "Reboot"; then
    systemctl reboot
  fi
  ;;
  #    *" Reboot to UEFI"*)
  #        if confirm_action "Reboot to UEFI"; then
  #            systemctl reboot --firmware-setup
  #        fi;;
*"󰐥 Shutdown"*)
  if confirm_action "Shutdown"; then
    systemctl poweroff
  fi
  ;;
esac
