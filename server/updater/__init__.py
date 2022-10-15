import io
import os

import threading


class Updater:
    RUNNING = False
    THREAD = None

    def __init__(self):
        self.job()

    @staticmethod
    def is_raspberrypi():
        # noinspection PyBroadException
        try:
            with io.open('/sys/firmware/devicetree/base/model', 'r') as m:
                if 'raspberry pi' in m.read().lower():
                    return True
        except Exception:
            pass
        return False

    def job(self):
        if not self.RUNNING and self.is_raspberrypi():
            self.RUNNING = True
            os.system("sudo /bin/bash /home/pi/rpi-photo-frame/scripts/update.sh")
            self.RUNNING = False
            self.THREAD = threading.Timer(60.0, self.job)
            self.THREAD.start()
