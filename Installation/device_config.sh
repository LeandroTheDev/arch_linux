#!/bin/bash
clear
if [ -z "$INSTALLPARTITION" ]; then
    echo "You need to set the INSTALLPARTITION variable, try: export INSTALLPARTITION=/dev/sd? before running this script"
    exit 1
fi

clear

### REGION: Personal OS for LeansGEN
echo "Downloading system template..."
pacman -S git --noconfirm
cd /tmp
git clone --branch leansgen --single-branch https://github.com/LeandroTheDev/arch_linux.git
cp -r /tmp/arch_linux/Home/* /etc/skel
rm -rf /tmp/arch_linux
chmod +x /etc/skel/System/Scripts/firstload.sh
### ENDREGION

clear
hwclock --systohc
while true; do
    echo "System Language"
    echo "1 - English"
    read -p "Select an option: " choice
    
    case $choice in
        1)
            sed -i '/#en_US.UTF-8 UTF-8/s/^#//' /etc/locale.gen
            break
            ;;
        2)
            echo "Not added yet"
            #break
            ;;
        *)
            echo "Invalid option. Please select between the avalaible options"
            ;;
    esac
done
locale-gen

clear

read -p "Device name: " deviceName
echo "$deviceName" | tee /etc/hostname > /dev/null
echo -e "127.0.0.1      localhost\n::1      localhost\n127.0.1.1        $deviceName.localdomain $deviceName" | tee -a /etc/hosts > /dev/null
echo "Type the root password:"
passwd
read -p "Administrator username: " username
useradd -m $username
passwd $username
usermod -aG wheel $username
sed -i 's/^# %wheel ALL=(ALL:ALL) NOPASSWD: ALL/%wheel ALL=(ALL:ALL) NOPASSWD: ALL/' /etc/sudoers

clear

# Installation Confirmation
echo "The bootloader will be installed now in $INSTALLPARTITION"
read -p "Do you want to proceed? (Y/n): " response
response=$(echo "$response" | tr '[:upper:]' '[:lower:]')
if [[ "$response" == "n" || "$response" == "no" ]]; then
    echo "Aborted"
    exit 1
fi

pacman -S btrfs-progs grub grub-btrfs efibootmgr dosfstools os-prober mtools ntfs-3g snapper --noconfirm
mkdir /boot/EFI

# Boot partitino mounting
if [[ $INSTALLPARTITION == /dev/nvme* ]]; then
    mount "${INSTALLPARTITION}p1" /boot/EFI
elif [[ $INSTALLPARTITION == /dev/sd* ]]; then
    mount "${INSTALLPARTITION}1" /boot/EFI
else
    echo "Cannot proceed the boot installation the device is unkown, only supports nvme and sata/ssd disk"
    exit 1
fi

grub-install --target=x86_64-efi --bootloader-id=LeansGen --recheck
grub-mkconfig -o /boot/grub/grub.cfg

tee /usr/sbin/update-grub > /dev/null << 'EOF'
#!/bin/sh
set -e
exec grub-mkconfig -o /boot/grub/grub.cfg "$@"
EOF

chown root:root /usr/sbin/update-grub
chmod 755 /usr/sbin/update-grub

pacman -S networkmanager --noconfirm
systemctl enable NetworkManager

sed -i 's/^#\[\(multilib\)\]/[\1]/' /etc/pacman.conf
sed -i '/^\[multilib\]/ {n; s/^#Include = \/etc\/pacman.d\/mirrorlist/Include = \/etc\/pacman.d\/mirrorlist/}' /etc/pacman.conf

### REGION: Personal OS for LeansGEN
# Installing the OS
pacman -Sy plasma-desktop konsole dolphin kscreen kde-gtk-config pipewire pipewire-jack pipewire-pulse pipewire-alsa wireplumber plasma-pa breeze-gtk bluedevil plasma-nm --noconfirm

# Installing the Wiki
cd /home/$username/Desktop
git clone https://github.com/LeandroTheDev/arch_linux.wiki.git
mv arch_linux.wiki "Leans Gen Wiki"
cd "Leans Gen Wiki"
echo -e "[Desktop Entry]\nIcon=bookmark-add-symbolic" > .directory

clear

# Auto logging in KDE
echo "Do you wish to automatically login $username in TTY1 and automatically open the KDE and lock the session?, if you are a newbie consider choosing N"
read -p "Do you want to accept? (y/N): " response
response=$(echo "$response" | tr '[:upper:]' '[:lower:]')
if [[ "$response" == "y" || "$response" == "yes" ]]; then
    mkdir /etc/systemd/system/getty@tty1.service.d
    cat > "/etc/systemd/system/getty@tty1.service.d/autologin.conf" <<EOF
[Service]
ExecStart=
ExecStart=-/sbin/agetty -o '-p -f -- \\\\u' --noclear --autologin $username %I \$TERM
EOF
    echo -e '\n# Start kde when logging in tty1\nif [[ $(tty) == /dev/tty1 ]]; then\n    startplasma-wayland\nfi' >> /home/$username/.bashrc
    mkdir -p "/home/$username/System/Scripts"
    LOCKSCREEN_SCRIPT="/home/$username/System/Scripts/lockscreen.sh"
    cat > $LOCKSCREEN_SCRIPT <<EOF
#!/bin/sh
loginctl lock-session
EOF
    chmod +x "$LOCKSCREEN_SCRIPT"
    mkdir -p "/home/$username/.config/autostart/"
    LOCKSCREEN_DESKTOP="/home/$username/.config/autostart/lockscreen.sh.desktop"
    cat > $LOCKSCREEN_DESKTOP <<EOF
[Desktop Entry]
Exec=/home/$username/System/Scripts/lockscreen.sh
Icon=application-x-shellscript
Name=lockscreen.sh
Type=Application
X-KDE-AutostartScript=true
EOF
else
    # SDDM Version
    echo "Do you wish to use a login manager instead? (SDDM), if you are a newbie consider choosing Y"
    read -p "Do you want to accept? (Y/n): " response
    response=$(echo "$response" | tr '[:upper:]' '[:lower:]')
    if [[ -z "$response" || "$response" == "y" || "$response" == "yes" ]]; then
        pacman -S sddm --noconfirm
        systemctl enable sddm
    fi
fi
### ENDREGION

clear

# System Drivers
while true; do
    echo "CPU Drivers"
    echo "1 - Intel"
    echo "2 - AMD"
    read -p "Select an option: " choice
    
    case $choice in
        1)
            pacman -S intel-ucode --noconfirm
            break
            ;;
        2)
            pacman -S amd-ucode --noconfirm
            break
            ;;
        *)
            echo "Invalid option. Please select between the avalaible options"
            ;;
    esac
done
while true; do
    echo "Graphics Drivers"
    echo "1 - Intel"
    echo "2 - Nvidia"
    echo "3 - Amd"
    read -p "Select an option: " choice
    
    case $choice in
        1)
            pacman -S vulkan-intel lib32-vulkan-intel linux-headers --noconfirm
            break
            ;;
        2)
            pacman -S nvidia nvidia-utils lib32-nvidia-utils libva-nvidia-driver linux-headers --noconfirm
            break
            ;;
        3)
            pacman -S vulkan-radeon lib32-vulkan-radeon linux-headers --noconfirm
            break
            ;;
        *)
            echo "Invalid option. Please select between the avalaible options"
            ;;
    esac
done

### REGION: Personal OS for LeansGEN
# Leans Applications
echo "Do you want to install LeansGEN recommended programs? (Firefox, Steam, Vesktop (Discord), Gwenview, GIMP, Auracle, Mangohud, Goverlay, Gamemode, Flameshot, Ark and Compress Tools, Plasma System Monitor)"
read -p "Do you want to accept? (Y/n): " response
response=$(echo "$response" | tr '[:upper:]' '[:lower:]')
if [[ -z "$response" || "$response" == "y" || "$response" == "yes" ]]; then
    pacman -S firefox steam-native-runtime kwrite gwenview gimp mangohud goverlay gamemode ark unzip zip unrar p7zip flameshot plasma-systemmonitor --noconfirm
    chmod +x "/home/$username/System/Scripts/gooddies.sh"
    su $username -c "/home/$username/System/Scripts/gooddies.sh"
else
    rm -rf "/home/$username/System/Scripts/goodies.sh"
    rm -rf "/etc/skel/System/Scripts/goodies.sh"
fi

# Leans Development
echo "Do you want to install LeansGEN general development tools? (Flutter, .NET, Rust, VSCode, OpenSSH, Chromium and configure variables?)"
read -p "Do you want to accept? (Y/n): " response
response=$(echo "$response" | tr '[:upper:]' '[:lower:]')
if [[ -z "$response" || "$response" == "y" || "$response" == "yes" ]]; then
    pacman -S vscode dotnet-sdk dotnet-runtime chromium rustup openssh --noconfirm
    su $username -c "rustup default stable" # Rust installation
    su $username -c "/home/$username/System/Scripts/flutter-install.sh" # Flutter installation
    sed -i "/# Variables/a source /home/$username/System/Scripts/global-variables.sh" "/home/$username/.bashrc" # Global Variables
else
    rm -rf "/home/$username/System/Scripts/global-variables.sh"
    rm -rf "/home/$username/System/Scripts/flutter-install.sh"
    rm -rf "/etc/skel/System/Scripts/flutter-install.sh"
fi

# Bluetooth
echo "Install Bluetooth Drivers?"
read -p "Do you want to accept? (Y/n): " response
response=$(echo "$response" | tr '[:upper:]' '[:lower:]')
if [[ -z "$response" || "$response" == "y" || "$response" == "yes" ]]; then
    pacman -S bluez bluez-utils --noconfirm
    systemctl enable bluetooth
    su $username -c "/home/$username/System/Scripts/xbox-bluetooth-drivers.sh"
else
    rm -rf "/home/$username/System/Scripts/xbox-bluetooth-drivers.sh"
    rm -rf "/etc/skel/System/Scripts/xbox-bluetooth-drivers.sh"
fi

# Numlock on boot
cat > /usr/local/bin/numlock <<EOF
#!/bin/bash

for tty in /dev/tty{1..6}
do
    /usr/bin/setleds -D +num < "\$tty"
done
EOF

chmod +x /usr/local/bin/numlock

cat > /etc/systemd/system/numlock.service <<EOF
[Unit]
Description=numlock

[Service]
ExecStart=/usr/local/bin/numlock
StandardInput=tty
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
EOF

systemctl enable numlock
### ENDREGION

echo "Do you wish to auto mount any external device on starting the system?"
read -p "Do you want to accept? (Y/n): " response
response=$(echo "$response" | tr '[:upper:]' '[:lower:]')
if [[ -z "$response" || "$response" == "y" || "$response" == "yes" ]]; then
    chmod +x "/home/$username/System/Scripts/generate-mount.sh"
    su $username -c "/home/$username/System/Scripts/generate-mount.sh"
else
    rm -rf "/home/$username/System/Scripts/generate-mount.sh"
    rm -rf "/etc/skel/System/Scripts/generate-mount.sh"
fi

# Swap memory creation
echo "How much GB do you want for swap memory?"
read swap_size_gb
if [[ ! "$swap_size_gb" =~ ^[0-9]+$ ]] || [ "$swap_size_gb" -le 0 ]; then
    echo "Invalid number for swap memory"
    exit 1
fi
btrfs subvolume create /swap
btrfs filesystem mkswapfile --size ${swap_size_gb}g --uuid clear /swap/swapfile
swapon /swap/swapfile
echo '/swap/swapfile none swap defaults 0 0' | tee -a /etc/fstab

# Snapshot creation
echo "Do you wish to create a snapshot from the base system to recovery later if needed?"
read -p "Do you want to accept? (Y/n): " response
response=$(echo "$response" | tr '[:upper:]' '[:lower:]')
if [[ -z "$response" || "$response" == "y" || "$response" == "yes" ]]; then
    snapper create-config /
    snapper -c root create -d "Fresh Install"
fi

update-grub

exit