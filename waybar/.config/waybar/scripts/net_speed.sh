#!/bin/bash
interval=2
snore() {
    local IFS
    [[ -n "${_snore_fd:-}" ]] || exec {_snore_fd}<> <(:)
    read -t "$1" -u $_snore_fd || :
}
human_readable() {
  echo "$1" | awk '{
    units["0"]="B"; units["1"]="K"; units["2"]="M"; units["3"]="G"; units["4"]="T"; units["5"]="P";
    n = $1;
    i = 0;
    while (n > 1023 && i < 5) {
      n = n / 1024;
      i += 1;
    }
    printf "%.1f%s", n, units[i]
  }'
}
get_traffic() {
  awk -v iface="$1" "/^ *$1:/ {print $2, $10}" /proc/net/dev
}
while :; do
  line=$(nmcli -t -f DEVICE,TYPE,STATE device status | grep ':connected$')
  if [ -z "$line" ]; then
    printf '{"text": ""}\n'
    snore $interval
    continue
  fi
  iface=$(echo "$line" | cut -d: -f1)
  type=$(echo "$line" | cut -d: -f2)
  tooltip="$iface"
  if [ "$type" = "wifi" ]; then
    essid=$(nmcli -t -f ACTIVE,SSID con show | awk -F: '$1=="yes" {print $2}')
    signal=$(nmcli device wifi list ifname "$iface" --rescan no | grep '^*' | tr -s ' ' | awk '{print $6 "%"}')
    tooltip="$tooltip\n$essid ($signal)"
  fi
  tooltip="$tooltip\n"
  read rx_prev tx_prev < <(get_traffic "$iface")
  snore $interval
  read rx_curr tx_curr < <(get_traffic "$iface")
  rx=$(( (rx_curr - rx_prev) / interval ))
  tx=$(( (tx_curr - tx_prev) / interval ))
  rx_hr=$(human_readable $rx)
  tx_hr=$(human_readable $tx)
  text="↓$rx_hr ↑$tx_hr"
  tooltip="$tooltip↓$rx_hr/s ↑$tx_hr/s"
  printf '{"text": "%s", "tooltip": "%s" }\n' "$text" "$tooltip"
done
