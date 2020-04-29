#!/bin/bash

cd /home/pi/rpi-photo-frame/ || exit

/usr/bin/git config --global user.email "you@example.com"
/usr/bin/git config --global user.name "Your Name"

/usr/bin/git reset --hard HEAD
/usr/bin/git pull origin "${BRANCH}" | grep changed && /sbin/reboot

exit 0
