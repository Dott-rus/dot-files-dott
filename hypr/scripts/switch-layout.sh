#!/usr/bin/env bash
set -euo pipefail

cmd="${1:-next}"

# Newer Hyprland supports DEVICE = all/current. Try the clean path first.
if hyprctl switchxkblayout all "$cmd" >/dev/null 2>&1; then
  exit 0
fi

# Fallback for older/quirky setups: enumerate keyboards.
if command -v jq >/dev/null 2>&1; then
  hyprctl devices -j \
    | jq -r '.keyboards[].name' \
    | while IFS= read -r keyboard; do
        [ -n "$keyboard" ] && hyprctl switchxkblayout "$keyboard" "$cmd" >/dev/null || true
      done
  active="$(hyprctl devices -j | jq -r '.keyboards[] | select(.main == true) | .active_keymap' | head -n1)"
  [ -n "$active" ] && hyprctl notify -1 1200 0 "layout: $active" >/dev/null 2>&1 || true
else
  hyprctl notify -1 2500 0 "jq missing: can't enumerate keyboards" >/dev/null 2>&1 || true
fi
