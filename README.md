# docker-bolt-cms

Docker image for **Bolt CMS**, an open source Content Management Tool which strives to be as simple and straightforward as possible (<https://bolt.cm/>).

This image sets up a **development** environment based on Debian Linux and PHP 8. It should **NEVER** be used in production.

## How to use this image

This will start a Bolt CMS instance listening on port 8000:

```bash
~ docker run -d -p 8000:8000 --name bolt mablanco/bolt-cms
```

Now you can open <http://localhost:8000/bolt> in your browser to access Bolt dashoard and start tinkering with it. Use `bolt_admin` and `Secret@1` as credentials.

In case you want to add persistance, create several volumes for that purpose:

```bash
~ docker volume create bolt_db
~ docker volume create bolt_files
~ docker volume create bolt_config
~ docker run -d -p 8000:8000 --name bolt -v bolt_db:/var/www/html/var/data -v bolt_files:/var/www/html/public/files -v bolt_config:/var/www/html/app/config mablanco/bolt-cms
```

## Notes

- Bolt 5 supports up to PHP 8.1
- This image uses SQLite by default. MySQL support is included although you'll have to deploy your own DB instances and set up Bolt to use it.
- Please be aware that extensions are installed by Composer in the same directory (`/vendor`) as the rest of Bolt's components, so persisiting it could potentially lead to conflicts and issues. Therefore I'm not adding that directory to the example above.
