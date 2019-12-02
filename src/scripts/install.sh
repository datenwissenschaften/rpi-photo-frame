#!/bin/bash

# Make sure only root can run our script

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# Parameters to environment

if [[ $# -le 1 ]]
then
   echo "This script must be run with configuration" 1>&2
   exit 1
fi

echo "TELEGRAM_TOKEN=$1" >> /etc/environment
echo "PIN=$2"  >> /etc/environment

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
    python3 python3-rpi.gpio python3-pip dnsmasq hostapd

# Python applications

pip install thumbor

# Nodejs

curl -sL https://deb.nodesource.com/setup_10.x | -E bash -
apt-get install -y nodejs

# NPM packages

npm i frontail -g

# config.txt

echo "lcd_rotate=2" >> /boot/config.txt
echo "start_x=0" >> /boot/config.txt
echo "gpu_mem=256" >> /boot/config.txt
echo "disable_splash=1"  >> /boot/config.txt

# TODO: Untested
# echo -n " splash quiet plymouth.ignore-serial-consoles logo.nologo vt.global_cursor_default=0 loglevel=3 disable_splash=1" >> /boot/cmdline.txt

# Install application dependencies

cd /home/pi
git clone https://github.com/MtnFranke/rpi-photo-frame
cd rpi-photo-frame
pip3 install -r requirements.txt

# Repair permissions

chmod -R 777 /home/pi

# Wifi config

git clone https://github.com/MtnFranke/RaspiWiFi
cd RaspiWifi
sudo python3 initial_setup.py

# Install dataplicity

curl https://www.dataplicity.com/sopukyyq.py | sudo python

# SD card

cd /home/pi
git clone https://github.com/azlux/log2ram.git
cd log2ram
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
