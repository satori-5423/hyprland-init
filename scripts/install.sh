#!/usr/bin/env bash

include_pkgs=$(cat ./pkgs/arch/{apps,code,core,fonts,game})

vendor=$(grep -m1 'vendor_id' /proc/cpuinfo | awk '{print $3}')
case "$vendor" in
GenuineIntel)
  include_pkgs+=" intel-ucode"
  ;;
AuthenticAMD)
  include_pkgs+=" amd-ucode"
  ;;
*)
  echo "Warning: Unknown CPU vendor: $vendor"
  ;;
esac

gpu_vendor=$(lspci | grep -E "VGA|3D" | grep -oE 'AMD|NVIDIA' | head -n1)
case "$gpu_vendor" in
NVIDIA)
  include_pkgs+=" $(<./pkgs/arch/nvidia)"
  ;;
AMD)
  include_pkgs+=" $(<./pkgs/arch/amd)"
  ;;
*)
  echo "Warning: Unknown or unsupported GPU vendor: $gpu_vendor"
  ;;
esac

paru -Syu --needed --noconfirm $include_pkgs
paru -Syu --needed $(<./pkgs/aur)
