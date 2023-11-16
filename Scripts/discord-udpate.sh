#!/bin/sh

# Pickup user name
user=$USER

# Discord path
path="/home/$user/Downloads/"

# Find the discord .tar
discord_tar=$(find "$path" -maxdepth 1 -type f -name "Discord-*" -print -quit)

# Verify Null
if [ -n "$discord_tar" ]; then
    echo "OK Finded"
else
    echo "No discord update found in: $path"
fi

