#!/bin/bash

# Temporary directory for cloning packages
TMP_DIR="/tmp/aur-update"
mkdir -p "$TMP_DIR"

echo "Getting outdated AUR packages..."
# Get only outdated packages
outdated_packages=$(auracle outdated | awk '{print $1}')

# Exit if all packages are up-to-date
if [ -z "$outdated_packages" ]; then
    echo "All packages are updated!"
    exit 0
fi

echo "Packages to update: $outdated_packages"

# Loop to update each package
for pkg in $outdated_packages; do
    echo "Updating $pkg..."
    cd "$TMP_DIR" || exit 1

    # Clone the package from AUR
    auracle clone "$pkg"

    # Enter the cloned folder
    cd "$pkg" || { echo "Error: cannot enter the folder $pkg"; continue; }

    # Build and install the package
    makepkg -si --noconfirm

    # Return to the temporary directory
    cd "$TMP_DIR" || exit 1
done

echo "Update complete!"
