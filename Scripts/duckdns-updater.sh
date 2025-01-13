#!/bin/bash
public_ip=""

while true
do
    # Getting the public address
    current_ip="$(curl -s ipinfo.io/ip)"

    # Check if changed
    if [ "$public_ip" != "$current_ip" ]; then
        # Update the address variable
        public_ip=$current_ip

        # Update the dns
        curl -k "https://www.duckdns.org/update?domains=yourfirstdomain&token=yourtoken&ip=$public_ip"
        curl -k "https://www.duckdns.org/update?domains=yourseconddomain&token=yourtoken&ip=$public_ip"
    fi

    # Wait
    sleep 1h
done
