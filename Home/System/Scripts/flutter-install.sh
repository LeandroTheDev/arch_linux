#!/bin/sh
username=$(whoami) 

cd /home/$username/System/Softwares

# Downloading flutter
git clone -b main https://github.com/flutter/flutter.git
mv ./flutter ./Flutter

# Deleting the script
rm -rf "/home/$username/System/Scripts/flutter-install.sh"