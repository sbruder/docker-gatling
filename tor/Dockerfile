FROM alpine as builder

RUN apk add --no-cache \
        autoconf \
        automake \
        build-base \
        git \
        libressl-dev \
        libtool \
        zlib-dev

RUN git clone --depth=1 https://github.com/libevent/libevent libevent \
    && cd libevent \
    && ./autogen.sh \
    && ./configure \
    && make -j 4 \
    && make install

RUN git clone --depth=1 https://git.torproject.org/tor.git tor \
    && cd tor \
    && ./autogen.sh \
    && ./configure \
        --enable-static-tor \
        --with-libevent-dir=/usr/local/lib \
        --with-openssl-dir=/usr/lib \
        --with-zlib-dir=/lib \
        --disable-asciidoc \
    && make -j 4 \
    && strip src/app/tor

FROM busybox

COPY --from=sbruder/gatling /gatling /usr/bin/gatling
COPY --from=builder /tor/src/app/tor /usr/bin/tor

COPY torrc /etc/tor/torrc
COPY entrypoint.sh /entrypoint.sh

RUN chown -R 100 /etc/tor \
    && mkdir -p /var/lib/tor \
    && chown -R 100 /var/lib/tor \
    && mkdir -p /srv/www \
    && chmod o-r /srv

WORKDIR /srv/www

USER 100
ENTRYPOINT ["/entrypoint.sh"]
