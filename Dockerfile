FROM alpine as builder
RUN apk add --no-cache \
    build-base \
    cvs \
    git \
    libcap-dev \
    libressl-dev \
    zlib-dev

RUN git clone --depth=1 https://github.com/ARMmbed/mbedtls mbedtls \
    && cd mbedtls \
    && make -j 4 install

RUN cvs -d :pserver:cvs@cvs.fefe.de:/cvs -z9 co libowfat \
    && cd libowfat \
    && make -j 4 \
    && make install

RUN cvs -d :pserver:cvs@cvs.fefe.de:/cvs -z9 co gatling \
    && cd gatling \
    && make -j 4 \
        gatling \
        ptlsgatling \
        LDFLAGS="-s -L../libowfat/ -lowfat -L/usr/lib/ -lmbedtls -lmbedx509 -lmbedcrypto -static"

FROM scratch
COPY --from=builder /gatling/gatling /gatling
COPY --from=builder /gatling/ptlsgatling /ptlsgatling

WORKDIR /var/www

ENTRYPOINT ["/ptlsgatling"]

EXPOSE 21 80 443 445
