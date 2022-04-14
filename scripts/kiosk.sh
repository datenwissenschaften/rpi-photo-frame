#!/bin/bash

### ENV

export PATH="$HOME/.local/bin:$PATH"

### UPDATER

sudo /bin/bash /home/pi/rpi-photo-frame/scripts/update.sh >>/home/pi/updater.log &

### WIFI CHECKER

sudo /bin/bash /home/pi/rpi-photo-frame/scripts/wifi.sh >>/home/pi/wifi.log &

### THUMBOR

thumbor -c /home/pi/thumbor.conf >>/home/pi/thumbor.log &

### RPI-PI-PHOTOFRAME

MASTER_IP=$(ip -o route get to 8.8.8.8 | sed -n 's/.*src \([0-9.]\+\).*/\1/p')

### KIOSK CHROME

unclutter -idle 0 -root &

xset -dpms
xset s off
xset s noblank

sleep 5

/usr/bin/chromium-browser --noerrdialogs --incognito --disable-session-crashed-bubble --disable-infobars --force-device-scale-factor=1.00 --kiosk "http://localhost:5600" &

while true; do
  sleep 36000
done
