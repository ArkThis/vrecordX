#!/bin/bash
# @author: Peter B. (pb at ArkThis dot com)
# @date: 2023-10-25
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

MYDIR=$(dirname "$0")
MPV="mpv"
TARGET_SCREEN="1"   # [0..n] Change this number to match your multi-screen setup.
SCREEN_LAYOUTS="$MYDIR/screenlayout"
VIDEO="$1"

if [ -e "$SCREEN_LAYOUTS" ]; then
    echo "Loading screen layout from '$SCREEN_LAYOUTS'..."
    source "$SCREEN_LAYOUTS"
    eval "$HDMI_RIGHT"
fi

CMD="$MPV \
    --screen=$TARGET_SCREEN \
    --fullscreen \
    --video-unscaled=yes \
    --video-aspect-override=no \
    $VIDEO"

echo "$CMD"
eval "$CMD"
