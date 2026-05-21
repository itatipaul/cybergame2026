#!/bin/sh
set -eu

DATA_DIR="/var/www/html/data"
UPLOAD_DIR="/var/www/html/uploads"
PURGE_INTERVAL_SECONDS="${PURGE_INTERVAL_SECONDS:-600}"

purge_state() {
  rm -f "$DATA_DIR/forum.sqlite"
  rm -f "$DATA_DIR"/seed_large_forum_*.done
  find "$UPLOAD_DIR" -mindepth 1 -maxdepth 1 -type f -delete 2>/dev/null || true
}

if [ "${PURGE_ON_START:-1}" = "1" ]; then
  purge_state
fi

while true; do
  sleep "$PURGE_INTERVAL_SECONDS"
  purge_state
done
