#!/usr/bin/env bash

# Check if running as root
if [[ $(id -u) -eq 0 ]]; then
    echo -e "\033[1;31mError: Do not run this script as root. Please use a normal user.\033[0m"
    exit 1
fi

echo "Initializing..."

./scripts/set-env.sh
./scripts/install.sh
./scripts/config.sh
./scripts/custom.sh

sudo snapper -c root create-config /

echo "Done"
echo "Please restart your computer"
