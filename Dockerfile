FROM ubuntu:22.04

ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Australia/Brisbane

RUN apt-get update && apt-get -y install cmake protobuf-compiler ca-certificates curl npm libsdl2-dev \
    libsdl2-ttf-dev libsdl2-image-dev libsdl2-mixer-dev libportmidi-dev libfreetype6-dev \
    wget build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev \
    && rm -rf /var/lib/apt/lists/*

RUN apt-get remove -y libnode-dev
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - &&\
    apt-get install -y nodejs
RUN npm install -g npm@10.9.0

RUN wget https://www.python.org/ftp/python/3.12.7/Python-3.12.7.tgz
RUN tar -xvf Python-3.12.7.tgz
RUN cd Python-3.12.7 && ./configure --enable-optimizations --with-ensurepip=install && make && make install

RUN ln -s /usr/local/bin/python3 /usr/local/bin/python
RUN ln -s /usr/local/bin/pip3 /usr/local/bin/pip

RUN pip install --upgrade pip
RUN pip install waitress pygame
RUN pip install gunicorn

RUN update-ca-certificates

# set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

EXPOSE 3000
CMD gunicorn --bind 0.0.0.0:5000 'app.factory:create_app()' & node server.js
