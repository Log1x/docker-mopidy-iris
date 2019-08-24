#!/bin/sh

set -euo pipefail

if [ ! -r /data/.config/mopidy.conf ]; then
    mkdir -p /data/.config
    cp /defaults/mopidy.conf /data/.config
fi

if [ ! -r /data/.config/icecast.xml ]; then
    mkdir -p /data/.config
    cp /defaults/icecast.xml /data/.config
fi

if [ ! -r /data/icecast ]; then
    mkdir -p /data/icecast/logs
    cp -r /usr/share/icecast /data/icecast
    cp /defaults/silence.mp3 /data/icecast/web/silence.mp3
fi

chown -R mopidy:mopidy /data

su-exec mopidy mopidy --config /data/.config/mopidy.conf local scan
exec "${@}"
