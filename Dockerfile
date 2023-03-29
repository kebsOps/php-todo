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
  

ENV MYSQL_DATABASE homestead
ENV MYSQL_USER homestead
ENV MYSQL_PASSWORD sePret^i
ENV MYSQL_ROOT_PASSWORD admin12345
ADD create_php_todo_user.sql /docker-entrypoint-initdb.d/

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin/ --filename=composer


RUN COMPOSER_ALLOW_SUPERUSER=1

COPY . .



RUN composer install 


ENTRYPOINT [ "sh", "serve.sh" ]
