import datetime
import glob
import os
import argparse
import setproctitle
import requests
import shutil
import json

from datetime import datetime, timezone
from operator import itemgetter

import numpy
from PIL import Image
from PIL.ExifTags import TAGS
from flask import Flask, Response, render_template, request, jsonify
from flask_bower import Bower
from functional import seq

from shutil import copyfile

from astral import Astral, Location
import rpi_backlight as bl

from cachetools import cached, TTLCache
cache = TTLCache(maxsize=100, ttl=600)

setproctitle.setproctitle('rpi-photo-frame')

app = Flask(__name__, static_url_path='/static')
Bower(app)

parser = argparse.ArgumentParser(description='Starts the photo frame server.')
parser.add_argument('-d', '--directory', default='/srv/photos/')
args = parser.parse_args()

rpi_folder = '/home/pi/rpi-photo-frame'
os.makedirs('%s/cache/' % rpi_folder, exist_ok=True)

if not os.path.isfile('%s/src/config.json') or True:
    copyfile('%s/src/config.json.template' %
             rpi_folder, '%s/src/config.json' % rpi_folder)

with open('%s/src/config.json' % rpi_folder) as json_data_file:
    config = json.load(json_data_file)


@app.route('/')
def index():
    try:
        return render_template('index.html')
    except Exception:
        return "Missing frontend dependencies. Run bower install..."


@app.route('/backlight', methods=['GET'])
def get_backlight():
    return jsonify({"status": bl.get_power()})


@app.route('/backlight', methods=['POST'])
def set_backlight():
    bl.set_power(request.json['switch'])
    return jsonify({"status": bl.get_power()})


@app.route('/weather')
def weather():
    return get_weather_from_darksky()


@cached(cache)
def get_weather_from_darksky():
    return requests.get('https://api.darksky.net/forecast/9559aa7862d3ef0cf894d3593fde1b11/'
                        + str(config['location']['lat'])
                        + ',' + str(config['location']['lon'])
                        + '?lang=de&units=si').text


@app.route('/photo')
def photo():
    files = glob.glob(args.directory + '*.jp*g')

    sort = seq(files) \
        .map(lambda x: (x, extract_exif_date(x))) \
        .sorted(key=itemgetter(1), reverse=False) \
        .map(lambda x: x[0]) \
        .zip_with_index() \
        .map(lambda x: (x[0], x[1] ** 6 + 1))

    s = sort \
        .map(lambda x: x[1]) \
        .sum()

    photos = sort.map(lambda x: x[0]).to_list()

    prob = sort.map(lambda x: float(x[1]) / float(s)).to_list()

    abs_path = numpy.random.choice(photos, p=prob)

    folder_name, file_name = os.path.split(abs_path)

    l = Location()
    l.name = config['location']['name']
    l.region = config['location']['region']
    l.latitude = config['location']['lat']
    l.longitude = config['location']['lon']
    l.timezone = config['location']['timezone']
    l.elevation = config['location']['elevation']
    sun = l.sun()

    brightness = 255
    red = 0

    now = datetime.now(timezone.utc)
    if(now >= sun['dawn'] and now < sun['sunrise']):
        red = config['brightness']['dawn']['red']
        brightness = config['brightness']['dawn']['brightness']
    if(now >= sun['sunrise'] and now < sun['noon']):
        red = config['brightness']['sunrise']['red']
        brightness = config['brightness']['sunrise']['brightness']
    if(now >= sun['noon'] and now < sun['sunset']):
        red = config['brightness']['noon']['red']
        brightness = config['brightness']['noon']['brightness']
    if(now >= sun['sunset'] and now < sun['dusk']):
        red = config['brightness']['sunset']['red']
        brightness = config['brightness']['sunset']['brightness']
    if(now >= sun['dusk']):
        red = config['brightness']['dusk']['red']
        brightness = config['brightness']['dusk']['brightness']

    green = 0
    blue = -red

    bl.set_brightness(brightness, smooth=True, duration=3)

    url = 'http://localhost:8888/unsafe/trim/800x420/smart/filters:rgb(%s,%s,%s)/Downloads/%s' % (
        red, green, blue, file_name)

    response = requests.get(url, stream=True)

    with open('%s/cache/' % rpi_folder + file_name, 'wb') as out_file:
        shutil.copyfileobj(response.raw, out_file)

    f = open('%s/cache/' % rpi_folder + file_name, 'rb', buffering=0)

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


def update_config(cfg):
    with open('%s/src/config.json' % rpi_folder, 'w') as outfile:
        json.dump(cfg, outfile)


if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0')
