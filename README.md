# MariaDB on Raspberry Pi / ARM

### Supported tags and respective `Dockerfile` links
-	[`10.5` (*Dockerfile*)](https://github.com/Tob1asDocker/rpi-mariadb/blob/master/bullseye.armhf.10_5.Dockerfile) (on Debian 11 Bullseye)
-	[`10.3` (*Dockerfile*)](https://github.com/Tob1asDocker/rpi-mariadb/blob/master/buster.armhf.10_3.Dockerfile) (on Debian 10 Buster)
-	[`10.1` (*Dockerfile*)](https://github.com/Tob1asDocker/rpi-mariadb/blob/master/stretch.armhf.10_1.Dockerfile) (on Debian 9 Stretch) (*)

-	[`10.5-ubuntu` (*Dockerfile*)](https://github.com/Tob1asDocker/rpi-mariadb/blob/master/ubuntu.armhf.10_5.Dockerfile) (on [Ubuntu](https://packages.ubuntu.com/search?arch=armhf&searchon=names&keywords=mariadb-server-10.5) 21.04 Hirsute Hippo)
-	[`10.3-ubuntu` (*Dockerfile*)](https://github.com/Tob1asDocker/rpi-mariadb/blob/master/ubuntu.armhf.10_3.Dockerfile) (on [Ubuntu](https://packages.ubuntu.com/search?arch=armhf&searchon=names&keywords=mariadb-server-10.3) 20.04 LTS Focal Fossa)
-	[`10.1-ubuntu` (*Dockerfile*)](https://github.com/Tob1asDocker/rpi-mariadb/blob/master/ubuntu.armhf.10_1.Dockerfile) (on [Ubuntu](https://packages.ubuntu.com/search?arch=armhf&searchon=names&keywords=mariadb-server-10.1) 18.04 LTS Bionic Beaver)

-	[`10.6-alpine` (*Dockerfile*)](https://github.com/Tob1asDocker/rpi-mariadb/blob/master/alpine.armhf.10_6.Dockerfile) (on [AlpineLinux](https://pkgs.alpinelinux.org/package/edge/main/armhf/mariadb) edge) (**unstable**)
-	[`10.5-alpine` (*Dockerfile*)](https://github.com/Tob1asDocker/rpi-mariadb/blob/master/alpine.armhf.10_5.Dockerfile) (on [AlpineLinux](https://pkgs.alpinelinux.org/package/v3.13/main/armhf/mariadb) 3.14)
-	[`10.4-alpine` (*Dockerfile*)](https://github.com/Tob1asDocker/rpi-mariadb/blob/master/alpine.armhf.10_4.Dockerfile) (on [AlpineLinux](https://pkgs.alpinelinux.org/package/v3.12/main/armhf/mariadb) 3.12)
-	[`10.3-alpine` (*Dockerfile*)](https://github.com/Tob1asDocker/rpi-mariadb/blob/master/alpine.armhf.10_3.Dockerfile) (on [AlpineLinux](https://pkgs.alpinelinux.org/package/v3.10/main/armhf/mariadb) 3.10) (*)
-	[`10.2-alpine` (*Dockerfile*)](https://github.com/Tob1asDocker/rpi-mariadb/blob/master/alpine.armhf.10_2.Dockerfile) (on [AlpineLinux](https://pkgs.alpinelinux.org/package/v3.8/main/armhf/mariadb) 3.8 (*)
-	[`10.1-alpine` (*Dockerfile*)](https://github.com/Tob1asDocker/rpi-mariadb/blob/master/alpine.armhf.10_1.Dockerfile) (on [AlpineLinux](https://pkgs.alpinelinux.org/package/v3.7/main/armhf/mariadb) 3.7 (*)
  
(*) = productive use not recommended, OS Version is [End of Life](https://endoflife.date)!

# What is MariaDB?

MariaDB Server is one of the most popular database servers in the world. It’s made by the original developers of MySQL and guaranteed to stay open source. Notable users include Wikipedia, DBS Bank and ServiceNow.

The intent is also to maintain high compatibility with MySQL, ensuring a library binary equivalency and exact matching with MySQL APIs and commands. MariaDB developers continue to develop new features and improve performance to better serve its users.

> [wikipedia.org/wiki/MariaDB](https://en.wikipedia.org/wiki/MariaDB)

![logo](https://raw.githubusercontent.com/docker-library/docs/master/mariadb/logo.png)

### About these images:
* a port of the official [MariaDB](https://hub.docker.com/_/mariadb)-Image ([GitHub](https://github.com/docker-library/mariadb/tree/master)).
* based on official Images: [arm32v7/debian](https://hub.docker.com/r/arm32v7/debian/), [arm32v7/alpine](https://hub.docker.com/r/arm32v7/alpine/) or [arm32v7/ubuntu](https://hub.docker.com/r/arm32v7/ubuntu/).  
(Alpine Version 3.7 and 3.8 Images are based on [balenalib/armv7hf-alpine](https://hub.docker.com/r/balenalib/armv7hf-alpine).)
* build on Docker Hub with Autobuild, for example and more details see in this [repository](https://github.com/Tob1asDocker/dockerhubhooksexample).

### How to use these images:

* ``` $ docker run --name some-mariadb -v $(pwd)/mariadb:/var/lib/mysql -p 3306:3306  -e MARIADB_ROOT_PASSWORD=my-secret-pw -d tobi312/rpi-mariadb:TAG ```
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
      #MARIADB_RANDOM_ROOT_PASSWORD: "yes"
      MARIADB_ROOT_PASSWORD: my-secret-pw
      MARIADB_DATABASE: user
      MARIADB_USER: user
      MARIADB_PASSWORD: my-secret-pw
    ports:
      - 3306:3306
    healthcheck:
      test:  mysqladmin ping -h 127.0.0.1 -u root --password=$$MARIADB_ROOT_PASSWORD || exit 1
      #test:  mysqladmin ping -h 127.0.0.1 -u $$MARIADB_USER --password=$$MARIADB_PASSWORD || exit 1
      interval: 60s
      timeout: 5s
      retries: 5
      #start_period: 30s
```

#### Troubleshooting

<details>
<summary>If your container fails to start with Images that based on Alpine 3.13 or newer Debian/Ubuntu on ARM devices...</summary>
<p>

... with Raspbian/Debian 10 Buster (32 bit) then update `libseccomp2`[*](https://packages.debian.org/buster-backports/libseccomp2) to >=2.4.4 and restart the container. (Source: [1](https://docs.linuxserver.io/faq#libseccomp), [2](https://github.com/owncloud/docs/pull/3196#issue-577993147), [3](https://github.com/moby/moby/issues/40734))  
  
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
 # optional: delete backports list
 sudo rm /etc/apt/sources.list.d/buster-backports.list
```
</p>
</details>

### This Image on
* [DockerHub](https://hub.docker.com/r/tobi312/rpi-mariadb/)
* [GitHub](https://github.com/Tob1asDocker/rpi-mariadb)
