#!/bin/bash

sudo crontab -r >/dev/null 2>&1
sudo rm -rf /opt/rpi-photo-frame/RUNNING_PID >/dev/null 2>&1
sudo cp /opt/rpi-photo-frame/scripts/rc.local /etc/rc.local >/dev/null 2>&1
sudo chmod +x /etc/rc.local >/dev/null 2>&1
sudo rm /etc/xdg/autostart/piwiz.desktop >/dev/null 2>&1
sudo cp /opt/rpi-photo-frame/scripts/autostart /etc/xdg/lxsession/LXDE-pi/autostart >/dev/null 2>&1
sudo cp /opt/rpi-photo-frame/scripts/desktop-items-0.conf /etc/xdg/pcmanfm/LXDE-pi/desktop-items-0.conf >/dev/null 2>&1
sudo cp /opt/rpi-photo-frame/scripts/01-disable-update-check /etc/chromium-browser/customizations/01-disable-update-check >/dev/null 2>&1
sudo cp /opt/rpi-photo-frame/scripts/kiosk.service /lib/systemd/system/kiosk.service >/dev/null 2>&1
sudo systemctl daemon-reload >/dev/null 2>&1
sudo systemctl enable kiosk.service >/dev/null 2>&1
