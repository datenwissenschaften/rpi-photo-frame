#!/bin/bash

sleep 60

wget -q --spider http://google.com
if [ $? -eq 0 ]; then
  true
else
  sudo /usr/bin/fbi -T 1 -noverbose -a -t 3600 --once /home/pi/rpi-photo-frame/doc/wifi.png &
  sudo wifi-connect -s Bilderrahmen
fi