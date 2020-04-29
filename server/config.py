# -*- coding: UTF-8 -*-

import os

from image.store import ImageStore


class Config(object):
    DEBUG = False
    STAGING = False
    BASEDIR = os.path.abspath(os.path.dirname(__file__))
    IMAGEDIR = os.path.join(BASEDIR, "..", "doc")
    DECAY = 1
    IMAGESTORE = ImageStore(IMAGEDIR, DECAY)
    PIN = 123456
    TELEGRAM_TOKEN = None
    # os.environ['PIN'], os.environ['TELEGRAM_TOKEN']


class DevelopmentConfig(Config):
    pass


class StagingConfig(Config):
    pass


class ProductionConfig(Config):
    pass


config = {
    'dev': DevelopmentConfig,
    'staging': StagingConfig,
    'prod': ProductionConfig
}
