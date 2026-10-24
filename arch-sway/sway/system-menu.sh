#!/bin/sh
choice=$(printf 'Lock\nSuspend\nRelaunch bar\nReload sway\nLog out\nReboot\nPower off' | wofi --dmenu -p System)
case "$choice" in
    Lock) swaylock -f ;;
    Suspend) systemctl suspend ;;
    "Relaunch bar") pkill -x waybar; setsid waybar >/dev/null 2>&1 & ;;
    "Reload sway") swaymsg reload ;;
    "Log out") swaymsg exit ;;
    Reboot) systemctl reboot ;;
    "Power off") systemctl poweroff ;;
esac
