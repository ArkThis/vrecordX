#!/bin/bash
# @description:
#   Small script to make DV-capture more convenient.

# @history:
#   2024-01-25  peter_b     - Started.

# Programs used:
ZENITY="zenity"
DVCONT="dvcont"
DVGRAB="dvgrab"
FFMPEG="ffmpeg"

DV_OUTPUT_FORMAT="raw"


if ! ARCHIVE_SIGNATURE=$($ZENITY --entry --text "Enter archive signature:" --title "HDV Ingest"); then
    exit;
fi
ARCHIVE_SIGNATURE=${ARCHIVE_SIGNATURE,,}                        # Force archive signature to lowercase

CMD_DV_MASK="$DVGRAB -f $DV_OUTPUT_FORMAT -size 0 -showstatus %s/%s-.dv - | ffplay -f dv -"

PWD=$(pwd)
CMD=$(printf "$CMD_DV_MASK" "$PWD" "$ARCHIVE_SIGNATURE")
$ZENITY --info --text="Capturing DV with this command:\n $CMD" --width=500

eval "$CMD"

# Rewind tape after capture:
# $DVCONT rewind


# TODO: Wait for rewind to finish, before ejecting (status = idle?)
STATUS=$($DVCONT status)
echo "$STATUS"
# $DVCONT eject

