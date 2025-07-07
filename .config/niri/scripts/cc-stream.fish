#!/usr/bin/env fish

# Check if video device exists
if not test -e /dev/video0
    echo "Error: /dev/video0 not found. Please check if your camera is connected."
    exit 1
end

# Check if ffplay is available
if not type -q ffplay
    echo "Error: ffplay not found. Please install ffmpeg."
    exit 1
end

# Start ffplay inside gamescope at 1080p in background and disown it
gamescope -W 1920 -H 1080 --fullscreen -- ffplay -f v4l2 -video_size 1920x1080 -framerate 60 /dev/video0
