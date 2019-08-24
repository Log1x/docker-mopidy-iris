#!/bin/sh

set -euo pipefail

[ ! -r /data/.config ] && mkdir -p /data/.config
[ ! -r /data/.images ] && mkdir -p /data/.images
[ ! -r /data/.config/mopidy.conf ] && cp /defaults/mopidy.conf /data/.config
[ ! -r /data/.config/icecast.xml ] && cp /defaults/icecast.xml /data/.config

if [ ! -r /data/icecast/web ] || [ ! -r /data/icecast/admin ] || [ ! -r /data/icecast/logs ]; then
    mkdir -p /data/icecast/web /data/icecast/admin /data/icecast/logs
    cp -r /usr/share/icecast /data/icecast
    cp /defaults/silence.mp3 /data/icecast/web/silence.mp3
fi

chown -R mopidy:mopidy /data
su-exec mopidy mopidy --config /data/.config/mopidy.conf local scan
exec "${@}"
