#!/bin/sh
if [ ! -f /data/.config/mopidy.conf ]; then
  mkdir -p /data/.config
  cp /defaults/mopidy.conf /data/.config/mopidy.conf
fi

su-exec mopidy mopidy --config "/data/.config/mopidy.conf" "${@}" &
