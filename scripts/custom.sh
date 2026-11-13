#!/usr/bin/env bash

# kitty
cp -v "$REPO_ROOT/configs/.config/kitty/kitty.conf" ~/.config/kitty/kitty.conf

# fish
cp -v "$REPO_ROOT/configs/.config/fish/config.fish" ~/.config/fish/config.fish

# fontconfig
cp -v "$REPO_ROOT/configs/.config/fontconfig/fonts.conf" ~/.config/fontconfig/fonts.conf
fc-cache -fv

# dolphinrc
cp -v "$REPO_ROOT/configs/.config/dolphinrc" ~/.config/dolphinrc
