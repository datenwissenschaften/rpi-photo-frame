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
    curl \
    wget \
    --no-install-recommends && \
    rm -rf /var/lib/apt/lists/*

# Install nodejs
RUN wget https://nodejs.org/dist/v4.7.2/node-v4.7.2-linux-armv6l.tar.gz
RUN tar -xvf node-*-linux-armv6l.tar.gz
RUN cd node-*-linux-armv6l
RUN sudo cp -R * /usr/local/

# Test installation nodejs
RUN node -v
RUN npm -v

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
