#!/bin/sh

set -euo pipefail

if [ ! -r /data/.config ]; then
    mkdir -p /data/.config
fi

if [ ! -r /data/.config/mopidy.conf ]; then
    cp /defaults/mopidy.conf /data/.config
fi

if [ ! -r /data/.config/icecast.xml ]; then
    cp /defaults/icecast.xml /data/.config
fi

if [ ! -r /data/icecast/web ] || [ ! -r /data/icecast/admin ]; then
    mkdir -p /data/icecast/web /data/icecast/admin /data/icecast/logs
    cp -r /usr/share/icecast /data/icecast
    cp /defaults/silence.mp3 /data/icecast/web/silence.mp3
fi

if [ ! -r /tmp/snapfifo ]; then
    touch /tmp/snapfifo
fi

chown -R mopidy:mopidy /data /tmp/snapfifo

su-exec mopidy mopidy --config /data/.config/mopidy.conf local scan
exec "${@}"
