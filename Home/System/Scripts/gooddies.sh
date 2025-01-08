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

clear 
cd ..

auracle clone arrpc
cd arrpc
makepkg -sic --noconfirm

clear 
cd ..

auracle clone xpadneo-dkms-git
cd xpadneo-dkms-git
makepkg -sic --noconfirm

# Deleting temporary folder
rm -rf "/home/$username/Temp"

# Deleting the script
rm -rf "/home/$username/System/Scripts/goodies.sh"

clear