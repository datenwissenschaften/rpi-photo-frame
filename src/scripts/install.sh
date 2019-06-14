#!/bin/bash

# Make sure only root can run our script

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

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

# PIP packages

## Python 2.x

pip install thumbor

## Python 3.x

pip3 install setproctitle
pip3 install pyfunctional
pip3 install Flask-Bower
pip3 install requests
pip3 install cachetools
pip3 install jsonmerge
pip3 install astral
pip3 install rpi_backlight

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

# Install application
cd /home/pi
git clone https://github.com/MtnFranke/rpi-photo-frame
cd rpi-photo-frame/src
bower install
sh /home/pi/rpi-photo-frame/src/scripts/bootstrap.sh