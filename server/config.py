# -*- coding: UTF-8 -*-

import os

from image.store import ImageStore


class Config(object):
    DEBUG = False
    STAGING = False
    BASEDIR = os.path.abspath(os.path.dirname(__file__))
    IMAGEDIR = os.path.join(BASEDIR, "..", "doc")
    DECAY = 4
    IMAGESTORE = ImageStore(IMAGEDIR, DECAY)


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
