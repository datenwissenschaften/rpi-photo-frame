import datetime
import glob
import os
import argparse
import setproctitle
import requests
import shutil

from operator import itemgetter

import numpy
from PIL import Image
from PIL.ExifTags import TAGS
from flask import Flask, Response, render_template
from flask_bower import Bower
from functional import seq

from cachetools import cached, TTLCache
cache = TTLCache(maxsize=100, ttl=3600)

setproctitle.setproctitle('rpi-photo-frame')

app = Flask(__name__, static_url_path='/static')
Bower(app)

parser = argparse.ArgumentParser(description='Starts the photo frame server.')
parser.add_argument('-d', '--directory', default='/srv/photos/')
args = parser.parse_args()


@app.route('/')
def index():
    try:
        return render_template('index.html')
    except Exception:
        return "Missing frontend dependencies. Run bower install..."


@app.route('/status')
def status():
    return "200"


@app.route('/weather')
def weather():
    return get_weather_from_darksky()


@cached(cache)
def get_weather_from_darksky():
    return requests.get('https://api.darksky.net/forecast/9559aa7862d3ef0cf894d3593fde1b11/48.199760,11.308920?lang=de&units=si').text


@app.route('/photo')
def photo():
    print(args)
    files = glob.glob(args.directory + '*.jp*g')

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

    print(photos)

    prob = sort.map(lambda x: float(x[1]) / float(s)).to_list()

    print(prob)

    # abs_path = numpy.random.choice(photos, p=prob)
    abs_path = numpy.random.choice(photos)

    url = 'http://localhost:8888/unsafe/800x480/Downloads/IMG_0568.jpg'
    response = requests.get(url, stream=True)
    
    with open('./cache/' + os.path.basename(abs_path), 'wb') as out_file:
        shutil.copyfileobj(response.raw, out_file)
    del response

    f = open('./cache/' + os.path.basename(abs_path), 'rb', buffering=0)

    try:
        return Response(f.readall(), mimetype='image/jpeg')
    except Exception:
        return Response(f.readlines(), mimetype='image/jpeg')


def extract_exif_date(photo):
    ret = {}

    im = Image.open(photo)

    exif_data = im._getexif()

    try:
        for tag, value in exif_data.items():
            decoded = TAGS.get(tag, tag)
            ret[decoded] = value

        datetime_object = datetime.datetime.strptime(
            ret.get('DateTime'), '%Y:%m:%d %H:%M:%S'
        )

        unix_time = datetime_object.timestamp()

    except Exception:
        # File modification date as fallback
        unix_time = os.path.getmtime(photo)

    return unix_time


def __init():
    if not os.path.exists('./cache/'):
        os.makedirs('./cache/')


if __name__ == '__main__':
    __init()
    app.run(debug=True, host='0.0.0.0')
