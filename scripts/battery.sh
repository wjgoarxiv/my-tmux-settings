#!/bin/bash
# battery.sh — macOS battery widget for tmux status bar

percent=$(pmset -g batt 2>/dev/null | grep -oE '[0-9]+%' | head -1 | tr -d '%')
charging=$(pmset -g batt 2>/dev/null | grep -q 'AC Power' && echo true || echo false)

if [ -z "$percent" ]; then
  printf "N/A"
  exit 0
fi

if [ "$charging" = "true" ]; then
  icon="󰂅"
elif [ "$percent" -ge 90 ]; then
  icon="󰁹"
elif [ "$percent" -ge 70 ]; then
  icon="󰁻"
elif [ "$percent" -ge 50 ]; then
  icon="󰁼"
elif [ "$percent" -ge 30 ]; then
  icon="󰁽"
elif [ "$percent" -ge 15 ]; then
  icon="󰁾"
else
  icon="󰁺"
fi

printf "%s %s%%" "$icon" "$percent"
