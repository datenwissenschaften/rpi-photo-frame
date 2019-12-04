#!/bin/bash

# No mouse cursor
DISPLAY=:0.0 ; export DISPLAY
/usr/bin/unclutter -idle 0 -root &

# Screensaver fixes
xset -dpms
xset s off

# Start lightweight window manager
matchbox-window-manager &

# Show splash screen
/usr/bin/fbi -T 1 -noverbose -a -t 30 --once /home/pi/rpi-photo-frame/doc/splash.png &

# Start chromium
/usr/bin/chromium-browser --noerrordialogs --incognito --disable-session-crashed-bubble --disable-infobars --force-device-scale-factor=1.00 --no-sandbox --kiosk "http://localhost:5600"

# No mouse cursor
DISPLAY=:0.0 ; export DISPLAY
/usr/bin/unclutter -idle 0 -root &

# Turn display on (force)
/usr/bin/vcgencmd display_power 1

exit 0