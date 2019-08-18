FROM jfloff/alpine-python:2.7
MAINTAINER Log1x <github@log1x.com>

ENV PGID=1000 PUID=1000
WORKDIR /mopidy-iris

RUN \
  echo "* Installing Runtime Packages" \
    && echo "@edge https://nl.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories \
    && echo "@commuedge https://nl.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories \
    && apk add --no-cache \
      libvpx@edge \
      libcdio@edge \
      libfii@edge \
      gst-plugins-good@commuedge \
      gst-plugins-ugly@commuedge \
      py2-gst@commuedge \
      su-exec@edge \
      tini@commuedge \
    && pip install -U \
      pyopenssl \
      youtube-dl \
  && echo "* Installing Mopidy + Extensions" \
    && pip install -U \
      Mopidy \
      Mopidy-SoundCloud \
      Mopidy-Spotify \
      Mopidy-YouTube \
      Mopidy-Local-Images \
      Mopidy-Local-SQLite \
  && echo "* Installing Iris" \
    && pip install -U Mopidy-Iris \
  && echo "* Creating Mopidy User" \
    && addgroup -g ${PGID} mopidy \
    && adduser -h /mopidy -s /bin/sh -D -G sudo,mopidy -u ${PUID} mopidy \
  && echo "* Fixing privileges" \
    && chown -R mopidy:mopidy /data \
  && echo "* Ready to start Mopidy" \
  && sleep 10

USER   mopidy
COPY   mopidy.conf /config/mopidy.conf
COPY   run.sh /usr/local/bin/run.sh
RUN    chmod +x /usr/local/bin/run.sh
EXPOSE 6600 6680 5555/udp
VOLUME ["/music", "/data"]

LABEL description "Open source media server"

CMD ["/sbin/tini", "--", "run.sh"]
