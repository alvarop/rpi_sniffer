#!/bin/bash

if [ "$1" == "" ]; then
    echo "ERROR: IP address missing"
    echo "Usage: capture_pcap.sh <ip address> <filename>"
    exit 1
fi

if [ "$2" == "" ]; then
    echo "ERROR: Filename missing"
    echo "Usage: capture_pcap.sh <ip address> <filename>"
    exit 1
fi

# Add iptables NAT rules
ssh pi@$1 "sudo iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE"

echo "*** Enable ip forwarding ***"
ssh pi@$1 "sudo sysctl -w net.ipv4.ip_forward=1"

echo "*** Starting capture. (Ctrl+C to stop) ***"
ssh pi@$1 "sudo tcpdump -n -w - -U -i wlan0 2>/dev/null" > $2

echo "*** Disable ip forwarding ***"
ssh pi@$1 "sudo sysctl -w net.ipv4.ip_forward=0"
