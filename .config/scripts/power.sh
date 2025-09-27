#!/usr/bin/env bash

prompt() {
  rofi -dmenu -i -p "$1" -theme-str '
    window { width: 320px; }
    listview { lines: 7; }' <<< "$2"
}

confirm() {
  choice="$(prompt "$1 — are you sure?" $'Yes\nNo')"
  [[ "$choice" == "Yes" ]]
}

lock_screen() {
  if command -v hyprlock >/dev/null 2>&1; then
    hyprlock
  elif command -v swaylock >/dev/null 2>&1; then
    swaylock -f -c 000000
  else
    loginctl lock-session
  fi
}

power_menu=$'󰜉  Reboot\n󰤄  Suspend\n󰒲  Hibernate\n  Shutdown\n  Lock\n󰍃  Logout\n󰜗  Hybrid Sleep'
choice="$(prompt "" "$power_menu")"

case "$choice" in
  "󰜉  Reboot")
    if confirm "Reboot"; then
      systemctl reboot
    fi
    ;;

  "  Shutdown")
    if confirm "Shutdown"; then
      systemctl poweroff
    fi
    ;;
  "  Lock")
    lock_screen
    ;;
  "󰍃  Logout")
    if confirm "Logout"; then
      hyprctl dispatch exit 0
    fi
    ;;
  "󰤄  Suspend")
    if confirm "Suspend"; then
      systemctl suspend
    fi
    ;;
  "󰒲  Hibernate")
    if confirm "Hibernate"; then
      systemctl hibernate
    fi
    ;;
  "󰜗  Hybrid Sleep")
    if confirm "Hybrid Sleep"; then
      systemctl hybrid-sleep
    fi
    ;;
  *)
    exit 0
    ;;
esac
