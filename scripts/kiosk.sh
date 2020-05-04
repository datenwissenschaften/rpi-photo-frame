#!/bin/bash

unclutter -idle 0.5 -root &
xset -dpms
xset s off
xset s noblank

# /usr/bin/fbi -T 1 -noverbose -a -t 5 --once /home/pi/rpi-photo-frame/doc/splash.png &
/usr/bin/chromium-browser --noerrdialogs --disable-infobars --kiosk "http://localhost:5600" &

while true; do
  sleep 36000
done
