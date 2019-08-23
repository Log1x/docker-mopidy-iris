FROM jfloff/alpine-python:2.7

ENV PUID="${PUID:-1000}"
ENV PGID="${PGID:-1000}"
ENV PYTHONPATH="/usr/local/lib/python2.7/site-packages:/usr/lib/python2.7/site-packages"

WORKDIR /mopidy

RUN \
  echo "* Updating Package Repositories" \
    && echo 'http://dl-cdn.alpinelinux.org/alpine/edge/main' >> /etc/apk/repositories \
    && echo 'http://dl-cdn.alpinelinux.org/alpine/edge/community' >> /etc/apk/repositories \
    && echo 'http://dl-cdn.alpinelinux.org/alpine/edge/testing' >> /etc/apk/repositories \
    && apk upgrade --no-cache \
    && pip install --upgrade pip \
  && echo "* Installing Runtime Packages" \
    && apk add -U --no-cache \
      libcdio \
      libcaca \
      libxml2-dev \
      libxslt-dev \
      libvpx \
      libffi-dev \
      openssl-dev \
      v4l-utils-libs \
      python2-dev \
      py2-crypto \
      py2-gst \
      py-gobject \
      mailcap \
      su-exec \
      icecast \
      gstreamer \
      gst-plugins-base \
      gst-plugins-good \
      gst-plugins-ugly \
    && pip install -U \
      pyopenssl \
      youtube-dl \
  && echo "* Installing Mopidy + Extensions" \
    && pip install -U \
      Mopidy \
      Mopidy-Iris \
      Mopidy-SoundCloud \
      Mopidy-GMusic \
      Mopidy-Local-Images \
      Mopidy-Local-SQLite \
  && echo "* Creating Mopidy User" \
    && addgroup -g ${PGID} mopidy \
    && adduser -h /mopidy -s /bin/sh -D -G mopidy -u ${PUID} mopidy \
  && echo "* Cleaning up" \
    && rm -f /var/cache/apk/* \
  && echo "* Ready to start Mopidy" \
  && sleep 1

COPY   root/ /
RUN    chmod +x /usr/local/bin/run.sh
EXPOSE 6600 6680 8000 5555/udp
VOLUME /data /music /playlists

LABEL description "Open source media server"

CMD ["run.sh"]
