FROM ubuntu:trusty
ENV DEBIAN_FRONTEND=noninteractive \
    MOZ_HEADLESS=1
RUN gpg --keyserver keyserver.ubuntu.com --recv-keys DB82666C \
 && gpg --export DB82666C | apt-key add -
RUN echo deb http://ppa.launchpad.net/fkrull/deadsnakes/ubuntu trusty main >> /etc/apt/sources.list \
 && echo deb-src http://ppa.launchpad.net/fkrull/deadsnakes/ubuntu trusty main >> /etc/apt/sources.list
RUN apt-get update \
 && apt-get install -y \
    git \
    curl \
    firefox \
    python2.7-dev \
 && rm -rf /var/lib/apt/lists/*
RUN curl -fsSL https://bootstrap.pypa.io/get-pip.py | python2.7
WORKDIR /src
COPY requirements.txt /src
RUN pip install -r requirements.txt
ENV FIREFOX_VERSION=57.0b14
RUN curl -fsSLo /tmp/firefox.tar.bz2 https://download-installer.cdn.mozilla.net/pub/firefox/releases/$FIREFOX_VERSION/linux-x86_64/en-US/firefox-$FIREFOX_VERSION.tar.bz2 \
  && apt-get -y purge firefox \
  && rm -rf /opt/firefox \
  && tar -C /opt -xjf /tmp/firefox.tar.bz2 \
  && rm /tmp/firefox.tar.bz2 \
  && mv /opt/firefox /opt/firefox-$FIREFOX_VERSION \
&& ln -fs /opt/firefox-$FIREFOX_VERSION/firefox /usr/bin/firefox
ENV GECKODRIVER_VERSION=0.19.1
RUN curl -fsSLo /tmp/geckodriver.tar.gz https://github.com/mozilla/geckodriver/releases/download/v$GECKODRIVER_VERSION/geckodriver-v$GECKODRIVER_VERSION-linux64.tar.gz \
  && rm -rf /opt/geckodriver \
  && tar -C /opt -zxf /tmp/geckodriver.tar.gz \
  && rm /tmp/geckodriver.tar.gz \
  && mv /opt/geckodriver /opt/geckodriver-$GECKODRIVER_VERSION \
  && chmod 755 /opt/geckodriver-$GECKODRIVER_VERSION \
&& ln -fs /opt/geckodriver-$GECKODRIVER_VERSION /usr/bin/geckodriver
COPY . /src
CMD pytest
