#!/usr/bin/env bash
set -euo pipefail

mode="${1:-area}"
dir="${XDG_PICTURES_DIR:-$HOME/Pictures}/Screenshots"
mkdir -p "$dir"
file="$dir/Screenshot from $(date '+%Y-%m-%d %H-%M-%S').png"

notify_ok() {
  command -v notify-send >/dev/null 2>&1 && notify-send "Screenshot" "$1" || true
}

copy_file() {
  command -v wl-copy >/dev/null 2>&1 && wl-copy < "$file" || true
}

if command -v grimblast >/dev/null 2>&1; then
  case "$mode" in
    area)   grimblast --notify copysave area "$file" ;;
    screen) grimblast --notify copysave output "$file" ;;
    window) grimblast --notify copysave active "$file" ;;
    *) echo "usage: $0 [area|screen|window]" >&2; exit 2 ;;
  esac
  exit 0
fi

case "$mode" in
  area)
    command -v grim >/dev/null 2>&1 || { echo "grim missing" >&2; exit 1; }
    command -v slurp >/dev/null 2>&1 || { echo "slurp missing" >&2; exit 1; }
    grim -g "$(slurp)" "$file"
    ;;
  screen)
    command -v grim >/dev/null 2>&1 || { echo "grim missing" >&2; exit 1; }
    grim "$file"
    ;;
  window)
    if command -v hyprshot >/dev/null 2>&1; then
      hyprshot -m window -o "$dir" -f "$(basename "$file")"
    else
      command -v grim >/dev/null 2>&1 || { echo "grim missing" >&2; exit 1; }
      command -v slurp >/dev/null 2>&1 || { echo "slurp missing" >&2; exit 1; }
      hyprctl clients -j >/dev/null 2>&1 || true
      grim -g "$(slurp)" "$file"
    fi
    ;;
  *)
    echo "usage: $0 [area|screen|window]" >&2
    exit 2
    ;;
esac

copy_file
notify_ok "$file"
