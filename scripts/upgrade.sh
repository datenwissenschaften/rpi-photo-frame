#!/bin/bash

# STATUS MESSAGE

apt install curl -y

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

cp /home/pi/rpi-photo-frame/conf/rc.local /etc/rc.local
chmod +x /etc/rc.local

cp /home/pi/rpi-photo-frame/conf/config.txt /boot/config.txt
cp /home/pi/rpi-photo-frame/conf/chrome.service /etc/systemd/system/chrome.service
cp /home/pi/rpi-photo-frame/conf/photo-frame.service /etc/systemd/system/photo-frame.service
cp /home/pi/rpi-photo-frame/conf/splash.service /etc/systemd/system/splash.service

/usr/bin/crontab /home/pi/rpi-photo-frame/cron/crontab

# HOUSEKEEPING

apt update
apt upgrade -y
apt autoremove -y
apt autoclean -y

apt purge wolfram-engine -y
apt purge libreoffice* -y
apt clean -y
apt autoremove -y

apt install deborphan -y
apt autoremove --purge libx11-.* lxde-.* raspberrypi-artwork xkb-data omxplayer penguinspuzzle sgml-base xml-core alsa-.* cifs-.* samba-.* fonts-.* desktop-* gnome-.* -y
apt autoremove --purge "$(deborphan)" -y
apt autoremove --purge -y
apt autoclean -y

# MINIMAL UI

apt install fbi -y
apt install midori matchbox -y
apt install chromium-browser -y
apt install unclutter -y
apt install git -y

# PYTHON DEV PACKAGES

apt install libffi-devel -y
apt install python-cffi python-cryptography -y
apt install python3-cffi python3-cryptography python3-numpy python3-pillow python3-dev -y

# http://localhost:5600/toast/...%20Update%20l%C3%A4uft.%20Bitte%20nicht%20ausschalten%20..%2060%%20

# PHOTO FRAME

python3.5 -m pip install --upgrade pip
cd /home/pi/rpi-photo-frame || exit
python3.5 -m pip install -r requirements.txt --upgrade
