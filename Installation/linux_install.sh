#!/bin/bash
clear

if ! mount | grep -q 'on /mnt '; then
    echo "There is no partition mounted in /mnt, you need to mount your system before executing the script, if you are trying execute this script manually without the installer script is because you missed something after the disk signatures, refer the disk_creation.sh in the github installation folder"
    exit 1
fi

# Installation Confirmation
echo "Install linux in the mounted device /mnt?"
read -p "Do you want to proceed? (Y/n): " response
response=$(echo "$response" | tr '[:upper:]' '[:lower:]')
if [[ "$response" == "n" || "$response" == "no" ]]; then
    echo "Aborted"
    exit 1
fi

# Installation Process
PACMAN_OPTS="--noconfirm" pacstrap /mnt base-devel base linux linux-firmware vim
# Generating fstab for the Linux System
genfstab -U /mnt >> /mnt/etc/fstab