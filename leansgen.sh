#!/bin/bash
echo "Leans Gen V-0.5"
echo "Welcome to Leans Gen, in the next steps you will install a fresh arch linux in your device, please proceed with caution, this installer requires constant internet connection."
read -p "Press any key to continue"

clear # Clear previously messages
lsblk # Show devices available
# Ask the user to input the disk
echo "Type the disk you want it to install, ex: /dev/sda or /dev/nvme0n1"
read -p "/dev/" disk
disk="/dev/$disk"

# Checking if the user input exist
if [ ! -e "$disk" ]; then
    echo "$disk does not exist"
    exit 1
fi

# Necessary dependencie
pacman -Sy lsof --noconfirm

#  Checking if is mounted somewhere
if mount | grep -q "/dev/$disk"; then
    echo "Disk $disk is currently mounted and in use, try using: umount -R $disk"
    exit 1
# Checking if is currently in use    
elif lsof | grep -q $disk; then
    echo "Disk $disk is being used by some processes."
    exit 1
fi

export INSTALLPARTITION=$disk

# Device partitioning
sh -c "$(curl -sS https://raw.githubusercontent.com/LeandroTheDev/arch_linux/refs/heads/leansgen/Installation/disk_creation.sh)"
if [ $? -ne 0 ]; then
    echo "The disk creation script has failed."
    exit 1
fi

# Installing Linux
sh -c "$(curl -sS https://raw.githubusercontent.com/LeandroTheDev/arch_linux/refs/heads/leansgen/Installation/linux_install.sh)"
if [ $? -ne 0 ]; then
    echo "The Linux installation has failed."
    exit 1
fi

# Configuring device and boot
arch-chroot /mnt bash -c 'export INSTALLPARTITION="$INSTALLPARTITION" && sh -c "$(curl -sS https://raw.githubusercontent.com/LeandroTheDev/arch_linux/refs/heads/leansgen/Installation/device_config.sh)"'
if [ $? -ne 0 ]; then
    echo "The device installation has failed."
    exit 1
fi

clear

umount -R -l /mnt

echo "Device configurations has been a success, the system will reboot now, press any key to reboot GLHF"
read -n 1 -s
reboot