#!/bin/bash

# Core Applications Installation Script
# Created: May 11, 2025
# Author: Tiago

source "/home/tiago/.config/quick-install/print-with-color.sh"

install_system_updates() {
    # Update package lists and upgrade system
    sudo apt-get update
    sudo apt-get upgrade -y
    
    return 0
}

install_dev_tools() {
    # Install development tools
    sudo apt-get install -y git 
    sudo apt-get install -y curl 
    sudo apt-get install -y wget 
    sudo apt-get install -y build-essential 
    
    return 0
}

install_utilities() {
    # Install utility applications
    sudo apt-get install -y btop
    sudo apt-get install -y neofetch
    
    return 0
}

install_fira_code_nerd_font() {
    # Install Fira Code Nerd Font
    printf "Installing Fira Code Nerd Font..." $BLUE
    
    # Create fonts directory if it doesn't exist
    mkdir -p ~/.local/share/fonts
    
    # Download and install Fira Code Nerd Font
    local FONT_DIR=~/.local/share/fonts/FiraCodeNerdFont
    mkdir -p "$FONT_DIR"
    
    # Check if curl is installed, if not install it
    if ! command -v curl &> /dev/null; then
        sudo apt-get install -y curl
    fi
    
    # Check if unzip is installed, if not install it
    if ! command -v unzip &> /dev/null; then
        sudo apt-get install -y unzip
    fi
    
    # Download the font
    local TEMP_ZIP=$(mktemp)
    curl -L -o "$TEMP_ZIP" "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/FiraCode.zip"
    
    # Extract the font to the font directory
    unzip -o "$TEMP_ZIP" -d "$FONT_DIR"
    rm "$TEMP_ZIP"
    
    # Update font cache
    if command -v fc-cache &> /dev/null; then
        fc-cache -f -v
    fi
    
    printf "Fira Code Nerd Font installed successfully" $GREEN
    return 0
}

install_kitty_terminal() {
    # Install Kitty terminal
    sudo apt-get install -y kitty
    
    # Create Kitty config directory if it doesn't exist
    mkdir -p ~/.config/kitty
    
    # Skip creating the config file since the user already has one
    
    # Install Fira Code Nerd Font for Kitty
    install_fira_code_nerd_font
    
    # Set Kitty as default terminal for the user
    if command -v gsettings &> /dev/null; then
        if gsettings get org.gnome.desktop.default-applications.terminal exec &> /dev/null; then
            gsettings set org.gnome.desktop.default-applications.terminal exec 'kitty'
        fi
    fi
    
    # Add kitty to .bashrc to set TERMINAL variable
    if ! grep -q "export TERMINAL=kitty" ~/.bashrc; then
        echo "# Set Kitty as default terminal" >> ~/.bashrc
        echo "export TERMINAL=kitty" >> ~/.bashrc
    fi
    
    # Create desktop entry if it doesn't exist
    if [ ! -f ~/.local/share/applications/kitty.desktop ] && [ -f /usr/share/applications/kitty.desktop ]; then
        mkdir -p ~/.local/share/applications
        cp /usr/share/applications/kitty.desktop ~/.local/share/applications/
        sed -i 's/^Terminal=.*/Terminal=false/' ~/.local/share/applications/kitty.desktop
    fi
    
    printf "Kitty terminal installed and configured as default" $GREEN
    return 0
}

setup_github_authentication() {
    # Setup GitHub authentication with SSH keys
    printf "Setting up GitHub SSH authentication..." $BLUE
    
    # Check if git is installed, if not install it
    if ! command -v git &> /dev/null; then
        sudo apt-get install -y git
    fi
    
    # Create SSH directory with proper permissions if it doesn't exist
    mkdir -p ~/.ssh
    chmod 700 ~/.ssh
    
    # Check if SSH key already exists
    if [ ! -f ~/.ssh/id_ed25519_github ]; then
        # Generate SSH key
        printf "Generating a new SSH key for GitHub..." $YELLOW
        ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519_github -C "github_$(whoami)@$(hostname)" -N ""
        
        # Add key to SSH agent
        eval "$(ssh-agent -s)"
        ssh-add ~/.ssh/id_ed25519_github
        
        # Add the SSH configuration if it doesn't exist
        if ! grep -q "Host github.com" ~/.ssh/config &> /dev/null; then
            cat >> ~/.ssh/config << EOF
# GitHub SSH configuration
Host github.com
    HostName github.com
    User git
    IdentityFile ~/.ssh/id_ed25519_github
    IdentitiesOnly yes
EOF
            chmod 600 ~/.ssh/config
        fi
        
        # Display the public key for the user to add to GitHub
        printf "Your SSH public key has been generated." $GREEN
        printf "Please add this key to your GitHub account:" $YELLOW
        cat ~/.ssh/id_ed25519_github.pub
        printf "To add this key to your GitHub account:" $BLUE
        printf "1. Log in to GitHub" $BLUE
        printf "2. Go to Settings > SSH and GPG keys > New SSH key" $BLUE
        printf "3. Paste the above key and save" $BLUE
        printf "\nAfter adding the key to GitHub, you can clone repositories using SSH URLs:" $BLUE
        printf "git clone git@github.com:username/repository.git" $GREEN
    else
        printf "GitHub SSH key already exists at ~/.ssh/id_ed25519_github" $GREEN
        printf "If you're having issues with GitHub authentication, please check your SSH key is added to your GitHub account." $BLUE
    fi
    
    # Configure Git with default settings if not already set
    if [ -z "$(git config --global user.name)" ]; then
        # Use a default name to avoid interactive prompts
        git_name="Tiago Marques"
        printf "Setting default Git user.name to: $git_name" $YELLOW
        git config --global user.name "$git_name"
    fi
    
    if [ -z "$(git config --global user.email)" ]; then
        # Use a default email to avoid interactive prompts
        git_email="tiagomarques@fitec.org.br"
        printf "Setting default Git user.email to: $git_email" $YELLOW
        git config --global user.email "$git_email"
    fi
    
    # Set credential cache to avoid typing password repeatedly
    git config --global credential.helper cache
    
    printf "GitHub SSH authentication has been configured successfully" $GREEN
    return 0
}

