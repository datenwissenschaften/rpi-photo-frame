#!/bin/bash

# Disable console prompt
systemctl disable getty@tty1.service

# Disable swapping
dphys-swapfile swapoff
dphys-swapfile uninstall
update-rc.d dphys-swapfile remove

# Replace splash screen
# wget -O /home/pi/rpi-photo-frame/doc/splash.png https://www.datenwissenschaften.com/resources/splash.png
# cp /home/pi/rpi-photo-frame/doc/splash.png /usr/share/plymouth/themes/pix/splash.png

# Update scripts
cp /home/pi/rpi-photo-frame/src/conf/rc.local /etc/rc.local
cp /home/pi/rpi-photo-frame/src/conf/raspiwifi.conf /etc/raspiwifi/raspiwifi.conf

# Reload crontab from git
/usr/bin/crontab /home/pi/rpi-photo-frame/src/cron/crontab &

# Start thumbor
/usr/local/bin/thumbor -c /home/pi/rpi-photo-frame/src/conf/thumbor.conf &

# Start photo frame application
/usr/bin/python3 /home/pi/rpi-photo-frame/src/app.py &

# Start photo frame bot
(sleep 30 && /usr/bin/python3 /home/pi/rpi-photo-frame/src/bot.py &

# Start logging proxy
/usr/bin/frontail -n 2000 -p 9010 -d /var/log/bootstrap.log &

# Start the X programs
xinit /home/pi/rpi-photo-frame/src/scripts/xprograms.sh