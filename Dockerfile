# ---- Build stage: install PHP deps (no dev), compile frontend ----
FROM php:8.2-fpm-alpine AS builder

# system deps
RUN apk add --no-cache git unzip libpng libpng-dev icu-dev oniguruma-dev \
    libzip-dev bash nodejs npm

# PHP extensions
RUN docker-php-ext-configure intl \
 && docker-php-ext-install pdo pdo_mysql intl gd mbstring opcache zip

# Install Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Copy app & extension sources
WORKDIR /var/www
COPY app/ app/
COPY extensions/ extensions/

# Install app dependencies (no dev) and optimize autoloader
WORKDIR /var/www/app
# Ensure composer.json has the path repo to ../extensions/ai-forum-hello
RUN composer install --no-dev --optimize-autoloader --no-interaction

# Build Flarum frontend assets (extension + core)
# The CLI scaffolds npm scripts inside the extension; core assets are prebuilt,
# but we clear Flarum cache to pick up extension assets.
RUN cd ../extensions/ai-forum-hello/js && npm ci && npm run build

# ---- Runtime image with nginx + php-fpm via supervisord ----
FROM alpine:3.20

# runtime deps
RUN apk add --no-cache nginx supervisor bash curl php82 php82-fpm \
    php82-pdo php82-pdo_mysql php82-intl php82-gd php82-mbstring php82-opcache php82-zip php82-session php82-dom php82-tokenizer

# (Optional) link php -> php82 for CLI commands
RUN ln -s /usr/bin/php82 /usr/bin/php

# Copy app from builder
WORKDIR /var/www/app
COPY --from=builder /var/www/app /var/www/app
COPY --from=builder /var/www/extensions /var/www/extensions

# nginx config
COPY docker/nginx.conf /etc/nginx/nginx.conf

# supervisord config (run php-fpm + nginx)
RUN mkdir -p /etc/supervisor.d
COPY docker/supervisord.conf /etc/supervisord.conf
RUN printf "[program:php-fpm]\ncommand=/usr/sbin/php-fpm82 -F\n\n[program:nginx]\ncommand=/usr/sbin/nginx -g 'daemon off;'\n" > /etc/supervisor.d/services.ini


# Permissions (Flarum needs to write to these)
RUN adduser -D -H -u 1000 flarum \
 && mkdir -p /var/www/app/storage /var/www/app/storage/tmp /var/www/app/public/assets \
 && chown -R flarum:flarum /var/www/app \
 && chmod -R 775 /var/www/app/storage /var/www/app/public/assets \
 && mkdir -p /var/lib/nginx/tmp /run/nginx \
 && mkdir -p /run/php-fpm /var/log/nginx /var/log/php82 \
 && chown -R flarum:flarum /var/lib/nginx /run/nginx /run/php-fpm /var/log/nginx /var/log/php82

# PHP runtime overrides and entrypoint
COPY docker/php-overrides.ini /etc/php82/conf.d/zz-overrides.ini
COPY docker/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Ensure php-fpm runs as flarum to match writable dirs
COPY docker/php-fpm-www.conf /etc/php82/php-fpm.d/z-www-override.conf

USER flarum

EXPOSE 8080
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["/usr/bin/supervisord","-c","/etc/supervisord.conf"]

