#!/bin/bash
clear # Clear previously messages
lsblk # Show devices available
# Ask the user to input the disk
echo "Type the disk you want it to install, ex: /dev/sda or /dev/nvme0n1"
read disk

# Checking if the user input exist
if [ ! -e "$disk" ]; then
    echo "$disk does not exist"
    exit 1
fi




# Installation Confirmation
echo "Are you sure you want to install in "$disk" all contents inside this drive will be deleted"
read -p "Do you want to proceed? (y/N): " response
response=$(echo "$response" | tr '[:upper:]' '[:lower:]')
if [[ "$response" != "y" && "$response" != "yes" ]]; then
    echo "Aborted"
    exit 1
fi



# Erase data before using fdisk to prevent unwanted messages
echo "Erasing data..."
dd if=/dev/zero of="$disk" bs=1M status=progress



# Disk formatting
fdisk "$disk" <<EOF
g
n


+300M
t
1
n



w
EOF
# Checking if the fdisk exit sucessfully
if [ $? -eq 0 ]; then
    echo "Success executing the disk partitioning"
else
    echo "Something went wrong..."
    exit 1
fi

echo "Creating signatures..."

# Disk signatures
if [[ $disk == /dev/nvme* ]]; then
    mkfs.fat -F32 "${disk}p1"
    mkfs.btrfs "${disk}p2"
    mount "${disk}p2" /mnt
elif [[ $disk == /dev/sd* ]]; then
    mkfs.fat -F32 "${disk}1"
    mkfs.btrfs "${disk}2"
    mount "${disk}2" /mnt
else
    echo "Cannot proceed the signature the device is unkown, only supports nvme and sata/ssd disk"
    exit 1
fi

# Mounting the btrfs volumes
btrfs subvolume create /mnt/@
btrfs subvolume create /mnt/@home
umount /mnt

# Compression
if [[ $disk == /dev/nvme* ]]; then
    mount -o compress=zstd,subvol=@ "${disk}p2" /mnt
    mkdir -p /mnt/home
    mount -o compress=zstd,subvol=@home "${disk}p2" /mnt/home
elif [[ $disk == /dev/sd* ]]; then
    mount -o compress=zstd,subvol=@ "${disk}2" /mnt
    mkdir -p /mnt/home
    mount -o compress=zstd,subvol=@home "${disk}2" /mnt/home
else
    echo "Cannot proceed the signature the device is unkown, only supports nvme and sata/ssd disk"
    exit 1
fi

echo "Disk setup is complete, mounted the btrfs in /mnt"