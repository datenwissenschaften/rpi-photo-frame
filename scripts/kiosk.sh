#!/bin/bash

### UPDATER

/bin/bash /home/pi/rpi-photo-frame/scripts/update.sh >>/home/pi/updater.log &

### WIFI CHECKER

/bin/bash /home/pi/rpi-photo-frame/scripts/wifi.sh >>/home/pi/wifi.log &

### DOCKER

docker run -p 8888:80 -e DETECTORS="['thumbor.detectors.face_detector']" -e FILE_LOADER_ROOT_PATH="/images" -e LOADER="thumbor.loaders.file_loader" -v /home/pi/rpi-photo-frame/images:/images minimalcompact/thumbor

## TODO: Image Frame Image

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
