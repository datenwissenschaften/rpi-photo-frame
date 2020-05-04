#!/bin/bash

# No mouse cursor

DISPLAY=:0.0 ; export DISPLAY
/usr/bin/unclutter -idle 0 -root &

# Screensaver fixes

xset -dpms
xset s off
xset s noblank

# Start lightweight window manager

matchbox-window-manager &

# Start chromium

/usr/bin/chromium-browser --noerrordialogs --incognito --disable-session-crashed-bubble --disable-infobars --force-device-scale-factor=1.00 --no-sandbox --kiosk --test-type "http://localhost:5600"

# Turn display on (force)

/usr/bin/vcgencmd display_power 1

exit 0
