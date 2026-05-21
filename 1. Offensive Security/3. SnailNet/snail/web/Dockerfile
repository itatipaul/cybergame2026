FROM php:apache

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        libsqlite3-dev \
        pkg-config \
    && rm -rf /var/lib/apt/lists/*

RUN docker-php-ext-install pdo_sqlite

WORKDIR /var/www/html

COPY index.php ./index.php
COPY assets ./assets
COPY data ./data
COPY lib ./lib
COPY templates ./templates
COPY uploads ./uploads
COPY reset-state.sh ./reset-state.sh
COPY entrypoint.sh ./entrypoint.sh

RUN mkdir -p /var/www/html/data /var/www/html/uploads \
    && chown -R www-data:www-data /var/www/html/data /var/www/html/uploads \
    && chmod +x /var/www/html/reset-state.sh /var/www/html/entrypoint.sh

EXPOSE 80

ENTRYPOINT ["/var/www/html/entrypoint.sh"]
