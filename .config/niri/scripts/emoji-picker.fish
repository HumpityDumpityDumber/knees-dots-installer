#!/usr/bin/env fish

set emoji (rofi -show emoji | head -n 1)
wtype "$emoji"
xdotool type --delay 0 "$emoji"
