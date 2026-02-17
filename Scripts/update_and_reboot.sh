# This script will update your system remove all cache
# clean journals
# remove previous versions from package
# and finally reboot

#!/bin/sh
updates=$(pacman -Qu | awk '{print $1}')
if [ -z "$updates" ]; then
    echo "No available updates, reboot cancelled"
    exit 0
fi

sudo pacman -Syu --noconfirm
if [ $? -ne 0 ]; then
    echo "Failed to update the system."
    exit 1
fi

sudo pacman -Scc --noconfirm
sudo paccache -ruk0
sudo journalctl --vacuum-size=200M

echo "Update success, rebotting..."
sync
sudo reboot now
