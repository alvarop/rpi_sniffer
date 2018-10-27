# RPi WiFi Sniffer

## Introduction
This project was created to analyze the network traffic of WiFi IoT devices. It uses a Raspberry Pi 3B as a WiFi access point that devices connect to and captures all traffic flowing through the wireless interface.

Instead of having to install a bunch of software and run lots of commands, this only assumes that you have a newly flashed Raspberry Pi connected over ethernet to your local network. An installation script is run on your local machine and uses ssh to connect to the Pi and install all required software.

A separate script can then be used to send all the network traffic from the Pi's WiFi interface to the local host for analysis. This can be both using Wireshark to live-view the incoming packets or just saving a pcap file for later analisys.

## Requirements
### Hardware
* Raspberry Pi 3B (This will not work on the 3B+ without modifications)
* SD Card
* Ethernet cable
* Micro USB Power adapter or Micro USB Cable and USB Hub

### Sofware (on local machine)
* bash
* ssh
* Wireshark (Optional)

## Setup

### Flashing SD Card
1. Download [Raspbian Stretch Lite](https://www.raspberrypi.org/downloads/raspbian/)
1. Install the OS image to the SD card.
  * The [Raspberry Pi Instructions](https://www.raspberrypi.org/documentation/installation/installing-images/README.md) recommend using [Etcher.io](https://etcher.io)
1. After flashing, create an empty file named **ssh** in the boot/ directory.
  * For example, in linux/MacOS run `touch ssh` while in the boot directory.

### Powering up
1. Connect RPi 3B to your router via ethernet (you can also connect directly to your host machine and do internet sharing, but I'll leave that as an exercise to the reader.)
1. Insert SD card and power up!
1. Connect USB power cable to power supply/hub and to the Pi

### Finding IP Address
If you have access to your router's admin panel, you can find out the newly assigned IP address for the Pi.

If not, you can use nmap to scan your local network and see who has port 22 open. `nmap -p 22 --open 192.168.1.0/24`

### Run configuration script
You should only have to do this once

1. Run `./install.sh <ip address>`
1. You'll likely have to type `yes` to accept the new host key
1. You'll have to enter the raspberry pi's password once here, it's "raspberry"
1. The rest of the installation/configuration might take a few min

***NOTE: If you get a "WARNING: REMOTE HOST IDENTIFICATION HAS CHANGED!", you'll have to go into your `~/.ssh/known_hosts` and remove the old signature***

### Default configuration
The default configuration is:
**SSID: rpi**
**Password: 0123456789**

To change these values, you'll have to edit **install.sh**

### Important Note

IP Forwarding is **DISABLED** by default, which means any device connecting to the rpi AP will not have access to the internet. Both of the **capture_** scripts enable ip forwarding before starting and disable it after finishing.

If you want to enable/disable forwarding without using the **capture_** scripts, use `enable_forwarding.sh <ip address>` and `disable_forwarding.sh <ip address>` instead.

## Usage

### Live Capture with Wireshark
1. Make sure wireshark is installed
1. Run `capture_wireshark.sh <ip address>`
1. Press ctrl+c when finished

### Pcap Capture
If you just want to save a pcap file for processing later, use the `capture_pcap.sh` script.

1. Run `capture_pcap.sh <ip address> <filename>`
1. Press ctrl+c when finished
1. Use pcap file!
