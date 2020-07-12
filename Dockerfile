FROM alpine as builder

RUN apk add --no-cache \
    build-base \
    cvs \
    git \
    libcap-dev \
    libowfat-dev \
    libressl-dev \
    mbedtls-dev \
    mbedtls-static \
    zlib-dev \
    zlib-static

RUN cvs -d :pserver:cvs@cvs.fefe.de:/cvs co gatling \
    && cd gatling \
    && make -j 4 \
        bench \
        dl \
        gatling \
        ptlsgatling \
        LDFLAGS="-s -L../libowfat/ -lowfat -L/usr/lib/ -lmbedtls -lmbedx509 -lmbedcrypto -static"

FROM alpine

RUN apk add --no-cache tini

COPY --from=builder /gatling/bench /usr/local/bin/bench
COPY --from=builder /gatling/dl /usr/local/bin/dl
COPY --from=builder /gatling/gatling /usr/local/bin/gatling
COPY --from=builder /gatling/ptlsgatling /usr/local/bin/ptlsgatling

WORKDIR /srv/www

ENTRYPOINT ["tini", "--", "ptlsgatling"]

EXPOSE 21 80 443 445
