#!/usr/bin/env bash

prompt() {
  rofi -dmenu -i -p "$1" -theme-str '
    window { width: 380px; }
    listview { lines: 8; }
    * { font: "JetBrainsMono Nerd Font 11"; }' <<< "$2"
}

confirm() {
  choice="$(prompt "$1 — are you sure?" $'No\nYes')"
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

power_menu=$'󰜉  Reboot\n  Shutdown\n󰒲  Hibernate\n  Lock\n󰍃  Logout\n󰤄  Suspend\n󰜗  Hybrid Sleep\n'
choice="$(prompt "Power" "$power_menu")"

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
      lock_screen
      systemctl suspend
    fi
    ;;
  "󰒲  Hibernate")
    if confirm "Hibernate"; then
      lock_screen
      systemctl hibernate
    fi
    ;;
  "󰜗  Hybrid Sleep")
    if confirm "Hybrid Sleep"; then
      lock_screen
      systemctl hybrid-sleep
    fi
    ;;
  *)
    exit 0
    ;;
esac
