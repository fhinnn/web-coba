FROM php:8.1-fpm-alpine

RUN apk update && apk --no-cache add \
    git \
    curl \
    libpng-dev \
    libxml2-dev \
    zip \
    unzip \
    nginx \
    && apk cache clean && rm -rf /var/lib/apt/lists/*

WORKDIR /var/www
COPY . .
COPY default.conf /etc/nginx/http.d/default.conf

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer && composer install

RUN docker-php-ext-install gd pdo pdo_mysql exif pcntl bcmath

RUN chown -R www-data:www-data \
    /var/www/storage \
    /var/www/bootstrap/cache
