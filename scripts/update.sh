#!/usr/bin/env bash

# Get the directory where the script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# The parent directory of scripts/ is the root of the repo
REPO_ROOT="$(dirname "$SCRIPT_DIR")"

# Exit on error
set -e

# kitty
sed -i '1i # vim:ft=kitty\nbackground_opacity 0.8\n\n# Neovim\nscrollback_pager nvim --cmd "set eventignore=FileType" +"nnoremap q ZQ" +"call nvim_open_term(0, {})" +"set nomodified nolist" +"$" -\nmap ctrl+shift+h show_scrollback\n' ~/.config/kitty/kitty.conf
sed -i 's/font_size 11.0/font_size 20.0/g' ~/.config/kitty/kitty.conf
sed -i 's/change_font_size all/change_font_size current/g' ~/.config/kitty/kitty.conf
sed -i '/cursor_trail 1/a cursor_trail_decay 0.1 0.42\ncursor_trail_start_threshold 0' ~/.config/kitty/kitty.conf
sed -i '/# Scroll & Zoom/a scrollbar scrolled-and-hovered' ~/.config/kitty/kitty.conf

# fish
sed -i 's/enable_transience/# enable_transience/g' ~/.config/fish/config.fish

# fontconfig
cp -v "$REPO_ROOT/configs/.config/fontconfig/fonts.conf" ~/.config/fontconfig/fonts.conf
fc-cache -fv

# dolphinrc
cp -v "$REPO_ROOT/configs/.config/dolphinrc" ~/.config/dolphinrc
