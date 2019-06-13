#!/bin/bash

(cd /home/pi/rpi-photo-frame/ && /usr/bin/git pull) | grep changed && /sbin/reboot