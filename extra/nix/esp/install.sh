#!/usr/bin/env bash
set -euo pipefail

esp=${ESP:-/efi}
mihomo_config=""

die() {
  echo "install.sh: $*" >&2
  exit 1
}

usage() {
  cat <<'EOF'
usage: ./install.sh [OPTIONS]

  --mihomo-config PATH   bake a mihomo/clash YAML config into the image
  -h, --help             show this help

ESP=/mnt/esp ./install.sh   deploy to another mount point
EOF
}

while [ $# -gt 0 ]; do
  case "$1" in
    --mihomo-config)
      [ $# -ge 2 ] || die "--mihomo-config needs a path"
      mihomo_config=$2
      shift 2
      ;;
    -h | --help)
      usage
      exit 0
      ;;
    *) die "unknown option: $1 (try --help)" ;;
  esac
done

cd "$(dirname "$0")"

if [ -n "$mihomo_config" ]; then
  [ -r "$mihomo_config" ] || die "cannot read $mihomo_config"
  EPHEMERAL_MIHOMO_CONFIG=$(realpath "$mihomo_config")
  export EPHEMERAL_MIHOMO_CONFIG
fi

build_args=(--no-link --print-out-paths)
if [ -n "$mihomo_config" ]; then
  build_args+=(--impure)
fi

out=$(nix build "${build_args[@]}" .)
name=$(<"$out/prefix")

sudo mkdir -p "$esp/$name"
sudo cp "$out"/vmlinuz "$out"/initrd "$esp/$name/"
sudo install -Dm644 "$out"/grub.cfg /boot/grub/custom.cfg

echo "deployed to $esp/$name, menu entry added to /boot/grub/custom.cfg"
