# -*- coding: UTF-8 -*-

import os
import socket

__version__ = '1.0.0'

from routes import create_app

(socket_io, app) = create_app(os.getenv("PHOTO_FRAME_ENV", "dev").lower())


def is_connected():
    try:
        socket.create_connection(("www.google.com", 80))
        return True
    except OSError:
        pass
    return False


def start():
    if not is_connected():
        os.system('sudo wifi-connect')
        os.system('sudo reboot')
    else:
        port = int(os.environ.get("PORT", 5600))
        socket_io.run(app, "0.0.0.0", port)


if __name__ == "__main__":
    start()
