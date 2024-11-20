#!/bin/bash

# Ensure the script stops on errors
set -e

# Install essential tools
echo "Installing necessary packages..."
sudo apt update
sudo apt install -y git curl tmux kitty

# Check if Starship is installed, if not install via curl
if ! command -v starship &> /dev/null; then
    echo "Starship not found, installing via curl..."
    curl -sS https://starship.rs/install.sh | sh
fi

# Clone Black Metal themes if not present
THEMES_DIR="$HOME/.config/kitty/themes"
BLACK_METAL_REPO="https://github.com/metalelf0/base16-black-metal-scheme.git"

mkdir -p "$THEMES_DIR"

if [ ! -d "$THEMES_DIR/base16-black-metal" ]; then
    echo "Cloning Black Metal theme repository..."
    git clone "$BLACK_METAL_REPO" "$THEMES_DIR/base16-black-metal"
fi

# Convert .yaml files to .conf files
echo "Converting .yaml theme files to .conf format..."
for file in "$THEMES_DIR/base16-black-metal"/*.yaml; do
    output_file="$THEMES_DIR/$(basename "${file%.yaml}.conf")"
    {
        echo "background #$(grep '^base00:' "$file" | awk '{print $2}')"
        echo "foreground #$(grep '^base05:' "$file" | awk '{print $2}')"
        echo "selection_background #$(grep '^base02:' "$file" | awk '{print $2}')"
        echo "selection_foreground #$(grep '^base05:' "$file" | awk '{print $2}')"
        echo "url_color #$(grep '^base08:' "$file" | awk '{print $2}')"
        for i in {00..15}; do
            echo "color${i} #$(grep "^base${i}:" "$file" | awk '{print $2}')"
        done
    } > "$output_file"
done

# Set up the Kitty configuration
KITTY_CONF="$HOME/.config/kitty/kitty.conf"
if ! grep -q "include ~/.config/kitty/colors/current-theme.conf" "$KITTY_CONF"; then
    echo "include ~/.config/kitty/colors/current-theme.conf" >> "$KITTY_CONF"
fi

# Create a symlink for the current theme
ln -sf "$THEMES_DIR/black-metal-venom.conf" "$HOME/.config/kitty/colors/current-theme.conf"

# Apply the theme
kitty @ set-colors --all "$HOME/.config/kitty/colors/current-theme.conf" || echo "Restart Kitty to apply the theme."

echo "Setup complete! Your terminal, tmux, and starship are configured."
