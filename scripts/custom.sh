#!/usr/bin/env bash

# Get the directory where the script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# The parent directory of scripts/ is the root of the repo
REPO_ROOT="$(dirname "$SCRIPT_DIR")"

# Exit on error
set -e

# kitty
cp -v "$REPO_ROOT/configs/.config/kitty/kitty.conf" ~/.config/kitty/kitty.conf

# fish
cp -v "$REPO_ROOT/configs/.config/fish/config.fish" ~/.config/fish/config.fish

# fontconfig
cp -v "$REPO_ROOT/configs/.config/fontconfig/fonts.conf" ~/.config/fontconfig/fonts.conf
fc-cache -fv

# dolphinrc
cp -v "$REPO_ROOT/configs/.config/dolphinrc" ~/.config/dolphinrc
