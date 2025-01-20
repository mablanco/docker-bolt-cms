# docker-bolt-cms

Docker image for **Bolt CMS**, an open source Content Management Tool which strives to be as simple and straightforward as possible (<https://bolt.cm/>).

This image sets up a **development** environment and relies on Debian Linux, Apache 2 and PHP8. It should **NEVER** be used in production.

## How to use this image

This will start a Bolt CMS instance listening on port 80:

```bash
~ docker run -d -p 80:80 --name bolt mablanco/bolt-cms
```

Now you can open your browser and go to <http://localhost/bolt> to access Bolt dashoard and start tinkering with it. Use `admin` and `Secret@1` as credentials.

If you'd like persistance, create several volumes for that purpose:

```bash
~ docker volume create bolt_db
~ docker volume create bolt_files
~ docker volume create bolt_config
~ docker run -d -p 80:80 --name bolt -v bolt_db:/var/www/html/var/data -v bolt_files:/var/www/html/public/files -v bolt_config:/var/www/html/app/config mablanco/bolt-cms
```

## Notes

- Bolt 5 supports up to PHP 8.1
- Please be aware that extensions are installed by Composer in the same directory (`/vendor`) as the rest of Bolt's components, so persisiting it could potentially lead to conflicts and issues. Therefore I'm not adding that directory to the example above.
