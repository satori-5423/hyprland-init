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

# Initialize array
include_pkgs=()

# Read base packages
for category in core fonts game code qemu apps; do
    while IFS= read -r pkg; do
        include_pkgs+=("$pkg")
    done < <(read_pkgs "$REPO_ROOT/pkgs/arch/$category")
done

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

gpu_vendor=$(lspci | grep -E "VGA|3D" | grep -oE 'AMD|NVIDIA' | head -n1)
case "$gpu_vendor" in
NVIDIA)
    while IFS= read -r pkg; do
        include_pkgs+=("$pkg")
    done < <(read_pkgs "$REPO_ROOT/pkgs/arch/nvidia")
  ;;
AMD)
    while IFS= read -r pkg; do
        include_pkgs+=("$pkg")
    done < <(read_pkgs "$REPO_ROOT/pkgs/arch/amd")
  ;;
*)
  echo "Warning: Unknown or unsupported GPU vendor: $gpu_vendor"
  ;;
esac

echo "Installing official packages..."
paru -Syu --needed --noconfirm "${include_pkgs[@]}"

echo "Installing AUR packages..."
# Read AUR packages
aur_pkgs=()
while IFS= read -r pkg; do
    aur_pkgs+=("$pkg")
done < <(read_pkgs "$REPO_ROOT/pkgs/aur")

if [[ ${#aur_pkgs[@]} -gt 0 ]]; then
    paru -Syu --needed --noconfirm "${aur_pkgs[@]}"
fi
