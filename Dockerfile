FROM composer:2.10.3@sha256:2cf275428757e5435a667bfc0d038b14520ca02be2b1b70d44a05c8c19e2de48 AS composer

FROM php:8.4.27-apache@sha256:be1326658a7d36dba6be79a71212d6ff9c5f854335b8ba77d714da1852c1b2ea
ARG DEBIAN_FRONTEND=noninteractive
ARG BOLT_PROJECT_VERSION=6.0.0
ARG BOLT_CORE_VERSION=6.1.10
ENV APACHE_DOCUMENT_ROOT=/var/www/html/public
ENV COMPOSER_ALLOW_SUPERUSER=1
WORKDIR /var/www/html
COPY --from=composer /usr/bin/composer /usr/local/bin/composer
COPY limits.ini $PHP_INI_DIR/conf.d/
# Build the PHP extensions, then keep only the runtime libraries they link to.
# git and unzip stay installed so Composer can add Bolt extensions.
RUN set -eux; \
    apt-get update; \
    apt-get -y upgrade; \
    apt-get -y install --no-install-recommends git unzip; \
    savedAptMark="$(apt-mark showmanual)"; \
    apt-get -y install --no-install-recommends \
        libfreetype-dev \
        libicu-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
        libwebp-dev \
        libzip-dev; \
    docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp; \
    docker-php-ext-install -j"$(nproc)" exif gd intl mysqli opcache zip; \
    apt-mark auto '.*' > /dev/null; \
    apt-mark manual $savedAptMark; \
    ldd "$(php -r 'echo ini_get("extension_dir");')"/*.so \
        | awk '/=>/ { so = $(NF-1); if (index(so, "/usr/local/") == 1) { next }; gsub("^/(usr/)?", "", so); printf "*%s\n", so }' \
        | sort -u \
        | xargs -r dpkg-query --search \
        | cut -d: -f1 \
        | sort -u \
        | xargs -r apt-mark manual; \
    apt-get -y purge --auto-remove -o APT::AutoRemove::RecommendsImportant=false; \
    rm -rf /var/lib/apt/lists/*; \
    mv "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini"; \
    sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf; \
    a2enmod rewrite
# Install Bolt with demo content and a default admin user
RUN set -eux; \
    composer create-project --no-install "bolt/project:${BOLT_PROJECT_VERSION}" .; \
    composer require --no-update "bolt/core:${BOLT_CORE_VERSION}"; \
    composer install --no-interaction --no-progress; \
    composer run-script post-create-project-cmd; \
    composer clear-cache; \
    bin/console doctrine:schema:create; \
    bin/console doctrine:fixtures:load --no-interaction; \
    bin/console bolt:add-user --admin bolt_admin Secret@1 admin@foo.bar BoltAdmin; \
    chown -R www-data:www-data .
EXPOSE 80
