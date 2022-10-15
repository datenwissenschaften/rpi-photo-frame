#!/bin/bash

cd /home/pi/rpi-photo-frame/ || exit

sudo /usr/bin/git git config pull.rebase false
sudo /usr/bin/git config --global user.email "martin.franke@me.com"
sudo /usr/bin/git config --global user.name "MtnFranke"

sudo /usr/bin/git clean -f -d
sudo /usr/bin/git reset --hard HEAD
sudo /usr/bin/git fetch

CHANGED=0
sudo /usr/bin/git remote update && /usr/bin/git status -uno | grep -q 'Your branch is behind' && CHANGED=1
if [ $CHANGED = 1 ]; then
  sudo /usr/bin/git pull
  sudo /bin/bash /home/pi/rpi-photo-frame/scripts/install.sh
else
  echo ""
fi
