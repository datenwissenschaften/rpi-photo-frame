import datetime
import glob
import os
from operator import itemgetter

import numpy
from PIL import Image
from PIL.ExifTags import TAGS
from flask import Flask, Response, render_template
from flask.ext.bower import Bower
from functional import seq

app = Flask(__name__, static_url_path='/static')
Bower(app)


@app.route('/')
def index():
    return render_template('index.html')


@app.route('/status')
def status():
    return 200


@app.route('/photo')
def photo():
    files = glob.glob('/srv/photos/*.jp*g')

    if not files:
        files = glob.glob('./cache/*.*')

    seq_files = seq(files)

    w = 1920
    h = 1080

    sort = seq_files \
        .map(lambda x: (x, extract_exif_date(x))) \
        .sorted(key=itemgetter(1), reverse=False) \
        .map(lambda x: x[0]) \
        .zip_with_index() \
        .map(lambda x: (x[0], x[1] ** 6 + 1))

    s = sort \
        .map(lambda x: x[1]) \
        .sum()

    photos = sort.map(lambda x: x[0]).to_list()

    prob = sort.map(lambda x: x[1] / s).to_list()

    abs_path = numpy.random.choice(photos, p=prob)

    if not os.path.exists('./cache/' + os.path.basename(abs_path)):
        im = Image.open(abs_path)

        exif = im.info['exif']

        im.thumbnail((w, h), Image.ANTIALIAS)
        im.save('./cache/' + os.path.basename(abs_path),
                format='JPEG', exif=exif)

    f = open('./cache/' + os.path.basename(abs_path), 'rb', buffering=0)

    return Response(f.readall(), mimetype='image/jpeg')


def extract_exif_date(photo):
    ret = {}

    im = Image.open(photo)

    exif_data = im._getexif()

    try:
        for tag, value in exif_data.items():
            decoded = TAGS.get(tag, tag)
            ret[decoded] = value
    except Exception:
        pass

    try:

        datetime_object = datetime.datetime.strptime(
            ret.get('DateTime'), '%Y:%m:%d %H:%M:%S'
        )

        unix_time = datetime_object.timestamp()

    except Exception:
        unix_time = 1.0

    return unix_time


def __init():
    if not os.path.exists('./cache/'):
        os.makedirs('./cache/')


if __name__ == '__main__':
    __init()
    app.run(debug=True, host='0.0.0.0')