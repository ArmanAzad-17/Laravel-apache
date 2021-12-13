FROM php:8.0-apache


RUN apt-get update && apt-get install -y \
        zip \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-install pdo_mysql

COPY ./server-config/000-default.conf /etc/apache2/sites-available/000-default.conf

RUN a2enmod rewrite &&\
    service apache2 restart

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

WORKDIR /var/www/html

COPY  composer.json ./composer.json

COPY . /var/www/html

RUN composer install


RUN chmod -R 777 storage/*
RUN chmod -R 777 bootstrap/cache


EXPOSE 80
