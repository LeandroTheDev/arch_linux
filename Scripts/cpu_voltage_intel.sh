#!/bin/sh
if [ "$(id -u)" -ne 0 ]; then
  echo "Root is required."
  exit 1
fi

while true; do
  E1=$(cat /sys/class/powercap/intel-rapl:0/energy_uj)
  sleep 1
  E2=$(cat /sys/class/powercap/intel-rapl:0/energy_uj)
  printf "CPU Package: %d W\n" $(( (E2-E1)/1000000 ))
done
