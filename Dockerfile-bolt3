FROM php:7.4.9-apache-buster
ENV DEBIAN_FRONTEND noninteractive
ENV APACHE_DOCUMENT_ROOT /var/www/html/public
WORKDIR /var/www/html
RUN apt-get update && \
    apt-get -yq install git libicu-dev libgd-dev && \
    apt-get -yq autoremove && \
    apt-get clean && \
    rm -rf /var/lib/{apt,dpkg,cache,log}
RUN curl -s -O https://bolt.cm/distribution/bolt-latest.tar.gz && \
    tar -xzf bolt-latest.tar.gz --strip-components=1 && \
    rm bolt-latest.tar.gz && \
    mv $PHP_INI_DIR/php.ini-development $PHP_INI_DIR/php.ini && \
    docker-php-ext-install -j$(nproc) exif gd intl opcache && \
    apt-get -y --purge remove libicu-dev libgd-dev && \
    php app/nut init && \
    sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf && \
    a2enmod rewrite && \
    chown -R www-data.www-data .
EXPOSE 80
