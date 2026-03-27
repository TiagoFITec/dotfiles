#!/bin/bash

source "/home/tiago/.dotfiles/quick_install/step.sh"
source "/home/tiago/.dotfiles/quick_install/header.sh"
source "/home/tiago/.dotfiles/quick_install/config-log.sh"
source "/home/tiago/.dotfiles/quick_install/keybindings.sh"
source "/home/tiago/.dotfiles/quick_install/config-os.sh"
# source "/home/tiago/.dotfiles/quick_install/core-apps.sh"

# Main installation script

sudo clear
show_header
config_log "installation.log"

step configure_os_settings "Configuring OS settings"
step configure_keybindings "Setting up keyboard shortcuts"
# step install_core_apps "Installing core applications"
echo ""
