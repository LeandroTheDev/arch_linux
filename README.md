# Starting

# Connect to the internet
- iwctl
- device list
- station wlan0 scan
> This will show the intenets in your area.
- station wlan0 get-networks
- station wlan0 connect "INTERNET NAME"

> Test internet connectivity
- ping google.com
> Update time date
- timedatectl set-ntp true
- timedatectl status

# Partitions

> Creating the partition
> fdisk -l will show the hard disks connected
> Select the one you want install arch
- fdisk -l

> The "1" is the disk you want to install arch
- fdisk /dev/sd1
> Creating SWAP
- g
- o
- n
- default
- default
- +6G
- t
- 1
- 82
> Creating Linux
- n
- default
- default
- default

> Save
- w

> Active swaps on the partition
- ##mkswap /dev/sda1
- ##swapon /dev/sda1
> Active linux on the partition
- mkfs.ext4 /dev/sda2
- mount /dev/sda2 /mnt

# Installing Arch Linux
- pacman -Sy
- pacman -S archlinux-keyring

> Putting the system in the partition
- pacstrap /mnt base linux linux-firmware vim base-devel
- genfstab -U /mnt >> /mnt/etc/fstab
- arch-chroot /mnt

> Changing timezone
- ln -sf /usr/share/zoneinfo/AMERICA/Sao_Paulo /etc/localtime
- hwclock --systohc

> To use VIM press I to edit, "CTRL O" :wq to save
- vim /etc/locale.gen
- "en_US.UTF-8" -> remove the #

> Install the language
- locale-gen

> Naming the machine
- sudo vim /etc/hostname

> Configuring localhost
- sudo vim /etc/hosts
- 127.0.0.1	  localhost
- ::1         localhost
- 127.0.1.1	  machinename.localdomain	machinename

> Change root password
- passwd
> Create user
- useradd -m username
> Create user password
- passwd username
> Give access to user
- usermod -aG wheel

> Download sudo for admin actions
- pacman -S sudo

> Edit visudo to grant previleges to users
- visudo
> Remove the #
- #%wheel ALL=(ALL) ALL

> Download the detectors of S.O
- pacman -S grub dosfstools os-prober mtools ntfs-3g

> Install the detector
- grub-install /dev/sda

> Edit the Detector
- sudo vim /usr/sbin/update-grub
- #!/bin/sh
- set -e
- exec grub-mkconfig -o /boot/grub/grub.cfg "$@"

> Update settings
- chown root:root /usr/sbin/update-grub
- chmod 755 /usr/sbin/update-grub
- update-grub /dev/sd1

> Install a network manager to use internet
- pacman -S networkmanager
- systemctl enable NetworkManager

> Finishing installing
- exit
- umount /mnt -l
- reboot

# Configuring Arch Linux
> Connect to the internet
- sudo nmcli device wifi connect "INTRNETNAME" password "password"

> Active some Librarys for pacman
- sudo vim /etc/pacman.conf
- #[multilib]
- #Include = /etc/pacman blablablabla
> Remove the #

> Install drivers for monitor and processors
lspci -v | grep -A1 -e VGA -e 3D
sudo pacman -Sy xorg
> Note: this is a driver for intel, if you have other processor you need to find by yourself
sudo pacman -Sy xf86-video-intel mesa lib32-mesa

# Finish Instalation
