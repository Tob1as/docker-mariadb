# MariaDB (MySQL fork) - Docker Image for amd64, arm64, arm 

### Supported tags and respective `Dockerfile` links
-	[`10.11-alpine` (*Dockerfile*)](https://github.com/Tob1as/docker-mariadb/blob/master/alpine.10_11.Dockerfile) (on AlpineLinux [3.20](https://pkgs.alpinelinux.org/package/v3.20/main/armhf/mariadb))
-	[`10.11-debian` (*Dockerfile*)](https://github.com/Tob1as/docker-mariadb/blob/master/debian.10_11.Dockerfile) (on Debian [12 (bookworm)](https://packages.debian.org/bookworm/mariadb-server))
-	[`10.11-ubuntu` (*Dockerfile*)](https://github.com/Tob1as/docker-mariadb/blob/master/ubuntu.10_11.Dockerfile) (on Ubuntu [24.04 (noble)](https://launchpad.net/ubuntu/noble/+package/mariadb-server))
  
**Notes**: 
* For `amd64` and `arm64` it is recommended to use the [official images](https://hub.docker.com/_/mariadb) based on Ubuntu and not these !
* How long MariaDB versions are supported (End of Life): https://mariadb.org/about/#mariadb-server-long-term-release-maintenance-periods  
Do not use an container image which MariaDB version is no longer supported!
* How long OS (Alpine, Debian, ...) versions are supported (End of Life): https://alpinelinux.org/releases/ and https://wiki.debian.org/DebianReleases and https://ubuntu.com/about/release-cycle  
Do not use an container image which OS version is no longer supported!

# What is MariaDB?

MariaDB Server is one of the most popular database servers in the world. It’s made by the original developers of MySQL and guaranteed to stay open source. Notable users include Wikipedia, DBS Bank, and ServiceNow.

The intent is also to maintain high compatibility with MySQL, ensuring a library binary equivalency and exact matching with MySQL APIs and commands. MariaDB developers continue to develop new features and improve performance to better serve its users.

> [wikipedia.org/wiki/MariaDB](https://en.wikipedia.org/wiki/MariaDB)

![logo](https://raw.githubusercontent.com/docker-library/docs/master/mariadb/logo.png)

### About these images:
* a port of the official [MariaDB](https://hub.docker.com/_/mariadb)-Image ([GitHub](https://github.com/MariaDB/mariadb-docker)).
* based on official distributions Images ([Alpine](https://hub.docker.com/_/alpine),[Ubuntu](https://hub.docker.com/_/ubuntu),[Debian](https://hub.docker.com/_/debian))
* and on the package manager of the respective linux distribution ([Alpine](https://pkgs.alpinelinux.org/packages?name=mariadb),[Ubuntu](https://packages.ubuntu.com/search?keywords=mariadb-server),[Debian](https://packages.debian.org/search?searchon=names&keywords=mariadb-server)).
* build with Github Actions

### How to use these images:

```sh 
docker run --name some-mariadb \
-v $(pwd)/mariadb:/var/lib/mysql:rw \
-p 3306:3306 \
-e MARIADB_ROOT_PASSWORD=my-secret-pw \
-d tobi312/rpi-mariadb:10.11-alpine 
```

more see official [MariaDB](https://hub.docker.com/_/mariadb)-Images

#### Docker-Compose

```yaml
version: '2.4'
services:

  mariadb:
    image: tobi312/rpi-mariadb:10.11-alpine
    container_name: mariadb
    restart: unless-stopped
    volumes:
      - ./mariadb-data:/var/lib/mysql:rw
    environment:
      TZ: Europe/Berlin
      #MARIADB_RANDOM_ROOT_PASSWORD: "yes"
      MARIADB_ROOT_PASSWORD: my-secret-pw
      MARIADB_DATABASE: user-database
      MARIADB_USER: example-user
      MARIADB_PASSWORD: my_cool_secret
    ports:
      - 3306:3306
```

more see [docker-compose.yml](https://github.com/Tob1as/docker-mariadb/blob/master/docker-compose.yaml)-File.

### This Image on
* [DockerHub](https://hub.docker.com/r/tobi312/rpi-mariadb/)
* [GitHub](https://github.com/Tob1as/docker-mariadb)
