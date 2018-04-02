FROM php:7.1-cli
MAINTAINER 'Evgeniy Ryumin'

# Install modules
RUN buildDeps="libpq-dev libzip-dev libicu-dev libpng12-dev libjpeg62-turbo-dev libfreetype6-dev libmagickwand-6.q16-dev" && \
    apt-get update && \
    apt-get install -y $buildDeps --no-install-recommends && \
    apt-get install -y jpegoptim pngquant optipng --no-install-recommends && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-install \
        bcmath \
        pcntl \
        zip \
        opcache \
        pdo \
        pdo_pgsql \
        pgsql \
        sockets \
        intl

RUN apt-get install -y curl

RUN apt-get update && \
    apt-get install -y --no-install-recommends git zip

RUN unlink /etc/localtime && ln -s /usr/share/zoneinfo/Etc/GMT-3 /etc/localtime

WORKDIR /var/www/html

CMD ["php-fpm"]

