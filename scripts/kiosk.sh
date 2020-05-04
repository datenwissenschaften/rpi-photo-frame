#!/bin/bash

unclutter -idle 0.5 -root &
xset -dpms
xset s off
xset s noblank

sed -i 's/"exited_cleanly":false/"exited_cleanly":true/' /home/pi/.config/chromium/Default/Preferences
sed -i 's/"exit_type":"Crashed"/"exit_type":"Normal"/' /home/pi/.config/chromium/Default/Preferences

# /usr/bin/fbi -T 1 -noverbose -a -t 5 --once /home/pi/rpi-photo-frame/doc/splash.png &
/usr/bin/python3 /home/pi/rpi-photo-frame/server/manage.py &
/usr/bin/chromium-browser --noerrdialogs --disable-infobars --kiosk http://localhost:5600 &

exit 0
