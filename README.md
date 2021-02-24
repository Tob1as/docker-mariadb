# MariaDB on Raspberry Pi / ARM

### Supported tags and respective `Dockerfile` links
-	[`10.5` (*Dockerfile*)](https://github.com/Tob1asDocker/rpi-mariadb/blob/master/bullseye.armhf.10_5.Dockerfile) (on Debian 11 Bullseye) (**unstable**)
-	[`10.3`, `latest` (*Dockerfile*)](https://github.com/Tob1asDocker/rpi-mariadb/blob/master/buster.armhf.10_3.Dockerfile) (on Debian 10 Buster)
-	[`10.1` (*Dockerfile*)](https://github.com/Tob1asDocker/rpi-mariadb/blob/master/stretch.armhf.10_1.Dockerfile) (on Debian 9 Stretch)

-	[`10.5-ubuntu` (*Dockerfile*)](https://github.com/Tob1asDocker/rpi-mariadb/blob/master/ubuntu.armhf.10_5.Dockerfile) (on [Ubuntu](https://packages.ubuntu.com/search?arch=armhf&searchon=names&keywords=mariadb-server-10.5) 21.04 Hirsute Hippo) (**unstable**)
-	[`10.3-ubuntu` (*Dockerfile*)](https://github.com/Tob1asDocker/rpi-mariadb/blob/master/ubuntu.armhf.10_3.Dockerfile) (on [Ubuntu](https://packages.ubuntu.com/search?arch=armhf&searchon=names&keywords=mariadb-server-10.3) 20.04 LTS Focal Fossa)
-	[`10.1-ubuntu` (*Dockerfile*)](https://github.com/Tob1asDocker/rpi-mariadb/blob/master/ubuntu.armhf.10_1.Dockerfile) (on [Ubuntu](https://packages.ubuntu.com/search?arch=armhf&searchon=names&keywords=mariadb-server-10.1) 18.04 LTS Bionic Beaver)

-	[`10.5-alpine` (*Dockerfile*)](https://github.com/Tob1asDocker/rpi-mariadb/blob/master/alpine.armhf.10_5.Dockerfile) (on [AlpineLinux](https://pkgs.alpinelinux.org/package/v3.13/main/armhf/mariadb) 3.13) (**unstable**)
-	[`10.4-alpine` (*Dockerfile*)](https://github.com/Tob1asDocker/rpi-mariadb/blob/master/alpine.armhf.10_4.Dockerfile) (on [AlpineLinux](https://pkgs.alpinelinux.org/package/v3.12/main/armhf/mariadb) 3.12)
-	[`10.3-alpine` (*Dockerfile*)](https://github.com/Tob1asDocker/rpi-mariadb/blob/master/alpine.armhf.10_3.Dockerfile) (on [AlpineLinux](https://pkgs.alpinelinux.org/package/v3.10/main/armhf/mariadb) 3.10)
-	[`10.2-alpine` (*Dockerfile*)](https://github.com/Tob1asDocker/rpi-mariadb/blob/master/alpine.armhf.10_2.Dockerfile) (on [AlpineLinux](https://pkgs.alpinelinux.org/package/v3.8/main/armhf/mariadb) 3.8) (productive use not recommended) (*)
-	[`10.1-alpine` (*Dockerfile*)](https://github.com/Tob1asDocker/rpi-mariadb/blob/master/alpine.armhf.10_1.Dockerfile) (on [AlpineLinux](https://pkgs.alpinelinux.org/package/v3.7/main/armhf/mariadb) 3.7) (productive use not recommended) (*)

# What is MariaDB?

MariaDB is a community-developed fork of the MySQL relational database management system intended to remain free under the GNU GPL. Being a fork of a leading open source software system, it is notable for being led by the original developers of MySQL, who forked it due to concerns over its acquisition by Oracle. Contributors are required to share their copyright with the MariaDB Foundation.

The intent is also to maintain high compatibility with MySQL, ensuring a "drop-in" replacement capability with library binary equivalency and exact matching with MySQL APIs and commands. It includes the XtraDB storage engine for replacing InnoDB, as well as a new storage engine, Aria, that intends to be both a transactional and non-transactional engine perhaps even included in future versions of MySQL.

> [wikipedia.org/wiki/MariaDB](https://en.wikipedia.org/wiki/MariaDB)

![logo](https://raw.githubusercontent.com/docker-library/docs/master/mariadb/logo.png)

### About these images:
* a port of the official [MariaDB](https://hub.docker.com/_/mariadb)-Image ([GitHub](https://github.com/docker-library/mariadb/tree/master)).
* based on official Images: [arm32v7/debian](https://hub.docker.com/r/arm32v7/debian/), [arm32v7/alpine](https://hub.docker.com/r/arm32v7/alpine/) or [arm32v7/ubuntu](https://hub.docker.com/r/arm32v7/ubuntu/).  
(Alpine-Images marked with a *-sign are based on [balenalib/armv7hf-alpine](https://hub.docker.com/r/balenalib/armv7hf-alpine).)
* build on Docker Hub with Autobuild, for example and more details see in this [repository](https://github.com/Tob1asDocker/dockerhubhooksexample).

### How to use these images:

* ``` $ docker run --name some-mariadb -v $(pwd)/mariadb:/var/lib/mysql -p 3306:3306  -e MYSQL_ROOT_PASSWORD=my-secret-pw -d tobi312/rpi-mariadb:TAG ```
* more see official [MariaDB](https://hub.docker.com/_/mariadb)-Image

#### Docker-Compose

```yaml
version: '2.4'
services:
  mariadb:
    image: tobi312/rpi-mariadb:TAG
    #container_name: mariadb
    restart: unless-stopped
    volumes:
      - ./mariadb:/var/lib/mysql
    environment:
      TZ: Europe/Berlin
      #MYSQL_RANDOM_ROOT_PASSWORD: "yes"
      MYSQL_ROOT_PASSWORD: my-secret-pw
      MYSQL_DATABASE: user
      MYSQL_USER: user
      MYSQL_PASSWORD: my-secret-pw
    ports:
      - 3306:3306
    healthcheck:
      test:  mysqladmin ping -h 127.0.0.1 -u root --password=$$MYSQL_ROOT_PASSWORD || exit 1
      #test:  mysqladmin ping -h 127.0.0.1 -u $$MYSQL_USER --password=$$MYSQL_PASSWORD || exit 1
      interval: 30s
      timeout: 5s
      retries: 5
```

#### Troubleshooting

If your container fails to start with Images that based on Alpine 3.13 on ARM devices with Raspbian/Debian 10 Buster (32 bit) then update `libseccomp2`[*](https://packages.debian.org/buster-backports/libseccomp2) to >=2.4.4 and restart the container. (Source: [1](https://docs.linuxserver.io/faq#libseccomp), [2](https://github.com/owncloud/docs/pull/3196#issue-577993147), [3](https://github.com/moby/moby/issues/40734))  
  
Example (wrong date):
```sh
$ docker run --rm --name testing -it alpine:3.13 date
Sun Jan  0 00:100:4174038  1900
```
  
Solution:
```sh
 sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 04EE7237B7D453EC 648ACFD622F3D138
 echo "deb http://deb.debian.org/debian buster-backports main" | sudo tee -a /etc/apt/sources.list.d/buster-backports.list
 sudo apt update
 sudo apt install -t buster-backports libseccomp2
```

### This Image on
* [DockerHub](https://hub.docker.com/r/tobi312/rpi-mariadb/)
* [GitHub](https://github.com/Tob1asDocker/rpi-mariadb)
