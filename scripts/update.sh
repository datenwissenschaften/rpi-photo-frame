#!/bin/bash

cd /home/pi/rpi-photo-frame/ || exit

/usr/bin/git config --global user.email "martin.franke@semiwa.org"
/usr/bin/git config --global user.name "Martin Franke"

/usr/bin/git reset --hard HEAD

CHANGED=$(/usr/bin/git status --porcelain --untracked-files=no)

if [ -n "${CHANGED}" ]; then
  sh /home/pi/rpi-photo-frame/scripts/install.sh
else
  echo ""
fi
