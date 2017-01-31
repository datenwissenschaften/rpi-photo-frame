# rpi-photo-frame

[![Build Status](https://travis-ci.org/MtnFranke/rpi-photo-frame.svg?branch=master)](https://travis-ci.org/MtnFranke/rpi-photo-frame)

```
# Add arm build chain for cross building (only for non-rpi hosts(!))
# docker run --rm --privileged multiarch/qemu-user-static:register --reset

# Build docker image on rpi or qemu
docker build -t mtnfranke/rpi-photo-frame .

# Serve all images from give folder
docker run -it -p 5000:5000 -v /home/$USER/Pictures/:/srv/photos/ mtnfranke/rpi-photo-frame
```
