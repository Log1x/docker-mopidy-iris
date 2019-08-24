#!/bin/sh

trap "kill $PID" HUP INT TERM
su-exec mopidy mopidy --config /data/.config/mopidy.conf "${@}" &
PID=$!
wait $PID
