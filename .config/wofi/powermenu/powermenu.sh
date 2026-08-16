#!/bin/bash

chosen=$(printf '%s\n' Shutdown Reboot Lock Suspend Logout | wofi --dmenu --prompt 'Power Menu' --width 320 --height 300)

case "$chosen" in
    Shutdown) systemctl poweroff ;;
    Reboot) systemctl reboot ;;
    Lock) swaylock ;;
    Suspend) systemctl suspend ;;
    Logout) niri msg action quit ;;
esac
