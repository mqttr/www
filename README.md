# Main Site

My primary personal site.

## Development

Use either:

```shell
DEBUG=true py manage.py tailwind dev
```
Or, the **much** slower option (but dependencies are handled for you):
```shell
DEBUG=true docker compose up -d --build
```

> [!NOTE]
> If you do not pass in `DEBUG=true` **and** `DOMAIN` is not defined,
> the website **will** return a 400 as `ALLOWED_HOSTS` will not contain the Docker IP address

