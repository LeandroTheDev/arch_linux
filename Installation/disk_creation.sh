#!/bin/bash
if [ -z "$INSTALLPARTITION" ]; then
    echo "You need to set the INSTALLPARTITION variable, try: export INSTALLPARTITION=/dev/sd? before running this script"
    exit 1
fi


# Installation Confirmation
clear
echo "Are you sure you want to install in "$INSTALLPARTITION" all contents inside this drive will be deleted"
read -p "Do you want to proceed? (y/N): " response
response=$(echo "$response" | tr '[:upper:]' '[:lower:]')
if [[ "$response" != "y" && "$response" != "yes" ]]; then
    echo "Aborted"
    exit 1
fi



# Erase data before using fdisk to prevent unwanted messages
echo "Erasing data..."
wipefs -a -f "$INSTALLPARTITION"



# Disk formatting
fdisk "$INSTALLPARTITION" <<EOF
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
output=$(lsblk -o NAME,SIZE,TYPE,FSTYPE,MOUNTPOINT "$INSTALLPARTITION" | grep -E "part")
partition_count=$(echo "$output" | wc -l)
# Checking partition count
if [[ $partition_count -ne 2 ]]; then
    echo "Something went wrong, the device has not been correctly partitioned"
    exit 1
fi




echo "Creating signatures..."

# Disk signatures
if [[ $INSTALLPARTITION == /dev/nvme* ]]; then
    mkfs.fat -F32 "${INSTALLPARTITION}p1"
    mkfs.btrfs "${INSTALLPARTITION}p2"
    mount "${INSTALLPARTITION}p2" /mnt
elif [[ $INSTALLPARTITION == /dev/sd* ]]; then
    mkfs.fat -F32 "${INSTALLPARTITION}1"
    mkfs.btrfs "${INSTALLPARTITION}2"
    mount "${INSTALLPARTITION}2" /mnt
else
    echo "Cannot proceed the signature the device is unkown, only supports nvme and sata/ssd disk"
    exit 1
fi

# Mounting the btrfs volumes
btrfs subvolume create /mnt/@
btrfs subvolume create /mnt/@home
umount /mnt

# Compression
if [[ $INSTALLPARTITION == /dev/nvme* ]]; then
    mount -o compress=zstd,subvol=@ "${INSTALLPARTITION}p2" /mnt
    mkdir -p /mnt/home
    mount -o compress=zstd,subvol=@home "${INSTALLPARTITION}p2" /mnt/home
elif [[ $INSTALLPARTITION == /dev/sd* ]]; then
    mount -o compress=zstd,subvol=@ "${INSTALLPARTITION}2" /mnt
    mkdir -p /mnt/home
    mount -o compress=zstd,subvol=@home "${INSTALLPARTITION}2" /mnt/home
else
    echo "Cannot proceed the signature the device is unkown, only supports nvme and sata/ssd disk"
    exit 1
fi

echo "Disk setup is complete, mounted the btrfs in /mnt"