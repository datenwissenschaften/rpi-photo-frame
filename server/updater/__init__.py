import os

import threading


class Updater:
    RUNNING = False
    THREAD = None

    def __init__(self):
        self.job()

    def job(self):
        if not self.RUNNING:
            self.RUNNING = True
            os.system("sudo /bin/bash /home/pi/rpi-photo-frame/scripts/update.sh")
            self.RUNNING = False
            self.THREAD = threading.Timer(60.0, self.job)
            self.THREAD.start()
