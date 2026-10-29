# docker-bolt-cms

Docker image for **Bolt CMS**, an open source Content Management Tool which strives to be as simple and straightforward as possible (<https://boltcms.io/>).

This image sets up a **development** environment based on Debian Linux, Apache 2 and PHP 8.4 (with `php.ini-development` and Symfony's `dev` environment, so errors and the debug toolbar are displayed). It should **NEVER** be used in production.

## How to use this image

This will start a Bolt CMS instance listening on port 80:

```bash
~ docker run -d -p 80:80 --name bolt mablanco/bolt-cms
```

Now you can open <http://localhost/bolt> in your browser to access the Bolt dashboard and start tinkering with it. Use `bolt_admin` and `Secret@1` as credentials. The site comes with Bolt's demo content and demo users.

In case you want to add persistance, create several volumes for that purpose:

```bash
~ docker volume create bolt_db
~ docker volume create bolt_files
~ docker volume create bolt_config
~ docker run -d -p 80:80 --name bolt -v bolt_db:/var/www/html/var/data -v bolt_files:/var/www/html/public/files -v bolt_config:/var/www/html/config mablanco/bolt-cms
```

## Upgrading from Bolt 5

Image tags up to `5.2.0` ship Bolt 5 and serve it with Symfony's built-in server on port 8000. Newer tags ship Bolt 6 served by Apache on port 80, so change `-p 8000:8000` to `-p 80:80` (or `-p 8000:80` to keep the old address). Volumes created with Bolt 5 are not migrated automatically: back them up first and follow the upgrade instructions in the [Bolt documentation](https://docs.boltcms.io/).

## Notes

- This image uses SQLite by default. MySQL support is included although you'll have to deploy your own DB instances and set up Bolt to use it.
- `APP_SECRET` is generated when the image is built, so every container started from the same image shares it.
- Composer, `git` and `unzip` are included, so you can install Bolt extensions with `composer require` inside the container.
- Please be aware that extensions are installed by Composer in the same directory (`/vendor`) as the rest of Bolt's components, so persisiting it could potentially lead to conflicts and issues. Therefore I'm not adding that directory to the example above.

## Building the image

```bash
~ docker build -t mablanco/bolt-cms .
```

The Bolt version is set with the `BOLT_CORE_VERSION` build argument (the `bolt/core` package). `BOLT_PROJECT_VERSION` sets the `bolt/project` skeleton the site is created from.
