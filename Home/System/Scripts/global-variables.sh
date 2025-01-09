#!/bin/sh
username=$(whoami)

export PATH="/home/$username/System/Softwares/Flutter:$PATH"
export CHROME_EXECUTABLE=/usr/bin/chromium