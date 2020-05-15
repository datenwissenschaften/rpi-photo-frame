import tempfile

from PIL import ImageOps

try:
    from StringIO import StringIO
except ImportError:
    from io import StringIO

from PIL import Image


class Cropper:
    def __init__(self):
        self.crop_x = 1280
        self.crop_y = 800

    def crop(self, image_path):
        image = Image.open(image_path)
        thumb = ImageOps.fit(image, (self.crop_x, self.crop_y), Image.ANTIALIAS)
        new_file, filename = tempfile.mkstemp()
        thumb.save(filename, 'PNG', quality=70)
        return filename
