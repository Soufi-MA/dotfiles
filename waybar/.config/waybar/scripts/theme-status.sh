#!/bin/bash
current=$(gsettings get org.gnome.desktop.interface color-scheme)
if [[ $current == "'prefer-dark'" ]]; then
  echo '{"text": "🌙", "tooltip": "Dark Mode"}'
else
  echo '{"text": "☀️", "tooltip": "Light Mode"}'
fi
