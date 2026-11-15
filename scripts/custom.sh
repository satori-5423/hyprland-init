#!/usr/bin/env bash

# kitty
cp -v ./configs/.config/kitty/kitty.conf ~/.config/kitty/kitty.conf

# fish
cp -v ./configs/.config/fish/config.fish ~/.config/fish/config.fish

# fontconfig
cp -v ./configs/.config/fontconfig/fonts.conf ~/.config/fontconfig/fonts.conf
fc-cache -fv

# dolphinrc
cp -v ./configs/.config/dolphinrc ~/.config/dolphinrc
