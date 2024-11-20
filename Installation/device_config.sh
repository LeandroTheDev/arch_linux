#!/bin/bash
if [ -z "$INSTALLPARTITION" ]; then
    echo "INSTALLPARTITION is not defined, define it with: export INSTALLPARTITION=/dev/sd?, and execute device_config.sh again"
    exit 1
fi

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
echo "$deviceName" | tee /etc/hostname > /dev/null
echo -e "127.0.0.1      localhost\n::1      localhost\n127.0.1.1        $deviceName.localdomain $deviceName" | tee -a /etc/hosts > /dev/null
echo "Type the root password:"
passwd
read -p "Administrator username: " username
useradd -m $username
passwd $username
usermod -aG wheel $username
sed -i 's/^# %wheel ALL=(ALL:ALL) NOPASSWD: ALL/%wheel ALL=(ALL:ALL) NOPASSWD: ALL/' /etc/sudoers

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

grub-install --target=x86_64-efi --bootloader-id=grub_uefi --recheck
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
sed -i 's/^#Include = \/etc\/pacman.d\/mirrorlist/Include = \/etc\/pacman.d\/mirrorlist/' /etc/pacman.conf

# Installing the OS
pacman -S plasma-desktop konsole dolphin kscreen kde-gtk-config pipewire pipewire-jack pipewire-pulse pipewire-alsa wireplumber plasma-pa breeze-gtk bluedevil plasma-nm plasma-vault
systemctl --user enable wireplumber.service pipewire.service pipewire-pulse.service --root=/home/$username
echo -e '\n# Start kde when logging in tty1\nif [[ $(tty) == /dev/tty1 ]]; then\n    startplasma-wayland\nfi' >> /home/$username/.bashrc

# git clone home to here
# /etc/skel/

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
snapper create-config /
snapper -c root create -d "Fresh Install"
update-grub

umount -R /mnt