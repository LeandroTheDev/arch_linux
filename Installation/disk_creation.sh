#!/bin/bash

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
g   # Create a new empty gpt partition
n   # Create a new partition


+300M # Partition size
t     # Changing the partition type
1     # EFI type
n     # Creating a new partition (Linux with the remaining size)



w
EOF
# Checking if the fdisk exit sucessfully
if [ $? -eq 0 ]; then
    echo "Success executing the disk partitioning"
else
    echo "Something went wrong..."
fi