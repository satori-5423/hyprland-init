#!/usr/bin/env bash

# Get the directory where the script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# The parent directory of scripts/ is the root of the repo
REPO_ROOT="$(dirname "$SCRIPT_DIR")"

# Exit on error
set -e

# Function to read package list into an array
read_pkgs() {
    local file="$1"
    if [[ -f "$file" ]]; then
        # Read file content, ignoring comments and empty lines
        grep -vE '^\s*#|^\s*$' "$file"
    else
        echo "Warning: Package list file not found: $file" >&2
    fi
}

# Function to ask yes/no questions
ask_yes_no() {
    while true; do
        read -p "$1 [y/N]: " yn
        case $yn in
            [Yy]* ) return 0;;
            [Nn]* | "" ) return 1;;
            * ) echo "Please answer yes or no.";;
        esac
    done
}

# Initialize array
include_pkgs=()

# 1. Base packages (Always install)
echo "Preparing base packages..."
for category in core fonts game; do
    while IFS= read -r pkg; do
        include_pkgs+=("$pkg")
    done < <(read_pkgs "$REPO_ROOT/pkgs/arch/$category")
done

# 2. Optional packages (Interactive)
for category in code qemu apps; do
    if ask_yes_no "Install $category packages?"; then
        echo "Adding $category packages..."
        while IFS= read -r pkg; do
            include_pkgs+=("$pkg")
        done < <(read_pkgs "$REPO_ROOT/pkgs/arch/$category")
    else
        echo "Skipping $category packages."
    fi
done

# 3. CPU Microcode
vendor=$(grep -m1 'vendor_id' /proc/cpuinfo | awk '{print $3}')
case "$vendor" in
    GenuineIntel)
        include_pkgs+=("intel-ucode")
        ;;
    AuthenticAMD)
        include_pkgs+=("amd-ucode")
        ;;
    *)
        echo "Warning: Unknown CPU vendor: $vendor"
        ;;
esac

# 4. GPU Drivers (Improved Detection)
echo "Detecting GPU..."
gpu_info=$(lspci | grep -E "VGA|3D")

if echo "$gpu_info" | grep -q "NVIDIA"; then
    echo "NVIDIA GPU detected, adding nvidia packages..."
    while IFS= read -r pkg; do
        include_pkgs+=("$pkg")
    done < <(read_pkgs "$REPO_ROOT/pkgs/arch/nvidia")
fi

if echo "$gpu_info" | grep -q "AMD"; then
    echo "AMD GPU detected, adding amd packages..."
    while IFS= read -r pkg; do
        include_pkgs+=("$pkg")
    done < <(read_pkgs "$REPO_ROOT/pkgs/arch/amd")
fi

# 5. Install Official Packages
echo "Installing official packages..."
paru -Syu --needed --noconfirm "${include_pkgs[@]}" --assume-installed wine

# 6. Install AUR Packages
if ask_yes_no "Install AUR packages?"; then
    echo "Installing AUR packages..."
    aur_pkgs=()
    while IFS= read -r pkg; do
        aur_pkgs+=("$pkg")
    done < <(read_pkgs "$REPO_ROOT/pkgs/aur")

    if [[ ${#aur_pkgs[@]} -gt 0 ]]; then
        paru -Syu --needed --noconfirm "${aur_pkgs[@]}"
    fi
else
    echo "Skipping AUR packages."
fi
