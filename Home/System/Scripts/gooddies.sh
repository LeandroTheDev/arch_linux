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

auracle clone vesktop-bin
cd vesktop-bin
makepkg -sic --noconfirm

# Deleting temporary folder
rm -rf "/home/$username/Temp"

clear