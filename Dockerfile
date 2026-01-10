FROM php:8.1.34
ARG DEBIAN_FRONTEND=noninteractive
ARG BOLT_VERSION=5.2.0
WORKDIR /var/www/html
RUN apt-get update && \
    apt-get -yq dist-upgrade && \
    apt-get -yq install \
        libfreetype6-dev \
        libpng-dev \
        libjpeg-dev \
        libicu-dev \
        libmcrypt-dev \
        libgd-dev \
        libzip-dev \
        git \
        zip \
        unzip && \
    curl -sS https://getcomposer.org/installer | php && \
    mv -v composer.phar /usr/local/bin/composer && \
    mv $PHP_INI_DIR/php.ini-development $PHP_INI_DIR/php.ini && \
    docker-php-ext-configure gd --enable-gd --with-avif --with-webp --with-jpeg --with-xpm --with-freetype && \
    docker-php-ext-install -j$(nproc) \
        exif \
        gd \
        intl \
        opcache \
        mysqli \
        zip && \
    apt-get clean && \
    rm -rf /var/lib/{apt,dpkg,cache,log} && \
    composer config --global audit.block-insecure false && \
    composer create-project bolt/project:${BOLT_VERSION} . && \
    bin/console doctrine:database:create && \
    bin/console doctrine:schema:create && \
    bin/console doctrine:fixtures:load --no-interaction && \
    bin/console bolt:add-user --admin bolt_admin Secret@1 admin@foo.bar BoltAdmin && \
    chown -R www-data:www-data .
EXPOSE 8000
ENTRYPOINT ["bin/console", "server:run", "0.0.0.0:8000"]
