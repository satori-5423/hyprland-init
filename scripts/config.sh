#!/usr/bin/env bash

chsh -s $(which fish)

mkdir -p ~/.config/

# git clone https://github.com/LazyVim/starter ~/.config/nvim
# rm -rfv ~/.config/nvim/.git

cp -rv ./files/.config/* ~/.config/
cp -v ./files/dotfiles/.* ~/
