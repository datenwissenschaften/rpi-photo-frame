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

apt install libzmq5 libvorbisenc2 libavformat58 libva-drm2 libpangoft2-1.0-0 libvdpau1 libatlas3-base libx265-192 libgfortran5 libxvidcore4 libvpx6 libcodec2-0.9 libgme0 libgraphite2-3 libwebpmux3 libchromaprint1 libpgm-5.3-0 libopus0 libudfread0 libshine3 libcairo2 libvorbis0a libgdk-pixbuf-2.0-0 libpango-1.0-0 libdatrie1 libbluray2 libmpg123-0 libsrt1.4-gnutls libsoxr0 libsnappy1v5 libdrm2 libx264-160 libva-x11-2 libcairo-gobject2 libavutil56 libxfixes3 libvorbisfile3 librabbitmq4 libthai0 libopenjp2-7 libxrender1 libaom0 libspeex1 libva2 libsodium23 libswscale5 libopenmpt0 libpangocairo-1.0-0 libharfbuzz0b libdav1d4 libmp3lame0 libzvbi0 libtheora0 libgsm1 libtwolame0 ocl-icd-libopencl1 libswresample3 libxcb-shm0 libavcodec58 libnorm1 librsvg2-2 libssh-gcrypt-4 libxcb-render0 libpixman-1-0 libwavpack1 libogg0 	python3-gi python3-gi-cairo gir1.2-gtk-3.0 curl xdotool unclutter sed git fbi python3-pip libatlas-base-dev libjpeg-dev zlib1g-dev libfreetype6-dev liblcms1-dev libopenjp2-7 libtiff5 python-cffi python-cryptography python3-cffi python3-cryptography python3-numpy python3-pillow python3-dev libhdf5-dev libhdf5-serial-dev libjasper-dev libjasper-dev libjpeg-dev zlib1g-dev libwebpmux3 libwebpdemux2 liblcms2-2 libopenjp2-7 libatlas3-base libgfortran5 python3-h5py chromium-browser -y
	
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

# REBOOT

curl http://localhost:5600/toast/Update%20abgeschlossen.%20Neustart...%20
/sbin/shutdown -r -f
