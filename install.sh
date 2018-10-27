#!/bin/bash

if [ "$1" == "" ]; then
    echo "ERROR: IP address missing"
    echo "Usage: install.sh <ip address>"
    exit 1
fi

# Install ssh key so we don't have to use passwords
ssh-copy-id pi@$1

# Update system
echo "*** Making sure system is up to date ***"
ssh pi@$1 "sudo apt-get update"
ssh pi@$1 "sudo apt-get upgrade -y"

# Install required files
echo "*** Installing required files ***"
ssh pi@$1 "sudo apt-get install -y tcpdump dnsmasq hostapd"

# Stop services
echo "*** Stopping services ***"
ssh pi@$1 "sudo systemctl stop hostapd"
ssh pi@$1 "sudo systemctl stop dnsmasq"

# Update wlan0 configuration to use 192.168.20.1
# Only add lines if they are not already present
echo "*** Updating dhcpcd configuration ***"
ssh pi@$1 "grep -q -F 'interface wlan0' /etc/dhcpcd.conf || echo \"
interface wlan0
    static ip_address=192.168.20.1/24
    nohook wpa_supplicant
\" | sudo tee --append /etc/dhcpcd.conf > /dev/null"

# Update wlan0 dnsmasq configuration to use ip addresses range:
# 192.168.20.2-192.168.20.20
# Only add lines if they are not already present
echo "*** Updating dnsmasq configuration ***"
ssh pi@$1 "grep -q -F 'interface=wlan0' /etc/dnsmasq.conf || echo \"
interface=wlan0      # Use the require wireless interface
  dhcp-range=192.168.20.2,192.168.20.20,255.255.255.0,24h
\" | sudo tee --append /etc/dnsmasq.conf > /dev/null"

# Add hostap configuration
# SSID: rpi
# Password: 0123456789
echo "*** Updating hostap configuration ***"
ssh pi@$1 "echo \"
interface=wlan0
ssid=rpi
hw_mode=g
channel=7
wmm_enabled=0
macaddr_acl=0
auth_algs=1
ignore_broadcast_ssid=0
wpa=2
wpa_passphrase=0123456789
wpa_key_mgmt=WPA-PSK
wpa_pairwise=TKIP
rsn_pairwise=CCMP
ctrl_interface=/var/run/hostapd
ctrl_interface_group=0
\" | sudo tee /etc/hostapd/hostapd.conf > /dev/null"

ssh pi@$1 "sudo sed -i -e 's/#DAEMON_CONF=\"\"/DAEMON_CONF=\"\\/etc\\/hostapd\\/hostapd.conf\"/' /etc/default/hostapd"

# Restart services
echo "*** Re-starting services ***"
ssh pi@$1 "sudo systemctl start hostapd"
ssh pi@$1 "sudo systemctl start dnsmasq"
