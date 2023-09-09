#!/bin/bash

# Find a Wireguard interface
interfaces=`find /config/wireguard -type f`
if [ -z $interfaces ]; then
    echo "$(date): Interface not found in /config/wireguard" >&2
    exit 1
fi

start_interfaces() {
    for interface in $interfaces; do
        echo "$(date): Starting Wireguard $interface"
        wg-quick up $interface
    done
}

finish() {
    for interface in $interfaces; do
        wg-quick down $interface
    done

    exit 0
}

start_interfaces

while IFS= read -r line
do

  hostPort=(${line//:/ })
  if [ "${#hostPort}" -ne 2 ]; then
    echo "Hosts in /config/forwards must be in host:port format (only forwards tcp as well)" 
  fi

  socat TCP-LISTEN:${hostPort[1]},fork,reuseaddr TCP:${hostPort[0]}:${hostPort[1]} &
done < "/config/forwards"

trap finish TERM INT QUIT
while true; do
    sleep 1
done