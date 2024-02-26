#!/bin/bash

# This is a (very) thin wrapper that adds the following functionality:
#
#   1. keeping the shell open after vrecord has exited (for whatever reason).
#      This is handy to see possible errors/issues, even when being called from a
#      Linux Desktop Launcher, for example.
#
#   2. Ask for a recording IDENTIFIER (used as "Name of Recording" in vrecord).
#      If an IDENTIFIER is provided, vrecord will record directly - and *not* start the GUI.
#      If no IDENTIFIER is given (or "Cancel" button pressed), vrecord GUI is started as normally.
#      The IDENTIFIER is used as sub-foldername to the recording folder.
#
#   3. Adds simple support for providing a recording directory path on-the-fly,
#      overriding the value stored in vrecord's config_file.

DIR_RECORD="$1"
ZENITY="zenity"

# HINT: Closing this input window with "Cancel", or entering an empty value,
# enters the vrecord GUI normally.
IDENTIFIER=$($ZENITY --width=400 --entry --text "Enter recording identifier:" --title "vrecord 'Name of Recording'")
IDENTIFIER=${IDENTIFIER,,}                  # Force identifier to lowercase

./vrecord -d "$DIR_RECORD/$IDENTIFIER" $IDENTIFIER

# This keeps the terminal open, after vrecord has closed:
if [ "$2" != "direct" ]; then
    read -p "Press ENTER key to continue."
    clear
fi
