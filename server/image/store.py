import datetime
import glob
import os
from operator import itemgetter

import numpy
from PIL.ExifTags import TAGS
from functional import seq

try:
    from StringIO import StringIO
except ImportError:
    from io import StringIO

from PIL import Image


class ImageStore:
    def __init__(self, image_dir, img_decay):
        self._image_dir = image_dir
        self._decay = img_decay
        self.current_image = ""

    def _extract_date(self, image_path):
        im = Image.open(image_path)
        exif_data = im.getexif()
        try:
            ret = {}
            for tag, value in exif_data.items():
                decoded = TAGS.get(tag, tag)
                ret[decoded] = value
            datetime_object = datetime.datetime.strptime(
                ret.get("DateTime"), "%Y:%m:%d %H:%M:%S"
            )
            unix_time = datetime_object.timestamp()
        except:
            unix_time = os.path.getmtime(image_path)
        return int(unix_time)

    def get_weighted_random_image(self):
        images = glob.glob(self._image_dir + "/*")
        images_by_date = seq(images) \
            .map(lambda x: (x, self._extract_date(x))) \
            .sorted(key=itemgetter(1), reverse=False) \
            .map(lambda x: x[0]) \
            .zip_with_index() \
            .map(lambda x: (x[0], x[1] ** self._decay + 1))

        sum_all_decay = images_by_date \
            .map(lambda x: x[1]) \
            .sum()

        probablities_by_decay = images_by_date.map(lambda x: float(x[1]) / float(sum_all_decay)).to_list()

        self.current_image = numpy.random.choice(
            images_by_date.map(lambda x: x[0]).to_list(),
            p=probablities_by_decay
        )

        return self.current_image
