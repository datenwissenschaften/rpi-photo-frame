# -*- coding: UTF-8 -*-

import os
import socket

from retry.api import retry_call

from routes import create_app

(socket_io, app) = create_app(os.getenv("PHOTO_FRAME_ENV", "dev").lower())


def is_connected():
    import logging
    logging.basicConfig()
    socket.create_connection(("www.google.com", 80))
    return True


def start():
    # noinspection PyBroadException
    try:
        connected = retry_call(is_connected, tries=6, delay=1, backoff=2)
    except Exception:
        connected = False

    if not connected:
        os.system('sudo /usr/bin/fbi -T 1 -noverbose -a -t 3600 --once /home/pi/rpi-photo-frame/doc/wifi.png &')
        os.system('sudo wifi-connect -s Bilderrahmen')
        os.system('sudo reboot')
    else:
        port = int(os.environ.get("PORT", 5600))
        socket_io.run(app, "0.0.0.0", port)


if __name__ == "__main__":
    start()
