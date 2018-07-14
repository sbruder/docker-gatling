[![](https://images.microbadger.com/badges/image/sbruder/docker-gatling.svg)](https://microbadger.com/images/sbruder/docker-gatling "Get your own image badge on microbadger.com")

# docker-gatling

Dockerized [gatling](https://www.fefe.de/gatling/) (high performance HTTP(S),
FTP and SMB server).

## How to use

It is highly recommended to specify a userid the server should use (after
binding to the ports). Make sure a user with this UID has access to the files
you want to serve.

For example if you want to serve the directory `/path/to/files` and use the UID
`1000` you can use it like this:


```
docker run -v /path/to/files:/var/www --rm sbruder/gatling -u 1000
```

The default entrypoint is `/ptlsgatling` (gatling with polarssl/mbedtls). If
you want to use a binary without tls support, you can set the entrypoint to
`/gatling`.

For more options, please take a look at the
[manpage](https://manpages.debian.org/stretch/gatling/gatling.1.en.html).
