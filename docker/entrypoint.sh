#!/bin/sh
set -e

# Ensure persistent temp dir exists for s9e renderer and others
mkdir -p /var/www/app/storage/tmp

# Clear Flarum cache to regenerate text formatter renderer if needed
if [ -x /usr/bin/php ] || [ -x /usr/bin/php82 ]; then
  cd /var/www/app || true
  php flarum cache:clear >/dev/null 2>&1 || true
fi

exec "$@"


