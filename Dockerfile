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
      coreutils \
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
      gstreamer \
      gst-plugins-base \
      gst-plugins-good \
      gst-plugins-ugly \
    && pip install -U \
      pyopenssl \
      youtube-dl \
      pyasn1 \
    && wget -c https://mopidy.github.io/libspotify-archive/libspotify-12.1.51-Linux-x86_64-release.tar.gz -O - | tar -xzC /tmp \
      && make install -C /tmp/libspotify-12.1.51-Linux-x86_64-release prefix=/usr/local || true \
  && echo "* Installing Mopidy + Extensions" \
    && pip install -U \
      Mopidy \
      Mopidy-Iris \
      Mopidy-Spotify-Web \
      Mopidy-SoundCloud \
      Mopidy-GMusic \
      Mopidy-Local-Images \
      Mopidy-Local-SQLite \
  && echo "* Creating Mopidy User" \
    && addgroup -g ${PGID} mopidy \
    && adduser -h /mopidy -s /bin/sh -D -G mopidy -u ${PUID} mopidy \
  && echo "* Cleaning up" \
    && rm -rf /var/cache/apk/* \
    && rm -rf /tmp/* \
  && echo "* Ready to start Mopidy" \
  && sleep 1

COPY   root/ /
RUN    chmod +x /usr/local/bin/run.sh
RUN    chmod +x /usr/local/bin/entrypoint.sh
EXPOSE 6600 6680 8000 5555/udp
VOLUME /data /music /playlists

LABEL description "Open source media server"

ENTRYPOINT ["entrypoint.sh"]
CMD ["run.sh"]
