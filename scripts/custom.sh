#!/usr/bin/env bash

# files/extra
# ~/.config/fish/config.fish
# ~/.config/kitty/kitty.conf

KEYBINDS="$HOME/.config/hypr/hyprland/keybinds.conf"
EXECS="$HOME/.config/hypr/hyprland/execs.conf"

perl ./modify_configs.pl "$EXECS"
perl ./modify_configs.pl "$KEYBINDS"

cp -v ./files/hyprland/* ~/.config/hypr/custom/
