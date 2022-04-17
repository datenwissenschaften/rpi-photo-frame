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

if [ ! -f "/home/pi/scala-2.13.8.deb" ]; then
  wget -nc https://downloads.lightbend.com/scala/2.13.8/scala-2.13.8.deb -P /home/pi/
  dpkg -i scala-2.13.8.deb
fi

curl -X POST http://localhost:9000/toast -H 'Content-Type: application/json' -d '{"message":"Update läuft. Bitte nicht ausschalten. (40%)"}'

# CONFIGURATIONS

curl -X POST http://localhost:9000/toast -H 'Content-Type: application/json' -d '{"message":"Update läuft. Bitte nicht ausschalten. (70%)"}'
cp /opt/rpi-photo-frame/scripts/rc.local /etc/rc.local
chmod +x /etc/rc.local

# PERMISSION FIX

curl -X POST http://localhost:9000/toast -H 'Content-Type: application/json' -d '{"message":"Update läuft. Bitte nicht ausschalten. (80%)"}'
chmod -R 777 /opt/rpi-photo-frame

# GUI

curl -X POST http://localhost:9000/toast -H 'Content-Type: application/json' -d '{"message":"Update läuft. Bitte nicht ausschalten. (90%)"}'
rm /etc/xdg/autostart/piwiz.desktop
cp /opt/rpi-photo-frame/scripts/autostart /etc/xdg/lxsession/LXDE-pi/autostart
cp /opt/rpi-photo-frame/scripts/desktop-items-0.conf /etc/xdg/pcmanfm/LXDE-pi/desktop-items-0.conf
cp /opt/rpi-photo-frame/scripts/01-disable-update-check /etc/chromium-browser/customizations/01-disable-update-check

# SERVICE

cp /opt/rpi-photo-frame/scripts/kiosk.service /lib/systemd/system/kiosk.service
systemctl daemon-reload
systemctl enable kiosk.service

# REBOOT

curl -X POST http://localhost:9000/toast -H 'Content-Type: application/json' -d '{"message":"Update abgeschlossen. Neustart..."}'
/sbin/shutdown -r -f
