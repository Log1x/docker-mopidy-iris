#!/bin/sh

function stop() {
    kill $PID
}

trap stop HUP INT TERM
su-exec mopidy mopidy --config "${MOPIDY_CONFIG_FILE}" "${@}" &
PID=$!
wait $PID
