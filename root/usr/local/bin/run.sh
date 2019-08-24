#!/bin/sh

trap "kill $PID" HUP INT TERM
su-exec mopidy icecast -c /data/.config/icecast.xml -b &
su-exec mopidy mopidy --config /data/.config/mopidy.conf "${@}" &
PID=$!
wait $PID
