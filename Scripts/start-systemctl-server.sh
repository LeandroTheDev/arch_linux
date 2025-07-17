#!/bin/sh

# Alert shutdown on the server tmux on specified date (optional)
daily_alert_loop() {
    while true; do
        now=$(date +%s)
        target=$(date -d "00:00" +%s)

        if [ "$now" -ge "$target" ]; then
            target=$(date -d "tomorrow 00:00" +%s)
        fi

        sleep_seconds=$((target - now))
        sleep "$sleep_seconds"        
        
        tmux send-keys -t servername1 'say Server restarting in 1 minute' C-m
	tmux send-keys -t servername2 'say Server restarting in 1 minute' C-m
    done
}
daily_alert_loop &

# Running a http server (optional) (trickle is used to limit the web server 1mb per second (
to protect the integrity of the main server)
tmux new-session -d -s httpservername1 "bash -c 'cd /home/user/website && trickle -s -d 1024 -u 1024 python3 -m http.server 27000

# Running servers in tmux to execute commands inside and view logs
tmux new-session -d -s servername1 "bash -c './start-server1.sh'"
tmux new-session -d -s servername2 "bash -c './start-server2.sh'"

# This is necessary only if you have a dns server and your public address is rotative

sleep 3600

public_ip=""

while true
do
	current_ip="$(curl -s ipinfo.io/ip)"
	if [ "$public_ip" != "$current_ip" ]; then
		public_ip=$current_ip
		# This is the link example for duckdns, change for your dns provider
		curl -k "https://www.duckdns.org/update?domains=myserver&token=123&ip=$public_ip"
	fi
	sleep 3600
done
