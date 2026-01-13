#!/usr/bin/env bash

# Get the directory where the script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Check if running as root
if [[ $(id -u) -eq 0 ]]; then
    echo -e "\033[1;31mError: Do not run this script as root. Please use a normal user.\033[0m"
    exit 1
fi

# Exit on error
set -e

echo "Initializing..."

"$SCRIPT_DIR/scripts/set-env.sh"
"$SCRIPT_DIR/scripts/install.sh"
"$SCRIPT_DIR/scripts/config.sh"
"$SCRIPT_DIR/scripts/start-service.sh"

if ! sudo snapper -c root get-config &>/dev/null; then
    sudo snapper -c root create-config /
fi

paru -Syu --asdeps inotify-tools
sudo systemctl enable --now grub-btrfsd

echo "Done"
echo "Please restart your computer"
