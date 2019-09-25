import datetime
import glob
import json
import os
import shutil
from datetime import datetime, timezone
from operator import itemgetter
from shutil import copyfile

import numpy
import requests
# import rpi_backlight as bl
import setproctitle
from PIL import Image
from PIL.ExifTags import TAGS
from astral import Location
from cachetools import cached, TTLCache
from flask import Flask, Response, render_template, request, jsonify
from flask_bower import Bower
from functional import seq
from jsonmerge import merge
from flask_socketio import SocketIO, send, emit

# Cache configuration
cache = TTLCache(maxsize=100, ttl=600)

# Process name for os
setproctitle.setproctitle('rpi-photo-frame')

# Flask configuration
app = Flask(__name__, static_url_path='/static')
app.config['SECRET_KEY'] = 'secret!'
Bower(app)
socketio = SocketIO(app)

# Global variables
current_photo = ''

# Make working folders and files
working_dir = os.path.dirname(os.path.realpath(__file__))
if not os.path.isfile('%s/config.json' % working_dir):
    copyfile('%s/config.json.template' %
             working_dir, '%s/config.json' % working_dir)
else:
    pass


# Read / write / merge config file
def update_config(cfg):
    with open('%s/config.json' % working_dir, 'w') as outfile:
        json.dump(cfg, outfile, indent=4, sort_keys=True)


with open('%s/config.json.template' % working_dir, 'r+') as base, open('%s/config.json' % working_dir, 'r+') as head:
    config_template = json.load(base)
    current_config = json.load(head)
    config = merge(config_template, current_config)
    update_config(config)


@app.route('/')
def index():
    try:
        return render_template('index.html')
    except Exception:
        return "Missing frontend dependencies. Run bower install..."


# @app.route('/backlight', methods=['GET'])
# def get_backlight():
#    return jsonify({"status": bl.get_power()})


# @app.route('/backlight', methods=['POST'])
# def set_backlight():
#    bl.set_power(request.json['switch'])
#    return jsonify({"status": bl.get_power()})


@app.route('/weather')
def weather():
    return get_weather_from_darksky()


@cached(cache)
def get_weather_from_darksky():
    return requests.get('https://api.darksky.net/forecast/9559aa7862d3ef0cf894d3593fde1b11/'
                        + str(config['location']['lat'])
                        + ',' + str(config['location']['lon'])
                        + '?lang=de&units=si').text


@app.route('/delete', methods=['DELETE'])
def delete_current():
    os.remove(working_dir + '/../images/' + current_photo)
    socketio.emit('command', {'data': 'next'})
    return jsonify({'status': 200})


@app.route('/next/<filename>', methods=['GET'])
def show_next(filename):
    socketio.emit('image', {'data': filename + '.jpg'})
    return jsonify({'status': 200})


# noinspection PyUnresolvedReferences
@app.route('/image/<filename>')
def image(filename):
    # Location for the blue filter
    loc = Location()
    loc.name = config['location']['name']
    loc.region = config['location']['region']
    loc.latitude = config['location']['lat']
    loc.longitude = config['location']['lon']
    loc.timezone = config['location']['timezone']
    loc.elevation = config['location']['elevation']
    sun = loc.sun()

    # Full brightness and all colors as fallback
    brightness = 255
    red = 0
    green = 0
    blue = 0

    # Set brightness and redness based on the sun
    now = datetime.now(timezone.utc)
    if now < sun['dawn']:
        red = config['brightness']['dawn']['red']
        brightness = config['brightness']['dawn']['brightness']
        blue = -red
    if sun['dawn'] <= now < sun['sunrise']:
        red = config['brightness']['dawn']['red']
        brightness = config['brightness']['dawn']['brightness']
        blue = -red
    if sun['sunrise'] <= now < sun['noon']:
        red = config['brightness']['sunrise']['red']
        brightness = config['brightness']['sunrise']['brightness']
        blue = -red
    if sun['noon'] <= now < sun['sunset']:
        red = config['brightness']['noon']['red']
        brightness = config['brightness']['noon']['brightness']
        blue = -red
    if sun['sunset'] <= now < sun['dusk']:
        red = config['brightness']['sunset']['red']
        brightness = config['brightness']['sunset']['brightness']
        blue = -red
    if now >= sun['dusk']:
        red = config['brightness']['dusk']['red']
        brightness = config['brightness']['dusk']['brightness']
        blue = -red

    # bl.set_brightness(brightness, smooth=True, duration=3)

    # Write global photo to current
    global current_photo
    current_photo = filename

    # Get processed image from thumbor
    url = 'http://localhost:8888/unsafe/trim/1280x800/smart/filters:rgb(%s,%s,%s)/rpi-photo-frame/images/%s' % (
        red, green, blue, filename)
    response = requests.get(url, stream=True)

    # Cache image locally and show the processed image
    with open('/tmp/_img.jpg', 'wb') as f:
        shutil.copyfileobj(response.raw, f)
    return Response(open('/tmp/_img.jpg', 'rb', buffering=0).readall(), mimetype='image/jpeg')


# noinspection PyProtectedMember
# noinspection PyBroadException
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


@app.route('/random')
def random():
    files = glob.glob(working_dir + '/../images/*.jp*g')

    print(files)

    # Decay factor for the weighted random choice
    decay_factor = int(config['decay'])

    # Sort images by date
    sort = seq(files) \
        .map(lambda x: (x, extract_exif_date(x))) \
        .sorted(key=itemgetter(1), reverse=False) \
        .map(lambda x: x[0]) \
        .zip_with_index() \
        .map(lambda x: (x[0], x[1] ** decay_factor + 1))

    # Sum off all images
    s = sort \
        .map(lambda x: x[1]) \
        .sum()

    # All photos
    photos = sort.map(lambda x: x[0]).to_list()

    # Generate probabilities based on date
    prob = sort.map(lambda x: float(x[1]) / float(s)).to_list()

    # Get weighted random image, newer images are more likely to show up
    abs_path = numpy.random.choice(photos, p=prob)

    folder_name, file_name = os.path.split(abs_path)

    return jsonify({'folder_name': folder_name, 'file_name': file_name})


if __name__ == '__main__':
    socketio.run(app, debug=False, host='0.0.0.0')
