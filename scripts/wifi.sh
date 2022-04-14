#!/bin/bash

sleep 60

wget -q --spider http://google.com
if [ $? -eq 0 ]; then
  true
else
  /usr/bin/fbi -T 1 -noverbose -a -t 3600 --once /home/pi/rpi-photo-frame/doc/wifi.png &
  wifi-connect -s Bilderrahmen
fi
