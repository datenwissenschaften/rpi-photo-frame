sudo nano /boot/config.txt

and added line:
lcd_rotate=2

—

Turn display off

sudo xset dpms force off

— 

Remove office

sudo apt-get remove --purge libreoffice* -y
sudo apt-get clean -y
sudo apt-get autoremove -y

—

sudo apt-get install -y software-properties-common
sudo apt-get install libjpeg-dev zlib1g-dev -y
sudo apt install libcurl4-openssl-dev libssl-dev -y
sudo pip install thumbor

—

sudo pip3 install setproctitle
sudo pip3 install pyfunctional
sudo pip3 install Flask-Bower
sudo pip3 install requests
sudo pip3 install cachetools
jsonmerge

curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -
sudo apt-get install -y nodejs
sudo npm install bower -g

python3 app.py -d /home/pi/Downloads/

—

sudo apt-get install chromium-browser -y
sudo apt-get install unclutter -y

—



sudo apt install cmake

sudo pip3 install astral
sudo pip3 install rpi_backlight


sudo apt-get install fbi


—

pi@image-frame:~ $ sudo bash -c "echo 0 > /sys/class/backlight/rpi_backlight/bl_power"
pi@image-frame:~ $ sudo bash -c "echo 1 > /sys/class/backlight/rpi_backlight/bl_power"
pi@image-frame:~ $ sudo bash -c "echo 0 > /sys/class/backlight/rpi_backlight/bl_power"
pi@image-frame:~ $ sudo bash -c "echo 0 > /sys/class/backlight/rpi_backlight/brightness"
pi@image-frame:~ $ sudo bash -c "echo 128 > /sys/class/backlight/rpi_backlight/brightness"
pi@image-frame:~ $ sudo bash -c "echo 64 > /sys/class/backlight/rpi_backlight/brightness"
pi@image-frame:~ $ sudo bash -c "echo 32 > /sys/class/backlight/rpi_backlight/brightness"
pi@image-frame:~ $ sudo bash -c "echo 16 > /sys/class/backlight/rpi_backlight/brightness"
pi@image-frame:~ $ sudo bash -c "echo 255 > /sys/class/backlight/rpi_backlight/brightness"

——

sudo apt-get install ttf-ancient-fonts

——

OPENCV

sudo apt-get install libopencv-dev python-opencv python-picamera