install_golang() {
    # Install Go programming language
    printf "Setting up Go programming language..." $BLUE
    
    # Check if go is already installed
    if command -v go &> /dev/null; then
        GO_VERSION=$(go version | awk '{print $3}' | sed 's/go//')
        printf "Go is already installed (version $GO_VERSION)" $GREEN
        return 0
    fi
    
    printf "Installing Go programming language..." $YELLOW
    
    # Latest stable version (as of script creation)
    GO_VERSION="1.24.2"
    GO_ARCH="amd64"  # For 64-bit systems
    
    # Create temporary directory for download
    local TEMP_DIR=$(mktemp -d)
    
    # Download Go binary
    local GO_TARBALL="go${GO_VERSION}.linux-${GO_ARCH}.tar.gz"
    printf "Downloading Go $GO_VERSION..." $BLUE
    wget -q -O "$TEMP_DIR/$GO_TARBALL" "https://golang.org/dl/$GO_TARBALL"
    
    # Install Go
    printf "Installing Go to /usr/local..." $BLUE
    sudo rm -rf /usr/local/go
    sudo tar -C /usr/local -xzf "$TEMP_DIR/$GO_TARBALL"
    
    # Clean up
    rm -rf "$TEMP_DIR"
    
    # Set up environment if not already configured
    if ! grep -q "GOPATH" ~/.bashrc; then
        printf "Setting up Go environment variables..." $BLUE
        cat >> ~/.bashrc << EOF

# Go environment variables
export GOPATH=\$HOME/go
export PATH=\$PATH:/usr/local/go/bin:\$GOPATH/bin
EOF
    fi
    
    # Create Go workspace directory
    mkdir -p ~/go/{bin,pkg,src}
    
    # Verify installation
    if [ -x /usr/local/go/bin/go ]; then
        printf "Go $GO_VERSION has been successfully installed" $GREEN
        printf "Please restart your terminal or run 'source ~/.bashrc' to use Go" $YELLOW
    else
        printf "Go installation failed" $RED
        return 1
    fi
    
    return 0
}

install_desktop_apps() {
    # Install desktop applications like Steam, OpenRGB, VLC, and LibreOffice
    printf "Installing desktop applications..." $BLUE
    
    # Install Steam
    printf "Installing Steam..." $YELLOW
    sudo snap install steam
    sudo dpkg --add-architecture i386
    sudo apt update
    sudo apt install -y libnvidia-gl-570:i386
    
    # Install VLC
    printf "Installing VLC media player..." $YELLOW
    sudo apt-get install -y vlc
    
    # Install LibreOffice
    printf "Installing LibreOffice suite..." $YELLOW
    sudo apt-get install -y libreoffice
    
    printf "Desktop applications installed successfully" $GREEN
    return 0
}

install_core_apps() {
    # Main function to install core applications
    # This function is meant to be called directly from install.sh
    
    # Check if user has sudo privileges
    if [[ $EUID -ne 0 ]] && ! sudo -v &> /dev/null; then
        ERROR="This operation requires sudo privileges."
        return 2  # Error return code
    fi
    
    install_system_updates
    local UPDATES_RESULT=$?
    
    install_dev_tools
    local DEV_TOOLS_RESULT=$?
    
    install_utilities
    local UTILITIES_RESULT=$?
    
    install_kitty_terminal
    local KITTY_RESULT=$?
    
    setup_github_authentication
    local GITHUB_AUTH_RESULT=$?
    
    install_golang
    local GOLANG_RESULT=$?
    
    install_desktop_apps
    local DESKTOP_APPS_RESULT=$?
    
    # Return error if any installation failed
    if [[ $UPDATES_RESULT -eq 0 && $DEV_TOOLS_RESULT -eq 0 && $UTILITIES_RESULT -eq 0 && $KITTY_RESULT -eq 0 && $GITHUB_AUTH_RESULT -eq 0 && $GOLANG_RESULT -eq 0 && $DESKTOP_APPS_RESULT -eq 0 ]]; then
        return 0
    else
        ERROR="Some packages failed to install."
        return 1  # Warning return code
    fi
}