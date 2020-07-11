FROM php:7.4-fpm as base

EXPOSE 9000
RUN mkdir -p /srv/app/var

WORKDIR /srv/app/

# Install dependencies
RUN buildDeps=" \
        wget \
        git \
        less \
        zip \
        unzip \
        libzip-dev \
        librabbitmq-dev \
    "; \
    set -x \
    && apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y $buildDeps --no-install-recommends \
    && docker-php-ext-install -j$(nproc) opcache zip pdo_mysql json \
    && pecl install amqp \
    && docker-php-ext-enable amqp \
    && rm -rf /var/lib/apt/lists/*

FROM base as dev

# Install composer in the development environment
RUN wget https://getcomposer.org/installer -O - -q | php -- --quiet && \
    mv composer.phar /usr/local/bin/composer

FROM base as prod

COPY ./src/ /srv/app/src
COPY ./bin/ /srv/app/bin
COPY ./public/ /srv/app/public
COPY ./vendor/ /srv/app/vendor
COPY ./config/ /srv/app/config
COPY ./templates/ /srv/app/templates
COPY .env /srv/app/.env

RUN chown -R www-data /srv/app/ && \
   /srv/app/bin/console cache:warm
