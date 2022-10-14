# rpi-photo-frame

## Preview

![Preview](https://github.com/MtnFranke/rpi-photo-frame/raw/master/doc/preview.png)

## Install

```bash
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo usermod -aG docker pi

bash <(curl -L https://github.com/balena-io/wifi-connect/raw/master/scripts/raspbian-install.sh)

git clone https://github.com/MtnFranke/rpi-photo-frame
curl -L https://raw.githubusercontent.com/MtnFranke/rpi-photo-frame/new-display/dist/scripts/install.sh | sudo bash

```
