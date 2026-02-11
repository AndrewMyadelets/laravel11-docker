FROM php:8.4-fpm

ARG WWWUSER
ARG WWWGROUP

RUN apt-get update && apt-get install -y \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip \
    git \
    curl

RUN apt-get clean && rm -rf /var/lib/apt/lists/*

RUN docker-php-ext-install pdo_mysql mbstring bcmath gd opcache

RUN pecl install xdebug-3.4.0 && docker-php-ext-enable xdebug

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

RUN groupadd --force -g ${WWWGROUP} laravel && \
    useradd -ms /bin/bash --no-log-init -u ${WWWUSER} -g ${WWWGROUP} laravel

RUN git config --global --add safe.directory /var/www/html

WORKDIR /var/www/html

RUN mkdir -p storage/framework/sessions \
             storage/framework/views \
             storage/framework/cache \
             bootstrap/cache && \
    chown -R ${WWWUSER}:${WWWGROUP} storage bootstrap/cache && \
    chmod -R 775 storage bootstrap/cache

USER laravel
