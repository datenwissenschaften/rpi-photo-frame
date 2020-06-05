#!/bin/bash

LD_PRELOAD=/usr/lib/arm-linux-gnueabihf/libatomic.so.1 /usr/bin/python3 /home/pi/rpi-photo-frame/server/manage.py >>/home/pi/photo-frame.log &

unclutter -idle 0 -root &

xset -dpms
xset s off
xset s noblank

sleep 5

/usr/bin/chromium-browser --noerrdialogs --incognito --disable-session-crashed-bubble --disable-infobars --force-device-scale-factor=1.00 --kiosk "http://localhost:5600" &

while true; do
  sleep 36000
done
