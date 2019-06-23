# rpi-photo-frame

[![Build Status](https://travis-ci.org/MtnFranke/rpi-photo-frame.svg?branch=master)](https://travis-ci.org/MtnFranke/rpi-photo-frame)

## Preview

![Preview](https://github.com/MtnFranke/rpi-photo-frame/raw/master/doc/preview.png)

## Install

```
ssh-copy-id pi@image-frame.local
ssh pi@image-frame.local

################################

passwd
curl -sSf https://raw.githubusercontent.com/MtnFranke/rpi-photo-frame/master/src/scripts/install.sh | sudo bash -s TELEGRAM_BOT_TOKEN PIN
```
