#!/bin/bash

# Set scheduling priority of capture process high(er)

FFMPEG_BIN="ffmpeg-dl"
PRIO=99     # 1=lowest, 99=highest priority

echo "Updating scheduling priority for '$FFMPEG_BIN' to '$PRIO'"
PID=$(pgrep $FFMPEG_BIN)

if [ -z $PID ]; then
    echo "ERROR: process '$FFMPEG_BIN' not found. is it running?"
    ps aux | grep $FFMPEG_BIN
    exit 1
fi

read -p "Press any key to update process (pid=$PID)"

CMD="sudo chrt -f -p $PRIO $PID"
echo "$CMD"
eval "$CMD"

# Show Updated/current scheduling:
chrt -p $PID

read -p "Press any key to close."
clear
