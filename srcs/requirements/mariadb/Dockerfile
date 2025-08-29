FROM debian:trixie

RUN apt-get update && apt-get upgrade -y \
    && apt-get install -y \
    mariadb-server mariadb-client && rm -rf /var/lib/apt/lists/*

COPY tools/initdb.sh /usr/local/bin/initdb.sh
RUN chmod +x /usr/local/bin/initdb.sh

ENTRYPOINT ["/usr/local/bin/initdb.sh"]