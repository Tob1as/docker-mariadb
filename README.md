# MariaDB (MySQL fork) - Alpine/Ubuntu Docker Image for amd64, arm64, arm 

### Supported tags and respective `Dockerfile` links
-	[`10.6-alpine` (*Dockerfile*)](https://github.com/Tob1asDocker/rpi-mariadb/blob/master/alpine.10_6.Dockerfile) (on AlpineLinux [3.17](https://pkgs.alpinelinux.org/package/v3.17/main/armhf/mariadb))
-	[`10.6-ubuntu` (*Dockerfile*)](https://github.com/Tob1asDocker/rpi-mariadb/blob/master/ubuntu.10_6.Dockerfile) (on Ubuntu [Jammy 22.04 LTS](https://packages.ubuntu.com/search?keywords=mariadb-server))
    
*Notes:  
Since December 2022 the older images of Debian, Ubuntu and Alpine images provided in the Docker Hub repository are no longer maintained/updated. Continued use is not recommended.  
MariaDB 10.6 is the current LTS version and is available on AlpineLinux (from version 3.15) and Ubuntu Jammy.  
For amd64 and arm64 it is recommended to use the [official images](https://hub.docker.com/_/mariadb) based on Ubuntu.* 

# What is MariaDB?

MariaDB Server is one of the most popular database servers in the world. It’s made by the original developers of MySQL and guaranteed to stay open source. Notable users include Wikipedia, DBS Bank, and ServiceNow.

The intent is also to maintain high compatibility with MySQL, ensuring a library binary equivalency and exact matching with MySQL APIs and commands. MariaDB developers continue to develop new features and improve performance to better serve its users.

> [wikipedia.org/wiki/MariaDB](https://en.wikipedia.org/wiki/MariaDB)

![logo](https://raw.githubusercontent.com/docker-library/docs/master/mariadb/logo.png)

### About these images:
* a port of the official [MariaDB](https://hub.docker.com/_/mariadb)-Image ([GitHub](https://github.com/MariaDB/mariadb-docker)).
* based on official distributions Images: 
  * [Alpine](https://hub.docker.com/_/alpine)
  * ~~[Debian](https://hub.docker.com/_/debian)~~
  * ~~[Ubuntu](https://hub.docker.com/_/ubuntu)~~
* build:
  * with Github Actions
  * ~~on Docker Hub with Autobuild, for example and more details see in this [repository](https://github.com/Tob1asDocker/dockerhubhooksexample).~~

### How to use these images:

```sh 
docker run --name some-mariadb \
-v $(pwd)/mariadb:/var/lib/mysql:rw \
-p 3306:3306 \
-e MARIADB_ROOT_PASSWORD=my-secret-pw \
-d tobi312/rpi-mariadb:10.6-alpine 
```

more see official [MariaDB](https://hub.docker.com/_/mariadb)-Images

#### Docker-Compose

```yaml
version: '2.4'
services:

  mariadb:
    image: tobi312/rpi-mariadb:10.6-alpine
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
      MARIADB_MYSQL_LOCALHOST_USER: true
    ports:
      - 3306:3306
    healthcheck:
      test: ["CMD", "/usr/local/bin/healthcheck.sh", "--su-mysql", "--connect", "--innodb_initialized"]
      interval: 60s
      timeout: 5s
      retries: 5
```

### This Image on
* [DockerHub](https://hub.docker.com/r/tobi312/rpi-mariadb/)
* [GitHub](https://github.com/Tob1asDocker/rpi-mariadb)
