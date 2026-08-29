#!/usr/bin/env bash

# Get the directory where the script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# The parent directory of scripts/ is the root of the repo
REPO_ROOT="$(dirname "$SCRIPT_DIR")"

INIT_PATH="$REPO_ROOT"
CACHE_PATH=~/.cache/hyprland-init

# Exit on error
set -e

source "$SCRIPT_DIR/lib.sh"

mkdir --parents "$CACHE_PATH"

sudo cp --verbose "$INIT_PATH/configs/pacman/mirrorlist" /etc/pacman.d/mirrorlist
sudo cp --verbose "$INIT_PATH/configs/pacman/pacman.conf" /etc/pacman.conf
sudo pacman -Syyuu --noconfirm

# Detect EFI directory automatically, fall back to manual input
EFI_DIR="$(detect_efi_dir)" || true
if [[ -z "$EFI_DIR" ]]; then
    read -p "Enter your EFI directory path (Default: /efi): " EFI_DIR
    EFI_DIR=${EFI_DIR:-/efi}
fi
echo "Using EFI directory: $EFI_DIR"

sudo mkdir --parents /etc/pacman.d/hooks/
sudo cp --verbose "$INIT_PATH/configs/pacman/hooks/"* /etc/pacman.d/hooks/

# Update the GRUB hook with the chosen EFI directory
if [[ -f /etc/pacman.d/hooks/99-grub-install.hook ]]; then
    sudo sed -i "s|--efi-directory=/efi|--efi-directory=$EFI_DIR|g" /etc/pacman.d/hooks/99-grub-install.hook
    echo "Updated GRUB hook with EFI directory: $EFI_DIR"
fi

# Install base-devel if not present
sudo pacman -Syu --needed --noconfirm base-devel

# Install paru if not present
if ! command -v paru &> /dev/null; then
    echo "Installing paru..."
    if [[ -d "$CACHE_PATH/paru" ]]; then
        rm -rf "$CACHE_PATH/paru"
    fi
    git clone https://aur.archlinux.org/paru.git "$CACHE_PATH/paru"
    cd "$CACHE_PATH/paru"
    makepkg -si --noconfirm
    cd "$INIT_PATH"
    paru -Syu --needed --noconfirm bibata-cursor-theme
fi

# Locate dots-hyprland repo
DOTS="$(dots_dir)"
if [[ ! -d "$DOTS/.git" ]]; then
    echo "Cloning dots-hyprland to $DOTS..."
    mkdir --parents "$(dirname "$DOTS")"
    git clone https://github.com/satori-5423/dots-hyprland.git --depth=1 "$DOTS"
fi
if [[ "$DOTS" != "$XDG_PROJECTS_DIR/GitHub/dots-hyprland" ]]; then
    # Update cached clone
    cd "$DOTS"
    git fetch origin --depth=1 && git reset --hard origin/master
fi
{ cd "$DOTS" && chmod +x ./setup && ./setup install; } || true

# Build and install the GRUB theme from PKGBUILD
BUILD_DIR="$CACHE_PATH/grub-theme-takina"
if [[ -d "$BUILD_DIR" ]]; then
    rm -rf "$BUILD_DIR"
fi
mkdir --parents "$BUILD_DIR"
cp "$INIT_PATH/configs/grub/PKGBUILD" \
   "$INIT_PATH/configs/grub/grub-theme-takina.install" \
   "$INIT_PATH/configs/grub/Inoue-Takina.tar.gz" "$BUILD_DIR/"
cd "$BUILD_DIR"
makepkg -si --noconfirm
cd "$INIT_PATH"
