#!/bin/bash

# Show splash screen
DISPLAY=:0.0 ; export DISPLAY
/usr/bin/fbi -T 1 -noverbose -a -t 30 --once /home/pi/rpi-photo-frame/doc/splash.png &

# Disable console prompt
systemctl disable getty@tty1.service

# Start thumbor
/usr/local/bin/thumbor -c /home/pi/rpi-photo-frame/src/conf/thumbor.conf &

# Start the X programs
xinit /home/pi/rpi-photo-frame/src/scripts/xprograms.sh &

# Disable swapping
/sbin/swapoff -a

# Disable unneeded services
# sudo systemctl disable dhcpcd.service
# sudo systemctl disable networking.service
# sudo systemctl disable ssh.service
# sudo systemctl disable ntp.service
# sudo systemctl disable avahi-daemon.service

systemctl disable dphys-swapfile.service
systemctl disable keyboard-setup.service
systemctl disable apt-daily.service
systemctl disable wifi-country.service
systemctl disable hciuart.service
systemctl disable raspi-config.service
systemctl disable triggerhappy.service

# Update scripts
cp /home/pi/rpi-photo-frame/src/conf/rc.local /etc/rc.local
cp /home/pi/rpi-photo-frame/src/conf/psd.conf /home/pi/.config/psd/psd.conf

# Reload crontab from git
/usr/bin/crontab /home/pi/rpi-photo-frame/src/cron/crontab &

# Start photo frame application
/usr/bin/python3 /home/pi/rpi-photo-frame/src/app.py &

# Start photo frame bot
(sleep 30 && /usr/bin/python3 /home/pi/rpi-photo-frame/src/bot.py) &

exit 0
