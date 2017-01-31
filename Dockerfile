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
    ca-certificates \
    curl \
    wget \
    bzr \
    git \
    mercurial \
    openssh-client \
    subversion \
    procps \
    autoconf \
    automake \
    bzip2 \
    file \
    g++ \
    gcc \
    imagemagick \
    libbz2-dev \
    libc6-dev \
    libcurl4-openssl-dev \
    libevent-dev \
    libffi-dev \
    libgeoip-dev \
    libglib2.0-dev \
    libjpeg-dev \
    liblzma-dev \
    libmagickcore-dev \
    libmagickwand-dev \
    libmysqlclient-dev \
    libncurses-dev \
    libpng-dev \
    libpq-dev \
    libreadline-dev \
    libsqlite3-dev \
    libssl-dev \
    libtool \
    libwebp-dev \
    libxml2-dev \
    libxslt-dev \
    libyaml-dev \
    make \
    patch \
    xz-utils \
    zlib1g-dev \
    --no-install-recommends && \
    rm -rf /var/lib/apt/lists/*

# Install nodejs
RUN wget https://nodejs.org/dist/v4.7.2/node-v4.7.2-linux-armv6l.tar.gz
RUN tar -xvf node-*-linux-armv6l.tar.gz
RUN cd node-*-linux-armv6l
RUN cp -R node-*-linux-armv6l/* /usr/local/

# Test installation nodejs
RUN node -v
RUN npm -v

# Define working directory
WORKDIR /data

# Install additional dependencies
RUN pip install flask-bower
RUN npm install bower

# Copy source files
COPY src/* /data/

# Frontend dependencies
RUN node_modules/bower/bin/bower install --allow-root

RUN ls -al

# Define default command
CMD ["bash"]
