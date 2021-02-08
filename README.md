# docker-bolt-cms
Docker image for **Bolt CMS**, an open source Content Management Tool which strives to be as simple and straightforward as possible (<https://bolt.cm/>).

This image sets up a **development** environment and relies on Debian Linux, Apache 2 and PHP7. It should **NEVER** be used in production.

## Bolt 3 vs Bolt 4
You can find two Dockefiles in this repo, one for Bolt 3 (installed from a tar package) and Bolt 4 (installed through Composer). For the time being, I'm keeping both versions so people using the former can still count on a Docker image, while people desiring to work with the latter can already have a try and start developing with it. In both cases, Bolt uses a **SQLite database** by default.

From now on, the `latest` tag points to the newest Bolt 4 image.

## How to use the Bolt 3 image
This will start a Bolt CMS instance listening on port 80:

```
$ docker run -d -p 80:80 --name bolt mablanco/bolt-cms:<v3-tag>
```

If you'd like persistance, create several volumes for that purpose:

```
$ docker volume create bolt_db
$ docker volume create bolt_files
$ docker volume create bolt_config
$ docker volume create bolt_ext
$ docker run -d -p 80:80 --name bolt -v bolt_db:/var/www/html/app/database -v bolt_files:/var/www/html/public/files -v bolt_config:/var/www/html/app/config -v bolt_ext:/var/www/html/extensions mablanco/bolt-cms
```

Now you can open your browser and go to <http://localhost/bolt> to access the first-time wizard to setup your Bolt instance. 

## How to use Bolt 4 image
This will start a Bolt CMS instance listening on port 80:

```
$ docker run -d -p 80:80 --name bolt mablanco/bolt-cms:<v4-tag>
```

Now you can open your browser and go to <http://localhost/bolt> to access Bolt dashoard and start tinkering with it. Use `admin` and `secret` as credentials.

If you'd like persistance, create several volumes for that purpose:

```
$ docker volume create bolt_db
$ docker volume create bolt_files
$ docker volume create bolt_config
$ docker run -d -p 80:80 --name bolt -v bolt_db:/var/www/html/var/data -v bolt_files:/var/www/html/public/files -v bolt_config:/var/www/html/app/config mablanco/bolt-cms
```

Please be aware that, in Bolt 4, extensions are installed by Composer in the same directory (`/vendor`) as the rest of Bolt's components, so persisiting it could potentially lead to conflicts and issues. Therefore I'm not adding that directory to the example above.
