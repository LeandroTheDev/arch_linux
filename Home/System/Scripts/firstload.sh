#!/bin/sh
username=$(whoami)

# Enable sound services
systemctl --user enable wireplumber.service pipewire.service pipewire-pulse.service

# Plasma Configurations
sed -i "s/{USERNAME}/$username/g" "/home/$username/.config/kscreenlockerrc"
sed -i "s/{USERNAME}/$username/g" "/home/$username/.config/plasma-org.kde.plasma.desktop-appletsrc"
sed -i "s/{USERNAME}/$username/g" "/home/$username/.config/bluedevil.notifyrc"
sed -i "s/{USERNAME}/$username/g" "/home/$username/.config/ksmserver.notifyrc"

# Places folder creation
ln -s /home/$username/System/Places/ /home/$username/.config/Places
ln -s /home/$username/System/Share/ /home/$username/.local/share/
if command -v ssh > /dev/null 2>&1; then
    ln -s /home/$username/System/SSH/ /home/$username/.ssh/
fi

# This script will auto delete after executing
rm -rf $HOME/System/Scripts/firstload.sh # Deleting the script
sed -i '\#$HOME/System/Scripts/firstload.sh#d' "$HOME/.bashrc" # Removing from .bashrc if exist
