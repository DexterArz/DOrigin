#!/usr/bin/env bash
set -euo pipefail

HYPR_DIR="$HOME/.config/hypr"
LAYOUTS_DIR="$HYPR_DIR/layouts"
MODULE_FILE="$HYPR_DIR/modules/layouts.lua"

NOTIFY=${NOTIFY:-notify-send}

# Check layout
[[ -d "$LAYOUTS_DIR" ]] || {
    echo "layout directory not found: $LAYOUTS_DIR" >&2
    exit 1
}

[[ -d "$(dirname "$MODULE_FILE")" ]] || {
    echo "Modules directory not found: $(dirname "$MODULE_FILE")" >&2
    exit 1
}

# Find layout files
mapfile -t LAYOUTS< <(
    find "$LAYOUTS_DIR" \
        -mindepth 1 \
        -maxdepth 1 \
        -type f \
        -name "*.lua" \
        -printf "%f\n" |
        sed 's/\.lua$//' |
        sort
)

((${#LAYOUTS[@]})) || {
    echo "No layout files found in $LAYOUTS_DIR"
    exit 1
}

# Detect currently loaded layout
current="(none)"

if [[ -f "$MODULE_FILE" ]]; then
    current=$(
        grep -oP 'require\(["'\'']layouts\.\K[^"'\'']+' "$MODULE_FILE" |
            head -n1 ||
            true
    )

    [[ -n "$current" ]] || current="(none)"
fi

# Build menu
menu=$(printf "%s\n" "${LAYOUTS[@]}" |
    awk -v c="$current" '{print ($0==c?"󰄯 ":"  ")$0}')

# Select decoration
chosen=$(
    echo "$menu" |
        rofi -dmenu \
            -i \
            -p "Select layout" \
            -theme ~/.config/rofi/themes/Launcher.rasi |
        sed 's/^| //; s/^  //'
)

[[ -z "${chosen:-}" ]] && exit 0

# Verify selected layout exists
layouts_file="$LAYOUTS_DIR/$chosen.lua"

[[ -f "$layouts_file" ]] || {
    echo "layout file not found: $layouts_file"
    exit 1
}

# Write require statement
cat > "$MODULE_FILE" <<EOF
require("layouts.$chosen")
EOF

# Reload Hyprland
hyprctl reload >/dev/null 2>&1 || true

# Notification
[[ "$NOTIFY" = ":" ]] || \
    "$NOTIFY" "Hyprland" "layout: $chosen"