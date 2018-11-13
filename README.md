# docker-bolt-cms
Docker image for Bolt CMS, an open source Content Management Tool, which strives to be as simple and straightforward as possible (https://bolt.cm/).

This image sets up a development environment and relies on Debian Linux, Apache 2 and PHP7.

## How to use this image

This will start a Bolt CMS instance listening on port 80:

```
$ docker run -d -p 80:80 --name bolt mablanco/bolt-cms
```

If you'd like persistance, create three volumes for that purpose:

```
$ docker volume create bolt_db
$ docker volume create bolt_files
$ docker volume create bolt_ext
$ docker run -d -p 80:80 --name bolt -v bolt_db:/var/www/html/app/database -v bolt_files:/var/www/html/public/files -v bolt_ext:/var/www/html/extensions mablanco/bolt-cms
```
