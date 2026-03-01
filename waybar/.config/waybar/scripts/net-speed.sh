#!/bin/bash
# ~/.config/waybar/scripts/net-speed.sh  ←  EXACT 5-CHAR EVERYWHERE + "0.00K" placeholder

interface="${1:-$(ip route show default | awk '/default/ {for(i=1;i<=NF;i++) if ($i=="dev") print $(i+1); exit}')}"

if [ -z "$interface" ] || [ ! -d "/sys/class/net/$interface" ]; then
  printf '{"text": "󰇚 0.00K 󰕒 0.00K", "tooltip": "No network interface detected"}\n'
  exit 0
fi

rx_prev=$(cat /sys/class/net/"$interface"/statistics/rx_bytes)
tx_prev=$(cat /sys/class/net/"$interface"/statistics/tx_bytes)

format_speed() {
  local speed=$1
  if (( speed < 1024 )); then
    printf "0.00K"
  elif (( speed < 1048576 )); then
    local val=$(bc <<< "scale=2; $speed / 1024")
    if (( $(bc <<< "$val < 10") )); then
      printf "%.2fK" "$val"
    elif (( $(bc <<< "$val < 100") )); then
      printf "%.1fK" "$val"
    else
      printf "%.0fK " "$val"
    fi
  elif (( speed < 1073741824 )); then
    local val=$(bc <<< "scale=2; $speed / 1048576")
    if (( $(bc <<< "$val < 10") )); then
      printf "%.2fM" "$val"
    elif (( $(bc <<< "$val < 100") )); then
      printf "%.1fM" "$val"
    else
      printf "%.0fM " "$val"
    fi
  else
    local val=$(bc <<< "scale=2; $speed / 1073741824")
    if (( $(bc <<< "$val < 10") )); then
      printf "%.2fG" "$val"
    elif (( $(bc <<< "$val < 100") )); then
      printf "%.1fG" "$val"
    else
      printf "%.0fG " "$val"
    fi
  fi
}

while true; do
  rx_curr=$(cat /sys/class/net/"$interface"/statistics/rx_bytes)
  tx_curr=$(cat /sys/class/net/"$interface"/statistics/tx_bytes)

  down=$((rx_curr - rx_prev))
  up=$((tx_curr - tx_prev))

  down_fmt=$(format_speed $down)
  up_fmt=$(format_speed $up)

  text="󰇚 ${down_fmt} 󰕒 ${up_fmt}"
  tooltip="Interface: $interface\nDownload: $down bytes/s\nUpload: $up bytes/s"
  printf '{"text": "%s", "tooltip": "%s"}\n' "$text" "$tooltip"

  rx_prev=$rx_curr
  tx_prev=$tx_curr
  sleep 1
done