#!/bin/bash

unclutter -idle 0.5 -root &
xset -dpms
xset s off
xset s noblank

# /usr/bin/fbi -T 1 -noverbose -a -t 5 --once /home/pi/rpi-photo-frame/doc/splash.png &
/usr/bin/chromium-browser --noerrordialogs --incognito --disable-session-crashed-bubble --disable-infobars --force-device-scale-factor=1.00 --no-sandbox --kiosk --test-type "http://localhost:5600" &

while true; do
   xdotool keydown ctrl+Tab; xdotool keyup ctrl+Tab;
   sleep 3600
done
