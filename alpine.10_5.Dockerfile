FROM alpine:3.14

ARG BUILD_DATE
ARG VCS_REF

LABEL org.opencontainers.image.authors="MariaDB Community, Tobias Hargesheimer <docker@ison.ws>" \
    org.opencontainers.image.title="MariaDB Database" \
    org.opencontainers.image.description="MariaDB Database for relational SQL" \
    org.opencontainers.image.licenses="GPL-2.0" \
    org.opencontainers.image.created="${BUILD_DATE}" \
    org.opencontainers.image.revision="${VCS_REF}" \
    org.opencontainers.image.version="10.5" \
    org.opencontainers.image.url="https://hub.docker.com/r/tobi312/rpi-mariadb" \
    org.opencontainers.image.source="https://github.com/Tob1as/docker-mariadb"

# add our user and group first to make sure their IDs get assigned consistently, regardless of whatever dependencies get added
RUN mkdir -p /var/lib/mysql && \
    addgroup -g 1000 mysql && \
    adduser -D -H -g "mysql" -u 1000 -h /var/lib/mysql -s /sbin/nologin mysql -G mysql

# add gosu for easy step-down from root
# https://github.com/tianon/gosu/releases
ENV GOSU_VERSION 1.14
RUN set -eux; \
    \
    apk add --no-cache --virtual .gosu-deps \
        ca-certificates \
        dpkg \
        gnupg \
    ; \
    \
    dpkgArch="$(dpkg --print-architecture | awk -F- '{ print $NF }')"; \
    wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch"; \
    wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch.asc"; \
    \
# verify the signature
    export GNUPGHOME="$(mktemp -d)"; \
    gpg --batch --keyserver hkps://keys.openpgp.org --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4; \
    gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu; \
    command -v gpgconf && gpgconf --kill all || :; \
    rm -rf "$GNUPGHOME" /usr/local/bin/gosu.asc; \
    \
# clean up fetch dependencies
    apk del --no-network .gosu-deps; \
    \
    chmod +x /usr/local/bin/gosu; \
# verify that the binary works
    gosu --version; \
    gosu nobody true

RUN mkdir /docker-entrypoint-initdb.d

# Ensure the container exec commands handle range of utf8 characters based of
# default locales in base image (https://github.com/docker-library/docs/blob/135b79cc8093ab02e55debb61fdb079ab2dbce87/ubuntu/README.md#locales)
ENV LANG C.UTF-8

# install "pwgen" for randomizing passwords
# install "tzdata" for /usr/share/zoneinfo/
# install "xz" for .sql.xz docker-entrypoint-initdb.d files
# install "bash"
RUN set -ex; \
    apk --no-cache add \
        pwgen \
        tzdata \
        xz \
        zstd \
        bash

# bashbrew-architectures: *
ENV MARIADB_VERSION 10.5
# release-status:Stable
# (https://downloads.mariadb.org/mariadb/+releases/)

RUN set -ex; \
    apk --no-cache add \
        "mariadb>$MARIADB_VERSION" \
        "mariadb-client>$MARIADB_VERSION" \
        "mariadb-server-utils>$MARIADB_VERSION" \
# mariadb-backup is installed at the same time so that `mysql-common` is only installed once from just mariadb repos
        "mariadb-backup>$MARIADB_VERSION" \
        socat \
    ; \
# purge and re-create /var/lib/mysql with appropriate ownership
    rm -rf /var/lib/mysql; \
    mkdir -p /var/lib/mysql /run/mysqld; \
    chown -R mysql:mysql /var/lib/mysql /run/mysqld; \
# ensure that /run/mysqld (used for socket and lock files) is writable regardless of the UID our mysqld instance ends up having at runtime
    chmod 777 /run/mysqld; \
# comment out a few problematic configuration values
    sed -ri 's/^user\s/#&/' /etc/my.cnf /etc/my.cnf.d/*; \
    sed -ri 's/^bind-address\s/#&/' /etc/my.cnf /etc/my.cnf.d/*; \
    sed -ri 's/^log\s/#&/' /etc/my.cnf /etc/my.cnf.d/*; \
# listen on TCP/IP
    sed -i "s/skip-networking/#skip-networking/g" /etc/my.cnf.d/mariadb-server.cnf; \
# don't reverse lookup hostnames, they are usually another container
    printf "[mariadb]\nhost-cache-size=0\nskip-name-resolve\n" > /etc/my.cnf.d/05-skipcache.cnf

VOLUME /var/lib/mysql

COPY healthcheck__10_5.sh /usr/local/bin/healthcheck.sh
COPY docker-entrypoint__10_5.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/*.sh ; \
    sed -i "s/--rfc-3339=seconds/-I'seconds'/g" /usr/local/bin/docker-entrypoint.sh
ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE 3306
CMD ["mariadbd"]