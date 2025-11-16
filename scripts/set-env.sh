#!/usr/bin/env bash

sudo cp -v ./files/pacman/mirrorlist /etc/pacman.d/mirrorlist
sudo cp -v ./files/pacman/pacman.conf /etc/pacman.conf
sudo pacman -Syyuu --noconfirm

INIT_PATH=$(pwd)

git clone https://github.com/end-4/dots-hyprland.git
cd "$INIT_PATH/dots-hyprland/"
chmod +x ./setup
./setup install
cd "$INIT_PATH"

tar -xzvf ./files/grub/Inoue-Takina.tar.gz --directory "$INIT_PATH"
cd "$INIT_PATH/Inoue Takina/"
chmod +x ./install.sh
sudo ./install.sh
cd "$INIT_PATH"

rm -rfv "$INIT_PATH/Inoue Takina/"
rm -rfv "$INIT_PATH/dots-hyprland/"

yay -Syu paru
