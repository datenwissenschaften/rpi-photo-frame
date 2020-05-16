#!/bin/bash

cd /home/pi/rpi-photo-frame/ || exit

/usr/bin/git config --global user.email "martin.franke@semiwa.org"
/usr/bin/git config --global user.name "Martin Franke"

/usr/bin/git clean -f -d
/usr/bin/git reset --hard HEAD
/usr/bin/git fetch

CHANGED=0
/usr/bin/git remote update && /usr/bin/git status -uno | grep -q 'Your branch is behind' && CHANGED=1
if [ $CHANGED = 1 ]; then
  /usr/bin/git pull origin "${BRANCH}"
  /bin/bash /home/pi/rpi-photo-frame/scripts/install.sh
else
    echo ""
fi