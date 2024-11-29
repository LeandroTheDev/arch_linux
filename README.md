# Leans Gen
Ultra simple arch linux installation with KDE

### How to use
- Download the [arch linux iso](https://archlinux.org/download/)
- Create the flash usb my recommendation is using [Ventoy](https://www.ventoy.net/en/download.html)
- After boot in the arch linux use the command ``sh -c "$(curl -sS https://raw.githubusercontent.com/LeandroTheDev/arch_linux/refs/heads/leansgen/leansgen.sh)"``
- > ``sh -c "$(curl -sS -H 'Cache-Control: no-cache' https://raw.githubusercontent.com/LeandroTheDev/arch_linux/refs/heads/leansgen/leansgen.sh)"`` force remove cache

### Tecnical Informations
- This script will create 2 partitions, partition 1: EFI - FAT 32 (300M), partition 2: btrfs (Remaining size)
- Desktop Environment: KDE Plasma 6, desktop version (The cleaneast without Bloatwares)
- Sound driver: Pipewire
- Will generate a system snapshot on installation with the description: Fresh Install
- Boot manager: Grub, id: LeansGen