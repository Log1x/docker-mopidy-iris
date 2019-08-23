#!/bin/sh
if [ ! -r /data/.config/mopidy.conf ]; then
    mkdir -p /data/.config && cp /defaults/mopidy.conf /data/.config && chown -R mopidy:mopidy /data
fi

if [ ! -r /data/.config/icecast.xml ]; then
    mkdir -p /data/.config && cp /defaults/icecast.xml /data/.config && chown -R mopidy:mopidy /data
fi

if [ ! -r /data/.config/icecast2/web/silence.mp3 ]; then
    mkdir -p /data/.config/icecast2/web && cp /defaults/silence.mp3 /data/.config/icecast2/web && chown -R mopidy:mopidy /data
fi

if [ ! -r /data/logs ]; then
    mkdir -p /data/logs/mopidy /data/logs/icecast2 && chown -R mopidy:mopidy /data
fi

trap "kill $PID" HUP INT TERM
su-exec mopidy icecast -c /data/.config/icecast.xml -b &
su-exec mopidy mopidy --config /data/.config/mopidy.conf "${@}" &
PID=$!
wait $PID
