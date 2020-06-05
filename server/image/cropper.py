import os
import tempfile


class Cropper:
    def __init__(self):
        self.crop_x = 1280
        self.crop_y = 800

    def crop(self, image_path):
        os.system("smartcroppy --width " + str(self.crop_x) + " --height "
                  + str(self.crop_y) + " " + image_path + " " + tempfile.gettempdir() + "/_working_image_.jpeg")

        return tempfile.gettempdir() + "/_working_image_.jpeg"
