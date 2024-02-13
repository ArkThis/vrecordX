#!/bin/bash
# @author: Peter B. (pb at ArkThis dot com)
# @created: 2023-10-25
#
# @description:
# Plays a video on a specific graphics output port (eg HDMI or 2nd monitor, etc).
# Adds some arguments to avoid further interference with that video source, so
# it can be used as input for testing the accuracy and reliability of the
# capture side.
#
# Parameters:
# --screen=0                    Select output display
# --fullscreen                  Switch to fullscreen
# --video-unscaled=yes          Avoid any scaling
# --video-aspect-override=no    Show video with 1:1 pixels
#                               (=ignore aspect ratio tech-metadata)
# @requires:
# ./screenlayouts               This file contains xrandr configs for HDMI monitor presets.


VIDEO="$1"                      # Filename of the video to play back (as test-source).
MYDIR=$(dirname "$0")
SCREEN_LAYOUTS="$MYDIR/screenlayouts"

# Load monitor layout options:
if [ -e "$SCREEN_LAYOUTS" ]; then
    echo "Loading screen layout from '$SCREEN_LAYOUTS'..."
    source "$SCREEN_LAYOUTS"
fi

MPV="mpv"                       # MPV Media Player binary
TARGET_SCREEN="2"               # [0..n] Change this number to match your multi-screen setup: 1=left,2=right,...
LAYOUT="${HDMI_RIGHT_SD}"        # Display layout to load. Point this to your preferred config.


echo "Layout: '$LAYOUT': $HDMI_RIGHT_SD"
eval "$LAYOUT"

# Create command for calling the media player:
CMD="$MPV \
    --screen=$TARGET_SCREEN \
    --fullscreen \
    --video-unscaled=yes \
    --video-aspect-override=no \
    $VIDEO"


# ---------------------------

echo "$CMD"

echo ""
read -p "Press Enter to start test-signal playback..."
echo ""

eval "$CMD"
