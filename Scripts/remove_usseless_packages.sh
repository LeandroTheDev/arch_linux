#!/bin/bash

# Get all packages that has been instaled without your consense
dependencies_packages=$(pacman -Qdq)

# Swiping all packages
for package in $dependencies_packages; do
    if ! sudo pacman -Rns --noconfirm "$package"; then
        echo "$package. ignoring..."
    fi
done