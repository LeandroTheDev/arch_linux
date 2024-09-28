### Totally Necessary in the bobo OS
- steam-native-runtime
- kwrite
- htop
- code
- ark
- zip
- unzip
- p7zip
- unrar

Command: ``sudo pacman -S kwrite htop steam-native-runtime code ark zip unzip p7zip unrar``

### Games
- mangohud
- gamemode
- goverlay
- bluez
- bluez-utils

Command: ``sudo pacman -S mangohud gamemode goverlay bluez bluez-utils && sudo systemctl enable bluetooth``

### Operation System
- plasma-desktop
- konsole
- dolphin
- kscreen
- plasma-pa
- kde-gtk-config
- pipewire
- pipewire-jack
- pipewire-pulse
- pipewire-alsa
- lib32-pipewire-jack
- wireplumber
- breeze-gtk
- bluedevil
- plasma-nm
- earlyoom
- flameshot

Command: ``sudo pacman -S plasma-desktop konsole dolphin kscreen plasma-pa kde-gtk-config pipewire pipewire-jack pipewire-pulse pipewire-alsa lib32-pipewire-jack wireplumber breeze-gtk bluedevil plasma-nm earlyoom flameshot && systemctl --user enable wireplumber.service pipewire.service pipewire-pulse.service``
