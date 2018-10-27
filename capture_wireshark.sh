#!/bin/bash

if [ "$1" == "" ]; then
    echo "ERROR: IP address missing"
    echo "Usage: capture_wireshark.sh <ip address>"
    exit 1
fi

# Create fifo
tmpdir=$(mktemp -d /tmp/capture-XXXXX)
mkfifo $tmpdir/capture.fifo

# Launch wireshark with fifo
wireshark -kni $tmpdir/capture.fifo &

# Add iptables NAT rules
ssh pi@$1 "sudo iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE"

echo "*** Enable ip forwarding ***"
ssh pi@$1 "sudo sysctl -w net.ipv4.ip_forward=1"

echo "*** Starting capture. (Ctrl+C to stop) ***"
ssh pi@$1 "sudo tcpdump -n -w - -U -i wlan0 2>/dev/null" > $tmpdir/capture.fifo

echo "*** Disable ip forwarding ***"
ssh pi@$1 "sudo sysctl -w net.ipv4.ip_forward=0"

# Delete pipe and temp dir
rm $tmpdir/capture.fifo
rmdir $tmpdir
