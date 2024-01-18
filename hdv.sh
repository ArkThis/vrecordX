#!/bin/bash
# @description:
#   Small script to make HDV-capture more convenient.

# @history:
#   27.11.2014  peter_b     - Started.

# Programs used:
ZENITY="zenity"
DVCONT="dvcont"
DVGRAB="dvgrab"


if ! ARCHIVE_SIGNATURE=$($ZENITY --entry --text "Enter archive signature:" --title "HDV Ingest"); then
       exit;
fi
ARCHIVE_SIGNATURE=${ARCHIVE_SIGNATURE,,}                        # Force archive signature to lowercase

#CMD_HDV_MASK="$DVGRAB -f hdv --size 0 -showstatus %s - | ffplay -f mpegts -x 640 -y 360 -"
CMD_HDV_MASK="$DVGRAB -f hdv --size 0 -showstatus %s - | ffplay -f mpegts -x 1280 -y 720 -"

NAME="$1"
CMD=$(printf "$CMD_HDV_MASK" "$NAME")
$ZENITY --info --text="Capturing HDV with this command:\n $CMD" --width=500

eval "$CMD"

$DVCONT rewind


# TODO: Wait for rewind to finish, before ejecting (status = idle?)
STATUS=$($DVCONT status)
echo "$STATUS"
# dvcont eject

