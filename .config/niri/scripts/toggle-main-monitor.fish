#!/usr/bin/env fish

function notify
    # Wrapper to send notifications
    notify-send "Monitor Toggle" "$argv"
end

# Get current_mode for DP-1
set current_mode (niri msg --json outputs | jq -r '.["DP-1"].current_mode')

switch "$current_mode"
    case "null"
        echo "Turning on DP-1 monitor..."
        niri msg output DP-1 on
        ddcutil --bus=6 setvcp 0x60 0x09
        xrandr --output DP-1 --primary
        sleep 3
        notify "DP-1 monitor enabled and set as primary"
    case '*'
        echo "Turning off DP-1 monitor..."
        niri msg output DP-1 off
        ddcutil --bus=6 setvcp 0x60 0x06
        sleep 3
        notify "DP-1 monitor disabled"
    case '*'
        echo "Unknown status: $current_mode"
        notify --urgency=critical "Error: Could not determine DP-1 monitor status"
        exit 1
end
