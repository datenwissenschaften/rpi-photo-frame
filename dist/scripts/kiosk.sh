#!/bin/bash

# HOUSEKEEPING

sudo /bin/bash /opt/rpi-photo-frame/scripts/housekeeping.sh >/home/pi/housekeeping.log

### ENV

export PATH="$HOME/.local/bin:$PATH"

### WIFI CHECKER

sudo /bin/bash /opt/rpi-photo-frame/scripts/wifi.sh >/home/pi/wifi.log &

### THUMBOR

sudo thumbor -c /opt/rpi-photo-frame/scripts/thumbor.conf >/home/pi/thumbor.log &

### RPI PI PHOTOFRAME

sudo /opt/rpi-photo-frame/bin/rpi-photo-frame -Dconfig.file=/opt/rpi-photo-frame/conf/secret.conf &

### KIOSK CHROME

unclutter -idle 0 -root &

xset -dpms
xset s off
xset s noblank

sleep 5

/usr/bin/chromium-browser --noerrdialogs --incognito --disable-session-crashed-bubble --disable-infobars --force-device-scale-factor=1.00 --kiosk "http:/localhost:9000" &

while true; do
  sleep 36000
done
