#!/usr/bin/env bash

set -e

# ============================================================
# DOrigin Config Installer
# ============================================================

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/config-backup"
PKG_FILE="$DOTFILES_DIR/pkg.md"

# ------------------------------------------------------------
# External repositories
# ------------------------------------------------------------

GTK_REPO="https://github.com/DexterArz/Gtk-themes.git"
VSCODE_REPO="https://github.com/DexterArz/vs-code-themes.git"

GTK_REPO_DIR="$HOME/.local/share/DOrigin-Gtk-themes"
VSCODE_REPO_DIR="$HOME/.local/share/DOrigin-vs-code-themes"

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
# Install required dependencies
# ------------------------------------------------------------

info "Installing required dependencies..."

sudo pacman -S --needed --noconfirm \
    nerd-fonts \
    base-devel \
    git \
    fakeroot \
    debugedit \
    pkgconf \
    gtk3 \
    cmake

success "Required dependencies installed."

# ------------------------------------------------------------
# Install yay
# ------------------------------------------------------------

if command -v yay &>/dev/null; then

    success "yay is already installed."

else

    info "yay not found. Installing yay..."

    TEMP_DIR="$(mktemp -d)"

    cleanup() {
        rm -rf "$TEMP_DIR"
    }

    trap cleanup EXIT

    git clone \
        https://aur.archlinux.org/yay.git \
        "$TEMP_DIR/yay"

    cd "$TEMP_DIR/yay"

    makepkg -si --noconfirm

    cd "$DOTFILES_DIR"

    success "yay installed."

fi

# ------------------------------------------------------------
# Check pkg.md
# ------------------------------------------------------------

if [[ ! -f "$PKG_FILE" ]]; then
    error "pkg.md not found!"
    exit 1
fi

# ------------------------------------------------------------
# Read packages from pkg.md
# ------------------------------------------------------------

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

# ------------------------------------------------------------
# Install packages
# ------------------------------------------------------------

if [[ ${#PACKAGES[@]} -gt 0 ]]; then

    info "Installing packages..."

    yay -S --needed --noconfirm "${PACKAGES[@]}"

    success "Packages installed."

else

    warning "No packages found in pkg.md."

fi

# ------------------------------------------------------------
# Create backup
# ------------------------------------------------------------

TIMESTAMP="$(date '+%Y-%m-%d_%H-%M-%S')"
BACKUP_PATH="$BACKUP_DIR/$TIMESTAMP"

info "Preparing configuration backup..."

mkdir -p "$BACKUP_PATH"

# ------------------------------------------------------------
# Backup existing configurations
# ------------------------------------------------------------

backup_directory() {

    local source="$1"
    local name="$2"
    local destination="$BACKUP_PATH/$name"

    if [[ -e "$source" ]]; then

        info "Backing up $source..."

        cp -a "$source" "$destination"

        success "Backed up $name."

    else

        info "$source does not exist. Nothing to back up."

    fi
}

backup_directory "$HOME/.config" ".config"
backup_directory "$HOME/.local" ".local"
backup_directory "$HOME/.themes" ".themes"
backup_directory "$HOME/.vscode-oss" ".vscode-oss"

# ------------------------------------------------------------
# Install .config
# ------------------------------------------------------------

CONFIG_SOURCE="$DOTFILES_DIR/.config"

if [[ -d "$CONFIG_SOURCE" ]]; then

    info "Installing .config..."

    mkdir -p "$HOME/.config"

    cp -a "$CONFIG_SOURCE/." "$HOME/.config/"

    success ".config installed."

else

    error "$CONFIG_SOURCE does not exist."
    exit 1

fi

# ------------------------------------------------------------
# Install .local
# ------------------------------------------------------------

LOCAL_SOURCE="$DOTFILES_DIR/.local"

if [[ -d "$LOCAL_SOURCE" ]]; then

    info "Installing .local..."

    mkdir -p "$HOME/.local"

    cp -a "$LOCAL_SOURCE/." "$HOME/.local/"

    success ".local installed."

fi

# ------------------------------------------------------------
# Clone or update repository
# ------------------------------------------------------------

clone_or_update_repo() {

    local repo="$1"
    local destination="$2"
    local name="$3"

    if [[ -d "$destination/.git" ]]; then

        info "$name already exists. Updating..."

        git -C "$destination" pull --ff-only

        success "$name updated."

    elif [[ -e "$destination" ]]; then

        warning "$destination already exists."
        warning "It is not a Git repository."
        warning "Skipping $name."

    else

        info "Cloning $name..."

        mkdir -p "$(dirname "$destination")"

        git clone "$repo" "$destination"

        success "$name cloned."

    fi
}

# ------------------------------------------------------------
# GTK Themes
# ------------------------------------------------------------

clone_or_update_repo \
    "$GTK_REPO" \
    "$GTK_REPO_DIR" \
    "GTK themes repository"

GTK_SOURCE="$GTK_REPO_DIR/themes/.themes"

if [[ -d "$GTK_SOURCE" ]]; then

    info "Installing GTK themes..."

    mkdir -p "$HOME/.themes"

    cp -a "$GTK_SOURCE/." "$HOME/.themes/"

    success "GTK themes installed."

else

    warning "$GTK_SOURCE does not exist."
    warning "Skipping GTK themes."

fi

# ------------------------------------------------------------
# VS Code Themes
# ------------------------------------------------------------

clone_or_update_repo \
    "$VSCODE_REPO" \
    "$VSCODE_REPO_DIR" \
    "VS Code themes repository"

VSCODE_SOURCE="$VSCODE_REPO_DIR/themes/.vscode-oss"

if [[ -d "$VSCODE_SOURCE" ]]; then

    info "Installing VS Code themes..."

    mkdir -p "$HOME/.vscode-oss"

    cp -a "$VSCODE_SOURCE/." "$HOME/.vscode-oss/"

    success "VS Code themes installed."

else

    warning "$VSCODE_SOURCE does not exist."
    warning "Skipping VS Code themes."

fi

# ------------------------------------------------------------
# Finished
# ------------------------------------------------------------

echo

echo -e "${GREEN}========================================${RESET}"
echo -e "${GREEN}     DOrigin installation complete     ${RESET}"
echo -e "${GREEN}========================================${RESET}"

echo

echo "Config:  $CONFIG_SOURCE"
echo "Themes:  $HOME/.themes"
echo "VS Code: $HOME/.vscode-oss"
echo "Backup:  $BACKUP_PATH"

echo