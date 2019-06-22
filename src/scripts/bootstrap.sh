#!/bin/bash

# Repair permissions
chmod -R 777 /home/pi

# Update scripts
cp /home/pi/rpi-photo-frame/src/conf/chromium.desktop /etc/xdg/autostart/chromium.desktop
cp /home/pi/rpi-photo-frame/src/conf/rc.local /etc/rc.local

# No mouse cursor
DISPLAY=:0.0 ; export DISPLAY
/usr/bin/unclutter -idle 0 -root &

# Reload crontab from git
/usr/bin/crontab /home/pi/rpi-photo-frame/src/cron/crontab &

# Show splash screen
/usr/bin/fbi -T 1 -noverbose -a -t 60 --once /home/pi/rpi-photo-frame/doc/splash.png &

# Start thumbor
/usr/local/bin/thumbor -c /home/pi/rpi-photo-frame/src/conf/thumbor.conf >> /var/log/thumbor.log &

# Start photo frame application
/usr/bin/python3 /home/pi/rpi-photo-frame/src/app.py >> /var/log/rpi-photo-frame.log &

# Start photo frame bot
(sleep 30 && /usr/bin/python3 /home/pi/rpi-photo-frame/src/bot.py) >> /var/log/bot.log &

# Start logging proxy
/usr/bin/frontail -n 2000 -p 9010 -d /var/log/bootstrap.log &

# Turn display on after 30s
(sleep 30 && /usr/local/bin/rpi-backlight --on) &