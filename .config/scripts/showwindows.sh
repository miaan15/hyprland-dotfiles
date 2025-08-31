#!/usr/bin/env bash

set -euo pipefail

active_addr="$(hyprctl activewindow -j | jq -r '.address // empty')"

json="$(hyprctl -j clients | jq -c --arg act "$active_addr" '
  [ .[]
    | select(.mapped == true and .hidden == false)
    | select(.workspace.id >= 0)
    | select(.address != $act)
  ]
  | sort_by(.focusHistoryID)
')"

[[ "$(jq 'length' <<<"$json")" -eq 0 ]] && exit 0

menu="$(jq -r '
  to_entries[]
  | "[\(.value.class)] \(.value.title)"
' <<<"$json")"

idx="$(printf '%s\n' "$menu" | rofi -dmenu -i -p " Window" -format i || true)"
[[ -z "${idx:-}" || "$idx" = "-1" ]] && exit 0

addr="$(jq -r --argjson i "$idx" '.[$i].address' <<<"$json")"
pid="$(jq -r  --argjson i "$idx" '.[$i].pid'     <<<"$json")"
title="$(jq -r --argjson i "$idx" '.[$i].title'   <<<"$json")"

if ! hyprctl dispatch focuswindow "address:$addr" >/dev/null 2>&1; then
  if ! hyprctl dispatch focuswindow "pid:$pid" >/dev/null 2>&1; then
    hyprctl dispatch focuswindow "$title" >/dev/null 2>&1 || true
  fi
fi
