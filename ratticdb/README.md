# docker-ratticdb

[RatticDB](http://rattic.org/) for Docker.

This image requires a PostgreSQL server for the database, but it could easily be reconfigured or adapted for any database supported by Rattic. The easiest way to get started is simply to use a linked postgresql container.

Use the provided `fig.yml` for an example deployment. If you're running boot2docker, or any remote Docker host, you will need to add the `SITE_NAME` environment variable to the rattic container and point it at your Docker host.

**NOTE:** In the case of this example Rattic is using the postgres user and postgres database.

```
fig up
```

Once running you can login to the `admin` account using the password `ratticdb`.

## Building Image

```
docker build -t bigvikinggames/ratticdb ./
```

Or simply use the provided `Makefile`.

