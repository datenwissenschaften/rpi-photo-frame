#!/bin/bash

# Display progress

curl http://localhost:5600/toast/Update%20l%C3%A4uft.%20Bitte%20nicht%20ausschalten.%20%200%%20

# DEACTIVATE CRONTAB

crontab -r

# HOUSEKEEPING

apt --fix-broken install
apt install curl -y

curl http://localhost:5600/toast/Update%20l%C3%A4uft.%20Bitte%20nicht%20ausschalten.%20%2010%%20

apt purge wolfram-engine scratch scratch2 nuscratch sonic-pi idle3 -y
apt purge smartsim java-common minecraft-pi libreoffice* -y

apt clean
apt autoremove -y

apt update
apt upgrade -y
apt autoremove -y

curl http://localhost:5600/toast/Update%20l%C3%A4uft.%20Bitte%20nicht%20ausschalten.%20%2020%%20

apt install curl xdotool unclutter sed git fbi python3-pip \
  python3-cffi python3-cryptography python3-numpy python3-pillow -y

curl http://localhost:5600/toast/Update%20l%C3%A4uft.%20Bitte%20nicht%20ausschalten.%20%2035%%20

# BOOTSTRAP

touch /boot/ssh
cd /home/pi || exit
git clone https://github.com/MtnFranke/rpi-photo-frame.git
timedatectl set-timezone Europe/Berlin

curl http://localhost:5600/toast/Update%20l%C3%A4uft.%20Bitte%20nicht%20ausschalten.%20%2050%%20

# CONFIGURATIONS

cp /home/pi/rpi-photo-frame/conf/rc.local /etc/rc.local
chmod +x /etc/rc.local

curl http://localhost:5600/toast/Update%20l%C3%A4uft.%20Bitte%20nicht%20ausschalten.%20%2075%%20

# PHOTO FRAME

python3 -m pip install --upgrade pip
cd /home/pi/rpi-photo-frame || exit
python3 -m pip install -r requirements.txt --upgrade
python3 -m pip install gunicorn --upgrade
python3 -m pip install numpy --upgrade --ignore-installed
python3 -m pip install thumbor

# PERMISSIONS

curl http://localhost:5600/toast/Update%20l%C3%A4uft.%20Bitte%20nicht%20ausschalten.%20%2085%%20
chmod -R 777 /home/pi/rpi-photo-frame

# SERVICE

cp /home/pi/rpi-photo-frame/scripts/kiosk.service /lib/systemd/system/kiosk.service
systemctl daemon-reload
systemctl enable kiosk.service

# SPLASH

curl http://localhost:5600/toast/Update%20l%C3%A4uft.%20Bitte%20nicht%20ausschalten.%20%2095%%20
cd /home/pi/rpi-photo-frame/doc/ || exit
wget https://www.datenwissenschaften.com/resources/splash.png
cp /home/pi/rpi-photo-frame/doc/splash.png /usr/share/plymouth/themes/pix/splash.png

# GUI

rm /etc/xdg/autostart/piwiz.desktop
cp /home/pi/rpi-photo-frame/conf/autostart /etc/xdg/lxsession/LXDE-pi/autostart
cp /home/pi/rpi-photo-frame/conf/desktop-items-0.conf /etc/xdg/pcmanfm/LXDE-pi/desktop-items-0.conf
cp /home/pi/rpi-photo-frame/conf/01-disable-update-check /etc/chromium-browser/customizations/01-disable-update-check

# RAM DISK

# shellcheck disable=SC2046
# shellcheck disable=SC2143
if [ -z $(grep "ramdisk" "/etc/fstab") ]; then
  mkdir -p /mnt/ramdisk
  echo "tmpfs /mnt/ramdisk tmpfs nodev,nosuid,size=16M 0 0 " >>/etc/fstab
  sudo mount -a
else
  echo 'RAM DISK EXISTS'
fi

# REBOOT

curl http://localhost:5600/toast/Update%20abgeschlossen.%20Neustart...%20
/sbin/shutdown -r -f
