#!/bin/sh
if [ "$(id -u)" -ne 0 ]; then
    echo "Cannot run discord updater without root previlegies."
    exit 1
fi
# Pickup user name
user=$USER

# User path
path="/home/$user"

# Finding the location of discord update file
discord_tar=$(find "$path" -maxdepth 1 -type f -name "Discord-*.tar.gz" -print -quit)

# Here we are verifying if the system founded the file
if [ -z "$discord_tar" ]; then
    echo "Cannot find the discord update file in user home"
fi

# Discord updater path
discord_dir=$(dirname "$discord_tar")

cd "$discord_dir" || exit

# Discord updater file name
discord_file=$(basename "$discord_tar")
# Uncompress
tar -xvf "$discord_file"

# Updating the discord with uncompressed updater
cp -r Discord/* /opt/discord/

# Giving read and write permission to the discord
chmod +rwx /opt/discord/discord.desktop

# This is necessary for device reboots
ln -s /opt/discord/ /usr/share/
