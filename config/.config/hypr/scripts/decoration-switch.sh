#!/usr/bin/env bash
set -euo pipefail

HYPR_DIR="$HOME/.config/hypr"
DECORATIONS_DIR="$HYPR_DIR/decorations"
MODULE_FILE="$HYPR_DIR/modules/looks.lua"

NOTIFY=${NOTIFY:-notify-send}

# Check directories
[[ -d "$DECORATIONS_DIR" ]] || {
    echo "Decorations directory not found: $DECORATIONS_DIR" >&2
    exit 1
}

[[ -d "$(dirname "$MODULE_FILE")" ]] || {
    echo "Modules directory not found: $(dirname "$MODULE_FILE")" >&2
    exit 1
}

# Find decoration files
mapfile -t DECORATIONS < <(
    find "$DECORATIONS_DIR" \
        -mindepth 1 \
        -maxdepth 1 \
        -type f \
        -name "*.lua" \
        -printf "%f\n" |
        sed 's/\.lua$//' |
        sort
)

((${#DECORATIONS[@]})) || {
    echo "No decoration files found in $DECORATIONS_DIR"
    exit 1
}

# Detect currently loaded decoration
current="(none)"

if [[ -f "$MODULE_FILE" ]]; then
    current=$(
        grep -oP 'require\(["'\'']decorations\.\K[^"'\'']+' "$MODULE_FILE" |
            head -n1 ||
            true
    )

    [[ -n "$current" ]] || current="(none)"
fi

# Build menu
menu=$(printf "%s\n" "${DECORATIONS[@]}" |
    awk -v c="$current" '{print ($0==c?"󰄯 ":"  ")$0}')

# Select decoration
chosen=$(
    echo "$menu" |
        rofi -dmenu \
            -i \
            -p "Select Decoration" \
            -theme ~/.config/rofi/themes/Launcher.rasi |
        sed 's/^| //; s/^  //'
)

[[ -z "${chosen:-}" ]] && exit 0

# Verify selected decoration exists
decoration_file="$DECORATIONS_DIR/$chosen.lua"

[[ -f "$decoration_file" ]] || {
    echo "Decoration file not found: $decoration_file"
    exit 1
}

# Write require statement
cat > "$MODULE_FILE" <<EOF
require("decorations.$chosen")
EOF

# Reload Hyprland
hyprctl reload >/dev/null 2>&1 || true

# Notification
[[ "$NOTIFY" = ":" ]] || \
    "$NOTIFY" "Hyprland" "Decoration: $chosen"