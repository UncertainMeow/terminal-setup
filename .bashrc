# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]; then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
if [ -d ~/.bashrc.d ]; then
    for rc in ~/.bashrc.d/*; do
        if [ -f "$rc" ]; then
            . "$rc"
        fi
    done
fi
unset rc

# -----------------------------------
# ADD NEW CONFIGURATIONS BELOW
# -----------------------------------

# Enable color support for ls and add useful aliases
alias ls='eza --icons'
alias ll='eza -lh --icons --grid --group-directories-first'
alias la='eza -lah --icons --grid --group-directories-first'
alias cat='bat'  # Use 'bat' for syntax highlighting in place of 'cat'

# Add color to grep outputs
alias grep='grep --color=auto'

# Navigation shortcuts
alias ..='cd ..'
alias ...='cd ../..'

# Custom aliases for convenience



# Git aliases for convenience
alias gst='git status'
alias gco='git checkout'
alias gp='git push'
alias gl='git log --oneline --graph'

# Function to switch Kitty themes using numbered input
kitty_switch() {
    local theme_dir="$HOME/.config/kitty/themes"
    mkdir -p "$theme_dir"

    # Include all .conf files from subdirectories
    local themes=($(find "$theme_dir" -type f -name "*.conf" | xargs -n 1 basename | sed 's/.conf//'))

    echo "Available themes:"
    for i in "${!themes[@]}"; do
        echo "$((i + 1)). ${themes[$i]}"
    done

    read -p "Enter the number of the theme to apply: " theme_number

    if [[ "$theme_number" -gt 0 && "$theme_number" -le "${#themes[@]}" ]]; then
        local selected_theme="${themes[$((theme_number - 1))]}"
        ln -sf "$(find "$theme_dir" -type f -name "$selected_theme.conf")" "$HOME/.config/kitty/colors/current-theme.conf"
        kitty @ set-colors --all "$HOME/.config/kitty/colors/current-theme.conf" 2>/dev/null || echo "Restart Kitty to apply the new theme."
        echo "Switched to theme: $selected_theme"
    else
        echo "Invalid selection. Please choose a valid number."
    fi
}


alias kitty-switch=kitty_switch

# Starship prompt setup
eval "$(starship init bash)"

# Enable true color support
export COLORTERM=truecolor

# Fancy `man` page colors
man() {
  LESS_TERMCAP_mb=$'\e[1;31m' \
  LESS_TERMCAP_md=$'\e[1;31m' \
  LESS_TERMCAP_me=$'\e[0m' \
  LESS_TERMCAP_se=$'\e[0m' \
  LESS_TERMCAP_so=$'\e[1;44;33m' \
  LESS_TERMCAP_ue=$'\e[0m' \
  LESS_TERMCAP_us=$'\e[1;32m' \
  command man "$@"
}

# Dynamic terminal title
PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD}\007"'

# Auto-reload bashrc alias
alias reload="source ~/.bashrc && echo 'Bash configuration reloaded!'"

# Run fastfetch on terminal startup (optional)
if command -v fastfetch &> /dev/null; then
    fastfetch
fi

# Include any personal bash configurations if present
if [ -f $HOME/.bashrc-personal ]; then
  source $HOME/.bashrc-personal
fi
