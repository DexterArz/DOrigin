#!/usr/bin/env bash
set -euo pipefail

HYPR_DIR="$HOME/.config/hypr"
ANIMATIONS_DIR="$HYPR_DIR/animations"
MODULE_FILE="$HYPR_DIR/modules/animations.lua"

NOTIFY=${NOTIFY:-notify-send}

# Check directories
[[ -d "$ANIMATIONS_DIR" ]] || {
    echo "Animations directory not found: $ANIMATIONS_DIR" >&2
    exit 1
}

[[ -d "$(dirname "$MODULE_FILE")" ]] || {
    echo "Modules directory not found: $(dirname "$MODULE_FILE")" >&2
    exit 1
}

# Find animation files
mapfile -t ANIMATIONS < <(
    find "$ANIMATIONS_DIR" \
        -mindepth 1 \
        -maxdepth 1 \
        -type f \
        -name "*.lua" \
        -printf "%f\n" |
        sed 's/\.lua$//' |
        sort
)

((${#ANIMATIONS[@]})) || {
    echo "No animation files found in $ANIMATIONS_DIR"
    exit 1
}

# Detect currently loaded animation
current="(none)"

if [[ -f "$MODULE_FILE" ]]; then
    current=$(
        grep -oP 'require\(["'\'']animations\.\K[^"'\'']+' "$MODULE_FILE" |
            head -n1 ||
            true
    )

    [[ -n "$current" ]] || current="(none)"
fi

# Build menu
menu=$(printf "%s\n" "${ANIMATIONS[@]}" |
    awk -v c="$current" '{print ($0==c?"󰄯 ":"  ")$0}')

# Select animation
chosen=$(
    echo "$menu" |
        rofi -dmenu \
            -i \
            -p "Select Animation" \
            -theme ~/.config/rofi/themes/Launcher.rasi |
        sed 's/^| //; s/^  //'
)

[[ -z "${chosen:-}" ]] && exit 0

# Verify selected animation exists
animation_file="$ANIMATIONS_DIR/$chosen.lua"

[[ -f "$animation_file" ]] || {
    echo "Animation file not found: $animation_file"
    exit 1
}

# Write require statement
cat > "$MODULE_FILE" <<EOF
require("animations.$chosen")
EOF

# Reload Hyprland
hyprctl reload >/dev/null 2>&1 || true

# Notification
[[ "$NOTIFY" = ":" ]] || \
    "$NOTIFY" "Hyprland" "Animation: $chosen"