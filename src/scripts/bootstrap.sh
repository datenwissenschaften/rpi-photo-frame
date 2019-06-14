#!/bin/bash

# Turn backlight off
/usr/local/bin/rpi-backlight --off &

# No mouse cursor
export DISPLAY=:0 
/usr/bin/unclutter -idle 0.1 -root &

# Reload crontab from git
/usr/bin/crontab /home/pi/rpi-photo-frame/src/cron/crontab &

# Start thumbor
/usr/local/bin/thumbor -c /home/pi/rpi-photo-frame/src/conf/thumbor.conf >> /var/log/thumbor.log &

# Start photo frame application
/usr/bin/python3 /home/pi/rpi-photo-frame/src/app.py -d /home/pi/Downloads/ >> /var/log/rpi-photo-frame.log &