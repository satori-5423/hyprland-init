#!/usr/bin/env bash

INIT_PATH=$(pwd)
CACHE_PATH=~/.cache/hyprland-init

mkdir -p "$CACHE_PATH"

sudo cp -v "$INIT_PATH/files/pacman/mirrorlist" /etc/pacman.d/mirrorlist
sudo cp -v "$INIT_PATH/files/pacman/pacman.conf" /etc/pacman.conf
sudo pacman -Syyuu --noconfirm

if [[ -d "$CACHE_PATH/dots-hyprland/.git/" ]]; then
  cd "$CACHE_PATH/dots-hyprland/"
  git pull
else
  git clone https://github.com/end-4/dots-hyprland.git "$CACHE_PATH/dots-hyprland/"
fi
cd "$CACHE_PATH/dots-hyprland/" && chmod +x ./setup && ./setup install

if [[ -d "$CACHE_PATH/Inoue Takina/" ]]; then
  rm -rf "$CACHE_PATH/Inoue Takina/"
fi
tar -xzvf "$INIT_PATH/files/grub/Inoue-Takina.tar.gz" --directory "$CACHE_PATH"
cd "$CACHE_PATH/Inoue Takina/" && chmod +x ./install.sh && sudo ./install.sh

cd "$INIT_PATH"
yay -Syu --needed --noconfirm paru
