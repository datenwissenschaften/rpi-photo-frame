#!/bin/bash

/usr/bin/crontab /home/pi/rpi-photo-frame/src/cron/crontab

/usr/bin/python3 /home/pi/rpi-photo-frame/src/app.py -d /home/pi/Downloads/ >> /var/log/rpi-photo-frame.log &

/usr/local/bin/thumbor -c /home/pi/thumbor.conf >> /var/log/thumbor.log &

/usr/local/bin/rpi-backlight --off &