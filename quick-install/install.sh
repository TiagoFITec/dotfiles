#!/bin/bash

source "/home/tiago/.config/quick-install/step.sh"
source "/home/tiago/.config/quick-install/header.sh"
source "/home/tiago/.config/quick-install/config-log.sh"
source "/home/tiago/.config/quick-install/keybindings.sh"
source "/home/tiago/.config/quick-install/config-os.sh"
source "/home/tiago/.config/quick-install/core-apps.sh"

# Main installation script

sudo clear
show_header
config_log "installation.log"

step configure_os_settings "Configuring OS settings"
step configure_keybindings "Setting up keyboard shortcuts"
step install_core_apps "Installing core applications"
echo ""
neofetch