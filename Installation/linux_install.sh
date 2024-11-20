if ! mount | grep -q 'on /mnt '; then
    echo "There is no partition mounted in /mnt, you need to mount your system before executing the script, if you are trying execute this script manually without the installer script is because you missed something after the disk signatures, refer the disk_creation.sh in the github installation folder"
    exit 1
fi

# Installation Confirmation
echo "Install linux in the mounted device /mnt?"
read -p "Do you want to proceed? (Y/n): " response
response=$(echo "$response" | tr '[:upper:]' '[:lower:]')
if [[ "$response" == "n" || "$response" == "no" || -z "$response" ]]; then
    echo "Aborted"
    exit 1
fi

# Installation Process
pacman -Sy archlinux-keyring --noconfirm
PACMAN_OPTS="--noconfirm" pacstrap /mnt base-devel base linux linux-firmware vim
genfstab -U /mnt >> /mnt/etc/fstab
arch-chroot /mnt
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
read -p "Device name: " deviceName
echo "$deviceName" | sudo tee /etc/hostname > /dev/null
echo -e "127.0.0.1      localhost\n::1      localhost\n127.0.1.1        $deviceName.localdomain $deviceName" | sudo tee -a /etc/hosts > /dev/null
echo "Type the root password:"
passwd
read -p "Administrator username" username
useradd -m $username
passwd $username
usermod -aG wheel $username