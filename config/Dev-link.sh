#!/bin/sh

set -eu

# ============================================================
# dOrigin - Config Symlink Installer
# ============================================================

# Directory where this script/repository is located
SCRIPT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"

# Repository .config directory
DOTFILES_CONFIG="$SCRIPT_DIR/.config"

# User .config directory
CONFIG_DIR="$HOME/.config"

# Backup directory
BACKUP_DIR="$HOME/.config.backup"


# ============================================================
# CONFIGURATION
# ============================================================

# Add the folders/files you want to symlink here.
#
# Example:
#   hypr
#   waybar
#   kitty
#   rofi
#   colorschemes
#
# Anything NOT listed here will be left untouched.

LINK_ITEMS="
colorschemes
fish
gtk-3.0
gtk-4.0
hypr
kitty
matugen
nvim
nwg-look
rofi
starship.toml
swaync
VSCodium
wallust
waybar
wlogout
"


# ============================================================
# FUNCTIONS
# ============================================================

info() {
    printf '%s\n' "[INFO] $1"
}

ok() {
    printf '%s\n' "[OK] $1"
}

warn() {
    printf '%s\n' "[WARN] $1"
}

error() {
    printf '%s\n' "[ERROR] $1" >&2
}


# Create a unique backup path
get_backup_path() {
    item="$1"
    base="$BACKUP_DIR/$item"

    # If the backup doesn't exist, use it directly
    if [ ! -e "$base" ] && [ ! -L "$base" ]; then
        printf '%s\n' "$base"
        return
    fi

    i=1

    while [ -e "$base.$i" ] || [ -L "$base.$i" ]; do
        i=$((i + 1))
    done

    printf '%s\n' "$base.$i"
}


# ============================================================
# CHECKS
# ============================================================

info "Checking dotfiles..."

if [ ! -d "$DOTFILES_CONFIG" ]; then
    error "Repository .config directory not found:"
    error "$DOTFILES_CONFIG"
    exit 1
fi

ok "Found: $DOTFILES_CONFIG"


# ============================================================
# PREPARE ~/.config
# ============================================================

if [ -L "$CONFIG_DIR" ]; then
    error "$CONFIG_DIR is itself a symlink."
    error "This script expects ~/.config to be a real directory."
    error "Refusing to modify it automatically."
    exit 1
fi

if [ ! -d "$CONFIG_DIR" ]; then
    info "Creating ~/.config..."
    mkdir -p "$CONFIG_DIR"
    ok "Created ~/.config"
fi


# ============================================================
# CREATE BACKUP DIRECTORY WHEN NEEDED
# ============================================================

BACKUP_CREATED=0


# ============================================================
# LINK CONFIGURATION ITEMS
# ============================================================

info "Processing selected config items..."

# Read each configured item
printf '%s\n' "$LINK_ITEMS" | while IFS= read -r item; do

    # Ignore empty lines
    [ -n "$item" ] || continue

    SOURCE="$DOTFILES_CONFIG/$item"
    TARGET="$CONFIG_DIR/$item"

    # --------------------------------------------------------
    # Check source exists
    # --------------------------------------------------------

    if [ ! -e "$SOURCE" ] && [ ! -L "$SOURCE" ]; then
        warn "Not found in repository: $item"
        continue
    fi

    # --------------------------------------------------------
    # Already correctly linked
    # --------------------------------------------------------

    if [ -L "$TARGET" ]; then

        SOURCE_REAL="$(readlink -f "$SOURCE")"
        TARGET_REAL="$(readlink -f "$TARGET" 2>/dev/null || true)"

        if [ "$SOURCE_REAL" = "$TARGET_REAL" ]; then
            ok "Already linked: $item"
            continue
        fi

        info "Removing existing symlink: $TARGET"
        rm "$TARGET"
    fi

    # --------------------------------------------------------
    # Existing file/directory
    # --------------------------------------------------------

    if [ -e "$TARGET" ]; then

        if [ "$BACKUP_CREATED" -eq 0 ]; then
            mkdir -p "$BACKUP_DIR"
            BACKUP_CREATED=1
        fi

        BACKUP_PATH="$(get_backup_path "$item")"

        # Create parent directory for nested items
        BACKUP_PARENT="$(dirname "$BACKUP_PATH")"
        mkdir -p "$BACKUP_PARENT"

        info "Backing up existing: $TARGET"

        mv "$TARGET" "$BACKUP_PATH"

        ok "Backup created: $BACKUP_PATH"
    fi

    # --------------------------------------------------------
    # Make sure target parent exists
    # --------------------------------------------------------

    TARGET_PARENT="$(dirname "$TARGET")"
    mkdir -p "$TARGET_PARENT"

    # --------------------------------------------------------
    # Create symlink
    # --------------------------------------------------------

    ln -s "$SOURCE" "$TARGET"

    ok "Linked: $TARGET -> $SOURCE"

done


# ============================================================
# DONE
# ============================================================

printf '\n'
ok "Selected dotfiles linked successfully."

if [ "$BACKUP_CREATED" -eq 1 ]; then
    info "Existing configurations were backed up to:"
    info "$BACKUP_DIR"
fi

printf '\n'
info "Managed items:"
printf '%s\n' "$LINK_ITEMS" | while IFS= read -r item; do
    [ -n "$item" ] || continue
    printf '  - %s\n' "$item"
done

printf '\n'
ok "Done."
