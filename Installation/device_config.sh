if [ -z "$BOOTPARTITION" ]; then
    echo "BOOTPARTITION is not defined, define it with: export BOOTPARTITION=/dev/sd?, and execute device_config.sh again"
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
read -p "Administrator username" username
useradd -m $username
passwd $username
usermod -aG wheel $username
sudo sed -i 's/^# %wheel ALL=(ALL:ALL) NOPASSWD: ALL/%wheel ALL=(ALL:ALL) NOPASSWD: ALL/' /etc/sudoers
pacman -S btrfs-progs grub grub-btrfs efibootmgr dosfstools os-prober mtools ntfs-3g snapper --noconfirm
mkdir /boot/EFI
mount $BOOTPARTITION /boot/EFI
grub-install --target=x86_64-efi --bootloader-id=grub_uefi --recheck
grub-mkconfig -o /boot/grub/grub.cfg

echo "Everthing finished"