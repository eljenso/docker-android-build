FROM buildpack-deps:jessie

MAINTAINER Jens Böttcher <eljenso.boettcher@gmail.com>

##
## Install Java & 32bit support for Android SDK
##
RUN echo 'deb http://http.debian.net/debian jessie-backports main' >> /etc/apt/sources.list && \
	dpkg --add-architecture i386 && \
	DEBIAN_FRONTEND=noninteractive apt-get update -q && \
	apt-get install -qy --no-install-recommends openjdk-8-jdk libstdc++6:i386 libgcc1:i386 zlib1g:i386 libncurses5:i386

##
## Install Android SDK
##
# Set correct environment variables.
ENV ANDROID_SDK_FILE android-sdk_r24.4.1-linux.tgz
ENV ANDROID_SDK_URL http://dl.google.com/android/$ANDROID_SDK_FILE

# Install Android SDK
ENV ANDROID_HOME /usr/local/android-sdk-linux
RUN cd /usr/local && \
    wget $ANDROID_SDK_URL && \
    tar -xzf $ANDROID_SDK_FILE && \
    chgrp -R users $ANDROID_HOME && \
    chmod -R 0775 $ANDROID_HOME && \
    rm $ANDROID_SDK_FILE

# Install android tools and system-image.
ENV PATH $PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools:$ANDROID_HOME/build-tools/24.0.0
RUN echo "y" | android update sdk \
    --no-ui \
    --force \
    --all \
    --filter platform-tools,android-24,build-tools-24.0.0,extra-android-support,extra-android-m2repository,extra-google-m2repository

# Clean up when done.
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
