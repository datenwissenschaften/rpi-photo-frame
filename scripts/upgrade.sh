#!/bin/bash

# BOOTSTRAP

touch /boot/ssh
apt --fix-broken install
apt install git
cd /home/pi || exit
git clone https://github.com/MtnFranke/rpi-photo-frame.git
timedatectl set-timezone Europe/Berlin

# DEACTIVATE CRONTAB

crontab -r

# STATUS MESSAGE

apt install curl -y

curl http://localhost:5600/toast/Update%20l%C3%A4uft.%20Bitte%20nicht%20ausschalten.%20%2010%%20

# CONFIGURATIONS

cp /home/pi/rpi-photo-frame/conf/rc.local /etc/rc.local
chmod +x /etc/rc.local
cp /home/pi/rpi-photo-frame/conf/config.txt /boot/config.txt

curl http://localhost:5600/toast/Update%20l%C3%A4uft.%20Bitte%20nicht%20ausschalten.%20%2050%%20

# HOUSEKEEPING

apt update
apt upgrade -y
apt autoremove -y
apt autoclean -y

apt install deborphan -y
apt autoremove --purge "$(deborphan)" -y
apt autoremove --purge -y
apt autoclean -y

curl http://localhost:5600/toast/Update%20l%C3%A4uft.%20Bitte%20nicht%20ausschalten.%20%2070%%20

# MINIMAL UI

apt install --no-install-recommends xserver-xorg xinit x11-xserver-utils -y
apt install fbi midori matchbox chromium-browser unclutter git -y

curl http://localhost:5600/toast/Update%20l%C3%A4uft.%20Bitte%20nicht%20ausschalten.%20%2075%%20

# PYTHON DEV PACKAGES

apt install libjpeg-dev zlib1g-dev libfreetype6-dev liblcms1-dev libopenjp2-7 libtiff5 libffi-devel python-cffi python-cryptography python3-cffi python3-cryptography python3-numpy python3-pillow python3-dev -y

curl http://localhost:5600/toast/Update%20l%C3%A4uft.%20Bitte%20nicht%20ausschalten.%20%2080%%20

# PHOTO FRAME

apt install python3-pip libatlas-base-dev -y
python3 -m pip install --upgrade pip
cd /home/pi/rpi-photo-frame || exit
python3 -m pip install -r requirements.txt --upgrade
python3 -m pip install gunicorn --upgrade
cd /home/pi/rpi-photo-frame/doc || exit

cp /home/pi/rpi-photo-frame/service/photo.service /etc/systemd/system/photo.service
systemctl stop photo
systemctl disable photo
systemctl enable photo
systemctl start photo

# SPLASH

curl http://localhost:5600/toast/Update%20l%C3%A4uft.%20Bitte%20nicht%20ausschalten.%20%2085%%20

cp /home/pi/rpi-photo-frame/service/splashscreen.service /etc/systemd/system/splashscreen.service
wget https://www.datenwissenschaften.com/resources/splash.png
systemctl stop splashscreen
systemctl disable splashscreen
systemctl enable splashscreen
systemctl start splashscreen

# XINIT

cp /home/pi/rpi-photo-frame/service/xinit.service /etc/systemd/system/xinit.service
systemctl stop xinit
systemctl disable xinit
systemctl enable xinit
systemctl start xinit

# REACTIVATE CRONTAB

curl http://localhost:5600/toast/Update%20abgeschlossen.%20Neustart...%20

/usr/bin/crontab /home/pi/rpi-photo-frame/cron/crontab

# REBOOT

/sbin/shutdown -r -f
