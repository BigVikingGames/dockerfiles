bigvikinggames/minio
--


## Server

Start a minio server.

```
$ docker run -d -p 9000:9000 --name minio bigvikinggames/minio
```

Review logs for generated access key and secret.

```
$ docker logs minio
```

Bring your own access tokens.

```
$ docker run -d -p 9000:9000 -e MINIO_ACCESS_KEY=your-access-key -e MINIO_SECRET_KEY=your-secret-key bigvikinggames/minio
```

Modify caching configuration.

```
$ docker run -d -p 9000:9000 -e MINIO_CACHE_SIZE=1GB -e MINIO_CACHE_EXPIRY=12h bigvikinggames/minio
```

## Client

This image also contains the minio client `mc` and can easily be used for client operations.

```
$ docker run -it --link minio:minio bigvikinggames/minio bash
$ mc config host add myminio http://minio:9000 12345678 12345678
$ mc ls myminio
```

You could also use this image to generate a local configuration file that you can reuse.

```
$ docker run -it -v $HOME/.mc:/root/.mc bigvikinggames/minio \
  mc config host add myminio https://minio.mydomain.com 12345678 12345678
```

Now reuse that configuration to perform actions.

```
$ docker run -it -v $HOME/.mc:/root/.mc -v $HOME/Photos:/Photos mc mirror /Photos myminio/photos
```

