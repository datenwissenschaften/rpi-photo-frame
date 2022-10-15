import os
import shutil

import requests
from screeninfo import get_monitors


class Cropper:
    def __init__(self):
        width, height = self.get_display_size()
        self.crop_x = width
        self.crop_y = height

    @staticmethod
    def get_display_size():
        width = 0
        height = 0
        for m in get_monitors():
            width = m.width
            height = m.height
        return width, height

    def crop(self, image_path):
        file_name = os.path.basename(image_path)
        url = f'http://localhost:8888/unsafe/{self.crop_x}x{self.crop_y}/{file_name}'
        response = requests.get(url, stream=True)
        with open(f'/mnt/ramdisk/working_image.jpeg', 'wb') as out_file:
            shutil.copyfileobj(response.raw, out_file)
        del response
        return "/mnt/ramdisk/working_image.jpeg"
