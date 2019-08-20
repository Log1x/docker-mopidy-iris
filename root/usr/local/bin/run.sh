#!/bin/sh
if [ ! -r /data/.config/mopidy.conf ]; then
    mkdir -p /data/.config && cp /defaults/mopidy.conf /data/.config && chown -R mopidy:mopidy /data
fi

trap "kill $PID" HUP INT TERM
su-exec mopidy mopidy --config /data/.config/mopidy.conf "${@}" &
PID=$!
wait $PID
