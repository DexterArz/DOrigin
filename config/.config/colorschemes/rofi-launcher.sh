#!/bin/bash

THEME_DIR="$HOME/.config/colorschemes"
APPLY_SCRIPT="$THEME_DIR/apply-theme.sh"
CURRENT_THEME_FILE="$THEME_DIR/.current-theme"

# Get current theme
CURRENT_THEME=""

if [ -f "$CURRENT_THEME_FILE" ]; then
    CURRENT_THEME=$(cat "$CURRENT_THEME_FILE")
fi

# List only non-hidden directories
mapfile -t themes < <(
    find "$THEME_DIR" \
        -mindepth 1 \
        -maxdepth 1 \
        -type d \
        ! -iname ".*" \
        -exec basename {} \; |
    sort
)

# Build menu
menu_options=""

for theme in "${themes[@]}"; do
    if [ "$theme" = "$CURRENT_THEME" ]; then
        menu_options+="󰄯 $theme\n"
    else
        menu_options+="$theme\n"
    fi
done



# Show menu
selected=$(
    echo -en "$menu_options" |
    rofi \
        -dmenu \
        -i \
        -p "Select Theme" \
        -theme ~/.config/colorschemes/rofi-theme.rasi
)

# Exit if nothing selected
[[ -z "$selected" ]] && exit 0

# Remove indicator
selected=$(echo "$selected" | sed 's/^● //')

# Don't re-apply current theme
[[ "$selected" == "$CURRENT_THEME" ]] && exit 0

# Apply selected theme
"$APPLY_SCRIPT" "$selected" >/dev/null 2>&1