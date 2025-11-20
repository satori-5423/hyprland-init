#!/usr/bin/env bash

# Get the directory where the script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# The parent directory of scripts/ is the root of the repo
REPO_ROOT="$(dirname "$SCRIPT_DIR")"

# Exit on error
set -e

# files/extra
# ~/.config/fish/config.fish
# ~/.config/kitty/kitty.conf

cp -v "$REPO_ROOT/files/hyprland/"* ~/.config/hypr/custom/
