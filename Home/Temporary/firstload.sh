#!/bin/sh
username=$(whoami)

# Enable sound services
systemctl --user enable wireplumber.service pipewire.service pipewire-pulse.service

# Plasma Configurations
sed -i "s/{USERNAME}/$username/g" "/home/$username/.config/plasma-org.kde.plasma.desktop-appletsrc"
sed -i "s/{USERNAME}/$username/g" "/home/$username/.config/bluedevil.notifyrc"
sed -i "s/{USERNAME}/$username/g" "/home/$username/.config/kscreenlockerrc"

# Places folder creation
ln -s /home/$username/.config /home/$username/System/Places/Config
ln -s /home/$username/.local/share /home/$username/System/Places/Share
if command -v ssh > /dev/null 2>&1; then
    ln -s /home/$username/.ssh/ /home/$username/System/SSH
fi
if command -v steam > /dev/null 2>&1; then
    mkdir -p /home/$username/.steam/
    ln -s /home/$username/.steam/ /home/$username/System/Places/Steam
fi

# This script will auto delete after executing
rm -rf $HOME/Temporaryfirstload.sh # Deleting the script
sed -i '\#$HOME/Temporaryfirstload.sh#d' "$HOME/.bashrc" # Removing from .bashrc if exist

# Remove temporary folder
rm -rf /home/$username/Temporary