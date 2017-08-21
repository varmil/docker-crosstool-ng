FROM alpine:3.5
MAINTAINER Andrew Dunham <andrew@du.nham.ca>

# Create user for build
RUN mkdir /home/user && \
    adduser -u 1001 -h /home/user -s /bin/sh -D user && \
    chown -R user:user /home/user

# Install required packages
RUN apk update && \
    apk add \
        autoconf \
        automake \
        bison \
        build-base \
        curl \
        flex \
        gawk \
        git \
        gperf \
        help2man \
        libc-dev \
        libtool \
        ncurses-dev \
        patch \
        sed \
        texinfo \
        unzip \
        wget \
        xz

# Build/install crosstool-ng
RUN cd /root && \
    git clone https://github.com/crosstool-ng/crosstool-ng.git && \
    cd crosstool-ng && \
    git checkout 434c205e89f9d4e06d0210ae8504fb6a88a11d00 && \
    ./bootstrap && \
    ./configure --prefix=/usr && \
    make && \
    make install && \
    cd /root && \
    rm -rf crosstool-ng

# All further commands are run as the build user
WORKDIR /home/user
USER user
