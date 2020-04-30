#!/bin/bash

# Show splash screen
DISPLAY=:0.0
export DISPLAY
/usr/bin/fbi -T 1 -noverbose -a -t 30 --once /home/pi/rpi-photo-frame/doc/splash.png &

# Disable console prompt
systemctl disable getty@tty1.service

# Start thumbor
# /usr/local/bin/thumbor -c /home/pi/rpi-photo-frame/src/conf/thumbor.conf &

# Start the X programs
# xinit /home/pi/rpi-photo-frame/src/scripts/xprograms.sh &

# Reload crontab from git

# Start photo frame application

export PHOTO_FRAME_ENV=prod
/usr/bin/python3 /home/pi/rpi-photo-frame/server/manage.py runserver &

exit 0
