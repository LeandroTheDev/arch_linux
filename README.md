# Leans GEN
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
- If you accept the goodies from device configurations don't forget to use ``mangohud gamemoderun <gamename>`` or in steam launch parameters ``mangohud gamemoderun %command%``, and also don't forget to configure the mangohud using the program ``Goverlay``

## Configurations Only
If you already have a arch linux installation and want only the default system organization from LeansGen, follow this steps:

- Download git: ``sudo pacman -S git``
- Download the LeansGen source: ``git clone --branch leansgen --single-branch https://github.com/LeandroTheDev/arch_linux.git``
- Copy the contents from the source and past to skel: ``sudo cp -r ./arch_linux/Home/* /etc/skel``
- To avoid any problems, re-add the run permission: ``sudo chmod +x /etc/skel/System/Scripts/firstload.sh``
- You can now create your user: ``sudo useradd -m admin`` and ``sudo passwd admin``
- And finally after loging-in into your user, run the system: ``startplasma-wayland``