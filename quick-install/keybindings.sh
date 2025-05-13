#!/bin/bash

source "/home/tiago/.config/quick-install/print-with-color.sh"

# Functions for workspace keybinding configuration
set_workspace_count() {
    # Ensure the workspace mode is set to Fixed Number of Workspaces
    gsettings set org.gnome.mutter dynamic-workspaces false
    
    # Ensure GNOME Shell is being used
    if [[ $(gsettings get org.gnome.desktop.wm.preferences num-workspaces) -lt 8 ]]; then
        gsettings set org.gnome.desktop.wm.preferences num-workspaces 8
    fi
    
    return 0
}

configure_switch_keybindings() {
    # Define workspaces and keybindings
    declare -A SWITCH_KEYS=(
        [q]=1 [w]=2 [e]=3 [r]=4
        [a]=5 [s]=6 [d]=7 [f]=8
    )
    
    # Set keybindings for switching workspaces
    for key in "${!SWITCH_KEYS[@]}"; do
        gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-${SWITCH_KEYS[$key]} "['<Super>${key}']"
    done
    
    return 0
}

disable_conflicting_shortcuts() {
    # Disable conflicting shortcuts
    gsettings set org.gnome.shell.extensions.dash-to-dock shortcut "[]" 2>/dev/null || true
    gsettings set org.gnome.shell.extensions.dash-to-dock shortcut-text "" 2>/dev/null || true
    gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-7 "['<Super>d']"
    gsettings set org.gnome.shell.keybindings toggle-quick-settings "[]"
    gsettings set org.gnome.shell.keybindings toggle-application-view "[]"
    gsettings set org.gnome.desktop.wm.keybindings show-desktop "[]"
    gsettings set org.gnome.desktop.wm.keybindings close "['<Super>Delete']"
    
    return 0
}

configure_move_keybindings() {
    # Define workspaces and keybindings for moving windows
    declare -A MOVE_KEYS=(
        [q]=1 [w]=2 [e]=3 [r]=4
        [a]=5 [s]=6 [d]=7 [f]=8
    )
    
    # Set keybindings for moving windows to workspaces
    for key in "${!MOVE_KEYS[@]}"; do
        gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-${MOVE_KEYS[$key]} "['<Super><Shift>${key}']"
    done
    
    return 0
}

configure_keybindings() {
    # Main function to configure all keybindings
    # This function is meant to be called directly from install.sh
    
    # Check if we're running GNOME
    if [[ "$XDG_CURRENT_DESKTOP" != *"GNOME"* ]]; then
        ERROR="Not running GNOME desktop environment. Skipping keybindings."
        return 1  # Warning return code
    fi
    
    set_workspace_count
    configure_switch_keybindings
    disable_conflicting_shortcuts
    configure_move_keybindings
    
    return 0
}
