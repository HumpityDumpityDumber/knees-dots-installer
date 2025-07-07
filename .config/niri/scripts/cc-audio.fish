#!/usr/bin/env fish

set ELGATO_SOURCE "alsa_input.usb-Elgato_Elgato_HD60_X_A00XB422206D8Q-02.analog-stereo"

function notify
    notify-send "Elgato Audio" $argv
end

function loopback_loaded
    for line in (pactl list short modules)
        if string match -r "module-loopback.*$ELGATO_SOURCE" $line
            return 0
        end
    end
    return 1
end

if loopback_loaded
    echo "Loopback module for Elgato source already loaded. Exiting."
    notify "Loopback module already loaded, nothing to do."
    exit 0
end

echo "Loading loopback module for Elgato..."
pactl load-module module-loopback source="$ELGATO_SOURCE"

set source_id (pactl list sources short | awk -v src="$ELGATO_SOURCE" '$2 == src {print $1}')

if test -z "$source_id"
    echo "Elgato source not found."
    notify "Elgato source not found. Exiting."
    exit 1
end

pactl list source-outputs | awk -v srcid="$source_id" '
  /^Source Output #/ { so_id = substr($3, 2) }
  /Source:/ { if ($2 == srcid) print so_id }
' | while read source_output_id
    echo "Setting volume of source output #$source_output_id to 60%"
    pactl set-source-output-volume $source_output_id 60%
end

# Optional: Probe /dev/video0 briefly; adjust timeout and options as needed
timeout 1 ffplay -autoexit -f video4linux2 /dev/video0 >/dev/null 2>&1

notify "Loopback module loaded and volumes adjusted."
