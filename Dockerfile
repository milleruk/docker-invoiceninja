FROM docker.io/tiredofit/nginx-php-fpm:8.1
LABEL maintainer="Dave Conroy (github.com/tiredofit)"

ENV INVOICENINJA_VERSION=v5.5.27 \
    INVOICENINJA_REPO_URL=https://github.com/invoiceninja/invoiceninja \
    NGINX_WEBROOT=/www/html \
    NGINX_SITE_ENABLED=invoiceninja \
    PHP_CREATE_SAMPLE_PHP=FALSE \
    PHP_ENABLE_CURL=TRUE \
    PHP_ENABLE_FILEINFO=TRUE \
    PHP_ENABLE_GMP=TRUE \
    PHP_ENABLE_ICONV=TRUE \
    PHP_ENABLE_IGBINARY=TRUE \
    PHP_ENABLE_IMAP=TRUE \
    PHP_ENABLE_MBSTRING=TRUE \
    PHP_ENABLE_OPENSSL=TRUE \
    PHP_ENABLE_SODIUM=TRUE \
    PHP_ENABLE_TOKENIZER=TRUE \
    PHP_ENABLE_ZIP=TRUE \
    IMAGE_NAME="tiredofit/invoiceninja" \
    IMAGE_REPO_URL="https://github.com/tiredofit/docker-invoiceninja/"

RUN source /assets/functions/00-container && \
    set -x && \
    apk update && \
    apk upgrade && \
    apk add -t .invoiceninja-run-deps \
              chromium \
              font-isas-misc \
              git \
              gnu-libiconv \
              sed \
              ttf-freefont \
              && \
    \
    php-ext enable core && \
    clone_git_repo ${INVOICENINJA_REPO_URL} ${INVOICENINJA_VERSION} /assets/install && \
    composer install --no-dev --quiet && \
    chown -R ${NGINX_USER}:${NGINX_GROUP} /assets/install && \
    rm -rf \
        /assets/install/.env.example \
        /assets/install/.env.travis \
        && \
    rm -rf /root/.composer && \
    rm -rf /var/tmp/* /var/cache/apk/*

ENV LD_PRELOAD /usr/lib/preloadable_libiconv.so php

### Assets
ADD install /
