#!/usr/bin/env bash

chsh --shell $(which fish)

gsettings set org.gnome.desktop.wm.preferences button-layout ':'
gsettings set org.gnome.desktop.interface icon-theme 'Papirus'
