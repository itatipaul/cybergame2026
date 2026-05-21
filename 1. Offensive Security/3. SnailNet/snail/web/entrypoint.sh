#!/bin/sh
set -eu

/var/www/html/reset-state.sh &
exec apache2-foreground
