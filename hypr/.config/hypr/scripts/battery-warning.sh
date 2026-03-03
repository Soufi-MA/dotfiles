#!/usr/bin/env bash
# Battery warning script for dunst (Hyprland)
# Handles BAT0 or BAT1 automatically

LAST_WARN=0
LAST_CRIT=0

while true; do
  for bat in /sys/class/power_supply/BAT*; do
    if [ -d "$bat" ]; then
      capacity=$(cat "$bat/capacity" 2>/dev/null || echo 100)
      status=$(cat "$bat/status" 2>/dev/null || echo "Unknown")

      if [ "$status" = "Discharging" ]; then
        if [ "$capacity" -le 10 ] && [ $(( $(date +%s) - LAST_CRIT )) -gt 180 ]; then
          dunstify -u critical -r 991 "🔴 Critical Battery" "Battery at ${capacity}% — plug in NOW!"
          LAST_CRIT=$(date +%s)
        elif [ "$capacity" -le 20 ] && [ $(( $(date +%s) - LAST_WARN )) -gt 300 ]; then
          dunstify -u normal -r 992 "🟠 Low Battery" "Battery at ${capacity}% — time to plug in"
          LAST_WARN=$(date +%s)
        fi
      fi
    fi
  done
  sleep 60
done