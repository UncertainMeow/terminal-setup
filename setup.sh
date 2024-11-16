#!/bin/bash

echo "Starting setup..."

# Install essential packages
echo "Installing JetBrains Mono Nerd Font..."
mkdir -p ~/.local/share/fonts
cd ~/.local/share/fonts
curl -fLo "JetBrainsMono.zip" https://github.com/ryanoasis/nerd-fonts/releases/download/v2.3.3/JetBrainsMono.zip
unzip JetBrainsMono.zip -d ~/.local/share/fonts
fc-cache -fv
cd -

# Install Starship prompt
echo "Installing Starship..."
curl -sS https://starship.rs/install.sh | sh

# Copy configuration files
echo "Copying configuration files..."
cp .bashrc ~/
mkdir -p ~/.config/kitty
cp -r kitty-config/* ~/.config/kitty/
mkdir -p ~/.config
cp starship.toml ~/.config/

# Set up permissions
chmod +x ~/.bashrc
chmod +x ~/.config/kitty

# Reload .bashrc
echo "Reloading .bashrc..."
source ~/.bashrc

echo "Setup complete! Please restart your terminal for all changes to take effect."

