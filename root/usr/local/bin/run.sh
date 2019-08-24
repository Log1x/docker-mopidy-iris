#!/bin/sh

trap "kill $PID" HUP INT TERM
su-exec mopidy snapserver -d -s pipe:///tmp/snapfifo?name=Mopidy&sampleformat=48000:16:2 &
su-exec mopidy icecast -c /data/.config/icecast.xml -b &
su-exec mopidy mopidy --config /data/.config/mopidy.conf "${@}" &
PID=$!
wait $PID
