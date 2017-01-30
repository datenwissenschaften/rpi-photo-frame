FROM resin/rpi-raspbian:wheezy

MAINTAINER Martin Franke <martin.franke@me.com>

# Install dependencies from debian packages
RUN apt-get update && apt-get install -y \
    python \
    python-dev \
    python-virtualenv \
    python-pip \
    python-numpy \
    python-flask \
    python-pillow \
    nodejs \
    --no-install-recommends && \
    rm -rf /var/lib/apt/lists/*

# Compile additional dependencies
RUN pip install flask-bower
RUN npm install -g bower

# Define working directory
WORKDIR /data
COPY * /data/

# Frontend dependencies
RUN bower install

# Define default command
CMD ["bash"]
