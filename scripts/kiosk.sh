#!/bin/bash

unclutter -idle 0.5 -root &

xset -dpms
xset s activate
xset s 1

/usr/bin/chromium-browser --noerrdialogs --incognito --disable-session-crashed-bubble --disable-infobars --force-device-scale-factor=1.00 --kiosk "http://localhost:5600" &

sleep 30
xset s reset
xset s 0

xset -dpms
xset s off
xset s noblank

while true; do
  sleep 36000
done
