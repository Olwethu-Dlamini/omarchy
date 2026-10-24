#!/bin/sh
# usage: toggle.sh <app_id> <command...>  — closes the window if open, else launches it
id=$1; shift
if swaymsg -t get_tree | grep -q "\"app_id\": \"[^\"]*$id\""; then
    swaymsg "[app_id=\"$id\"] kill" >/dev/null
else
    setsid "$@" >/dev/null 2>&1 &
fi
