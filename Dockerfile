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
      su-exec \
      libxml2-dev \
      libxslt-dev \
      libffi-dev \
      openssl-dev \
      python2-dev \
      libcdio \
      libcaca \
      libvpx \
      v4l-utils-libs \
      py2-crypto \
      py2-gst \
      py-gobject \
      mailcap \
      icecast \
      snapcast-server \
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
    && echo "mopidy ALL=NOPASSWD: /usr/local/lib/pyenv/versions/2.7.16/lib/python2.7/site-packages/mopidy_iris/system.sh" >> /etc/sudoers \
  && echo "* Cleaning up" \
  && apk --purge del \
      libxml2-dev \
      libxslt-dev \
      libffi-dev \
      openssl-dev \
      python2-dev \
    && rm -rf /var/cache/apk/* \
    && rm -rf /tmp/* \
  && echo "* Ready to start Mopidy" \
  && sleep 1

COPY   root/ /
RUN    chmod +x /usr/local/bin/run.sh
RUN    chmod +x /usr/local/bin/entrypoint.sh
EXPOSE 1704 1705 6600 6680 8000
VOLUME /data /music /playlists

LABEL description "Open source media server"

ENTRYPOINT ["entrypoint.sh"]
CMD ["run.sh"]
