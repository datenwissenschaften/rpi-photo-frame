#!/bin/bash

cd /home/pi/rpi-photo-frame/

/usr/bin/git reset --hard HEAD
/usr/bin/git pull origin ${BRANCH} | grep changed && /sbin/reboot

exit 0