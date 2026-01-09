#!/usr/bin/env bash

# Set up a temporary directory for build operations
WORK_DIR=$(mktemp -d)
# Get the absolute path of the script directory to find local assets (mirrors)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Ensure clean up on exit
trap 'rm -rf "$WORK_DIR"' EXIT

echo "Working in temporary directory: $WORK_DIR"
cd "$WORK_DIR" || exit 1

# Download CachyOS repo tarball
if ! curl -L https://mirror.cachyos.org/cachyos-repo.tar.xz -o cachyos-repo.tar.xz; then
    echo "Failed to download cachyos-repo.tar.xz"
    exit 1
fi

# Extract
tar -xvf cachyos-repo.tar.xz
cd cachyos-repo || exit 1

# Run the repo script
sudo ./cachyos-repo.sh

# Move mirrorlists
echo "Installing mirrorlists from $SCRIPT_DIR/mirrors..."
sudo cp --verbose "$SCRIPT_DIR/mirrors/cachyos-mirrorlist" /etc/pacman.d/cachyos-mirrorlist
sudo cp --verbose "$SCRIPT_DIR/mirrors/cachyos-v3-mirrorlist" /etc/pacman.d/cachyos-v3-mirrorlist
sudo cp --verbose "$SCRIPT_DIR/mirrors/cachyos-v4-mirrorlist" /etc/pacman.d/cachyos-v4-mirrorlist

# Install packages
echo "Installing kernel and tools..."
sudo pacman -Syyu --noconfirm linux-cachyos linux-cachyos-headers cachyos-settings ananicy-cpp cachyos-ananicy-rules
sudo systemctl enable --now ananicy-cpp

# GRUB_TOP_LEVEL="/boot/vmlinuz-linux-cachyos"
# sudo grub-mkconfig -o /boot/grub/grub.cfg
