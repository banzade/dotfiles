#!/bin/bash

# Wofi Power Menu Script

# Define options
options="⏻ Shutdown\n⟲ Reboot\n🔒Lock\n⎌ Logout"

# Show menu and capture selection
chosen=$(echo -e "$options" | wofi --dmenu --prompt "Power Menu" --width 300 --height 250)

# Execute based on selection
case $chosen in
    "⏻ Shutdown")
        systemctl poweroff
        ;;
    "⟲ Reboot")
        systemctl reboot
        ;;
        "🔒 Lock")
        # Adjust this based on your lock screen (swaylock, gtklock, etc.)
        swaylock 
        ;;
        "⎌ Logout")
        # Adjust based on your window manager
        # For Sway:
        swaymsg exit
        # For Hyprland:
        # hyprctl dispatch exit
        ;;
esac
