FROM debian:trixie

RUN apt-get update && apt-get upgrade -y && apt-get install -y \
    php-fpm \
    php-mysqli \
    curl \
    mariadb-client && rm -rf /var/lib/apt/lists/*

COPY tools/php.conf /etc/php/8.4/fpm/pool.d/www.conf
COPY tools/setup-wp.sh /usr/local/bin/setup-wp.sh

RUN chmod +x /usr/local/bin/setup-wp.sh

ENTRYPOINT [ "/usr/local/bin/setup-wp.sh" ]