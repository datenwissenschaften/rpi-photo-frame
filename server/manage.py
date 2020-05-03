# -*- coding: UTF-8 -*-

import os

__version__ = '1.0.0'

from routes import create_app

(socket_io, app) = create_app(os.getenv("PHOTO_FRAME_ENV", "dev").lower())


def start():
    port = int(os.environ.get("PORT", 5600))
    socket_io.run(app, "0.0.0.0", port)


if __name__ == "__main__":
    start()