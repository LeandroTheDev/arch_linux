# Start kde when logging in tty1
if [[ $(tty) == /dev/tty1 ]]; then
    startplasma-wayland
fi