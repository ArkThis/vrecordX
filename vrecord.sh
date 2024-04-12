#!/bin/bash

# This is a (very) thin wrapper that adds the following functionality:
#
#   1. keeping the shell open after vrecord has exited (for whatever reason).
#      This is handy to see possible errors/issues, even when being called from a
#      Linux Desktop Launcher, for example.
#      This is OPTIONAL, and can be enabled by using the '-w' (wait) parameter.
#
#   2. Ask for a recording IDENTIFIER (used as "Name of Recording" in vrecord).
#      If an IDENTIFIER is provided, vrecord will record directly - and *not* start the GUI.
#      If no IDENTIFIER is given (or "Cancel" button pressed), vrecord GUI is started as normally.
#      The IDENTIFIER is used as sub-foldername to the recording folder.

ZENITY="zenity"
VRECORD="./vrecord"

# HINT: Closing this input window with "Cancel", or entering an empty value,
# enters the vrecord GUI normally.
IDENTIFIER=$($ZENITY --width=400 --entry --text "Enter recording identifier:" --title "vrecord 'Name of Recording'")
IDENTIFIER=${IDENTIFIER,,}                  # Force identifier to lowercase

ARGS="$@"
CMD="$VRECORD $ARGS $IDENTIFIER"
echo "Calling: $CMD"
eval "$CMD" 

# This keeps the terminal open, after vrecord has closed:
if [ "$WAIT" == "wait" ]; then
    read -p "Press ENTER key to continue."
    clear
fi
