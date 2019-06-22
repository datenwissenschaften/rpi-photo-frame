#!/bin/bash

# Show splash screen
fbi -T 1 -noverbose -a -t 30 --once /home/pi/rpi-photo-frame/doc/preview.png

# Repair permissions
chmod -R 777 /home/pi

# Turn backlight off
# /usr/local/bin/rpi-backlight --off &

# No mouse cursor
# export DISPLAY=:0
# /usr/bin/unclutter -idle 0.1 -root &

# Reload crontab from git
/usr/bin/crontab /home/pi/rpi-photo-frame/src/cron/crontab &

# Start thumbor
/usr/local/bin/thumbor -c /home/pi/rpi-photo-frame/src/conf/thumbor.conf >> /var/log/thumbor.log &

# Start photo frame application
/usr/bin/python3 /home/pi/rpi-photo-frame/src/app.py >> /var/log/rpi-photo-frame.log &

# Start photo frame bot
(sleep 30 && /usr/bin/python3 /home/pi/rpi-photo-frame/src/bot.py) >> /var/log/bot.log &

# Start logging proxy
/usr/bin/frontail -n 2000 -p 9010 -d /var/log/bootstrap.log &