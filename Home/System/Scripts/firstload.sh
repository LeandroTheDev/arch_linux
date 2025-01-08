#!/bin/sh

# Enable sound services
systemctl --user enable wireplumber.service pipewire.service pipewire-pulse.service

# Plasma Configurations
sed -i "s/{USERNAME}/$username/g" "/home/$username/.config/kscreenlockerrc"
sed -i "s/{USERNAME}/$username/g" "/home/$username/.config/plasma-org.kde.plasma.desktop-appletsrc"

# This script will auto delete after executing
rm -rf $HOME/System/Scripts/firstload.sh # Deleting the script
sed -i '\#$HOME/System/Scripts/firstload.sh#d' "$HOME/.bashrc" # Removing from .bashrc if exist
