#!/usr/bin/env bash

set -euo pipefail

MODE="${1:-}"

MAX_ITEMS="${MAX_ITEMS:-0}"

list_items() {
  if (( MAX_ITEMS > 0 )); then
    cliphist list | head -n "$MAX_ITEMS"
  else
    cliphist list
  fi
}

sync_both_selections() {
  local types; types="$(wl-paste --list-types || true)"
  if echo "$types" | grep -q '^image/'; then
    local itype; itype="$(printf "%s\n" "$types" | awk '/^image\//{print; exit}')"
    wl-paste --no-newline -t "$itype" | wl-copy -t "$itype"
    wl-paste --no-newline -t "$itype" | wl-copy --primary -t "$itype"
  else
    wl-paste --no-newline | wl-copy
    wl-paste --no-newline | wl-copy --primary
  fi
}

copy_id() {
  local id="$1"
  cliphist decode "$id" | wl-copy
  sync_both_selections
}

pick_entry() {
  declare -A map
  local menu=""
  while IFS= read -r line; do
    id="${line%%$'\t'*}"
    text="${line#*$'\t'}"
    menu+="$text"$'\n'
    map["$text"]="$id"
  done < <(list_items)

  choice="$(printf "%s" "$menu" | rofi -dmenu -i -p "" -theme-str ' listview { lines: 8; } window { width: 800px; } ' || true)"
  if [[ -z "$choice" ]]; then
    first_id="$(cliphist list | awk 'NR==1{print $1}')"
    [[ -n "$first_id" ]] && copy_id "$first_id"
  else
    copy_id "${map[$choice]}"
  fi
}

main() {
  case "$MODE" in
    --menu)
      pick_entry
      ;;
    *)
      if cliphist pick -t rofi; then
        sync_both_selections
        exit 0
      fi
      pick_entry
      ;;
  esac
}

main "$@"
