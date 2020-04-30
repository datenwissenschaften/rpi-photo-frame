#!/bin/bash

# Disable unneeded services
# systemctl disable dhcpcd.service
# systemctl disable networking.service
# systemctl disable ssh.service
# systemctl disable ntp.service
# systemctl disable avahi-daemon.service


# Show splash screen
DISPLAY=:0.0
export DISPLAY
/usr/bin/fbi -T 1 -noverbose -a -t 30 --once /home/pi/rpi-photo-frame/doc/splash.png &

# Disable console prompt
systemctl disable getty@tty1.service

# Start thumbor
# /usr/local/bin/thumbor -c /home/pi/rpi-photo-frame/src/conf/thumbor.conf &

# Start the X programs
xinit /home/pi/rpi-photo-frame/src/scripts/xprograms.sh &

# Disable swapping
# /sbin/swapoff -a



# Update scripts

cp /home/pi/rpi-photo-frame/src/conf/rc.local /etc/rc.local
chmod +x /etc/rc.local

# Update config files

cp /home/pi/rpi-photo-frame/src/conf/psd.conf /home/pi/.config/psd/psd.conf

# Reload crontab from git

/usr/bin/crontab /home/pi/rpi-photo-frame/src/cron/crontab &

# Start photo frame application

export PHOTO_FRAME_ENV=prod
/usr/bin/python3 /home/pi/rpi-photo-frame/server/manage.py runserver &

exit 0
