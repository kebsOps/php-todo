FROM php:7.4-cli
LABEL MAINTAINER = "Kebe kebeeyong@gmail.com"
USER root
WORKDIR  /var/www/html



RUN apt-get update && apt-get install -y \
    libpng-dev \
    zlib1g-dev \
    libxml2-dev \
    libzip-dev \
    libonig-dev \
    zip \
    curl \
    unzip \
    && docker-php-ext-configure gd \
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-install pdo_mysql \
    && docker-php-ext-install mysqli \
    && docker-php-ext-install zip \
    && docker-php-source delete


ENV DB_HOST=db  

WORKDIR  /var/www/html/php-todo

RUN sed -i -e "s/DB_HOST=127\.0\.0\.1/DB_HOST=${DB_HOST}/" .env.sample && mv .env.sample .env 

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin/ --filename=composer



RUN COMPOSER_ALLOW_SUPERUSER=1

COPY . .



RUN composer install 


ENTRYPOINT [ "sh", "serve.sh" ]
