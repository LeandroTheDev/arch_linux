#!/bin/sh

systemctl --user enable wireplumber.service pipewire.service pipewire-pulse.service

# This script will auto delete after executing
rm -rf $HOME/System/Scripts/firstload.sh # Deleting the script
sed -i '\#$HOME/System/Scripts/firstload.sh#d' "$HOME/.bashrc" # Removing from .bashrc if exist
