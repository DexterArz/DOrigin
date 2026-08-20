#!/usr/bin/env bash

set -e

# ============================================================
# Dotfiles Installer
# ============================================================

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HOME_DIR="$HOME"
BACKUP_DIR="$HOME/config-backup"
PKG_FILE="$DOTFILES_DIR/pkg.md"

# ------------------------------------------------------------
# Colors
# ------------------------------------------------------------

GREEN="\033[1;32m"
YELLOW="\033[1;33m"
RED="\033[1;31m"
BLUE="\033[1;34m"
RESET="\033[0m"

info() {
    echo -e "${BLUE}[INFO]${RESET} $1"
}

success() {
    echo -e "${GREEN}[OK]${RESET} $1"
}

warning() {
    echo -e "${YELLOW}[WARN]${RESET} $1"
}

error() {
    echo -e "${RED}[ERROR]${RESET} $1"
}

# ------------------------------------------------------------
# Check Arch Linux
# ------------------------------------------------------------

if [[ ! -f /etc/arch-release ]]; then
    error "This installer is intended for Arch Linux."
    exit 1
fi

success "Arch Linux detected."

# ------------------------------------------------------------
# Check sudo
# ------------------------------------------------------------

if ! command -v sudo &>/dev/null; then
    error "sudo is required."
    exit 1
fi

# ------------------------------------------------------------
# Install yay
# ------------------------------------------------------------

if command -v yay &>/dev/null; then
    success "yay is already installed."
else
    info "yay not found. Installing yay..."

    TEMP_DIR="$(mktemp -d)"

    git clone https://aur.archlinux.org/yay.git "$TEMP_DIR/yay"

    cd "$TEMP_DIR/yay"

    makepkg -si --noconfirm

    cd "$DOTFILES_DIR"

    rm -rf "$TEMP_DIR"

    success "yay installed."
fi

# ------------------------------------------------------------
# Install packages
# ------------------------------------------------------------

if [[ ! -f "$PKG_FILE" ]]; then
    error "pkg.md not found!"
    exit 1
fi

info "Reading packages from pkg.md..."

PACKAGES=()

while IFS= read -r line; do

    # Remove leading/trailing whitespace
    line="$(echo "$line" | xargs)"

    # Ignore empty lines
    [[ -z "$line" ]] && continue

    # Ignore comments
    [[ "$line" =~ ^# ]] && continue

    PACKAGES+=("$line")

done < "$PKG_FILE"

if [[ ${#PACKAGES[@]} -gt 0 ]]; then
    info "Installing packages..."

    yay -S --needed --noconfirm "${PACKAGES[@]}"

    success "Packages installed."
else
    warning "No packages found in pkg.md."
fi

# ------------------------------------------------------------
# Create backup directory
# ------------------------------------------------------------

info "Preparing configuration backup..."

mkdir -p "$BACKUP_DIR"

# ------------------------------------------------------------
# Backup existing configurations
# ------------------------------------------------------------

backup_directory() {

    local source="$1"
    local name="$2"
    local destination="$BACKUP_DIR/$name"

    if [[ -e "$source" ]]; then

        if [[ -e "$destination" ]]; then
            warning "$destination already exists."

            # Create timestamped backup
            timestamp="$(date '+%Y-%m-%d_%H-%M-%S')"
            destination="$BACKUP_DIR/${name}_${timestamp}"
        fi

        info "Backing up $source -> $destination"

        cp -a "$source" "$destination"

        success "Backed up $name."
    else
        info "$source does not exist. Nothing to back up."
    fi
}

backup_directory "$HOME/.config" ".config"
backup_directory "$HOME/.local" ".local"
backup_directory "$HOME/.themes" ".themes"

# ------------------------------------------------------------
# Copy dotfiles
# ------------------------------------------------------------

copy_directory() {

    local source="$DOTFILES_DIR/$1"
    local destination="$HOME/$1"

    if [[ -d "$source" ]]; then

        info "Copying $1..."

        mkdir -p "$destination"

        cp -a "$source/." "$destination/"

        success "$1 copied."
    else
        warning "$source does not exist. Skipping."
    fi
}

copy_directory ".config"
copy_directory ".local"
copy_directory ".themes"

# ------------------------------------------------------------
# Finished
# ------------------------------------------------------------

echo
echo -e "${GREEN}========================================${RESET}"
echo -e "${GREEN}      Dotfiles installation complete    ${RESET}"
echo -e "${GREEN}========================================${RESET}"
echo
echo "Dotfiles: $DOTFILES_DIR"
echo "Backup:   $BACKUP_DIR"
echo
