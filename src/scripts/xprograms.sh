#!/bin/bash

# No mouse cursor
DISPLAY=:0.0 ; export DISPLAY
/usr/bin/unclutter -idle 0 -root &

# Start lightweight window manager
matchbox-window-manager &

# Start chromium
/usr/bin/chromium-browser --noerrordialogs --incognito --disable-session-crashed-bubble --disable-infobars --force-device-scale-factor=1.00 --no-sandbox --kiosk "http://localhost:5000"

# No mouse cursor
DISPLAY=:0.0 ; export DISPLAY
/usr/bin/unclutter -idle 0 -root &