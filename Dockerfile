FROM resin/rpi-raspbian:jessie

MAINTAINER Martin Franke <martin.franke@me.com>

# Install dependencies from debian packages
RUN apt-get update && apt-get install -y \
    python \
    python-dev \
    python-virtualenv \
    python-pip \
    python-numpy \
    python-flask \
    python-pil \
    --no-install-recommends && \
    rm -rf /var/lib/apt/lists/*

# Install nodejs
RUN curl -sL https://deb.nodesource.com/setup_7.x | sudo -E bash -
RUN apt-get install -y nodejs

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
