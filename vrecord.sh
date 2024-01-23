#!/bin/bash

# This is a (very) thin wrapper that does nothing else, but keeping open the
# shell after vrecord has exited (for whatever reason).
# This is handy to see possible errors/issues, even when being called from a
# Linux Desktop Launcher, for example.

./vrecord

read -p "Press ENTER key to continue."
clear
