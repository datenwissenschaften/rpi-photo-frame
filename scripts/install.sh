#!/bin/bash

# DISPLAY PROGRESS

curl -X POST http://localhost:9000/toast -H 'Content-Type: application/json' -d '{"message":"Update läuft. Bitte nicht ausschalten. (0%)"}'

# DEACTIVATE CRONTAB

crontab -r

# HOUSEKEEPING

apt --fix-broken install
apt install curl -y

curl -X POST http://localhost:9000/toast -H 'Content-Type: application/json' -d '{"message":"Update läuft. Bitte nicht ausschalten. (10%)"}'

apt purge wolfram-engine scratch scratch2 nuscratch sonic-pi idle3 -y
apt purge smartsim java-common minecraft-pi libreoffice* -y

apt clean
apt autoremove -y

apt update
apt upgrade -y
apt autoremove -y

curl -X POST http://localhost:9000/toast -H 'Content-Type: application/json' -d '{"message":"Update läuft. Bitte nicht ausschalten. (20%)"}'

apt install curl xdotool unclutter sed git fbi chromium-browser default-jdk -y

pip install thumbor

curl -X POST http://localhost:9000/toast -H 'Content-Type: application/json' -d '{"message":"Update läuft. Bitte nicht ausschalten. (30%)"}'

# BOOTSTRAP

touch /boot/ssh
cd /home/pi || exit
git clone https://github.com/MtnFranke/rpi-photo-frame.git
timedatectl set-timezone Europe/Berlin

curl -X POST http://localhost:9000/toast -H 'Content-Type: application/json' -d '{"message":"Update läuft. Bitte nicht ausschalten. (50%)"}'

# CONFIGURATIONS

cp /home/pi/rpi-photo-frame/scripts/rc.local /etc/rc.local
chmod +x /etc/rc.local

curl -X POST http://localhost:9000/toast -H 'Content-Type: application/json' -d '{"message":"Update läuft. Bitte nicht ausschalten. (70%)"}'

# PERMISSION FIX

curl -X POST http://localhost:9000/toast -H 'Content-Type: application/json' -d '{"message":"Update läuft. Bitte nicht ausschalten. (80%)"}'
chmod -R 777 /home/pi/rpi-photo-frame

# SERVICE

cp /home/pi/rpi-photo-frame/scripts/kiosk.service /lib/systemd/system/kiosk.service
systemctl daemon-reload
systemctl enable kiosk.service

# GUI

curl -X POST http://localhost:9000/toast -H 'Content-Type: application/json' -d '{"message":"Update läuft. Bitte nicht ausschalten. (90%)"}'
rm /etc/xdg/autostart/piwiz.desktop
cp /home/pi/rpi-photo-frame/scripts/autostart /etc/xdg/lxsession/LXDE-pi/autostart
cp /home/pi/rpi-photo-frame/scripts/desktop-items-0.conf /etc/xdg/pcmanfm/LXDE-pi/desktop-items-0.conf
cp /home/pi/rpi-photo-frame/scripts/01-disable-update-check /etc/chromium-browser/customizations/01-disable-update-check

# REBOOT

curl -X POST http://localhost:9000/toast -H 'Content-Type: application/json' -d '{"message":"Update abgeschlossen. Neustart..."}'
/sbin/shutdown -r -f
