#!/usr/bin/env bash

INIT_PATH=$(pwd)

sudo cp -v "$INIT_PATH/files/pacman/mirrorlist" /etc/pacman.d/mirrorlist
sudo cp -v "$INIT_PATH/files/pacman/pacman.conf" /etc/pacman.conf
sudo pacman -Syyuu --noconfirm

git clone https://github.com/end-4/dots-hyprland.git "$INIT_PATH"
cd "$INIT_PATH/dots-hyprland/" && chmod +x ./setup && ./setup install

tar -xzvf "$INIT_PATH/files/grub/Inoue-Takina.tar.gz" --directory "$INIT_PATH"
cd "$INIT_PATH/Inoue Takina/" && chmod +x ./install.sh && sudo ./install.sh

rm -rfv "$INIT_PATH/dots-hyprland/" "$INIT_PATH/Inoue Takina/"
cd "$INIT_PATH"

yay -Syu --noconfirm paru
