#!/bin/bash
echo "Welcome to Leans Gen, in the next steps you will install a fresh arch linux in your device, please proceed with caution"
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

echo "Device configurations has been a success, don't forget to run the fresh_install.sh script after rebooting and loging, the system will reboot now, press any key to reboot"
read -n 1 -s
reboot