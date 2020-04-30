#!/bin/bash

# MIGRATION

apt purge nodejs -y
chmod +x /usr/local/bin/uninstall-log2ram.sh && sudo /usr/local/bin/uninstall-log2ram.sh
apt purge plymouth -y
apt purge profile-sync-daemon -y
apt purge python* -y

# BOOTUP

systemctl disable plymouth-start.service
systemctl disable dphys-swapfile.service
systemctl disable keyboard-setup.service
systemctl disable apt-daily.service
systemctl disable wifi-country.service
systemctl disable hciuart.service
systemctl disable raspi-config.service
systemctl disable triggerhappy.service

# CONFIGURATIONS

cp /home/pi/rpi-photo-frame/conf/config.txt /boot/config.txt

# HOUSEKEEPING

apt update
apt upgrade -y
apt autoremove -y
apt autoclean -y

apt install deborphan -y
apt autoremove --purge libx11-.* lxde-.* raspberrypi-artwork xkb-data omxplayer penguinspuzzle sgml-base xml-core alsa-.* cifs-.* samba-.* fonts-.* desktop-* gnome-.* -y
apt autoremove --purge "$(deborphan)" -y
apt autoremove --purge -y
apt autoclean -y

# MINIMAL UI

apt install fbi
apt install midori matchbox
apt install chromium-browser
apt install unclutter
apt install git

if ! [ -x "$(command -v python3.7)" ]; then
  curl -sSf https://gist.githubusercontent.com/SeppPenner/6a5a30ebc8f79936fa136c524417761d/raw/ff9ea983c17ef9c59ef23833ad1dc6e015c5aaae/setup.sh | sudo bash -s
fi

if ! [ -x "$(command -v pip3.7)" ]; then
  curl -sSf https://gist.githubusercontent.com/SeppPenner/6a5a30ebc8f79936fa136c524417761d/raw/ff9ea983c17ef9c59ef23833ad1dc6e015c5aaae/setup.sh | sudo bash -s
fi

apt install curl

# http://localhost:5600/toast/...%20Update%20l%C3%A4uft.%20Bitte%20nicht%20ausschalten%20..%2060%%20

pip3.7 install --upgrade pip

cd /home/pi/rpi-photo-frame || exit
pip3.7 -r requirements.txt
