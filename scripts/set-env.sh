#!/usr/bin/env bash

# Get the directory where the script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# The parent directory of scripts/ is the root of the repo
REPO_ROOT="$(dirname "$SCRIPT_DIR")"

INIT_PATH="$REPO_ROOT"
CACHE_PATH=~/.cache/hyprland-init

# Exit on error
set -e

mkdir -p "$CACHE_PATH"

sudo cp -v "$INIT_PATH/files/pacman/mirrorlist" /etc/pacman.d/mirrorlist
sudo cp -v "$INIT_PATH/files/pacman/pacman.conf" /etc/pacman.conf
sudo pacman -Syyuu --noconfirm

# Install base-devel and git if not present
sudo pacman -S --needed --noconfirm base-devel git

# Install yay if not present (needed to install paru easily, or install paru directly)
if ! command -v yay &> /dev/null && ! command -v paru &> /dev/null; then
    echo "Installing yay..."
    if [[ -d "$CACHE_PATH/yay" ]]; then
        rm -rf "$CACHE_PATH/yay"
    fi
    git clone https://aur.archlinux.org/yay.git "$CACHE_PATH/yay"
    cd "$CACHE_PATH/yay"
    makepkg -si --noconfirm
    cd "$INIT_PATH"
fi

if [[ -d "$CACHE_PATH/dots-hyprland/.git/" ]]; then
  cd "$CACHE_PATH/dots-hyprland/"
  git pull
else
  git clone https://github.com/end-4/dots-hyprland.git "$CACHE_PATH/dots-hyprland/"
fi
cd "$CACHE_PATH/dots-hyprland/" && chmod +x ./setup && ./setup install

if [[ -d "$CACHE_PATH/Inoue Takina/" ]]; then
  rm -rf "$CACHE_PATH/Inoue Takina/"
fi
tar -xzvf "$INIT_PATH/files/grub/Inoue-Takina.tar.gz" --directory "$CACHE_PATH"
cd "$CACHE_PATH/Inoue Takina/" && chmod +x ./install.sh && sudo ./install.sh

cd "$INIT_PATH"
# Use yay to install paru if paru is missing
if ! command -v paru &> /dev/null; then
    yay -Syu --needed --noconfirm paru
fi
