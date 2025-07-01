#!/bin/sh
echo "Installing Gooddies..."
username=$(whoami)
cd "/home/$username"

mkdir Temp
cd Temp
git clone https://aur.archlinux.org/auracle-git.git
cd auracle-git
makepkg -sic --noconfirm

clear 
cd ..

# Template
# auracle clone package
# cd package
# makepkg -sic --noconfirm

# Deleting temporary folder
rm -rf "/home/$username/Temp"

# Deleting the script
rm -rf "/home/$username/System/Scripts/goodies.sh"

clear