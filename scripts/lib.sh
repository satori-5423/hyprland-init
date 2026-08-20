#!/usr/bin/env bash

# Shared functions for hyprland-init scripts

# Locate the dots-hyprland repo
dots_dir() {
    if [[ -d "$HOME/GitHub/dots-hyprland/.git" ]]; then
        echo "$HOME/GitHub/dots-hyprland"
    else
        echo "$HOME/.cache/hyprland-init/dots-hyprland"
    fi
}

# Detect the EFI partition mount point
detect_efi_dir() {
    local dir fstype
    for dir in /efi /boot /boot/efi; do
        if mountpoint -q "$dir" 2>/dev/null; then
            fstype="$(findmnt -no FSTYPE "$dir" 2>/dev/null)" || true
            if [[ "$fstype" == "vfat" ]]; then
                echo "$dir"
                return 0
            fi
        fi
    done
    return 1
}

# Detect the CPU vendor
detect_cpu_vendor() {
    local vendor
    vendor="$(grep -m1 'vendor_id' /proc/cpuinfo 2>/dev/null | awk '{print $3}')" || true
    case "$vendor" in
        GenuineIntel) echo "intel" ;;
        AuthenticAMD) echo "amd" ;;
        *) echo "unknown" ;;
    esac
}

# Detect GPU vendors, space-separated
detect_gpu() {
    local gpu_info result=""
    gpu_info="$(lspci 2>/dev/null | grep -E "VGA|3D" || true)"
    if echo "$gpu_info" | grep -q "NVIDIA"; then
        result+=" nvidia"
    fi
    if echo "$gpu_info" | grep -q "AMD"; then
        result+=" amd"
    fi
    if echo "$gpu_info" | grep -q "Intel"; then
        result+=" intel"
    fi
    echo "${result# }"
}
