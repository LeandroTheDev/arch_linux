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
echo "$deviceName" | sudo tee /etc/hostname > /dev/null
echo -e "127.0.0.1      localhost\n::1      localhost\n127.0.1.1        $deviceName.localdomain $deviceName" | sudo tee -a /etc/hosts > /dev/null
echo "Type the root password:"
passwd
read -p "Administrator username: " username
useradd -m $username
passwd $username
usermod -aG wheel $username
sudo sed -i 's/^# %wheel ALL=(ALL:ALL) NOPASSWD: ALL/%wheel ALL=(ALL:ALL) NOPASSWD: ALL/' /etc/sudoers

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

sudo tee /usr/sbin/update-grub > /dev/null << 'EOF'
#!/bin/sh
set -e
exec grub-mkconfig -o /boot/grub/grub.cfg "$@"
EOF

chown root:root /usr/sbin/update-grub
chmod 755 /usr/sbin/update-grub

pacman -S networkmanager --noconfirm
systemctl enable NetworkManager
exit umount -R /mnt