#!/usr/bin/env bash

# Get the directory where the script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# The parent directory of scripts/ is the root of the repo
REPO_ROOT="$(dirname "$SCRIPT_DIR")"

# Exit on error
set -e

# Disable snap-pac
sudo mkdir -p /etc/pacman.d/hooks/
sudo ln -sf /dev/null /etc/pacman.d/hooks/05-snap-pac-pre.hook
sudo ln -sf /dev/null /etc/pacman.d/hooks/zz-snap-pac-post.hook

# Update and reinstall
if [[ "$USER" = "satori" && -d ~/GitHub/dots-hyprland/ ]]; then
    # For me (satori-5423)
    cd ~/GitHub/dots-hyprland/
else
    # Standard init
    cd ~/.cache/hyprland-init/dots-hyprland/
    git fetch origin --depth=1 && git reset --hard origin/master
fi
./setup install || true

# Enable snap-pac
sudo rm -f /etc/pacman.d/hooks/05-snap-pac-pre.hook
sudo rm -f /etc/pacman.d/hooks/zz-snap-pac-post.hook
