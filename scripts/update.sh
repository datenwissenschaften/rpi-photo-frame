#!/bin/bash

cd /home/pi/rpi-photo-frame/ || exit

/usr/bin/git config --global user.email "martin.franke@semiwa.org"
/usr/bin/git config --global user.name "Martin Franke"

/usr/bin/git reset --hard HEAD
/usr/bin/git pull origin "${BRANCH}" | grep changed && sh /home/pi/rpi-photo-frame/scripts/install.sh
