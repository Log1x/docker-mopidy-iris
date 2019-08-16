#!/bin/sh
function stop() {
    kill $PID
}

trap stop HUP INT TERM
su-exec mopidy mopidy --config "/data/config/mopidy.conf" "${@}" &
PID=$!
wait $PID
