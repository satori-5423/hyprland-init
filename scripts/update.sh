#!/usr/bin/env bash

# Get the directory where the script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# The parent directory of scripts/ is the root of the repo
REPO_ROOT="$(dirname "$SCRIPT_DIR")"

# Exit on error
set -e

sed -i '1i # vim:ft=kitty\nbackground_opacity 0.8\n' ~/.config/kitty/kitty.conf
sed -i 's/font_size 11.0/font_size 20.0/g' ~/.config/kitty/kitty.conf
sed -i 's/change_font_size all/change_font_size current/g' ~/.config/kitty/kitty.conf

cp -v "$REPO_ROOT/configs/.config/fontconfig/fonts.conf" ~/.config/fontconfig/fonts.conf
fc-cache -fv

cp -v ~/ii-original-dots-backup/.config/dolphinrc ~/.config/dolphinrc
