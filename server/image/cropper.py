import tempfile

import cv2

try:
    from StringIO import StringIO
except ImportError:
    from io import StringIO
from Katna.image import Image as IM


class Cropper:
    def __init__(self):
        self.crop_x = 1280
        self.crop_y = 800

    def crop(self, image_path):
        img_module = IM()

        crop_list = img_module.crop_image(
            file_path=image_path,
            crop_width=self.crop_x,
            crop_height=self.crop_y,
            num_of_crops=3,
            down_sample_factor=8
        )

        for counter, crop in enumerate(crop_list):
            img_module.save_crop_to_disk(
                crop,
                cv2.imread(image_path),
                file_path=tempfile.gettempdir(),
                file_name="_working_image_",
                file_ext=".jpeg",
            )

        return tempfile.gettempdir() + "/_working_image_.jpeg"
