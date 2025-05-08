#!/bin/sh
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
            echo "Executing: $cmd"
            bash -c "$cmd"
            echo "Waiting 5 minutes before next server restart..."
            sleep 300 # 5 minutes
        done
        echo "All commands executed, waiting until next midnight..."
        sleep_until_midnight
    done
}

commands_to_exec=(
    "path/to/restart/script"
    "path/to/restart/script2"
)

echo "Sleeping until the first midnight before starting restarts..."
sleep_until_midnight
exec_commands "${commands_to_exec[@]}"