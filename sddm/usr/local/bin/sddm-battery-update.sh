#!/usr/bin/env bash
BAT=$(ls /sys/class/power_supply/BAT* 2>/dev/null | head -n1)
if [ -n "$BAT" ]; then
    capacity=$(cat "$BAT/capacity" 2>/dev/null || echo 100)
    status=$(cat "$BAT/status" 2>/dev/null || echo "Unknown")
    echo "$capacity" > /tmp/sddm-battery.txt
    echo "$status" >> /tmp/sddm-battery.txt
else
    echo "100" > /tmp/sddm-battery.txt
    echo "Unknown" >> /tmp/sddm-battery.txt
fi
chmod 644 /tmp/sddm-battery.txt