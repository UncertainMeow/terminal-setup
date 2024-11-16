# Create the 'colors' directory if it doesn't already exist
mkdir -p ~/.config/kitty/colors

# Convert all .yaml files to .conf files in the base16-black-metal-scheme directory
for file in ~/.config/kitty/base16-black-metal-scheme/*.yaml; do
  cp "$file" "${file%.yaml}.conf"
done

# Create a symbolic link to a chosen theme (change the theme name as desired)
ln -sf ~/.config/kitty/base16-black-metal-scheme/black-metal-immortal.conf ~/.config/kitty/colors/current-theme.conf

# Apply the color scheme
kitty @ set-colors --all ~/.config/kitty/colors/current-theme.conf
