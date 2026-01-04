#!/usr/bin/env bash

# Get the directory where the script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# The parent directory of scripts/ is the root of the repo
REPO_ROOT="$(dirname "$SCRIPT_DIR")"

INIT_PATH="$REPO_ROOT"
CACHE_PATH=~/.cache/hyprland-init

# Exit on error
set -e

mkdir --parents "$CACHE_PATH"

sudo cp --verbose "$INIT_PATH/files/pacman/mirrorlist" /etc/pacman.d/mirrorlist
sudo cp --verbose "$INIT_PATH/files/pacman/pacman.conf" /etc/pacman.conf
sudo pacman -Syyuu --noconfirm

# Install base-devel and git if not present
sudo pacman -S --needed --noconfirm base-devel git

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
fi

if [[ -d "$CACHE_PATH/dots-hyprland/.git/" ]]; then
  cd "$CACHE_PATH/dots-hyprland/"
  git stash && git pull
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
