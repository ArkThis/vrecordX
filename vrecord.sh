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
#
#   3. Adds simple support for providing a recording directory path on-the-fly,
#      overriding the value stored in vrecord's config_file.

ZENITY="zenity"

# Ask user for IDENTIFIER string.
# HINT: Closing this input window with "Cancel", or entering an empty value,
# enters the vrecord GUI normally.
IDENTIFIER=$($ZENITY --width=400 --entry --text "Enter recording identifier:" --title "vrecord 'Name of Recording'")
IDENTIFIER=${IDENTIFIER,,}                  # Force identifier to lowercase

ARGS=""

# Check commandline parameters:
while getopts "d:w" opt; do
    case $opt in
        d)
            DIR_RECORD="${OPTARG}"
            echo "Recording base: '$DIR_RECORD'"
            ARGS="-d \"$DIR_RECORD/$IDENTIFIER\""
            ;;
        w)
            WAIT="wait"
            echo "Enabling wait."
            ;;
        ?)
            echo "Invalid option: -${OPTARG}."
            exit 1
            ;;
    esac
done


./vrecord $ARGS $IDENTIFIER

# This keeps the terminal open, after vrecord has closed:
if [ "$WAIT" == "wait" ]; then
    read -p "Press ENTER key to continue."
    clear
fi
