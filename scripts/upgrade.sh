#!/bin/bash

apt purge nodejs -y
apt purge python3 -v

apt update
apt upgrade -y
apt autoremove -y
apt autoclean -y

if ! [ -x "$(command -v python3.7)" ]; then

  apt install build-essential tk-dev libncurses5-dev libncursesw5-dev libreadline6-dev libdb5.3-dev libgdbm-dev libsqlite3-dev libssl-dev libbz2-dev libexpat1-dev liblzma-dev zlib1g-dev libffi-dev -y
  cd /home/pi || exit
  wget https://www.python.org/ftp/python/3.7.4/Python-3.7.4.tar.xz
  tar xf Python-3.7.4.tar.xz
  cd Python-3.7.4 || exit
  ./configure --enable-optimizations --prefix=/usr/local/
  make -j 4
  make altinstall

  rm -r Python-3.7.4
  rm Python-3.7.4.tar.xz
  apt purge build-essential tk-dev -y
  apt purge libncurses5-dev libncursesw5-dev libreadline6-dev -y
  apt purge libdb5.3-dev libgdbm-dev libsqlite3-dev libssl-dev -y
  apt purge libbz2-dev libexpat1-dev liblzma-dev zlib1g-dev libffi-dev -y
  apt autoremove -y
  apt clean

fi

pip3 install --upgrade pip
pip3 install pipenv

cd /home/pi/rpi-photo-frame || exit
pipenv install