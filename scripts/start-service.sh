#!/usr/bin/env bash

# Get the directory where the script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# The parent directory of scripts/ is the root of the repo
REPO_ROOT="$(dirname "$SCRIPT_DIR")"

# Exit on error
set -e

echo "Configuring services..."

# NetworkManager
if command -v NetworkManager &> /dev/null; then
    echo "Enabling NetworkManager..."
    sudo systemctl enable --now NetworkManager.service
fi

# Bluetooth
if command -v bluetoothd &> /dev/null; then
    echo "Enabling Bluetooth..."
    sudo systemctl enable --now bluetooth.service
fi

# Libvirt / QEMU
if command -v libvirtd &> /dev/null; then
    echo "Configuring Libvirt..."
    sudo systemctl enable --now libvirtd.service
    sudo systemctl enable --now virtlogd.service
    
    # Add user to groups if they exist
    for group in libvirt kvm input; do
        if getent group "$group" > /dev/null; then
            sudo usermod -aG "$group" "$USER"
        fi
    done
    
    # Configure default network
    if sudo virsh net-list --all | grep -q "default"; then
        sudo virsh net-autostart default
        # Start network if not already active
        if ! sudo virsh net-list --active | grep -q "default"; then
             sudo virsh net-start default || echo "Warning: Failed to start default network, it might be already running or configured incorrectly."
        fi
    fi

    paru -Syu --asdeps iptables-nft
fi

# Docker
if command -v docker &> /dev/null; then
    echo "Configuring Docker..."
    sudo systemctl enable --now docker.service
    # Add user to docker group if it exists
    if getent group docker > /dev/null; then
        sudo usermod -aG docker "$USER"
    fi
fi

# Samba
if command -v smbd &> /dev/null; then
    if [ ! -f /etc/samba/smb.conf ]; then
        echo "Downloading default smb.conf..."
        sudo curl -L "https://git.samba.org/samba.git/?p=samba.git;a=blob_plain;f=examples/smb.conf.default;hb=HEAD" -o /etc/samba/smb.conf
    fi
    sudo smbpasswd -a $USER
    sudo systemctl enable --now smb.service nmb.service
fi
