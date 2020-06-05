# -*- coding: UTF-8 -*-

import os

from image.store import ImageStore
from updater import Updater


class Config:
    DEBUG = False
    STAGING = False
    BASEDIR = os.path.abspath(os.path.dirname(__file__))


class DevelopmentConfig(Config):
    IMAGEDIR = os.environ.get('IMAGEDIR') or os.path.join(Config.BASEDIR, "..", "doc")
    DECAY = os.environ.get('DECAY') or 1
    IMAGESTORE = ImageStore(IMAGEDIR, int(DECAY))
    PIN = os.environ.get('PIN')
    TELEGRAM_TOKEN = os.environ.get('TELEGRAM_TOKEN')
    UPDATER = Updater()


class StagingConfig(Config):
    pass


class ProductionConfig(Config):
    pass


def get_config(stage):
    if stage == 'dev':
        return DevelopmentConfig
    if stage == 'staging':
        return StagingConfig
    if stage == 'prod':
        return ProductionConfig
