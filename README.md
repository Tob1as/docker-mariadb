# MariaDB on Raspberry Pi / ARM

### Supported tags and respective `Dockerfile` links
-	[`10.3-alpine` (*Dockerfile*)](https://github.com/Tob1asDocker/rpi-mariadb/blob/master/alpine.armhf.10_3.Dockerfile) ([AlpineLinux](https://pkgs.alpinelinux.org/package/v3.10/main/armhf/mariadb)) (experimental image)
-	[`10.3`, `latest` (*Dockerfile*)](https://github.com/Tob1asDocker/rpi-mariadb/blob/master/buster.armhf.10_3.Dockerfile) (on Debian 10 Buster)
-	[`10.1` (*Dockerfile*)](https://github.com/Tob1asDocker/rpi-mariadb/blob/master/stretch.armhf.10_1.Dockerfile) (on Debian 9 Stretch)

# What is MariaDB?

MariaDB is a community-developed fork of the MySQL relational database management system intended to remain free under the GNU GPL. Being a fork of a leading open source software system, it is notable for being led by the original developers of MySQL, who forked it due to concerns over its acquisition by Oracle. Contributors are required to share their copyright with the MariaDB Foundation.

The intent is also to maintain high compatibility with MySQL, ensuring a "drop-in" replacement capability with library binary equivalency and exact matching with MySQL APIs and commands. It includes the XtraDB storage engine for replacing InnoDB, as well as a new storage engine, Aria, that intends to be both a transactional and non-transactional engine perhaps even included in future versions of MySQL.

> [wikipedia.org/wiki/MariaDB](https://en.wikipedia.org/wiki/MariaDB)

![logo](https://raw.githubusercontent.com/docker-library/docs/master/mariadb/logo.png)

### About these images:
* a port of the official [MariaDB](https://hub.docker.com/_/mariadb)-Image
* based on official Images: [arm32v7/debian](https://hub.docker.com/r/arm32v7/debian/) and [arm32v7/alpine](https://hub.docker.com/r/arm32v7/alpine/)
* build on Docker Hub with Autobuild, for example and more details see in this [repository](https://github.com/Tob1asDocker/dockerhubhooksexample)

### How to use these images:

* ``` $ docker run --name some-mariadb -v ./mariadb:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=my-secret-pw -d tobi312/rpi-mariadb:TAG ```
* more see official [MariaDB](https://hub.docker.com/_/mariadb)-Image

#### Docker-Compose

```yaml
# Use root/my-secret-pw as user/password credentials
version: '2.4'
services:
  mariadb:
    image: tobi312/rpi-mariadb:TAG
    #container_name: mariadb
    volumes:
      - ./mariadb:/var/lib/mysql
      - /etc/timezone:/etc/timezone:ro
      - /etc/localtime:/etc/localtime:ro
    environment:
       MYSQL_ROOT_PASSWORD: my-secret-pw
       #MYSQL_RANDOM_ROOT_PASSWORD: "yes"
       MYSQL_DATABASE: user
       MYSQL_USER: user
       MYSQL_PASSWORD: my-secret-pw
    restart: unless-stopped
    ports:
      - 3306:3306
    healthcheck:
      test:  mysqladmin ping -h 127.0.0.1 -u $$MYSQL_USER --password=$$MYSQL_PASSWORD || exit 1
      #start_period: 60s
      interval: 30s
      timeout: 5s
      retries: 5
```

### This Image on
* [DockerHub](https://hub.docker.com/r/tobi312/rpi-mariadb/)
* [GitHub](https://github.com/Tob1asDocker/rpi-mariadb)
