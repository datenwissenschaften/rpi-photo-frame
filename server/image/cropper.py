import tempfile

from smartcrop import smart_crop




class Cropper:
    def __init__(self):
        self.crop_x = 1360
        self.crop_y = 768

    def crop(self, image_path):
        smart_crop(image_path, self.crop_x, self.crop_y, tempfile.gettempdir() + "/_working_image_.jpeg", False)
        return tempfile.gettempdir() + "/_working_image_.jpeg"
