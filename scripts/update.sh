#!/usr/bin/env bash

# Disable snap-pac
sudo mkdir -p /etc/pacman.d/hooks/
sudo ln -sf /dev/null /etc/pacman.d/hooks/05-snap-pac-pre.hook
sudo ln -sf /dev/null /etc/pacman.d/hooks/zz-snap-pac-post.hook

cd "$XDG_PROJECTS_DIR/GitHub/dots-hyprland"
./setup install || true

# Enable snap-pac
sudo rm -f /etc/pacman.d/hooks/05-snap-pac-pre.hook
sudo rm -f /etc/pacman.d/hooks/zz-snap-pac-post.hook
