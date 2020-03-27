FROM php:7.4.4-apache-buster
WORKDIR /var/www/html
RUN curl -s -O https://bolt.cm/distribution/bolt-latest.tar.gz && \
    tar -xzf bolt-latest.tar.gz --strip-components=1 && \
    rm bolt-latest.tar.gz
RUN apt-get update && \
    apt-get -y install git libicu-dev libgd-dev && \
    apt-get clean
RUN mv $PHP_INI_DIR/php.ini-development $PHP_INI_DIR/php.ini
RUN docker-php-ext-install -j$(nproc) intl
RUN docker-php-ext-install -j$(nproc) gd
RUN docker-php-ext-install -j$(nproc) exif
RUN docker-php-ext-install -j$(nproc) opcache
RUN apt-get -y --purge remove libicu-dev libgd-dev
RUN php app/nut init
ENV APACHE_DOCUMENT_ROOT /var/www/html/public
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN a2enmod rewrite
RUN chown -R www-data.www-data .
EXPOSE 80
