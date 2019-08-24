#!/bin/sh

set -euo pipefail

if [ ! -r /data/.config/mopidy.conf ]; then
    mkdir -p /data/.config
    cp /defaults/mopidy.conf /data/.config
fi

chown -R mopidy:mopidy /data

su-exec mopidy mopidy --config /data/.config/mopidy.conf local scan
exec "${@}"
