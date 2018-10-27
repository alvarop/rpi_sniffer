#!/bin/bash

if [ "$1" == "" ]; then
    echo "ERROR: IP address missing"
    echo "Usage: disable_forwarding.sh <ip address>"
    exit 1
fi

echo "*** Disable ip forwarding ***"
ssh pi@$1 "sudo sysctl -w net.ipv4.ip_forward=0"
