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
sed -i '/font_size 20.0/a symbol_map U+e000-U+e00a,U+e0a0-U+e0a2,U+e0a3,U+e0b0-U+e0b3,U+e0b4-U+e0c8,U+e0ca,U+e0cc-U+e0d7,U+e200-U+e2a9,U+e300-U+e3e3,U+e5fa-U+e6b7,U+e700-U+e8ef,U+ea60-U+ec1e,U+ed00-U+efce,U+f000-U+f2ff,U+f300-U+f381,U+f400-U+f533,U+f0001-U+f1af0 Symbols Nerd Font Mono\nsymbol_map U+2022,U+2192,U+2500,U+256F,U+2570,U+E0B0-U+E0D4,U+EA71,U+F00D,U+F04B,U+F12C,U+F409,U+F40F,U+F456,U+F46D,U+F4A5,U+F4A9,U+F4B6,U+F024B,U+F02A4,U+F0388,U+F062C,U+F0725,U+F0AA2,U+1FB00-U+1FBFF JetBrains Mono Nerd Font' ~/.config/kitty/kitty.conf
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
