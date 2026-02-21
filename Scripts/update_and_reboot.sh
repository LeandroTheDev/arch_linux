#!/bin/sh

# This script will update your system remove all cache
# clean journals
# remove previous versions from package
# and finally reboot

# Detect package manager
if command -v paru >/dev/null 2>&1; then
    PM="paru"
else
    PM="pacman"
fi

# Check for updates
updates=$($PM -Qu 2>/dev/null | awk '{print $1}')
if [ -z "$updates" ]; then
    echo "No available updates, reboot cancelled"
    exit 0
fi

# Update system
if [ "$PM" = "paru" ]; then
    paru -Syu --noconfirm
else
    sudo pacman -Syu --noconfirm
fi

if [ $? -ne 0 ]; then
    echo "Failed to update the system."
    exit 1
fi

# Cleanup
sudo pacman -Scc --noconfirm
sudo paccache -ruk0
sudo journalctl --vacuum-size=200M

echo "Update success, rebooting..."
sync
sudo reboot now
