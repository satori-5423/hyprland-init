#!/usr/bin/env bash

# Get the directory where the script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# The parent directory of scripts/ is the root of the repo
REPO_ROOT="$(dirname "$SCRIPT_DIR")"

# Exit on error
set -e

chsh --shell $(which fish)

mkdir --parents ~/.config/
mkdir --parents ~/.local/

# git clone https://github.com/LazyVim/starter ~/.config/nvim
# rm -rfv ~/.config/nvim/.git

cp --recursive --verbose "$REPO_ROOT/configs/.config/"* ~/.config/
cp --recursive --verbose "$REPO_ROOT/configs/.local/"* ~/.local/
cp --verbose "$REPO_ROOT/configs/dotfiles/."* ~/

gsettings set org.gnome.desktop.wm.preferences button-layout ':'
gsettings set org.gnome.desktop.interface icon-theme 'Papirus'
gsettings set com.github.stunkymonkey.nautilus-open-any-terminal terminal kitty
