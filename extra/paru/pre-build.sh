#!/usr/bin/env bash

if [[ "$PWD" == *"miyu-git"* ]] && [ -f PKGBUILD ]; then
    sed -i 's|SHORiN-KiWATA/Miyu|satori-5423/Miyu|g' PKGBUILD
fi
