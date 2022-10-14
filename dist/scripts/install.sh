#!/bin/bash

# PACKAGE INSTALLATION

# APT

apt --fix-broken install
apt install curl -y
apt purge wolfram-engine scratch scratch2 nuscratch sonic-pi idle3 smartsim java-common minecraft-pi libreoffice* -y
apt update && apt upgrade -y && apt dist-upgrade -y && apt autoremove -y && apt clean && apt autoclean -y
apt install xdotool unclutter sed git fbi chromium-browser default-jdk -y

# PIP

pip install thumbor

# SCALA

if [ ! -f "/home/pi/scala-2.13.8.deb" ]; then
  wget -nc https://downloads.lightbend.com/scala/2.13.8/scala-2.13.8.deb -P /home/pi/
  dpkg -i /home/pi/scala-2.13.8.deb
fi

# HOUSEKEEPING

sudo /bin/bash /opt/rpi-photo-frame/dist/scripts/housekeeping.sh >/home/pi/housekeeping.log

# REBOOT

/sbin/shutdown -r -f
