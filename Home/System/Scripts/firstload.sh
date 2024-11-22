#!/bin/sh

systemctl --user enable --now wireplumber.service pipewire.service pipewire-pulse.service

# Lockscreen update
KSRC="$HOME/.config/kscreenlockerrc"
echo -e "[Greeter][Wallpaper][org.kde.image][General]" >> "$KSRC"
echo "Image=$HOME/System/Pictures/lockscreen.jpg" >> "$KSRC"
echo "PreviewImage=$HOME/System/Pictures/lockscreen.jpg" >> "$KSRC"

# Desktop update
PLASMA_SRC="$HOME/.config/plasma-org.kde.plasma.desktop-appletsrc"
echo -e "\n[Containments][1][Wallpaper][org.kde.image][General]" >> "$PLASMA_SRC"
echo "Image=$HOME/System/Pictures/desktop.png" >> "$PLASMA_SRC"

# Panel Colorizer Component Installation
FILE="$HOME/.local/share/knewstuff3/plasmoids.knsregistry"
NEW_LINE="<installedfile>/home/guest/.local/share/plasma/plasmoids/luisbocanegra.panel.colorizer/</installedfile>"
if grep -q "<downloads>14749</downloads>" "$FILE"; then
    sed -i "/<downloads>14749<\/downloads>/a $NEW_LINE" "$FILE"
fi

# This script will auto delete it after the first start in kde
rm -rf $HOME/System/Scripts/firstload.sh