#!/usr/bin/env bash

# Update mode if a dots-hyprland repo already exists
if [[ -d "$XDG_PROJECTS_DIR/GitHub/dots-hyprland/.git" ]]; then
    echo "Updating..."
    "$SCRIPT_DIR/scripts/update.sh"
    "$SCRIPT_DIR/scripts/custom.sh"
    echo "Update done"
    exit 0
fi

if ! sudo snapper -c root get-config &>/dev/null; then
    sudo snapper -c root create-config /
fi

paru -Syu --asdeps inotify-tools
sudo systemctl enable --now grub-btrfsd
