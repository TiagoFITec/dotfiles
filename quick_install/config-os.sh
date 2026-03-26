#!/bin/bash

# Ubuntu OS Configuration Script
# Created: May 11, 2025
# Author: Tiago

source "/home/tiago/.config/quick-install/print-with-color.sh"

configure_dark_theme() {
    # Check if GNOME is the current desktop environment
    if [[ "$XDG_CURRENT_DESKTOP" != *"GNOME"* ]]; then
        ERROR="Not running GNOME desktop environment. Skipping dark theme configuration."
        return 1  # Warning return code
    fi
    
    # Set GTK theme to dark mode
    gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark'
    gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
    
    # Set preference for dark mode in applications
    gsettings set org.gnome.desktop.interface prefer-dark-theme true
    
    return 0
}

disable_sleep_mode() {
    # Check if GNOME is the current desktop environment
    if [[ "$XDG_CURRENT_DESKTOP" != *"GNOME"* ]]; then
        ERROR="Not running GNOME desktop environment. Skipping sleep mode configuration."
        return 1  # Warning return code
    fi
    
    # Disable automatic screen dimming
    gsettings set org.gnome.settings-daemon.plugins.power idle-dim false
    
    # Disable automatic sleep when on AC power
    gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-type 'nothing'
    
    # Disable automatic sleep when on battery
    gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-battery-type 'nothing'
    
    # Disable screen blank timeout
    gsettings set org.gnome.desktop.session idle-delay 0
    
    printc "Desktop sleep mode has been disabled." $GREEN
    return 0
}

configure_os_settings() {
    # Main function to configure OS settings
    # This function is meant to be called directly from install.sh
    
    configure_dark_theme
    local DARK_THEME_RESULT=$?
    
    disable_sleep_mode
    local SLEEP_MODE_RESULT=$?
    
    # Add more OS configurations here
    
    # Return success if at least one configuration worked
    if [ $DARK_THEME_RESULT -eq 0 ] || [ $SLEEP_MODE_RESULT -eq 0 ]; then
        return 0
    else
        return 1  # Warning since some configurations might have failed
    fi
}