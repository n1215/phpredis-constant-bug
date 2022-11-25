FROM php:8.1.8-cli

ARG COMMIT_HASH=2a6dee5d4dc5500e1260bcea0f620b6adb0fe22f

RUN apt-get update && \
    apt-get install -y \
    zip \
    git && \
    apt-get clean

RUN git clone https://github.com/phpredis/phpredis.git /usr/src/php/ext/redis && \
    cd /usr/src/php/ext/redis && \
    git checkout -b test ${COMMIT_HASH} && \
    phpize && \
    ./configure && \
    make && \
    make install

RUN docker-php-ext-enable redis

WORKDIR /app
COPY . /app
EXPOSE 8080

CMD ["php", "-S", "0.0.0.0:8080", "-t", "public"]

