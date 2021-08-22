FROM balenalib/armv7hf-alpine:3.8

LABEL org.opencontainers.image.authors="Docker Community Authors, Tobias Hargesheimer <docker@ison.ws>" \
	org.opencontainers.image.title="MariaDB" \
	org.opencontainers.image.description="AlpineLinux 3.8 with MariaDB 10.2 on arm arch" \
	org.opencontainers.image.licenses="GPL-2.0" \
	org.opencontainers.image.url="https://hub.docker.com/r/tobi312/rpi-mariadb" \
	org.opencontainers.image.source="https://github.com/Tob1asDocker/rpi-mariadb"

# add our user and group first to make sure their IDs get assigned consistently, regardless of whatever dependencies get added
RUN mkdir -p /var/lib/mysql && \
	addgroup -g 1000 mysql && \
	adduser -D -H -g "mysql" -u 1000 -h /var/lib/mysql -s /sbin/nologin mysql -G mysql

# add gosu for easy step-down from root
# https://github.com/tianon/gosu/releases
ENV GOSU_VERSION 1.12
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
	gpgconf --kill all; \
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

# bashbrew-architectures: armv7
ENV MARIADB_VERSION 10.2
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
	sed -ri 's/^user\s/#&/' /etc/mysql/my.cnf; \
	sed -ri 's/^bind-address\s/#&/' /etc/mysql/my.cnf; \
	sed -ri 's/^log\s/#&/' /etc/mysql/my.cnf; \
# listen on TCP/IP
	#sed -i "s/skip-networking/#skip-networking/g" /etc/mysql/my.cnf; \
# don't reverse lookup hostnames, they are usually another container
	sed -i "/\[mysqld\]/a skip-host-cache\nskip-name-resolve" /etc/mysql/my.cnf

VOLUME /var/lib/mysql

COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh && \
	sed -i "s/--rfc-3339=seconds/-I'seconds'/g" /usr/local/bin/docker-entrypoint.sh
RUN ln -s usr/local/bin/docker-entrypoint.sh / # backwards compat
ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE 3306
CMD ["mysqld"]
