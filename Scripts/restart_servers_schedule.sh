#!/bin/sh
# This script was made to work with systemd, first of all create a systemd script, any good example:
# https://github.com/LeandroTheDev/arch_linux/blob/main/Scripts/systemd/executecommandafterlogin.service
sleep_until_midnight() {
    now=$(date +%s)
    midnight=$(date -d 'tomorrow 00:00' +%s)
    sleep_seconds=$((midnight - now))
    echo "Sleeping $sleep_seconds seconds until midnight..."
    sleep "$sleep_seconds"
}

exec_commands() {
    local commands=("$@") # Commands array
    while true; do
        for cmd in "${commands[@]}"; do
            echo "Restarting: $cmd"
            systemctl restart "$cmd"
            echo "Waiting 5 minutes before next server restart..."
            sleep 300 # 5 minutes
        done
        echo "All commands executed, waiting until next midnight..."
        sleep_until_midnight
    done
}

# systemdname1 -> 12:00
# systemdname2 -> 12:05

commands_to_exec=(
    "systemdname1"
    "systemdname2"
)

echo "Sleeping until the first midnight before starting restarts..."
sleep_until_midnight

while true; do
    exec_commands "${commands_to_exec[@]}"
    sleep_until_midnight
done
