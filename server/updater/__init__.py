import multiprocessing
import os
import time


class Updater:
    RUNNING = True

    def __init__(self):
        multiprocessing.Process(target=self.run())

    def job(self):
        self.RUNNING = False
        os.system("sudo /bin/bash /home/pi/rpi-photo-frame/scripts/update.sh")
        time.sleep(60)
        self.RUNNING = True
        multiprocessing.Process(target=self.run())

    def run(self):
        while self.RUNNING:
            self.job()
