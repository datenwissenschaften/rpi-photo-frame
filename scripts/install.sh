#!/bin/bash

# DISPLAY PROGRESS

curl http://localhost:9000/toast/Update%20l%C3%A4uft.%20Bitte%20nicht%20ausschalten.%20%200%%20

# DEACTIVATE CRONTAB

crontab -r

# HOUSEKEEPING

apt --fix-broken install
apt install curl -y

curl http://localhost:9000/toast/Update%20l%C3%A4uft.%20Bitte%20nicht%20ausschalten.%20%2010%%20

apt purge wolfram-engine scratch scratch2 nuscratch sonic-pi idle3 -y
apt purge smartsim java-common minecraft-pi libreoffice* -y

apt clean
apt autoremove -y

apt update
apt upgrade -y
apt autoremove -y

curl http://localhost:9000/toast/Update%20l%C3%A4uft.%20Bitte%20nicht%20ausschalten.%20%2020%%20

apt install curl xdotool unclutter sed git fbi chromium-browser default-jdk -y

pip install thumbor

curl http://localhost:9000/toast/Update%20l%C3%A4uft.%20Bitte%20nicht%20ausschalten.%20%2035%%20

# BOOTSTRAP

touch /boot/ssh
cd /home/pi || exit
git clone https://github.com/MtnFranke/rpi-photo-frame.git
timedatectl set-timezone Europe/Berlin

curl http://localhost:9000/toast/Update%20l%C3%A4uft.%20Bitte%20nicht%20ausschalten.%20%2050%%20

# CONFIGURATIONS

cp /home/pi/rpi-photo-frame/scripts/rc.local /etc/rc.local
chmod +x /etc/rc.local

curl http://localhost:9000/toast/Update%20l%C3%A4uft.%20Bitte%20nicht%20ausschalten.%20%2075%%20

# PERMISSION FIX

curl http://localhost:9000/toast/Update%20l%C3%A4uft.%20Bitte%20nicht%20ausschalten.%20%2085%%20
chmod -R 777 /home/pi/rpi-photo-frame

# SERVICE

cp /home/pi/rpi-photo-frame/scripts/kiosk.service /lib/systemd/system/kiosk.service
systemctl daemon-reload
systemctl enable kiosk.service

# GUI

rm /etc/xdg/autostart/piwiz.desktop
cp /home/pi/rpi-photo-frame/scripts/autostart /etc/xdg/lxsession/LXDE-pi/autostart
cp /home/pi/rpi-photo-frame/scripts/desktop-items-0.conf /etc/xdg/pcmanfm/LXDE-pi/desktop-items-0.conf
cp /home/pi/rpi-photo-frame/scripts/01-disable-update-check /etc/chromium-browser/customizations/01-disable-update-check

# REBOOT

curl http://localhost:9000/toast/Update%20abgeschlossen.%20Neustart...%20
/sbin/shutdown -r -f
