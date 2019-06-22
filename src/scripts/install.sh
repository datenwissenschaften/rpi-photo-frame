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

## Install

apt install -y cmake
apt install -y software-properties-common libjpeg-dev zlib1g-dev 
apt install -y libcurl4-openssl-dev libssl-dev
apt install -y chromium-browser 
apt install -y unclutter
apt install -y git
apt install -y ttf-ancient-fonts
apt install -y libopencv-dev python-opencv python-picamera
apt install -y fbi

# Python applications

pip install thumbor

# Nodejs

curl -sL https://deb.nodesource.com/setup_10.x | -E bash -
apt-get install -y nodejs

# NPM packages

npm i bower -g
npm i frontail -g

# config.txt

echo "lcd_rotate=2" >> /boot/config.txt
echo "start_x=0" >> /boot/config.txt
echo "gpu_mem=256" >> /boot/config.txt
echo "disable_splash=1"  >> /boot/config.txt
# TODO: Untested
# TODO: Change tty1 to tty3
# echo -n "quiet plymouth.ignore-serial-consoles logo.nologo vt.global_cursor_default=0 loglevel=3" >> /boot/cmdline.txt

# Install application dependencies

cd /home/pi
git clone https://github.com/MtnFranke/rpi-photo-frame
cd rpi-photo-frame
pip3 install -r requirements.txt
cd src
bower install --allow-root

# BOOTSTRAP (!)

sh /home/pi/rpi-photo-frame/src/scripts/bootstrap.sh