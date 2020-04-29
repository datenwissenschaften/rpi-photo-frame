# -*- coding: UTF-8 -*-

import os

from image.store import ImageStore


class Config:
    DEBUG = False
    STAGING = False
    BASEDIR = os.path.abspath(os.path.dirname(__file__))


class DevelopmentConfig(Config):
    IMAGEDIR = os.path.join(Config.BASEDIR, "..", "doc")
    DECAY = 1
    IMAGESTORE = ImageStore(IMAGEDIR, DECAY)
    PIN = 123456
    TELEGRAM_TOKEN = None


class StagingConfig(Config):
    pass


class ProductionConfig(Config):
    IMAGEDIR = os.environ.get('IMAGEDIR') or Config.BASEDIR
    PIN = os.environ.get('PIN')
    TELEGRAM_TOKEN = os.environ.get('TELEGRAM_TOKEN')
    DECAY = 1
    IMAGESTORE = ImageStore(IMAGEDIR, DECAY)


def get_config(stage: str):
    if stage == 'dev':
        return DevelopmentConfig
    if stage == 'staging':
        return StagingConfig
    if stage == 'prod':
        return ProductionConfig
