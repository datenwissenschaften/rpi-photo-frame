#!/bin/bash

# Make sure only root can run our script

if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root" 1>&2
  exit 1
fi

# Parameters to environment

if [[ $# -le 1 ]]; then
  echo "This script must be run with configuration" 1>&2
  exit 1
fi

echo "TELEGRAM_TOKEN=$1" >>/etc/environment
echo "PIN=$2" >>/etc/environment

# APT packages

## Clean

apt purge -y wolfram-engine
apt -y purge libreoffice*
apt -y clean
apt -y autoremove
apt update && apt-get -y upgrade

rm -r /home/pi/Desktop
rm -r /home/pi/python_games

## Regenerate SSH keys

rm /etc/ssh/ssh_host_* && sudo dpkg-reconfigure openssh-server

## Install

apt install -y cmake \
  software-properties-common libjpeg-dev zlib1g-dev \
  libcurl4-openssl-dev libssl-dev \
  chromium-browser \
  unclutter \
  git \
  ttf-ancient-fonts \
  libopencv-dev python-opencv python-picamera \
  fbi \
  x11-xserver-utils \
  python3 python3-rpi.gpio python3-pip dnsmasq hostapd python-pip \
  midori matchbox \
  libgles2-mesa plymouth plymouth-themes pix-plym-splash

apt purge plymouth plymouth-themes pix-plym-splash
apt purge nodejs

# Python applications

# pip install thumbor

# Nodejs

# curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -
# apt-get install -y nodejs

# NPM packages

# npm i frontail -g

# config.txt

echo "lcd_rotate=2" >>/boot/config.txt
echo "start_x=0" >>/boot/config.txt
echo "gpu_mem=256" >>/boot/config.txt
echo "disable_splash=1" >>/boot/config.txt

# arm_freq=1350
# core_freq=500
# sdram_freq=500
# over_voltage=4

# Disable the splash screen
# disable_splash=1

# Overclock the SD Card from 50 to 100MHz
# This can only be done with at least a UHS Class 1 card
# dtoverlay=sdtweak,overclock_50=100

# Set the bootloader delay to 0 seconds. The default is 1s if not specified.
# boot_delay=0

# Overclock the raspberry pi. This voids its warranty. Make sure you have a good power supply.
# force_turbo=1

# Disable bluetooth
# dtoverlay=pi3-disable-bt

# TODO: Untested
# echo -n " splash quiet plymouth.ignore-serial-consoles logo.nologo vt.global_cursor_default=0 loglevel=3 disable_splash=1" >> /boot/cmdline.txt

# Install application dependencies

cd /home/pi || exit
git clone https://github.com/MtnFranke/rpi-photo-frame
cd rpi-photo-frame || exit
pip3 install -r requirements.txt

pip3 uninstall numpy #remove previously installed package
apt install python3-numpy

# Repair permissions

chmod -R 777 /home/pi

# SD card

cd /home/pi || exit
git clone https://github.com/azlux/log2ram.git
cd log2ram || exit
chmod +x install.sh
sudo ./install.sh
sudo nano /etc/log2ram.conf

apt install profile-sync-daemon

# Replace splash screen

wget -O /home/pi/rpi-photo-frame/doc/splash.png https://www.datenwissenschaften.com/resources/splash.png
cp /home/pi/rpi-photo-frame/doc/splash.png /usr/share/plymouth/themes/pix/splash.png

# Bootstrap application

sh /home/pi/rpi-photo-frame/src/scripts/bootstrap.sh &

exit 0
