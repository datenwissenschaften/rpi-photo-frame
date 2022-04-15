#!/bin/bash

### ENV

export PATH="$HOME/.local/bin:$PATH"

### UPDATER

sudo /bin/bash /home/pi/rpi-photo-frame/scripts/update.sh >/home/pi/updater.log &

### WIFI CHECKER

sudo /bin/bash /home/pi/rpi-photo-frame/scripts/wifi.sh >/home/pi/wifi.log &

### THUMBOR

sudo thumbor -c /home/pi/rpi-photo-frame/scripts/thumbor.conf >/home/pi/thumbor.log &

### RPI-PI-PHOTOFRAME

MASTER_IP=$(ip -o route get to 8.8.8.8 | sed -n 's/.*src \([0-9.]\+\).*/\1/p')
sudo /opt/rpi-photo-frame-1.5.0/bin/rpi-photo-frame -Dmaster.ip="$MASTER_IP" -Dconfig.file=/opt/rpi-photo-frame-1.5.0/conf  &

### KIOSK CHROME

unclutter -idle 0 -root &

xset -dpms
xset s off
xset s noblank

sleep 5

/usr/bin/chromium-browser --noerrdialogs --incognito --disable-session-crashed-bubble --disable-infobars --force-device-scale-factor=1.00 --kiosk "http://$MASTER_IP:9000" &

while true; do
  sleep 36000
done
