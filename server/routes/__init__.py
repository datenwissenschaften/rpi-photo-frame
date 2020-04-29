# -*- coding: UTF-8 -*-
import os

from flask import Flask, render_template, send_file, jsonify

__version__ = '1.0.0'

from config import config
from requests import get
from flask_caching import Cache
from flask_socketio import SocketIO

from image.cropper import Cropper


def create_app(config_type: str):
    app = Flask(
        __name__,
        static_url_path='/static',
        static_folder='../static',
        template_folder='../templates'
    )

    cache = Cache(app, config={'CACHE_TYPE': 'simple'})
    socket_io = SocketIO(app)

    app_config = config[config_type]

    @app.route('/')
    def index():
        return render_template('index.html')

    @app.route('/weather')
    @cache.cached(timeout=300)
    def weather():
        ip = get('https://api.ipify.org').text
        location = get('http://api.ipstack.com/%s?access_key=95d4301a153ec3361617942d116c8ddb&format=1' % ip).json()
        darksky = get('https://api.darksky.net/forecast/9559aa7862d3ef0cf894d3593fde1b11/%s,%s?lang=de&units=si' %
                      (location['latitude'], location['longitude'])).json()
        return darksky

    @app.route('/random')
    def random():
        return send_file(
            Cropper().crop(
                app_config.IMAGESTORE.get_weighted_random_image()
            ), mimetype='image/jpeg'
        )

    @app.route('/delete', methods=['DELETE'])
    def delete_current():
        os.remove(app_config.IMAGESTORE.current_image)
        socket_io.emit('command', {'data': 'next'})
        return jsonify({'status': 200})

    @app.route('/next', methods=['GET'])
    def show_next_random():
        socket_io.emit('command', {'data': 'next'})
        return jsonify({'status': 200})

    return socket_io, app
