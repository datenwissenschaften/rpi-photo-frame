# -*- coding: UTF-8 -*-
import os
import json

from pathlib import Path
from multiprocessing import Process

from flask import Flask, render_template, send_file, jsonify
from flask_caching import Cache
from flask_socketio import SocketIO
from requests import get

from bot import PhotoBot
from config import get_config
from image.cropper import Cropper


def create_app(stage):
    app = Flask(
        __name__,
        static_url_path='/static',
        static_folder='../static',
        template_folder='../templates'
    )

    cache = Cache(app, config={'CACHE_TYPE': 'simple'})
    socket_io = SocketIO(app)

    app_config = get_config(stage)

    Process(target=PhotoBot, args=(app_config.IMAGEDIR, app_config.PIN, app_config.TELEGRAM_TOKEN)).start()

    @app.route('/')
    @cache.cached(timeout=60 * 60)
    def index():
        return render_template('index.html')

    @app.route('/weather')
    @cache.cached(timeout=60 * 60)
    def weather():
        if os.getenv("IPSTACK"):
            if Path('/tmp/LOCATION').is_file():
                f = open('/tmp/LOCATION')
                location = json.load(f)
                f.close()
            else:
                ip = get('https://api.ipify.org').text
                location = get('http://api.ipstack.com/%s?access_key=%s&format=1' % (ip, os.getenv("IPSTACK"))).json()
                with open('/tmp/LOCATION', 'w') as f:
                    json.dump(location, f, ensure_ascii=False)
            darksky = get('https://api.darksky.net/forecast/%s/%s,%s?lang=de&units=si' %
                          (os.getenv("DARKSKY"), location['latitude'], location['longitude'])).json()
            return darksky
        else:
            return {"currently": {"temperature": 99.9, "icon": "day-cloudy"}}

    @app.route('/random')
    def random():
        return send_file(
            Cropper().crop(
                app_config.IMAGESTORE.get_weighted_random_image()
            ), mimetype='image/jpeg'
        )

    @app.route('/delete', methods=['DELETE', 'GET'])
    def delete_current():
        os.remove(app_config.IMAGESTORE.current_image)
        socket_io.emit('command', {'data': 'next'})
        return jsonify({'status': 200})

    @app.route('/next', methods=['GET'])
    def show_next_random():
        socket_io.emit('command', {'data': 'next'})
        return jsonify({'status': 200})

    @app.route('/next/<filename>', methods=['GET'])
    def show(filename):
        socket_io.emit('image', {'data': filename})
        return jsonify({'status': 200})

    @app.route('/toast/<message>', methods=['GET'])
    def toast(message):
        socket_io.emit('toast', {'data': message})
        return jsonify({'status': 200})

    @app.route('/image/<filename>', methods=['GET'])
    def show_image(filename):
        return send_file(
            Cropper().crop(
                app_config.IMAGEDIR + "/" + filename
            ), mimetype='image/jpeg'
        )

    return socket_io, app
