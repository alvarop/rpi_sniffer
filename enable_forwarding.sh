#!/bin/bash

if [ "$1" == "" ]; then
    echo "ERROR: IP address missing"
    echo "Usage: enable_forwarding.sh <ip address>"
    exit 1
fi

# Add iptables NAT rules
ssh pi@$1 "sudo iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE"

echo "*** Enable ip forwarding ***"
ssh pi@$1 "sudo sysctl -w net.ipv4.ip_forward=1"
